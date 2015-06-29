//
//  CycledView.h
//  CycledView
//
//  Created by 裕福 on 15/6/29.
//  Copyright (c) 2015年 裕福. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycledViewController.h"
@class CycledViewController;
@interface CycledView : UIView
{
    NSString *_bottomTitle;
    UIPanGestureRecognizer *_panGuesture;
    UIImage *_image;
}
@property(nonatomic,strong)CycledViewController *controller;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,retain) UIImageView *backgroundImage;

-(id)initWithTitle:(NSString *)title andImage:(UIImage *)img andDelegate:(id)aDelegate;
@end
