//
//  ViewController.m
//  DownloadFontOnline
//
//  Created by AD-iOS on 15/7/31.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

#import "ViewController.h"
#import "FontManager.h"

@interface ViewController ()
{

    UILabel *label;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"字体测试 字体测试 字体测试字体测试 字体测试";
    label.font = [UIFont fontWithName:@"STXingkai-SC-Light" size:20];
    [self.view addSubview:label];
    [[FontManager sharedManager]downloadFontWithPostScriptName:@"STXingkai-SC-Light" fontSize:20 complete:^(UIFont *font) {

                label.font = font;


    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
