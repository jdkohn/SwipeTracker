//
//  TestNotificationVC.swift
//  SwipeTracker
//
//  Created by Jacob Kohn on 9/4/16.
//  Copyright © 2016 Jacob Kohn. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications

class TestNotificationController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //button.addTarget(self, action: #selector(self.sendNotification(sender:)), for: .touchUpInside)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*
    func sendNotification(sender: UIButton) {

        perform(#selector(self.send()), with: nil, afterDelay: TimeInterval(5.0), inModes: <#T##[RunLoopMode]#>)

    }
    
    func send() {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hello_message_body", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
 
 */
}
