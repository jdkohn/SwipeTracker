//
//  ViewController.swift
//  SwipeTracker
//
//  Created by Jacob Kohn on 9/4/16.
//  Copyright © 2016 Jacob Kohn. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var numSwipeLabel: UILabel!
    @IBOutlet weak var useSwipeButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var marketplace: CLCircularRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2DMake(36.007584, -78.914172)
        marketplace  = CLCircularRegion.init(center: center, radius: 20.0, identifier: "Marketplace")
        marketplace.notifyOnEntry = true
        marketplace.notifyOnExit = false
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        UIApplication.shared.registerForRemoteNotifications()

        //addResetNotification()
        addSwipeNotification()
        addTimeNotification()
        
        numSwipeLabel.text = String(defaults.integer(forKey: "sw"))
        useSwipeButton.addTarget(self, action: #selector(self.useSwipe(sender:)), for: .touchUpInside)
        updateForRemainingSwipes()
    }

    func useSwipe(sender: UIButton) {
        let swipeNum = (defaults.integer(forKey: "sw")) - 1
        defaults.setValue(swipeNum, forKey: "sw")
        numSwipeLabel.text = String(swipeNum)
        if(swipeNum == 0) {
            updateForRemainingSwipes()
            let alert = UIAlertController(title: "Yo", message: "You have no swipes left", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func updateForRemainingSwipes() {
        numSwipeLabel.text = String(defaults.integer(forKey: "sw"))
        if(numSwipeLabel.text == "0") {
            useSwipeButton.isEnabled = false
        } else {
            useSwipeButton.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSwipeNotification() {
        
        let trigger = UNLocationNotificationTrigger(region: marketplace, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Marketplace", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "You're at Marketplace, are you using a swipe?", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let request = UNNotificationRequest.init(identifier: "MKTPLCE", content: content, trigger: trigger)
        
        // Schedule the notification.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            print(error)
        }
    }

    func addResetNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "Hello"
        content.body = "What up?"
        content.sound = UNNotificationSound.default()
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
        }
        print("should have been added")
    }
    
    func addTimeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "TEST"
        var date = DateComponents()
        date.hour = 6
        date.minute = 8
    
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        let request = UNNotificationRequest.init(identifier: "TimeTest", content: content, trigger: trigger)
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
        }
    }
    /*
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            let notification = UILocalNotification()
            notification.alertBody = "Entry!"
            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["id": "id"];
            notification.fireDate = NSDate(timeIntervalSinceNow: 1) as Date
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
 */
}
