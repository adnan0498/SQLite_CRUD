//
//  DBManager.swift
//  SQLite CRUD
//
//  Created by Adnan on 29/01/2024.
//

import Foundation
import SQLite

class SQLiteHelper {
    private var db: Connection!
    private var users: Table!
    private var id: Expression<Int64>!
    private var name: Expression<String>!
    private var email: Expression<String>!
    private var age: Expression<Int64>!
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/my_users.sqlite3")
            createTable()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    private func createTable() {
        users = Table("users")
        id = Expression<Int64>("id")
        name = Expression<String>("name")
        email = Expression<String>("email")
        age = Expression<Int64>("age")
        
        if(!UserDefaults.standard.bool(forKey: Const.IS_DB_CREATED)) {
            do {
                try db!.run(users.create { t in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(email, unique: true)
                    t.column(age)
                })
                
                UserDefaults.standard.set(true, forKey: Const.IS_DB_CREATED)
            } catch {
                print("Error creating table: \(error)")
            }
        }
    }
    
    func addUser(nameValue: String, emailValue: String, ageValue: Int64) {
        do {
            try db.run(users.insert(name <- nameValue, email <- emailValue, age <- ageValue))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAllUsers() -> [UserModel] {
        do {
            return try db!.prepare(users).map { row in
                let id = try row.get(self.id)
                let name = try row.get(self.name)
                let email = try row.get(self.email)
                let age = try row.get(self.age)
                return UserModel(id: id, name: name, email: email, age: age)
            }
        } catch {
            print("Error fetching persons: \(error)")
            return []
        }
    }
    
    func getUser(idValue: Int64) -> UserModel {
        var userModel = UserModel()
        
        do {
            let user: AnySequence<Row> = try db.prepare(users.filter(id == idValue))
            try user.forEach { rowValue in
                userModel.id = try rowValue.get(id)
                userModel.name = try rowValue.get(name)
                userModel.email = try rowValue.get(email)
                userModel.age = try rowValue.get(age)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return userModel
    }
    
    func updateUser(idValue: Int64, nameValue: String, emailValue: String, ageValue: Int64) {
        do {
            let user: Table = users.filter(id == idValue)
            try db.run(user.update(name <- nameValue, email <- emailValue, age <- ageValue))
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteUser(idValue: Int64) {
        do {
            let user = users.filter(id == idValue)
            try db.run(user.delete())
        } catch {
            print("Error deleting user: \(error)")
        }
    }
}
