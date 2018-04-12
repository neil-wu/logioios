//
//  ViewController.m
//  logioios
//
//  Created by appdev on 2018/4/12.
//  Copyright © 2018年 test. All rights reserved.
//

#import "ViewController.h"
#import "LogIO.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    logio_init("192.168.2.63", "28777");
    
    CGRect rect = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50);
    UIButton* btn = [[UIButton alloc] initWithFrame: rect];
    [btn addTarget:self action:@selector(onTapBtn) forControlEvents: UIControlEventTouchUpInside];
    [btn setTitle:@"log" forState: UIControlStateNormal];
    [btn setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

-(void) onTapBtn {
    static int cnt = 0;
    logio(@"btn tapped %d", cnt++);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
