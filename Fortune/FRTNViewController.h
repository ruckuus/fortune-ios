//
//  FRTNViewController.h
//  Fortune
//
//  Created by Ajeng on 7/19/13.
//  Copyright (c) 2013 Lemon.Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRTNViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapsLabel;

- (void) updateLabelsFromTouches:(NSSet *) touches;

@end
