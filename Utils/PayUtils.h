//
//  PayUtils.h
//  PayDemo
//
//  Created by 张玥 on 2018/12/20.
//  Copyright © 2018 张玥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "DataSigner.h"
NS_ASSUME_NONNULL_BEGIN

@interface PayUtils : NSObject
typedef NS_ENUM(NSInteger, PaymentMethod) {
    PaymentMethodAlipay,
    PaymentMethodWechat,
    PaymentMethodUPPay,
};

+(void)buy:(PaymentMethod)payMethod;
+(void)alipayStateChange:(NSDictionary*)result;
+(void)wechatPayStateChange:(PayResp*)response;
@end

NS_ASSUME_NONNULL_END
