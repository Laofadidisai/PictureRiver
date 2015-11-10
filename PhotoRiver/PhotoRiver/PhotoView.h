//
//  PhotoView.h
//  PhotoRiver
//
//  Created by 老李 on 15-11-1.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"

typedef NS_ENUM(NSInteger, PhotoState) {
    
    PhotoStateNormal,
    PhotoStateBig,
    PhotoStateDraw,
    PhotoStateTogether
    
};



@interface PhotoView : UIView
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) DrawView * drawView;
@property(nonatomic) float speed;
@property(nonatomic) CGRect oldFrame;
@property(nonatomic) float oldSpeed;
@property(nonatomic) float oldAlpha;
@property(nonatomic) int state;

-(void)updateImage:(UIImage *)image;
-(void)setImageAlphaAndSpeedAndSize:(float)alpha;

@end
