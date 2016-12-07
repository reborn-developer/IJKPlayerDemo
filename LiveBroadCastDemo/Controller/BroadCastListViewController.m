//
//  BroadCastListViewController.m
//  LiveBroadCastDemo
//
//  Created by reborn on 16/10/28.
//  Copyright © 2016年 reborn. All rights reserved.
//

#import "BroadCastListViewController.h"
#import "broadListCell.h"
#import "LiveViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#define SCREEN_WIDTH                      ([[UIScreen mainScreen]bounds].size.width)
#define SCREEN_HEIGHT                     ([[UIScreen mainScreen]bounds].size.height)
#define ALD(x)                            (x * SCREEN_WIDTH/375.0)
#define BroadCastListCellIdentifier       @"BroadCastListCellIdentifier"

@interface BroadCastListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *listArray;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation BroadCastListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直播List";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self requestData];
}

- (void)requestData
{
    NSString *url = @"http://116.211.167.106/api/live/aggregation?uid=40788282&interest=1";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _listArray = [LiveListModel mj_objectArrayWithKeyValuesArray:responseObject[@"lives"]];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    broadListCell *cell = [tableView dequeueReusableCellWithIdentifier:BroadCastListCellIdentifier];
    
    if (cell == nil) {
        cell = [[broadListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BroadCastListCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    [cell configCellWithData:[_listArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewController *liveVC = [[LiveViewController alloc] init];
    liveVC.liveListModel = _listArray[indexPath.row];
    [self.navigationController pushViewController:liveVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ALD(370);
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource =self;
        
    }
    return _tableView;
}

@end
