//
//  DetailViewController.swift
//  ToDo
//
//  Created by wgd on 2018/3/29.
//  Copyright © 2018年 marcow. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var itemInfo: (ItemManager, Int)?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let itemInfo = itemInfo else { return }
    let item = itemInfo.0.item(at: itemInfo.1)
    titleLabel.text = item.title
    locationLabel.text = item.location?.name
    descriptionLabel.text = item.itemDescription
    if let timestamp = item.timestamp {
      let date = Date(timeIntervalSince1970: timestamp)
      dateLabel.text = Date.dateFormatter.string(from: date)
    }
    if let coordinate = item.location?.coordinate {
      let region = MKCoordinateRegionMakeWithDistance(coordinate,
                                                      100, 100)
      mapView.region = region
    }
  }
  
  func checkItem() {
    if let itemInfo = itemInfo {
      itemInfo.0.checkItem(at: itemInfo.1)
    }
  }
  
  
}
