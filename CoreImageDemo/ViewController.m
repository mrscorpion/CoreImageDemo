//
//  ViewController.m
//  CoreImageDemo
//
//  Created by mr.scorpion on 16/7/19.
//  Copyright © 2016年 mrscorpion. All rights reserved.
//  iOS CoreImage图片处理动态渲染(滤镜)

#import "ViewController.h"
#import <GLKit/GLKit.h> // 需要导入此库

@interface ViewController ()
@property (nonatomic, strong) GLKView *glkView; //渲染用的buffer视图(类似流媒体,实时改变)
@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIImage *ciImage;
@property (nonatomic, strong) CIContext *ciContext;

@property (strong, nonatomic) UIImageView *backImage; // 第二层的image
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *showImage = [UIImage imageNamed:@"immersion_mode"];
    CGRect rect = CGRectMake(0, 0, showImage.size.width, showImage.size.height);

    // 获取OpenGLES渲染的上下文
    EAGLContext *eagContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    // 创建出渲染的buffer
    self.glkView = [[GLKView alloc] initWithFrame:rect context:eagContext];
    [self.glkView bindDrawable]; // 绑定绘制,否则刚开始会黑屏
    [self.view addSubview:self.glkView];

    // 创建出CoreImage用的上下文
    self.ciContext = [CIContext contextWithEAGLContext:eagContext options:@{kCIContextWorkingColorSpace : [NSNull null]}];

    // CoreImage相关设置
    self.ciImage = [[CIImage alloc] initWithImage:showImage];
    self.filter = [CIFilter filterWithName:@"CISepiaTone"];
//    self.filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [self.filter setValue:self.ciImage forKey:kCIInputImageKey];
    [self.filter setValue:@(0) forKey:kCIInputIntensityKey];

    // 开始渲染
    [self.ciContext drawImage:[self.filter valueForKey:kCIOutputImageKey] inRect:CGRectMake(0, 0, self.glkView.drawableWidth, self.glkView.drawableHeight) fromRect:[self.ciImage extent]];
    [self.glkView display];
}


#pragma mark - Touch
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSInteger waveNum = 0;
    // fabs函数 : 求绝对值函数，fabs(x)，求出x的绝对值
    waveNum = 2 * (height/2 -fabs(height/2 - point.y)) / height * 10; //8;
    if (waveNum < 1) {
        waveNum = 1;
    }
    
    self.backImage.image = [UIImage imageNamed:@"immersion_mode"];
    
//    CGFloat value = 0;
//    value =  2 * (height/2 -fabs(height/2 - point.y)) / height;
//    if (value < 1) {
//        value = 1;
//    }
//    if (waveNum < 2) {
//        self.backImage.image = [UIImage imageNamed:@"immersion_mode"];
//    } else {
//        self.backImage.image = [UIImage imageNamed:@"immersion_mode_press"];
//    }
    
    [self changeColorValue:waveNum];
//    [self changeColorValue:value];
}
- (void)changeColorValue:(CGFloat)value
{
    [self.filter setValue:self.ciImage forKey:kCIInputImageKey];
    [self.filter setValue:@(value) forKey:kCIInputIntensityKey];
    // 开始渲染
    [self.ciContext drawImage:[self.filter valueForKey:kCIOutputImageKey] inRect:CGRectMake(0, 0, self.glkView.drawableWidth, self.glkView.drawableHeight) fromRect:[self.ciImage extent]];
    [self.glkView display];
}


- (void)moveTouchAction
{
//    XXNSLg(@"我在移动%ld",(long)wave);
//    if ([LGCentralManager sharedInstance].curPeripheral.isConnected) {
//        [[LGCentralManager sharedInstance].curPeripheral synchronizationPWMLevel:wave + 1];
//    } else {
//        [[HGMangerP2P sharedInstance] synchronizationPWMLevel:wave + 1];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
