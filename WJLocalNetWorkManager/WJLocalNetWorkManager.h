//
//  WJLocalNetWorkManager.h
//  WJLocalNetWorkManager
//
//  Created by coderjun on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WJLocalNetWorkManager : NSObject
+ (void) requestLocalNetworkAuthorization:(void(^)(BOOL isAuth)) complete;
@end

NS_ASSUME_NONNULL_END
