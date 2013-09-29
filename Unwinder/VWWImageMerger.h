//
//  VWWImageMerger.h
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWImageMerger : NSObject

// clears samples and mergedImage
-(void)beginSession;

// inserts image and returns. Completion is fired after sample is rendered into mergedImage
-(void)addImage:(UIImage*)image withSamplWidth:(CGFloat)width atIndex:(NSInteger)index completion:(VWWUnwinderImageBlock)completion;

// Merge all images and then apply finaliztion and perhaps watermark
-(void)finalizeSessionWithCompletion:(VWWUnwinderImageBlock)completion;

// Get the current image at any time
-(UIImage*)mergedImage;


@end
