//
//  UIViewController+LBYPageDetection.m
//  LBYPageDetection
//
//  Created by 叶晓倩 on 2018/3/26.
//  Copyright © 2018年 bill. All rights reserved.
//

#import "UIViewController+LBYPageDetection.h"
#import <objc/runtime.h>
#import "LBYPageDetection.h"

@implementation UIViewController (LBYPageDetection)

+ (void)load {
    if (!lby_getConfiguration() || ![lby_getConfiguration().allKeys containsObject:@"LBYNeedDetection"] || [lby_getConfiguration()[@"LBYNeedDetection"] boolValue]) {
        Class klass = [self class];
        
        SEL originSel = @selector(viewDidAppear:);
        SEL newSel = @selector(lby_viewDidAppear:);
        Method originMethod = class_getInstanceMethod(klass, originSel);
        Method newMethod = class_getInstanceMethod(klass, newSel);
        method_exchangeImplementations(originMethod, newMethod);
        
        originSel = @selector(viewWillDisappear:);
        newSel = @selector(lby_viewWillDisappear:);
        originMethod = class_getInstanceMethod(klass, originSel);
        newMethod = class_getInstanceMethod(klass, newSel);
        method_exchangeImplementations(originMethod, newMethod);
    }
}

- (void)lby_viewDidAppear:(BOOL)animated {
    if (lby_canDetection(self)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if (![self respondsToSelector:@selector(lby_needPageDetection)] || [[self performSelector:@selector(lby_needPageDetection)] boolValue]) {
#pragma clang diagnostic pop
            
            NSNumber *hasBeen = objc_getAssociatedObject(self, @"lby_hasBeenDetection");
            if (!hasBeen || !hasBeen.boolValue) {
                UIImage *image = [LBYPageDetection screenShotsWithView:self.view scaledToSize:lby_scaleSize(self)];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *color = [LBYPageDetection maximumColor:image];
                    if ([color isKindOfClass:[NSString class]] && color.length) {
                        objc_setAssociatedObject(self, @"lby_maximumColor", color, OBJC_ASSOCIATION_COPY);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            for (NSNumber *number in lby_detectionTimes()) {
                                if ([self respondsToSelector:@selector(pageDetection)]) {
                                    [self performSelector:@selector(pageDetection) withObject:nil afterDelay:number.floatValue];
                                }
                            }
                        });
                    }
                });
            }
        }
    }
    
    [self lby_viewDidAppear:animated];
}

- (void)lby_viewWillDisappear:(BOOL)animated {
    if (lby_canDetection(self)) {
        objc_setAssociatedObject(self, @"lby_hasBeenDetection", @(YES), OBJC_ASSOCIATION_RETAIN);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pageDetection) object:nil];
    }
    
    [self lby_viewWillDisappear:animated];
}

- (void)pageDetection {
    NSString *color = objc_getAssociatedObject(self, @"lby_maximumColor");
    if ([color isKindOfClass:[NSString class]] && color.length) {
        UIImage *image = [LBYPageDetection screenShotsWithView:self.view scaledToSize:lby_scaleSize(self)];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGFloat account = [LBYPageDetection accountWithImage:image color:color];
            dispatch_async(dispatch_get_main_queue(), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                if ([self respondsToSelector:@selector(lby_detectionResult:)]) {
                    [self performSelector:@selector(lby_detectionResult:) withObject:@(account)];
                }
#pragma clang diagnostic pop
            });
        });
    }
}

static NSDictionary *lby_getConfiguration() {
    static NSDictionary *lbyConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lbyConfiguration = [[NSBundle mainBundle] infoDictionary][@"LBYPageDetectionConfiguration"];
    });
    return lbyConfiguration;
}

static BOOL lby_canDetection(NSObject *self) {
    if (lby_getConfiguration() && lby_getConfiguration()[@"LBYIgnoreClasses"] && [lby_getConfiguration()[@"LBYIgnoreClasses"] isKindOfClass:[NSArray class]]) {
        NSArray *ignoreClasses = lby_getConfiguration()[@"LBYIgnoreClasses"];
        for (NSString *class in ignoreClasses) {
            Class klass = NSClassFromString(class);
            if (klass && [self isKindOfClass:klass]) {
                return NO;
            }
        }
    }
    return YES;
}

static CGSize lby_scaleSize(NSObject *self) {
    float scaleSize = 10.0;
    if (lby_getConfiguration() && [lby_getConfiguration().allKeys containsObject:@"LBYScaleSize"]) {
        scaleSize = [lby_getConfiguration()[@"LBYScaleSize"] floatValue];
    }
    
    if (scaleSize <= 0) {
        scaleSize = 10.0;
    }
    
    UIViewController *vc = (UIViewController *)self;
    CGSize size = vc.view.frame.size;
    return CGSizeMake(size.width / scaleSize, size.height / scaleSize);
}

static NSArray *lby_detectionTimes() {
    NSArray *detectionTimes;
    if (lby_getConfiguration() && [lby_getConfiguration().allKeys containsObject:@"LBYDetectionTimes"]) {
        detectionTimes = lby_getConfiguration()[@"LBYDetectionTimes"];
    }
    
    if (![detectionTimes isKindOfClass:[NSArray class]] || !detectionTimes.count) {
        detectionTimes = @[@3];
    }
    
    return detectionTimes;
}


@end
