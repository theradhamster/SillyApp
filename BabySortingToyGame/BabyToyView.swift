//
//  BabyToyView.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 10/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct BabyToyView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = ToyViewModel()
    @State private var animationAmount = 0.0
    @State var isAnimating: Bool = true
    @State var heheIsPresented = false
    @State var markIsPresented = false
    @State var emailIsPresented = false
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedImage(name: "stonecar.gif", isAnimating: $isAnimating)
                    .clipShape(Triangle())
                Triangle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                AnimatedImage(name: "stonecar.gif", isAnimating: $isAnimating)
                    .clipShape(InvertedTriangle())
                InvertedTriangle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                Image("goodmorging")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(Circle())
                    .rotationEffect(.degrees(animationAmount))
                    .onAppear {
                        withAnimation(.linear(duration: 2.0)
                            .speed(0.1).repeatForever(autoreverses: false)) {
                            animationAmount = 360.0
                        }
                    }
                
                HStack {
                    ZStack {
                        AnimatedImage(name: "stonetamb.gif", isAnimating: $isAnimating)
                            .clipShape(Triangle())
                            .frame(width: 100, height: 100)
                        Triangle()
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .frame(width: 100, height: 100)
                        AnimatedImage(name: "stonecar.gif", isAnimating: $isAnimating)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    ZStack {
                        AnimatedImage(name: "stonetamb.gif", isAnimating: $isAnimating)
                            .clipShape(Triangle())
                            .frame(width: 100, height: 100)
                        Triangle()
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .frame(width: 100, height: 100)
                        AnimatedImage(name: "stonecar.gif", isAnimating: $isAnimating)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
                .offset(y: 50)
                
                Button {
                    emailIsPresented.toggle()
                } label: {
                    AnimatedImage(name: "giphy.gif", isAnimating: $isAnimating)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .offset(x: 130, y: 340)
                
                .popover(isPresented: $emailIsPresented) {
                    Image("helloemail")
                        .resizable()
                        .presentationCompactAdaptation(.popover)
                    Text("Hello👋My name is Email")
                        .padding()
                }
                
                LazyVGrid(columns: gridItems, spacing: 30) {
                    ForEach(viewModel.toyContainers, id: \.id) { toy in
                        ToyContainer(toy: toy, viewModel: viewModel)
                    }
                }
                .padding()
                
                if let currentToy = viewModel.currentToy {
                    DraggableToy(toy: currentToy, position: viewModel.currentPosition, gesture: drag)
                        .opacity(viewModel.draggableToyOpacity)
                }
                
                Button {
                    heheIsPresented.toggle()
                } label: {
                    Image("stone3")
                        .resizable()
                        .frame(width: 300, height: 50)
                }
                .offset(x: -50, y: -370)
                
                .popover(isPresented: $markIsPresented) {
                        Image("markiplier")
                            .presentationCompactAdaptation(.popover)
                            .onAppear {
                                viewModel.current = viewModel.audioFiles[1]
                                viewModel.playSound()
                            }
                            .onDisappear {
                                viewModel.stopSound()
                            }
                }
                .offset(y: 60)
        
            }
            
            .onAppear {
                viewModel.setNextToy()
            }
            
            .alert(
                Text("Congratulations, you won!"),
                isPresented: $viewModel.isGameOver,
                actions: {
                    Button("OK") {
                        withAnimation {
                            viewModel.generateNewGame()
                        }
                    }
                },
                message: {
                    Text("Number of attempts: \(viewModel.attempts)")
                }
            )
            
            .alert(
                    Text("Would you like to see him?"),
                isPresented: $heheIsPresented,
                actions: {
                    Button("Eeeeeeiiii") {
                        withAnimation {
                            dismiss()
                        }
                    }
                    Button("Yes") {
                        markIsPresented.toggle()
                    }
                }
                )
        }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { state in
                viewModel.update(dragPosition: state.location)
            }
            .onEnded { state in
                viewModel.update(dragPosition: state.location)
                withAnimation {
                    viewModel.confirmWhereToyWasDropped()
                }
            }
    }
}

#Preview {
    BabyToyView()
}
