//
//  FirstVC.m
//  LBYPageDetection
//
//  Created by 叶晓倩 on 2018/3/27.
//  Copyright © 2018年 bill. All rights reserved.
//

#import "FirstVC.h"
#import <WebKit/WebKit.h>

@interface FirstVC ()
{
    WKWebView *_webView;
}

@end

@implementation FirstVC

- (void)dealloc {
    NSLog(@"FirstVC Dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lby_detectionResult:(NSNumber *)account {
    NSLog(@"FirstVC ======= %@", account);
}

@end
