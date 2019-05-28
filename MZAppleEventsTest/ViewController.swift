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
        let message: String
        let itunes = try! AddressDescriptor(bundleIdentifier: "com.apple.iTunes")
        let event = AppleEventDescriptor(code: 0x686f6f6b_506c5073, target: itunes) // playpause
        let (err, reply) = event.send()
        if err != 0 || reply?.errorNumber != 0 {
            message = "iTunes playpause error: \(err != 0 ? err : reply!.errorNumber)"
        } else {
            var event = AppleEventDescriptor(code: coreEventGetData, target: itunes) // playpause
            event.setParameter(keyDirectObject, to: RootSpecifierDescriptor.app.property(0x7054726b))
            let (err, reply) = event.send()
            if err != 0 || reply?.errorNumber != 0 {
                if let desc = reply?.parameter(keyAEResult), let result = try? unpackAsString(desc) {
                    message = "iTunes now playing: \(result)"
                } else {
                    message = "iTunes get current track bug: no result"
                }
            } else {
                message = "iTunes get current track error: \(err != 0 ? err : reply!.errorNumber)"
            }
        }
        let alertController = UIAlertController(title: "Sending Apple events to iTunes",
                                                message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

