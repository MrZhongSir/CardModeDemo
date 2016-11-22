//
//  CardView.h
//  CardModeDemo
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 wenSir. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface CardView : UIView

-(void)loadCardViewWithDictionary:(NSDictionary*)dictionary;

@end
