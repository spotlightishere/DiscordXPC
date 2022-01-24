//
//  NSString+CString.m
//  DiscordXPC
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

#import "NSString+CString.h"

@implementation NSString (CString)

/// Determines whether the UTF-8 length of this string is larger than the given
/// size.
/// @param givenSize The character length to compare against.
- (BOOL)lengthGreaterThan:(NSInteger)givenSize {
    NSInteger size = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    return size > givenSize;
}

/// Copies the UTF-8 contents of this string to the destination.
/// @param destination The pointer to the char array we copy to.
/// @param size The maximum size this string should be.
- (void)copyTo:(char *)destination withSize:(NSInteger)size {
    strncpy(destination, [self UTF8String], size);
}

@end
