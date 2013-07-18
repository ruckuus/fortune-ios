//
//  FRTNViewController.m
//  Fortune
//
//  Created by Ajeng on 7/19/13.
//  Copyright (c) 2013 Lemon.Studio. All rights reserved.
//

#import "FRTNViewController.h"
#import "FRTNClient.h"
#import <AFNetworking.h>
#import <ConciseKit.h>

@interface FRTNViewController () {
    NSArray *jsonResponse;
    NSString *fortuneText;
}
@end

@implementation FRTNViewController

- (void)updateLabelsFromTouches:(NSSet *)touches
{
    FRTNClient * client = [FRTNClient sharedClient];
    NSString * path = fortuneBaseURLString;
    NSURLRequest * request = [client requestWithMethod:@"GET" path:path parameters:nil];
    
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"%@", JSON);
        
        jsonResponse = JSON;
        
        fortuneText = [jsonResponse valueForKey:@"text"];
        NSLog(@"Fortune Text: %@", fortuneText);
        
        self.messageLabel.text = fortuneText;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"ERROR");
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
  
    self.messageLabel.text = @"Touches Ended.";
    [self updateLabelsFromTouches:touches];
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.messageLabel.text = @"Drag Detected";
    [self updateLabelsFromTouches:touches];
}
*/

@end
