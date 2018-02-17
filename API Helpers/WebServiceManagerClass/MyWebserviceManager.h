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

typedef enum {
    Default,
    None,
    URLOnly,
    URLWithResponse,
}LogType;

@interface MyWebserviceManager : NSObject

@property (weak, nonatomic) LogType logType;

@property (nonatomic,weak) id <MyWebServiceManagerProtocol> delegate;

// Check Connectivity
- (BOOL) connected;

// Call Web Service Method With headerData (nullable), Parameters (nullable), images (nullable)
- (void) callMyWebServiceManager:(NSString *)serviceName headerData:(NSString *)headerData withFieldName:(NSString *)headerFieldName parameterDictionary:(NSDictionary *)parameterDictionary images:(NSArray<__kindof UIImage*> *)images imageFieldName:(NSString *)imageFieldName serviceType:(webserviceType)serviceType;

@end
