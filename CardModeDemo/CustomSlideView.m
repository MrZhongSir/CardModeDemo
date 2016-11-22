//
//  CustomSlideView.m
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import "CustomSlideView.h"
#import "CardView.h"

@interface CustomSlideView()
{
    NSMutableArray *_cardViewArray;//存储底部的cardView
    NSMutableArray *_slideCardViewArray;//存储滑动的cardView
    
    UIView *_bottomView;//用于显示叠加效果的底部视图
    UIScrollView *_mainScrollView;//用于滑动的交互视图
    
    NSInteger _index;//序列号
}
@end

@implementation CustomSlideView

-(instancetype)initWithFrame:(CGRect)frame AndzMarginValue:(CGFloat)zMarginValue AndxMarginValue:(CGFloat)xMarginValue AndalphaValue:(CGFloat)alphaValue AndangleValue:(CGFloat)angleValue
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化
        self.cardDataArray = [[NSMutableArray alloc]init];
        _cardViewArray = [[NSMutableArray alloc]init];
        _slideCardViewArray = [[NSMutableArray alloc]init];
        self.zMarginValue = zMarginValue;
        self.xMarginValue = xMarginValue;
        self.alphaValue = alphaValue;
        self.angleValue = angleValue;
        
        //设置frame
        frame.origin = CGPointMake(0, 0);
        
        //初始化两个主要视图
        _bottomView = [[UIView alloc]initWithFrame:frame];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.layer.cornerRadius = 5.0;
        
        _mainScrollView = [[UIScrollView alloc]initWithFrame:frame];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.autoresizingMask = YES;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.layer.cornerRadius = 5.0;
        
        [self addSubview:_bottomView];
        [self addSubview:_mainScrollView];
        
        //设置叠加视图的透视投影(这一步很重要)
        CATransform3D sublayerTransform = CATransform3DIdentity;//单位矩阵
        sublayerTransform.m34 = -0.002;
        [_bottomView.layer setSublayerTransform:sublayerTransform];
    }
    
    return self;
}

-(void)addCardDataWithArray:(NSArray *)array
{
    if (_cardDataArray.count == 0) {
        //初始化序列号
        _index = array.count-1;
    }
    
    [_cardDataArray addObjectsFromArray:array];
    
    if (_cardDataArray.count) {
        //加载叠加视图
        [self loadBottomView];
        //加载滚动视图
        [self loadSlideCardViewWithCount:_cardDataArray.count];
    }
}

#pragma mark- 加载最顶层的滚动视图
-(void)loadSlideCardViewWithCount:(NSInteger)count
{
    CGSize viewSize = self.frame.size;
    CGFloat width = viewSize.width; //图宽
    
    if (_cardDataArray.count>10) {
        _mainScrollView.contentSize = CGSizeMake(width, viewSize.height*_cardDataArray.count);
        
        //经过这个操作
        [_mainScrollView setContentOffset:CGPointMake(0, (count+_index)* viewSize.height) animated:NO];
    
        CardView*card = [_slideCardViewArray firstObject];
        card.frame = CGRectMake(0, _index* viewSize.height, viewSize.width, viewSize.height-58);
        
        return;
    }
    
    //坐标
    CGPoint point = CGPointMake(0, (_cardDataArray.count-1)*viewSize.height);
    
    //实例化CardView
    CardView *card = [[CardView alloc]initWithFrame:CGRectMake(point.x, point.y, viewSize.width, viewSize.height-58)];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.masksToBounds = YES;
    card.layer.cornerRadius = 5.0;//设置圆角
    [card loadCardViewWithDictionary:_cardDataArray[0]];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSelectCardViewAction)];
    [card addGestureRecognizer:tap];
    
    //添加到视图与数组中
    [_slideCardViewArray insertObject:card atIndex:0];
    [_mainScrollView addSubview:card];
    
    //设置滚动视图属性
    _mainScrollView.contentSize = _cardDataArray.count>1 ? CGSizeMake(width, viewSize.height*_cardDataArray.count):CGSizeMake(width, viewSize.height*_cardDataArray.count+1);
    _mainScrollView.contentOffset = CGPointMake(0, (_cardDataArray.count-1)* viewSize.height);
}

