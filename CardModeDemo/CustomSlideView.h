//
//  CustomSlideView.h
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideCardViewDelegate <NSObject>

-(void)slideCardViewDidSlectIndex:(NSInteger)index;//选中某张卡片
-(void)slideCardViewDidScrollAllPage:(NSInteger)page AndIndex:(NSInteger)index;//滚动某张卡片
-(void)slideCardViewDidEndScrollIndex:(NSInteger)index;//滚动结束时的当前卡片

@end

@interface CustomSlideView : UIView <UIScrollViewDelegate>

@property (nonatomic,weak) id<SlideCardViewDelegate>delegate;
@property(nonatomic,assign) CGFloat zMarginValue;//图片之间z方向的间距值，越小间距越大
@property(nonatomic,assign) CGFloat xMarginValue;//图片之间x方向的间距值，越小间距越大
@property(nonatomic,assign) CGFloat alphaValue;//图片的透明比率值
@property(nonatomic,assign) CGFloat angleValue;//偏移角度
@property(nonatomic,strong) NSMutableArray* cardDataArray;//卡片信息数组

#pragma mark- init method

/*通过参数进行初始化
 注:ZMarginValue与XMarginValue的值越接近，效果越佳
 透明比率值建议设置在1000左右
 */
-(instancetype)initWithFrame:(CGRect)frame AndzMarginValue:(CGFloat)zMarginValue AndxMarginValue:(CGFloat)xMarginValue AndalphaValue:(CGFloat)alphaValue AndangleValue:(CGFloat)angleValue;

/*
 添加卡片信息
 */
-(void)addCardDataWithArray:(NSArray*)array;

@end
