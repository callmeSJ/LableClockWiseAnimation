//
//  ViewController.m
//  LableRevolve
//
//  Created by SJ on 16/6/3.
//  Copyright © 2016年 SJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)VView *VView;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
}

#pragma mark 创建视图

-(void)createView{
    _VView = [[VView alloc]init];
    [_VView setFrame:CGRectMake(0, 0, 320, 400)];
    [_VView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_VView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
