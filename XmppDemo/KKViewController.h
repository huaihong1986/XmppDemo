//
//  KKViewController.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKChatDelegate.h"

@interface KKViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,KKChatDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tView;

- (IBAction)Account:(id)sender;
@end
