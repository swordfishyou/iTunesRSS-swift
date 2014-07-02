//
//  AppDelegate.swift
//  iTunesRSS
//
//  Created by Tukhtarov Anatoly on 6/27/14.
//  Copyright (c) 2014 Ciklum. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        let request = NSURLRequest(URL: NSURL(string: "https://itunes.apple.com/us/rss/topfreeapplications/limit=10/xml"))
        let operation = ITRURLOperation(request: request)
        operation.start()
        operation.completionHandler = {(oprtn: ITRURLOperation, error: NSError?) -> () in
            println("operation completed")
        }
        
        self.window!.makeKeyAndVisible()
        return true
    }

}

