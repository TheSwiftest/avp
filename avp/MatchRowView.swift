//
//  MatchRowView.swift
//  avp
//
//  Created by Brian Corbin on 6/4/22.
//

import SwiftUI

struct MatchRowView: View {
    let match: Match
    
    var matchTimeFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        return "\(dateFormatter.string(from: match.schedule.scheduleTime)) \(match.schedule.timeZone)"
    }
    
    private var matchStateSymbol: Image {
        switch match.matchState {
        case "F":
            return Image(systemName: "checkmark.circle")
        case "A":
            return Image(systemName: "play.circle")
        case "U":
            return Image(systemName: "clock")
        default:
            return Image(systemName: "checkmark.circle")
        }
    }
    
    private var matchStateColor: Color {
        switch match.matchState {
        case "F":
            return .yellow
        case "A":
            return .green
        case "U":
            return .primary
        default:
            return .primary
        }
    }
    
    private var matchTeamsFormatted: String {
        if match.teamA == nil && match.teamB == nil {
            return "TBD"
        }
        
        var teamAFormatted = "TBD"
        if let team = match.teamA {
            teamAFormatted = "\(team.captain.lastName) / \(team.player.lastName)"
        }
        
        var teamBFormatted = "TBD"
        if let team = match.teamB {
            teamBFormatted = "\(team.captain.lastName) / \(team.player.lastName)"
        }
        
        return "\(teamAFormatted) vs \(teamBFormatted)"
    }
    
    var body: some View {
        HStack {
            matchStateSymbol.foregroundColor(matchStateColor)
            VStack(alignment: .leading) {
                Text(matchTeamsFormatted).lineLimit(1).minimumScaleFactor(0.5)
                Text(matchTimeFormatted)
                    .font(.caption)
            }
            Spacer()
        }
    }
}

struct MatchRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MatchRowView(match: testMatches[0])
            MatchRowView(match: testMatches[1])
            MatchRowView(match: testMatches[2])
            MatchRowView(match: testMatches[3])
        }
        .previewLayout(.fixed(width: 300, height: 50))
    }
}
