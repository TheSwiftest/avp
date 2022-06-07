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
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible(minimum: 125)), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], alignment: .center) {
            Group {
                Spacer()
                Text("Team")
                Text("Set 1")
                Text("Set 2")
                Text("Set 3")
                Text("Won")
            }
            .font(.caption)
            
            Group {
                Text("#\(match.teamA!.seed)")
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text(match.teamA!.captain.lastName)
                            Text(match.teamA!.player.lastName)
                        }.lineLimit(1)
                    }
                    Spacer()
                }
                
                if let sets = match.sets {
                    if sets.count > 0 {
                        Text("\(sets[0].a)")
                    } else {
                        Spacer()
                    }
                    
                    if sets.count > 1 {
                        Text("\(sets[1].a)")
                    } else {
                        Spacer()
                    }
                    
                    if sets.count > 2 {
                        Text("\(sets[2].a)")
                    } else {
                        Spacer()
                    }
                } else {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                Text("\(match.setsWonA)")
            }
            
            Group {
                Spacer()
                HStack {
                    Text("T/O Remaining")
                        .font(.caption)
                    Spacer()
                }
                Group {
                    if let sets = match.sets {
                        if sets.count > 0 {
                            Text("\(1 - sets[0].timeoutsTakenA)")
                        } else {
                            Spacer()
                        }
                        
                        if sets.count > 1 {
                            Text("\(1 - sets[1].timeoutsTakenA)")
                        } else {
                            Spacer()
                        }
                        
                        if sets.count > 2 {
                            Text("\(1 - sets[2].timeoutsTakenA)")
                        } else {
                            Spacer()
                        }
                    } else {
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                .font(.caption)
                Spacer()
            }
            
            Group {
                Text("#\(match.teamB!.seed)")
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            Text(match.teamB!.captain.lastName)
                            Text(match.teamB!.player.lastName)
                        }.lineLimit(1)
                    }
                    Spacer()
                }
                
                if let sets = match.sets {
                    if sets.count > 0 {
                        Text("\(sets[0].b)")
                    } else {
                        Spacer()
                    }
                    
                    if sets.count > 1 {
                        Text("\(sets[1].b)")
                    } else {
                        Spacer()
                    }
                    
                    if sets.count > 2 {
                        Text("\(sets[2].b)")
                    } else {
                        Spacer()
                    }
                } else {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                Text("\(match.setsWonB)")
            }
            
            Group {
                Spacer()
                HStack {
                    Text("T/O Remaining")
                        .font(.caption)
                    Spacer()
                }
                Group {
                    if let sets = match.sets {
                        if sets.count > 0 {
                            Text("\(1 - sets[0].timeoutsTakenA)")
                        } else {
                            Spacer()
                        }
                        
                        if sets.count > 1 {
                            Text("\(1 - sets[1].timeoutsTakenA)")
                        } else {
                            Spacer()
                        }
                        
                        if sets.count > 2 {
                            Text("\(1 - sets[2].timeoutsTakenA)")
                        } else {
                            Spacer()
                        }
                    } else {
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                .font(.caption)
                Spacer()
            }
        }
    }
}

struct MatchDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MatchDetailView(match: testMatches[0])
        }
    }
}
