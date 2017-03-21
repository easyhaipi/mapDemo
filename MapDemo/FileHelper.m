
//
//  FileHelper.m
//  iOS_2D_RecordPath
//
//  Created by PC on 15/8/3.
//  Copyright (c) 2015年 FENGSHENG. All rights reserved.
//

#import "FileHelper.h"
@implementation FileHelper
/**
 获得文件下的所有的记录数组

 @return <#return value description#>
 */
+ (NSMutableArray *)recordsArray
{
    NSString *path = [FileHelper baseDir];
    
    NSError *error = nil;
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];

    if (error!=nil)
    {
        return nil;
    }
    else
    {
     
        return  (NSMutableArray *)fileArray;
    
    }
}



/**
 文件的基本路径

 @return <#return value description#>
 */
+ (NSString *)baseDir
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   path = [path stringByAppendingPathComponent:@"pathRecords"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];

    return path;
}



/**
 存放文件路径的名称

 @param name <#name description#>
 @return <#return value description#>
 */
+ (NSString *)filePathWithName:(NSString *)name
{
    NSString *path = [FileHelper baseDir];
    
 
    NSString *documentPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",name]];

    //查找文件，如果不存在，就创建一个文件
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        
    
        BOOL isSuccess =  [[NSFileManager defaultManager] createFileAtPath:documentPath contents:nil attributes:nil];
        NSLog(@"---%d",isSuccess);
    }
    

    
    //开始创建文件
    
       return documentPath;
}

/**
 存放文件路径的名称
 
 @param name <#name description#>
 @return <#return value description#>
 */
+ (NSString *)filePathWithNameTitle:(NSString *)nameTitle
{
    NSString *path = [FileHelper baseDir];
    
    
    NSString *documentPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",nameTitle]];
    
    //查找文件，如果不存在，就创建一个文件
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        
        
        BOOL isSuccess =  [[NSFileManager defaultManager] createFileAtPath:documentPath contents:nil attributes:nil];
        NSLog(@"---%d",isSuccess);
    }

    //开始创建文件
    
    return documentPath;
}


/**
 删除文件名称为filename 的文件

 @param filename <#filename description#>
 @return <#return value description#>
 */
+ (BOOL)deleteFile:(NSString *)filename
{
    NSString *path = [FileHelper filePathWithName:filename];
    
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error != nil)
    {
        NSLog(@"%@",error);
    }
    
    return success;
}



@end
