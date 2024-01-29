//
//  ContentView.swift
//  SQLite CRUD
//
//  Created by Adnan on 29/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var userList: [UserModel] = []
    @State private var isUserSelected = false
    @State private var selectedUserId: Int64 = 0
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                NavigationLink {
                    AddUserView()
                } label: {
                    Text("Add User")
                }
            }
            
            List(self.userList) { model in
                HStack {
                    Text(model.name)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(model.email)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(model.age)")
                        .lineLimit(1)
                    
                    Button {
                        selectedUserId = model.id
                        isUserSelected.toggle()
                    } label: {
                        Text("Edit")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        let dbHelper = SQLiteHelper()
                        dbHelper.deleteUser(idValue: model.id)
                        userList.removeAll()
                        userList = dbHelper.getAllUsers()
                        
                    } label: {
                        Text("Delete")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .onAppear {
            let dbHelper = SQLiteHelper()
            userList = dbHelper.getAllUsers()
        }
        .navigationDestination(isPresented: $isUserSelected) {
            EditUserView(id: $selectedUserId)
        }
    }
}

#Preview {
    ContentView()
}
