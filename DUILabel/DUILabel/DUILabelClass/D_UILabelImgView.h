//
//  D_UILabelImgView.h
//  
//
//  Created by NewM on 13-4-22.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
#undef RELEASEDICTARRAYOBJ
#define RELEASEDICTARRAYOBJ(_obj)\
[_obj removeAllObjects];\
[_obj release];\
_obj = nil;

#undef RELEASEOBJ
#define RELEASEOBJ(_obj)\
[_obj release];\
_obj = nil;

@interface DUILabelImgView : UIView
{
    id        ctFrame;
    NSString *_imgName;
    CGRect    imgBound;
}
@property (nonatomic, assign)id        ctFrame;
@property (nonatomic, retain)NSString *imgName;
@property (nonatomic, assign)CGRect    imgBound;
@end
