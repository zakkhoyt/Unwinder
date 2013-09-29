//
//  VWWCameraOverlayView.h
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VWWCameraOverlayView : UIView
-(void)setTakeSampleBlock:(VWWUnwinderIBActionBlock)takeSampleBlock;
@property (nonatomic) CGFloat sampleWidth;
@end
