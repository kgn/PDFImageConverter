//
//  PDFImageConverter.h
//
//  Created by Sorin Nistor on 4/21/11.
//  Copyright 2011 iPDFdev.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PDFImageConverter : NSObject

+ (NSData *)convertImageToPDF:(UIImage *)image;
+ (NSData *)convertImageToPDF:(UIImage *)image withResolution:(CGFloat)resolution;
+ (NSData *)convertImageToPDF:(UIImage *)image withResolutionSize:(CGSize)resolutionSize;
+ (NSData *)convertImageToPDF:(UIImage *)image withResolution:(CGFloat)resolution maxBoundsRect:(CGRect)boundsRect pageSize:(CGSize)pageSize;

@end
