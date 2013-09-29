//
//  VWWIPViewController.m
//  Unwinder
//
//  Created by Zakk Hoyt on 9/28/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWIPViewController.h"
#import "VWWCameraOverlayView.h"
#import "VWWImageMerger.h"

@interface VWWIPViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISlider *sampleWidthSlider;
@property (weak, nonatomic) IBOutlet UIImageView *mergedImage;


@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, strong) VWWCameraOverlayView *cameraOverlayView;
@property (nonatomic, weak) IBOutlet UIButton *takeSampleButton;
@property (nonatomic) NSInteger index;
@property VWWImageMerger *imageMerger;
@end

@implementation VWWIPViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    
    // Slider
    self.sampleWidthSlider.minimumValue = VWW_SAMPLE_WIDTH_MIN;
    self.sampleWidthSlider.maximumValue = VWW_SAMPLE_WIDTH_MAX;
    self.sampleWidthSlider.value = VWW_SAMPLE_WIDTH_DEFAULT;
    
    
    // Image Picker
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.showsCameraControls = NO;
        self.imagePicker.delegate = self;
        // Overlay
        self.cameraOverlayView = [[[NSBundle mainBundle] loadNibNamed:@"cameraOverlay" owner:self options:nil] objectAtIndex:0];
        self.cameraOverlayView.sampleWidth = self.sampleWidthSlider.value;
        self.imagePicker.cameraOverlayView = self.cameraOverlayView;
    } else {
        self.startButton.enabled = NO;
    }
    
    
    // Image merger
    self.imageMerger = [[VWWImageMerger alloc]init];
    
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    NSLog(@"%s", __func__);
}



- (IBAction)startButtonTouchUpInside:(id)sender {
    self.index = 0;
    [self.imageMerger beginSession];
    
    __weak VWWIPViewController *weakSelf = self;
    [self.cameraOverlayView setTakeSampleBlock:^(id sender) {
        NSLog(@"button tapped... taking picture");
        [weakSelf.imagePicker takePicture];
    }];
    
    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
    [self.popover presentPopoverFromRect:self.startButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}





- (IBAction)finishButtonTouchUpInside:(id)sender {
    [self.imageMerger finalizeSessionWithCompletion:^(UIImage *image) {
        self.mergedImage.image = image;
    }];
}



#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s", __func__);
    
//    NSString *const UIImagePickerControllerMediaType;
//    NSString *const UIImagePickerControllerOriginalImage;
//    NSString *const UIImagePickerControllerEditedImage;
//    NSString *const UIImagePickerControllerCropRect;
//    NSString *const UIImagePickerControllerMediaURL;
//    NSString *const UIImagePickerControllerReferenceURL;
//    NSString *const UIImagePickerControllerMediaMetadata;
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSLog(@"image size is %@", NSStringFromCGSize(image.size));
    
    __weak VWWIPViewController *weakSelf = self;
    [self.imageMerger addImage:image
                withSamplWidth:self.sampleWidthSlider.value
                       atIndex:self.index
                    completion:^(UIImage *image) {
                        weakSelf.mergedImage.image = image;
                    }];
    
//    self.mergedImage.image = image;
//    return;
//    [self.imageMerger addImage:image atIndex:self.index];
//    UIImage *mergedImage = [self.imageMerger mergedImage];
//    self.mergedImage.image = mergedImage;
//    self.index++;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}

@end


