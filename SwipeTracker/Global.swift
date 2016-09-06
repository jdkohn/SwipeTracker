//
//  Global.swift
//  SwipeTracker
//
//  Created by Jacob Kohn on 9/4/16.
//  Copyright © 2016 Jacob Kohn. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

let OneWeek = 604800
let SeptemberFifth = 1473051600

let defaults : UserDefaults = UserDefaults.standard

let nc = NotificationCenter.default
let quickAccessNotificationKey = "jk.UsedQuickAccess"
