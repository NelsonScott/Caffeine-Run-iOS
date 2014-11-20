//
//  charactersViewController.m
//  Caffeine Run
//
//  Created by Scott Nelson on 10/15/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import "charactersViewController.h"
#import "backgroundViewController.h"

@interface charactersViewController ()
@end

@implementation charactersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToCharSelect:(UIStoryboardSegue*)sender{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"malePushSegue"])
    {
        backgroundViewController *control = (backgroundViewController *)segue.destinationViewController;
        control.isMale = YES;
    }
    else {
        backgroundViewController *control = (backgroundViewController *)segue.destinationViewController;
        control.isMale = NO;
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
