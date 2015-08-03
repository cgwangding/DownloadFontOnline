//
//  FontManager.m
//  DownloadFontOnline
//
//  Created by AD-iOS on 15/7/31.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

#import "FontManager.h"
#import <CoreText/CoreText.h>

@implementation FontManager

+ (instancetype)sharedManager
{
    static FontManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FontManager alloc]init];
    });
    return manager;
}


- (BOOL)isFontDownloaded:(NSString *)fontName
{
#warning 每次重新启动应用时，系统都会自动重新匹配字体，所以，就算下载过该字体，应用启动时该方法仍会返回NO
    UIFont *aFont = [UIFont fontWithName:fontName size:12.0];
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    }
    return NO;
}


- (void)downloadFontWithPostScriptName:(NSString*)fontName fontSize:(CGFloat)fontSize complete:(void (^)(UIFont *font))complete failure:(void (^)(NSError *error))failure
{
    [self downloadFontWithPostScriptName:fontName fontSize:fontSize progress:nil complete:complete failure:failure];
}

- (void)downloadFontWithPostScriptName:(NSString*)fontName fontSize:(CGFloat)fontSize progress:(void (^)(CGFloat progress))progress complete:(void (^)(UIFont *font))complete failure:(void (^)(NSError *error))failure
{
    if ([self isFontDownloaded:fontName]) {
        NSLog(@"字体已下载");
        dispatch_async(dispatch_get_main_queue(), ^{
            UIFont *font = [UIFont fontWithName:fontName size:fontSize];
            complete(font);
        });
        return;
    }
    
    // 用字体的PostScript名字创建一个Dictionary
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName,kCTFontNameAttribute, nil];
    // 创建一个字体描述对象CTFontDescriptorRef
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    // 将字体描述对象放到一个NSMutableArray中
    NSMutableArray *descs = [NSMutableArray array];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((__bridge CFArrayRef)descs, NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        CGFloat progressValue = [[(__bridge NSDictionary*)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] floatValue];
        
        switch (state) {
            case kCTFontDescriptorMatchingDidBegin:
                NSLog(@"字体已经匹配");
                break;
            case kCTFontDescriptorMatchingDidFinish:
                if (!errorDuringDownload) {
                    NSLog(@"字体%@ 下载完成",fontName);
                    //                    NSLog(@"%@",(__bridge NSDictionary*)progressParameter);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //更新UI
                        UIFont *font = [UIFont fontWithName:fontName size:fontSize];
                        complete(font);
                    });
                }
                break;
            case kCTFontDescriptorMatchingWillBeginDownloading:
                NSLog(@"字体开始下载");
                break;
            case kCTFontDescriptorMatchingDidFinishDownloading:
            {
                NSLog(@"字体下载完成");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //更新UI
                    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
                    complete(font);
                });
            }
                break;
            case kCTFontDescriptorMatchingDownloading:
            {
                NSLog(@"下载进度 %.0f%%",progressValue);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progress) {
                        progress(progressValue);
                    }
                });
            }
                break;
            case kCTFontDescriptorMatchingDidFailWithError:
            {
                NSString *errorMessage = nil;
                NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
                if (error != nil) {
                    errorMessage = [error description];
                } else {
                    errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
                }
                // 设置标志
                errorDuringDownload = YES;
                NSLog(@"下载错误: %@", errorMessage);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure(error);
                    }
                });
                
            }
                break;
            default:
                break;
        }
        
        return @YES;
    });
}

@end
