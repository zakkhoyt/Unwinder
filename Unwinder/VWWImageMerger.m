//
//  VWWImageMerger.m
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWImageMerger.h"
#import "UIImage+Resize.h"


// Each sample will have
const NSString *VWWSampleIndex = @"index";
const NSString *VWWSampleWidth = @"width";
const NSString *VWWSampleOriginalImage = @"image";



@interface VWWImageMerger ()
@property (nonatomic) CGSize size;
@property (nonatomic, strong) UIImage *mergedImage;
@property (nonatomic, strong) NSMutableArray *samples;
@property (nonatomic) CGFloat xOffset;
@end

@implementation VWWImageMerger
// 1,024, 719

-(id)init{
    self = [super init];
    if(self){
        self.samples = [@[]mutableCopy];
    }
    return self;
}
#pragma mark Private methods

//-(UIImage*)cropImageToSelection:(NSDictionary*)sample{
//
//    // First resize so that the heights match
//    UIImage *image = [sample[VWWSampleOriginalImage] copy];
//    NSLog(@"original sample image size: %@", NSStringFromCGSize(image.size));
//    float ratio =  self.size.height / (float)image.size.height;
//    CGSize newImageSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
//    NSLog(@"new sample image size: %@", NSStringFromCGSize(newImageSize));
////    UIImage *resizedImage = [self resizeImage:originalImage toSize:newImageSize];
//    [image resizedImage:newImageSize interpolationQuality:kCGInterpolationNone];
//
//
//
//    // Now take our middle sample
//    NSNumber *widthNumber = sample[VWWSampleWidth];
//    CGRect cropRect = CGRectMake((image.size.width - widthNumber.floatValue) / 2.0,
//                                 0,
//                                 widthNumber.floatValue,
//                                 self.size.height);
//    NSLog(@"Cropping sample rect %@", NSStringFromCGRect(cropRect));
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
//    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//
//    return croppedImage;
//}
//
//
//-(void)mergeImages{
//    UIGraphicsBeginImageContext(self.size);
//    CGFloat currentX = 0.0;
//    for(NSInteger index = 0; index < self.samples.count; index++){
//        NSDictionary *sample = [self sampleForIndex:index];
//        NSAssert(sample != nil, @"Sample cannot be nil");
//        UIImage *croppedImage = [self cropImageToSelection:sample];
//        NSNumber *widthNumber = sample[VWWSampleWidth];
//        CGRect sampleRect = CGRectMake(currentX, 0, widthNumber.floatValue, self.size.height);
//        [croppedImage drawInRect:sampleRect];
//        currentX += ((NSNumber*)sample[VWWSampleWidth]).floatValue;
//    }
//    self.mergedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}

-(NSDictionary*)sampleForIndex:(NSInteger)index{
    
    for(NSDictionary *sample in self.samples){
        NSNumber *indexNumber = sample[VWWSampleIndex];
        if(indexNumber.integerValue == index) return sample;
    }
    
    return nil;
}


-(UIImage*)cropImageToSelection:(NSDictionary*)sample{

    // First resize so that the heights match
    UIImage *image = [sample[VWWSampleOriginalImage] copy];
    NSLog(@"original sample image size: %@", NSStringFromCGSize(image.size));
    float ratio =  self.size.height / (float)image.size.height;
    CGSize newImageSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
    NSLog(@"new sample image size: %@", NSStringFromCGSize(newImageSize));
//    UIImage *resizedImage = [self resizeImage:originalImage toSize:newImageSize];
    [image resizedImage:newImageSize interpolationQuality:kCGInterpolationNone];



    // Now take our middle sample
    NSNumber *widthNumber = sample[VWWSampleWidth];
    CGRect cropRect = CGRectMake((image.size.width - widthNumber.floatValue) / 2.0,
                                 0,
                                 widthNumber.floatValue,
                                 self.size.height);
    NSLog(@"Cropping sample rect %@", NSStringFromCGRect(cropRect));
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

    return croppedImage;
}


//-(void)renderSampleIntoMergedImage:(NSDictionary*)sample{
//    
//}
//
//-(void)mergeImages{
//    UIGraphicsBeginImageContext(self.size);
//    CGFloat currentX = 0.0;
//    for(NSInteger index = 0; index < self.samples.count; index++){
//        NSDictionary *sample = [self sampleForIndex:index];
//        NSAssert(sample != nil, @"Sample cannot be nil");
//        UIImage *croppedImage = [self cropImageToSelection:sample];
//        NSNumber *widthNumber = sample[VWWSampleWidth];
//        CGRect sampleRect = CGRectMake(currentX, 0, widthNumber.floatValue, self.size.height);
//        [croppedImage drawInRect:sampleRect];
//        currentX += ((NSNumber*)sample[VWWSampleWidth]).floatValue;
//    }
//    self.mergedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}


