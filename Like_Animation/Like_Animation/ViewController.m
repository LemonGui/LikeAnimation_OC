//
//  ViewController.m
//  Like_Animation
//
//  Created by Lemon on 2019/5/28.
//  Copyright © 2019 Lemon. All rights reserved.
//

#import "ViewController.h"
#import "LikeAnimation.h"
@interface ViewController ()
@property (nonatomic,strong) UIView * placeholderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500)];
    _placeholderView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_placeholderView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    LikeAnimation * likeAnimation = [[LikeAnimation alloc] init];
    likeAnimation.frame = CGRectMake(0, 0, 100, 100);
    likeAnimation.center = _placeholderView.center;
    likeAnimation.duration = 1;
    likeAnimation.circlesCounter = 1;
    likeAnimation.particlesCounter = @[@(7),@(3)];
//    likeAnimation.delegate = self;
    [_placeholderView addSubview:likeAnimation];
    [likeAnimation run];
}



@end
