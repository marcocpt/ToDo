//
//  ToDoItem.swift
//  ToDo
//
//  Created by marcow on 25/3/18.
//  Copyright © 2018年 marcow. All rights reserved.
//

import Foundation

struct ToDoItem {
  let title: String
  let itemDescription: String?
  let timestamp: Double?
  let location: Location?
  
  var plistDict: [String:Any] {
    return [:]
  }
  
  init(title: String,
       itemDescription: String? = nil,
       timestamp: Double? = nil,
       location: Location? = nil) {
    self.title = title
    self.itemDescription = itemDescription
    self.timestamp = timestamp
    self.location = location
  }
  
  init?(dict: [String:Any]) {
    return nil
  }
  
  
}

extension ToDoItem: Equatable {
  static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
    if lhs.title != rhs.title {
      return false
    }
    
    if lhs.itemDescription != rhs.itemDescription {
      return false
    }
    
    if lhs.timestamp != rhs.timestamp {
      return false
    }
    
    if lhs.location != rhs.location {
      return false
    }
    
    return true
  }
}


