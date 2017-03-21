//
//  DisplayMapRouteViewController.m
//  MapDemo
//
//  Created by hulinEasy on 2017/3/21.
//  Copyright © 2017年 ORCHAN. All rights reserved.
//

#import "DisplayMapRouteViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI/BMKMapView.h>

#import "BMKSportNode.h"
#import "FileHelper.h"
@interface DisplayMapRouteViewController ()
/** 轨迹线 */
@property (nonatomic, strong) BMKPolyline *polyLine;
@end

@implementation DisplayMapRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化地图窗口
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    
    // 设置MapView的一些属性
    [self setMapViewProperty];
    
    [self.view addSubview:self.mapView];
    
    [self showRoute];
}
/**
 *  设置 百度MapView的一些属性
 */
- (void)setMapViewProperty
{
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
 
    // 允许旋转地图
    self.mapView.rotateEnabled = YES;
    
    // 显示比例尺
    //    self.bmkMapView.showMapScaleBar = YES;
    //    self.bmkMapView.mapScaleBarPosition = CGPointMake(self.view.frame.size.width - 50, self.view.frame.size.height - 50);
    
    // 定位图层自定义样式参数
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    displayParam.locationViewImgName = @"walk";
    [self.mapView updateLocationViewWithParam:displayParam];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
       
    self.navigationController.navigationBar.barStyle    = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 显示路径
 */
- (void)showRoute
{
 
    
    NSString *recordPath = [FileHelper filePathWithNameTitle:self.title];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:recordPath];
    NSArray * recordsArray = [dic objectForKey:@"sportNodes"];

    // 去除经纬度为(0,0)的点 将剩余的轨迹点存储在poisWithoutZero中
    NSMutableArray *poisWithoutZero = [[NSMutableArray alloc] init]; ;
    for (NSDictionary *dic  in recordsArray) {
        NSNumber *longitude = [dic objectForKey:@"longitude"];
        NSNumber *latitude = [dic  objectForKey:@"latitude"];
        BMKSportNode *node = [[BMKSportNode alloc] init];
        node.coordinate = CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue]);
        node.title = [dic objectForKey:@"distance"];
        if (fabs(longitude.doubleValue - 0) < 0.001 && fabs(latitude.doubleValue - 0) < 0.001) {
            continue;
        }
        [poisWithoutZero addObject:node];
    }
    
    
    // 手动分配内存存储轨迹点，并获取最小经度minLon、最大经度maxLon、最小纬度minLat、最大纬度maxLat
    CLLocationCoordinate2D *locations = malloc([poisWithoutZero count] * sizeof(CLLocationCoordinate2D));
    CLLocationDegrees minLon = 180.0;
    CLLocationDegrees maxLon = -180.0;
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees maxLat = -90.0;
    for (int i = 0; i < [poisWithoutZero count]; i++) {
        BMKSportNode *node = [poisWithoutZero objectAtIndex:i];
        //        NSArray *point = [poisWithoutZero objectAtIndex:i];
        NSNumber *longitude = @(node.coordinate.longitude);
        NSNumber *latitude = @(node.coordinate.latitude);
        minLon = MIN(minLon, longitude.doubleValue);
        maxLon = MAX(maxLon, longitude.doubleValue);
        minLat = MIN(minLat, latitude.doubleValue);
        maxLat = MAX(maxLat, latitude.doubleValue);
        
        locations[i] = CLLocationCoordinate2DMake(latitude.doubleValue,longitude.doubleValue);
    }
    
    // 根据轨迹点生成轨迹线
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:locations count:[poisWithoutZero count]];
    
    // 获取轨迹的中心点和经纬度范围，确定轨迹的经纬度区域
    CLLocationCoordinate2D centerCoord = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5f, (minLon + maxLon) * 0.5f);
    BMKCoordinateSpan viewSapn;
    // 经纬度范围乘以一个大于1的系数，以在绘制轨迹时留出边缘部分
    viewSapn.longitudeDelta = (maxLon - minLon) * 1.2;
    viewSapn.latitudeDelta = (maxLat - minLat) * 1.2;
    BMKCoordinateRegion viewRegion;
    viewRegion.center = centerCoord;
    viewRegion.span = viewSapn;
    
    // 回到主线程，绘制轨迹线
    dispatch_async(dispatch_get_main_queue(), ^{
        if (poisWithoutZero.count > 1) {
            // 设定当前地图的显示范围
            [_mapView setRegion:viewRegion animated:YES];
            // 向地图窗口添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法来生成标注对应的View
            [_mapView addOverlay:polyline];
        } else {
            NSLog(@"指定轨迹的轨迹点少于两个，无法绘制轨迹");
        }
    });
    
    free(locations);
    
    
}



// BMKMapViewDelegate协议中添加轨迹线时调用该方法，根据overlay生成对应的View
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}
-(void)dealloc
{
    self.mapView = nil;
}
@end
