//
//  CycledView.m
//  CycledView
//
//  Created by 裕福 on 15/6/29.
//  Copyright (c) 2015年 裕福. All rights reserved.
//

#import "CycledView.h"

@implementation CycledView

-(id)initWithTitle:(NSString *)atitle andImage:(UIImage *)img andDelegate:(id)aDelegate{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        _controller = aDelegate;
        _bottomTitle = atitle;
        _image = img;
        [self setup];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(20, 0, self.bounds.size.width-40, self.bounds.size.height-50);
    _backgroundImage = [[UIImageView alloc] initWithFrame:frame];
    _backgroundImage.image = _image;
    _backgroundImage.layer.cornerRadius = 5;
    _backgroundImage.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_backgroundImage];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel setFrame:CGRectMake(0, self.frame.size.height - 50 , self.frame.size.width, 50)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = _bottomTitle;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    
    _panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:_controller
                                                           action:@selector(handlePanGuesture:)];
    _panGuesture.delegate = _controller;
    
    [self addGestureRecognizer:_panGuesture];
    
}
-(void)layoutSubviews
{
    CGRect frame = CGRectMake(20, 0, self.bounds.size.width-40, self.bounds.size.height-50);
    _backgroundImage.frame = frame;
    _backgroundImage.image = _image;
    _titleLabel.frame = CGRectMake(0, self.bounds.size.height - 50 , self.bounds.size.width, 50);
    _titleLabel.text = _bottomTitle;
    
    [super layoutSubviews];
}

@end
