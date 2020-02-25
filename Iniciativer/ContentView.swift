//
//  ContentView.swift
//  Iniciativer
//
//  Created by Alex Luna on 09/01/2020.
//  Copyright © 2020 Garagem Infinita. All rights reserved.
//

import SwiftUI

struct Character: Codable, Identifiable, Comparable {
    static func < (lhs: Character, rhs: Character) -> Bool {
        return lhs.initiative > rhs.initiative
    }
    
    var id = UUID()
    var name: String
    var initiative: Int
}

class Party: ObservableObject {
    @Published var combatants = [Character]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(combatants) { UserDefaults.standard.set(encoded, forKey: "Fighters")}
        }
    }
    
    init() {
        if let fighters = UserDefaults.standard.data(forKey: "Fighters") {
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([Character].self, from: fighters) {
                self.combatants = decoded
                return
            }
        }
        self.combatants = []
    }
    
    func resetInit() {
        for combatant in combatants {
            var newCombatant = combatant
            newCombatant.initiative = Int.random(in: 1...20)
            combatants.append(newCombatant)
            if let index = combatants.firstIndex(of: combatant) {
                combatants.remove(at: index)
            }
        }
    }
}

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
