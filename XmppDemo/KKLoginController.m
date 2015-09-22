//
//  KKLoginController.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKLoginController.h"
#import "Statics.h"

@interface KKLoginController ()

@end

@implementation KKLoginController
@synthesize userTextField;
@synthesize passTextField;
@synthesize serverTextField;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setUserTextField:nil];
    [self setPassTextField:nil];
    [self setServerTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//click return button,then keyboard disappear
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    //当用户按下ruturn，把焦点从textField移开那么键盘就会消失了
    
    [textField resignFirstResponder];
    
    return YES;
    
}
//click the space screen,then keyboard disappear
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.userTextField resignFirstResponder];
    [self.passTextField resignFirstResponder];
    [self.serverTextField resignFirstResponder];

}
- (IBAction)LoginButton:(id)sender {
    
    if ([self validateWithUser:userTextField.text andPass:passTextField.text andServer:serverTextField.text]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.userTextField.text forKey:USERID];
        [defaults setObject:self.passTextField.text forKey:PASS];
        [defaults setObject:self.serverTextField.text forKey:SERVER];
        //保存
        [defaults synchronize];
        
        [self dismissModalViewControllerAnimated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名，密码和服务器" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (IBAction)closeButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)validateWithUser:(NSString *)userText andPass:(NSString *)passText andServer:(NSString *)serverText{
    
    if (userText.length > 0 && passText.length > 0 && serverText.length > 0) {
        return YES;
    }
    
    return NO;
}
@end
