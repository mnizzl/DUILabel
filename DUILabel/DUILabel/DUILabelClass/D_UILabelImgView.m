//
//  D_UILabelImgView.m
//  
//
//  Created by NewM on 13-4-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "D_UILabelImgView.h"
#import <CoreText/CoreText.h>


@implementation DUILabelImgView
@synthesize imgName = _imgName;
@synthesize ctFrame = _ctFrame;
@synthesize imgBound = _imgBound;


- (void)dealloc
{

    self.imgName = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context,
                       CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.frame.size.height),
                                              1.f,
                                              -1.f));


    
    UIImage *img = [UIImage imageNamed:_imgName];
    CGContextDrawImage(context, _imgBound, img.CGImage);
    
}



@end
