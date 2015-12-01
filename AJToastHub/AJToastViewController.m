//
//  AJToast.m
//  AJToastHub
//
//  Created by 钟宝健 on 15/11/27.
//  Copyright © 2015年 钟宝健. All rights reserved.
//

#import "AJToastViewController.h"
#import "NSString+Size.h"
#import "UIView+Extend.h"
#import <POP/POP.h>

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kMessageFont    [UIFont systemFontOfSize:13.0]
#define kDefaultCenter  CGPointMake(kScreenWidth / 2.0, kScreenHeight - 100.0 - DEFAULT_HEIGHT)

static const CGFloat DEFAULT_HEIGHT = 35.0;
static const CGFloat DEFAULT_WIDTH  = 50.0;
static const CGFloat MAX_WIDTH      = 300.0;
static const CGFloat SPACE_WIDTH    = 8.0;
static const CGFloat DEFAULT_ALPHA  = 0.7;

@interface AJToastViewController ()
@property (nonatomic, strong) UIView *containView;
@property (nonatomic, strong) UILabel *messageLabel;
@end

@implementation AJToastViewController

#pragma mark - <初始化>

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor clearColor];

    [self setupView];
}

- (void)setupView
{
    
    // 视图容器
    self.containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)];
    self.containView.center = kDefaultCenter;
    self.containView.backgroundColor = [UIColor colorWithWhite:0.200 alpha:1.000];
    self.containView.alpha = 0.0;
    self.containView.layer.cornerRadius = 5.0;
    self.containView.layer.masksToBounds = YES;
    [self.view addSubview:self.containView];
    
    // 消息
    CGFloat messageLabelWidth = DEFAULT_WIDTH - SPACE_WIDTH * 2.0;
    CGFloat messageLabelHeight = DEFAULT_HEIGHT - SPACE_WIDTH * 2.0;
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SPACE_WIDTH, SPACE_WIDTH, messageLabelWidth, messageLabelHeight)];
    self.messageLabel.textColor = [UIColor whiteColor];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = kMessageFont;
    self.messageLabel.numberOfLines = 0;
    [self.containView addSubview:self.messageLabel];
}

#pragma mark - <逻辑处理>

- (void)refreshViewFrameWithMessage
{
    // 先宽高计算
    CGFloat contentWidth = [_messageStr widthWithFont:kMessageFont constrainedToHeight:DEFAULT_HEIGHT - SPACE_WIDTH * 2.0];
    
    CGFloat maxContentWidth = MAX_WIDTH - SPACE_WIDTH * 2.0;
    if (contentWidth > maxContentWidth) {
        
        CGFloat contentHeight = [_messageStr heightWithFont:kMessageFont constrainedToWidth:maxContentWidth];
        
        // 调整父视图大小
        self.containView.width = MAX_WIDTH;
        self.containView.height = contentHeight + SPACE_WIDTH * 2.0;
        
        // 调整消息大小
        self.messageLabel.width = maxContentWidth;
        self.messageLabel.height = contentHeight;
        
    }else{
        
        self.containView.width = contentWidth + SPACE_WIDTH * 2.0;
        self.messageLabel.width = contentWidth;
    }
    
    // 调整内容视图中点
    self.containView.center = kDefaultCenter;
}

#pragma mark - SET方法重写
- (void)setMessageStr:(NSString *)messageStr
{
    _messageStr = messageStr;
    
    self.messageLabel.text = _messageStr;
    
    [self refreshViewFrameWithMessage];
}

#pragma mark 显示隐藏
- (void)show:(void (^)())finished
{
    
    // 初始化弹窗中点
    self.containView.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight + self.containView.height);
    if (self.toastPosition == ToastPositionTop) {
        self.containView.center = CGPointMake(kScreenWidth / 2.0, - self.containView.height);
    }
    
    // 目标中点Y坐标
    CGFloat spaceWidth = 80.0;
    CGFloat targetY;
    switch (self.toastPosition) {
        case ToastPositionBottom: {
            targetY = kScreenHeight - spaceWidth - self.containView.height / 2.0;
            break;
        }
        case ToastPositionCenter: {
            targetY = kScreenHeight / 2.0;
            break;
        }
        case ToastPositionTop: {
            targetY = spaceWidth + self.containView.height / 2.0;
            break;
        }
        default: {
            targetY = kScreenHeight / 2.0;
            break;
        }
    }
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(targetY);
    positionAnimation.springBounciness = 10;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(DEFAULT_ALPHA);
    
    [self.containView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation1"];
    //    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.containView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation1"];
    
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
        finished();
    }];
}

- (void)dismiss:(void (^)())finished
{
    // 设置消失时的Y坐标
    CGFloat animationPositionY = kScreenHeight + self.containView.height;
    
    if(self.toastPosition == ToastPositionTop){
        animationPositionY = - self.containView.height;
    }
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(animationPositionY);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        finished();
    }];
    
    [self.containView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation2"];
    [self.containView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation2"];
    
}

@end
