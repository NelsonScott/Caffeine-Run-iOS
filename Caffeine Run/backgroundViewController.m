//
//  backgroundViewController.m
//  Caffeine Run
//
//  Created by Scott Nelson on 10/15/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import "backgroundViewController.h"
#import "uvuViewController.h"

@interface backgroundViewController ()

@end

@implementation backgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    uvuViewController *control = (uvuViewController *)segue.destinationViewController;

    if([segue.identifier isEqualToString:@"city1"])
    {
        control.isMale = self.isMale;
        control.city = 0;
    }
    else if ([segue.identifier isEqualToString:@"city2"]) {
        control.isMale = self.isMale;
        control.city = 1;
    }
    else if ([segue.identifier isEqualToString:@"underwater"]) {
        control.isMale = self.isMale;
        control.city = 2;
    }
    else if ([segue.identifier isEqualToString:@"space"]) {
        control.isMale = self.isMale;
        control.city = 3;
    }
    
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
