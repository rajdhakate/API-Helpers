//
//  MyWebServiceManagerProtocol.h
//  MyWebServiceManager
//
//  Created by Raj's MAC on 12/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

#import "MyWebserviceManager.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonCrypto.h>
#import "Reachability.h"

#define SALT @"..." // SALT goes here
#define LOCALSERVER @"..." // LOCAL URL goes here
#define HOSTINGSERVER @"..." // LIVE URL goes here

@implementation MyWebserviceManager
{
    NSString *mainUrl;
}

+ (NSString *) getSHA1WithCharacters:(NSString *)string {
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

- (void) callMyWebServiceManager:(NSString *)serviceName headerData:(NSString *)headerData withFieldName:(NSString *)headerFieldName parameterDictionary:(NSDictionary *)parameterDictionary images:(NSArray<__kindof UIImage*> *)images imageFieldName:(NSString *)imageFieldName serviceType:(webserviceType)serviceType {
    if ([serviceName isEqualToString:@"version_update"]) {
        mainUrl = [NSString stringWithFormat:@"%@%@", LOCALSERVER, serviceName];
    } else {
        mainUrl = [NSString stringWithFormat:@"%@%@", LOCALSERVER, serviceName];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (headerData != nil || headerFieldName != nil) {
        [manager.requestSerializer setValue:headerData forHTTPHeaderField:headerFieldName];
    }
    
    [self manager:manager serviceType:serviceType url:mainUrl serviceName:serviceName parameters:parameterDictionary images:images imageFieldName:imageFieldName];
}

- (void) manager:(AFHTTPSessionManager *)manager serviceType:(webserviceType)serviceType url:(NSString *)url serviceName:(NSString *)serviceName parameters:(NSDictionary *)parameters images:(NSArray<__kindof UIImage *> *)images imageFieldName:(NSString *)fileName {
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    NSError *error;
    NSString *fullURL;
    
    if (parameters) {
        NSMutableArray *parameterDictionary = [NSMutableArray new];
        for (NSString *key in parameters) {
            id value = parameters[key];
            NSString *parameter = [NSString stringWithFormat:@"%@=%@", key, value];
            [parameterDictionary addObject:parameter];
        }
        fullURL = [NSString stringWithFormat:@"%@?%@", url, [parameterDictionary componentsJoinedByString:@"&"]];
    }
    
    if (images) {
        for (UIImage *image in images) {
            NSURLSessionTask *task = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate processOnGoing:serviceName progress:uploadProgress.fractionCompleted*100];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"response for %@..... \n%@", url, responseObject);
                [self.delegate processCompleted:serviceName responseDictionary:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error for %@..... \n%@", url, error.localizedDescription);
                [self.delegate processFailed:error];
            }];
            
            if (error || !task) {
                NSLog(@"Creation of task failed for %@..... \n%@", url, error.localizedDescription);
            }
        }
    } else {
        if (serviceType == GET) {
            [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate processOnGoing:serviceName progress:downloadProgress.fractionCompleted*100];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"response for %@..... \n%@", url, responseObject);
                [self.delegate processCompleted:serviceName responseDictionary:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error for %@..... \n%@", url, error.localizedDescription);
                [self.delegate processFailed: error];
            }];
        } else {
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate processOnGoing:serviceName progress:uploadProgress.fractionCompleted*100];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"response for %@..... \n%@", url, responseObject);
                [self.delegate processCompleted:serviceName responseDictionary:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error for %@..... \n%@", url, error.localizedDescription);
                [self.delegate processFailed: error];
            }];
        }
    }
}

@end
