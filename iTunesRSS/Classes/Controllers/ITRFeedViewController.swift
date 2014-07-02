//
//  ITRFeedViewController.swift
//  iTunesRSS
//
//  Created by Tukhtarov Anatoly on 6/27/14.
//  Copyright (c) 2014 Ciklum. All rights reserved.
//

import Foundation
import UIKit

class ITRFeedViewController : UIViewController {
    override func viewDidLoad() {
        let request = NSURLRequest(URL: NSURL(string: "https://itunes.apple.com/us/rss/topfreeapplications/limit=10/xml"))
        let operation = ITRURLOperation(request: request)
        operation.start()
        operation.completionHandler = {[weak operation](oprtn: ITRURLOperation, error: NSError?) -> () in
            let responseString = NSString(data: oprtn.responseData, encoding: NSUTF8StringEncoding)
            let url = oprtn.response.URL
            println(url)
        }
    }
}