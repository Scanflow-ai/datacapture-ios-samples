//
//  ScanflowTextManager.h
//  ScanflowText
//
//  Created by Mac-OBS-46 on 29/11/22.
//

#include <CoreMedia/CMBase.h>
#include <CoreMedia/CMTime.h>
#include <CoreMedia/CMTimeRange.h>
#include <CoreMedia/CMFormatDescription.h>
#include <CoreMedia/CMAttachment.h>
#include <CoreMedia/CMBufferQueue.h>
#include <CoreMedia/CMBlockBuffer.h>
#include <CoreMedia/CMSampleBuffer.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol TextDetectionDelegate <NSObject>

- (void)recognitionComplete:(NSString *)result processedImage:(UIImage *) inputImage;

@end


@interface TextDetection : NSObject

@property(nonatomic, strong) id<TextDetectionDelegate> delegate;

- (void)initModel;
- (void)processImage:(UIImage*)sampleBuffer;

@end
