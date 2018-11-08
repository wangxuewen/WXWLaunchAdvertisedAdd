//
//  TestViewController.m
//  WXWLaunchAdvertisedAdd
//
//  Created by administrator on 2018/11/8.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"TestVC";
    NSURL *url = [NSURL URLWithString:@"https://github.com/wangxuewen"];
    [[UIApplication sharedApplication] openURL:url];
    self.view.backgroundColor = [UIColor whiteColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
