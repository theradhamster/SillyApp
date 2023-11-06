//
//  ContentView.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 11/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BabyToyView()
                .tabItem {
                    Label("Steno", systemImage: "fan.ceiling")
                }
            DaveView()
                .tabItem {
                    Label("Dave", systemImage: "carrot")
                }
        }
    }
}

#Preview {
    ContentView()
}
