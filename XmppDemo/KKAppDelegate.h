//
//  KKAppDelegate.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

@interface KKAppDelegate : UIResponder <UIApplicationDelegate>{
    
    XMPPStream *xmppStream;
    NSString *password;  //密码
    BOOL isOpen;  //xmppStream是否开着

}

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, readonly)XMPPStream *xmppStream;

@property(nonatomic, retain)id chatDelegate;
@property(nonatomic, retain)id messageDelegate;

//是否连接
-(BOOL)connect;
//断开连接
-(void)disconnect;

//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;

@end
