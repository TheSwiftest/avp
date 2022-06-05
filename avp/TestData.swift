//
//  TestData.swift
//  avp
//
//  Created by Brian Corbin on 6/4/22.
//

import Foundation

let filePath = Bundle.main.path(forResource: "testMatches", ofType: "json")
let jsonData = try! String(contentsOfFile: filePath!).data(using: .utf8)!

let testMatches = try! JSONDecoder().decode(Matches.self, from: jsonData)
