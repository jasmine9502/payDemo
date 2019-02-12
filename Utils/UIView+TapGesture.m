//
//  UIView+TapGesture.m
//  o2
//
//  Created by 张玥 on 2018/12/21.
//  Copyright © 2018年 张玥. All rights reserved.
//

#import "UIView+TapGesture.h"

#import <objc/runtime.h>

@implementation UIView (AddTapGestureRecognizer)

//--------------------  start 长按  --------------------
- (void)addLongPressGestureRecognizerWithDelegate:(id)tapGestureDelegate Block:(void(^)(UILongPressGestureRecognizer*))block{
    self.blockLongPress = block;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onlongTap:)];
    [self addGestureRecognizer:longTap];
    if (tapGestureDelegate) {
        longTap.delegate = tapGestureDelegate;
    }
    self.userInteractionEnabled = YES;
}

- (void)onlongTap:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state==UIGestureRecognizerStateBegan){
        if (self.blockLongPress) {
            self.blockLongPress(gesture);
        }
    }
}

- (void)setBlockLongPress:(void (^)(UILongPressGestureRecognizer* longPressRecognizer))block{
    objc_setAssociatedObject(self, @selector(blockLongPress), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UILongPressGestureRecognizer* longPressRecognizer))blockLongPress{
    return objc_getAssociatedObject(self, @selector(blockLongPress));
}
//--------------------  end 长按  --------------------


//--------------------  start 点击  --------------------
- (void)addTapGestureRecognizerWithDelegate:(id)tapGestureDelegate Block:(void (^)(UITapGestureRecognizer*))block {
    self.blockTap = block;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    [self addGestureRecognizer:tag];
    if (tapGestureDelegate) {
        tag.delegate = tapGestureDelegate;
    }
    self.userInteractionEnabled = YES;
}

- (void)onClick:(UITapGestureRecognizer*)gesture  {
    if (self.blockTap) {
        self.blockTap(gesture);
    }
}

- (void)setBlockTap:(void (^)(UITapGestureRecognizer *tapRecognizer))block{
    objc_setAssociatedObject(self, @selector(blockTap), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UITapGestureRecognizer *tapRecognizer))blockTap{
    return objc_getAssociatedObject(self, @selector(blockTap));
}
//--------------------  end 点击  --------------------
@end

