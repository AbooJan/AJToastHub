//
//  AJWindow.h
//  AJToastHub
//
//  Created by 钟宝健 on 15/11/27.
//  Copyright © 2015年 钟宝健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJToastViewController.h"

@interface AJToast : UIWindow

+(AJToast *)sharedInstance;

- (void)dismiss;

//===========Toast===========

- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)dismissTime;

- (void)showMessage:(NSString *)message position:(ToastPosition)position;
- (void)showMessage:(NSString *)message position:(ToastPosition)position afterDelay:(NSTimeInterval)dismissTime;


//===========Hub=============
- (void)showHub:(NSString *)message;

@end
