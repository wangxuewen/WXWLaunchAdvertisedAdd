//
//  WXWLaunchAdvertiseView.m
//  WXWLaunchAdvertisedAdd
//
//  Created by administrator on 2018/11/8.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "WXWLaunchAdvertiseView.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImageView+WebCache.h"

#define mainHeight      [[UIScreen mainScreen] bounds].size.height
#define mainWidth       [[UIScreen mainScreen] bounds].size.width
#define KIsiPhoneXs ((int)((mainHeight/mainWidth)*100) == 216)?YES:NO
#define IMGURL @"IMGURL"
#define ISCLICKADVIEW @"ISCLICKADVIEW"
#define ADVERTURL @"ADVERTURL"

@interface WXWLaunchAdvertiseView()
{
    NSTimer *countDownTimer;
}

///跳过按钮 可自定义
@property (nonatomic, strong) UIButton *skipBtn;

@property (strong, nonatomic) NSString *isClick;

@end

@implementation WXWLaunchAdvertiseView

#pragma mark - 获取广告类型
- (void (^)(AdType adType))getWXWLaunchImageAdViewType {
    __weak typeof(self) weakSelf = self;
    return ^(AdType adType){
        [weakSelf addWXWLaunchImageAdView:adType];
    };
}

#pragma mark - 点击广告
- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    _isClick = @"1";
    if (self.imgShowAnimation) {
        [self startcloseAnimation];
    } else {
        [self closeAddImgAnimation];
    }
}

#pragma mark - 开启关闭动画
- (void)startcloseAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.5;
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.3];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.advertImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    [NSTimer scheduledTimerWithTimeInterval:opacityAnimation.duration
                                     target:self
                                   selector:@selector(closeAddImgAnimation)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)skipBtnClick{
    _isClick = @"2";
    if (self.imgShowAnimation) {
        [self startcloseAnimation];
    } else {
        [self closeAddImgAnimation];
    }
}

#pragma mark - 关闭动画完成时处理事件
-(void)closeAddImgAnimation
{
    [countDownTimer invalidate];
    countDownTimer = nil;
    
    if ([_isClick integerValue] == 1) {
        if (self.clickBlock) {//点击广告
            self.clickBlock(clickAdType);
        }
    }else if([_isClick integerValue] == 2){
        if (self.clickBlock) {//点击跳过
            self.clickBlock(skipAdType);
        }
    }else{
        if (self.clickBlock) {
            self.clickBlock(overtimeAdType);
        }
    }
    self.hidden = YES;
    self.advertImgView.hidden = YES;
    //    [self removeFromSuperview];
}

- (void)onTimer {
    self.skipBtn.backgroundColor = self.skipBgColor;
    if (_adTime == 0) {
        [countDownTimer invalidate];
        countDownTimer = nil;
        if (self.imgShowAnimation) {
            [self startcloseAnimation];
        } else {
            [self closeAddImgAnimation];
        }
    }else{
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%@ | 跳过",@(_adTime--)] forState:UIControlStateNormal];
    }
}

- (void)setLocalImgName:(NSString *)localImgName{
    _localImgName = localImgName;
    if (_localImgName.length > 0) {
        if ([_localImgName rangeOfString:@".gif"].location  != NSNotFound ) {
            _localImgName  = [_localImgName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
            NSData *gifData = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:_localImgName ofType:@"gif"]];
            UIWebView *webView = [[UIWebView alloc] initWithFrame:self.advertImgView.frame];
            webView.backgroundColor = [UIColor clearColor];
            webView.scalesPageToFit = YES;
            webView.scrollView.scrollEnabled = NO;
            [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
            [webView setUserInteractionEnabled:NO];
            UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            clearBtn.frame = webView.frame;
            clearBtn.backgroundColor = [UIColor clearColor];
            [clearBtn addTarget:self action:@selector(activiTap:) forControlEvents:UIControlEventTouchUpInside];
            [webView addSubview:clearBtn];
            [self.advertImgView addSubview:webView];
            [self.advertImgView bringSubviewToFront:_skipBtn];
        }else{
            self.advertImgView.image = [UIImage imageNamed:_localImgName];
        }
    }
}


-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    if ([self isImgCache] == nil) {
        [_advertImgView sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:nil];
    }
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    [userDf setObject:_imgUrl forKey:IMGURL];
}

