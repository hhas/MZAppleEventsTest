//
//  ViewController.swift
//

import UIKit
import MZAppleEvents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func playTrack(sender: UIButton) {
        
        // TO DO: why is this throwing errAEDescNotFound (-1701) in iOSMac but not macOS
        
        var message: String = ""
        /*
        let te = try! AddressDescriptor(bundleIdentifier: "com.apple.TextEdit")
        var event = AppleEventDescriptor(code: 0x686f6f6b_506c5073, target: te) // playpause
        event.setParameter(keyDirectObject, to: RootSpecifierDescriptor.app.elements(cDocument).property(cText))
        let (err, reply) = event.send()
        message += "get = \(err), \(reply?.parameters as Any))"
        */
        
        let itunes = try! AddressDescriptor(bundleIdentifier: "com.apple.iTunes")
        var event = AppleEventDescriptor(code: 0x686f6f6b_506c5073, target: itunes) // playpause
        event.setAttribute(keySubjectAttr, to: nullDescriptor)
        let (err, reply) = event.send()
        message += "playpause = \(err), \(reply?.parameters as Any))"
        if (reply?.errorNumber ?? err) != 0 {
            message += "iTunes playpause error: \(reply?.errorNumber ?? err)"
        } else {
            var event = AppleEventDescriptor(code: coreEventGetData, target: itunes) // get
            event.setParameter(keyDirectObject, to: RootSpecifierDescriptor.app.property(0x7054726b).property(0x706e616d)) // name of current track
            let (err, reply) = event.send()
            print("get", err, reply?.parameters as Any)
            if (reply?.errorNumber ?? err) == 0 {
                if let desc = reply?.parameter(keyAEResult), let result = try? unpackAsString(desc) {
                    message += "iTunes now playing: \(result)"
                } else {
                    message += "iTunes get current track bug: no result"
                }
            } else {
                message += "iTunes get current track error: \((reply?.errorNumber ?? err))"
            }
        }
     
        
        let alertController = UIAlertController(title: "Sending Apple events to iTunes",
                                                message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

