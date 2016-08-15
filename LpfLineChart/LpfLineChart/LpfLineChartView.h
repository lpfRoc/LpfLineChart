//
//  LpfLineChartView.h
//  LpfLineChart
//
//  Created by roc on 16/8/15.
//  Copyright © 2016年 roc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LpfPointModel;
@class LpfLineChartView;
static const CGFloat chartLineStartX = 35.f;
static const CGFloat chartLineTheXAxisSpan = 45.f;
static const CGFloat chartLineTheYAxisSpan = 40.f;

typedef NS_ENUM(NSInteger, SChartBtnStyle) {
    SChartBtnStyleSeven = 0,
    SChartBtnStyleThirty ,
    SChartBtnStyleNinety
};
@protocol LpfChartLineViewDelegate <NSObject>

@required

- (void)chartLine :(LpfLineChartView *)chartLine changeChartSelectBtn:(UIButton *)btn;

@end

@interface LpfLineChartView : UIView
@property (nonatomic, weak) id<LpfChartLineViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *shapeLayerArr;  //存放线条数zu
@property (nonatomic, strong) NSMutableArray *pointLayerArr;  //存放圆点layer数组
@property (nonatomic, strong) NSMutableArray *pointModelArr;  //存放圆点模型数组
@property (nonatomic, assign) BOOL isFirst;                  //首次进入次界面
@property (nonatomic, strong) UIColor *pointColor;           //点颜色
@property (nonatomic, strong) UIColor *anotherPointColor;
@property (nonatomic, strong) UIColor *otherPointColor;
@property (nonatomic, strong) NSArray * xValues;             //实际点x坐标
@property (nonatomic, strong) NSArray * yValues;             //实际点y坐标
@property (nonatomic, assign) CGFloat yMax;                  //最大实际y坐标
@property (nonatomic, assign) BOOL curve;//是否曲线
@property (nonatomic, weak) CADisplayLink *currentDisplayLink;
@property (nonatomic, strong) LpfPointModel *pointModel;       //点模型对象
@property (nonatomic, assign) int layerCount;         //绘制折线的条数
/**
 *  @author sen, 15-12-24 10:12:59
 *
 *  开始绘制图表
 */
- (void)updataAnimation:(CADisplayLink *)display;
@end
