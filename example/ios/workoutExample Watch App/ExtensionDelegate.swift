//
//  ExtensionDelegate.swift
//  Runner
//
//  Created by Oleksii Kravchenko on 07/11/2024.
//

import WatchKit
import HealthKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let healthStore = HKHealthStore()

    func applicationDidFinishLaunching() {
        requestAuthorization()
    }

    func requestAuthorization() {
        let healthKitTypes: Set = [
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if !success {
                print("HealthKit authorization failed: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
