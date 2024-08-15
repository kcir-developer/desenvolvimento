//
//  Home.swift
//  BreatheAnimation
//
//  Created by Ricardo Dias
//

import SwiftUI

// Extensão para a localização
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

struct Home: View {
    var breatheDuration: Int
    @Binding var showHome: Bool  // Adiciona um Binding para controle de navegação

    @State var currentType: BreatheType = sampleTypes[0]
    @Namespace var animation
    @State var showBreatheView: Bool = false
    @State var startAnimation: Bool = false
    @State var timerCount: CGFloat = 0
    @State var breatheAction: String = "Breathe In".localized
    @State var count: Int = 0

    var body: some View {
            ZStack {
                Background()
                
                VStack {
                    Content()
                    
                    Text(breatheAction)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .opacity(showBreatheView ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: breatheAction)
                        .animation(.easeInOut(duration: 1), value: showBreatheView)
                    
                    Spacer() // Adiciona um espaço flexível

                    // Botão movido para o final do VStack
                    Button(action: {
                        withAnimation {
                            showHome = false
                        }
                    }) {
                        Text("Back to Duration Selection")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10) // Adiciona um padding na parte inferior
                }
            }
                
        .onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()) { _ in
            if showBreatheView {
                if timerCount > 3.2 {
                    timerCount = 0
                    breatheAction = (breatheAction == "Breathe Out".localized ? "Breathe In".localized : "Breathe Out".localized)
                    withAnimation(.easeInOut(duration: 3).delay(0.1)) {
                        startAnimation.toggle()
                    }
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                } else {
                    timerCount += 0.01
                }
                count = 3 - Int(timerCount)
            } else {
                timerCount = 0
            }
        }
    }
    
    @ViewBuilder
    func Content() -> some View {
        VStack {
            HStack {
                Text("Breathe".localized)
                    .font(.largeTitle.bold())
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button { } label: {
                    Image(systemName: "suit.heart")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 42, height: 42)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.ultraThinMaterial)
                        }
                }
            }
            .padding()
            .opacity(showBreatheView ? 0 : 1)
            
            GeometryReader { proxy in
                let size = proxy.size
                VStack {
                    BreatheView(size: size)
                    Text("Breathe to reduce".localized)
                        .font(.title3)
                        .foregroundColor(.white)
                        .opacity(showBreatheView ? 0 : 1)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 12) {
                            ForEach(sampleTypes) { type in
                                Text(type.title)
                                    .foregroundColor(currentType.id == type.id ? .black : .white)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background {
                                        ZStack {
                                            if currentType.id == type.id {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(.white)
                                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                            } else {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .stroke(.white.opacity(0.5))
                                            }
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            currentType = type
                                        }
                                    }
                            }
                        }
                        .padding()
                        .padding(.leading, 25)
                        .frame(maxWidth: .infinity)
                    }
                    .opacity(showBreatheView ? 0 : 1)
                    
                    Button(action: startBreathing) {
                        Text(showBreatheView ? "Finish Breathe".localized : "START".localized)
                            .fontWeight(.semibold)
                            .foregroundColor(showBreatheView ? .white.opacity(0.75) : .black)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background {
                                if showBreatheView {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(.white.opacity(0.5))
                                } else {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(currentType.color.gradient)
                                }
                            }
                    }
                    .padding()
                }
                .frame(width: size.width, height: size.height, alignment: .bottom)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func BreatheView(size: CGSize) -> some View {
        ZStack {
            ForEach(1...8, id: \.self) { index in
                Circle()
                    .fill(currentType.color.gradient.opacity(0.5))
                    .frame(width: 150, height: 150)
                    .offset(x: startAnimation ? 0 : 75)
                    .rotationEffect(.init(degrees: Double(index) * 45))
                    .rotationEffect(.init(degrees: startAnimation ? -45 : 0))
            }
        }
        .scaleEffect(startAnimation ? 0.8 : 1)
        .overlay {
            Text("\(count == 0 ? 1 : count)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .animation(.easeInOut, value: count)
                .opacity(showBreatheView ? 1 : 0)
        }
        .frame(height: (size.width - 40))
    }
    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            Image("BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(x: -200, y: -250)
                .frame(width: size.width, height: size.height)
                .clipped()
                .blur(radius: startAnimation ? 4 : 0, opaque: true)
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                currentType.color.opacity(0.9),
                                .clear,
                                .clear
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height / 1.5)
                            .frame(maxHeight: .infinity, alignment: .top)
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .clear,
                                .black,
                                .black,
                                .black,
                                .black
                            ], startPoint: .top, endPoint: .bottom))
                            .frame(height: size.height / 1.35)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
        }
        .ignoresSafeArea()
    }
    
    func startBreathing() {
        if showBreatheView {
            showBreatheView = false
            return
        }
        withAnimation(.easeInOut(duration: 0.5)) {
            showBreatheView = true
        }
        withAnimation(.easeInOut(duration: 3).delay(0.05)) {
            startAnimation = true
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        // Cria um estado para o parâmetro 'showHome'
        Home(breatheDuration: 5, showHome: .constant(true))
    }
}
