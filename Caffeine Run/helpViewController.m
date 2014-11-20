//
//  helpViewController.m
//  Caffeine Run
//
//  Created by Scott Nelson on 10/15/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import "helpViewController.h"
#import "uvuViewController.h"
@interface helpViewController ()
@end

@implementation helpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    uvuViewController *main = (uvuViewController *)segue.destinationViewController;
    main.city = self.city;
    main.isMale = self.isMale;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
