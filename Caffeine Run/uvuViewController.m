//
//  uvuViewController.m
//  Caffeine Run
//
//  Created by Scott Nelson on 10/4/14.
//  Copyright (c) 2014 uVu Technologies. All rights reserved.
//

#import "uvuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "scoresViewController.h"
#import "helpViewController.h"
#include <stdlib.h>

@interface uvuViewController ()
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIImageView *mainCharacter;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImages;
@property (weak, nonatomic) IBOutlet UIImageView *gameOverView;
@property (weak, nonatomic) IBOutlet UIButton *musicButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *backToSelection;
@property (weak, nonatomic) IBOutlet UIImageView *fallRight;
@property (weak, nonatomic) IBOutlet UIImageView *fallLeft;
@property (weak, nonatomic) IBOutlet UIButton *powerUpRight;
@property (weak, nonatomic) IBOutlet UIButton *powerUpLeft;
@property (weak, nonatomic) IBOutlet UIImageView *dog;
@property (weak, nonatomic) IBOutlet UIImageView *obstacleRight;
@property (weak, nonatomic) IBOutlet UIImageView *obstacleLeft;
@property (weak, nonatomic) IBOutlet UITextView *score;
@property (weak, nonatomic) IBOutlet UITextView *level;
@property (weak, nonatomic) IBOutlet UIImageView *scorelevelholder;
@end
AVAudioPlayer *_audioPlayer;
AVAudioPlayer *_gameOverPlayer;
NSMutableArray *bgImages, *powerUpImages, *dogImages, *catImages;
double elapsedTime, oriented;
double startTime;
double bonus;
int landScape, delta = 2, difficulty;
float moveRightLimit, moveLeftLimit, currentPosition, gravity, gravity_value;
float moveIncrement;
float charWidth, charHeight;
NSMutableArray *charImages, *charTiltImages;
bool tilted = false, musicPaused, flipped = false, fromRight, ragTime = false;
NSTimer *timer, *obstacleTimer, *moveTimer;
@implementation uvuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *path = [NSString stringWithFormat:@"%@/uVuLoop.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    NSLog(@"Main screen loaded");
    NSString *gameOverPath = [NSString stringWithFormat:@"%@/gameOverSound.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *overSoundUrl = [NSURL fileURLWithPath:gameOverPath];
    
    //show buttons
    _startButton.hidden = NO;
    _helpButton.hidden = NO;
    _musicButton.hidden = NO;
    _backToSelection.hidden = NO;
    
    NSArray *dogNames = @[@"dog_laugh0001.png", @"dog_laugh0002.png", @"dog_laugh0003.png", @"dog_laugh0004.png"];
    dogImages = [[NSMutableArray alloc] init];
    for (int i=0; i<dogNames.count; i++){
        [dogImages addObject:[UIImage imageNamed:[dogNames objectAtIndex:i]]];
    }
    
    NSArray *powerUpNames = @[@"bonus10001.png",@"bonus10002.png",@"bonus10003.png",@"bonus10004.png",@"bonus10005.png",@"bonus10006.png",@"bonus10007.png",@"bonus10008.png",@"bonus10009.png",@"bonus10010.png"];
    
    powerUpImages = [[NSMutableArray alloc] init];
    for (int i = 0; i< powerUpNames.count; i++){
        [powerUpImages addObject:[UIImage imageNamed:[powerUpNames objectAtIndex:i]]];
    }
    
    _powerUpRight.imageView.animationImages = powerUpImages;
    _powerUpLeft.imageView.animationImages = powerUpImages;
    _powerUpRight.imageView.animationDuration = 0.5;
    _powerUpLeft.imageView.animationDuration = 0.5;
    [_powerUpRight.imageView startAnimating];
    [_powerUpLeft.imageView startAnimating];
    
    //Orientation changes affect gameplay
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if(orientation == UIDeviceOrientationLandscapeLeft)
    {
        landScape = 1;
    }
    else if(orientation == UIDeviceOrientationLandscapeRight)
    {
        landScape = -1;
    }

    // Create audio player object and initialize with URL to sound
    if (_audioPlayer == nil){
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        _audioPlayer.numberOfLoops = -1;
        [_audioPlayer play];
    }
    if (_gameOverPlayer == nil){
        _gameOverPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:overSoundUrl error:nil];
    }
    
        if (_city == 0){
            //city daytime
            NSLog(@"Chose DayTime");
            
            NSArray *catNames = @[@"cat0001.png",@"cat0002.png",@"cat0003.png",@"cat0004.png",@"cat0005.png",@"cat0006.png",@"cat0007.png",@"cat0008.png",@"cat0009.png",@"cat0010.png"];
            
            catImages = [[NSMutableArray alloc] init];
            for (int i=0; i<catNames.count; i++){
                [catImages addObject:[UIImage imageNamed:[catNames objectAtIndex:i]]];
            }

            NSArray *bgNames = @[@"bg0004.png",@"bg0007.png",@"bg0010.png",@"bg0013.png",@"bg0016.png",@"bg0019.png",@"bg0022.png",@"bg0025.png",@"bg0028.png",@"bg0031.png",@"bg0034.png",@"bg0037.png",@"bg0040.png",@"bg0043.png",@"bg0046.png",@"bg0049.png",@"bg0052.png",@"bg0055.png",@"bg0058.png"];
            
            bgImages = [[NSMutableArray alloc] init];
            for (int i = 0; i< bgNames.count; i++){
                [bgImages addObject:[UIImage imageNamed:[bgNames objectAtIndex:i]]];
            }
            
            //female character normal
            if (!_isMale){
                _mainCharacter.image = [UIImage imageNamed:@"char20001.png"];
                _fallLeft.image = [UIImage imageNamed:@"char20017.png"];
                _fallRight.image = [UIImage imageNamed:@"char20018.png"];
                
                NSArray *imageNames = @[@"char20001.png",@"char20002.png",@"char20003.png",@"char20004.png",@"char20005.png",@"char20006.png",@"char20007.png",@"char20008.png",@"char20009.png",@"char20010.png",@"char20011.png",@"char20012.png",@"char20013.png",@"char20014.png",@"char20015.png",@"char20016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char2_tilt0001.png",@"char2_tilt0004.png",@"char2_tilt0007.png",@"char2_tilt0010.png",@"char2_tilt0013.png",@"char2_tilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
            }
            //male character normal
            else {
                NSArray *imageNames = @[@"char10001.png",@"char10002.png",@"char10003.png",@"char10004.png",@"char10005.png",@"char10006.png",@"char10007.png",@"char10008.png",@"char10009.png",@"char10010.png",@"char10011.png",@"char10012.png",@"char10013.png",@"char10014.png",@"char10015.png",@"char10016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char1_tilt0001.png",@"char1_tilt0004.png",@"char1_tilt0007.png",@"char1_tilt0010.png",@"char1_tilt0013.png",@"char1_tilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
                
            }
        }
        else if (_city == 1){
            //city nighttime
            NSLog(@"Chose nighttime");
            
            NSArray *catNames = @[@"cat0001.png",@"cat0002.png",@"cat0003.png",@"cat0004.png",@"cat0005.png",@"cat0006.png",@"cat0007.png",@"cat0008.png",@"cat0009.png",@"cat0010.png"];
            
            catImages = [[NSMutableArray alloc] init];
            for (int i=0; i<catNames.count; i++){
                [catImages addObject:[UIImage imageNamed:[catNames objectAtIndex:i]]];
            }

            _backgroundImages.image = [UIImage imageNamed:@"bgcity20001.png"];
            
            NSArray *bgNames = @[@"bgcity20004.png",@"bgcity20007.png",@"bgcity20010.png",@"bgcity20013.png",@"bgcity20016.png",@"bgcity20019.png",@"bgcity20022.png",@"bgcity20025.png",@"bgcity20028.png",@"bgcity20031.png",@"bgcity20034.png",@"bgcity20037.png",@"bgcity20040.png",@"bgcity20043.png",@"bgcity20046.png",@"bgcity20049.png",@"bgcity20052.png",@"bgcity20055.png",@"bgcity20058.png"];
            
            bgImages = [[NSMutableArray alloc] init];
            for (int i = 0; i< bgNames.count; i++){
                [bgImages addObject:[UIImage imageNamed:[bgNames objectAtIndex:i]]];
            }
            
            //female character normal
            if (!_isMale){
                _mainCharacter.image = [UIImage imageNamed:@"char20001.png"];
                _fallLeft.image = [UIImage imageNamed:@"char20017.png"];
                _fallRight.image = [UIImage imageNamed:@"char20018.png"];
                
                NSArray *imageNames = @[@"char20001.png",@"char20002.png",@"char20003.png",@"char20004.png",@"char20005.png",@"char20006.png",@"char20007.png",@"char20008.png",@"char20009.png",@"char20010.png",@"char20011.png",@"char20012.png",@"char20013.png",@"char20014.png",@"char20015.png",@"char20016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char2_tilt0001.png",@"char2_tilt0004.png",@"char2_tilt0007.png",@"char2_tilt0010.png",@"char2_tilt0013.png",@"char2_tilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
            }
            //male character normal
            else {
                NSArray *imageNames = @[@"char10001.png",@"char10002.png",@"char10003.png",@"char10004.png",@"char10005.png",@"char10006.png",@"char10007.png",@"char10008.png",@"char10009.png",@"char10010.png",@"char10011.png",@"char10012.png",@"char10013.png",@"char10014.png",@"char10015.png",@"char10016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char1_tilt0001.png",@"char1_tilt0004.png",@"char1_tilt0007.png",@"char1_tilt0010.png",@"char1_tilt0013.png",@"char1_tilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
                
            }
        }
        else if (_city == 2){
            //underwater scene
            NSLog(@"Chose water");
            
            NSArray *catNames = @[@"cat0011.png",@"cat0012.png",@"cat0013.png",@"cat0014.png",@"cat0015.png",@"cat0016.png",@"cat0017.png",@"cat0018.png",@"cat0019.png",@"cat0020.png"];
            catImages = [[NSMutableArray alloc] init];
            for (int i=0; i<catNames.count; i++){
                [catImages addObject:[UIImage imageNamed:[catNames objectAtIndex:i]]];
            }
            
            _backgroundImages.image = [UIImage imageNamed:@"bg_underwater0001.png"];
            
            NSArray *bgNames = @[@"bg_underwater0004.png",@"bg_underwater0007.png",@"bg_underwater0010.png",@"bg_underwater0013.png",@"bg_underwater0016.png",@"bg_underwater0019.png",@"bg_underwater0022.png",@"bg_underwater0025.png",@"bg_underwater0028.png",@"bg_underwater0031.png",@"bg_underwater0034.png",@"bg_underwater0037.png",@"bg_underwater0040.png",@"bg_underwater0043.png",@"bg_underwater0046.png",@"bg_underwater0049.png",@"bg_underwater0052.png",@"bg_underwater0055.png",@"bg_underwater0058.png"];
            
            bgImages = [[NSMutableArray alloc] init];
            for (int i = 0; i< bgNames.count; i++){
                [bgImages addObject:[UIImage imageNamed:[bgNames objectAtIndex:i]]];
            }
            
            if (!_isMale){
                _mainCharacter.image = [UIImage imageNamed:@"char2_underwater0001.png"];
                _fallLeft.image = [UIImage imageNamed:@"char2_underwater0017.png"];
                _fallRight.image = [UIImage imageNamed:@"char2_underwater0018.png"];
                
                NSArray *imageNames = @[@"char2_underwater0001.png",@"char2_underwater0002.png",@"char2_underwater0003.png",@"char2_underwater0004.png",@"char2_underwater0005.png",@"char2_underwater0006.png",@"char2_underwater0007.png",@"char2_underwater0008.png",@"char2_underwater0009.png",@"char2_underwater0010.png",@"char2_underwater0011.png",@"char2_underwater0012.png",@"char2_underwater0013.png",@"char2_underwater0014.png",@"char2_underwater0015.png",@"char2_underwater0016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char2_underwatertilt0001.png",@"char2_underwatertilt0004.png",@"char2_underwatertilt0007.png",@"char2_underwatertilt0010.png",@"char2_underwatertilt0013.png",@"char2_underwatertilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
            }
            else {
                _mainCharacter.image = [UIImage imageNamed:@"char1_underwater0001.png"];
                _fallLeft.image = [UIImage imageNamed:@"char1_underwater0017.png"];
                _fallRight.image = [UIImage imageNamed:@"char1_underwater0018.png"];
                
                NSArray *imageNames = @[@"char1_underwater0001.png",@"char1_underwater0002.png",@"char1_underwater0003.png",@"char1_underwater0004.png",@"char1_underwater0005.png",@"char1_underwater0006.png",@"char1_underwater0007.png",@"char1_underwater0008.png",@"char1_underwater0009.png",@"char1_underwater0010.png",@"char1_underwater0011.png",@"char1_underwater0012.png",@"char1_underwater0013.png",@"char1_underwater0014.png",@"char1_underwater0015.png",@"char1_underwater0016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char1_underwatertilt0001.png",@"char1_underwatertilt0004.png",@"char1_underwatertilt0007.png",@"char1_underwatertilt0010.png",@"char1_underwatertilt0013.png",@"char1_underwatertilt0016.png"];
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
            }
        }
        else if (_city == 3){
            //space scene
            NSLog(@"Chose water");
            
            NSArray *catNames = @[@"cat0021.png",@"cat0022.png",@"cat0023.png",@"cat0024.png",@"cat0025.png",@"cat0026.png",@"cat0027.png",@"cat0028.png",@"cat0029.png",@"cat0030.png"];
            catImages = [[NSMutableArray alloc] init];
            for (int i=0; i<catNames.count; i++){
                [catImages addObject:[UIImage imageNamed:[catNames objectAtIndex:i]]];
            }
            
            _backgroundImages.image = [UIImage imageNamed:@"bg_space0001.png"];
            
            NSArray *bgNames = @[@"bg_space0004.png",@"bg_space0007.png",@"bg_space0010.png",@"bg_space0013.png",@"bg_space0016.png",@"bg_space0019.png",@"bg_space0022.png",@"bg_space0025.png",@"bg_space0028.png",@"bg_space0031.png",@"bg_space0034.png",@"bg_space0037.png",@"bg_space0040.png",@"bg_space0043.png",@"bg_space0046.png",@"bg_space0049.png",@"bg_space0052.png",@"bg_space0055.png",@"bg_space0058.png"];
            
            bgImages = [[NSMutableArray alloc] init];
            for (int i = 0; i< bgNames.count; i++){
                [bgImages addObject:[UIImage imageNamed:[bgNames objectAtIndex:i]]];
            }
            
            if (!_isMale){
                _mainCharacter.image = [UIImage imageNamed:@"char2astronaut0001.png"];
                _fallLeft.image = [UIImage imageNamed:@"char2astronaut0017.png"];
                _fallRight.image = [UIImage imageNamed:@"char2astronaut0018.png"];
                
                NSArray *imageNames = @[@"char2astronaut0001.png",@"char2astronaut0002.png",@"char2astronaut0003.png",@"char2astronaut0004.png",@"char2astronaut0005.png",@"char2astronaut0006.png",@"char2astronaut0007.png",@"char2astronaut0008.png",@"char2astronaut0009.png",@"char2astronaut0010.png",@"char2astronaut0011.png",@"char2astronaut0012.png",@"char2astronaut0013.png",@"char2astronaut0014.png",@"char2astronaut0015.png",@"char2astronaut0016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char2astronauttilt0001.png",@"char2astronauttilt0004.png",@"char2astronauttilt0007.png",@"char2astronauttilt0010.png",@"char2astronauttilt0013.png",@"char2astronauttilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
                
            }
            else {
                _mainCharacter.image = [UIImage imageNamed:@"char1astronaut0001.png"];
                _fallLeft.image = [UIImage imageNamed:@"char1astronaut0017.png"];
                _fallRight.image = [UIImage imageNamed:@"char1astronaut0018.png"];
                
                NSArray *imageNames = @[@"char1astronaut0001.png",@"char1astronaut0002.png",@"char1astronaut0003.png",@"char1astronaut0004.png",@"char1astronaut0005.png",@"char1astronaut0006.png",@"char1astronaut0007.png",@"char1astronaut0008.png",@"char1astronaut0009.png",@"char1astronaut0010.png",@"char1astronaut0011.png",@"char1astronaut0012.png",@"char1astronaut0013.png",@"char1astronaut0014.png",@"char1astronaut0015.png",@"char1astronaut0016.png"];
                
                charImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < imageNames.count; i++) {
                    [charImages addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
                }
                
                NSArray *tiltImageNames = @[@"char1astronauttilt0001.png",@"char1astronauttilt0004.png",@"char1astronauttilt0007.png",@"char1astronauttilt0010.png",@"char1astronauttilt0013.png",@"char1astronauttilt0016.png"];
                
                charTiltImages = [[NSMutableArray alloc] init];
                for (int i = 0; i < tiltImageNames.count; i++) {
                    [charTiltImages addObject:[UIImage imageNamed:[tiltImageNames objectAtIndex:i]]];
                }
            }
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onObstacleTimer:(NSTimer*)theObstacleTimer{
    
    if (arc4random_uniform(10)>2){
        if (arc4random_uniform(10)>5){
            fromRight= true;
            _obstacleRight.hidden=NO;
            _obstacleRight.transform = CGAffineTransformMakeScale(-1,1);
            moveTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveObstacle:) userInfo:nil repeats:YES];
        }
        else {
            fromRight = false;
            _obstacleLeft.hidden=NO;
            moveTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(moveObstacle:) userInfo:nil repeats:YES];
        }
    }
}
-(void)moveObstacle:(NSTimer*)moveOb{
    
    if (fromRight){
        //Cat on right side of screen
//        int x = 370;
        int x1 = charWidth+.90*charWidth;
        int x2 = charWidth + 1.16*charWidth;
        if (_obstacleRight.frame.origin.x>x1 && !flipped){
            [_obstacleRight setFrame:CGRectMake(_obstacleRight.frame.origin.x-delta, _obstacleRight.frame.origin.y, _obstacleRight.frame.size.width, _obstacleRight.frame.size.height)];
        }
        else if (!flipped){
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void) {
                                 _obstacleRight.transform = CGAffineTransformMakeScale(1, 1);
                             }
                             completion:^(BOOL finished){
                                 flipped = true;
                             }];
        }
        else if (_obstacleRight.frame.origin.x<x2) {
            [_obstacleRight setFrame:CGRectMake(_obstacleRight.frame.origin.x+delta, _obstacleRight.frame.origin.y, _obstacleRight.frame.size.width, _obstacleRight.frame.size.height)];
        }
        else {
            _obstacleRight.transform = CGAffineTransformMakeScale(-1, 1);
            flipped = false;
            _obstacleRight.hidden= YES;
            [moveTimer invalidate];
        }
    }
    else {
        //cat from left side of screen
        //x1 = 370
        //x2 = 420
        int x1 = charWidth-.90*charWidth;
        int x2 = charWidth - 1.16*charWidth;

        if (_obstacleLeft.frame.origin.x<x1 && !flipped){
            [_obstacleLeft setFrame:CGRectMake(_obstacleLeft.frame.origin.x+delta, _obstacleLeft.frame.origin.y, _obstacleLeft.frame.size.width, _obstacleLeft.frame.size.height)];
        }
        else if (!flipped){
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^(void) {
                                 _obstacleLeft.transform = CGAffineTransformMakeScale(-1, 1);
                             }
                             completion:^(BOOL finished){
                                 flipped = true;
                             }];
        }
        else if (_obstacleLeft.frame.origin.x>x2) {
            [_obstacleLeft setFrame:CGRectMake(_obstacleLeft.frame.origin.x-delta, _obstacleLeft.frame.origin.y, _obstacleLeft.frame.size.width, _obstacleLeft.frame.size.height)];
        }
        else {
            _obstacleLeft.transform = CGAffineTransformMakeScale(1, 1);
            flipped = false;
            _obstacleLeft.hidden= YES;
            [moveTimer invalidate];
        }

    }
    }

-(void)onTimer:(NSTimer*)theTimer{

    if (arc4random_uniform(10)>4){
        //randomly left or right
        if (arc4random_uniform(10)>5){
            _powerUpRight.hidden = NO;
            _powerUpLeft.hidden = YES;
        }
        else {
            _powerUpRight.hidden = YES;
            _powerUpLeft.hidden = NO;
        }
    }
    else {
        _powerUpLeft.hidden = YES;
        _powerUpRight.hidden = YES;
    }
}
- (IBAction)rightPowerHit:(id)sender {
    bonus+= 15;
    _powerUpRight.hidden = YES;
}
- (IBAction)leftPowerHit:(id)sender {
    bonus+= 15;
    _powerUpLeft.hidden = YES;
}

-(IBAction)startButton:(id)sender{
    //make sure correct view settings
    _fallLeft.hidden = YES;
    _fallRight.hidden = YES;
    _musicButton.hidden = YES;
    _mainCharacter.hidden = NO;
    _scorelevelholder.hidden=NO;
    _score.hidden=NO;
    _level.hidden=NO;
    if (!musicPaused){
        [self playMusic];
    }
    
    //timer for power ups
    timer = [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
    //timer for obstacles
    obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(onObstacleTimer:) userInfo:nil repeats:YES];
    
    //get mainchar coordinates
    charWidth = _mainCharacter.frame.origin.x;
    charHeight = _mainCharacter.frame.origin.y;
    moveIncrement = (charWidth*.001);
    moveRightLimit = (charWidth+0.75*charWidth);
    moveLeftLimit= (charWidth-0.75*charWidth);
    
    //feel like character is falling
    gravity = .5*moveIncrement;
    
    //Set back to original values
    [_mainCharacter setFrame:CGRectMake(charWidth, charHeight, _mainCharacter.frame.size.width, _mainCharacter.frame.size.height)];
    _gameOverView.alpha = 0;
    UIImage *start = [UIImage imageNamed:@"start"];
    [_startButton setImage:start forState:UIControlStateNormal];
    bonus = 0;
    
    //start the character animation
    _mainCharacter.animationImages = charTiltImages;
    _mainCharacter.animationDuration = 0.75;
    [_mainCharacter startAnimating];
    
//    [_mainCharacter.layer setBorderColor: [[UIColor blackColor] CGColor]];
//    [_mainCharacter.layer setBorderWidth: 2.0];

    
    //start the background animation
    _backgroundImages.animationImages = bgImages;
    _backgroundImages.animationDuration = 0.75;
    [_backgroundImages startAnimating];
    
    //start obstacle animation
    _obstacleRight.animationImages = catImages;
    _obstacleRight.animationDuration = 0.75;
    [_obstacleRight startAnimating];
    _obstacleLeft.animationImages = catImages;
    _obstacleLeft.animationDuration = 0.75;
    [_obstacleLeft startAnimating];
    
    //Create motion controller
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval=.2;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [self processMotion:motion];
    }];

    //Keep track of time
    startTime = CACurrentMediaTime();
    
    //disable buttons
    _startButton.hidden = YES;
    _helpButton.hidden = YES;
    _backToSelection.hidden = YES;
    
    //ust for testing
    _powerUpRight.hidden=YES;
    _powerUpLeft.hidden=YES;
    
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if(orientation == UIDeviceOrientationLandscapeLeft)
    {
        landScape = 1;
    }
    else if(orientation == UIDeviceOrientationLandscapeRight)
    {
        landScape = -1;
    }
}

