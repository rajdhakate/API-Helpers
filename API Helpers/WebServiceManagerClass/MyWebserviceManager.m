//
//  MyWebServiceManagerProtocol.h
//  MyWebServiceManager
//
//  Created by Raj's MAC on 12/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

#import "MyWebserviceManager.h"
#import "AFHTTPSessionManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import "Reachability.h"

#define SALT @"..."
#define LOCALSERVER @"..."
#define HOSTINGSERVER @"..."

@implementation MyWebserviceManager
{
    NSString *mainUrl;
}

+ (NSString*) getSHA1WithCharacters:(NSString*)string {
    NSString *saltAndEmail = [NSString stringWithFormat:@"%@%@", SALT, string];
    NSData *data = [saltAndEmail dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    NSLog(@"String - %@\nSalt - %@\nAuthCode - %@", string, SALT, output);
    return output;
}

- (BOOL) connected {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] != NotReachable) {
        NSLog(@"Device is connected to the internet");
        return TRUE;
    } else {
        NSLog(@"Device is not connected to the internet");
        return FALSE;
    }
}

- (void) callMyWebServiceManager:(NSString *)serviceName headerData:(NSString*)headerData withFieldName:(NSString*)headerFieldName parameterDictionary:(NSDictionary *)parameterDictionary serviceType:(webserviceType)serviceType
{
    if ([serviceName isEqualToString:@"version_update"]) {
        mainUrl = [NSString stringWithFormat:@"%@%@", LOCALSERVER, serviceName];
    } else {
        mainUrl = [NSString stringWithFormat:@"%@%@", LOCALSERVER, serviceName];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (headerData != nil || headerFieldName != nil) {
        [manager.requestSerializer setValue:headerData forHTTPHeaderField:headerFieldName];
    }
    
    NSMutableArray *parameters = [NSMutableArray new];
    for (NSString *key in parameterDictionary) {
        id value = parameterDictionary[key];
        NSString *parameter = [NSString stringWithFormat:@"%@=%@", key, value];
        [parameters addObject:parameter];
    }
    NSString *fullURL = [NSString stringWithFormat:@"%@?%@", mainUrl, [parameters componentsJoinedByString:@"&"]];
    
    if (serviceType==GET) {
        [manager GET:mainUrl parameters:parameterDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
            [self.delegate processOnGoing:serviceName process:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"response for %@..... \n%@", fullURL, responseObject);
            [self.delegate processCompleted:serviceName responseDictionary:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error for %@..... \n%@", fullURL, error);
            [self.delegate processFailed:error];
        }];
    } else {
        [manager POST:mainUrl parameters:parameterDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
            [self.delegate processOnGoing:serviceName process:uploadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.delegate processCompleted:serviceName responseDictionary:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.delegate processFailed: error];
        }];
    }
}

- (void) callMyWebServiceManagerWithOutParameter:(NSString *)serviceName serviceType:(webserviceType)serviceType
{
    if ([serviceName isEqualToString:@"version_update"]) {
        mainUrl = [NSString stringWithFormat:@"%@%@", LOCALSERVER, serviceName];
    } else {
        mainUrl = [NSString stringWithFormat:@"%@%@", LOCALSERVER, serviceName];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    if (serviceType==GET) {
        [manager GET:mainUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            [self.delegate processOnGoing:serviceName process:downloadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"Test is.....%@",responseObject);
            [self.delegate processCompleted:serviceName responseDictionary:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.delegate processFailed: error];
        }];
    } else {
        [manager POST:mainUrl parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            [self.delegate processOnGoing:serviceName process:uploadProgress];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.delegate processCompleted:serviceName responseDictionary:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.delegate processFailed: error];
        }];
    }
}


@end
