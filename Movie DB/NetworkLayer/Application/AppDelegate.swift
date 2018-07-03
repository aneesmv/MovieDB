//
//  AppDelegate.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let mainVC: MainViewController =
        mainStoryBoard.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
      let networkManager = NetworkManager()
      mainVC.networkManager = networkManager
      self.window = UIWindow(frame: UIScreen.main.bounds)
      self.window?.rootViewController = mainVC
      self.window?.makeKeyAndVisible()
    return true
  }
}

