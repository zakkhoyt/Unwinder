//
//  VWWCameraOverlayView.m
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWCameraOverlayView.h"
#import "VWWSampleBorderView.h"

@interface VWWCameraOverlayView ()
@property (nonatomic, strong) VWWUnwinderIBActionBlock takeSampleBlock;
@property (weak, nonatomic) IBOutlet VWWSampleBorderView *sampleBorderView;
@end

@implementation VWWCameraOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


#pragma mark IBActions
- (IBAction)takeSampleButtonTouchUpInside:(id)sender {
    self.takeSampleBlock(sender);
}



#pragma mark Public methods
-(void)setTakeSampleBlock:(VWWUnwinderIBActionBlock)takeSampleBlock{
    _takeSampleBlock = takeSampleBlock;
    [self setNeedsDisplay];
}


-(void)setSampleWidth:(CGFloat)sampleWidth{
    _sampleWidth = sampleWidth;
    [self setNeedsDisplay];
}

@end
