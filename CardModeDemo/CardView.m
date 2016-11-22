//
//  CardView.m
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(void)loadCardViewWithDictionary:(NSDictionary *)dictionary
{
    self.backgroundColor = RGBCOLOR([[dictionary objectForKey:@"red"] floatValue], [[dictionary objectForKey:@"green"] floatValue], [[dictionary objectForKey:@"blue"] floatValue]);
}

@end
