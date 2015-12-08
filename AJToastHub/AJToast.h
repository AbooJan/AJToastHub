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

/// 显示Toast时背景是否可点击，默认不可点击
@property (nonatomic, assign) BOOL toastBackgroundCanClick;
/// 显示Hub时背景是否可点击，默认不可点击
@property (nonatomic, assign) BOOL hubBackgroundCanClick;


- (void)dismiss;

//===========Toast===========

- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message afterDelay:(NSTimeInterval)dismissTime;

- (void)showMessage:(NSString *)message position:(ToastPosition)position;
- (void)showMessage:(NSString *)message position:(ToastPosition)position afterDelay:(NSTimeInterval)dismissTime;


//===========Hub=============
- (void)showHub:(NSString *)message;

@end
