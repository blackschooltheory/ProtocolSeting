//
//  PrivateProtocol.m
//  ProtocolSeting
//
//  Created by DLK on 2020/1/16.
//  Copyright © 2020 DLK. All rights reserved.
//

#import "PrivateProtocol.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CoreLocation.h>

#import <Photos/PHPhotoLibrary.h>

#import <UserNotifications/UserNotifications.h>

#import <AVKit/AVKit.h>

@interface PrivateProtocol ()<UNUserNotificationCenterDelegate,CLLocationManagerDelegate>

@end

@implementation PrivateProtocol
{
    CLLocationManager*   locationManager;
}

-(void)jumpSeting{
    NSURL *appSettingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:appSettingURL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:appSettingURL options:@{} completionHandler:^(BOOL success) {}];
        } else {
            // Fallback on earlier versions
        }
     }
}

-(void)showOrSetProtocol:(NSString *)protocolStr{
    if ([protocolStr isEqualToString:@"Location"]) {
        BOOL enable = [CLLocationManager locationServicesEnabled];
           CLAuthorizationStatus state = [CLLocationManager authorizationStatus];
           if (!enable || 2 > state) {// 尚未授权位置权限
               NSLog(@"系统位置权限授权弹窗");
                          // 系统位置权限授权弹窗
               locationManager = [[CLLocationManager alloc] init];
               locationManager.delegate = self;
               [locationManager requestAlwaysAuthorization];
               [locationManager requestWhenInUseAuthorization];
           }
           else {
               [self jumpSeting];
           }
        
    }else if ([protocolStr isEqualToString:@"Photo"]){
        
          PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status<2) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 用户点击 "OK"
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 用户点击 不允许访问
                    });
                }
            }];
        }else{
            [self jumpSeting];
        }
        
        
        
    }else if ([protocolStr isEqualToString:@"Video"]){
        
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authorizationStatus<2) {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted){ NSLog(@"允许了");
                        }
                    else{
                        NSLog(@"拒绝了");
                        
                    }
                    }];
        }else{
            [self jumpSeting];
        }
        
    }else if ([protocolStr isEqualToString:@"Audio"]){
        NSString * mediaType = AVMediaTypeAudio;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if (authorizationStatus<2) {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if (granted){ NSLog(@"允许了");
                        }
                    else{
                        NSLog(@"拒绝了");
                        
                    }
                    }];
        }else{
            [self jumpSeting];
        }
        
        
    }
    
}
-(NSArray *)protocolStateList{
    NSMutableArray *protocolArr=[[NSMutableArray alloc]init];
//    [self notificationProtocolState:protocolArr];
    [protocolArr addObject:[self locationProtocolState]];
     [protocolArr addObject:[self photoProtocolState]];
    [protocolArr addObject:[self videoProtocolState]];
    [protocolArr addObject:[self audioProtocolState]];
    return protocolArr;
}
-(NSDictionary *)locationProtocolState{
    //返回定位状态
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse   || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        return @{@"Location":@"YES"};
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        return @{@"Location":@"NO"};
        //定位不能用
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        return @{@"Location":@"NO"};
    }
    return @{@"Location":@"NO"};
}
-(NSDictionary *)photoProtocolState{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status==PHAuthorizationStatusAuthorized) {
        //有权限
        return @{@"Photo":@"YES"};
    }else{
        //无权限
         return @{@"Photo":@"NO"};
    }
    
      return @{@"Photo":@"NO"};
}
//通知权限暂不处理
//-(void)notificationProtocolState:(NSMutableArray*)protocolList{
//
//    if (@available(iOS 10 , *))
//    {
//         [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//            if (settings.authorizationStatus == UNAuthorizationStatusDenied)
//            {
//                // 没权限
//                [protocolList addObject:@{@"notification":@"NO"}];
//            }else{
//                [protocolList addObject:@{@"notification":@"YES"}];
//            }
//
//        }];
//    }
//    else if (@available(iOS 8 , *))
//    {
//        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
//
//        if (setting.types == UIUserNotificationTypeNone) {
//            // 没权限
//             [protocolList addObject:@{@"notification":@"NO"}];
//        }else{
//             [protocolList addObject:@{@"notification":@"YES"}];
//        }
//    }
//}

-(NSDictionary *)videoProtocolState{
    NSString * mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                // 不允许弹出提示框
                if (authorizationStatus == AVAuthorizationStatusAuthorized) {
                    //有权限
                    return @{@"Video":@"YES"};
                }else{
                    // 这里是摄像头可以使用的处理逻辑
                    NSLog(@"可以使用");
                    //无权限
                     return @{@"Video":@"NO"};
                }
      return @{@"Video":@"NO"};
}

-(NSDictionary *)audioProtocolState{
    NSString * mediaType = AVMediaTypeAudio;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                       // 不允许弹出提示框
                       if (authorizationStatus == AVAuthorizationStatusAuthorized) {
                           //有权限
                           return @{@"Audio":@"YES"};
           
                       }else{
                           // 这里是摄像头可以使用的处理逻辑
                           NSLog(@"可以使用");
                           //无权限
                            return @{@"Audio":@"NO"};
                       }
             return @{@"Audio":@"NO"};
}

@end
