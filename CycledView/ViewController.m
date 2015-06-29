//
//  ViewController.m
//  CycledView
//
//  Created by 裕福 on 15/6/29.
//  Copyright (c) 2015年 裕福. All rights reserved.
//

#import "ViewController.h"
#import "CycledViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CycledViewController *view = [[CycledViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
