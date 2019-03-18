//
//  ViewController.m
//  ZLProgressViewDemo
//
//  Created by kevin on 2019/3/18.
//  Copyright © 2019 kevin. All rights reserved.
//

#import "ViewController.h"
#import "ZLProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZLProgressView *progressView = [[ZLProgressView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    progressView.center = self.view.center;
    progressView.progress = 0.5;
    [self.view addSubview:progressView];
}


@end