-(void)processMotion:(CMDeviceMotion*)motion {
    oriented = 10*motion.attitude.pitch;
    currentPosition = _mainCharacter.frame.origin.x;
    
    //Update Level based on time
    elapsedTime = CACurrentMediaTime() - startTime;
    difficulty = ((elapsedTime/10)+1);
    
    if (currentPosition>charWidth){
        //on right side, pos gravity
        //added higher levels now makes gravity harder
        gravity_value = fabs(gravity)*(difficulty+2);
    }
    else {
        gravity_value = -gravity*(difficulty+2);
    }
    
    //Change position
    float delta = 2*moveIncrement;
    //changed so only higher tilt values to register
    delta = fabs(oriented)*delta-.4;
    
    //update score view
    //should include bonus points
    NSString *score =[NSString stringWithFormat:@" Score: %d", (int)(elapsedTime+bonus)];
    NSMutableString *level = [NSMutableString stringWithFormat:@" Level: %d", difficulty];
    _score.text = score;
    _level.text = level;
    
    oriented = oriented*landScape;
    if (oriented >= 0){
        
        //check if gameover
        if (((currentPosition+delta)>moveRightLimit) || [self ifCollided]){
            self.motionManager = nil;
            [_mainCharacter stopAnimating];
            
            _fallRight.hidden = NO;
            _mainCharacter.hidden= YES;
            _powerUpLeft.hidden = YES;
            _powerUpRight.hidden = YES;

            [self gameOver];
        }
        //still playing, move character
        else{
            [_mainCharacter setFrame:CGRectMake(currentPosition+delta+gravity_value, charHeight, _mainCharacter.frame.size.width, _mainCharacter.frame.size.height)];
        }
    }
    else {
        //check if gameover
        if (((currentPosition-delta)<moveLeftLimit) || [self ifCollided]){
            self.motionManager = nil;
            [_mainCharacter stopAnimating];
            
            _fallLeft.hidden = NO;
            _mainCharacter.hidden= YES;
            _powerUpLeft.hidden = YES;
            _powerUpRight.hidden = YES;

            [self gameOver];
        }
        //still playing, move character
        else {
            [_mainCharacter setFrame:CGRectMake(currentPosition-delta+gravity_value, charHeight, _mainCharacter.frame.size.width, _mainCharacter.frame.size.height)];
        }
    }
}

