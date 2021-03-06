//
//  ItemListViewControllerTest.swift
//  ToDoTests
//
//  Created by marcow on 26/3/18.
//  Copyright © 2018年 marcow. All rights reserved.
//

import XCTest
@testable import ToDo

class ItemListViewControllerTests: XCTestCase {
  var sut: ItemListViewController!
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(
      withIdentifier: "ItemListViewController")
    sut = viewController as! ItemListViewController
    
    // NOTE: trigger the call of viewDidLoad(). Never call viewDidLoad() directly.
    sut.loadViewIfNeeded()
    
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func test_TableView_AfterViewDidLoad_IsNotNil() {
    XCTAssertNotNil(sut.tableView)
  }
  
  func test_LoadingView_SetsTableViewDataSource() {
    XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
  }
  
  func test_LoadingView_SetsTableViewDelegate() {
    XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
  }
  
  func test_LoadingView_SetsDataSourceAndDelegateToSameObject() {
    XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                   sut.tableView.delegate as? ItemListDataProvider)
  }
  
  func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
    let target = sut.navigationItem.rightBarButtonItem?.target
    XCTAssertEqual(target as? UIViewController, sut)
  }
  
  func test_AddItem_PresentsAddItemViewController() {
    XCTAssertNil(sut.presentedViewController)
    perform_ItemListVC_addButton_action()
    XCTAssertNotNil(sut.presentedViewController)

    guard let inputViewController = sut.presentedViewController as?
      InputViewController else { XCTFail(); return }
    XCTAssertNotNil(inputViewController.titleTextField)
  }
  
  func test_ItemListVC_SharesItemManagerWithInputVC() {
    perform_ItemListVC_addButton_action()
    guard let inputViewController =
      sut.presentedViewController as? InputViewController else
    { XCTFail(); return }
    guard let inputItemManager = inputViewController.itemManager else
    { XCTFail(); return }
    XCTAssertTrue(sut.itemManager === inputItemManager)
  }
  
  func test_ViewDidLoad_SetsItemManagerToDataProvider() {
    XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
  }
  
  func test_ViewWillAppear_ReloadData() {
    let mockTableView = MockTableView()
    sut.tableView = mockTableView
    
    // NOTE: A reminder: to trigger viewWillAppear(_:)
    sut.beginAppearanceTransition(true, animated: true)
    sut.endAppearanceTransition()
//    sut.viewWillAppear(false)
    XCTAssertTrue(mockTableView.isReloadData)
  }
  
  func test_ItemSelectedNotification_PushesDetailVC() {
    let mockNavigationController =
      MockNavigationController(rootViewController: sut)
    UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
    
    sut.loadViewIfNeeded()
    sut.itemManager.add(ToDoItem(title: "foo"))
    sut.itemManager.add(ToDoItem(title: "bar"))

    NotificationCenter.default.post(
      name: NSNotification.Name("ItemSelectedNotification"),
      object: self,
      userInfo: ["index": 1])
    guard let detailViewController =
      mockNavigationController.pushedViewController as? DetailViewController else
    { XCTFail(); return }
    guard let detailItemManager = detailViewController.itemInfo?.0 else
    { XCTFail(); return }
    guard let index = detailViewController.itemInfo?.1 else
    { XCTFail(); return }
//    detailViewController.loadViewIfNeeded()
    _ = detailViewController.view
    XCTAssertNotNil(detailViewController.titleLabel)
    XCTAssertTrue(detailItemManager === sut.itemManager)
    XCTAssertEqual(index, 1)
  }
  
  
}

extension ItemListViewControllerTests {
  func perform_ItemListVC_addButton_action(line: UInt = #line) {
    guard let addButton = sut.navigationItem.rightBarButtonItem else
    { XCTFail(); return }
    guard let action = addButton.action else { XCTFail(); return }
    
    // NOTE: we have just instantiated the View Controller, but it is not shown anywhere
    UIApplication.shared.keyWindow?.rootViewController = sut
    sut.performSelector(onMainThread: action,
                        with: addButton,
                        waitUntilDone: true)
    sut.performSelector(onMainThread: action,
                        with: addButton,
                        waitUntilDone: true)
  }
}

// MOCK --
extension ItemListViewControllerTests {
  class MockTableView: UITableView {
    var isReloadData = false
    
    override func reloadData() {
      super.reloadData()
      isReloadData = true
    }
  }
  
  class MockNavigationController : UINavigationController {
    var pushedViewController: UIViewController?
    override func pushViewController(_ viewController: UIViewController,
                                     animated: Bool) {
      pushedViewController = viewController
      super.pushViewController(viewController, animated: animated)
    }
  }
}
