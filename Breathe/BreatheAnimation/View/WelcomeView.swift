//
//  WelcomeView.swift
//  BreatheAnimation
//
//  Created by Ricardo Dias on 13/08/2024.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showNextScreen: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Welcome to")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Breathe Animation")
                    .font(.title)
                    .foregroundColor(.white)
                
                Image(systemName: "lungs.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                
                Button(action: {
                    withAnimation {
                        showNextScreen = true
                    }
                }) {
                    Text("Start")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}



