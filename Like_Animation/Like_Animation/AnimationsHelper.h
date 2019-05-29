//
//  AnimationsHelper.h
//  Like_Animation
//
//  Created by Lemon on 2019/5/28.
//  Copyright © 2019 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimationProtocol <NSObject>

-(void)runAnimationOnLayer:(CAShapeLayer *)layer;

@end

@interface Animation : NSObject <AnimationProtocol>
@property (nonatomic,copy) void(^beforeAction)(void);
@property (nonatomic,copy) void(^afterAction)(void);

- (instancetype)initWithAnimation:(CAAnimation *)animation;
- (instancetype)initP:(NSString *)path f:(id)fromValue t:(id)toValue d:(CFTimeInterval)duration b:(void(^)(void))before a:(void(^)(void))after;
@end

@interface AnimationGroup : Animation 
@property (nonatomic,strong) NSArray <Animation *>* animations;
- (instancetype)initDuration:(CFTimeInterval)duration animations:(NSArray <Animation *>*)animations;

@end

@interface AnimationSequence : CAAnimation <CAAnimationDelegate>
@property (nonatomic,strong) NSMutableArray <Animation *>* animations;
@property (nonatomic,strong) CAShapeLayer* layer;
@property (nonatomic,assign) NSInteger index;

-(void)addDelay:(CFTimeInterval)duration;
-(void)addDelay:(CFTimeInterval)duration beforeAction:(void(^)(void))before afterAction:(void(^)(void))after;
-(void)addCaAnimation:(CAAnimation *)caAnimation;
-(void)addAnimation:(Animation *)animation;
-(void)runAnimationOnLayer:(CAShapeLayer *)layer;
@end


