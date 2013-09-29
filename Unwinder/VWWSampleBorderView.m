//
//  VWWSampleBorderView.m
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWSampleBorderView.h"

@implementation VWWSampleBorderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)drawLineWithContext:(CGContextRef)cgContext fromPoint:(CGPoint)begin toPoint:(CGPoint)end{
//    // Don't draw the line unless both points are not set.
//    if((begin.x == 0 && begin.y == 0) ||
//       (end.x == 0 && end.y == 0)){
//        return;
//    }
    CGContextMoveToPoint(cgContext,
                         begin.x,
                         begin.y);
    
    CGContextAddLineToPoint(cgContext,
                            end.x,
                            end.y);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(cgContext);
    CGContextSetLineWidth(cgContext, 2.0f);
    
    CGFloat greenColor[4] = {0.0, 1.0, 0.0, 1.0};
//    CGFloat yellowColor[4] = {1.0, 1.0, 0.0, 1.0};
//    CGFloat redColor[4] = {1.0, 0.0, 0.0, 1.0};
    
    
    CGPoint leftBegin = CGPointMake(230, 0);
    CGPoint leftEnd = CGPointMake(230, 360);
    CGContextSetStrokeColor(cgContext, greenColor);
    [self drawLineWithContext:cgContext
                    fromPoint:leftBegin
                      toPoint:leftEnd];

    
    CGPoint rightBegin = CGPointMake(250, 0);
    CGPoint rightEnd = CGPointMake(250, 360);
    CGContextSetStrokeColor(cgContext, greenColor);
    [self drawLineWithContext:cgContext
                    fromPoint:rightBegin
                      toPoint:rightEnd];

    
    
    CGContextStrokePath(cgContext);
    
    
}


@end
