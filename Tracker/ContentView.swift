//
//  ContentView.swift
//  Tracker
//
//  Created by Roaa on 2/2/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject var manager = DatabaseManager()
    
    var emoSleepState: (max: SleepDataPoints?, min: SleepDataPoints?) { 
        let max = manager.sleepDataPoints.max{$0.feeling < $1.feeling}
        let min = manager.sleepDataPoints.max{$0.feeling > $1.feeling}
        return (max, min == max ? nil : min)
    }
    
    var proSleepState: (max: SleepDataPoints?, min: SleepDataPoints?) {
        let max = manager.sleepDataPoints.max{$0.productivity < $1.productivity}
        let min = manager.sleepDataPoints.max{$0.productivity > $1.productivity}
        return (max, min == max ? nil : min)
    }
    
    var emoSocialState: (max: SocialDataPoints?, min: SocialDataPoints?) {
        let max = manager.socialDataPoints.max{$0.feeling < $1.feeling}
        let min = manager.socialDataPoints.max{$0.feeling > $1.feeling}
        return (max, min == max ? nil : min)
    }
     
    var proSocialState: (max: SocialDataPoints?, min: SocialDataPoints?) {
        let max = manager.socialDataPoints.max{$0.productivity < $1.productivity}
        let min = manager.socialDataPoints.max{$0.productivity > $1.productivity}
        return (max, min == max ? nil : min)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 40) {
                    Text("GENERAL TRENDS")
                        .font(.largeTitle.bold())
                        .padding(.top, 30)
                    
                    Divider()
                        .padding(30)
                    
                    Text("SLEEP")
                        .font(.title.bold())
                     
                    //hours vs feeling
                    Text("SLEEP VS. EMOTIONAL STATE")
                    if manager.sleepDataPoints.count > 0 {
                        Chart {
                            ForEach(manager.sleepDataPoints) { data in
                                BarMark(x: .value("HOURS", data.SleepHours),
                                        y: .value("FEELS", data.feeling))
                                .foregroundStyle (
                                    emoSleepState.max?.feeling == data.feeling ? .blue : (emoSleepState.min?.feeling == data.feeling ? .cyan : .gray)
                                )
                            }
                        }
                    } else {
                        emptyChart
                    }
                    VStack(spacing: 10) {
                        if let maxEmoSleepState = emoSleepState.max {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.blue)
                                    .opacity(0.7)
                                Text("The hightest productive state was \(maxEmoSleepState.productivity) on \(maxEmoSleepState.createdAt.toString()) after \(maxEmoSleepState.SleepHours) \(maxEmoSleepState.SleepHours == 1 ? "hour" : "hours") of sleep.")
                                    .foregroundColor(.gray)
                            }
                        }
                        if let minEmoSleepState = emoSleepState.min {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.cyan)
                                    .opacity(0.7)
                                Text("The lowest productive state was \(minEmoSleepState.productivity) on \(minEmoSleepState.createdAt.toString()) after \(minEmoSleepState.SleepHours) \(minEmoSleepState.SleepHours == 1 ? "hour" : "hours") of sleep.")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    
                    //hours vs productivity
                    Text("SLEEP VS. PRODUCTIVITY")
                    if manager.sleepDataPoints.count > 0 {
                        Chart {
                            ForEach(manager.sleepDataPoints) { data in
                                BarMark(x: .value("HOURS", data.SleepHours),
                                        y: .value("RESULT", data.productivity))
                                .foregroundStyle (
                                    emoSleepState.max?.productivity == data.productivity ? .blue : (emoSleepState.min?.productivity == data.productivity ? .cyan : .gray)
                                )
                            }
                        }
                        
                    } else {
                        emptyChart
                    }
                    
                    VStack(spacing: 10) {
                        if let maxProSleepState = proSleepState.max {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.blue)
                                    .opacity(0.7)
                                Text("The hightest productive state was \(maxProSleepState.productivity) on \(maxProSleepState.createdAt.toString()) after \(maxProSleepState.SleepHours) \(maxProSleepState.SleepHours == 1 ? "hour" : "hours") of sleep.")
                            }
                        }
                        if let minProSleepState = proSleepState.min {
                                HStack(alignment: .top) {
                                    Image(systemName: "asterisk")
                                        .foregroundColor(.cyan)
                                        .opacity(0.7)
                                    Text("The lowest productive state was \(minProSleepState.productivity) on \(minProSleepState.createdAt.toString()) after \(minProSleepState.SleepHours) \(minProSleepState.SleepHours == 1 ? "hour" : "hours") of sleep.")
                                }
                        }
                        NavigationLink(destination: QuestionCard(quizCase: .sleep).environmentObject(manager)) {
                            Text("ADD DATA")
                                .foregroundColor(.white)
                                .font(.title.bold())
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(.mint))
                        }
                        .padding(.top, 50)
                    }
                    .foregroundColor(.gray)
                    .padding(.bottom)

                    Divider()
                        .padding(30)
                    
                    Text("SOCIAL")
                        .font(.title.bold())
                     
                    //hours vs feeling
                    Text("SOCIAL VS. EMOTIONAL STATE")
                    if manager.socialDataPoints.count > 0 {
                        Chart {
                            ForEach(manager.socialDataPoints) { data in
                                BarMark(x: .value("HOURS", data.SocialHours),
                                        y: .value("FEELS", data.feeling))
                                .foregroundStyle (
                                    emoSocialState.max?.feeling == data.feeling ? .blue : (emoSocialState.min?.feeling == data.feeling ? .cyan : .gray)
                                )
                            }
                        }
                    } else {
                        emptyChart
                    }
                     
                    VStack(spacing: 10) {
                        if let maxEmoSocialState = emoSocialState.max {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.blue)
                                    .opacity(0.7)
                                Text("The hightest productive state was \(maxEmoSocialState.productivity) on \(maxEmoSocialState.createdAt.toString()) after \(maxEmoSocialState.SocialHours) \(maxEmoSocialState.SocialHours == 1 ? "hour" : "hours") of social engagement.")
                            }
                        }
                        if let minEmoSocialState = emoSocialState.min {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.cyan)
                                    .opacity(0.7)
                                Text("The lowest productive state was \(minEmoSocialState.productivity) on \(minEmoSocialState.createdAt.toString()) after \(minEmoSocialState.SocialHours) \(minEmoSocialState.SocialHours == 1 ? "hour" : "hours") of social engagement.")
                            }
                        } 
                    }
                    .foregroundColor(.gray)
                    .padding(.bottom)
                     
                    
                    //hours vs productivity
                    Text("SOCIAL VS. PRODUCTIVITY")
                    if manager.socialDataPoints.count > 0 {
                        Chart {
                            ForEach(manager.socialDataPoints) { data in
                                BarMark(x: .value("HOURS", data.SocialHours),
                                        y: .value("RESULT", data.productivity))
                                .foregroundStyle (
                                    emoSocialState.max?.productivity == data.productivity ? .blue : (emoSocialState.min?.productivity == data.productivity ? .cyan : .gray)
                                )
                            }
                        }
                    } else {
                        emptyChart
                    }
                    
                    VStack(spacing: 10) {
                        if let maxProSocialState = proSocialState.max {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.blue)
                                    .opacity(0.7)
                                Text("The hightest productive state was \(maxProSocialState.productivity) on \(maxProSocialState.createdAt.toString()) after \(maxProSocialState.SocialHours) \(maxProSocialState.SocialHours == 1 ? "hour" : "hours") of social engagement.")
                            }
                        }
                        
                        if let minProSocialState = proSocialState.min {
                            HStack(alignment: .top) {
                                Image(systemName: "asterisk")
                                    .foregroundColor(.cyan)
                                    .opacity(0.7)
                                Text("The lowest productive state was \(minProSocialState.productivity) on \(minProSocialState.createdAt.toString()) after \(minProSocialState.SocialHours) \(minProSocialState.SocialHours == 1 ? "hour" : "hours") of social engagement.")
                            }
                        }
                        NavigationLink(destination: QuestionCard(quizCase: .social).environmentObject(manager)) {
                            Text("ADD DATA")
                                .foregroundColor(.white)
                                .font(.title.bold())
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(.mint))
                        }
                        .padding(.top, 50)
                    }
                    .foregroundColor(.gray)
                    .padding(.bottom)
                }
                .onAppear {
                    do {
                        Task {
                            try await manager.fetchSleepDataPoints()
                            try await manager.fetchSocialDataPoints()
                        }
                    }
                }
                .padding()
            }
        }
    }
        
    
    var emptyChart: some View {
        HStack(alignment: .top) {
            Image(systemName: "asterisk")
            Text("***Please input data to see results***")
            Image(systemName: "asterisk")
        }
    }
}

#Preview {
    ContentView()
}
