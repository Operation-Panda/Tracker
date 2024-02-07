//
//  QuestionCard.swift
//  Tracker
//
//  Created by Roaa on 2/2/24.
//

import SwiftUI

enum QuizCase {
    case social
    case sleep
}

struct QuestionCard: View {
    @EnvironmentObject var manager: DatabaseManager
    @Environment(\.dismiss) var dismiss
    
    let quizCase: QuizCase
    
    var description: String {
        if quizCase == .social {return "Social"}
        return "Sleep"
    }
    
    @State var hoursAnswer: Int = -1
    @State var feelingAnswer: Int = -1
    @State var productivityAnswer: Int = -1
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 60) {
                Text("\(description.uppercased()) DATA")
                    .font(.largeTitle.bold())
                    .padding(.vertical)
                
                VStack(spacing: 30) {
                        Stepper(value: $hoursAnswer, in: 0...24, step: 1) {
                            Text(hoursAnswer >= 0 ? "\(description) Hours:          \(hoursAnswer) " : "\(description) Hours:")
                        }
                        Divider()
                        Stepper(value: $feelingAnswer, in: 0...10, step: 1) {
                            Text(feelingAnswer >= 0 ? "Feeling:                   \(feelingAnswer) " : "Feeling:")
                        }
                        Divider()
                        Stepper(value: $productivityAnswer, in: 0...10, step: 1) {
                            Text(productivityAnswer >= 0 ? "Productivity:           \(productivityAnswer) " : "Productivity:")
                        }
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(.black)
                    )
                    
                    
            
                Button {
                    if hoursAnswer >= 0, feelingAnswer >= 0, productivityAnswer >= 0 {
                        if quizCase == .sleep {
                            Task {
                                try await manager.postSleepData(SleepHours: hoursAnswer, feeling: feelingAnswer, productivity: productivityAnswer, date: Date())
                            }
                            dismiss()
                        } else {
                            Task {
                                try await manager.postSocialData(SocialHours: hoursAnswer, feeling: feelingAnswer, productivity: productivityAnswer, date: Date())
                            }
                            dismiss()
                        }
                        
                    }
                } label: {
                    Text("Submit")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(.mint))
                }
            }
            .padding()
        }
    }
}

#Preview {
    QuestionCard(quizCase: .sleep)
}
