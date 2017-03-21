//
//  RecordListViewController.m
//  MapDemo
//
//  Created by hulinEasy on 2017/3/21.
//  Copyright © 2017年 ORCHAN. All rights reserved.
//  历史记录列表

#import "RecordListViewController.h"
#import "FileHelper.h"
#import "DisplayMapRouteViewController.h"

/// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
/// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface RecordListViewController ()<UITableViewDelegate,UITableViewDataSource>

//当前文件夹路径下的所有plist文件
@property(nonatomic,strong)NSArray *filesArray;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.view.backgroundColor = [UIColor redColor];
  
    self.filesArray = [FileHelper recordsArray];
    [self.tableView reloadData];
  

}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filesArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.textLabel.text = [self.filesArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileName = [self.filesArray objectAtIndex:indexPath.row];
    DisplayMapRouteViewController *vc = [[DisplayMapRouteViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = fileName;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
