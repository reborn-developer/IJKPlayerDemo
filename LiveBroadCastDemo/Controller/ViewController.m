//
//  ViewController.m
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "ViewController.h"
#import "BroadCastListViewController.h"
#import "CaptureViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(10, 100, 300, 30);
    collectButton.backgroundColor = [UIColor blueColor];
    [collectButton setTitle:@"采集音视频" forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:collectButton];
    
    
    UIButton *broadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    broadButton.frame = CGRectMake(10, 150, 300, 30);
    broadButton.backgroundColor = [UIColor blueColor];
    [broadButton setTitle:@"播放" forState:UIControlStateNormal];
    [broadButton addTarget:self action:@selector(broadCastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:broadButton];
}

-(void)collectAction:(id)sender
{
    CaptureViewController *captureVC = [[CaptureViewController alloc] init];
    [self.navigationController pushViewController:captureVC animated:YES];
}

-(void)broadCastAction:(id)sender
{
    BroadCastListViewController *broadCastListVC = [[BroadCastListViewController alloc] init];
    [self.navigationController pushViewController:broadCastListVC animated:YES];
}

@end
