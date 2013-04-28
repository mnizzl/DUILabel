//
//  D_UILabel.m
//  
//
//  Created by NewM on 13-4-18.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "D_UILabel.h"
#import <CoreText/CoreText.h>
#import "D_UILabelImgView.h"

@interface DUILabel ()
{
    NSMutableDictionary *_dict_font;
    NSMutableDictionary *_dict_color;
    NSMutableDictionary *_dict_selfImg;
    NSMutableDictionary *_dict_autoImg;
    
    NSMutableArray *_arr_autoImgkey;
    
    //创建AttributeString
    NSMutableAttributedString *string;
    
}

@end

@implementation DUILabel
@synthesize linesSpacing = _linesSpacing;
@synthesize chartSpacing = _chartSpacing;
@synthesize needCoretext = _needCoretext;
- (void)initSelf
{
    
    self.needCoretext = NO;
    
    self.chartSpacing = 0;
    self.linesSpacing = 5.f;

    _dict_font = [[NSMutableDictionary alloc] initWithCapacity:4];
    _dict_color = [[NSMutableDictionary alloc] initWithCapacity:4];
    _dict_selfImg = [[NSMutableDictionary alloc] initWithCapacity:3];
    _dict_autoImg = [[NSMutableDictionary alloc] initWithCapacity:5];
    _arr_autoImgkey = [[NSMutableArray alloc] initWithCapacity:5];
}

- (void)dealloc
{

    RELEASEDICTARRAYOBJ(_dict_color);
    RELEASEDICTARRAYOBJ(_dict_font);
    RELEASEDICTARRAYOBJ(_dict_selfImg)
    RELEASEDICTARRAYOBJ(_dict_autoImg)
    RELEASEDICTARRAYOBJ(_arr_autoImgkey)
    
    RELEASEOBJ(string);

    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)setNeedCoretext:(BOOL)needCoretext
{
    _needCoretext = needCoretext;
    if (needCoretext)
    {
        [self setLineBreakMode:UILineBreakModeCharacterWrap];
        [self autoHeight];
    }else
    {
        [self setLineBreakMode:UILineBreakModeTailTruncation];
    }
    [self setNeedsDisplay];
}

- (void)setLinesSpacing:(CGFloat)linesSpacing
{
    _linesSpacing = linesSpacing;
    [self setNeedsDisplay];
}

- (void)setChartSpacing:(long)chartSpacing
{
    _chartSpacing = chartSpacing;
    [self setNeedsDisplay];
}

- (DUILabelC)COLOR
{
    DUILabelC block = ^DUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        
        NSString *loc = first;
        NSString *length = va_arg(args, NSString *);
        CGColorRef *color = va_arg(args, CGColorRef *);
        
        length = [NSString stringWithFormat:@"%@,%@", loc, length];
        
        [_dict_color setValue:(id)color forKey:length];
        
        [self setNeedsDisplay];
        
        return self;
    
    };
    return [[block copy] autorelease];
}

- (DUILabelF)FONT
{   
    
    DUILabelF block = ^DUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *loc = first;
        NSString *lenght = va_arg(args, NSString *);
        NSString *size = va_arg(args, NSString *);
        loc = [NSString stringWithFormat:@"%@,%@", loc, lenght];
        
        [_dict_font setValue:size forKey:loc];
        
        [self setNeedsDisplay];
        
        return self;
    };
    return [[block copy] autorelease];
}

- (DUILabelAI)IMGA
{
    DUILabelAI block = ^DUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *imgName = first;
        
        NSMutableString *valueString = [[NSMutableString alloc] init];

        NSInteger loc = va_arg(args, NSInteger);
        NSString *width = va_arg(args, NSString *);
        NSString *height = va_arg(args, NSString *);
        
        [valueString appendFormat:@"%d,%@,%@",loc,width,height];
        
        [_arr_autoImgkey addObject:valueString];
        [_dict_autoImg setValue:imgName forKey:valueString];
        

        va_end(args);
        RELEASEOBJ(valueString);
        
        [self setNeedsDisplay];
        return self;
    };
    return [[block copy] autorelease];
}

