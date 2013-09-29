//
//  VWWImageMerger.h
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VWWImageMerger : NSObject

-(id)initWithSize:(CGSize)size;
-(void)addImage:(UIImage*)image atIndex:(NSInteger)index;
-(void)removeImageAtIndex:(NSInteger)index;
-(UIImage*)mergedImage;
-(void)clear;
    
@property (nonatomic) float sampleWidth;
@end
