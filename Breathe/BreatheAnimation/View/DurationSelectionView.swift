//
//  DurationSelectionView.swift
//  BreatheAnimation
//
//  Created by Ricardo Dias on 13/08/2024.
//

import SwiftUI

struct DurationSelectionView: View {
    @Binding var showHome: Bool
    @Binding var breatheDuration: Int
    
    var body: some View {
        ZStack {
            // Imagem de fundo
            Image("silhouette")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            // Conteúdo existente
            VStack {
                Text("Select Duration")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white) // Ajuste a cor do texto conforme necessário
                
                Picker("Duration", selection: $breatheDuration) {
                    ForEach(1..<11) { duration in
                        Text("\(duration) minutes").tag(duration)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                
                Button(action: {
                    withAnimation {
                        showHome = true
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
}
