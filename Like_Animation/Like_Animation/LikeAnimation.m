//
//  LikeAnimation.m
//  Like_Animation
//
//  Created by Lemon on 2019/5/28.
//  Copyright © 2019 Lemon. All rights reserved.
//

#import "LikeAnimation.h"
#import "AnimationsHelper.h"

@interface LikeAnimation()
@property (nonatomic,strong) CAShapeLayer * circleLayer;
@property (nonatomic,strong) CAShapeLayer * heartLayer;
@property (nonatomic,strong) CAShapeLayer * particlesLayer;
@end

@implementation LikeAnimation

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.duration = 1.5;
        self.heartColors = @[[UIColor whiteColor],[UIColor whiteColor]];
        self.circlesCounter = 1;
        self.particlesColor = [UIColor yellowColor];
        self.particlesCounter = @[@(6),@(7)];
    }
    return self;
}

-(void)run{
    [self.layer addSublayer:self.circleLayer];
    [self.layer addSublayer:self.particlesLayer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeAnimationWillBegin:)]) {
        [self.delegate likeAnimationWillBegin:self];
    }
    
    [self runCircleAnimations];
    [self runParticleAnimations];
    
    [self performSelector:@selector(animationComplete) withObject:nil afterDelay:self.duration * 2];
}

-(void)animationComplete{
    if (self.delegate && [self.delegate respondsToSelector:@selector(likeAnimationDidEnd:)]) {
        [self.delegate likeAnimationDidEnd:self];
    }
}

#pragma mark - Private
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = self.particlesColor.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.frame = self.bounds;
        layer.fillMode = kCAFillModeBoth;
        layer.lineWidth = 0.5;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 3.0;
        layer.shadowOpacity = 0.4;
        layer.shadowOffset = CGSizeMake(0, 0);
        _circleLayer = layer;
    }
    return _circleLayer;
}

- (CAShapeLayer *)heartLayer{
    if (!_heartLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.heartColors[0].CGColor;
        layer.fillMode = kCAFillModeForwards;
        layer.frame = self.bounds;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 7.0;
        layer.shadowOpacity = 0.4;
        layer.shadowOffset = CGSizeMake(0, 0);
        _heartLayer = layer;
    }
    return _heartLayer;
}

- (CAShapeLayer *)particlesLayer{
    if (!_particlesLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.particlesColor.CGColor;
        layer.fillMode = kCAFillModeForwards;
        layer.frame = self.bounds;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 3.0;
        layer.shadowOpacity = 0.4;
        layer.shadowOffset = CGSizeMake(0, 0);
        _particlesLayer = layer;
    }
    return _particlesLayer;
}

#pragma mark - Circle
- (void)runCircleAnimations{
    AnimationSequence * sequence = [[AnimationSequence alloc] init];
    [sequence addDelay:(self.duration / 5 + self.duration / 20) beforeAction:^{
        self.circleLayer.opacity = 0;
    } afterAction:^{
        self.circleLayer.opacity = 1;
    }];
    
    
    Animation * animation = [[AnimationGroup alloc] initDuration:self.duration / 2 animations:
  @[[[Animation alloc] initP:@"path" f:(id)[self circlePath:0].CGPath t:(id)[self circlePath:self.frame.size.height / 2].CGPath d:self.duration / 3 b:nil a:nil],
    [[Animation alloc] initP:@"lineWidth" f:@(self.bounds.size.height / 2) t:@(0.5) d:self.duration / 3 b:nil a:nil]]];
    [sequence addAnimation:animation];
    
    [sequence addAnimation:[[Animation alloc] initP:@"opacity" f:@(1) t:@(0) d:self.duration / 5 b:nil a:nil]];
    
    self.circleLayer.path = [self circlePath:self.frame.size.height / 2].CGPath;
    [sequence runAnimationOnLayer:self.circleLayer];
}

-(UIBezierPath *)circlePath:(CGFloat)radius{
    if (self.circlesCounter <= 0) {
        return [UIBezierPath bezierPath];
    }
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    for (int i = 0; i<self.circlesCounter; i++) {
        CGPoint center = CGPointMake(self.frame.size.width / 2,self.frame.size.height / 2);
        [path addArcWithCenter:center radius:radius * (1 - (CGFloat)i * 0.1) startAngle:0 endAngle:(CGFloat)2 * M_PI clockwise:YES];
        [path closePath];
    }
    return path;
}