- (DUILabelI)IMG
{
    DUILabelI block = ^DUILabel * (id first,...)
    {
        va_list args;
        va_start(args, first);
        
        NSString *imgName = first;
        
        NSMutableString *valueString = [[NSMutableString alloc] init];
        int i = 0;
        for (; i < 4;i++)
        {
            
            NSObject *valueObj = va_arg(args, NSObject *) ;
            if (!valueObj )
            {
                break;
            }

            [valueString appendFormat:@"%@,",valueObj];
            
        }
        
        NSString *loString = [valueString substringToIndex:([valueString length]-1)];
        

        [_dict_selfImg setValue:imgName forKey:loString];
        
        va_end(args);
        loString = nil;
        RELEASEOBJ(valueString);
        
        [self setNeedsDisplay];
        return self;
    };
    return [[block copy] autorelease];
    
    
}

void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat imgWidth;
CGFloat imgHeight;
CGFloat RunDelegateGetAscentCallback( void *refCon ){
    return imgHeight;//[UIImage imageNamed:imageName].size.height;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
    return imgWidth;//[UIImage imageNamed:imageName].size.width;
}

- (CTFrameRef)allocFrame
{

    //创建AttributeString
    if (string)
    {
        RELEASEOBJ(string);
    }
    string = [[NSMutableAttributedString alloc]
              initWithString:self.text];
    
    
    //创建字体以及字体大小
    CTFontRef normalFont;
    
    
    //添加字体
    if ([_dict_font count] > 0) {
        
        for (int i = 0; i < [[_dict_font allKeys] count]; i++)
        {
            int loc = 0;
            int length = 0;
            NSString *key = [[_dict_font allKeys] objectAtIndex:i];
            NSArray *keys = [key componentsSeparatedByString:@","];
            CGFloat size = [[_dict_font objectForKey:key] floatValue];
            
            if ([keys count] > 1)
            {
                loc = [[keys objectAtIndex:0] intValue];
                length = [[keys objectAtIndex:1] intValue];
            }
            
            normalFont = CTFontCreateWithName((CFStringRef)self.font.fontName, size, NULL);
            
            [string addAttribute:(id)kCTFontAttributeName
                           value:(id)normalFont
                           range:NSMakeRange(loc, length)];
//            CFRelease(normalFont);
            
            
            
        }
        
    }else
    {
        normalFont = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
        [string addAttribute:(id)kCTFontAttributeName
                       value:(id)normalFont
                       range:NSMakeRange(0, [string length])];
//        
    }
    
    //设置字间距
    CFNumberRef numberRef = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&_chartSpacing);
    
    [string addAttribute:(id)kCTKernAttributeName
                   value:(id)numberRef
                   range:NSMakeRange(0, [string length])];
    
    
    CFRelease(numberRef);
    
    //预留空格的方法
    
    
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@"  "];//空格用于给图片留位置
    
    for (int i = 0; i < [_arr_autoImgkey count]; i++)
    {
        
        NSString *value = [_arr_autoImgkey objectAtIndex:i];
        NSArray *valueArray = [value componentsSeparatedByString:@","];
        NSString *imgName = [valueArray objectAtIndex:0];
        CGFloat width = [[valueArray objectAtIndex:1] floatValue];
        CGFloat height = [[valueArray objectAtIndex:2] floatValue];
        
        imgWidth = width;
        imgHeight = height;
        
        CTRunDelegateCallbacks imageCallbacks;
        imageCallbacks.version = kCTRunDelegateVersion1;
        imageCallbacks.dealloc = RunDelegateDeallocCallback;
        imageCallbacks.getAscent = RunDelegateGetAscentCallback;
        imageCallbacks.getDescent = RunDelegateGetDescentCallback;
        imageCallbacks.getWidth = RunDelegateGetWidthCallback;
        CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, imgName);
        
        [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(id)runDelegate range:NSMakeRange(0, 1)];
        
        [string insertAttributedString:imageAttributedString atIndex:[[_arr_autoImgkey objectAtIndex:i] integerValue]];
        
        
        CFRelease(runDelegate);
    }
    RELEASEOBJ(imageAttributedString);
    
    
    //添加字体颜色
    if ([_dict_color count] > 0)
    {
        for (int i = 0; i < [_dict_color count]; i++)
        {
            int length = 0;
            int loc = 0;
            NSArray *key = [[[_dict_color allKeys] objectAtIndex:i] componentsSeparatedByString:@","];
            id value = [_dict_color objectForKey:[[_dict_color allKeys] objectAtIndex:i] ];
            if ([key count] > 1) {
                length = [[key objectAtIndex:1] intValue];
                loc = [[key objectAtIndex:0] intValue];
            }
            [string addAttribute:(id)kCTForegroundColorAttributeName
                           value:value
                           range:NSMakeRange(loc, length)];
        }
    }else
    {
        [string addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)[UIColor redColor].CGColor
                       range:NSMakeRange(0, [self.text length])];
    }
    
    //创建文本对齐方式
    CTTextAlignment alignment = CTTextAlignmentFromUINSORUITextAlignment(self.textAlignment);
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize = sizeof(CTTextAlignment);
    alignmentStyle.value = &alignment;

    
    //创建文本行间距
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
    lineSpaceStyle.valueSize = sizeof(CGFloat);
    lineSpaceStyle.value = &_linesSpacing;
    
    
    //    self.lineBreakMode = NSLineBreakByWordWrapping;
    
    //设置换行模式
    CTLineBreakMode coreTextLBMode = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
    CTParagraphStyleSetting paragrapLinehStyle;//换行模式
    paragrapLinehStyle.spec = kCTParagraphStyleSpecifierLineBreakMode;
    paragrapLinehStyle.valueSize = sizeof(CTLineBreakMode);
    paragrapLinehStyle.value = &coreTextLBMode;
    
    //创建样式数组
    CTParagraphStyleSetting settings[]={
        alignmentStyle,lineSpaceStyle,paragrapLinehStyle
    };
    
    //设置样式
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
    
    //给字符串添加样式attribute
    [string addAttribute:(id)kCTParagraphStyleAttributeName
                   value:(id)paragraphStyle
                   range:NSMakeRange(0, [string length])];
    
    //控制布局
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path,
                  NULL,
                  CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path,
                                                NULL);
    

    
    //释放
    CFRelease(paragraphStyle);
    CGPathRelease(path);
    CFRelease(framesetter);
    CFRelease(normalFont);
