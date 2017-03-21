//
//  BMKSportNode.h
//  YingYanObjCDemo
//
//  Created by hulinEasy on 2017/3/20.
//  Copyright © 2017年 Daniel Bey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface BMKSportNode : NSObject
//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;

@property (nonatomic, strong) NSDate *startTime;
@property(nonatomic,strong)NSString *title;



@end
