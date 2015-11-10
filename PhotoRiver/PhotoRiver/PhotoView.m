//
//  PhotoView.m
//  PhotoRiver
//
//  Created by 老李 on 15-11-1.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.drawView = [[DrawView alloc]initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;       //contentMode 内容模式
        self.drawView.contentMode = UIViewContentModeScaleAspectFit;  //UIViewContentModeScaleAspectFit:视图模式适合规模方面的内容
        [self addSubview:self.drawView];
        [self addSubview:self.imageView];
        
        NSTimer * timer = [NSTimer timerWithTimeInterval:1/10 target:self selector:@selector(movePhotos) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:@"NSDefaultRunLoopMode"];
        
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor whiteColor]CGColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage)];
        [self addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipImage)];
        [self addGestureRecognizer:swip];
        
    }
    return self;
}

-(void)tapImage
{
    [UIView animateWithDuration:0.5 animations:^{
        if (self.state == PhotoStateNormal) {
            self.oldFrame = self.frame;
            self.oldAlpha = self.alpha;
            self.oldSpeed = self.speed;
            self.frame = CGRectMake(20, 20, self.superview.bounds.size.width - 40, self.superview.bounds.size.height - 40);
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            [self.superview bringSubviewToFront:self];
            self.speed = 0;
            self.alpha = 1;
            self.state = PhotoStateBig;
            
        }
        else if (self.state == PhotoStateBig)
        {
            self.frame = self.oldFrame;
            self.alpha = self.oldAlpha;
            self.speed = self.oldSpeed;
            self.imageView.frame = self.bounds;
            self.drawView.frame = self.bounds;
            self.state = PhotoStateNormal;
        }
 
    }];
    
    
    
}

-(void)swipImage
{
    if (self.state == PhotoStateBig) {
        [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.state = PhotoStateDraw;
    }else if (self.state == PhotoStateDraw){
        [self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        self.state = PhotoStateBig;
    }
    
    
}

-(void)updateImage:(UIImage *)image
{
    self.imageView.image = image;
    NSLog(@"图片");
}

-(void)setImageAlphaAndSpeedAndSize:(float)alpha
{
    self.alpha = alpha;
    self.speed = alpha;
    self.transform = CGAffineTransformScale(self.transform, alpha,alpha);
}

-(void)movePhotos
{
    self.center = CGPointMake(self.center.x + self.speed, self.center.y);
    if (self.center.x>self.superview.bounds.size.width + self.frame.size.width/2) {
        self.center = CGPointMake(-self.frame.size.width/2, arc4random()%(int)(self.superview.bounds.size.height - self.bounds.size.height)+ self.bounds.size.height/2);
    }
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
