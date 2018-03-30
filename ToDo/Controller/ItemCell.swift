//
//  ItemCellTableViewCell.swift
//  ToDo
//
//  Created by wgd on 2018/3/26.
//  Copyright © 2018年 marcow. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  func configCell(with item: ToDoItem, checked: Bool = false) {
    if checked {
      let attributedString = NSAttributedString(
        string: item.title,
        attributes: [NSAttributedStringKey.strikethroughStyle:
          NSUnderlineStyle.styleSingle.rawValue])
      titleLabel.attributedText = attributedString
      locationLabel.text = nil
      dateLabel.text = nil
    } else {
      titleLabel.text = item.title
      locationLabel.text = item.location?.name
      if let timestamp = item.timestamp {
        let date = Date(timeIntervalSince1970: timestamp)
        dateLabel.text = Date.dateFormatter.string(from: date)
      }
    }
  }
  
  
}
