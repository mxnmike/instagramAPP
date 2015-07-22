//
//  PictureObject.h
//  instagramAPP
//
//  Created by Mobile Apps Company on 7/21/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PictureObject : NSObject

@property (strong, nonatomic) NSString *strURLThumb;
@property (strong, nonatomic) NSString *strURLLowRes;
@property (strong, nonatomic) NSString *strURLStdRes;
@property (strong, nonatomic) UIImage *imgThumb;
@property (strong, nonatomic) UIImage *imgLowRes;
@property (strong, nonatomic) UIImage *imgStdRes;
@property (strong, nonatomic) NSString *strFromUser;

@end
