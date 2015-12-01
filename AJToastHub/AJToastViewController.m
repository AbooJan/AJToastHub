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
#define kDefaultCenter  CGPointMake(kScreenWidth / 2.0, kScreenHeight - 100.0 - DEFAULT_TOAST_HEIGHT)
#define kBgColor        [UIColor colorWithWhite:0.200 alpha:1.000]


static const CGFloat DEFAULT_TOAST_HEIGHT = 35.0;
static const CGFloat DEFAULT_TOAST_WIDTH  = 50.0;
static const CGFloat TOAST_MAX_WIDTH      = 300.0;
static const CGFloat TOAST_SPACE_WIDTH    = 8.0;

static const CGFloat DEFAUTL_HUB_HEIGHT   = 100.0;
static const CGFloat DEFAULT_HUB_WIDTH    = 100.0;

static const CGFloat DEFAULT_ALPHA  = 0.7;


@interface AJToastViewController ()

@property (nonatomic, strong) UIView *toastContainView;
@property (nonatomic, strong) UILabel *toastMessageLabel;

@property (nonatomic, strong) UIView *hubContainView;
@property (nonatomic, strong) UILabel *hubMessageLabel;

@end

@implementation AJToastViewController

#pragma mark - 初始化

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

    [self setupToastView];
    [self setupHubView];
}

- (void)setupToastView
{
    // 视图容器
    self.toastContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_TOAST_WIDTH, DEFAULT_TOAST_HEIGHT)];
    self.toastContainView.center = kDefaultCenter;
    self.toastContainView.backgroundColor = kBgColor;
    self.toastContainView.alpha = 0.0;
    self.toastContainView.layer.cornerRadius = 5.0;
    self.toastContainView.layer.masksToBounds = YES;
    [self.view addSubview:self.toastContainView];
    
    // 消息
    CGFloat messageLabelWidth = DEFAULT_TOAST_WIDTH - TOAST_SPACE_WIDTH * 2.0;
    CGFloat messageLabelHeight = DEFAULT_TOAST_HEIGHT - TOAST_SPACE_WIDTH * 2.0;
    self.toastMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOAST_SPACE_WIDTH, TOAST_SPACE_WIDTH, messageLabelWidth, messageLabelHeight)];
    self.toastMessageLabel.textColor = [UIColor whiteColor];
    self.toastMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.toastMessageLabel.font = kMessageFont;
    self.toastMessageLabel.numberOfLines = 0;
    [self.toastContainView addSubview:self.toastMessageLabel];
}

- (void)setupHubView
{
    // 视图容器
//    self.hubContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_HUB_WIDTH, DEFAUTL_HUB_HEIGHT)];
//    self.hubContainView.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight / 2.0);
//    self.hubContainView
    
    // 菊花
    
    
    // 消息
}

#pragma mark - 逻辑处理

- (void)refreshViewFrameWithMessage
{
    // 先宽高计算
    CGFloat contentWidth = [_messageStr widthWithFont:kMessageFont constrainedToHeight:DEFAULT_TOAST_HEIGHT - TOAST_SPACE_WIDTH * 2.0];
    
    CGFloat maxContentWidth = TOAST_MAX_WIDTH - TOAST_SPACE_WIDTH * 2.0;
    if (contentWidth > maxContentWidth) {
        
        CGFloat contentHeight = [_messageStr heightWithFont:kMessageFont constrainedToWidth:maxContentWidth];
        
        // 调整父视图大小
        self.toastContainView.width = TOAST_MAX_WIDTH;
        self.toastContainView.height = contentHeight + TOAST_SPACE_WIDTH * 2.0;
        
        // 调整消息大小
        self.toastMessageLabel.width = maxContentWidth;
        self.toastMessageLabel.height = contentHeight;
        
    }else{
        
        self.toastContainView.width = contentWidth + TOAST_SPACE_WIDTH * 2.0;
        self.toastMessageLabel.width = contentWidth;
    }
    
    // 调整内容视图中点
    self.toastContainView.center = kDefaultCenter;
}

#pragma mark - SET方法重写
- (void)setMessageStr:(NSString *)messageStr
{
    _messageStr = messageStr;
    
    self.toastMessageLabel.text = _messageStr;
    
    [self refreshViewFrameWithMessage];
}

#pragma mark - Toast

#pragma mark 显示隐藏
- (void)showToast:(void (^)())finished
{
    
    // 初始化弹窗中点
    self.toastContainView.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight + self.toastContainView.height);
    if (self.toastPosition == ToastPositionTop) {
        self.toastContainView.center = CGPointMake(kScreenWidth / 2.0, - self.toastContainView.height);
    }
    
    // 目标中点Y坐标
    CGFloat spaceWidth = 80.0;
    CGFloat targetY;
    switch (self.toastPosition) {
        case ToastPositionBottom: {
            targetY = kScreenHeight - spaceWidth - self.toastContainView.height / 2.0;
            break;
        }
        case ToastPositionCenter: {
            targetY = kScreenHeight / 2.0;
            break;
        }
        case ToastPositionTop: {
            targetY = spaceWidth + self.toastContainView.height / 2.0;
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
    
    [self.toastContainView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation1"];
    //    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.toastContainView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation1"];
    
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
        finished();
    }];
}

- (void)dismissToast:(void (^)())finished
{
    // 设置消失时的Y坐标
    CGFloat animationPositionY = kScreenHeight + self.toastContainView.height;
    
    if(self.toastPosition == ToastPositionTop){
        animationPositionY = - self.toastContainView.height;
    }
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(animationPositionY);
    [offscreenAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        finished();
    }];
    
    [self.toastContainView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation2"];
    [self.toastContainView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation2"];
    
}


#pragma mark - Hub

- (void)showHub:(void (^)())finished
{
    //
}

- (void)dismissHub:(void (^)())finished
{
    //
}

@end
