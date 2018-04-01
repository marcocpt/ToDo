//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by wgd on 2018/3/30.
//  Copyright © 2018年 marcow. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class InputViewControllerTests: XCTestCase {
  var sut: InputViewController!
  var placemark: MockPlacemark!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let storyboard = UIStoryboard(name: "Main",
                                  bundle: nil)
    sut = storyboard.instantiateViewController(
      withIdentifier: "InputViewController") as! InputViewController
    _ = sut.view
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_Save_UsesGeocoderToGetCoordinateFromAddress() {
    let timestamp = 1456095600.0
    let date = Date(timeIntervalSince1970: timestamp)
    
    sut.titleTextField.text = "Foo"
    sut.dateTextField.text = Date.dateFormatter.string(from: date)
    sut.locationTextField.text = "Bar"
    sut.addressTextField.text = "Infinite Loop 1, Cupertino"
    sut.descriptionTextField.text = "Baz"
    
    let mockGeocoder = MockGeocoder()
    sut.geocoder = mockGeocoder
    sut.itemManager = ItemManager()
    sut.save()
    placemark = MockPlacemark()
    let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                -122.0300674)
    placemark.mockCoordinate = coordinate
    mockGeocoder.completionHandler?([placemark], nil)
    let item = sut.itemManager?.item(at: 0)
    let testItem = ToDoItem(title: "Foo",
                            itemDescription: "Baz",
                            timestamp: timestamp,
                            location: Location(name: "Bar",
                                               coordinate: coordinate))
    XCTAssertEqual(item, testItem)
  }
  
  func test_SaveButtonHasSaveAction() {
    let saveButton: UIButton = sut.saveButton
    guard let actions = saveButton.actions(
      forTarget: sut,
      forControlEvent: .touchUpInside) else {
        XCTFail(); return
    }
    XCTAssertTrue(actions.contains("save"))
  }
  
  func test_Geocoder_FetchesCoordinates() {
    let geocoderAnswered = expectation(description: "Geocoder")
    CLGeocoder().geocodeAddressString("WuHan") {
      (placemarks, error) -> Void in
      let coordinate = placemarks?.first?.location?.coordinate
      guard let latitude = coordinate?.latitude else {
        XCTFail()
        return
      }
      guard let longitude = coordinate?.longitude else {
        XCTFail()
        return
      }
      XCTAssertEqual(latitude, 30.5843, accuracy: 0.0001)
      XCTAssertEqual(longitude, 114.2986, accuracy: 0.0001)
      geocoderAnswered.fulfill()
    }
    waitForExpectations(timeout: 3, handler: nil)
  }
  
}

// MARK: - test has item
extension InputViewControllerTests {
  func test_HasTitleTextField() {
    XCTAssertNotNil(sut.titleTextField)
  }
  
  func test_HasDateTextField() {
    XCTAssertNotNil(sut.dateTextField)
  }
  
  func test_HasLocationTextField() {
    XCTAssertNotNil(sut.locationTextField)
  }
  
  func test_HasAddressTextField() {
    XCTAssertNotNil(sut.addressTextField)
  }
  
  func test_HasDescriptionTextField() {
    XCTAssertNotNil(sut.descriptionTextField)
  }
  
  func test_HasSaveButton() {
    XCTAssertNotNil(sut.saveButton)
  }
  
  func test_HasCancelButton() {
    XCTAssertNotNil(sut.cancelButton)
  }
}

// MARK: - Mock
extension InputViewControllerTests {
  
  class MockGeocoder: CLGeocoder {
    var completionHandler: CLGeocodeCompletionHandler?
    
    override func geocodeAddressString(
      _ addressString: String,
      completionHandler: @escaping CLGeocodeCompletionHandler) {
      self.completionHandler = completionHandler
    }
  }
  
  class MockPlacemark : CLPlacemark {
    var mockCoordinate: CLLocationCoordinate2D?
    
    override var location: CLLocation? {
      guard let coordinate = mockCoordinate else
      { return CLLocation() }
      return CLLocation(latitude: coordinate.latitude,
                        longitude: coordinate.longitude)
    }
  }
}

