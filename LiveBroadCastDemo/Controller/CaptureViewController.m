//
//  CaptureViewController.m
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "CaptureViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property(nonatomic, strong) AVCaptureSession           *captureSession;
@property(nonatomic, strong) AVCaptureDeviceInput       *currentVideoDeviceInput;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic, strong) AVCaptureConnection        *videoConnection;
@property (nonatomic, weak)  UIImageView                *focusImageView;

@end

@implementation CaptureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"采集音视频信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 20);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"change" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(changeCapture:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self captureVideo];
}

- (void)captureVideo
{
    //1.创建捕捉会话
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    _captureSession = captureSession;
    
    
    //2.获取摄像头设备，默认后置摄像头
    //    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *videoDevice = [self getVideoDeviceByPosition:AVCaptureDevicePositionFront];
    
    
    //3.获取声音设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    //4.创建对应视频设备输入对象
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    _currentVideoDeviceInput = videoDeviceInput;
    
    //5.创建对应音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    //6.添加到会话中（注意判断是否可以添加输入）
    //6.1添加视频
    if ([captureSession canAddInput:videoDeviceInput]) {
        [captureSession addInput:videoDeviceInput];
    }
    //6.2添加音频
    if ([captureSession canAddInput:audioDeviceInput]) {
        [captureSession addInput:audioDeviceInput];
    }
    
    
    //7.获取视频数据输出设备
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    //7.1设置代理，捕捉视频样品数据
    //队列必须是串行队列，才能获取到数据
    dispatch_queue_t videoQueue = dispatch_queue_create("VideoCapture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    
    if ([captureSession canAddOutput:videoOutput]) {
        [captureSession addOutput:videoOutput];
    }
    
    //8.获取音屏数据输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    
    //8.1设置代理，捕捉音频样品数据
    dispatch_queue_t audioQueue = dispatch_queue_create("AudidCapture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    
    if ([captureSession canAddOutput:audioOutput]) {
        [captureSession addOutput:audioOutput];
    }
    
    //9.获取视频输入与输出连接，用于分辨音视频数据
    _videoConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //10.添加视频预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:previewLayer];
    
    _previewLayer = previewLayer;
    
    //11.启动会话
    [captureSession startRunning];
    
}

-(AVCaptureDevice *)getVideoDeviceByPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

//切换摄像头
- (void)changeCapture:(id)sender
{
    //获取当前设备方向
    AVCaptureDevicePosition currentPostion = _currentVideoDeviceInput.device.position;
    
    //获取需要改变的方向
    AVCaptureDevicePosition changePosition = currentPostion == AVCaptureDevicePositionFront?AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    
    //获取改变的摄像头设备
    AVCaptureDevice *changeDevice = [self getVideoDeviceByPosition:changePosition];
    
    //获取改变的摄像头输入设备
    AVCaptureDeviceInput *changeDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:changeDevice error:nil];
    
    //移除之前的摄像头设备
    [_captureSession removeInput:_currentVideoDeviceInput];
    
    //添加新的摄像头设备
    [_captureSession addInput:changeDeviceInput];
    
    //记录当前的摄像头设备
    _currentVideoDeviceInput = changeDeviceInput;
    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (_videoConnection == connection) {
        NSLog(@"采集到视频数据了~~~~~~~~~");
    } else {
        NSLog(@"采集到音频数据");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取点击位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    //当前位置转换为摄像头点上的位置
    CGPoint cameraPoint = [_previewLayer captureDevicePointOfInterestForPoint:point];
    
    //设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    
    //设置聚焦
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
    
}

/**
 *  设置聚焦光标位置
 *
 *  @pram point  光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusImageView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        self.focusImageView.alpha = 0;
    }];
    
}

/**
 *  设置聚焦
 *
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    AVCaptureDevice *captureDevice = _currentVideoDeviceInput.device;
    
    //锁定配置
    [captureDevice lockForConfiguration:nil];
    
    //设置聚焦
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    
    //设置曝光
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    
    //解锁配置
    [captureDevice unlockForConfiguration];
}

#pragma mark - 属性
- (UIImageView *)focusImageView
{
    if (_focusImageView == nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focusImage"]];
        _focusImageView = imageV;
        [self.view addSubview:_focusImageView];
    }
    return _focusImageView;
}


@end
