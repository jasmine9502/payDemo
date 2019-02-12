//
//  PayUtils.m
//  PayDemo
//
//  Created by 张玥 on 2018/12/20.
//  Copyright © 2018 张玥. All rights reserved.
//

#import "PayUtils.h"
#import "AlipayOrder.h"
#import "UPPaymentControl.h"
#import "ViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import "XMLHelper.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"
#import "DataMd5.h"
#import "APOrderInfo.h"
#import "APRSASigner.h"
#define WXAppId    @"wx9aa6dee0f6f38c60"  //appId，申请微信账号时获取的
#define WXAppSecret @"" //appSecret 申请app账号时获取
#define WXMCHID @"1511586491"   //申请成功后获取的商户号
#define WXSecret @"ZSkUByL3dLCb7KGkKTWNJgr1IjtKsJ8l"     //申请成功后获取的商户密钥
#define kUrlWechatPay       @"https://api.mch.weixin.qq.com/pay/unifiedorder"
#define PrivateKey   @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCbZA0qJLZSis5tdB3CcBjxN4rZD/t7WQ03Q2TF8q4eHJQIsKbh0cRbaYAKFSWqOD/JkppLJbQhUqpNSOqekoZavu/7eCVkUTXGXWm6YYNWls9KIAOEISkEtrlq8PSACK5g/tIPPvxFuSQpAb8oI5UQyRhqTrmVbWPxTUhHbKHblAKJk6L6GIunQXaG23CxiUSBNjA6zfmEXie40Ycfuf8Ng45v2Qn1SNr9dwfcwM+xX81MZjcV2iAa1VNB0gYVJDv/+GCuLFtr+AeXJlJs44hNoovwjqNt7lTutruERboHhYMPzyG8sQXNgvIMQVqTHrH4TnfMpMhEBjYl/5CONw73AgMBAAECggEBAJVE0CyapZW3B0M3VtsP6bXV4AhRhQdhbQOYNra8P6xnUYDjiPvGELSrLLcCx3Kzo/rTXGoxps6X5UZmdBKtuGh1oHxVVr3+EQUjeMv0nkDQkAGprRcA77E6gfUL0CMps7EzN8AzhgzII8dMiT9apvg/5LdCNp4nPelvjq4l2XneO8U+WIAK1NSABPiwzH8j5OT20mPBYmLi2WyMZ77veANpZCr2fXayyzrYs7Dg1vSebjPJkz5givJLPr/NxdP8OeSIzWIL6fytrwawJtBB77QmtDospdNQpgzsQcRNrZdJKwvOrwXGN6KWxrShnGkeI+PtX6kxE8dWw2MY+EUVouECgYEA32n4u7GKz7xlTEUQbccJD/hTM7+aE5HZYu8RCHOsMvoTU+2qtVuiRB2O7cDEST2DRXYotsmEI7F/pPC7gLe0N1w40NYeig5eEgqVT0wEhaq2zEjI1o+o83pqaVKR0fVpb2Pm3uZGmkPK211d0AwqrSuwrfSj1DaDTcWsN2QSunECgYEAsg4sBqucFsWF4eFhMuyUygc6CL9KmKXqNjsWUJ5m8esV/SD+2G2NvnRPYM4qZyjodk9QZL2LlGwTHSRiSqfEWw48e1/UapwEkrrl9AD5r57dcx0z23d9rKTJ5Y/pRjt8ekEtet/tEEfan5GQlA1AeJXo+UamxNcYwWu2z5T5g+cCgYEAlEz01iqZOSIWn9UsfaJkKpytJimmbh0fjyOgS9r00HXdxJV7/pzQDqUMTlfqM6/IZqBzkDoeI89cKrG91UicMS9fa4jmhr/Yw+MQj62nRs82Pk6GOp7sCIsW/cjYkOV10oIfK5DyBs6/ZnQIpOSeo4rf4ekFowV4jXSMx8v+/pECgYBMitUYRPuDuoPUV3veVV+c/cBP9FPQDTsC9yGfpIiipKm+OEn1phrR7dQVzGrkD+zmty/bLrRrKI6K75Ilf7tkXVlYvBhngAxjO18RJr4vZf7StpINXW+0IN7+BYCFhZr8Pzqa4NpbLlhoUj4xtwSpEeCmEF4urjzhITnkQKmGrwKBgANfYYrAVloCrfrdBP1nOr3e4F0G68KJETXOo1M/sXBDP4APyUhYYSS6km8caciQ3FniFiLnIzHahkOm8Pv18ecqw97K3WSJ4V1+NhNYZfR5y6jnR8d10gLMeG1xEhOQq7hxPu0RRj8JfvME+Kjdj526VAX9uDXo+al28/lFQjkB"

@implementation PayUtils

+(void)buy:(PaymentMethod)payMethod{
    NSDictionary *data;
    [self handleResult:payMethod data:data];
}

