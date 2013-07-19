//
//  FRTNClient.m
//  
//
//  Created by Ajeng on 7/19/13.
//
//

#import "FRTNClient.h"
#import <AFJSONRequestOperation.h>

//NSString * const fortuneBaseURLString = @"http://misskepik.com/fortune.php";
NSString * const fortuneBaseURLString = @"http://frtnt.leongkui.me/v1/cookies";
NSString * const quotesBaseURLString = @"http://frtnt.leongkui.me/view/quotes";

@implementation FRTNClient

+(FRTNClient *)sharedClient {
    static FRTNClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:fortuneBaseURLString]];
    });
    return _sharedClient;
}

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];

    [self setDefaultHeader:@"Accept" value:@"application/json"];
    self.parameterEncoding = AFJSONParameterEncoding;
    return self;
}

@end