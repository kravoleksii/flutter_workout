//
//  InterfaceContoller.swift
//  Runner
//
//  Created by Oleksii Kravchenko on 07/11/2024.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {
    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?

    @IBAction func startWorkout() {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            workoutSession?.startActivity(with: Date())
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }
}
