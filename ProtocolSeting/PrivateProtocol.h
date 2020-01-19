//
//  PrivateProtocol.h
//  ProtocolSeting
//
//  Created by DLK on 2020/1/16.
//  Copyright © 2020 DLK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrivateProtocol : NSObject

-(NSArray *)protocolStateList;//返回协议状态列表

-(void)showOrSetProtocol:(NSString *)protocolStr;//显示协议或者设置协议

@end

NS_ASSUME_NONNULL_END
