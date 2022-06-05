//
//  ContentView.swift
//  avp
//
//  Created by Brian Corbin on 6/3/22.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        NavigationView {
            MatchesScheduleView()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Schedule")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
