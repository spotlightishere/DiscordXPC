//
//  main.m
//  DiscordXPC
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

#import "DiscordXPC.h"
#import <Foundation/Foundation.h>

@interface ServiceDelegate : NSObject <NSXPCListenerDelegate>
@end

@implementation ServiceDelegate

/// Used to configure our XPC listener and handle inbound requests.
- (BOOL)listener:(NSXPCListener *)listener
    shouldAcceptNewConnection:(NSXPCConnection *)newConnection {

    // Configure the connection.
    // First, set the interface that the exported object implements.
    newConnection.exportedInterface =
        [NSXPCInterface interfaceWithProtocol:@protocol(DiscordXPCProtocol)];

    // Next, set the object that the connection exports. All messages sent on
    // the connection to this service will be sent to the exported object to
    // handle. The connection retains the exported object.
    DiscordXPC *exportedObject = [DiscordXPC new];
    newConnection.exportedObject = exportedObject;
    
    // Resuming the connection allows the system to deliver more incoming
    // messages.
    [newConnection resume];

    // We wish to always accept inbound connections.
    return YES;
}

@end

int main(int argc, const char *argv[]) {
    // Create the delegate for the service.
    ServiceDelegate *delegate = [ServiceDelegate new];

    // Set up the one NSXPCListener for this service. It will handle all
    // incoming connections.
    NSXPCListener *listener = [NSXPCListener serviceListener];
    listener.delegate = delegate;

    // Resuming the serviceListener starts this service. This method does not
    // return.
    [listener resume];
    return 0;
}