#pragma mark - Particles

- (void)runParticleAnimations{
    AnimationSequence * sequence = [[AnimationSequence alloc] init];
    [sequence addDelay:(self.duration / 5 + self.duration / 20 + self.duration / 3 * 0.85)];
    
    
    Animation * animation1 = [[Animation alloc] initP:@"opacity"
                                                    f:@(0)
                                                    t:@(1)
                                                    d:self.duration / 5
                                                    b:^{
        self.particlesLayer.path = [self particlesPath:0 reverse:NO].CGPath;
    }
                                                    a:^{
                                                        
                                                    }];
    Animation * animation2 = [[Animation alloc] initP:@"path"
                                                    f:(id)[self particlesPath:0 reverse:NO].CGPath
                                                    t:(id)[self particlesPath:0.7 reverse:NO].CGPath
                                                    d:self.duration / 5
                                                    b:nil
                                                    a:nil];
    Animation * animation = [[AnimationGroup alloc] initDuration:self.duration / 5 animations:@[animation1,animation2]];
    [sequence addAnimation:animation];
    
    Animation * animation3 = [[Animation alloc] initP:@"path"
                           f:(id)[self particlesPath:0.7 reverse:NO].CGPath
                           t:(id)[self particlesPath:1.5 reverse:YES].CGPath
                           d:self.duration / 3
                           b:nil
                           a:^{
                               self.particlesLayer.opacity = 0;
                           }];
    [sequence addAnimation:[[AnimationGroup alloc] initDuration:self.duration / 3 animations:@[animation3]]];
    [sequence runAnimationOnLayer:self.particlesLayer];
}

-(UIBezierPath *)particlesPath:(CGFloat)scale reverse:(BOOL)reverse{
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    double mainAngel = M_PI * 2 / [self.particlesCounter[0] doubleValue];
    double mainSubangel = mainAngel / ([self.particlesCounter[1] doubleValue] + 1);
    
    for (int i = 0; i<[self.particlesCounter[0] integerValue]; i++) {
        double angel = (double)i * mainAngel;
        float radius = center.x * ( 0.8 + scale * 0.4 );
        float x = center.x + radius * (CGFloat)cos(angel);
        float y = center.y + radius * (CGFloat)sin(angel);
        CGPoint point = CGPointMake(x, y);
        [path moveToPoint:point];
        [path addArcWithCenter:point radius:( reverse ? 0 : 8 * scale ) startAngle:0 endAngle:(CGFloat)M_PI * 2 clockwise:YES];
        
        for (int j = 0; j<[self.particlesCounter[1] integerValue]; j++) {
            double subangel = angel + (double)(j + 1) * mainSubangel;
            float x = center.x + radius * cos(subangel) * (1 + 0.5 * quadratic((CGFloat)j /(CGFloat) ([self.particlesCounter[1] floatValue] + 1)));
            float y = center.y + radius * sin(subangel) * (1 + 0.5 * quadratic((CGFloat)j /(CGFloat) ([self.particlesCounter[1] floatValue] + 1)));
            CGPoint point = CGPointMake(x, y);
            [path moveToPoint:point];
            [path addArcWithCenter:point radius:( reverse ? 0 : 1 + scale ) startAngle:0 endAngle:(CGFloat)M_PI * 2 clockwise:YES];
        }
    }
    [path closePath];
    return path;
}

CGFloat quadratic(CGFloat i){
    if (i >= 0.1 && i < 0.2) { return 0.1; }
    else if (i >= 0.2 && i < 0.3) { return 0.3; }
    else if (i >= 0.3 && i < 0.4) { return 0.6; }
    else if (i >= 0.4 && i < 0.5) { return 0.85; }
    else if (i >= 0.5 && i < 0.6) { return 0.1; }
    else if (i >= 0.6 && i < 0.7) { return 0.85; }
    else if (i >= 0.7 && i < 0.8) { return 0.6; }
    else if (i >= 0.8 && i < 0.9) { return 0.3; }
    else { return 0; }
}
@end
