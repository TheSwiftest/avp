//
//  MatchService.swift
//  avp
//
//  Created by Brian Corbin on 6/3/22.
//

import Foundation

class MatchService: ObservableObject {
    
    enum MatchServiceError: Error {
        case invalidUrl
    }
    
    static func getMatches() async throws -> Matches {
        guard let url = URL(string: "https://volleyballapi.web4data.co.uk/api/matches/byevent/28") else {
            throw MatchServiceError.invalidUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return try decoder.decode(Matches.self, from: data)
    }
}
            
typealias Matches = [Match]
typealias Stats = [Match.Stat]
typealias Sets = [Match.Set]

struct Match: Decodable, Identifiable {
    var id: String {
        return "\(eventId)-\(tournamentId)-\(competitionId)-\(bracketId)-\(matchNo)"
    }
    
    let stats: Stats
    let schedule: Schedule
    let eventId: Int
    let eventName: String
    let year: Int
    let tournamentId: Int
    let tournamentName: String
    let competitionId: Int
    let competitionName: String
    let competitionCode: String
    let matchNo: Int
    let bracketId: Int
    let bracket: String
    let teamA: Team?
    let teamB: Team?
    let setsWonA: Int
    let setsWonB: Int
    let currSet: Int?
    let sets: Sets?
    let winner: Int?
    let resultCode: String
    let startTime: String?
    let finishTime: String?
    let matchState: String
    let server: Int?
    let serveState: Int
    let matchDuration: String
    let sideoutActive: Bool
    let inTimeout: Bool
    
    enum CodingKeys: String, CodingKey {
        case stats = "Stats"
        case schedule = "MatchSchedule"
        case eventId = "EventId"
        case eventName = "EventName"
        case year = "Year"
        case tournamentId = "TournamentId"
        case tournamentName = "TournamentName"
        case competitionId = "CompetitionId"
        case competitionName = "CompetitionName"
        case competitionCode = "CompetitionCode"
        case matchNo = "MatchNo"
        case bracketId = "BracketId"
        case bracket = "Bracket"
        case teamA = "TeamA"
        case teamB = "TeamB"
        case setsWonA = "SetsWonA"
        case setsWonB = "SetsWonB"
        case currSet = "CurrSet"
        case sets = "Sets"
        case winner = "Winner"
        case resultCode = "ResultCode"
        case startTime = "StartTime"
        case finishTime = "FinishTime"
        case matchState = "MatchState"
        case server = "Server"
        case serveState = "ServeState"
        case matchDuration = "MatchDuration"
        case sideoutActive = "SideoutActive"
        case inTimeout = "InTimeout"
    }
    
    struct Stat: Decodable {
        let competitionId: Int
        let matchNo: Int
        let playerIndex: Int
        let setNo: Int
        let playerId: Int
        let attacks: Int
        let kills: Int
        let hittingErrors: Int
        let digs: Int
        let tBlocks: Int
        let aces: Int
        let serviceErrors: Int
        let miscErrors: Int
        let teamHittingPercentage: String
        let cBlocks: Int
        let passInt: Int
        let passOut: Int
        let passRating: String
        
        enum CodingKeys: String, CodingKey {
            case competitionId = "CompetitionId"
            case matchNo = "MatchNo"
            case playerIndex = "PlayerIndex"
            case setNo = "SetNo"
            case playerId = "PlayerId"
            case attacks = "Attacks"
            case kills = "Kills"
            case hittingErrors = "HittingErrors"
            case digs = "Digs"
            case tBlocks = "TBlocks"
            case aces = "Aces"
            case serviceErrors = "ServiceErrors"
            case miscErrors = "MiscErrors"
            case teamHittingPercentage = "TeamHittingPercentage"
            case cBlocks = "CBlocks"
            case passInt = "PassIn"
            case passOut = "PassOut"
            case passRating = "PassRating"
        }
    }
    
    struct Schedule: Decodable {
        let scheduleDisp: String
        let scheduleTime: Date
        let timeZone: String
        let courtName: String
        
        enum CodingKeys: String, CodingKey {
            case scheduleDisp = "ScheduleDisp"
            case scheduleTime = "ScheduleTime"
            case timeZone = "TimeZone"
            case courtName = "CourtName"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            scheduleDisp = try container.decode(String.self, forKey: .scheduleDisp)
            timeZone = try container.decode(String.self, forKey: .timeZone)
            courtName = try container.decode(String.self, forKey: .courtName)
            
            let dateString = try container.decode(String.self, forKey: .scheduleTime)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            guard let date = dateFormatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(forKey: .scheduleTime, in: container, debugDescription: "Date string does not match format expected by formatter")
            }
            
            scheduleTime = date
        }
    }
    
    struct Team: Decodable {
        let captain: Player
        let player: Player
        let status: String?
        let rank: Int?
        let seed: Int
        
        enum CodingKeys: String, CodingKey {
            case captain = "Captain"
            case player = "Player"
            case status = "Status"
            case rank = "Rank"
            case seed = "Seed"
        }
        
        struct Player: Decodable {
            let playerId: Int
            let lastName: String
            let firstName: String
            let gender: String
            
            var fullName: String {
                return "\(firstName) \(lastName)"
            }
            
            enum CodingKeys: String, CodingKey {
                case playerId = "PlayerId"
                case lastName = "LastName"
                case firstName = "FirstName"
                case gender = "Gender"
            }
        }
    }
    
    struct Set: Decodable {
        let setNo: Int
        let a: Int
        let b: Int
        let servesA: Int
        let servesB: Int
        let duration: String
        let startTime: String
        let endTime: String?
        let freezeServeCountA: Int
        let freezeServeCountB: Int
        let timeoutsTakenA: Int
        let timeoutsTakenB: Int
        let initServeState: Int
        
        enum CodingKeys: String, CodingKey {
            case setNo = "SetNo"
            case a = "A"
            case b = "B"
            case servesA = "ServesA"
            case servesB = "ServesB"
            case duration = "Duration"
            case startTime = "StartTime"
            case endTime = "EndTime"
            case freezeServeCountA = "FreezeServeCountA"
            case freezeServeCountB = "FreezeServeCountB"
            case timeoutsTakenA = "TimeoutsTakenA"
            case timeoutsTakenB = "TimeoutsTakenB"
            case initServeState = "InitServeState"
        }
    }
}
