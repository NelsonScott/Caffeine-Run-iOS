//
//  scoresViewController.h
//  Caffeine Run
//
//  Created by Scott Nelson on 10/21/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scoresViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *name10;
@property (weak, nonatomic) IBOutlet UITextView *name9;
@property (weak, nonatomic) IBOutlet UITextView *name8;
@property (weak, nonatomic) IBOutlet UITextView *name7;
@property (weak, nonatomic) IBOutlet UITextView *name6;
@property (weak, nonatomic) IBOutlet UITextView *name5;
@property (weak, nonatomic) IBOutlet UITextView *name4;
@property (weak, nonatomic) IBOutlet UITextView *name3;
@property (weak, nonatomic) IBOutlet UITextView *name2;
@property (weak, nonatomic) IBOutlet UITextView *name1;

@property (weak, nonatomic) IBOutlet UITextView *score10;
@property (weak, nonatomic) IBOutlet UITextView *score9;
@property (weak, nonatomic) IBOutlet UITextView *score8;
@property (weak, nonatomic) IBOutlet UITextView *score7;
@property (weak, nonatomic) IBOutlet UITextView *score6;
@property (weak, nonatomic) IBOutlet UITextView *score5;
@property (weak, nonatomic) IBOutlet UITextView *score4;
@property (weak, nonatomic) IBOutlet UITextView *score3;
@property (weak, nonatomic) IBOutlet UITextView *score2;
@property (weak, nonatomic) IBOutlet UITextView *score1;

@property(nonatomic) int userScore;
@property(nonatomic) bool isMale;
@property(nonatomic) int city;
@end
