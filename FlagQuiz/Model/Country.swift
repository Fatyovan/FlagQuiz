//
//  Country.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 4.1.26.
//

import Foundation

struct Country: Identifiable, Equatable {
    let id = UUID()
    let code: String
    let enName: String
    let mkdName: String
    
    var flagImageName: String {
        return code.lowercased()
    }
    
    init(code: String, enName: String, mkdName: String) {
        self.code = code
        self.enName = enName
        self.mkdName = mkdName
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.code == rhs.code
    }
}
