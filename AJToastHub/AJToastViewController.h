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


@interface AJToastViewController : UIViewController
@property (nonatomic, copy) NSString *messageStr;

@property (nonatomic, assign) ToastPosition toastPosition;

- (void)show:(void(^)())finished;
- (void)dismiss:(void(^)())finished;

@end
