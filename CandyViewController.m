//
//  CandyViewController.m
//  CandySearch
//
//  Created by admin on 26.07.15.
//  Copyright (c) 2015 sergey. All rights reserved.
//

#import "CandyViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>


@interface CandyViewController ()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLoginButton;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;


@end

@implementation CandyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateUserInfo];
    
    self.FBLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
  
    //twitter login
//    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
//        // play with Twitter session
//    }];
//    logInButton.center = self.view.center;
//    [self.view addSubview:logInButton];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    //logout
    // clear labels
    self.nameLabel.text = [NSString stringWithFormat:@"Username"];
    self.emailLabel.text = [NSString stringWithFormat:@"Email"];
    self.ageLabel.text = [NSString stringWithFormat:@"age"];
}

-(void)profileUpdated:(NSNotification *) notification{
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
    
    [self updateUserInfo];
}

-(void) updateUserInfo
{
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location, friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
                 NSDictionary* userInfo = (NSDictionary*)result;
                 
                 // setting UI using user info
                 self.nameLabel.text = [userInfo objectForKey:@"name"];
                 self.emailLabel.text = [userInfo objectForKey:@"email"];
                 self.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)[self numberOfYearsFrom:[userInfo objectForKey:@"birthday"]]];
                 
             }
             else{
                 NSLog(@"Error getting user!");
             }
         }];
    }
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    //    NSLog(@"result is:%@",result);
    //    NSLog(@"error :%@",error);
    
}

- (NSInteger)numberOfYearsBetween:(NSString *)startDate and:(NSString *)endDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *start = [formatter dateFromString:startDate];
    NSDate *end = [formatter dateFromString:endDate];
    
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       
                                       components:NSYearCalendarUnit
                                       
                                       fromDate:start
                                       
                                       toDate:end
                                       
                                       options:0];
    
    return ageComponents.year;
}

-(NSInteger) numberOfYearsFrom:(NSString *)startDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    return [self numberOfYearsBetween:startDate and:[formatter stringFromDate:[NSDate date]]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
