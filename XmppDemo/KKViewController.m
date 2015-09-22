//
//  KKViewController.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKViewController.h"
#import "KKAppDelegate.h"
#import "KKChatController.h"

@interface KKViewController (){
    
    //在线用户
    NSMutableArray *onlineUsers;
    
    NSString *chatUserName;
    
}

@end

@implementation KKViewController
@synthesize tView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    onlineUsers = [NSMutableArray array];
    
    //设定在线用户委托
    KKAppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    if (login) {
        
        if ([[self appDelegate] connect]) {
           
            
            
        }
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置账号" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self Account:self];
        
    }
    
    
}

- (void)viewDidUnload
{
    [self setTView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (IBAction)Account:(id)sender {
    
    [self performSegueWithIdentifier:@"login" sender:self];
    
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [onlineUsers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //文本
    cell.textLabel.text = [onlineUsers objectAtIndex:[indexPath row]];
    //标记
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //start a Chat
    chatUserName = (NSString *)[onlineUsers objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"chat" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
if ([segue.identifier isEqualToString:@"chat"]) {
        
      
        KKChatController *chatController = segue.destinationViewController;
        
        chatController.chatWithUser = chatUserName;
    }
}

//取得当前程序的委托
-(KKAppDelegate *)appDelegate{
    
    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    
    if (![onlineUsers containsObject:buddyName]) {
        [onlineUsers addObject:buddyName];
        
        [self.tView reloadData];
    }
    
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    
    [onlineUsers removeObject:buddyName];
    [self.tView reloadData];
    
}


@end
