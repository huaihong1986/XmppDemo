//
//  KKChatController.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKChatController.h"
#import "KKAppDelegate.h"
#import "Statics.h"
#import "KKMessageCell.h"

#define padding 20

@interface KKChatController (){
    
    NSMutableArray *messages;
    
}

@end

@implementation KKChatController
@synthesize tView;
@synthesize messageTextField;
@synthesize chatWithUser;


- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.messageTextField.delegate = self;
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    messages = [NSMutableArray array];
    
    [messageTextField becomeFirstResponder];
    
    KKAppDelegate *del = [self appDelegate];
    del.messageDelegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}
//click return button,then keyboard disappear
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    
    [textField resignFirstResponder];
    
    return YES;
    
}
//click the space screen,then keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.messageTextField resignFirstResponder];
   
    
}
- (void)viewDidUnload
{
    [self setTView:nil];
    [self setMessageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"msgCell";
    
    KKMessageCell *cell =(KKMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[KKMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    
    //发送者
    NSString *sender = [dict objectForKey:@"sender"];
    //消息
    NSString *message = [dict objectForKey:@"msg"];
    //时间
    NSString *time = [dict objectForKey:@"time"];
    
    CGSize textSize = {260.0 ,10000.0};
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.width +=(padding/2);
    
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    
    UIImage *bgImage = nil;
    
    //发送消息
    if ([sender isEqualToString:@"you"]) {
        //背景图
        bgImage = [[UIImage imageNamed:@"BlueBubble2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(padding, padding*1.5, size.width, size.height + padding)];
        
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y + padding/2, size.width + padding, size.height+ padding/2 )];
    }else {
        
        bgImage = [[UIImage imageNamed:@"GreenBubble2.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
        
        [cell.messageContentView setFrame:CGRectMake(320-size.width - padding, padding, size.width, size.height + padding)];
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y + padding/2, size.width + padding, size.height + padding/2)];
    }
    
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];

    return cell;
    
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict  = [messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];
    
    CGSize textSize = {260.0 , 10000.0};
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    
    size.height += padding*2;
    
    CGFloat height = size.height < 65 ? 65 : size.height;
    
    return height;
    
}

- (IBAction)sendButton:(id)sender {
    
    //本地输入框中的信息
    NSString *message = self.messageTextField.text;
    
    if (message.length > 0) {
        
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:chatWithUser];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:USERID]];
        //组合
        [mes addChild:body];
        
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.messageTextField.text = @"";
        [self.messageTextField resignFirstResponder];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        [dictionary setObject:message forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        [dictionary setObject:[Statics getCurrentTime] forKey:@"time"];

        [messages addObject:dictionary];
        
        //重新刷新tableView
        [self.tView reloadData];
        
    }
    
    
}

#pragma mark KKMessageDelegate
-(void)newMessageReceived:(NSDictionary *)messageCotent{
    
    [messages addObject:messageCotent];
    
    [self.tView reloadData];
    
}

- (IBAction)closeButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(KKAppDelegate *)appDelegate{
    
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

@end
