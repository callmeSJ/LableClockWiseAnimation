//
//  VView.m
//  LableRevolve
//
//  Created by SJ on 16/6/3.
//  Copyright © 2016年 SJ. All rights reserved.
//

#import "VView.h"


@interface VView()
{
    int countInside ;
    int countOutside;
    BOOL flagInside ;
    BOOL flagOutside;
    
}
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)NSMutableArray *outsideArray;
@property(nonatomic,strong)NSMutableArray *outsideArray2;
@property(nonatomic,strong)NSMutableArray *insideArray;
@property(nonatomic,strong)NSMutableArray *insideArray2;


@end

@implementation VView


-(void)drawRect:(CGRect)rect{
    [self createLable];
    [self createButton];
}

-(void)dealloc{
    [_timer invalidate];
}

#pragma mark 创建Lable
-(void)createLable{
    //单纯设置边框颜色可以不用写这么麻烦，直接在下面写一个UIColor类然后.CGColor就可以
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColor = CGColorCreate(colorSpace, (CGFloat[]){0,1,1,1});
    
    float x = 20;
    float y = 150;
    float lineSpace = 75;
    float rowSpace = 40;
    int lableInt = 1;
    NSString *lableStr = @"Lable";
    for (int i = 0; i < 4; i++) {
        y = y + rowSpace;
        for(int j = 0 ; j < 4 ; j++){
            NSString *lableStr1 = lableStr;
            NSString *lableAddStr = [NSString stringWithFormat:@"%@%d",lableStr1,lableInt];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake((x + lineSpace *j), y, 65, 30)];
            [lable setText:lableAddStr];
            [lable setTag:(lableInt + 100)];
            [lable setTextAlignment:NSTextAlignmentCenter];
            [lable.layer setBorderColor:borderColor];
            [lable.layer setBorderWidth:1.5];
            [lable.layer setMasksToBounds:YES];
            [lable.layer setCornerRadius:5.0];
            lableInt++;
            [self addSubview:lable];
        }
    }
    
    [self array];
    
//  查看lable所设的tag跟text
//    for (int i = 1; i < lableInt; i++) {
//        UILabel *l = [self viewWithTag:(100 + i)];
//        NSLog(@"lable.text = %@,lable.tag = %ld, i = %d ",l.text,(long)l.tag,i);
//    }
}

#pragma mark 给外圈数组跟内圈数组赋值
-(void)array{
//    _insideArray = [[NSMutableArray alloc]init];
//    _outsideArray = [[NSMutableArray alloc]init];
    
    //简单的放到数组里面
//    for (int i = 101; i < 116; i++) {
//        if(i ==106 ||i ==107 || i ==110 ||i ==111 ){
//            NSString *iInside = [NSString stringWithFormat:@"%d",i];
//            [_insideArray addObject:iInside];
//        }else{
//            NSString *iOutside = [NSString stringWithFormat:@"%d",i];
//            
//            [_outsideArray addObject:iOutside];
//            
//        }
//        
//    }

#warning 也算是个笨办法= =
    
    _insideArray = [[NSMutableArray alloc]initWithObjects:@"106",@"110",@"111",@"107", nil];
    _insideArray2 = [[NSMutableArray alloc]initWithObjects:@"106",@"107",@"111",@"110", nil];

    
    _outsideArray = [[NSMutableArray alloc]initWithObjects:@"101",@"102",@"103",@"104",@"108",@"112",@"116",@"115",@"114",@"113",@"109",@"105", nil];
   _outsideArray2 = [[NSMutableArray alloc]initWithObjects:@"101",@"105",@"109",@"113",@"114",@"115",@"116",@"112",@"108",@"104",@"103",@"102", nil];
}



#pragma mark 创建一个开始button
-(void)createButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
     btn.frame = CGRectMake(50, 50, 80, 40);
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createTimer:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

