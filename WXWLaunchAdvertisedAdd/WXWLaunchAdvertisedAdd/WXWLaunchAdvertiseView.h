//
//  WXWLaunchAdvertiseView.h
//  WXWLaunchAdvertisedAdd
//
//  Created by administrator on 2018/11/8.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

typedef enum {
    
    LogoAdType = 0,///带logo的广告
    FullScreenAdType = 1,///全屏的广告
    
}AdType;

typedef enum {
    
    skipAdType = 1,///点击跳过
    clickAdType = 2,///点击广告
    overtimeAdType = 3,///倒计时完成跳过
    
}clickType;

#import <UIKit/UIKit.h>
//#import <ImageIO/ImageIO.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^WXWClickAdvertisement) (const clickType);


@interface WXWLaunchAdvertiseView : UIView
///广告背景图
@property (nonatomic, strong) UIImageView *advertImgView;
///倒计时总时长,默认6秒
@property (nonatomic, assign) NSInteger adTime;
///本地图片名字
@property (nonatomic, copy) NSString *localImgName;
///网络图片URL
@property (nonatomic, copy) NSString *imgUrl;
///广告点击URL
@property (nonatomic, copy) NSString *advertUrl;
///是否支持点击广告
@property (nonatomic, assign) BOOL isClickAdertView;
///跳过按钮背景颜色
@property (nonatomic, strong) UIColor *skipBgColor;
///跳过按钮字体颜色
@property (nonatomic, strong) UIColor *skipTitleColor;
///图片显示动画，默认NO
@property (nonatomic, assign) BOOL imgShowAnimation;

@property (nonatomic, copy)WXWClickAdvertisement clickBlock;

/*
 *  adType 广告类型
 */
- (void(^)(AdType const adType))getWXWLaunchImageAdViewType;

@end

NS_ASSUME_NONNULL_END
