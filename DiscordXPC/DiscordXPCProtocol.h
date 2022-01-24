//
//  DiscordXPCProtocol.h
//  DiscordXPC
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

#import <Foundation/Foundation.h>

/// Defines the reply type.
typedef void (^ReplyBlock)(BOOL);

/// A simple interface to utilise Discord's GameSDK from Mac Catalyst.
@protocol DiscordXPCProtocol

/// Initiates a connection to Discord, wrapping the Game SDK.
/// This should only be called once throughout your client's life cycle.
/// @param appId The application/client ID to specify to Discord.
/// @param reply A callback on whether our endeavors were successful.
- (void)connectToDiscordForApp:(int64_t)appId withReply:(ReplyBlock)reply;

/// Updates the user's Rich Presence.
/// @param details The details to give to Discord.
/// @param state The state to give to Discord.
/// @param reply A callback on whether our endeavors were successful.
- (void)setPresenceWithDetails:(NSString *)details
                      andState:(NSString *)state
                     withReply:(ReplyBlock)reply;

/// A callback used to invoke Discord's throughout our runloop.
- (void)callbackHandler;

@end
