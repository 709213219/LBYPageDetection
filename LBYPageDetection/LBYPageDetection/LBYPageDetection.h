//
//  LBYPageDetection.h
//  LBYPageDetection
//
//  Created by 叶晓倩 on 2018/3/26.
//  Copyright © 2018年 bill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LBYPageDetection : NSObject

/**
 指定视图进行截屏
 */
+ (UIImage *)screenShotsWithView:(UIView *)view scaledToSize:(CGSize)newSize;

/**
 占比最高的颜色
 */
+ (NSString *)maximumColor:(UIImage *)image;

/**
 获取某个颜色的占比
 */
+ (CGFloat)accountWithImage:(UIImage *)image color:(NSString *)color;

@end