-(void) gameOver{
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    _gameOverView.alpha = 1.0;
    [_backgroundImages stopAnimating];
    [UIView commitAnimations];
    
    //make the laughing dog pop up
    _dog.hidden = NO;
    [_dog setFrame: CGRectMake([[self view] frame].origin.x, [[self view] frame].origin.y + 480.0, [[self view] frame].size.width, [[self view] frame].size.height)];
    [UIView animateWithDuration: 1.0f animations: ^{
        [_dog setCenter: [[self view] center]];
    } ];
    _dog.animationImages = dogImages;
    _dog.animationDuration = 0.25;
    [_dog startAnimating];

    [timer invalidate];
    timer = nil;
    [obstacleTimer invalidate];
    obstacleTimer = nil;
    [self pauseMusic];
    [_gameOverPlayer play];
    
    //hide obstacles
    _obstacleLeft.hidden = YES;
    _obstacleRight.hidden = YES;
    
    //put in correct place
    [_mainCharacter setFrame:CGRectMake(moveLeftLimit, charHeight, _mainCharacter.frame.size.width, _mainCharacter.frame.size.height)];
    
    UIImage *playAgain = [UIImage imageNamed:@"play_again"];
    [_startButton setImage:playAgain forState:UIControlStateNormal];
    
    double delayInSeconds = 2.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:@"MainToScores" sender:self];
    });
}

