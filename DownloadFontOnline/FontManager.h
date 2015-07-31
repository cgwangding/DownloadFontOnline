//
//  FontManager.h
//  DownloadFontOnline
//
//  Created by AD-iOS on 15/7/31.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

/**
 *  ReadMe>>>>>>>>>>>看这看这>>>>>>>>>>>>>>>>>>>>>>：
 *  由于下载的时候需要使用字体的PostScript名称。
 *  PostScript名称可以Mac 系统自带的 字体册 功能中查找。
 *  LaunchPad->其他->字体册->选中需要的字体->command + i
 *  在字体册右边即可找到PostScript名称。
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface FontManager : NSObject

+ (instancetype)sharedManager;

/**
 *  动态检测下载对应的PostScriptName的字体，必须是苹果支持的才行
 *
 *  @param fontName 字体的PostScriptName
 *  @param fontSize 字体大小
 *  @param complete 完成时的回调
 *  @param failure  失败时回调
 */
- (void)downloadFontWithPostScriptName:(NSString*)fontName fontSize:(CGFloat)fontSize complete:(void (^)(UIFont *font))complete failure:(void (^)(NSError *error))failure;

/**
 *  动态检测下载对应的PostScriptName的字体，必须是苹果支持的才行
 *
 *  @param fontName 字体的PostScriptName
 *  @param fontSize 字体大小
 *  @param progress 下载进度
 *  @param complete 完成时的回调
 *  @param failure  失败时回调
 */
- (void)downloadFontWithPostScriptName:(NSString*)fontName fontSize:(CGFloat)fontSize progress:(void (^)(CGFloat progress))progress complete:(void (^)(UIFont *font))complete failure:(void (^)(NSError *error))failure;

@end
