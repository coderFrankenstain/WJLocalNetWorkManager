//
//  WJLocalNetWorkManager.m
//  WJLocalNetWorkManager
//
//  Created by coderjun on 2022/1/10.
//

#import "WJLocalNetWorkManager.h"
#import <Network/Network.h>
#define BonjourName  @"your bonjourName"
static  void(^result)(BOOL isAuth);

@implementation WJLocalNetWorkManager
#pragma mark 判断本地网络服务是否授权
+ (void) requestLocalNetworkAuthorization:(void(^)(BOOL isAuth)) complete {
    result = complete;
    if(@available(iOS 14, *)) {
        //IOS14需要进行本地网络授权
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            const char* serviceName = BonjourName.UTF8String;
            DNSServiceRef serviceRef = nil;
            DNSServiceBrowse( &serviceRef, 0, 0, serviceName, nil, browseReply, nil);
            DNSServiceProcessResult(serviceRef);
            DNSServiceRefDeallocate(serviceRef);
            
        });
    }
    else {
       //IOS14以下默认返回yes,因为IOS14以下设备默认开启本地网络权限
        complete(YES);
    }
}

///函数回调授权结果
static void browseReply( DNSServiceRef sdRef, DNSServiceFlags flags, uint32_t interfaceIndex, DNSServiceErrorType errorCode, const char *serviceName, const char *regtype, const char *replyDomain, void *context )
{
    //主线程返回获取结果
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result) {
            if (errorCode == kDNSServiceErr_PolicyDenied) {
                result(NO);
            }
            else {
                result(YES);
            }
        }
    });

    
}

@end
