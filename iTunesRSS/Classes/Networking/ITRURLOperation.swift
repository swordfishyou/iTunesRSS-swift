//
//  ITRURLOperation.swift
//  iTunesRSS
//
//  Created by Tukhtarov Anatoly on 6/27/14.
//  Copyright (c) 2014 Ciklum. All rights reserved.
//

import Foundation

class ITRURLOperation: NSObject, NSURLConnectionDataDelegate {
    let request: NSURLRequest
    let queue = dispatch_queue_create("com.connection.ITRURLOperation", DISPATCH_QUEUE_CONCURRENT)
    var response: NSHTTPURLResponse!
    var responseData: NSMutableData!
    var connection: NSURLConnection!
    var error: NSError?
    var callbackQueue: dispatch_queue_t?
    var completionHandler: ((ITRURLOperation, NSError?) -> ())?
    
    init(request: NSURLRequest) {
        assert(request != nil, "Request can not be nil")
        self.request = request
        super.init()
    }
    
    convenience init(request: NSURLRequest, callbackQueue: dispatch_queue_t!) {
        self.init(request: request)
        self.callbackQueue = callbackQueue
    }
    
    func start() {
        let currentRunLoop = NSRunLoop.currentRunLoop()
        currentRunLoop.addPort(NSMachPort(), forMode: NSDefaultRunLoopMode)
        
        self.connection = NSURLConnection(request: self.request, delegate: self, startImmediately: false)
        self.connection.scheduleInRunLoop(currentRunLoop, forMode: NSDefaultRunLoopMode)
        
        let networkingBlock: dispatch_block_t = {
            autoreleasepool {
                if self.connection {
                    self.connection.start()
                    self.responseData = NSMutableData()
                }
                
                currentRunLoop.run()
            }
        }
        
        dispatch_async(self.queue, networkingBlock);
    }
    
    func cancel() {
        dispatch_async(self.queue, {
            if self.connection {
                self.connection.cancel()
                
                let error: NSError = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: [NSURLErrorFailingURLErrorKey : self.request.URL])
                self.connection(self.connection, didFailWithError: error)
            }
        })
    }
    
    func finish() {
        self.connection.unscheduleFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.connection = nil
        
        dispatch_async(self.callbackQueue != nil ? self.callbackQueue : dispatch_get_main_queue(), {
            if self.completionHandler {
                self.completionHandler!(self, self.error)
            }
        })
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        self.responseData.length = 0
        self.response = response
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.responseData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        self.finish()
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        self.error = error
        self.finish()
    }
}