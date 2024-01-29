//
//  EditUserView.swift
//  SQLite CRUD
//
//  Created by Adnan on 29/01/2024.
//

import SwiftUI

struct EditUserView: View {
    @Binding var id: Int64
    @State private var name = ""
    @State private var email = ""
    @State private var age = ""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter name", text: $name)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .disableAutocorrection(true)
                
                TextField("Enter email", text: $email)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                TextField("Enter age", text: $age)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(5)
                    .keyboardType(.numberPad)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal)
            
            Button {
                let dbHelper = SQLiteHelper()
                dbHelper.updateUser(idValue: id, nameValue: name, emailValue: email, ageValue: Int64(age) ?? 0)
                self.mode.wrappedValue.dismiss()
                
            } label: {
                Text("Update User")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
            }
            .padding()
        }
        .onAppear {
            let dbHelper = SQLiteHelper()
            let userModel = dbHelper.getUser(idValue: id)
            name = userModel.name
            email = userModel.email
            age = String(userModel.age)
        }
    }
}

#Preview {
    EditUserView(id: .constant(0))
}
