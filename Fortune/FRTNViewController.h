//
//  FRTNViewController.h
//  Fortune
//
//  Created by Ajeng on 7/19/13.
//  Copyright (c) 2013 Lemon.Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccount.h>

@interface FRTNViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *twitterButtonPressed;
@property (weak, nonatomic) IBOutlet UIButton *facebookButtonPressed;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;
@property (strong, nonatomic) ACAccount * twitterAccount;

- (IBAction)twitterPermissionAction:(id)sender;
- (IBAction)facebookPermissionAction:(id)sender;

- (void) updateLabelsFromTouches:(NSSet *) touches;

@end
