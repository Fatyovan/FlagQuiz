//
//  CSVParser.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 4.1.26.
//


import Foundation

class CSVParser {
    static func parseCountries(fileName: String) -> [Country] {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            print("❌ CSV file not found: \(fileName).csv")
            return []
        }
        
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            let rows = contents.components(separatedBy: "\n")
                .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            
            // Skip header row
            let dataRows = rows.dropFirst()
            
            return dataRows.compactMap { row in
                let columns = row.components(separatedBy: ",")
                guard columns.count >= 3 else { return nil }
                
                let code = columns[0].trimmingCharacters(in: .whitespaces)
                let enName = columns[1].trimmingCharacters(in: .whitespaces)
                let mkdName = columns[2].trimmingCharacters(in: .whitespaces)
                
                return Country(code: code, enName: enName, mkdName: mkdName)
            }
        } catch {
            print("❌ Error reading CSV: \(error)")
            return []
        }
    }
}