//
//  LBYPageDetection.m
//  LBYPageDetection
//
//  Created by 叶晓倩 on 2018/3/26.
//  Copyright © 2018年 bill. All rights reserved.
//

#import "LBYPageDetection.h"

@implementation LBYPageDetection

+ (UIImage *)screenShotsWithView:(UIView *)view scaledToSize:(CGSize)newSize {
    UIImage *image;
    @try {
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
        [view drawViewHierarchyInRect:(CGRect){{0,0}, newSize} afterScreenUpdates:NO];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } @catch (NSException *exception) {
        
    }
    return image;
}

+ (NSString *)maximumColor:(UIImage *)image {
    if (!image || ![image isKindOfClass:[UIImage class]]) return nil;
    
    NSDictionary *colors = [self _colorsOfImage:image];
    
    if (!colors || ![colors isKindOfClass:[NSDictionary class]] || !colors.count) return nil;
    
    NSArray *keys = [colors keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 floatValue] < [obj2 floatValue] ? NSOrderedDescending : NSOrderedAscending;
    }];
    
    return keys.firstObject;
}

+ (CGFloat)accountWithImage:(UIImage *)image color:(NSString *)color {
    if (!image || ![image isKindOfClass:[UIImage class]]) return CGFLOAT_MIN;
    if (!color || ![color isKindOfClass:[NSString class]]) return CGFLOAT_MIN;
    
    CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    CFDataRef pixelData = CGDataProviderCopyData(provider);
    const UInt8 *data = CFDataGetBytePtr(pixelData);
    long dataLength = CFDataGetLength(pixelData);
    int numberOfColorComponents = 4;
    
    int colorCount = 0;
    int detectionCount = 0;
    for (int i = 0; i < dataLength; i += numberOfColorComponents) {
        if (data[i+3] != 0) {
            ++colorCount;
            
            UInt8 blue = data[i];
            UInt8 green = data[i+1];
            UInt8 red = data[i+2];
            NSString *result = [NSString stringWithFormat:@"%d-%d-%d", red, green, blue];
            if ([result isEqualToString:color]) {
                ++detectionCount;
            }
        }
    }
    
    return (colorCount > 0) ? (CGFloat)detectionCount / colorCount : CGFLOAT_MIN;
}

#pragma mark - private method
+ (NSDictionary *)_colorsOfImage:(UIImage *)image {
    if (!image || ![image isKindOfClass:[UIImage class]]) return nil;
    
    CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    CFDataRef pixelData = CGDataProviderCopyData(provider);
    const UInt8 *data = CFDataGetBytePtr(pixelData);
    long dataLength = CFDataGetLength(pixelData);
    int numberOfColorComponents = 4;
    
    NSMutableDictionary *colors = [[NSMutableDictionary alloc] init];
    
    int colorCount = 0;
    for (int i = 0; i < dataLength; i+= numberOfColorComponents) {
        if (data[i+3] != 0) {
            ++colorCount;
            
            UInt8 blue = data[i];
            UInt8 green = data[i+1];
            UInt8 red = data[i+2];
            
            NSString *result = [NSString stringWithFormat:@"%d-%d-%d", red, green, blue];
            if ([colors.allKeys containsObject:result]) {
                colors[result] = @([colors[result] integerValue] + 1);
            } else {
                colors[result] = @(1);
            }
        }
    }
    
    NSMutableDictionary *percents = [NSMutableDictionary dictionaryWithCapacity:colors.count];
    
    [colors enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        percents[key] = @([obj intValue] / (float)colorCount);
    }];
    
    return percents;
}

@end
