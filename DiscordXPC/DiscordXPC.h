//
//  DiscordXPC.h
//  DiscordXPC
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

#import "DiscordXPCProtocol.h"
#import <Foundation/Foundation.h>

/// An implementation of the interface to utilise Discord's GameSDK from Mac
/// Catalyst.
@interface DiscordXPC : NSObject <DiscordXPCProtocol>
@end
