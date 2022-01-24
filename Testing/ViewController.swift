//
//  ViewController.swift
//  Testing
//
//  Created by Spotlight Deveaux on 2022-01-23.
//

import Dynamic
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate our XPC connection.
        let connection = Dynamic.NSXPCConnection.initWithServiceName("space.joscomputing.Testing.DiscordXPC").asAnyObject as! NSXPCConnection
        connection.remoteObjectInterface = NSXPCInterface(with: DiscordXPCProtocol.self)
        connection.resume()

        // Make a call to the service.
        let proxy = connection.remoteObjectProxy as! DiscordXPCProtocol
        Task.init {
            let app = await proxy.connectToDiscord(forApp: 402_370_117_901_484_042)
            print(app)

            let result = await proxy.setPresenceWithDetails("Hello, world!", andState: "Hi from iOS!")
            print(result)
        }

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            proxy.callbackHandler()
        }
    }
}
