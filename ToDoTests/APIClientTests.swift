//
//  APIClientTests.swift
//  ToDoTests
//
//  Created by wgd on 2018/3/30.
//  Copyright © 2018年 marcow. All rights reserved.
//

import XCTest
@testable import ToDo

class APIClientTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_Login_UsesExpectedURL() {
    let sut = APIClient()
    let mockURLSession = MockURLSession()
    
    
  }
  
  
}


extension APIClientTests {
  class MockURLSession {
    var url: URL?
    func dataTask(
      with url: URL,
      completionHandler: @escaping
      (Data?, URLResponse?, Error?) -> Void)
      -> URLSessionDataTask {
        self.url = url
        return URLSession.shared.dataTask(with: url)
    }
  }
}
