//
//  ITRURLOperationTests.swift
//  iTunesRSS
//
//  Created by Tukhtarov Anatoly on 7/2/14.
//  Copyright (c) 2014 Ciklum. All rights reserved.
//

import XCTest
import iTunesRSS

class ITRURLOperationTests: XCTestCase {
    let baseURL: NSURL = NSURL(string: "https://itunes.apple.com/us/rss/topfreeapplications/limit=10/xml")
  
    func testURLOperationRequestIsEqualToSetRequest() {
        let request = NSURLRequest(URL: self.baseURL)
        let operation = ITRURLOperation(request: request)
        XCTAssertEqualObjects(operation.request, request, "Operation's request has to be the same as set")
    }
    
    func testURLOperationConnestionIsNilUntilStart() {
        let operation = self.operationWithBaseURLRequest()
        XCTAssertNil(operation.connection, "Operation's connection has to be nil until start of the operation")
    }
    
    func testURLOperationResponseIsNilUntilStart() {
        let operation = self.operationWithBaseURLRequest()
        XCTAssertNil(operation.response, "Operation's connection has to be nil until start of the operation")
    }
    
    func testURLOperationResponseDataIsNilUntilStart() {
        let operation = self.operationWithBaseURLRequest()
        XCTAssertNil(operation.responseData, "Operation's connection has to be nil until start of the operation")
    }
    
    func testURLOperationInvokesCompletionHandlerWithResponseDataOnSuccess() {
        var responseData: NSMutableData?
        var expectation = self.expectationWithDescription("loadDataForSuccessTest")
        let operation = self.operationWithBaseURLRequest()
        
        operation.completionHandler = {(oprtn: ITRURLOperation, error: NSError?) -> () in
            responseData = oprtn.responseData
            expectation.fulfill()
        }
        
        operation.start()
        
        self.waitForExpectationsWithTimeout(2.0, handler: nil)
        XCTAssertNotNil(responseData, "Operation's response data can't be nil")
        
    }
    
    func testURLOperstionInvokesCompletionHandlerWithErrorOnCancel() {
        var cancelError: NSError?
        var expectation = self.expectationWithDescription("loadDataForCanceledOperstion")
        
        let request = NSURLRequest(URL: NSURL(string: "https://itunes.apple.com/us/rss/topfreeapplications/limit=100/xml"))
        let operation = ITRURLOperation(request: request)
        
        operation.completionHandler = {(oprtn: ITRURLOperation, error: NSError?) -> () in
            cancelError = error
            expectation.fulfill()
        }
        
        operation.start()
        operation.cancel()
        
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
        XCTAssert((cancelError?.code)! == NSURLErrorCancelled, "Canceled operation's error code has to be NSURLErrorCancelled")
    }
    
    func operationWithBaseURLRequest() -> ITRURLOperation {
        let request = NSURLRequest(URL: self.baseURL)
        return ITRURLOperation(request: request)
    }
}
