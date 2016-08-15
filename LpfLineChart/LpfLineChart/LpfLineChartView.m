//
//  LpfLineChartView.m
//  LpfLineChart
//
//  Created by roc on 16/8/15.
//  Copyright © 2016年 roc. All rights reserved.
//

#import "LpfLineChartView.h"
#import "LpfPointModel.h"
#define kScale 1
#define UI_SCREEN_WIDTH self.bounds.size.width
#define kLineColor [UIColor colorWithRed:1.000f green:0.769f blue:0.000f alpha:1.00f]
#define kCirCleColor [UIColor colorWithRed:0.859f green:0.871f blue:0.882f alpha:1.00f]
#define kHVLineColor [UIColor colorWithRed:0.918f green:0.929f blue:0.949f alpha:1.00f]
#define kBulldesFont [UIFont systemFontOfSize:10]

static const NSInteger kYEqualPaths = 5;//y轴为5等份
static const CGFloat kTopSpace = 50.f;//距离顶部y值

@interface LpfLineChartView ()
@property (nonatomic, strong) NSMutableArray *YLabelArr;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) NSInteger count;               //屏幕刷新次数
@property (nonatomic, strong) UIButton *selectBtn;           //纪录上次点击的按钮


@end
@implementation LpfLineChartView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.curve = NO;
        
        UIButton *btn = [self createChangeBtnByTitle:@"7天" SChartBtnStyle:(SChartBtnStyleSeven)];
        btn.frame = CGRectMake(25, 10, 100, 30);
        
        UIButton *btn1 = [self createChangeBtnByTitle:@"30天" SChartBtnStyle:(SChartBtnStyleThirty)];
        
        btn1.frame = CGRectMake(150, 10, 100, 30);
        CGPoint center = btn1.center;
        center.x = self.center.x;
        btn1.center = center;
        
        
        UIButton *btn2 = [self createChangeBtnByTitle:@"90天" SChartBtnStyle:(SChartBtnStyleNinety)];
        btn2.frame = CGRectMake(self.bounds.size.width - 125, 10, 100, 30);
        
        CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updataAnimation:)];
        display.paused = YES;
        [display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _currentDisplayLink = display;
    }
    return self;
}
- (NSMutableArray *)shapeLayerArr
{
    if (!_shapeLayerArr){
        self.shapeLayerArr = [NSMutableArray array];
        for (int i = 0; i < self.layerCount; i++) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.lineCap = kCALineCapRound;
            shapeLayer.lineJoin = kCALineJoinRound;
            shapeLayer.lineWidth = 2.f;
            shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer addSublayer:shapeLayer];
            [self.shapeLayerArr addObject:shapeLayer];
        }
    }
    return _shapeLayerArr;
}

- (NSMutableArray *)YLabelArr
{
    if (!_YLabelArr){
        self.YLabelArr = [NSMutableArray array];
    }
    return _YLabelArr;
}

- (NSMutableArray *)pointModelArr
{
    if (!_pointModelArr){
        _pointModelArr = [NSMutableArray array];
        for (int i = 0; i < self.layerCount; i++) {
            NSMutableArray *arr = [NSMutableArray array];
            [_pointModelArr addObject:arr];
        }
        
    }
    return _pointModelArr;
}

- (NSMutableArray *)pointLayerArr {
    if (!_pointLayerArr) {
        _pointLayerArr = [NSMutableArray array];
        
        for (int i = 0; i<self.layerCount; i++) {
            NSMutableArray *arr= [NSMutableArray array];
            for (int j = 0; j < [self.xValues[0] count]; j++) {
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.zPosition = 1;
                shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
                if (i == 0) {
                    shapeLayer.fillColor = _pointColor.CGColor;
                }else if (i == 1)
                {
                    shapeLayer.fillColor = _anotherPointColor.CGColor;
                }else
                {
                    shapeLayer.fillColor = _otherPointColor.CGColor;
                }
                
                shapeLayer.opacity = 0;
                [self.layer addSublayer:shapeLayer];
                [arr addObject:shapeLayer];
            }
            [_pointLayerArr addObject:arr];
        }
        
    }
    return _pointLayerArr;
    
}


- (void)setYMax:(CGFloat)yMax {
    _yMax = yMax;
}


- (void)setCurve:(BOOL)curve {
    _curve = curve;
}

- (void)setYValues:(NSArray *)yValues {
    _yValues = yValues;
    if (_isFirst) {
        [self drawHorizontal];
    }
    
}

