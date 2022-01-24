//
//  DiscordXPC.m
//  DiscordXPC
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

#import "DiscordXPC.h"
#import "NSString+CString.h"
#import "discord_game_sdk.h"

/// An implementation of the interface to utilise Discord's Game SDK from Mac
/// Catalyst.
@implementation DiscordXPC

/// The struct we manage our connection to Discord with.
struct IDiscordCore *core = nil;

/// The timer used to manage core callbacks.
NSTimer *coreTimer = nil;

// MARK: Exposed Protocol

/// Initiates a connection to Discord, wrapping the Game SDK.
/// This should only be called once throughout your client's life cycle.
/// @param appId The application/client ID to specify to Discord.
/// @param reply A callback on whether our endeavors were successful.
- (void)connectToDiscordForApp:(int64_t)appId withReply:(void (^)(BOOL))reply {
    // Prepare to connect to Discord.
    struct DiscordCreateParams params;
    DiscordCreateParamsSetDefault(&params);
    params.client_id = appId;
    params.flags = DiscordCreateFlags_Default;

    // Register!
    enum EDiscordResult result = DiscordCreate(DISCORD_VERSION, &params, &core);
    core->set_log_hook(core, DiscordLogLevel_Debug, nil, loggingHook);

    reply(result == DiscordResult_Ok);
}

/// Updates the user's Rich Presence.
/// @param details The details to give to Discord.
/// @param state The state to give to Discord.
/// @param reply A callback on whether our endeavors were successful.
- (void)setPresenceWithDetails:(NSString *)details
                      andState:(NSString *)state
                     withReply:(ReplyBlock)reply {
    // Validate sizes. As of writing, details and state must be 128.
    // This should be read as "we may set 127 with a null terminator".
    if ([details lengthGreaterThan:127] || [state lengthGreaterThan:127]) {
        reply(false);
        return;
    }

    // Prepare an activity structure usable for Discord.
    struct DiscordActivity activity;
    memset(&activity, 0, sizeof(activity));

    // Set in our structure.
    [details copyTo:activity.details withSize:127];
    [state copyTo:activity.state withSize:127];

    // Use a manager to update the activity.
    struct IDiscordActivityManager *manager = core->get_activity_manager(core);
    manager->update_activity(manager, &activity, nil, nil);
}

/// A callback used to invoke Discord's throughout our runloop.
- (void)callbackHandler {
    // If we have not been configured yet, do nothing.
    if (core == nil) {
        return;
    }
    
    core->run_callbacks(core);
}

// MARK: Callback Handlers

/// A generic callback returning our success result for the operation.
/// @param callback_data Our reply function from XPC.
/// @param result The error result we're given by Discord in this callback.
void genericCallback(void *callback_data, enum EDiscordResult result) {
    // TODO: XPC result back to calling application
}

/// A callback utilized for logging.
/// @param hook_data The passed user data.
/// @param level The passed level.
/// @param message The passed message.
void loggingHook(void *hook_data, enum EDiscordLogLevel level,
                 const char *message) {
    printf("[Discord GameSDK] %s\n", message);
}

@end
