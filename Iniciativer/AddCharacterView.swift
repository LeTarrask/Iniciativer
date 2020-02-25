//
//  AddCharacterView.swift
//  Iniciativer
//
//  Created by Alex Luna on 09/01/2020.
//  Copyright © 2020 Garagem Infinita. All rights reserved.
//

import SwiftUI

struct AddCharacterView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var party: Party
    @State private var name = ""
    @State private var type = "PC"
    @State private var initiative = ""
    @State private var bonus = 0
    static let types = ["PC", "NPC"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Initiative Roll", text: $initiative)
                    .keyboardType(.numberPad)
                
                Stepper(value: $bonus, in: -10...10, label: { Text("Initiative bonus: \(bonus)")})
                
                Button("Roll initiative", action: {
                    self.initiative = String(Int.random(in: 1...20) + self.bonus)
                })
            }
        .navigationBarTitle("Add Character")
        .navigationBarItems(trailing:
            Button("Save") {
                if let finalInitiative = Int(self.initiative) {
                    let fighter = Character(name: self.name, initiative: finalInitiative)
                    self.party.combatants.append(fighter)
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct AddCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        AddCharacterView(party: Party())
    }
}
