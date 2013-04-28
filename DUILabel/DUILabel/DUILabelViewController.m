//
//  DUILabelViewController.m
//  DUILabel
//
//  Created by NewM on 13-4-28.
//  Copyright (c) 2013年 ZzL. All rights reserved.
//

#import "DUILabelViewController.h"
#import "D_UILabel.h"
#import "RegexKitLite.h"

@interface DUILabelViewController ()

@end

@implementation DUILabelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DUILabel *label = [[DUILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [label setText:@"这是一个coretextLabel，[1][2][1][1][2][1][1][2][1][1][2][1][1][2][1][1][2][1][1][2][1][1][2][1][1][2][1],你好"];
    label.COLOR(@"1", @"2", [UIColor greenColor]).COLOR(@"3", @"3", [UIColor redColor]);
    label.FONT(@"1", @"2", @"25.f");
    label.IMG(@"Default.png",@"252",@"65",@"14",@"14");//自己定义图片位置
    
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSArray *array_emoji = [label.text componentsMatchedByRegex:regex_emoji];
    
    for (int i = 0; i < [array_emoji count]; i++)
    {
        
        NSString *str = [array_emoji objectAtIndex:i];
        
        NSRange range = [label.text rangeOfString:str];
        
        label.text = [label.text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:@""];
        
        label.IMGA(@"Default.png",range.location+i*2,@"22",@"22");
                                    //(这里乘2为了计算宽度的也是必须的，其他随便)
        
    }
    [label setNeedCoretext:YES];//这个必须放在最后亲（有解决方案可以跟我说一下QQ：33299542）
    [self.view addSubview:label];
    
    [label release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
