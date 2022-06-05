//
//  MatchView.swift
//  avp
//
//  Created by Brian Corbin on 6/4/22.
//

import SwiftUI

class TournamentMatches: ObservableObject {
    @Published var loadingInitial = true
    @Published var matches: Matches = []
    @Published var selectedDate: Date = Date.now
    
    var matchesByDateAndCourt: [Date: [String: Matches]] {
        var temp: [Date: [String: Matches]] = [:]
        let matchesByDate = Dictionary(grouping: matches) { match -> Date in
            let dateComponents = Calendar.current.dateComponents([.day, .year, .month], from: match.schedule.scheduleTime)
            return Calendar.current.date(from: dateComponents)!
        }
        
        for (date, matches) in matchesByDate {
            let matchesByCourt = Dictionary(grouping: matches) { match -> String in
                match.schedule.courtName
            }
            
            temp[date] = matchesByCourt
        }
        
        return temp
    }
    
    func matchesForCourt(_ courtId: String) -> Matches {
        return matchesByDateAndCourt[selectedDate]![courtId]!.sorted(by: {$0.schedule.scheduleTime < $1.schedule.scheduleTime})
    }
    
    func datesSorted() -> [Date] {
        return Array(matchesByDateAndCourt.keys).sorted(by: {$0 < $1})
    }
    
    func courtIdsSorted() -> [String] {
        let matchesByCourt = matchesByDateAndCourt[selectedDate]!
        let courtIds = Array(matchesByCourt.keys)
        return courtIds.sorted { courtA, courtB in
            return Int(courtA) ?? 0 < Int(courtB) ?? 0
        }
    }
    
    init() {
        loadMatches()
    }
    
    func loadMatches() {
        loadingInitial = true
        Task {
            do {
                let matches = try await MatchService.getMatches()
                DispatchQueue.main.async {
                    self.matches = matches
                    self.selectedDate = self.datesSorted().first!
                    self.loadingInitial = false
                }
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}

struct MatchesScheduleView: View {
    @StateObject var tournamentMatches = TournamentMatches()
    
    private func name(for courtId: String) -> String {
        if courtId == "ST" {
            return "Stadium"
        }
        
        return "Court \(courtId)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d"
        return dateFormatter.string(from: date)
    }
    
    var body: some View {
        if tournamentMatches.loadingInitial {
            Text("Loading matches...")
        } else {
            VStack {
                Picker("Date", selection: $tournamentMatches.selectedDate) {
                    ForEach(tournamentMatches.datesSorted(), id: \.self) { date in
                        Text(formatDate(date))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                List {
                    ForEach(tournamentMatches.courtIdsSorted(), id: \.self) { courtId in
                        Section {
                            ForEach(tournamentMatches.matchesForCourt(courtId)) { match in
                                NavigationLink {
                                    MatchDetailView(match: match)
                                } label: {
                                    MatchRowView(match: match)
                                }
                            }
                        } header: {
                            Text(name(for: courtId))
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
        }
    }
}

struct MatchesScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesScheduleView()
    }
}
