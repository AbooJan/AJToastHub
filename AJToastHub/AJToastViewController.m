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

static const CGFloat DEFAUTL_HUB_HEIGHT   = 80.0;
static const CGFloat DEFAULT_HUB_WIDTH    = 80.0;
static const CGFloat DEFAULT_HUB_MESSAGE_HEIGHT = 20.0;

static const CGFloat DEFAULT_ALPHA  = 0.7;


@interface AJToastViewController ()

@property (nonatomic, strong) UIView *toastContainView;
@property (nonatomic, strong) UILabel *toastMessageLabel;

@property (nonatomic, strong) UIView *hubContainView;

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
    self.hubContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_HUB_WIDTH, DEFAUTL_HUB_HEIGHT)];
    self.hubContainView.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight / 2.0);
    self.hubContainView.backgroundColor = kBgColor;
    self.hubContainView.alpha = 0.0;
    self.hubContainView.layer.cornerRadius = 5.0;
    self.hubContainView.layer.masksToBounds = YES;
    
    // 菊花
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.bounds = CGRectMake(0, 0, 50.0, 50.0);
    loadingView.center = CGPointMake(DEFAULT_HUB_WIDTH / 2.0, DEFAUTL_HUB_HEIGHT / 2.0 - DEFAULT_HUB_MESSAGE_HEIGHT / 2.0);
    loadingView.tag = 1001;
    [loadingView startAnimating];
    [self.hubContainView addSubview:loadingView];
    
    // 消息
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_HUB_WIDTH - TOAST_SPACE_WIDTH * 2.0, DEFAULT_HUB_MESSAGE_HEIGHT)];
    messageLabel.center = CGPointMake(DEFAULT_HUB_WIDTH / 2.0, CGRectGetMaxY(loadingView.frame) + TOAST_SPACE_WIDTH / 2.0);
    messageLabel.font = [UIFont systemFontOfSize:12.0];
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.tag = 1002;
    [self.hubContainView addSubview:messageLabel];
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
    // 添加到视图中
    [self.view addSubview:self.toastContainView];
    
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
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(DEFAULT_ALPHA);
    
    [self.toastContainView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation1"];
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

    
    [self.toastContainView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation2"];
    [self.toastContainView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation2"];
    
    // 完成回调
    __weak __typeof(&*self) weakSelf = self;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        [weakSelf.toastContainView removeFromSuperview];
        finished();
    }];
}


#pragma mark - Hub

- (void)refreshHubView
{
    if (self.messageStr == nil || [self.messageStr isEqualToString:@""]) {
        
        self.hubContainView.width = DEFAULT_HUB_WIDTH - 20.0;
        self.hubContainView.height = DEFAUTL_HUB_HEIGHT - 20.0;
        
        UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[self.hubContainView viewWithTag:1001];
        loadingView.center = CGPointMake(self.hubContainView.width  / 2.0, self.hubContainView.height  / 2.0);
        
    }else{
        
        UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[self.hubContainView viewWithTag:1001];
        loadingView.center = CGPointMake(loadingView.center.x, DEFAUTL_HUB_HEIGHT / 2.0 - DEFAULT_HUB_MESSAGE_HEIGHT / 2.0);
        
        self.hubContainView.width = DEFAULT_HUB_WIDTH;
        self.hubContainView.height = DEFAUTL_HUB_HEIGHT;
    }
}

- (void)showHub:(void (^)())finished
{
    // 添加到View中
    [self.view addSubview:self.hubContainView];
    
    // 设置数据
    UILabel *messageLabel = (UILabel *)[self.hubContainView viewWithTag:1002];
    messageLabel.text = self.messageStr;
    
    // 调整菊花中点
    [self refreshHubView];
    
    // --- 动画 ---
    // 初始化弹窗中点
    self.hubContainView.center = CGPointMake(kScreenWidth / 2.0, kScreenHeight + self.hubContainView.height);
    
    // 目标中点Y坐标
    CGFloat targetY = kScreenHeight / 2.0;
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(targetY);
    positionAnimation.springBounciness = 10;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(DEFAULT_ALPHA);
    
    [self.hubContainView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation3"];
    [self.hubContainView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation3"];
    
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL isFinish) {
        finished();
    }];
}

- (void)dismissHub:(void (^)())finished
{
    // 设置消失时的Y坐标
    CGFloat animationPositionY = kScreenHeight + self.hubContainView.height;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(animationPositionY);

    
    [self.hubContainView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation4"];
    [self.hubContainView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation4"];
    
    
    // 完成回调
    __weak __typeof(&*self) weakSelf = self;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finish) {
        
        [weakSelf.hubContainView removeFromSuperview];
        
        finished();
    }];
}

@end
