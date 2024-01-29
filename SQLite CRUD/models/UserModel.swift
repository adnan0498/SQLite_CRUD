//
//  UserModel.swift
//  SQLite CRUD
//
//  Created by Adnan on 29/01/2024.
//

import Foundation

struct UserModel: Identifiable {
    var id: Int64 = 0
    var name: String = ""
    var email: String = ""
    var age: Int64 = 0
}
