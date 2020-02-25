//
//  Models.swift
//  Iniciativer
//
//  Created by Alex Luna on 25/02/2020.
//  Copyright © 2020 Garagem Infinita. All rights reserved.
//

import Foundation

struct Character: Codable, Identifiable, Comparable {
    static func < (lhs: Character, rhs: Character) -> Bool {
        return lhs.initiative > rhs.initiative
    }
    
    var id = UUID()
    var name: String
    var initiative: Int
    var type: String
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
