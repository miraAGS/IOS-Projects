//
//  AppDelegate.swift
//  bgTasks
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    BGTaskScheduler.shared.register(
      forTaskWithIdentifier: "com.bgTask.fetchPokemon",
      using: nil) { (task) in
        print("Task handler")
        self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
    }
    
    return true
  }
  
  func handleAppRefreshTask(task: BGAppRefreshTask) {
    print("Handling task")
    task.expirationHandler = {
      task.setTaskCompleted(success: false)
      PokeManager.urlSession.invalidateAndCancel()
    }
    
    let randomPoke = (1...151).randomElement() ?? 1
    PokeManager.pokemon(id: randomPoke) { (pokemon) in
      NotificationCenter.default.post(name: .newPokemonFetched,
                                      object: self,
                                      userInfo: ["pokemon": pokemon])
      task.setTaskCompleted(success: true)
    }
    
    scheduleBackgroundPokemonFetch()
  }
  
  func scheduleBackgroundPokemonFetch() {
    let pokemonFetchTask = BGAppRefreshTaskRequest(identifier: "com.bgTask.fetchPokemon")
    pokemonFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
    do {
      try BGTaskScheduler.shared.submit(pokemonFetchTask)
      print("task scheduled")
    } catch {
      print("Unable to submit task: \(error.localizedDescription)")
    }
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

