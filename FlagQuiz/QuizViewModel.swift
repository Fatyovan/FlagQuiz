//
//  QuizViewModel.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 4.1.26.
//

import SwiftUI
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentCountry: Country?
    @Published var answers: [String] = []
    @Published var selectedAnswer: String?
    @Published var score: Int = 0
    @Published var totalQuestions: Int = 0
    
    private var allCountries: [Country] = []
    
    init() {
        loadCountries()
        nextQuestion()
    }
    
    private func loadCountries() {
        let allParsedCountries = CSVParser.parseCountries(fileName: "countryNamesWithTranslate")
        
        allCountries = allParsedCountries.filter { country in
            UIImage(named: country.enName) != nil
        }
        
        print("✅ Loaded \(allCountries.count) countries with valid flags (out of \(allParsedCountries.count) total)")
    }
    
    func nextQuestion() {
        guard !allCountries.isEmpty else {
            print("❌ No countries loaded!")
            return
        }
        
        selectedAnswer = nil
        
        // Get random country
        currentCountry = allCountries.randomElement()
        
        guard let currentCountry = currentCountry else { return }
        
        // Generate 4 unique answers
        var answerSet: Set<String> = [currentCountry.mkdName]
        
        while answerSet.count < 4 {
            if let randomCountry = allCountries.randomElement() {
                answerSet.insert(randomCountry.mkdName)
            }
        }
        
        answers = Array(answerSet).shuffled()
    }
    
    func checkAnswer(_ answer: String) {
        guard let currentCountry = currentCountry else { return }
        
        selectedAnswer = answer
        totalQuestions += 1
        
        if answer == currentCountry.mkdName {
            score += 1
        }
    }
    
    func resetScore() {
        score = 0
        totalQuestions = 0
    }
    
    var isCorrect: Bool {
        guard let selectedAnswer = selectedAnswer,
              let currentCountry = currentCountry else {
            return false
        }
        return selectedAnswer == currentCountry.mkdName
    }
    
    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(score) / Double(totalQuestions)) * 100)
    }
}
