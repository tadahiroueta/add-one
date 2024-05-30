//
//  Game.swift
//  add-one
//
//  Created by Ueta, Lucas T on 12/12/23.
//

import Foundation

class Game {
    var score: Int
    var prompt: Int
    var expectation: Int { calculateExpectation(prompt) }
    
    init() {
        score = 0
        prompt = 0
        updatePrompt()
    }
    
    func updatePrompt() { prompt = Int.random(in: 0..<10000) }

    func calculateExpectation(_ prompt: Int) -> Int {
        var sum = 0
        for i in 1...4 {
            sum += (prompt % Int(pow(10.0, Double(i))) / Int(pow(10.0, Double(i - 1))) + 1) % 10 * Int(pow(10.0, Double(i - 1)))
        }
        return sum
    }
    
    func checkAnswer(_ answer: Int) {
        score += answer == expectation ? 1 : -1
        updatePrompt()
    }
}
