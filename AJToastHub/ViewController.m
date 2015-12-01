//
//  ViewController.m
//  AJToastHub
//
//  Created by 钟宝健 on 15/11/27.
//  Copyright © 2015年 钟宝健. All rights reserved.
//

#import "ViewController.h"
#import "AJToast.h"

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
    [self showWin];
}

- (void)showWin
{
//    [[AJToast sharedInstance] showMessage:@"网络不给力~"];
    
//    AJToast *toast = [AJToast sharedInstance];
//    [toast showMessage:@"服务器开小差了~" afterDelay:3.0];
    
    
    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-1-" position:ToastPositionBottom afterDelay:2.0];
//    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-2-" position:ToastPositionCenter];
//    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-3-" position:ToastPositionCenter];
//    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-4-" position:ToastPositionCenter];
    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-5-" position:ToastPositionBottom afterDelay:6.0];
    
    [self performSelector:@selector(otherThreadMesaage2) withObject:nil];
    [self performSelector:@selector(otherThreadMesaage3) withObject:nil];
    [self performSelector:@selector(otherThreadMesaage4) withObject:nil];
}

- (void)otherThreadMesaage2
{
    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-2-" position:ToastPositionBottom];
}

- (void)otherThreadMesaage3
{
    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-3-" position:ToastPositionBottom afterDelay:5.0];
}

- (void)otherThreadMesaage4
{
    [[AJToast sharedInstance] showMessage:@"兼职猫，喵了个咪-4-" position:ToastPositionBottom];
}

- (void)dismissWin
{
    [[AJToast sharedInstance] dismiss];
}


#pragma mark - Hub

- (IBAction)showHub:(id)sender
{
    [[AJToast sharedInstance] showHub:@"正在登录..."];
//    [[AJToast sharedInstance] showHub:@""];
    
    [self performSelector:@selector(otherThreadMesaage2) withObject:nil];
    [self performSelector:@selector(otherThreadMesaage3) withObject:nil];
    
    [self performSelector:@selector(hideHub) withObject:nil afterDelay:6.0];
}

- (IBAction)dismissHub:(id)sender
{
    [self hideHub];
}

- (void)hideHub
{
    [[AJToast sharedInstance] dismiss];
}

@end
