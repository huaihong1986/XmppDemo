//
//  KKChatController.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMessageDelegate.h"

@interface KKChatController : UIViewController<UITableViewDelegate, UITableViewDataSource,  KKMessageDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property(nonatomic, retain) NSString *chatWithUser;

- (IBAction)sendButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@end
