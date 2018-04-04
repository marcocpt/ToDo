//
//  InputViewController.swift
//  ToDo
//
//  Created by wgd on 2018/3/30.
//  Copyright © 2018年 marcow. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var dateTextField: UITextField!
  @IBOutlet weak var locationTextField: UITextField!
  @IBOutlet weak var addressTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextField!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  lazy var geocoder = CLGeocoder()
  var itemManager: ItemManager?
  
  @IBAction func save() {
    guard let titleString = titleTextField.text,
      titleString.count > 0 else { return }
    
    let date: Date?
    if let dateText = self.dateTextField.text, dateText.count > 0 {
      date = Date.dateFormatter.date(from: dateText)
    } else {
      date = nil
    }
    
    let descriptionString = descriptionTextField.text
    if let locationName = locationTextField.text, locationName.count > 0,
      let address = addressTextField.text, address.count > 0 {
      geocoder.geocodeAddressString(address) {
        [weak self] (placeMarks, error) -> Void in
        guard let strongSelf = self else { return }
        let placeMark = placeMarks?.first
        let item = ToDoItem(
          title: titleString,
          itemDescription: descriptionString,
          timestamp: date?.timeIntervalSince1970,
          location: Location(
            name: locationName,
            coordinate: placeMark?.location?.coordinate
          )
        )
        strongSelf.itemManager?.add(item)
      }
    } else {
      let item = ToDoItem(title: titleString,
                          itemDescription: descriptionString,
                          timestamp: date?.timeIntervalSince1970,
                          location: nil)
      self.itemManager?.add(item)
    }
    
    dismiss(animated: true)
  }
}
