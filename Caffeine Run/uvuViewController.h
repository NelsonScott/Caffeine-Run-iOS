//
//  uvuViewController.h
//  Caffeine Run
//
//  Created by Scott Nelson on 10/4/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface uvuViewController : UIViewController
@property (strong, nonatomic) CMMotionManager *motionManager;
@property(nonatomic) bool isMale;
@property(nonatomic) int city;
@end
