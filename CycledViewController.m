//
//  CycledViewController.m
//  CycledView
//
//  Created by 裕福 on 15/6/29.
//  Copyright (c) 2015年 裕福. All rights reserved.
//

#import "CycledViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CycledView.h"

#define defaultItmesNumber 4
#define defaultMarge 25.0
#define defaultHeight [UIScreen mainScreen].bounds.size.width
#define defaultWideth [UIScreen mainScreen].bounds.size.width
#define kScaleFactor (1.0/1.5)

@implementation CycledViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        numberOfItems = defaultItmesNumber;
        itemViews= [[NSMutableArray alloc]initWithCapacity:0];
        centers = [[NSMutableArray alloc]initWithCapacity:0];
        [self setup];
    }
    return self;
}
-(void)dealloc{
    itemViews = nil;
    centers = nil;
}
-(void)setup{
    for (int i = 0;i< numberOfItems ;i++) {
        CycledView *item=[[CycledView alloc] initWithTitle:[NSString stringWithFormat:@"Image %d",i] andImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]] andDelegate:self];
        
        [itemViews addObject:item];
        [self addSubview:item];
    }
    [self caculateInitState];
    
}

-(void)caculateInitState{
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
        
        CycledView *item = [itemViews objectAtIndex:itemIndex];
        item.frame = CGRectMake(0, 0, defaultWideth, defaultHeight);;
        item.center = center;
        item.controller = self;
        
        item.transform = CGAffineTransformScale(CGAffineTransformIdentity, kScaleFactor+0.1*itemIndex,kScaleFactor+0.1*itemIndex);
        center.y -= defaultMarge;
        
        [UIView setAnimationsEnabled:YES];
        [self addSubview:item];
        item.userInteractionEnabled = FALSE;
        if (itemIndex==numberOfItems-1) {
            item.userInteractionEnabled = TRUE;
        }
    }
    for (CycledView *item in itemViews) {
        [centers addObject:[NSValue valueWithCGPoint:item.center]];
    }
    [self reloadViews];
    
}
-(void)reloadViews{
    CGPoint center = CGPointZero;
    for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
        //        center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CycledView *item = [itemViews objectAtIndex:itemIndex];
        if (itemIndex != 0) {
            center = [[centers objectAtIndex:itemIndex] CGPointValue];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelay:0.3];
            item.center = center;
            item.transform = CGAffineTransformScale(CGAffineTransformIdentity, kScaleFactor+0.1*itemIndex,kScaleFactor+0.1*itemIndex);
            item.controller = self;
            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelay:0.1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(didStop)];
            center = [[centers objectAtIndex:1] CGPointValue];
            item.center = center;
            item.transform = CGAffineTransformScale(CGAffineTransformIdentity, kScaleFactor+0.1,kScaleFactor+0.1);
            [UIView commitAnimations];
        }
        item.userInteractionEnabled = NO;
        if (itemIndex==numberOfItems-1) {
            item.userInteractionEnabled = YES;
        }
        [self addSubview:item];
    }
}

- (void)didStop
{
    CycledView *view = [itemViews objectAtIndex:0];
    view.hidden = NO;
}

-(void)slideLeft{
    
    CycledView *item  = [itemViews lastObject];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setValue:@"slideleft" forKey:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:item.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(item.center.x-self.bounds.size.width,item.center.y)];
    animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 0.3;
    [animation setDelegate:self];
    
    // 让图层保持动画执行后的状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [item.layer addAnimation:animation forKey:@"position"];
    
}

-(void)slideRight{
    
    CycledView *item  = [itemViews lastObject];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setValue:@"slideright" forKey:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:item.center];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(item.center.x+self.bounds.size.width,item.center.y)];
    animation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = 0.3;
    [animation setDelegate:self];
    
    // 让图层保持动画执行后的状态
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [item.layer addAnimation:animation forKey:@"position"];
    
}

#pragma mark 动画停止执行
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    NSString* value = [theAnimation valueForKey:@"position"];
    if ([value isEqualToString:@"slideup"]||[value isEqualToString:@"slideleft"]||[value isEqualToString:@"slideright"])
    {
        CycledView *item  = [itemViews lastObject];
        item.hidden = YES;
        
        [itemViews removeObject:item];
        [itemViews insertObject:item atIndex:0];
        [self reloadViews];
        return;
    }
}

#pragma mark -
#pragma mark UIPanGestureRecognizer
- (void)handlePanGuesture:(UIPanGestureRecognizer *)sender {
    
    CycledView *panItem = (CycledView *)sender.view;
    if (sender.state ==  UIGestureRecognizerStateChanged) {
        CycledView *view = [itemViews objectAtIndex:0];
        if (view.hidden) {
            return;
        }
        
        CGPoint position = [sender translationInView:self];
        CGPoint center = CGPointMake(sender.view.center.x+position.x , sender.view.center.y+position.y);
        for (NSInteger itemIndex = 1; itemIndex < numberOfItems-1; itemIndex++) {
            CGPoint beforeCenter = [[centers objectAtIndex:itemIndex] CGPointValue];
            CycledView *item= [itemViews objectAtIndex:itemIndex];
            CGFloat x = fabs(beforeCenter.x-center.x);
            CGFloat y = fabs(beforeCenter.y-center.y);
            CGFloat value;
            if (x-y>=0) {
                value = x;
            }else{
                value = y;
            }
            if (value>100) {
                value = 100;
            }
            beforeCenter.y -= value/100.0*defaultMarge;
            item.center = beforeCenter;
            item.transform = CGAffineTransformScale(CGAffineTransformIdentity, kScaleFactor+0.1*itemIndex+value*0.001,kScaleFactor+0.1*itemIndex+value*0.001);
        }
        
        self.slide = SlideOrientation_None;
        if (position.x > 10) {
            self.slide = SlideOrientation_right;
        }else if (position.x < -10) {
            self.slide = SlideOrientation_Left;
        }
        
        sender.view.center = center;
        [sender setTranslation:CGPointZero inView:self];
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        for (int i=0; i<itemViews.count; i++) {
            CycledView *view = [itemViews objectAtIndex:i];
            view.userInteractionEnabled = NO;
        }
        
        CGFloat toggleCenter = CGRectGetMidX(panItem.frame);
        if (self.slide == SlideOrientation_right) {
            [self slideRight];
        }else if (self.slide == SlideOrientation_Left) {
            [self slideLeft];
        }else if (toggleCenter<0) {
            [self slideLeft];
        }else if(toggleCenter>self.frame.size.width){
            [self slideRight];
        }else{
            [self reloadViews];
        }
    }
}


@end