-(void)loadBottomView
{
    if (_cardDataArray.count>10) {
        return;
    }
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    for(int i=0; i<(_cardDataArray.count<4?_cardDataArray.count:4); i++)
    {
        //设置CardView的坐标，z值和透明度
        CGPoint point = CGPointMake(0, -i*height/_xMarginValue);
        float zPosition = -i*height/_zMarginValue;
        
        //实例化CardView
        CardView *card = [[CardView alloc]initWithFrame:CGRectMake(point.x, point.y, width,height-58)];
        card.backgroundColor = [UIColor whiteColor];
        card.layer.masksToBounds = YES;
        card.layer.cornerRadius = 5.0;
        [card loadCardViewWithDictionary:_cardDataArray[i]];
        
        if (i<3) {
            card.layer.zPosition = zPosition; // Z坐标
            card.alpha = 1;
        }
        else{
            card.layer.zPosition = -288; // Z坐标
            card.alpha = 0;
        }
        
        //添加到视图与数组中
        if(i == 0){
            card.hidden = YES;
        }
        
        [_cardViewArray insertObject:card atIndex:0];
        [_bottomView addSubview:card];
    }
}

//通过协议，告诉控制器选择的卡片
-(void)showSelectCardViewAction
{
    if([self.delegate respondsToSelector:@selector(slideCardViewDidSlectIndex:)])
    {
        [self.delegate slideCardViewDidSlectIndex:_index];
    }
    
    NSLog(@"%ld",_index);
}

#pragma mark- UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView //滚动时处理
{
    CGFloat offset_y = scrollView.contentOffset.y;//scrollView所在位置
    CGFloat height = scrollView.frame.size.height;//高度
    CGFloat width = scrollView.frame.size.width;//视图宽度
    CGFloat currentIndex = offset_y/height;//当前标签
    
    //得到索引
    _index = currentIndex>(int)currentIndex?(int)currentIndex+1:(int)currentIndex;
    
    if (_index>_cardDataArray.count-1) {
        _index = (int)_cardDataArray.count-1;
    }
    
    //调整滚动视图图片的角度
    CardView* scrollCardView = [_slideCardViewArray firstObject];
    
    //表示处于当前视图内
    if(scrollCardView.frame.origin.y<offset_y)
    {
        if(offset_y>_cardDataArray.count*height-height){
            scrollCardView.hidden = YES;
        }else{
            scrollCardView.hidden = NO;
            scrollCardView.frame = CGRectMake(0, _index*height, scrollCardView.frame.size.width, scrollCardView.frame.size.height);
            [scrollCardView loadCardViewWithDictionary:_cardDataArray[_cardDataArray.count-1-_index]];
        }
    }
    else if(scrollCardView.frame.origin.y-height<offset_y&&offset_y<=scrollCardView.frame.origin.y)
    {
        scrollCardView.hidden = NO;
    }
    else
    {
        scrollCardView.frame = CGRectMake(0, _index*height, scrollCardView.frame.size.width, scrollCardView.frame.size.height);
        [scrollCardView loadCardViewWithDictionary:_cardDataArray[_cardDataArray.count-1-_index]];
    }
    
    NSInteger _select = _index-3>0?(_index-3):0;
    
    for (NSInteger i=_select; i<=_index; i++) {
        //调整滚动视图图片的角度
        float currOrigin_y = i * height; //当前图片的y坐标
        
        //调整叠加视图
        CardView* moveCardView = [_cardViewArray objectAtIndex:i-_select];
        [moveCardView loadCardViewWithDictionary:_cardDataArray[_cardDataArray.count-1-i]];
        
        float range_y = (currOrigin_y - offset_y)/(_xMarginValue) ;
        
        moveCardView.frame = CGRectMake(0, range_y, width, height-58);
        
        if(range_y >= 0) // 如果超过当前滑动视图便隐藏
            moveCardView.hidden = YES;
        else
        {
            moveCardView.hidden = NO;
        }
        
        //调整弹压视图的z值
        float range_z = -(offset_y-currOrigin_y)/_zMarginValue;
        
        moveCardView.layer.zPosition = range_z;
        
        //调整弹压视图的透明度
        float alpha = 1.f + (currOrigin_y-offset_y)/_alphaValue;
        
        if (currentIndex-2<=i && i<=currentIndex) {
            moveCardView.alpha = 1;
        }else if(currentIndex-2>i&&currentIndex-3<i){
            moveCardView.alpha = alpha;
        }
        else{
            moveCardView.alpha = 0;
        }
    }
    
    //代理滚动时回调函数
    if([self.delegate respondsToSelector:@selector(slideCardViewDidScrollAllPage:AndIndex:)])
        [self.delegate slideCardViewDidScrollAllPage:_cardDataArray.count-1 AndIndex:_index];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for(CardView* card in _slideCardViewArray)  //调整所有图片的z值
        card.layer.zPosition = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //滚动结束处理
{
    if([self.delegate respondsToSelector:@selector(slideCardViewDidEndScrollIndex:)])
    {
        [self.delegate slideCardViewDidEndScrollIndex:_index];
    }
}

@end
