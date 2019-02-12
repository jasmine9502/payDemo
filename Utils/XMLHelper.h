//
//  XMLHelper.h
//  PayDemo
//
//  Created by 张玥 on 2018/12/24.
//  Copyright © 2018 张玥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMLHelper : NSObject<NSXMLParserDelegate>{
    
    //解析器
    NSXMLParser *xmlParser;
    //解析元素
    NSMutableArray *xmlElements;
    //解析结果
    NSMutableDictionary *dictionary;
    //临时串变量
    NSMutableString *contentString;
}
//输入参数为xml格式串，初始化解析器
-(void)startParse:(NSData *)data;
//获取解析后的字典
-(NSMutableDictionary*) getDict;


@end

NS_ASSUME_NONNULL_END
