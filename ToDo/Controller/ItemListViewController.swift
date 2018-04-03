//
//  ItemListViewController.swift
//  ToDo
//
//  Created by marcow on 26/3/18.
//  Copyright © 2018年 marcow. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  @IBOutlet var dataProvider: ItemListDataProvider!
  
  let itemManager = ItemManager()

  override func viewDidLoad() {
    tableView.dataSource = dataProvider
    tableView.delegate = dataProvider
    
    dataProvider.itemManager = itemManager
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  @IBAction func addItem(_ sender: UIBarButtonItem) {
    if let nextViewController =
      storyboard?.instantiateViewController(
        withIdentifier: "InputViewController")
        as? InputViewController {
      nextViewController.itemManager = self.itemManager
      present(nextViewController, animated: true, completion: nil)
    }
  }
  
  
}