- (void)setIsClickAdertView:(BOOL)isClickAdertView{
    _isClickAdertView = isClickAdertView;
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    [userDf setObject:@(isClickAdertView) forKey:ISCLICKADVIEW];
}

-(void)setAdvertUrl:(NSString *)advertUrl{
    _advertUrl = advertUrl;
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    [userDf setObject:advertUrl forKey:ADVERTURL];
}


- (void)addWXWLaunchImageAdView:(AdType)adType{
#pragma mark - iOS开发 强制竖屏。系统KVO 强制竖屏—>适用于支持各种方向屏幕启动时，竖屏展示广告 by:nixs
    NSNumber * orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    //倒计时时间
    _adTime = 6;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    NSString *launchImageName = [self getLaunchImage:@"Portrait"];
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    self.backgroundColor = [UIColor colorWithPatternImage:launchImage];
    self.frame = CGRectMake(0, 0, mainWidth, mainHeight);
    if (adType == FullScreenAdType) {
        self.advertImgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    }else{
        self.advertImgView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight - mainWidth/3)];
    }
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipBtn.frame = CGRectMake(mainWidth - 70, 20, 60, 30);
    if (KIsiPhoneXs) {
        self.skipBtn.frame = CGRectMake(mainWidth - 70, 40, 60, 30);
    }
    self.skipBtn.backgroundColor = [UIColor clearColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.skipBtn.layer.cornerRadius = 3;
    self.skipBtn.clipsToBounds = YES;
    
    self.advertImgView.tag = 1101;
    [self addSubview:self.advertImgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activiTap:)];
    // 允许用户交互
    self.advertImgView.userInteractionEnabled = YES;
    [self.advertImgView addGestureRecognizer:tap];
    if (self.imgShowAnimation) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = self.imgShowAnimation ? 0.8 : 0.001;
        opacityAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        opacityAnimation.toValue = [NSNumber numberWithFloat:0.8];
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.advertImgView.layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    }
    if ([self isImgCache].length > 0) {
        [_advertImgView sd_setImageWithURL:[NSURL URLWithString:[self isImgCache]] placeholderImage:nil];
    }
    _isClickAdertView = [self isClickAdViewCache];
    if ([self isAdvertUrlCache].length > 0) {
        _advertUrl = [self isAdvertUrlCache];
    }
    [self addSubview:self.skipBtn];
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

/*
 *viewOrientation 屏幕方向
 */
- (NSString *)getLaunchImage:(NSString *)viewOrientation{
    //获取启动图片
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    //横屏请设置成 @"Landscape"|Portrait
    //    NSString *viewOrientation = @"Portrait";
    __block NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    [imagesDict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize imageSize = CGSizeFromString(obj[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:obj[@"UILaunchImageOrientation"]])
        {
            launchImageName = obj[@"UILaunchImageName"];
        }
    }];
    return launchImageName;
}

#pragma mark - setter
- (void)setSkipBgColor:(UIColor *)skipBgColor {
    if (_skipBgColor != skipBgColor) {
        _skipBgColor = skipBgColor;
    }
}

- (void)setSkipTitleColor:(UIColor *)skipTitleColor {
    if (_skipTitleColor != skipTitleColor) {
        _skipTitleColor = skipTitleColor;
        [_skipBtn setTitleColor:skipTitleColor forState:UIControlStateNormal];
    }
}

-(void)setImgShowAnimation:(BOOL)imgShowAnimation {
    if (_imgShowAnimation != imgShowAnimation) {
        _imgShowAnimation = imgShowAnimation;
    }
}

#pragma mark - getter
- (NSString *)isImgCache{
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    NSString *imgURL = [userDf objectForKey:IMGURL];
    if (imgURL.length > 0) {
        return imgURL;
    }
    return nil;
}

- (NSString *)isAdvertUrlCache{
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    NSString *advertUrl = [userDf objectForKey:ADVERTURL];
    if (advertUrl.length > 0) {
        return advertUrl;
    }
    return nil;
}

- (BOOL)isClickAdViewCache{
    NSUserDefaults *userDf = [NSUserDefaults standardUserDefaults];
    NSNumber *isClick  = [userDf objectForKey:ISCLICKADVIEW];
    return [isClick boolValue];
}

@end
