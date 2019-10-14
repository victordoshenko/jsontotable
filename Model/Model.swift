//
//  Model.swift
//  jsontotable
//
//  Created by Victor Doshchenko on 12/10/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import Foundation

struct Session: Codable {
    let session: String
}
struct Sessions: Codable {
    let status: Int
    let data: Session
}
struct Data: Codable {
    let id: String
    let body: String
    let da: String
    let dm: String
}
struct Datas: Codable {
    let status: Int
    let data: [[Data]]
}