- (void)setXValues:(NSArray *)xValues {
    _xValues = xValues;
    if (_isFirst) {
        [self drawVertical];
    }
    
}

/**
 *  创建按钮
 */
- (UIButton *)createChangeBtnByTitle:(NSString *)title SChartBtnStyle :(SChartBtnStyle)btnStyle
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTitle:title forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(change:) forControlEvents:(UIControlEventTouchUpInside)];
    btn.tag = btnStyle;
    [self addSubview:btn];
    return btn;
}
//画横线
- (void)drawHorizontal {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i <= kYEqualPaths; i++) {
        
        if (i == 0 || i == kYEqualPaths) {
            [path moveToPoint:CGPointMake(0, chartLineTheYAxisSpan *kScale* i + kTopSpace*kScale)];
            [path addLineToPoint:CGPointMake(UI_SCREEN_WIDTH, chartLineTheYAxisSpan *kScale* i + kTopSpace*kScale)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = kHVLineColor.CGColor;
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 0.3f;
            [self.layer addSublayer:shapeLayer];
        }
        
    }
    
}
//画竖线
- (void)drawVertical {
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    for (NSInteger i = 0; i < [_xValues[0] count]; i++) {
        
        [path moveToPoint:CGPointMake(chartLineStartX*kScale+ chartLineTheXAxisSpan*kScale*i,kTopSpace*kScale)];
        [path addLineToPoint:CGPointMake(chartLineStartX*kScale + chartLineTheXAxisSpan *kScale* i,chartLineTheYAxisSpan *kScale * kYEqualPaths + kTopSpace*kScale)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = kHVLineColor.CGColor;
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 0.3f;
        [self.layer addSublayer:shapeLayer];
    }
}


- (void)change:(UIButton *)btn
{
    _isFirst = NO;
    /**
     *  如果显示的和要点击的图一样，直接返回无需再次绘制
     */
    if (self.selectBtn.tag == btn.tag) {
        return;
    }
    
    self.selectBtn = btn;
    
    for (int i = 0; i < self.layerCount; i++) {
        for (LpfPointModel *model in self.pointModelArr[i]) {
            [model resume];
        }
    }
    
    if ([_delegate respondsToSelector:@selector(chartLine:changeChartSelectBtn:)]&&_delegate) {
        [_delegate chartLine:self changeChartSelectBtn:btn];
    }
    
    
    _count = 0;
    
    /**
     *  打开屏幕刷新
     */
    _currentDisplayLink.paused = NO;
}

#pragma mark - drawLine
- (void)drawLineByXValues:(NSArray *)xValues yValues:(NSArray *)yValues  yMax:(CGFloat )yMax pointModelArr:(NSMutableArray *)pointModelArr pointLayerArr :(NSMutableArray *)pointLayerArr shapeLayer:(CAShapeLayer *)shapeLayer isAnotherLine:(BOOL)isAnotherLine
{
    /**
     *  第二条线绘制延迟刷新3次
     */
    if (isAnotherLine) {
        _count = _count - 3;
    }
    NSMutableArray *pointXArray = [NSMutableArray array]; //存放实际坐标x
    NSMutableArray * pointYArray = [NSMutableArray array];//存放实际坐标y
    NSMutableArray *points = [NSMutableArray array];      //存放转换后的坐标y
    //设置y轴
    for (NSInteger i = 0; i < xValues.count; i++) {
        [pointXArray addObject:@(chartLineStartX*kScale + chartLineTheXAxisSpan*kScale * i)];
    }
    //设置y轴
    for (NSInteger i = 0; i < xValues.count; i++) {
        [pointYArray addObject:@(chartLineTheYAxisSpan*kScale * kYEqualPaths - [yValues[i] floatValue]/yMax * chartLineTheYAxisSpan *kScale* kYEqualPaths + kTopSpace*kScale)];
    }
    
    for (NSInteger i = 0; i < pointXArray.count; i++) {
        CGPoint point = CGPointMake([pointXArray[i] floatValue], [pointYArray[i] floatValue]);
        NSValue * value = [NSValue valueWithCGPoint:point];
        [points addObject:value];
    }
    for (int i = 0 ; i < points.count; i++) {
        
        
        if (pointModelArr.count != points.count) {  //第一次进来需要先创建SPointModel并加入pointModelArr
            LpfPointModel *model = [[LpfPointModel alloc] init];
            model.nextPoint = [points[i] CGPointValue];
            
            [pointModelArr addObject:model];
        }else
        {
            LpfPointModel *model = pointModelArr[i];
            model.nextPoint = [points[i] CGPointValue];
        }
        
    }
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    
    
    for (NSInteger i = 0; i < points.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        
        LpfPointModel *model = pointModelArr[i];
        CGFloat show_Y = model.lastPoint.y + _count/ 60.0 * (model.nextPoint.y - model.lastPoint.y);
        
        /**
         *  show_y 不存在 说明首次进入显示（model.nextPoint.y） 没点击按钮
         */
        point.y  =  model.lastPoint.y?show_Y:model.nextPoint.y;
        model.currentPoint = point;
        point = point;
        //        NSLog(@"-------------------%f",show_Y);
        
        
        if (i == 0) {
            [bezier moveToPoint:point];
            
            UIBezierPath *pointBezier = [UIBezierPath bezierPath];
            [pointBezier addArcWithCenter:CGPointMake(point.x , point.y) radius:5 startAngle:0  endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *shapeLayer = pointLayerArr[i];
            shapeLayer.path = pointBezier.CGPath;
            
        } else {
            
            UIBezierPath *pointBezier = [UIBezierPath bezierPath];
            [pointBezier addArcWithCenter:CGPointMake(point.x , point.y) radius:5 startAngle:0  endAngle:M_PI*2 clockwise:YES];
            CAShapeLayer *shapeLayer = pointLayerArr[i];
            shapeLayer.path = pointBezier.CGPath;
            
            [bezier addLineToPoint:point];
            
        }
        
        if (_isFirst && !isAnotherLine) {
            [self addXLabel:point andIndex:i];
        }
        
    }
    _count = _count + 3;
    shapeLayer.path = bezier.CGPath;
    
    if (_isFirst) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration =  1.f;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
        pathAnimation.autoreverses = NO;
        [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        /**
         *  点逐个出现动画
         */
        for (int i = 0; i <pointLayerArr.count; i++) {
            CAShapeLayer *shapeLayer = pointLayerArr[i];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i+1)/(pointLayerArr.count*1.0)* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                shapeLayer.opacity = 1;
            });
        }
        
    }
    
    //        [self addYLabel];
    
}

