//
//  MyWebServiceManagerProtocol.h
//  MyWebServiceManager
//
//  Created by Raj's MAC on 12/11/17.
//  Copyright © 2017 Raj Dhakate. All rights reserved.
//

#import "MyWebserviceManager.h"
#import <AFNetworking.h>
#import "Reachability.h"

#define LOCALSERVER @"..." // LOCAL URL goes here
#define HOSTINGSERVER @"..." // LIVE URL goes here

@implementation MyWebserviceManager
{
    NSString *mainUrl;
}

- (BOOL) connected {
    if (!self.logType) {
        self.logType = Default;
    }
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach currentReachabilityStatus] != NotReachable) {
        if (self.logType != None) {
            NSLog(@"API-Helper <Reachability> : Device is connected to the internet");
        }
        return TRUE;
    } else {
        if (self.logType != None) {
            NSLog(@"API-Helper <Reachability> : Device is not connected to the internet");
        }
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
        if (self.logType != None) {
            NSLog(@"API-Helper <FullURL> : %@", fullURL);
        }
    }
    
    if (images) {
        for (UIImage *image in images) {
            NSURLSessionTask *task = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *data = UIImageJPEGRepresentation(image, 1.0);
                [formData appendPartWithFileData:data name:fileName fileName:[NSString stringWithFormat:@"%@.png", fileName] mimeType:@"image/png"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate processOnGoing:serviceName progress:uploadProgress.fractionCompleted*100];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : response for %@..... \n%@", url, responseObject);
                }
                [self.delegate processCompleted:serviceName responseDictionary:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : error for %@..... \n%@", url, error.localizedDescription);
                }
                [self.delegate processFailed:error];
            }];
            
            if (error || !task) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : Creation of task failed for %@..... \n%@", url, error.localizedDescription);
                }
            }
        }
    } else {
        if (serviceType == GET) {
            [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate processOnGoing:serviceName progress:downloadProgress.fractionCompleted*100];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : response for %@..... \n%@", url, responseObject);
                }
                [self.delegate processCompleted:serviceName responseDictionary:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : error for %@..... \n%@", url, error.localizedDescription);
                }
                [self.delegate processFailed: error];
            }];
        } else {
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate processOnGoing:serviceName progress:uploadProgress.fractionCompleted*100];
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : response for %@..... \n%@", url, responseObject);
                }
                [self.delegate processCompleted:serviceName responseDictionary:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (self.logType == URLWithResponse) {
                    NSLog(@"API-Helper : error for %@..... \n%@", url, error.localizedDescription);
                }
                [self.delegate processFailed: error];
            }];
        }
    }
}

@end
