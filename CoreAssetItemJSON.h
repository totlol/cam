//
//  CoreAssetItemJSON.h
//  CoreAssetManager
//
//  Created by Bálint Róbert on 12/04/16.
//  Copyright (c) 2016 IncepTech Ltd All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreAssetItemNormal.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreAssetItemJSON : CoreAssetItemNormal

- (NSString *)fileSystemPath;

- (NSURLRequest *)createURLRequest;

- (_Nullable id)postProcessData:(NSData *)assetData;

- (nullable NSData *)serializeRequestJSON;
+ (nullable NSData *)serializeRequestJSONWithInput:(id)input;

@end

NS_ASSUME_NONNULL_END
