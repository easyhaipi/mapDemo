//
//  DisplayMapRouteViewController.h
//  MapDemo
//
//  Created by hulinEasy on 2017/3/21.
//  Copyright © 2017年 ORCHAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>
@interface DisplayMapRouteViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate>
/** 百度地图View */
@property (nonatomic,strong) BMKMapView *mapView;
@end
