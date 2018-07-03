//
//  NetworkLayerTests.swift
//  NetworkLayerTests
//
//  Created by Malcolm Kumwenda on 2018/03/05.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import XCTest
@testable import NetworkLayer

class NetworkLayerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testURLEncoding() {
        guard let url = URL(string: "https:www.google.com/") else {
            XCTAssertTrue(false, "Could not instantiate url")
            return
        }
        var urlRequest = URLRequest(url: url)
        let parameters: Parameters = ["UserID": 1,
                          "Name": "Malcolm",
                          "Email": "malcolm@network.com",
                          "isCool": true]
        do {
            try URLParameterEncoder.encode(urlRequest: &urlRequest, with: parameters)
            guard let fullURL = urlRequest.url else {
                XCTAssertTrue(false, "urlRequest url is nil.")
                return
            }
            let expectedURL = "https:www.google.com/?Email=malcolm%2540network.com&isCool=true&Name=Malcolm&UserID=1"
            XCTAssertEqual(fullURL.absoluteString, expectedURL)
        }catch {
            
        }
        
        
    }
}
