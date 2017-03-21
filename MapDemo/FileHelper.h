//
//  FileHelper.h
//  iOS_2D_RecordPath
//
//  Created by PC on 15/8/3.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//  文件管理工具

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+ (NSString *)filePathWithName:(NSString *)name;

+ (NSMutableArray *)recordsArray;

+ (BOOL)deleteFile:(NSString *)filename;
+ (NSString *)filePathWithNameTitle:(NSString *)nameTitle;
@end
