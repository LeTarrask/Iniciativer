//
//  ContentView.swift
//  Iniciativer
//
//  Created by Alex Luna on 09/01/2020.
//  Copyright © 2020 Garagem Infinita. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    @ObservedObject var party = Party()
    @State private var showingAddCharacter = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Reset initiative", action: {
                    self.party.resetInit()
                })
                .navigationBarTitle("Tarrask Initiativer", displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.showingAddCharacter = true
                }) {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .foregroundColor(Color.black)
                })
                    .sheet(isPresented: $showingAddCharacter) {
                        AddCharacterView(party: self.party)
                }
                .padding()
                List {
                    ForEach(party.combatants.sorted()) { combatant in
                        HStack {
                            Text(combatant.name)
                                .font(.headline)
                            if combatant.type == "NPC" {
                                Image(systemName: "bolt.slash")
                            }
                            Spacer()
                            Text(String(combatant.initiative))
                        }
                    }
                    .onDelete(perform: removeFighter)
                }
            }
        }
    }
    
    func removeFighter(at offsets: IndexSet) {
        party.combatants.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