-(void)insertSampleintoImage:(NSDictionary*)sample completion:(VWWUnwinderImageBlock)completion{
    
    // First resize so that the heights match
    UIImage *image = [sample[VWWSampleOriginalImage] copy];
    NSLog(@"original sample image size: %@", NSStringFromCGSize(image.size));
    UIImage *croppedImage = [self cropImageToSelection:sample];
    
    // Then render it into our output image
    NSNumber *widthNumber = sample[VWWSampleWidth];
    CGRect sampleRect = CGRectMake(self.xOffset, 0, widthNumber.floatValue, self.size.height);
    [croppedImage drawInRect:sampleRect];
    self.xOffset += ((NSNumber*)sample[VWWSampleWidth]).floatValue;
    
    
    self.mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    completion(self.mergedImage);
//    // Now take our middle sample
//    NSNumber *widthNumber = sample[VWWSampleWidth];
//    CGRect cropRect = CGRectMake((image.size.width - widthNumber.floatValue) / 2.0,
//                                 0,
//                                 widthNumber.floatValue,
//                                 self.size.height);
//    NSLog(@"Cropping sample rect %@", NSStringFromCGRect(cropRect));
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
//    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
    
    
    
    
//    return croppedImage;
    
    
}


#pragma mark Public methods

// clears samples and mergedImage
-(void)beginSession{
    [self.samples removeAllObjects];
    self.xOffset = 0;
    
    UIGraphicsBeginImageContext(self.size);
}

// inserts image and returns. Completion is fired after sample is rendered into mergedImage
-(void)addImage:(UIImage*)image withSamplWidth:(CGFloat)width atIndex:(NSInteger)index completion:(VWWUnwinderImageBlock)completion{
    
    // Set size if this is the first sample
    if(self.samples.count == 0){
        self.size = image.size;
        NSLog(@"%s Setting imageMerger.size to: %@", __func__, NSStringFromCGSize(self.size));
    }
    
    // Create sample, store
    NSDictionary *sample = @{VWWSampleIndex : @(index),
                             VWWSampleWidth : @(width),
                             VWWSampleOriginalImage : image};
    [self.samples addObject:sample];
    
    // Apply sample to merged image
    [self insertSampleintoImage:sample completion:^(UIImage *image) {
        completion(image);
    }];
}

// Merge all images and then apply finaliztion and perhaps watermark
-(void)finalizeSessionWithCompletion:(VWWUnwinderImageBlock)completion{
    // TODO: watermark
    
    
    
    UIGraphicsEndImageContext();
    
    
    // For now just return the mergedImage
    completion(self.mergedImage);
}

// Get the current image at any time
-(UIImage*)mergedImage{
    return _mergedImage;
}


// Below here is the first revision.




//-(UIImage*)cropImageToSelection:(NSDictionary*)sample{
//   
//    // First resize so that the heights match
//    UIImage *image = [sample[VWWSampleOriginalImage] copy];
//    NSLog(@"original sample image size: %@", NSStringFromCGSize(image.size));
//    float ratio =  self.size.height / (float)image.size.height;
//    CGSize newImageSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
//    NSLog(@"new sample image size: %@", NSStringFromCGSize(newImageSize));
////    UIImage *resizedImage = [self resizeImage:originalImage toSize:newImageSize];
//    [image resizedImage:newImageSize interpolationQuality:kCGInterpolationNone];
//    
//    
//    
//    // Now take our middle sample
//    NSNumber *widthNumber = sample[VWWSampleWidth];
//    CGRect cropRect = CGRectMake((image.size.width - widthNumber.floatValue) / 2.0,
//                                 0,
//                                 widthNumber.floatValue,
//                                 self.size.height);
//    NSLog(@"Cropping sample rect %@", NSStringFromCGRect(cropRect));
//    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
//    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    
//    return croppedImage;
//}
//
//
//-(void)mergeImages{
//    UIGraphicsBeginImageContext(self.size);
//    CGFloat currentX = 0.0;
//    for(NSInteger index = 0; index < self.samples.count; index++){
//        NSDictionary *sample = [self sampleForIndex:index];
//        NSAssert(sample != nil, @"Sample cannot be nil");
//        UIImage *croppedImage = [self cropImageToSelection:sample];
//        NSNumber *widthNumber = sample[VWWSampleWidth];
//        CGRect sampleRect = CGRectMake(currentX, 0, widthNumber.floatValue, self.size.height);
//        [croppedImage drawInRect:sampleRect];
//        currentX += ((NSNumber*)sample[VWWSampleWidth]).floatValue;
//    }
//    self.mergedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//}
//
//
//#pragma mark Public methods
//-(id)initWithSize:(CGSize)size{
//    self = [super init];
//    if(self){
//        self.size = size;
//        self.samples = [@[]mutableCopy];
//        self.sampleWidth = VWW_SAMPLE_WIDTH_DEFAULT;
//        NSLog(@"%s size: %@", __func__, NSStringFromCGSize(self.size));
//    }
//    return self;
//}
//
//-(void)addImage:(UIImage*)image atIndex:(NSInteger)index{
//    NSDictionary *sample = @{VWWSampleIndex : @(index),
//                             VWWSampleWidth : @(self.sampleWidth),
//                             VWWSampleOriginalImage : image};
//    [self.samples addObject:sample];
//}
//
//-(void)removeImageAtIndex:(NSInteger)index{
//    for(NSInteger index = 0; index < self.samples.count; index++){
//        NSDictionary *sample = self.samples[index];
//        NSNumber *indexNumber = sample[VWWSampleIndex];
//        if(indexNumber.integerValue == index){
//            [self.samples removeObjectAtIndex:index];
//            return;
//        }
//    }
//}
//-(void)clear{
//    [self.samples removeAllObjects];
//    self.mergedImage = nil;
//}
//
//-(UIImage*)mergedImage{
//    [self mergeImages];
//    return _mergedImage;
//}

@end