- (void)updataAnimation:(CADisplayLink *)display{
    
    if (_isFirst && _count >= 1) {
        display.paused = YES;
        return;
    }
    if (_count > 60) {
        display.paused = YES;
        return;
    }
    
#pragma mark - drawOneLine
    
    for (int i = 0; i < self.layerCount; i++) {
        BOOL isAnotherLine;
        if (i == 0) {
            isAnotherLine = NO;
        }else
        {
            isAnotherLine = YES;
        }
        [self drawLineByXValues:self.xValues[i] yValues:self.yValues[i] yMax:self.yMax pointModelArr:self.pointModelArr[i] pointLayerArr:self.pointLayerArr[i] shapeLayer:self.shapeLayerArr[i] isAnotherLine:isAnotherLine];
    }
    
}

//标记x轴label
- (void)addXLabel:(CGPoint)point andIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chartLineTheXAxisSpan*kScale, 20)];
    label.center = CGPointMake(point.x, chartLineTheYAxisSpan*kScale * kYEqualPaths + kTopSpace*kScale + 20);
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:10.f];
    label.textAlignment = NSTextAlignmentCenter;
    //    label.text = _xValues[index];
    if (index == 0) {
        label.text = @"3月8日";
    }else if(index == [_xValues[0] count]-1)
    {
        label.text = @"3月14日";
    }
    [self addSubview:label];
}

//标记y轴label
- (void)addYLabel {
    if (self.YLabelArr.count) {
        
        for ( NSInteger i = 0; i <= kYEqualPaths; i++) {
            UILabel * label = self.YLabelArr[i];
            if (i == kYEqualPaths) {
                label.text = @"0";
            } else {
                label.text = [NSString stringWithFormat:@"%.2f",_yMax - _yMax/5.f * i];
            }
        }
        
    }else
    {
        for (NSInteger i = 0; i <= kYEqualPaths; i++) {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, chartLineTheYAxisSpan *kScale* i + kTopSpace*kScale, chartLineStartX *kScale- 5, 10)];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:10.f];
            label.textAlignment = NSTextAlignmentRight;
            [self.YLabelArr addObject:label];
            [self addSubview:label];
            if (i == kYEqualPaths) {
                label.text = @"0";
            } else {
                label.text = [NSString stringWithFormat:@"%.2f",_yMax - _yMax/5.f * i];
            }
        }
    }
    
}

@end
