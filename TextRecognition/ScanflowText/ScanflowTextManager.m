//
//  ScanflowTextManager.m
//  ScanflowText
//
//  Created by Mac-OBS-46 on 28/11/22.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/videoio/cap_ios.h>
// clang-format on
#import "ScanflowTextManager.h"
#include <pipeline.h>
#include "timer.h"
#include <arm_neon.h>
#include <iostream>
#include <mutex>
#include "paddle_api.h"
#include "paddle_use_kernels.h"
#include "paddle_use_ops.h"
#include <string>
#import <sys/timeb.h>
#include <vector>

using namespace paddle::lite_api;
using namespace cv;

std::mutex mtx;
Pipeline *pipe_;
Timer tic;
long long count = 0;

@interface TextDetection ()

@property(nonatomic) std::string dict_path;
@property(nonatomic) std::string config_path;
@property(nonatomic) cv::Mat cvimg;



@end

@implementation TextDetection

-(void) initModel {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    
    std::string paddle_dir = std::string([path UTF8String]);
    std::string framewok =  paddle_dir + "/Frameworks";
    
    std::string padOcr =  framewok + "/PaddleOcr.framework";
    
    
    std::string det_model_file =
    padOcr + "/ch_ppocr_mobile_v2.0_det_opt.nb";
    
    std::string rec_model_file =
    padOcr + "/ch_ppocr_mobile_v2.0_rec_opt.nb";
    
    std::string cls_model_file =
    padOcr + "/ch_ppocr_mobile_v2.0_cls_opt.nb";
    
    std::string img_path = padOcr + "/test.jpg";
    std::string output_img_path = padOcr + "/test_result.jpg";
    self.dict_path = padOcr + "/ppocr_keys_v1.txt";
    self.config_path = padOcr + "/config.txt";
    
  
    pipe_ = new Pipeline(det_model_file, cls_model_file, rec_model_file,
                         "LITE_POWER_HIGH", 1, self.config_path, self.dict_path);
    
}




- (void)processImage:(UIImage*)sampleBuffer {
  

    
    cv::Mat srcimg;
    UIImageToMat(sampleBuffer,srcimg);
    
    cv::Mat outCopyImg;
    
    if (srcimg.channels() == 4) {
        cvtColor(srcimg, outCopyImg, COLOR_RGBA2BGR);
    } else {
        cvtColor(srcimg, outCopyImg, COLOR_RGB2BGR);
    }
    
    
    std::vector<std::string> res_txt;
    std::vector<float> res_txt_score;
    cv::Mat img_vis =
    pipe_->Process(outCopyImg,res_txt,res_txt_score);
    
    //print recognized text
    std::ostringstream result;
    
    for (int i = 0; i < res_txt.size(); i++) {
        
        NSString *elementText = [NSString stringWithUTF8String:res_txt[i].c_str()];
        NSLog(@"%@",elementText);
        
        float accuracy = res_txt_score[i];
        NSLog(@"%@",[NSString stringWithFormat:@"%f",accuracy]);
        
        //识别17位的VIN码
        if (accuracy>0.5) {
           
            NSLog(@"%@",elementText);
            [self.delegate recognitionComplete:elementText];
        }
       
    }
   
    return;
    
}


- (UIImage *) imageFromSamplePlanerPixelBuffer:(CMSampleBufferRef)sampleBuffer{
    @autoreleasepool {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        void *baseAddress = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
        
        // Get the number of bytes per row for the plane pixel buffer
        size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
        // Get the pixel buffer width and height
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        // Create a device-dependent RGB color space
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                     bytesPerRow, colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
        // Create a Quartz image from the pixel data in the bitmap graphics context
        CGImageRef quartzImage = CGBitmapContextCreateImage(context);
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        // Free up the context and color space
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        // Create an image object from the Quartz image
        UIImage *image = [UIImage imageWithCGImage:quartzImage];
        
        // Release the Quartz image
        CGImageRelease(quartzImage);
        return (image);
    }
}

@end
