//
//  scoresViewController.m
//  Caffeine Run
//
//  Created by Scott Nelson on 10/21/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import "scoresViewController.h"
#import "uvuViewController.h"

@interface scoresViewController ()
@end
NSString* newName;

@implementation scoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //check if made top 10
    if ([self checkTopTen]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Initials:" message:@"Please enter your initials (only first three letters used):" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert addButtonWithTitle:@"Go"];
        [alert show];
    }
    else {
        [self displayScores];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textfield = [alertView textFieldAtIndex:0];
    NSString *input = textfield.text;
    if (input.length > 3){
        input = [input substringToIndex:3];
    }
    input = [input uppercaseString];
    newName = input;
    
    if (newName.length == 0){
        newName = @"ABC";
    }
    [self updateScores];
}

- (BOOL)checkTopTen{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //make sure initialized
    for (int i=1; i<11; i++){
        NSString *key = [NSString stringWithFormat:@"%i", i];
        NSString *nameKey = [NSString stringWithFormat:@"Name%i", i];
        if (([defaults objectForKey:key] == nil) || ([defaults objectForKey:nameKey] == nil)){
            [defaults setInteger:i forKey:key];
            [defaults setObject:@"AAA" forKey:nameKey];
            [defaults synchronize];
        }
    }

    //check if in top 10
    for (int i=10; i>0; i--){
        NSString *key = [NSString stringWithFormat:@"%i", i];
        if ([defaults integerForKey:key] < _userScore){
            return true;
        }
    }
    
    return false;
}

-(void) updateScores {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger myNewScore = _userScore;
    
    for (int i=10; i>0; i--){
        NSString *key = [NSString stringWithFormat:@"%i", i];
        NSString *nameKey = [NSString stringWithFormat:@"Name%i", i];
        if ([defaults integerForKey:key] < myNewScore){
            NSInteger temp = [defaults integerForKey:key];
            NSString* tempName = [defaults objectForKey:nameKey];
            
            [defaults setInteger:myNewScore forKey:key];
            [defaults setObject:newName forKey:nameKey];
            
            myNewScore = temp;
            newName = tempName;
        }
    }
    [self displayScores];
}

-(void)displayScores{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //update names and numbers on the screen
    NSArray *names = [NSArray arrayWithObjects:_name1,_name2,_name3,_name4,_name5,_name6,_name7,_name8,_name9,_name10, nil];
    NSArray *scores = [NSArray arrayWithObjects:_score1,_score2,_score3,_score4,_score5,_score6,_score7,_score8,_score9,_score10, nil];
    
    for (int i=10; i>0;i--){
        NSString *numKey = [NSString stringWithFormat:@"%i", i];
        NSInteger tempInt = [defaults integerForKey:numKey];
        
        NSString *nameKey = [NSString stringWithFormat:@"Name%i", i];
        NSString* tempName = [defaults objectForKey:nameKey];
        UITextView *name = names[i-1];
        UITextView *score = scores[i-1];
        name.text = tempName;
        
        NSString* newStringInt = [NSString stringWithFormat:@"%li", (long)tempInt];
        score.text = newStringInt;
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"scoresToMain"]){
        uvuViewController *main = (uvuViewController *)segue.destinationViewController;
        main.city = self.city;
        main.isMale = self.isMale;
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