#pragma mark 创建定时器
-(void)createTimer:(id)sender{
#warning 这里少什么自己想去
    NSLog(@"创建动画");
    countInside = 0;
    flagInside = true;
#warning 我好像说过要一个3秒一动，一个2秒一动，你就写一个定时器倒是真省事儿~不过逻辑还可以，不用改了，但是没有整合思想，下面同样逻辑的动画太多了，完全可以整合到一个方法里面
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

#pragma mark 定时的方法
-(void)timerAction:(id)sender{
    
    if(flagInside == true){
    [self lableAnimationInsideAntiClockwise];
        countInside++;
        if(countInside == 4){
            countInside = 0;
            flagInside = !flagInside;
        }
    }else{
        [self lableAnimationInsideClockwise];
        countInside++;
        if(countInside == 4){
            countInside = 0;
            flagInside = !flagInside;
        }

    }
    
    if(flagOutside == true){
        [self lableAnimationOutsideClockwise];
        countOutside ++;
        if(countOutside == 12){
            countOutside = 0;
            flagOutside = !flagOutside;
        }
    }else{
        [self lableAnimationOutsideAntiClockwise];
        countOutside++;
        if(countOutside == 12){
            countOutside = 0;
            flagOutside = !flagOutside;
        }
    }
    
}

#pragma mark Lable动画的方法

//内圈动画逆时针
-(void)lableAnimationInsideAntiClockwise{
    UILabel *tempLable;
    //目前的一个问题，第一个lable的tag改变后，等到最后一个即107想到106原来位置的时候，这时候tag=106的lable已经没有。
    //然后 我就开挂直接用了原来的值。。
    tempLable = [self viewWithTag:106];
    CGFloat x = tempLable.frame.origin.x;
    CGFloat y = tempLable.frame.origin.y;
    float w = tempLable.frame.size.width;
    float h = tempLable.frame.size.height;
    

        for(int j =0; j<_insideArray.count;j++){
            int iTag = [_insideArray[j] intValue];
            UILabel *la = [self viewWithTag:iTag];
            [la.layer setBorderColor:[UIColor redColor].CGColor];
        }
        [UIView animateWithDuration:1 animations:^{
#warning 不是必须的动画算法放到动画Block外面去，不要在动画里面占用时间，会导致动画时间都偏差
            for(int i = 0; i <_insideArray.count ; i++){
                int iTag = [_insideArray[i] intValue];
                int iTagNext = 0;
                if(i == 3){
                iTagNext = [_insideArray[0] intValue];
                }
                else {
                iTagNext = [_insideArray[i+1] intValue];
                }
                if(i == 0){
                    UILabel *la = [self viewWithTag:iTag];
            
                UILabel *laNext = [self viewWithTag:iTagNext];
            

                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                    [laNext setTag:1000];
            
                    [la setTag:iTagNext];

                }else if(i == 3){

                UILabel *la = [self viewWithTag:1000];
                
                [la setFrame:CGRectMake(x, y, w, h)];

                [la setTag:iTagNext];
                }
                else{
                UILabel *la = [self viewWithTag:1000];

                UILabel *laNext = [self viewWithTag:iTagNext];
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1000];
                [la setTag:iTagNext];

                }
              
            }
        } completion:^(BOOL finished) {
        NSLog(@"内圈逆时针");
            
        }];
    
}

//内圈动画顺时针
-(void)lableAnimationInsideClockwise{
    UILabel *tempLable;

    tempLable = [self viewWithTag:106];
    CGFloat x = tempLable.frame.origin.x;
    CGFloat y = tempLable.frame.origin.y;
    float w = tempLable.frame.size.width;
    float h = tempLable.frame.size.height;
    

    for(int j =0; j<_insideArray.count;j++){
        int iTag = [_insideArray[j] intValue];
        UILabel *la = [self viewWithTag:iTag];
        [la.layer setBorderColor:[UIColor greenColor].CGColor];
    }
    [UIView animateWithDuration:1 animations:^{
        for(int i = 0; i <_insideArray2.count ; i++){
            int iTag = [_insideArray2[i] intValue];
            int iTagNext = 0;
            if(i == 3){
                iTagNext = [_insideArray2[0] intValue];
            }
            else {
                iTagNext = [_insideArray2[i+1] intValue];
            }
            if(i == 0){
                UILabel *la = [self viewWithTag:iTag];
                
                UILabel *laNext = [self viewWithTag:iTagNext];
                
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1000];
                
                [la setTag:iTagNext];
                
            }else if(i == 3){
                
                UILabel *la = [self viewWithTag:1000];
                
                [la setFrame:CGRectMake(x, y, w, h)];
                
                [la setTag:iTagNext];
            }
            else{
                UILabel *la = [self viewWithTag:1000];
                
                UILabel *laNext = [self viewWithTag:iTagNext];
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1000];
                [la setTag:iTagNext];
                
            }
           
        }
    } completion:^(BOOL finished) {
        NSLog(@"内圈顺时针");
    }];

}

