//
//  ZLProgressView.m
//  ZLProgressViewDemo
//
//  Created by kevin on 2019/3/18.
//  Copyright © 2019 kevin. All rights reserved.
//

#import "ZLProgressView.h"

@interface ZLProgressView ()
{
    //前面的波浪
    CAShapeLayer *_waveLayer1;
    CAShapeLayer *_waveLayer2;
    
    CADisplayLink *_disPlayLink;
    
    /**
     曲线的振幅
     */
    CGFloat _waveAmplitude;
    /**
     曲线角速度
     */
    CGFloat _wavePalstance;
    /**
     曲线初相
     */
    CGFloat _waveX;
    /**
     曲线偏距
     */
    CGFloat _waveY;
    /**
     曲线移动速度
     */
    CGFloat _waveMoveSpeed;
    /**
     width
     */
    CGFloat _width;
    /**
     height
     */
    CGFloat _height;
    /**
     字体大小
     */
    CGFloat _font;
}
@property (nonatomic, retain) UILabel *BlueLab;//蓝底
@property (nonatomic, retain) UILabel *WhiteLab;//白底
@end

@implementation ZLProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _width = frame.size.width;
        _height = frame.size.height;
        _font = _width/3.0;
        [self setUpView];
        [self setData];
    }
    return self;
}

//添加控件
- (void)setUpView{
    
    [self addSubview:self.WhiteLab];
    [self addSubview:self.BlueLab];
    
    //初始化波浪
    //底层
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
    view.layer.cornerRadius = _width/2;
    view.layer.masksToBounds = YES;
    
    _waveLayer1 = [CAShapeLayer layer];
    _waveLayer1.fillColor = [UIColor greenColor].CGColor;
    _waveLayer1.strokeColor = [UIColor greenColor].CGColor;
    [view.layer addSublayer:_waveLayer1];
    
    //上层
    _waveLayer2 = [CAShapeLayer layer];
    _waveLayer2.fillColor = [UIColor greenColor].CGColor;
    _waveLayer2.strokeColor = [UIColor greenColor].CGColor;
    [view.layer addSublayer:_waveLayer2];
    
    self.BlueLab.layer.mask = view.layer;
}

//输入参数
- (void)setData{
    //振幅
    _waveAmplitude = 3;
    //角速度
    _wavePalstance = M_PI/_width/2;
    //偏距
    _waveY = _height;
    //初相
    _waveX = 0;
    //x轴移动速度
    _waveMoveSpeed = _wavePalstance * 10;
    //以屏幕刷新速度为周期刷新曲线的位置
    _disPlayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateWave:)];
    [_disPlayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)updateWave:(CADisplayLink *)link{
    _waveX += _waveMoveSpeed;
    [self updateWaveY];
    [self updateWave1];
    [self updateWave2];
}

//更新偏距的大小 直到达到目标偏距 让wave有一个匀速增长的效果
-(void)updateWaveY{
    CGFloat targetY = _height - _progress * _height;
    if (_waveY < targetY) {
        _waveY += 2;
    }
    if (_waveY > targetY ) {
        _waveY -= 2;
    }
}

-(void)updateWave1{
    //波浪宽度
    CGFloat waterWaveWidth = _width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.00f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * cos(_wavePalstance * x + _waveX) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _height);
    CGPathAddLineToPoint(path, nil, 0, _height);
    CGPathCloseSubpath(path);
    _waveLayer1.path = path;
    CGPathRelease(path);
}

-(void)updateWave2{
    //波浪宽度
    CGFloat waterWaveWidth = _width;
    //初始化运动路径
    CGMutablePathRef path = CGPathCreateMutable();
    //设置起始位置
    CGPathMoveToPoint(path, nil, 0, _waveY);
    //初始化波浪其实Y为偏距
    CGFloat y = _waveY;
    //正弦曲线公式为： y=Asin(ωx+φ)+k;
    for (float x = 0.0f; x <= waterWaveWidth ; x++) {
        y = _waveAmplitude * sin(_wavePalstance * x + _waveX) + _waveY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    //添加终点路径、填充底部颜色
    CGPathAddLineToPoint(path, nil, waterWaveWidth, _height);
    CGPathAddLineToPoint(path, nil, 0, _height);
    CGPathCloseSubpath(path);
    _waveLayer2.path = path;
    CGPathRelease(path);
    
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    self.BlueLab.text = [[NSString stringWithFormat:@"%.0f",progress*100] stringByAppendingString:@"%"];
    self.WhiteLab.text = [[NSString stringWithFormat:@"%.0f",progress*100] stringByAppendingString:@"%"];
}

-(void)stop{
    if (_disPlayLink) {
        [_disPlayLink invalidate];
        _disPlayLink = nil;
    }
}

-(void)dealloc{
    [self stop];
    if (_waveLayer1) {
        [_waveLayer1 removeFromSuperlayer];
        _waveLayer1 = nil;
    }
    if (_waveLayer2) {
        [_waveLayer2 removeFromSuperlayer];
        _waveLayer2 = nil;
    }
    
}

//初始化控件
- (UILabel *)WhiteLab{
    if (!_WhiteLab) {
        _WhiteLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
        _WhiteLab.textAlignment = NSTextAlignmentCenter;
        _WhiteLab.font = [UIFont systemFontOfSize:_font];
        _WhiteLab.layer.cornerRadius = _width/2;
        _WhiteLab.layer.borderColor = [UIColor greenColor].CGColor;
        _WhiteLab.layer.borderWidth = 1;
        _WhiteLab.backgroundColor = [UIColor whiteColor];
        _WhiteLab.textColor = [UIColor greenColor];
        _WhiteLab.clipsToBounds = YES;
    }
    return _WhiteLab;
}

- (UILabel *)BlueLab{
    if (!_BlueLab) {
        _BlueLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _width, _height)];
        _BlueLab.textAlignment = NSTextAlignmentCenter;
        _BlueLab.font = [UIFont systemFontOfSize:_font];
        _BlueLab.layer.cornerRadius = _width/2;
        _BlueLab.layer.borderColor = [UIColor greenColor].CGColor;
        _BlueLab.layer.borderWidth = 1;
        _BlueLab.backgroundColor = [UIColor greenColor];
        _BlueLab.textColor = [UIColor whiteColor];
        _BlueLab.clipsToBounds = YES;
    }
    return _BlueLab;
}

@end
