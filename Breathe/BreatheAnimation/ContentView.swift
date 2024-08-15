//
//  ContentView.swift
//  BreatheAnimation
//
//  Created by Ricardo Dias


import SwiftUI

struct ContentView: View {
    @State private var showWelcome = true
    @State private var showDurationSelection = false
    @State private var showHome = false
    @State private var breatheDuration: Int = 5
    
    var body: some View {
        VStack {
            if showWelcome {
                WelcomeView(showNextScreen: $showDurationSelection)
            } else if showDurationSelection {
                DurationSelectionView(showHome: $showHome, breatheDuration: $breatheDuration)
            } else if showHome {
                Home(breatheDuration: breatheDuration, showHome: $showHome)
            }
        }
        .onChange(of: showDurationSelection) { newValue in
            if newValue {
                showWelcome = false
            }
        }
        .onChange(of: showHome) { newValue in
            if newValue {
                showDurationSelection = false
            } else {
                showDurationSelection = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
