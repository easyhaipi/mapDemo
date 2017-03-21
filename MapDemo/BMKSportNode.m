//
//  BMKSportNode.m
//  YingYanObjCDemo
//
//  Created by hulinEasy on 2017/3/20.
//  Copyright © 2017年 Daniel Bey. All rights reserved.
//

#import "BMKSportNode.h"

@implementation BMKSportNode
- (NSString *)title
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    return [formatter stringFromDate:self.startTime];
}
- (id)init
{
    self = [super init];
    if (self)
    {
        _startTime = [NSDate date];
       
    }
    
    return self;
}

@end
