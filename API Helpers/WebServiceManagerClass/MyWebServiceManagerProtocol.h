//
//  MyWebServiceManagerProtocol.h
//  MyWebServiceManager
//
//  Created by Raj's MAC on 12/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyWebServiceManagerProtocol <NSObject>

@required
- (void) processCompleted:(NSString *)serviceName responseDictionary:(NSDictionary *)responseDictionary;
- (void) processFailed:(NSError *)errorDictionary;

@optional
- (void) processOnGoing:(NSString*)serviceName progress:(double)progress;

@end
