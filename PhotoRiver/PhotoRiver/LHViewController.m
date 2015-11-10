//
//  LHViewController.m
//  PhotoRiver
//
//  Created by 老李 on 15-11-1.
//  Copyright (c) 2015年 Alibaba. All rights reserved.
//

#import "LHViewController.h"
#import "PhotoView.h"

#define IMAGEWIDTH 120
#define IMAGEHEIGHT 160

@interface LHViewController ()
@property(nonatomic,strong)NSMutableArray * photos;
@end

@implementation LHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    
    self.photos = [[NSMutableArray alloc]init];
    NSMutableArray * photoPaths = [[NSMutableArray alloc]init];
    
    NSString * path = [[NSBundle mainBundle]bundlePath];
    
    NSLog(@"path = %@",path);
    
    NSFileManager * fm = [NSFileManager defaultManager];
    
    NSArray * fileNames = [fm contentsOfDirectoryAtPath:path error:nil];
    for (NSString * fileName in fileNames) {
        if ([fileName hasSuffix:@"jpg"] || [fileName hasSuffix:@"JPG"]) {
            NSString * photoPath = [path stringByAppendingPathComponent:fileName];
            [photoPaths addObject:photoPath];
        }
    }
    
    if (photoPaths) {
        for (int i = 0; i < 12; i++) {
            float X = arc4random()%((int)self.view.bounds.size.width - IMAGEWIDTH);
            float Y = arc4random()%((int)self.view.bounds.size.height - IMAGEHEIGHT);
            float W = IMAGEWIDTH;
            float H = IMAGEHEIGHT;
            
            PhotoView * photo = [[PhotoView alloc]initWithFrame:CGRectMake(X, Y, W, H)];
            [photo updateImage:[UIImage imageWithContentsOfFile:photoPaths[i]]];
            [self.view addSubview:photo];
            
            float alpha = i*1.0/10+0.2;
            [photo setImageAlphaAndSpeedAndSize:alpha];
            
            [self.photos addObject:photo];
        }
        
    }
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
}

-(void)doubleTap
{
    NSLog(@"变化");
    
    for (PhotoView * photo in self.photos) {
        if (photo.state == PhotoStateDraw || photo.state == PhotoStateBig) {
            return;
        }
    }
    
    float W = self.view.bounds.size.width/3;
    float H = self.view.bounds.size.height/3;
    
    [UIView animateWithDuration:1 animations:^{
        for (int i = 0; i < self.photos.count; i++) {
            PhotoView * photo = [self.photos objectAtIndex:i];
            
            if (photo.state == PhotoStateNormal) {
                photo.oldAlpha = photo.alpha;
                photo.oldFrame = photo.frame;
                photo.oldSpeed = photo.speed;
                photo.alpha = 1;
                photo.frame = CGRectMake(i%3*W, i/3*H, W, H);
                photo.imageView.frame = photo.bounds;
                photo.drawView.frame = photo.bounds;
                photo.speed = 0;
                photo.state = PhotoStateTogether;
            }
            else if (photo.state == PhotoStateTogether){
                photo.alpha = photo.oldAlpha;
                photo.frame = photo.oldFrame;
                photo.speed = photo.oldSpeed;
                photo.imageView.frame = photo.bounds;
                photo.drawView.frame = photo.bounds;
                photo.state = PhotoStateNormal;
                
            }
        }
    }];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
