//
//  MCKImageView.m
//  CoreAssetManager
//
//  Created by mrnuku on 2016. 01. 17..
//  Copyright © 2016. mrnuku. All rights reserved.
//

#import "CoreAssetImageView.h"
//#import "CommunicationManager.h"
#import "CoreAssetManager.h"

#define ANIMATION_TRIGGER_TIME 0.01
#define ANIMATION_DURATION 0.3333

/*@interface CoreAssetImageView() <CommuncicationManagerDelegateProtocol>

@end*/

@implementation CoreAssetImageView {
    id cmBlock;
    BOOL signedToCommunicationManagerEvents;
}

#pragma mark - initializer methods

#if TARGET_INTERFACE_BUILDER
- (void)prepareForInterfaceBuilder {
    [self commonInit];
}
#endif

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)dealloc {
    if (signedToCommunicationManagerEvents) {
        //[CommunicationManager removeDelegate:self];
        signedToCommunicationManagerEvents = NO;
    }
}

- (void)commonInit {
    self.circleShaped = _circleShaped;
}

#pragma mark - logic

- (void)layoutSubviews {
    [super layoutSubviews];
    self.circleShaped = _circleShaped;
}

- (void)setCircleShaped:(BOOL)circleShaped {
    self.layer.cornerRadius = circleShaped ? self.bounds.size.width * .5 : 0;
    self.layer.masksToBounds = circleShaped;
    
    _circleShaped = circleShaped;
}

/*- (void)setParentRecord:(NSObject<CoreAssetImageViewDisplayableDelegate> *)parentRecord {
    BOOL validProtocolResponder = [_parentRecord respondsToSelector:@selector(assetNameForUserData:)];
    
    if (!signedToCommunicationManagerEvents && validProtocolResponder) {
        [CommunicationManager registerDelegate:self];
        signedToCommunicationManagerEvents = YES;
    }
    else if (signedToCommunicationManagerEvents && !validProtocolResponder) {
        [CommunicationManager removeDelegate:self];
        signedToCommunicationManagerEvents = NO;
    }
    
    _parentRecord = parentRecord;
    [self reloadAssetNameFromParent];
}*/

- (void)setAssetName:(NSString *)assetName {
    if (![assetName isEqualToString:_assetName]) {
        self.image = _emptyImage;
        
        CFTimeInterval startTime = CACurrentMediaTime();
        NSUInteger assetNameLength = _assetName.length;
        
        cmBlock = assetName.length ? [CoreAssetManager fetchImageWithName:assetName withCompletionHandler:^(UIImage *image) {
            UIImage *oldImage = self.image;
            self.image = image;
            
            CFTimeInterval downloadTime = CACurrentMediaTime() - startTime;
            
            if (!assetNameLength || downloadTime >= ANIMATION_TRIGGER_TIME) {
                
                [CATransaction begin];
                if (oldImage) {
                    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
                    crossFade.duration = ANIMATION_DURATION;
                    crossFade.fromValue = (__bridge id _Nullable)(oldImage.CGImage);
                    crossFade.toValue = (__bridge id _Nullable)(image.CGImage);
                    [self.layer addAnimation:crossFade forKey:@"animateContents"];
                }
                else {
                    CATransition *transition = [CATransition animation];
                    transition.duration = ANIMATION_DURATION;
                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    transition.type = kCATransitionFade;
                    
                    [self.layer addAnimation:transition forKey:nil];
                }
                [CATransaction commit];
            }
        }] : nil;
        
        _assetName = assetName;
    }
}

- (void)reloadAssetNameFromParent {
    if ([_parentRecord respondsToSelector:@selector(assetNameForUserData:)]) {
        self.assetName = [_parentRecord assetNameForUserData:_userData];
    }
}

/*#pragma mark - CommuncicationManagerDelegateProtocol methods

- (void)polling_didSaveTruthMoc {
    [self reloadAssetNameFromParent];
}*/

@end