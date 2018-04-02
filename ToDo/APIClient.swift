//
//  APIClient.swift
//  ToDo
//
//  Created by wgd on 2018/3/30.
//  Copyright © 2018年 marcow. All rights reserved.
//

import Foundation

class APIClient {
  lazy var session: SessionProtocol = URLSession.shared
  
  func loginUser(withName username: String,
                 password: String,
                 completion: @escaping (Token?, Error?) -> Void) {
    let allowedCharacters = CharacterSet(
      charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
    guard let encodedUsername = username.addingPercentEncoding(
      withAllowedCharacters: allowedCharacters) else { fatalError() }
    guard let encodedPassword = password.addingPercentEncoding(
      withAllowedCharacters: allowedCharacters) else { fatalError() }
    let query = "username=\(encodedUsername)&password=\(encodedPassword)"
    guard let url = URL(string: "https://awesometodos.com/login?\(query)") else {
      fatalError()
    }
    session.dataTask(with: url) { (data, response, error) in
      guard let data = data else { return }
      let dict = try! JSONSerialization.jsonObject(with: data, options: []) as?
        [String:String]
      let token: Token?
      if let tokenString = dict?["token"] {
        token = Token(id: tokenString)
      } else {
        token = nil
      }
      completion(token, nil)
    }.resume()
  }
}

protocol SessionProtocol {
  func dataTask(with url: URL,
    completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask
}

extension URLSession: SessionProtocol {}
