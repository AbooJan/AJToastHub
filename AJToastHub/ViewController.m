//
//  ViewController.m
//  AJToastHub
//
//  Created by 钟宝健 on 15/11/27.
//  Copyright © 2015年 钟宝健. All rights reserved.
//

#import "ViewController.h"
#import "AJToast.h"
#import "AJHub.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.941 alpha:1.000];
}

#pragma mark - Toast

- (IBAction)showToast:(id)sender
{
    [self showToastMessage];
}

- (void)showToastMessage
{
    // 背景可以点击测试
    AJToast *toast = [AJToast shareInstance];
    toast.toastBackgroundCanClick = YES;
    [toast showMessage:@"网络不给力~"];
    
    // 延时显示测试
//    AJToast *toast = [AJToast shareInstance];
//    [toast showMessage:@"服务器开小差了~" afterDelay:3.0];
    
    
    // 多线程显示测试
//    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-1" position:ToastPositionBottom afterDelay:2.0];
//    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-2-" position:ToastPositionCenter];
//    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-3-" position:ToastPositionCenter];
//    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-4-" position:ToastPositionCenter];
//    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-5-" position:ToastPositionBottom afterDelay:6.0];
//
    [self performSelector:@selector(otherThreadMesaage2) withObject:nil];
    [self performSelector:@selector(otherThreadMesaage3) withObject:nil];
    [self performSelector:@selector(otherThreadMesaage4) withObject:nil];
}

- (void)otherThreadMesaage2
{
    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-2-" position:ToastPositionBottom];
}

- (void)otherThreadMesaage3
{
    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-3-" position:ToastPositionBottom afterDelay:5.0];
}

- (void)otherThreadMesaage4
{
    [[AJToast shareInstance] showMessage:@"兼职猫，喵了个咪-4-" position:ToastPositionBottom];
}


#pragma mark - Hub

- (IBAction)showHub:(id)sender
{
    // 有内容加载
//    [[AJHub shareInstance] showHub:@"拼命加载中..."];
//    [self performSelector:@selector(hideHub) withObject:nil afterDelay:6.0];

    // 无内容加载
//    [[AJHub shareInstance] showHub:@""];
//    [self performSelector:@selector(hideHub) withObject:nil afterDelay:6.0];
    
    
    // 可点击测试
    AJHub *hub = [AJHub shareInstance];
    hub.hubBackgroundCanClick = YES;
    [hub showHub:@""];
//    [self performSelector:@selector(hideHub) withObject:nil afterDelay:6.0];
}

- (IBAction)dismissHub:(id)sender
{
    [self hideHub];
}

- (void)hideHub
{
    [[AJHub shareInstance] dismiss];
}

@end
