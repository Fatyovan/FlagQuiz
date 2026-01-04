//
//  QuizView.swift
//  FlagQuiz
//
//  Created by Ivan Jovanovik on 4.1.26.
//

import SwiftUI

struct QuizView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var showNextButton = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.5, green: 0.3, blue: 0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with score
                headerView
                
                ScrollView {
                    VStack(spacing: 30) {
                        Spacer()
                            .frame(height: 20)
                        
                        // Flag image
                        if let country = viewModel.currentCountry {
                            flagImageView(country: country)
                        }
                        
                        // Answer buttons
                        answersView
                        
                        // Next button
                        if showNextButton {
                            nextButtonView
                        }
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Flag Quiz 🇲🇰")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 20) {
                Text("Score: \(viewModel.score)/\(viewModel.totalQuestions)")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                
                if viewModel.totalQuestions > 0 {
                    Text("\(viewModel.scorePercentage)%")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    // MARK: - Flag Image View
    private func flagImageView(country: Country) -> some View {
        VStack(spacing: 15) {
            Image(country.enName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                .padding(.horizontal, 10)
            
            Text("Која е оваа земја?")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Answers View
    private var answersView: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.answers, id: \.self) { answer in
                AnswerButton(
                    text: answer,
                    isSelected: viewModel.selectedAnswer == answer,
                    isCorrect: showNextButton && answer == viewModel.currentCountry?.mkdName,
                    isWrong: showNextButton && viewModel.selectedAnswer == answer && answer != viewModel.currentCountry?.mkdName
                ) {
                    handleAnswerSelection(answer)
                }
            }
        }
    }
    
    // MARK: - Next Button View
    private var nextButtonView: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showNextButton = false
                viewModel.nextQuestion()
            }
        }) {
            HStack {
                Text("Следно Прашање")
                    .font(.headline)
                Image(systemName: "arrow.right.circle.fill")
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    // MARK: - Actions
    private func handleAnswerSelection(_ answer: String) {
        viewModel.checkAnswer(answer)
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showNextButton = true
        }
        
        if viewModel.isCorrect {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } else {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

#Preview {
    QuizView()
}
