//
//  DatabaseManager.swift
//  Tracker
//
//  Created by Roaa on 2/2/24.
//

import Foundation
import Supabase

struct SleepDataPoints: Identifiable, Codable, Equatable {
    var id: Int? //to not have to init id when creating a SDP instance, declare it as var so that the manager could handle it
    let createdAt: Date
    let SleepHours: Int
    let feeling: Int
    let productivity: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case SleepHours, feeling, productivity
    }
}

struct SocialDataPoints: Identifiable, Codable, Equatable {
    var id: Int? //to not have to init id when creating a SDP instance, declare it as var so that the manager could handle it
    let createdAt: Date
    let SocialHours: Int
    let feeling: Int
    let productivity: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case feeling, productivity, SocialHours
    }
}

class DatabaseManager: ObservableObject {
    @Published var sleepDataPoints = [SleepDataPoints]()
    @Published var socialDataPoints = [SocialDataPoints]()
    
    private let client = SupabaseClient(supabaseURL: URL(string: "https://ywzxbqfntowhteujusqf.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3enhicWZudG93aHRldWp1c3FmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDY5MDI5MDQsImV4cCI6MjAyMjQ3ODkwNH0.cYloJG5nu-CzS269n1c4I_IbtuOYOWaplM7ZNCsf7vY")
    
    init() {
        Task {
            do {
                let sleepDataPoints = try await fetchSleepDataPoints()
                let socialDataPoints = try await fetchSocialDataPoints()
                await MainActor.run { //to pass the values to the @Published variables
                    self.sleepDataPoints = sleepDataPoints
                    self.socialDataPoints = socialDataPoints
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchSleepDataPoints() async throws -> [SleepDataPoints] {
        return try await client.database.from("Sleep Data Points").select().execute().value
    }
    
    func fetchSocialDataPoints() async throws -> [SocialDataPoints] {
        return try await client.database.from("Social Data Points").select().execute().value
    }
    
    func postSleepData(SleepHours: Int, feeling: Int, productivity: Int, date: Date) async throws {
        _ = try await client.database.from("Sleep Data Points").insert(SleepDataPoints(createdAt: date, SleepHours: SleepHours, feeling: feeling, productivity: productivity)).execute()
    }
    
    func postSocialData(SocialHours: Int, feeling: Int, productivity: Int, date: Date) async throws {
        _ = try await client.database.from("Social Data Points").insert(SocialDataPoints(createdAt: date, SocialHours: SocialHours, feeling: feeling, productivity: productivity)).execute()
    }
    
}
