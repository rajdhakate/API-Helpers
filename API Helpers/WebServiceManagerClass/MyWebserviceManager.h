//
//  MyWebServiceManagerProtocol.h
//  MyWebServiceManager
//
//  Created by Raj's MAC on 12/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyWebServiceManagerProtocol.h"

typedef enum{
    GET,
    POST,
} webserviceType;

@interface MyWebserviceManager : NSObject

@property (nonatomic,strong) id <MyWebServiceManagerProtocol> delegate;

// Generate Auth Code
+ (NSString*) getSHA1WithCharacters:(NSString*)string;

// Check Connectivity
- (BOOL) connected;

// Call Web Service Method With Parameters
- (void) callMyWebServiceManager:(NSString *)serviceName headerData:(NSString*)headerData withFieldName:(NSString*)headerFieldName parameterDictionary:(NSDictionary *)parameterDictionary serviceType:(webserviceType)serviceType;

// Call Web Service Method Without Parameters
- (void) callMyWebServiceManagerWithOutParameter:(NSString *)serviceName serviceType:(webserviceType)serviceType;

@end
