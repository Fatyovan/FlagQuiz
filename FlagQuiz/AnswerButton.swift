//
//  AnswerButton.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 4.1.26.
//

import SwiftUI

struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let action: () -> Void
    
    private var backgroundColor: Color {
        if isCorrect { return .green }
        if isWrong { return .red }
        if isSelected { return .blue.opacity(0.3) }
        return Color(uiColor: .systemBackground)
    }
    
    private var borderColor: Color {
        if isCorrect { return .green }
        if isWrong { return .red }
        if isSelected { return .blue }
        return .gray.opacity(0.3)
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(isCorrect || isWrong ? .white : .primary)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        }
        .disabled(isSelected)
    }
}
