//
//  ViewController.m
//  ProtocolSeting
//
//  Created by DLK on 2020/1/16.
//  Copyright © 2020 DLK. All rights reserved.
//

#import "ViewController.h"
#import <AVKit/AVKit.h>
#import <UserNotifications/UserNotifications.h>
#import <Photos/PHPhotoLibrary.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CoreLocation.h>

#import "PrivateProtocol.h"

@interface ViewController ()<UNUserNotificationCenterDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArry;
@property(nonatomic,strong) PrivateProtocol *protocol;
@end

@implementation ViewController
{
    CLLocationManager*   locationManager;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return _dataArry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *model=_dataArry[indexPath.row];
    NSArray *arr= model.allKeys;
    cell.textLabel.text=arr[0];
    
    return cell;
}
-(void)todoSome{
    NSLog("todoString");
    NSLog("source tree");
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *model=_dataArry[indexPath.row];
       NSArray *arr= model.allKeys;
    [_protocol showOrSetProtocol:arr[0]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _protocol=[[PrivateProtocol alloc]init];
   _dataArry=[[NSMutableArray alloc]initWithArray:[_protocol protocolStateList]] ;
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
}

@end
