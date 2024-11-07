import SwiftUI
import HealthKit

struct ContentView: View {
  @EnvironmentObject var mainEO: MainEO
  let healthStore = HKHealthStore()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("Send config from phone")
        Spacer().frame(height: 10)
        if let activityType = mainEO.activityType {
          Text("Activity Type: \(activityType.rawValue)")
          Spacer().frame(height: 10)
        }
        if let locationType = mainEO.locationType {
          Text("Location Type: \(locationType.rawValue)")
          Spacer().frame(height: 10)
        }
        if let swimmingLocationType = mainEO.swimmingLocationType {
          Text("Swimming Location Type: \(swimmingLocationType.rawValue)")
          Spacer().frame(height: 10)
        }
        if let lapLength = mainEO.lapLength {
          Text("Lap Length: \(lapLength)")
        }
        Spacer().frame(height: 20)
        Button(action: startWorkout) {
          Text("Start Workout")
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      }
    }
  }

  func startWorkout() {
    // Ensure HealthKit is available
    guard HKHealthStore.isHealthDataAvailable() else { return }

    // Define the workout configuration
    let workoutConfiguration = HKWorkoutConfiguration()
    workoutConfiguration.activityType = mainEO.activityType ?? .running
    workoutConfiguration.locationType = mainEO.locationType ?? .outdoor

    do {
      let session = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
      session.startActivity(with: Date())
    } catch {
      print("Failed to start workout session: \(error.localizedDescription)")
    }
  }
}