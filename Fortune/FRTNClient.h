//
//  FRTNClient.h
//  
//
//  Created by Ajeng on 7/19/13.
//
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

extern NSString * const fortuneBaseURLString;
extern NSString * const quotesBaseURLString;

@interface FRTNClient : AFHTTPClient

+(FRTNClient *)sharedClient;

@end
