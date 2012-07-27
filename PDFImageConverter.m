//
//  PDFImageConverter.m
//
//  Created by Sorin Nistor on 4/21/11.
//  Copyright 2011 iPDFdev.com. All rights reserved.
//

#import "PDFImageConverter.h"


@implementation PDFImageConverter

+ (NSData *)convertImageToPDF:(UIImage *)image{
    return [PDFImageConverter convertImageToPDF:image withResolution:96];
}

+ (NSData *)convertImageToPDF:(UIImage *)image withResolution:(CGFloat)resolution{
    return [PDFImageConverter convertImageToPDF:image withResolutionSize:CGSizeMake(resolution, resolution)];
}

+ (NSData *)convertImageToPDF:(UIImage *)image withResolutionSize:(CGSize)resolutionSize{
	if((resolutionSize.width <= 0)|| (resolutionSize.height <= 0)){
        return nil;
    }
    
    CGFloat pageWidth = image.size.width * image.scale * 72 / resolutionSize.width;
    CGFloat pageHeight = image.size.height * image.scale * 72 / resolutionSize.height;
    
    NSMutableData *pdfFile = [[NSMutableData alloc] init];
    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfFile);
    // The page size matches the image, no white borders.
    CGRect mediaBox = CGRectMake(0, 0, pageWidth, pageHeight);
    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &mediaBox, NULL);
    
    CGContextBeginPage(pdfContext, &mediaBox);
	CGContextDrawImage(pdfContext, mediaBox, [image CGImage]);
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CGDataConsumerRelease(pdfConsumer);
    
    return pdfFile;
}

+ (NSData *)convertImageToPDF:(UIImage *)image withResolution:(CGFloat)resolution maxBoundsRect:(CGRect)boundsRect pageSize:(CGSize)pageSize{
    if(resolution <= 0){
        return nil;
    }
    
    CGFloat imageWidth = image.size.width * image.scale * 72 / resolution;
    CGFloat imageHeight = image.size.height * image.scale * 72 / resolution;
    
    CGFloat sx = imageWidth / boundsRect.size.width;
    CGFloat sy = imageHeight / boundsRect.size.height;
    
    // At least one image edge is larger than maxBoundsRect
    if((sx > 1) || (sy > 1)){
        CGFloat maxScale = sx > sy ? sx :sy;
        imageWidth = imageWidth / maxScale;
        imageHeight = imageHeight / maxScale;
    }
    
    // Put the image in the top left corner of the bounding rectangle
    CGRect imageBox = CGRectMake(boundsRect.origin.x, boundsRect.origin.y + boundsRect.size.height - imageHeight, imageWidth, imageHeight);
    
    NSMutableData *pdfFile = [[NSMutableData alloc] init];
    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfFile);
    
    CGRect mediaBox = CGRectMake(0, 0, pageSize.width, pageSize.height);
    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &mediaBox, NULL);
    
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextDrawImage(pdfContext, imageBox, [image CGImage]);	
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CGDataConsumerRelease(pdfConsumer);

    return pdfFile;
}

@end
