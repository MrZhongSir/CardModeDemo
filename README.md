# CardModeDemo
卡片效果

这里实现了一个卡片效果，工程里加上 CustomSlideView类

1.初始化方法

CustomSlideView *_slide = [[CustomSlideView alloc]initWithFrame:rect AndzMarginValue:9/(RatioValue) AndxMarginValue:11/(RatioValue) AndalphaValue:1 AndangleValue:2000];

2.添加卡片视图方法
[_slide addCardDataWithArray:array];
_slide.backgroundColor = [UIColor clearColor];
[self.view addSubview:_slide];

3.遵守SlideCardViewDelegate协议，实现几个代理方法
_slide.delegate = self;

#pragma mark- 代理
-(void)slideCardViewDidEndScrollIndex:(NSInteger)index
{
    NSLog(@"__结束滑动时的卡片编号__%ld",index);
}

-(void)slideCardViewDidSlectIndex:(NSInteger)index
{
    NSLog(@"__选中或者点击卡片编号__%ld",index);
}

-(void)slideCardViewDidScrollAllPage:(NSInteger)page AndIndex:(NSInteger)index
{
    NSLog(@"__卡片总页数__%ld__滑动时当前卡片__%ld",page,index);
}
