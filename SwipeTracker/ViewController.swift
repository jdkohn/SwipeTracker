//
//  ViewController.swift
//  SwipeTracker
//
//  Created by Jacob Kohn on 9/4/16.
//  Copyright © 2016 Jacob Kohn. All rights reserved.
//


/* 
 
 Check to see if didUpdateLocations is working in background
 Check to see if didEnterRegion is working in background or foreground
 Make sure that location updates are sent
 
 */

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var numSwipeLabel: UILabel!
    @IBOutlet weak var useSwipeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    var marketplace: CLCircularRegion!
    var atMarketplace = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nc.addObserver(self, selector: #selector(self.updateForRemainingSwipes), name: NSNotification.Name(rawValue: quickAccessNotificationKey), object: nil)
        
        let center = CLLocationCoordinate2DMake(36.007691, -78.913840) //mplace
        //let center = CLLocationCoordinate2DMake(36.008192, -78.915235) //plow
        //let center = CLLocationCoordinate2DMake(36.008150, -78.915048) //girl's water fountain
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        marketplace  = CLCircularRegion.init(center: center, radius: 10.0, identifier: "Marketplace")
        marketplace.notifyOnEntry = true
        marketplace.notifyOnExit = false
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        print("You are: \(locationManager.location?.distance(from: location)) some type of units away from Marketplace")
        UIApplication.shared.registerForRemoteNotifications()
        
        //addResetNotification()
        addSwipeNotification()
        addTimeNotification()
        
        numSwipeLabel.text = String(defaults.integer(forKey: "sw"))
        useSwipeButton.addTarget(self, action: #selector(self.useSwipe(sender:)), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        updateForRemainingSwipes()
        
        locationManager.startMonitoring(for: marketplace)
        locationManager.allowsBackgroundLocationUpdates = true
        if marketplace.contains(center) { print("Marketplace contains center") }
        if marketplace.contains(CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)) { print("Currently in region") } else { print("You are not in the region") }
        
        print(locationManager.monitoredRegions)
    }
    
    func reset() {
        defaults.set(12, forKey: "sw")
        numSwipeLabel.text = "12"
    }

    func useSwipe(sender: UIButton) {
        let swipeNum = (defaults.integer(forKey: "sw")) - 1
        defaults.setValue(swipeNum, forKey: "sw")
        numSwipeLabel.text = String(swipeNum)
        if(swipeNum == 0) {
            sendOutOfSwipesNotification()
        }
        
    }
    
    func updateForRemainingSwipes() {
        numSwipeLabel.text = String(defaults.integer(forKey: "sw"))
        if(numSwipeLabel.text == "0") {
            sendOutOfSwipesNotification()
            useSwipeButton.isEnabled = false
        } else {
            useSwipeButton.isEnabled = true
        }
    }
    
    //sends alert to user that no swipes remaining
    func sendOutOfSwipesNotification() {
        let alert = UIAlertController(title: "Yo", message: "You have no swipes left", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //adds UNLocationNotification for marketplace
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
            if let e = error {
                print("Error adding notification \(e)")
            }
        }
    }

    //doesn't do anything - once figure out how to do timed notifications set for monday mornings
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
            if let e = error {
                print("Error adding notification \(e)")
            }
        }
        print("should have been added")
    }
    
    //trying to work on setting alerts for certain time
    //does not work currently *eye roll emoji*
    func addTimeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "TEST"
        var triggerComponents = DateComponents(hour: 23, minute: 55, second: 20)
        triggerComponents.timeZone = TimeZone(abbreviation: "EST")
        triggerComponents.calendar = NSCalendar.current
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        let request = UNNotificationRequest.init(identifier: "TimeTest", content: content, trigger: trigger)
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let e = error {
                print("Error adding notification \(e)")
            }
        }
    }
    
    //should send alert when user enters marketplace, also prints to console
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        deliverMarketplaceNotification()
        
        print("Just entered \(region)")
    }
    
    // prints output to confirm that location manager does start monitoring for a region
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started monitoring for region \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let center = CLLocationCoordinate2DMake(36.008150, -78.915048)
        let location = CLLocation(latitude: center.latitude, longitude: center.longitude)
        print(locationManager.location?.distance(from: location))
        
        for location in locations {
            if(marketplace.contains(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))) {
                if(!atMarketplace) {
                    deliverMarketplaceNotification()
                    atMarketplace = true
                }
            } else {
                atMarketplace = false
                print("left Marketplace")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //??
    }
    
    func deliverMarketplaceNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "Yo"
        content.body = "You're At Marketplace"
        content.sound = UNNotificationSound.default()

        let action = UNNotificationAction(identifier: "useswipe", title: "Use Swipe", options: UNNotificationActionOptions.foreground)
        let categories = NSMutableSet(object: action)
        //content.attachments = categories
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        // Schedule the notification.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let e = error {
                print("Error adding notification \(e)")
            }
        }
        
        print("Notification Sent")
    }
}
