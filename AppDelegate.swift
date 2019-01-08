//
//  AppDelegate.swift
//  Todoey
//
//  Created by fatih maytalman on 3.01.2019.
//  Copyright © 2019 fatih maytalman. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        }catch{
            print("Error realm init, \(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application is in background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Application is in foreground again")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // MARK: - Core Data stack
    
    
    
}

