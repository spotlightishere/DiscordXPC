//
//  NSString+CString.h
//  DiscordXPC
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CString)

/// Determines whether the UTF-8 length of this string is larger than the given
/// size.
/// @param givenSize The character length to compare against.
- (BOOL)lengthGreaterThan:(NSInteger)givenSize;

/// Copies the UTF-8 contents of this string to the destination.
/// @param destination The pointer to the char array we copy to.
/// @param size The maximum size this string should be.
- (void)copyTo:(char *)destination withSize:(NSInteger)size;

@end

NS_ASSUME_NONNULL_END