//外圈动画顺时针
-(void)lableAnimationOutsideClockwise{
    UILabel *tempLable;
    tempLable = [self viewWithTag:101];
    CGFloat x = tempLable.frame.origin.x;
    CGFloat y = tempLable.frame.origin.y;
    float w = tempLable.frame.size.width;
    float h = tempLable.frame.size.height;
    

    for(int j =0; j<_outsideArray.count;j++){
        int iTag = [_outsideArray[j] intValue];
        UILabel *la = [self viewWithTag:iTag];
        [la.layer setBorderColor:[UIColor blueColor].CGColor];
    }

    
    [UIView animateWithDuration:1 animations:^{
        for(int i = 0; i <_outsideArray.count ; i++){
            int iTag = [_outsideArray[i] intValue];
            int iTagNext = 0;
            if(i == 11){
                iTagNext = [_outsideArray[0] intValue];
            }
            else {
                iTagNext = [_outsideArray[i+1] intValue];
            }
            if(i == 0){
                UILabel *la = [self viewWithTag:iTag];
                
                UILabel *laNext = [self viewWithTag:iTagNext];
                
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1001];
                
                [la setTag:iTagNext];
                
            }else if(i == 11){
                
                UILabel *la = [self viewWithTag:1001];
                
                [la setFrame:CGRectMake(x, y, w, h)];
                
                [la setTag:iTagNext];
            }
            else{
                UILabel *la = [self viewWithTag:1001];
                
                UILabel *laNext = [self viewWithTag:iTagNext];
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1001];
                [la setTag:iTagNext];
                
            }
            
        }
    } completion:^(BOOL finished) {
        NSLog(@"外圈顺时针");
    }];

}

//外圈动画逆时针
-(void)lableAnimationOutsideAntiClockwise{
    UILabel *tempLable;
    tempLable = [self viewWithTag:101];
    CGFloat x = tempLable.frame.origin.x;
    CGFloat y = tempLable.frame.origin.y;
    float w = tempLable.frame.size.width;
    float h = tempLable.frame.size.height;
    
  
    for(int j =0; j<_outsideArray2.count;j++){
        int iTag = [_outsideArray2[j] intValue];
        UILabel *la = [self viewWithTag:iTag];
        [la.layer setBorderColor:[UIColor yellowColor].CGColor];
    }

    
    [UIView animateWithDuration:1 animations:^{
        for(int i = 0; i <_outsideArray2.count ; i++){
            int iTag = [_outsideArray2[i] intValue];
            int iTagNext = 0;
            if(i == 11){
                iTagNext = [_outsideArray2[0] intValue];
            }
            else {
                iTagNext = [_outsideArray2[i+1] intValue];
            }
            if(i == 0){
                UILabel *la = [self viewWithTag:iTag];
                
                UILabel *laNext = [self viewWithTag:iTagNext];
                
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1001];
                
                [la setTag:iTagNext];
                
            }else if(i == 11){
                
                UILabel *la = [self viewWithTag:1001];
                
                [la setFrame:CGRectMake(x, y, w, h)];
                
                [la setTag:iTagNext];
            }
            else{
                UILabel *la = [self viewWithTag:1001];
                
                UILabel *laNext = [self viewWithTag:iTagNext];
                
                [la setFrame:CGRectMake(laNext.frame.origin.x, laNext.frame.origin.y, laNext.frame.size.width, laNext.frame.size.height)];
                [laNext setTag:1001];
                [la setTag:iTagNext];
                
            }
            
        }
    } completion:^(BOOL finished) {
        NSLog(@"外圈逆时针");
    }];
    
}


@end
