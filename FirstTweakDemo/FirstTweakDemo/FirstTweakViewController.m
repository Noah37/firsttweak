//
//  FirstTweakViewController.m
//  FirstTweakDemo
//
//  Created by daye on 2021/1/11.
//  Copyright © 2021 Noah37. All rights reserved.
//

#import "FirstTweakViewController.h"

@interface FirstTweakViewController ()

@end

@implementation FirstTweakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"FirstTweakDemo";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showAlert];
    });
}

- (void)showAlert {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"这是原始弹窗" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
