//
//  NSStringMD5.h
//

#import <Foundation/Foundation.h>


@interface NSString (MD5)

+ (NSString *)generateUUID;
- (NSString *)MD5Hash;

@end
