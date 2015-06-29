//
//  CycledViewController.h
//  CycledView
//
//  Created by 裕福 on 15/6/29.
//  Copyright (c) 2015年 裕福. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SlideOrientation) {
    SlideOrientation_Left,
    SlideOrientation_right,
    SlideOrientation_None
};

@interface CycledViewController : UIView<UIGestureRecognizerDelegate>
{
    NSInteger numberOfItems;
    NSMutableArray *itemViews;  //views
    NSMutableArray *centers;    //center point for each item view;
    NSMutableArray *lastCenters;
}

@property (nonatomic) SlideOrientation slide;

@end
