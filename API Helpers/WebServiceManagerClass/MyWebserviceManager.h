//
//  MyWebServiceManagerProtocol.h
//  MyWebServiceManager
//
//  Created by Raj's MAC on 12/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MyWebServiceManagerProtocol.h"

typedef enum{
    GET,
    POST,
} webserviceType;

@interface MyWebserviceManager : NSObject

@property (nonatomic,strong) id <MyWebServiceManagerProtocol> delegate;

// Generate Auth Code
+ (NSString *) getSHA1WithCharacters:(NSString *)string;

// Check Connectivity
- (BOOL) connected;

// Call Web Service Method With headerData (nullable), Parameters (nullable), images (nullable)
- (void) callMyWebServiceManager:(NSString *)serviceName headerData:(NSString *)headerData withFieldName:(NSString *)headerFieldName parameterDictionary:(NSDictionary *)parameterDictionary images:(NSArray<__kindof UIImage*> *)images imageFieldName:(NSString *)imageFieldName serviceType:(webserviceType)serviceType;

@end
