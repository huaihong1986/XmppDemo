//
//  KKLoginController.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKLoginController : UITableViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@property (strong, nonatomic) IBOutlet UITextField *serverTextField;
- (IBAction)LoginButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@end
