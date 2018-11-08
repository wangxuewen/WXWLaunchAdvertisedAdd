//
//  NSObject+WXWLaunchAdvertisement.h
//  WXWLaunchAdvertisedAdd
//
//  Created by administrator on 2018/11/8.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWLaunchAdvertiseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WXWLaunchAdvertisement)

+ (void)makeWXWLaunchAdvertiseView:(void(^)(WXWLaunchAdvertiseView *))block;

@end

NS_ASSUME_NONNULL_END
