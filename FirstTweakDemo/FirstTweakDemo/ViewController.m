//
//  ViewController.m
//  FirstTweakDemo
//
//  Created by daye on 2021/1/11.
//  Copyright © 2021 Noah37. All rights reserved.
//

#import "ViewController.h"
#import "FirstTweakViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pushAction:(id)sender {
    FirstTweakViewController * tweakVC = [[FirstTweakViewController alloc] init];
    [self.navigationController pushViewController:tweakVC animated:YES];
}

@end
