//
//  NSObject+WXWLaunchAdvertisement.m
//  WXWLaunchAdvertisedAdd
//
//  Created by administrator on 2018/11/8.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "NSObject+WXWLaunchAdvertisement.h"

@implementation NSObject (WXWLaunchAdvertisement)

+ (void)makeWXWLaunchAdvertiseView:(void(^)(WXWLaunchAdvertiseView *))block {
    WXWLaunchAdvertiseView *imgAdView = [[WXWLaunchAdvertiseView alloc]init];
    imgAdView.clickBlock = ^(const clickType type) {
        
    };
    NSLog(@"-----%@",imgAdView.clickBlock);
    block(imgAdView);
}


@end
