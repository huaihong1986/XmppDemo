//
//  KKAppDelegate.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKAppDelegate.h"
#import "Statics.h"
#import "KKChatDelegate.h"
#import "KKMessageDelegate.h"

@implementation KKAppDelegate

@synthesize window = _window;
@synthesize xmppStream;
@synthesize chatDelegate;
@synthesize messageDelegate;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    return YES;
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self disconnect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self connect];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setupStream{
    
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    
}

-(void)goOnline{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
}

-(void)goOffline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

-(BOOL)connect{
    
    [self setupStream];
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASS];
    NSString *server = [defaults stringForKey:SERVER];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (userId == nil || pass == nil) {
        return NO;
    }
    
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    //设置服务器
    [xmppStream setHostName:server];
    //密码
    password = pass;
    
    //连接服务器
    NSError *error = nil;
    if (![xmppStream connect:&error]) {
        NSLog(@"can't connect %@", server);
        return NO;
    }
   
    return YES;

}

-(void)disconnect{
    
    [self goOffline];
    [xmppStream disconnect];
    
}

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    isOpen = YES;
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:password error:&error];
    
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [self goOnline];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    if (!msg)
        return;
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    //消息接收到的时间
    [dict setObject:[Statics getCurrentTime] forKey:@"time"];
    
    //消息委托(这个后面讲)
    [messageDelegate newMessageReceived:dict];
    
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    

    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
   
    if ([presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        
        if ([presenceType isEqualToString:@"available"]) {
          
            //用户列表委托(后面讲)
            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"humatomac-mini.local"]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"humatomac-mini.local"]];
        }
        
    }

}

@end