//    [string release];
    
    return frame;
}

- (void)drawIMG:(CGContextRef)context frame:(CTFrameRef)frame;
{
    if ([[_dict_selfImg allValues] count] > 0)
    {
        for (int i = 0; i < [[_dict_selfImg allKeys] count]; i++)
        {
            CGContextSaveGState(context);//保存图层
            NSString *value = [[_dict_selfImg allKeys] objectAtIndex:i];
            NSString *imgName = [_dict_selfImg objectForKey:value];
            NSArray *valueArray = [value componentsSeparatedByString:@","];
            CGFloat xZhou = [[valueArray objectAtIndex:0] floatValue];
            CGFloat yZhou = [[valueArray objectAtIndex:1] floatValue];
            CGFloat width = [[valueArray objectAtIndex:2] floatValue];
            CGFloat height = [[valueArray objectAtIndex:3] floatValue];
            
            yZhou = self.bounds.size.height - height - yZhou;
            
            DUILabelImgView *img = [[DUILabelImgView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [img setCtFrame:(id)frame];
            [img setImgName:imgName];
            [img setImgBound:CGRectMake(xZhou, yZhou, width, height)];
            [img setBackgroundColor:[UIColor clearColor]];
            [self addSubview:img];
            [img release];
            CGContextRestoreGState(context);//恢复图层
        }
        
        [_dict_selfImg removeAllObjects];
    }


}

- (void)drawIMGA:(CGContextRef)context frame:(CTFrameRef)frame
{
    int i = 0;
    if ([[_dict_autoImg allKeys] count] > 0)
    {
        
        
        NSString *value = [_arr_autoImgkey objectAtIndex:i];
        NSString *imgName = [_dict_autoImg objectForKey:value];
        NSArray *valueArray = [value componentsSeparatedByString:@","];
        NSInteger loc = [[valueArray objectAtIndex:0] floatValue];
        CGFloat width = [[valueArray objectAtIndex:1] floatValue];
        CGFloat height = [[valueArray objectAtIndex:2] floatValue];
        
        NSUInteger lineNum = 0;
        CGFloat xZhou = 0;
        CGFloat yZhou = 0;
        
        {
            NSArray *lines = (NSArray *)CTFrameGetLines(frame);
            CGPoint origins [[lines count]];
            CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
            
            
            for (id lineObj in lines)
            {
                
                CTLineRef line = (CTLineRef)lineObj;
                
                for (id runObj in (NSArray *)CTLineGetGlyphRuns(line))
                {
                    
                    CTRunRef run = (CTRunRef)runObj;
                    CFRange runRange = CTRunGetStringRange(run);
                    CGRect runBounds;
                    CGFloat ascent;
                    CGFloat descent;
                    runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
                    runBounds.size.height = ascent + descent;
                    
                    CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                    runBounds.origin.x = origins[lineNum].x + xOffset;
                    runBounds.origin.y = origins[lineNum].y;
                    runBounds.origin.y -= descent;
                    if (runRange.location <= loc && runRange.location+runRange.length > loc)
                    {
                        xZhou = runBounds.origin.x+2;
                        yZhou = runBounds.origin.y - _linesSpacing/2 ;
                        
                        
                        CGContextSaveGState(context);//保存图层
                        
                        DUILabelImgView *img = [[DUILabelImgView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
                        [img setCtFrame:(id)frame];
                        [img setImgName:imgName];
                        [img setImgBound:CGRectMake(xZhou, yZhou, width, height)];
                        [img setBackgroundColor:[UIColor clearColor]];
                        [self addSubview:img];
                        [img release];
                        
                        CGContextRestoreGState(context);//恢复图层
                        
                        i++;
                        if (i > [_arr_autoImgkey count]-1)
                        {
                            break;
                        }
                        
                        value = [_arr_autoImgkey objectAtIndex:i];
                        imgName = [_dict_autoImg objectForKey:value];
                        valueArray = [value componentsSeparatedByString:@","];
                        loc = [[valueArray objectAtIndex:0] floatValue];
                        width = [[valueArray objectAtIndex:1] floatValue];
                        height = [[valueArray objectAtIndex:2] floatValue];
                        
                    }
                    
                }
                lineNum++;
                
            }
            
            
            
        }
        
        
        [_dict_autoImg removeAllObjects];
        [_arr_autoImgkey removeAllObjects];
    }

}

- (void)drawTextInRect:(CGRect)rect
{
    //不需要coretext
    if (!_needCoretext)
    {
        [super drawTextInRect:rect];
        return;
    }

    CTFrameRef frame = [self allocFrame];
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    //翻转系统坐标（Core Text uses a Y-flipped coordinate system）
    //x，y轴方向移动
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(context, 1.f, -1.f);
    
    //绘画
    CTFrameDraw(frame, context);
    
    
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(context);//保存图层
    
    
    [self drawIMG:context frame:frame];
    
    [self drawIMGA:context frame:frame];
    
    CGContextRestoreGState(context);//恢复图层
    
    
    CFRelease(frame);
    
    [_dict_color removeAllObjects];
    [_dict_font removeAllObjects];

}

- (void)autoHeight
{
    CTFrameRef frame = [self allocFrame];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    CGSize maxSize = CGSizeMake(320, 3000);
    CFRange fitCFRange = CFRangeMake(0,0);
	CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
    CGRect newFrame = self.frame;
    newFrame.size.height = sz.height+1;
    [self setFrame:newFrame];
    CFRelease(framesetter);
    CFRelease(frame);

}

/*
 kCTParagraphStyleSpecifierAlignment = 0,                 //对齐属性
 kCTParagraphStyleSpecifierFirstLineHeadIndent = 1,       //首行缩进
 kCTParagraphStyleSpecifierHeadIndent = 2,                //段头缩进
 kCTParagraphStyleSpecifierTailIndent = 3,                //段尾缩进
 kCTParagraphStyleSpecifierTabStops = 4,                  //制表符模式
 kCTParagraphStyleSpecifierDefaultTabInterval = 5,        //默认tab间隔
 kCTParagraphStyleSpecifierLineBreakMode = 6,             //换行模式
 kCTParagraphStyleSpecifierLineHeightMultiple = 7,        //多行高
 kCTParagraphStyleSpecifierMaximumLineHeight = 8,         //最大行高
 kCTParagraphStyleSpecifierMinimumLineHeight = 9,         //最小行高
 kCTParagraphStyleSpecifierLineSpacing = 10,              //行距
 kCTParagraphStyleSpecifierParagraphSpacing = 11,         //段落间距  在段的未尾（Bottom）加上间隔，这个值为负数。
 kCTParagraphStyleSpecifierParagraphSpacingBefore = 12,   //段落前间距 在一个段落的前面加上间隔。TOP
 kCTParagraphStyleSpecifierBaseWritingDirection = 13,     //基本书写方向
 kCTParagraphStyleSpecifierMaximumLineSpacing = 14,       //最大行距
 kCTParagraphStyleSpecifierMinimumLineSpacing = 15,       //最小行距
 kCTParagraphStyleSpecifierLineSpacingAdjustment = 16,    //行距调整
 kCTParagraphStyleSpecifierCount = 17,        //
 */

CTTextAlignment CTTextAlignmentFromUINSORUITextAlignment(NSTextAlignment textAlignment)
{
    switch (textAlignment) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
        case NSTextAlignmentCenter :
            return kCTCenterTextAlignment;
            
        case NSTextAlignmentRight :
            return kCTRightTextAlignment;
        case NSTextAlignmentLeft :
            return kCTLeftTextAlignment;
#else
        case NSTextAlignmentCenter | UITextAlignmentCenter:
            return kCTCenterTextAlignment;
            
        case NSTextAlignmentRight | UITextAlignmentRight:
            return kCTRightTextAlignment;
        case NSTextAlignmentLeft | UITextAlignmentLeft:
            return kCTLeftTextAlignment;
#endif
        default:
            return kCTLeftTextAlignment;
            break;
    }
}

CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode)
{

	switch (lineBreakMode) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
		case NSLineBreakByWordWrapping:
            return kCTLineBreakByWordWrapping;
		case NSLineBreakByCharWrapping:
            return kCTLineBreakByCharWrapping;
		case NSLineBreakByClipping:
            return kCTLineBreakByClipping;
		case NSLineBreakByTruncatingHead:
            return kCTLineBreakByTruncatingHead;
		case NSLineBreakByTruncatingTail:
            return kCTLineBreakByTruncatingTail;
		case NSLineBreakByTruncatingMiddle:
            return kCTLineBreakByTruncatingMiddle;
#else
        case (UILineBreakModeWordWrap | NSLineBreakByWordWrapping):
            return kCTLineBreakByWordWrapping;
		case (UILineBreakModeCharacterWrap | NSLineBreakByCharWrapping):
            return kCTLineBreakByCharWrapping;
		case (UILineBreakModeClip | NSLineBreakByClipping):
            return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation | NSLineBreakByTruncatingHead:
            return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation | NSLineBreakByTruncatingTail:
            return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation | NSLineBreakByTruncatingMiddle:
            return kCTLineBreakByTruncatingMiddle;
#endif
		default:
            return 0;
	}
}

@end
