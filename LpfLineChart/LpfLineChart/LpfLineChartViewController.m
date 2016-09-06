//
//  LpfLineChartViewController.m
//  LpfLineChart
//
//  Created by roc on 16/8/15.
//  Copyright © 2016年 roc. All rights reserved.
//

#import "LpfLineChartViewController.h"
#import "LpfLineChartView.h"
#define kHeaderViewH 350
@interface LpfLineChartViewController ()<LpfChartLineViewDelegate>
@property (nonatomic, strong) LpfLineChartView *chartLineView;
@property (nonatomic, strong) NSArray * xValues;
@property (nonatomic, strong) NSArray * yValues;
@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, strong) NSArray * anotherXValues;
@property (nonatomic, strong) NSArray * anotherYValues;
@property (nonatomic, assign) CGFloat  anotherYMax;
@property (nonatomic, strong) NSArray * anotherXValues1;
@property (nonatomic, strong) NSArray * anotherYValues1;
@property (nonatomic, assign) CGFloat  anotherYMax1;
@end

@implementation LpfLineChartViewController
#pragma mark - lazy


- (LpfLineChartView *)chartLineView
{
    if (!_chartLineView){
        self.chartLineView = [[LpfLineChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, kHeaderViewH)];
        self.chartLineView.backgroundColor = [UIColor redColor];
        self.chartLineView.pointColor = [UIColor yellowColor];
        self.chartLineView.anotherPointColor = [UIColor blueColor];
        self.chartLineView.otherPointColor = [UIColor purpleColor];
        self.chartLineView.layerCount = 3;
        self.chartLineView.delegate = self;
    }
    return _chartLineView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.title = @"流量统计234";
    [self.view addSubview:self.chartLineView];
    
    /**
     *  首次显示数据
     */
    /**
     *  第一条线数据
     */
    self.chartLineView.isFirst = YES;
    self.xValues = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300"];
    self.yValues = @[@"50",@"5",@"15",@"70",@"45",@"24",@"80",];
    self.yMax = 80;
    /**
     *  第二条线数据
     */
    self.anotherXValues = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300"];
    self.anotherYValues = @[@"0",@"0",@"0",@"0",@"15",@"64",@"99"];
    self.anotherYMax = 99;
    /**
     *  第三条线数据
     */
    self.anotherXValues1 = @[@"0",@"50",@"100",@"150",@"200",@"250",@"300"];
    self.anotherYValues1 = @[@"130",@"0",@"2",@"10",@"15",@"64",@"49"];
    self.anotherYMax1 = 130;
    
    /**
     *  取三条线最大y值
     */
    self.chartLineView.yMax = (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax)>self.anotherYMax1? (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax):self.anotherYMax1;
    
    self.chartLineView.xValues = [NSArray arrayWithObjects:self.xValues,self.anotherXValues,self.anotherXValues1, nil];
    self.chartLineView.yValues = [NSArray arrayWithObjects:self.yValues,self.anotherYValues,self.anotherYValues1, nil];
    
    [self.chartLineView pointLayerArr];
}
#pragma mark - SChartLineDelegate
- (void )chartLine :(LpfLineChartView *)chartLineView changeChartSelectBtn:(UIButton *)btn
{
    chartLineView.xValues = [NSArray arrayWithObjects:self.xValues,self.anotherXValues,self.anotherXValues1 ,nil];;
    
    switch (btn.tag) {
        case SChartBtnStyleSeven:
        {
            self.yValues = @[@"50",@"5",@"15",@"70",@"45",@"24",@"80"];
            self.anotherYValues =  @[@"0",@"0",@"0",@"0",@"15",@"64",@"99"];
            self.anotherYValues1 = @[@"130",@"0",@"2",@"10",@"15",@"64",@"49"];
            self.yMax = 80;
            self.anotherYMax = 99;
            self.anotherYMax1 = 130;
            chartLineView.yMax = (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax)>self.anotherYMax1? (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax):self.anotherYMax1;;
            chartLineView.yValues = [NSArray arrayWithObjects:self.yValues,self.anotherYValues,self.anotherYValues1, nil];
            
        }
            break;
        case SChartBtnStyleThirty:
        {
            self.yValues = @[@"50",@"70",@"15",@"50",@"55",@"94",@"50"];
            self.anotherYValues =  @[@"0",@"0",@"0",@"0",@"15",@"34",@"40"];
            self.anotherYValues1 =  @[@"0",@"0",@"0",@"30",@"5",@"4",@"0"];
            self.yMax = 94;
            self.anotherYMax = 40;
            self.anotherYMax1 = 30;
            self.chartLineView.yMax = (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax)>self.anotherYMax1? (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax):self.anotherYMax1;;
            self.chartLineView.yValues = [NSArray arrayWithObjects:self.yValues,self.anotherYValues,self.anotherYValues1, nil];
        }
            break;
        case SChartBtnStyleNinety:
        {
            self.yValues = @[@"0",@"10",@"35",@"50",@"25",@"120",@"50"];
            self.anotherYValues =  @[@"10",@"0",@"0",@"0",@"75",@"4",@"0"];
            self.anotherYValues1 =  @[@"100",@"0",@"30",@"0",@"20",@"4",@"0"];
            self.yMax = 120;
            self.anotherYMax = 75;
            self.anotherYMax1 = 100;
            self.chartLineView.yMax =(self.yMax>self.anotherYMax?self.yMax:self.anotherYMax)>self.anotherYMax1? (self.yMax>self.anotherYMax?self.yMax:self.anotherYMax):self.anotherYMax1;;
            self.chartLineView.yValues = [NSArray arrayWithObjects:self.yValues,self.anotherYValues,self.anotherYValues1, nil];
        }
            break;
        default:
            break;
    }
    
    
}

/**
 *  第一进入此见面动态绘制折线图
 */
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.chartLineView.currentDisplayLink.paused = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
