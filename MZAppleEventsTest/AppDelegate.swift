//
//  AppDelegate.swift
//

import UIKit
import MZAppleEvents


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appleEventHandlers[coreEventGetData] = { (event: AppleEventDescriptor) throws -> Descriptor? in
            guard let desc = event.parameter(keyDirectObject) else { throw AppleEventError.missingParameter }
            print("coreEventGetData:", desc)
            return packAsString("coreEventGetData: \(desc)")
        }
        
        // TO DO:
        //let source = CFMachPortCreateRunLoopSource(nil, AppleEvents.createMachPort(), 1)
        //CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
        
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

