//
//  AnimationsHelper.m
//  Like_Animation
//
//  Created by Lemon on 2019/5/28.
//  Copyright © 2019 Lemon. All rights reserved.
//

#import "AnimationsHelper.h"

@interface Animation ()
@property (nonatomic,strong) CAAnimation * animation;

@end

@implementation Animation

- (instancetype)initWithAnimation:(CAAnimation *)animation beforeAction:(void(^)(void))before afterAction:(void(^)(void))after
{
    self = [super init];
    if (self) {
        self.animation = animation;
        self.beforeAction = before;
        self.afterAction = after;
    }
    return self;
}

- (instancetype)initWithAnimation:(CAAnimation *)animation
{
    self = [super init];
    if (self) {
        self.animation = animation;
    }
    return self;
}

- (instancetype)initAnimationForKeyPath:(NSString *)path fromValue:(id)fromValue toValue:(id)toValue duration:(CFTimeInterval)duration beforeAction:(void(^)(void))before afterAction:(void(^)(void))after
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:path];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return [self initWithAnimation:animation beforeAction:before afterAction:after];
}

- (instancetype)initP:(NSString *)path f:(id)fromValue t:(id)toValue d:(CFTimeInterval)duration b:(void(^)(void))before a:(void(^)(void))after
{
    return [self initAnimationForKeyPath:path fromValue:fromValue toValue:toValue duration:duration beforeAction:before afterAction:after];
}

- (instancetype)initWithAnimation:(CAAnimation *)animation beforeAction:(void(^)(void))before
{
    return [self initWithAnimation:animation beforeAction:before afterAction:nil];
}

- (instancetype)initWithAnimation:(CAAnimation *)animation afterAction:(void(^)(void))after
{
    return [self initWithAnimation:animation beforeAction:nil afterAction:after];
}

-(void)runAnimationOnLayer:(CAShapeLayer *)layer{
    if (self.beforeAction) {
        self.beforeAction();
    }
    [layer addAnimation:self.animation forKey:nil];
}


@end



@implementation AnimationGroup

- (instancetype)initDuration:(CFTimeInterval)duration animations:(NSArray <Animation *>*)animations
{
    NSMutableArray * tempAnimations = @[].mutableCopy;
    for (Animation * animation in animations) {
        [tempAnimations addObject:animation.animation];
    }
    CAAnimationGroup * animationSequence = [CAAnimationGroup animation];
    animationSequence.animations = tempAnimations;
    animationSequence.duration = duration;
    animationSequence.removedOnCompletion = false;
    animationSequence.fillMode = kCAFillModeForwards;
    
    self = [super initWithAnimation:animationSequence];
    if (self) {
        self.animations = animations;
        self.animation = animationSequence;
    }
    return self;
}

-(void)runAnimationOnLayer:(CAShapeLayer *)layer{
    
    for (Animation * animation in self.animations) {
        if (animation.beforeAction) {
            animation.beforeAction();
        }
    }
    [super runAnimationOnLayer:layer];
}

@end

@implementation AnimationSequence 

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.animations = @[].mutableCopy;
    }
    return self;
}

-(void)addDelay:(CFTimeInterval)duration{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:nil];
    animation.duration = duration;
    animation.delegate = self;
    [self.animations addObject:[[Animation alloc] initWithAnimation:animation]];
}

-(void)addDelay:(CFTimeInterval)duration beforeAction:(void(^)(void))before afterAction:(void(^)(void))after{
    CABasicAnimation * caAnimation = [CABasicAnimation animationWithKeyPath:nil];
    caAnimation.duration = duration;
    caAnimation.fillMode = kCAFillModeForwards;
    caAnimation.delegate = self;
    Animation * animation = [[Animation alloc] initWithAnimation:caAnimation];
    animation.beforeAction = before;
    animation.afterAction = after;
    [self.animations addObject:animation];
}

-(void)addCaAnimation:(CAAnimation *)caAnimation{
    caAnimation.delegate = self;
    caAnimation.fillMode = kCAFillModeForwards;
    [self.animations addObject:[[Animation alloc] initWithAnimation:caAnimation]];
}

-(void)addAnimation:(Animation *)animation{
    if (animation.animation) {
        animation.animation.delegate = self;
    }
    [self.animations addObject:animation];
}

-(void)runAnimationOnLayer:(CAShapeLayer *)layer{
    Animation * animation = self.animations.firstObject;
    if (animation) {
        self.index = 0;
        self.layer = layer;
        [animation runAnimationOnLayer:layer];
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        Animation * animation = self.animations[self.index];
        if (animation.afterAction) {
            animation.afterAction();
        }
        self.index += 1;
        
        if (self.index < self.animations.count) {
            Animation * animation = self.animations[self.index];
            if (animation.beforeAction) {
                animation.beforeAction();
            }
            
            CAAnimation * caAnimation = animation.animation;
            if (caAnimation) {
                [self.layer addAnimation:caAnimation forKey:nil];
            }
        }
    }
    
}



@end
