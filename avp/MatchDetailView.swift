//
//  MatchDetailView.swift
//  avp
//
//  Created by Brian Corbin on 6/4/22.
//

import SwiftUI

struct MatchDetailView: View {
    enum Info: String {
        case results, stats
    }
    
    let match: Match
    
    @State private var infoShowing: Info = .results
    
    var body: some View {
        VStack {
            Picker("Info Showing", selection: $infoShowing) {
                Text(MatchDetailView.Info.results.rawValue.capitalized).tag(MatchDetailView.Info.results)
                Text(MatchDetailView.Info.stats.rawValue.capitalized).tag(MatchDetailView.Info.stats)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            MatchDetailResultsView(match: match)
        }
    }
}

struct MatchDetailResultsView: View {
    let match: Match
    
    var body: some View {
        VStack {
            HStack {
                Group {
                    Text("Team")
                    Text("Sets Won")
                    Text("Set 1")
                    Text("Set 2")
                    Text("Set 3")
                }
                .font(.caption)
            }
            HStack {
                Text("#\(match.teamA!.seed)")
                VStack(alignment: .leading) {
                    Text(match.teamA!.captain.fullName)
                    Text(match.teamA!.player.fullName)
                }
                Text("\(match.setsWonA)")
                Text("\(match.sets![0].a)")
                Text("\(match.sets![1].a)")
                Text("\(match.sets![2].a)")
            }
            HStack {
                
            }
        }
//        HStack {
//            VStack(alignment: .center) {
//                Text("Team")
//                    .font(.caption)
//                Text(match.teamA!.captain.fullName)
//                Text(match.teamA!.player.fullName)
//                Text("T/O Remaining")
//                    .font(.caption2)
//            }
//        }
    }
}

struct MatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MatchDetailView(match: testMatches[0])
        }
        .previewLayout(.sizeThatFits)
    }
}
