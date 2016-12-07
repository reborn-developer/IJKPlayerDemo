//
//  LiveViewController.m
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "LiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import <UIImageView+WebCache.h>
#define SCREEN_WIDTH                      ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT                     ([[UIScreen mainScreen]bounds].size.height)
#define ALD(x)                            (x * SCREEN_WIDTH/375.0)
@interface LiveViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self InitView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //界面消失 停止播放
    [_player pause];
    [_player stop];
    [_player shutdown];
}
- (void)InitView
{
    
    /* @设置直播占位图
     * @ 创建IJKFFMoviePlayerController：专门用来直播，并且传入拉流地址
     * @ 准备播放
     * @强引用player，防止被销毁
     ***/
     
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.imageView];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_liveListModel.creator.portrait]];
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    //拉流地址
    NSURL *streamUrl = [NSURL URLWithString:_liveListModel.stream_addr];
    
    IJKFFMoviePlayerController *playerVC = [[IJKFFMoviePlayerController alloc] initWithContentURL:streamUrl withOptions:nil];
    
    [playerVC prepareToPlay];
    
    //强引用
    _player = playerVC;
    
    playerVC.view.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:playerVC.view atIndex:1];

}

@end
