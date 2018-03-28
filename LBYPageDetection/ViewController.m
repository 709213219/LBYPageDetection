//
//  ViewController.m
//  LBYPageDetection
//
//  Created by 叶晓倩 on 2018/3/26.
//  Copyright © 2018年 bill. All rights reserved.
//

#import "ViewController.h"
#import "LBYPageDetection.h"
#import "FirstVC.h"
#import "SecondVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _dataSource = @[@"firstVC", @"secondVC"];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row < _dataSource.count) {
        cell.textLabel.text = _dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0: {
            FirstVC *firstVC = [[FirstVC alloc] init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }
            break;
        case 1: {
            SecondVC *secondVC = [[SecondVC alloc] init];
            [self.navigationController pushViewController:secondVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (BOOL)lby_needPageDetection {
    return NO;
}

@end
