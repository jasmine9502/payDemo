//
//  UIView+TapGesture.h
//  o2
//
//  Created by 张玥 on 2018/12/21.
//  Copyright © 2018 张玥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (AddTapGestureRecognizer)

@property (nonatomic,assign) void(^blockTap)(UITapGestureRecognizer *tapRecognizer);
@property (nonatomic,assign) void(^blockLongPress)(UILongPressGestureRecognizer *longPressRecognizer);

//给view添加长按回调
- (void)addLongPressGestureRecognizerWithDelegate:(id)tapGestureDelegate Block:(void(^)(UILongPressGestureRecognizer *longPressRecognizer))block;

//给view添加点击回调
- (void)addTapGestureRecognizerWithDelegate:(id)tapGestureDelegate Block:(void(^)(UITapGestureRecognizer *tapRecognizer))block;

@end
