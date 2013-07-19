//
//  FRTNViewController.m
//  Fortune
//
//  Created by Ajeng on 7/19/13.
//  Copyright (c) 2013 Lemon.Studio. All rights reserved.
//

#import "FRTNViewController.h"
#import "FRTNClient.h"
#import "FRTNDrawImage.h"
#import <AFNetworking.h>
#import <ConciseKit.h>
#import <Social/Social.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountCredential.h>

@interface FRTNViewController () {
    NSArray *jsonResponse;
    NSString *fortuneText;
    NSString *author;
    NSDictionary *list;
}
@end

@implementation FRTNViewController
@synthesize facebookAccount;
@synthesize twitterAccount;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountChanged) name:ACAccountStoreDidChangeNotification object:nil];
    
//    [self.view setBackgroundColor: [self colorFromHexString:@"#c0392b"]];
//    self.view.backgroundColor = [self colorFromHexString:@"#c0392b"];
    
}

/* Twitter permission button */
#if 1
- (IBAction)twitterPermissionAction:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweet setInitialText:fortuneText];
        [self presentViewController:tweet animated:YES completion:nil];
    }
    
#if 0
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0) {
             
                 twitterAccount = [arrayOfAccounts lastObject];
                 
                 NSDictionary *message = @{@"status": @"Test Twitter post from iOS 6"};
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                 
                 SLRequest *postRequest = [SLRequest 
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodPOST
                                           URL:requestURL parameters:message];
             }
         }
     }];
    
#endif
}



#endif

/* Facebook permission button */
- (IBAction)facebookPermissionAction:(id)sender {
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController*fvc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fvc setInitialText:fortuneText];
        [fvc addImage:[UIImage imageNamed:@"lhasa"]];
        [self presentViewController:fvc animated:YES completion:nil];
    }
#if 0
    self.accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"292555344224549";
    
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"email"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {
         if (granted) {
             NSArray *accounts = [self.accountStore accountsWithAccountType:FBaccountType];
             //it will always be the last object with single sign on
             self.facebookAccount = [accounts lastObject];
             NSLog(@"facebook account =%@",self.facebookAccount);
             [self get];
         } else {
             //Fail gracefully...
             NSLog(@"error getting permission %@",e);
             
         }
     }];
    
#endif
    
#if 0
    NSDictionary * options = @{
                               ACFacebookAppIdKey: @"292555344224549",
                               ACFacebookPermissionsKey : @[@"publish_stream"],
                               ACFacebookAudienceKey : ACFacebookAudienceFriends
    };
    
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType options:options completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            NSArray *accounts = [self.accountStore accountsWithAccountType:facebookAccountType];
            
            if([accounts count]>0)
                self.facebookAccount = [accounts lastObject];
        }
        else
        {
            // Fail gracefully...
            NSLog(@"%@",error.description); /*
            if([error code]== ACErrorAccountNotFound)
                [self throwAlertWithTitle:@"Error" message:@"Account not found. Please setup your account in settings app."];
            else
                [self throwAlertWithTitle:@"Error" message:@"Account access denied."];
            */
            
        }
    }];
#endif
}


- (void)updateLabelsFromTouches:(NSSet *)touches
{
    FRTNClient * client = [FRTNClient sharedClient];
    NSString * path = fortuneBaseURLString;
    NSURLRequest * request = [client requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        
        jsonResponse = JSON;
        
        NSString *temp = [jsonResponse valueForKey:@"quote"];
        fortuneText = [self flattenHTML:temp];
        author = [jsonResponse valueForKey:@"cite"];
        NSLog(@"Fortune Text: %@", fortuneText);
        
        self.twitterButtonPressed.enabled = TRUE;
        self.facebookButtonPressed.enabled = TRUE;
        
        //self.view.backgroundColor = [self colorFromHexString:@"#c0392b"];
        
        self.messageLabel.text = fortuneText;

        
//        UIImage *image = [UIImage alloc];
//        image = [FRTNDrawImage imageFromText:fortuneText];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"ERROR");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"Network error" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [alert show];

    }];
    
    [operation start];

}

#pragma mark - Touch Event Methods

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.messageLabel.text = @"Touches Began";
    [self updateLabelsFromTouches:touches];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.messageLabel.text = @"Touches Cancelled";
    [self updateLabelsFromTouches:touches];
}
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
    self.messageLabel.text = @"Wait for a while ... plz";
    [self updateLabelsFromTouches:touches];
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.messageLabel.text = @"Drag Detected";
    [self updateLabelsFromTouches:touches];
}
*/

-(void)get
{
    
    NSURL *requestURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:requestURL
                                               parameters:nil];
    request.account = self.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *data,
                                         NSHTTPURLResponse *response,
                                         NSError *error) {
        
        if(!error)
        {
            list =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            NSLog(@"Dictionary contains: %@", list );
            if([list objectForKey:@"error"]!=nil)
            {
                [self attemptRenewCredentials];
            }
            /*
            dispatch_async(dispatch_get_main_queue(),^{
                nameLabel.text = [list objectForKey:@"username"];
            });
             */
        }
        else{
            //handle error gracefully
            NSLog(@"error from get%@",error);
            //attempt to revalidate credentials
        }
        
    }];
    
    self.accountStore = [[ACAccountStore alloc]init];
    ACAccountType *FBaccountType= [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *key = @"292555344224549";
    NSDictionary *dictFB = [NSDictionary dictionaryWithObjectsAndKeys:key,ACFacebookAppIdKey,@[@"friends_videos"],ACFacebookPermissionsKey, nil];
    
    
    [self.accountStore requestAccessToAccountsWithType:FBaccountType options:dictFB completion:
     ^(BOOL granted, NSError *e) {}];
    
}

-(void)accountChanged:(NSNotification *)notif//no user info associated with this notif
{
    [self attemptRenewCredentials];
}

-(void)attemptRenewCredentials{
    [self.accountStore renewCredentialsForAccount:(ACAccount *)self.facebookAccount completion:^(ACAccountCredentialRenewResult renewResult, NSError *error){
        if(!error)
        {
            switch (renewResult) {
                case ACAccountCredentialRenewResultRenewed:
                    NSLog(@"Good to go");
                    [self get];
                    break;
                case ACAccountCredentialRenewResultRejected:
                    NSLog(@"User declined permission");
                    break;
                case ACAccountCredentialRenewResultFailed:
                    NSLog(@"non-user-initiated cancel, you may attempt to retry");
                    break;
                default:
                    break;
            }
            
        }
        else{
            //handle error gracefully
            NSLog(@"error from renew credentials%@",error);
        }
    }];
    
    
}

-(UIColor*)colorFromHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

@end
