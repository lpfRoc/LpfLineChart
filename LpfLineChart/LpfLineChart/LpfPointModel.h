//
//  LpfPointModel.h
//  LpfLineChart
//
//  Created by roc on 16/8/15.
//  Copyright © 2016年 roc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LpfPointModel : NSObject
@property (nonatomic, assign)  CGPoint lastPoint;
@property (nonatomic, assign)  CGPoint currentPoint;
@property (nonatomic, assign)  CGPoint nextPoint;

- (void)resume;
@end
