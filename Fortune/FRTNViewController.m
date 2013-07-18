//
//  FRTNViewController.m
//  Fortune
//
//  Created by Ajeng on 7/19/13.
//  Copyright (c) 2013 Lemon.Studio. All rights reserved.
//

#import "FRTNViewController.h"


@implementation FRTNViewController

- (void)updateLabelsFromTouches:(NSSet *)touches
{
//    NSUInteger numTaps = [[touches anyObject] tapCount];
    NSString *tapsMessage = @"Taps detected";
                        //[[NSString alloc]
                             //initWithFormat:[@"taps detected"];//, numTaps];
    self.tapsLabel.text = tapsMessage;
//    NSUInteger numTouches = [touches count];
    NSString *touchMsg = @"Touch detected";//[[NSString alloc] initWithFormat:
                         // @"%d touches detected"];//, numTouches];
//    self.touchesLabel.text = touchMsg;
    self.touchLabel.text = @"Touch detected";
}

#pragma mark - Touch Event Methods
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
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.messageLabel.text = @"Touches Ended.";
    [self updateLabelsFromTouches:touches];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.messageLabel.text = @"Drag Detected";
    [self updateLabelsFromTouches:touches];
}


@end
