//
//  SecondVC.m
//  LBYPageDetection
//
//  Created by 叶晓倩 on 2018/3/27.
//  Copyright © 2018年 bill. All rights reserved.
//

#import "SecondVC.h"

@interface SecondVCCell: UICollectionViewCell
{
    UIImageView *_imageView;
}

- (void)setImage:(NSString *)imageStr;

@end

@implementation SecondVCCell

- (void)dealloc {
    NSLog(@"SecondVCCell Dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(NSString *)imageStr {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageStr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = [UIImage imageWithData:data];
        });
    });
}

@end

@interface SecondVC () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray *_dataSource;
    UICollectionView *_collectionView;
}

@end

@implementation SecondVC

- (void)dealloc {
    NSLog(@"SecondVC Dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = @[@"http://t.388g.com/uploads/allimg/160711/5-160G10U313.jpg", @"http://pic60.nipic.com/file/20150207/11284670_083602732000_2.jpg", @"http://pic2.ooopic.com/13/45/00/33b1OOOPIC3a.jpg", @"http://pic8.nipic.com/20100801/387600_002750589396_2.jpg", @"http://pic36.photophoto.cn/20150716/0005018365454062_b.png", @"http://pic28.photophoto.cn/20130827/0005018376937114_b.jpg", @"http://pic26.photophoto.cn/20130323/0005018467298586_b.jpg", @"http://img17.3lian.com/201612/20/37494c35be42137c1fb6b5b8e6912f44.png", @"http://c.hiphotos.baidu.com/zhidao/pic/item/4d086e061d950a7bc06026dd08d162d9f2d3c956.jpg", @"http://pic28.photophoto.cn/20130830/0005018373595008_b.jpg", @"http://d.hiphotos.baidu.com/zhidao/pic/item/0bd162d9f2d3572c5a387f618c13632763d0c3b1.jpg"];
    
    CGFloat wh = (CGRectGetWidth(self.view.frame) - 10) / 2.0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(wh, wh);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[SecondVCCell class] forCellWithReuseIdentifier:@"secondcell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondVCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"secondcell" forIndexPath:indexPath];
    if (indexPath.row < _dataSource.count) {
        [cell setImage:_dataSource[indexPath.row]];
    }
    return cell;
}

#pragma mark - LBYPageDetection
- (void)lby_detectionResult:(NSNumber *)account {
    NSLog(@"Second ======= %@", account);
}

@end
