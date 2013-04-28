//
//  D_UILabel.h
//  
//
//  Created by NewM on 13-4-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DUILabel;
typedef DUILabel*(^DUILabelC)(id key,...);
typedef DUILabel*(^DUILabelF)(id key,...);
typedef DUILabel*(^DUILabelI)(id key,...);
typedef DUILabel*(^DUILabelAI)(id key,...);


#undef RELEASEDICTARRAYOBJ
#define RELEASEDICTARRAYOBJ(_obj)\
[_obj removeAllObjects];\
[_obj release];\
_obj = nil;

#undef RELEASEOBJ
#define RELEASEOBJ(_obj)\
[_obj release];\
_obj = nil;

@interface DUILabel : UILabel
{
    long    _chartSpacing;//字间距
    CGFloat _linesSpacing;//行间距
    
}

@property (nonatomic, assign)CGFloat linesSpacing;
@property (nonatomic, assign)long    chartSpacing;
@property (nonatomic, assign)BOOL    needCoretext;//是否需要coretext


- (DUILabelC)COLOR;//loc,lenght,color
- (DUILabelF)FONT;//loc,lenght,size
- (DUILabelI)IMG;//name,x,y,width,height
- (DUILabelAI)IMGA;//name,loc,width,height

@end
