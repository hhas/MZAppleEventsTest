//
//  AppDelegate.swift
//

import UIKit
import MZAppleEvents


struct StderrStream: TextOutputStream {
    public mutating func write(_ string: String) { fputs(string, stderr) }
}
var errStream = StderrStream()


/*

<key>com.apple.security.scripting-targets</key>
<dict>
    <key>com.apple.iTunes</key>
    <array>
        <string>com.apple.iTunes.playback</string>
    </array>
</dict>

*/



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appleEventHandlers[coreEventGetData] = { (event: AppleEventDescriptor) throws -> Descriptor? in
            guard let desc = event.parameter(keyDirectObject) else { throw AppleEventError.missingParameter }
            print("coreEventGetData:", desc, to: &errStream)
            return packAsString("coreEventGetData: \(desc)")
        }
        
        defaultEventHandler = { (event: AppleEventDescriptor) throws -> Descriptor? in
            print("defaultEventHandler:", event, to: &errStream)
            return nil
        }
        
        let source = CFMachPortCreateRunLoopSource(nil, MZAppleEvents.createMachPort(), 1)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }


}