+(void)handleResult:(PaymentMethod)payMethod data:(NSDictionary * _Nonnull)data{
    if(payMethod==PaymentMethodAlipay) {
        NSString *rsa2PrivateKey = PrivateKey;
        NSString *rsaPrivateKey = @"";
        APOrderInfo* order = [APOrderInfo new];
        // NOTE: app_id设置
        order.app_id = @"2018073160797778";
        // NOTE: 支付接口名称
        order.method = @"alipay.trade.app.pay";
        // NOTE: 参数编码格式
        order.charset = @"utf-8";
        // NOTE: 当前时间点
        NSDateFormatter* formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        order.timestamp = [formatter stringFromDate:[NSDate date]];
        
        // NOTE: 支付版本
        order.version = @"1.0";
        // NOTE: sign_type 根据商户设置的私钥来决定
        order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
        // NOTE: 商品数据
        order.biz_content = [APBizContent new];
        order.biz_content.body = @"我是测试数据";
        order.biz_content.subject = @"海克斯康业务助手";
        order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
        order.biz_content.timeout_express = @"30m"; //超时时间设置
        order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
        
        //将商品信息拼接成字符串
        NSString *orderInfo = [order orderInfoEncoded:NO];
        NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
        NSLog(@"orderSpec = %@",orderInfo);
        
        // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
        //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
        NSString *signedString = nil;
        APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
        if ((rsa2PrivateKey.length > 1)) {
            signedString = [signer signString:orderInfo withRSA2:YES];
        } else {
            signedString = [signer signString:orderInfo withRSA2:NO];
        }
        
        // NOTE: 如果加签成功，则继续执行支付
        if (signedString != nil) {
            //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
            NSString *appScheme = @"com.leica-geosystems.HxSales1";
            // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                     orderInfoEncoded, signedString];
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    }
    else if(payMethod==PaymentMethodWechat) {
        //获取签名
        NSString *tradeType = @"APP";                                       //交易类型
        NSString *totalFee  = @"1";                                         //交易价格1表示0.01元，10表示0.1元
        NSString *tradeNO   = [self generateTradeNO];//随机字符串变量 这里最好使用和安卓端一致的生成逻辑
        NSString *addressIP = [self fetchIPAddress];
        NSString *orderNo   = [NSString stringWithFormat:@"%ld",time(0)];
        NSString *notifyUrl = @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php";// 交易结果通知网站此处用于测试，随意填写，正式使用时填写正确网站
        //获取SIGN签名
        DataMd5 *adaptor = [[DataMd5 alloc] initWithWechatAppId:WXAppId
                                                    wechatMCHId:WXMCHID
                                                        tradeNo:tradeNO
                                               wechatPartnerKey:WXSecret
                                                       payTitle:@"付款"
                                                        orderNo:orderNo
                                                       totalFee:totalFee
                                                       deviceIp:addressIP
                                                      notifyUrl:notifyUrl
                                                      tradeType:tradeType];

        NSString *string = [[adaptor dic] XMLString];
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        // 这里传入的XML字符串只是形似XML，但不是正确是XML格式，需要使用AF方法进行转义
        session.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        [session.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [session.requestSerializer setValue:kUrlWechatPay forHTTPHeaderField:@"SOAPAction"];
        [session.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
            return string;
        }];
        
        [session POST:kUrlWechatPay
           parameters:string
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {             //  输出XML数据
             NSString *responseString = [[NSString alloc] initWithData:responseObject
                                                              encoding:NSUTF8StringEncoding] ;
             //  将微信返回的xml数据解析转义成字典
             NSDictionary *dic = [NSDictionary dictionaryWithXMLString:responseString];
             // 判断返回的许可
             if ([[dic objectForKey:@"result_code"] isEqualToString:@"SUCCESS"]
                 &&[[dic objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] ) {
                 // 发起微信支付，设置参数
                 PayReq *request = [[PayReq alloc] init];
                 request.openID = [dic objectForKey:@"appid"];
                 request.partnerId = [dic objectForKey:@"mch_id"];
                 request.prepayId= [dic objectForKey:@"prepay_id"];
                 request.package = @"Sign=WXPay";
                 request.nonceStr= [dic objectForKey:@"nonce_str"];
                 
                 // 将当前时间转化成时间戳
                 NSDate *datenow = [NSDate date];
                 NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                 UInt32 timeStamp =[timeSp intValue];
                 request.timeStamp= timeStamp;
                 
                 // 签名加密
                 DataMd5 *md5 = [[DataMd5 alloc] init];
                 request.sign=[md5 createMD5SingForPay:request.openID
                                             partnerid:request.partnerId
                                              prepayid:request.prepayId
                                               package:request.package
                                              noncestr:request.nonceStr
                                             timestamp:request.timeStamp];
                 
                 // 调用微信
                 [WXApi sendReq:request];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
    }
}

+(void)alipayStateChange:(NSDictionary*)result {
    NSString *resultCode = [result objectForKey:@"resultStatus"];
    if([resultCode isEqualToString:@"9000"]) {
        [Util  showHudTipStr:@"支付成功"];
        //通知页面变化
        [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
    }
    else if([resultCode isEqualToString:@"6001"]) {
        [Util  showHudTipStr:@"支付取消"];
    }
    else{
        [Util  showHudTipStr:@"支付失败"];
    }
}

+(void)wechatPayStateChange:(PayResp*)response {
    switch(response.errCode){
        case WXSuccess:
            [Util  showHudTipStr:@"支付成功"];
            //通知页面变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            break;
        case WXErrCodeUserCancel:
            [Util  showHudTipStr:@"支付取消"];
            break;
        default:
            [Util  showHudTipStr:[NSString stringWithFormat:@"支付失败，retcode=%d", response.errCode]];
            break;
    }
}

#pragma mark - 产生随机字符串
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    srand(time(0)); // 此行代码有警告:
#pragma clang diagnostic pop
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - 获取设备ip地址
+ (NSString *)fetchIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

@end
