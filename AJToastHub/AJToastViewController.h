//
//  AJToast.h
//  AJToastHub
//
//  Created by 钟宝健 on 15/11/27.
//  Copyright © 2015年 钟宝健. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ToastPosition)
{
    ToastPositionBottom,
    ToastPositionCenter,
    ToastPositionTop
};

typedef NS_ENUM(NSInteger, ToastType)
{
    ToastTypeSimmpleText,    // 纯文字
    ToastTypeHub             // 菊花
};

@class AJToast;

@interface AJToastViewController : UIViewController

@property (nonatomic, weak) AJToast *superWindow;

@property (nonatomic, copy) NSString *messageStr;
@property (nonatomic, assign) ToastType toastType;

//=======Toast=========
@property (nonatomic, assign) ToastPosition toastPosition;

- (void)showToast:(void(^)())finished;
- (void)dismissToast:(void(^)())finished;

//=======Hub==========
- (void)showHub:(void(^)())finished;
- (void)dismissHub:(void(^)())finished;

@end
