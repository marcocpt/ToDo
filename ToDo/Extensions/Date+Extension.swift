//
//  Date+Extension.swift
//  ToDo
//
//  Created by wgd on 2018/3/30.
//  Copyright © 2018年 marcow. All rights reserved.
//

import UIKit

extension Date {
  static var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
    return dateFormatter
  }
}