-(IBAction)toggleMusic:(id)sender{
    if (_audioPlayer.playing){
        [self pauseMusic];
        musicPaused = true;
    }
    else{
        [self playMusic];
        musicPaused = false;
    }
}

-(void)pauseMusic{
    [_audioPlayer pause];
    UIImage *mute = [UIImage imageNamed:@"mute.png"];
    [_musicButton setImage:mute forState:UIControlStateNormal];
}

-(void)playMusic{
    [_audioPlayer play];
    UIImage *unMute = [UIImage imageNamed:@"unmute.png"];
    [_musicButton setImage:unMute forState:UIControlStateNormal];
}

-(BOOL)ifCollided{
    //testing lower threshold for hit
    CGRect bounds = CGRectMake(1.2*_mainCharacter.frame.origin.x, _mainCharacter.frame.origin.y,.6*_mainCharacter.frame.size.width, _mainCharacter.frame.size.height);
    //should only bump in when obstacles are visible
    return ((CGRectIntersectsRect(bounds, _obstacleRight.frame) && !_obstacleRight.hidden)|| (CGRectIntersectsRect(bounds, _obstacleLeft.frame) && !_obstacleLeft.hidden));
}

- (void) touchesBegan:(NSSet *)touches
            withEvent:(UIEvent *)event {
    NSUInteger touchCount = [touches count];
    NSUInteger tapCount = [[touches anyObject] tapCount];
    
    //easter egg, change the music
    if ((touchCount>2) || (tapCount>2)){
        if (!ragTime){
            [self pauseMusic];
            _audioPlayer = nil;
            NSString *ragPath = [NSString stringWithFormat:@"%@/pr_mapleleafrag.mp3", [[NSBundle mainBundle] resourcePath]];
            NSURL *ragSoundUrl = [NSURL fileURLWithPath:ragPath];
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ragSoundUrl error:nil];
            _audioPlayer.numberOfLoops = -1;
            [self playMusic];
            ragTime = true;
        }
        else {
            [self pauseMusic];
            _audioPlayer = nil;
            NSString *path = [NSString stringWithFormat:@"%@/uVuLoop.mp3", [[NSBundle mainBundle] resourcePath]];
            NSURL *soundUrl = [NSURL fileURLWithPath:path];
            _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            _audioPlayer.numberOfLoops = -1;
            [self playMusic];
            ragTime = false;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"MainToScores"]){
        scoresViewController *scoreBoard = (scoresViewController *)segue.destinationViewController;
        scoreBoard.userScore = elapsedTime;
        scoreBoard.city = self.city;
        scoreBoard.isMale = self.isMale;
    }
    else if ([segue.identifier isEqualToString:@"MainToHelp"]){
        helpViewController *help = (helpViewController *)segue.destinationViewController;
        help.city = self.city;
        help.isMale = self.isMale;
    }
}

@end
