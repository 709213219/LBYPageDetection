# LBYPageDetection

###导入方式:
- 方式一：直接将LBYPageDetection.h.m和UIViewController+LBYPageDetection.h.m拖到项目中。
- 方式二：pod 导入

> pod 'LBYPageDetection', '~> 1.0.0'

###使用姿势:
##### LBYPageDetection原理
导入LBYPageDetection库后，默认情况下在所有UIViewController的viewDidAppear方法中会对当前视图进行截屏分析占比最高的颜色。然后在3s后会再次对当前视图进行截屏并分析前面占比最高的颜色现在占比是多少。通过这个占比可以粗略的得到当前视图的加载完成情况。


#####导入LBYPageDetection库后不想使用怎么办？
在Info.plist文件中添加type为Dictionary的键LBYPageDetectionConfiguration，然后在其下添加key为Boolean类型的键LBYNeedDetection，值设置为NO则不会使用LBYPageDetection库。

#####对某一个类型的UIViewcontroller不使用怎么办? 例如UINavigationController和UITabBarController
同样在LBYPageDetectionConfiguration添加类型为Array的键LBYIgnoreClasses，在LBYIgnoreClasses下添加需要忽略的类。

#####对一个类不使用怎么办?
在该类中实现lby_needPageDetection方法，并返回NO。

```
- (BOOL)lby_needPageDetection {
    return NO;
}
```

#####截屏后会先对得到的图片压缩10倍再对其进行分析，因为不压缩的话，一张图片几十万个点，太耗时。如果想压缩更大倍数或者更小倍数怎么办？
同样在LBYPageDetectionConfiguration下添加type为Number的键LBYScaleSize，值就是需要压缩的倍数。

#####默认情况下会在视图viewDidAppear 3s后检测其视图加载完成情况，如果想在其他时间点或者多个时间点检测怎么办?
同样在LBYPageDetectionConfiguration下添加type为Array的键LBYDetectionTimes，并在其下添加需要检测的时间点。

#####如果获取视图加载完成情况？即初始颜色的占比值？
在具体的UIViewController类下实现lby_detectionResult:方法，参数就是初始颜色的占比值。

```
- (void)lby_detectionResult:(NSNumber *)account {
    NSLog(@"FirstVC ======= %@", account);
}
```
