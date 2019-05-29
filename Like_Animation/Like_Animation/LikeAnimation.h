//
//  LikeAnimation.h
//  Like_Animation
//
//  Created by Lemon on 2019/5/28.
//  Copyright © 2019 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LikeAnimation;
@protocol LikeAnimationDelegate <NSObject>

-(void)likeAnimationWillBegin:(LikeAnimation *)view;
-(void)likeAnimationDidEnd:(LikeAnimation *)view;
@end

static double DurationMin = (NSTimeInterval)0.5;
static double DurationMax = (NSTimeInterval)3;
static int    CirclesMin = 0;
static int    CirclesMax = 3;
static int    MainParticlesMin = 3;
static int    MainParticlesMax = 13;
static int    SmallParticlesMin = 0;
static int    SmallParticlesMax = 13;

@interface LikeAnimation : UIView

@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,strong) NSArray<UIColor *> * heartColors;
@property (nonatomic,assign) NSInteger circlesCounter;
@property (nonatomic,strong) UIColor * particlesColor;
@property (nonatomic,weak) id<LikeAnimationDelegate> delegate;
@property (nonatomic,strong) NSArray<NSNumber *> * particlesCounter;

-(void)run;
@end

NS_ASSUME_NONNULL_END
