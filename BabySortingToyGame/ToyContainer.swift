//
//  ToyContainer.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 10/31/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ToyContainer: View {
    let toy: Toy
    @ObservedObject var viewModel: ToyViewModel
    @State private var animationAmount = 0.0
    @State var isAnimating: Bool = true
    private let regularSize: CGFloat = 100
    private let highlightedSize: CGFloat = 130
    
    var body: some View {
        ZStack {
            AnimatedImage(name: "stonetamb.gif", isAnimating: $isAnimating)
                .clipShape(Heart())
                .rotation3DEffect(.degrees(animationAmount), axis: (x: 1.5, y: 1.0, z: 2.3))
                .rotationEffect(.degrees(animationAmount))
                .onAppear {
                    withAnimation(.linear(duration: 0.1)
                        .speed(0.1).repeatForever(autoreverses: false)) {
                        animationAmount = 360.0
                    }
                }
            Image(toy.imageNumber)
                .resizable()
                .scaledToFit()
                .frame(width: regularSize, height: regularSize)
                .padding()
            if viewModel.isHighlighted(id: toy.id) {
                Image(toy.imageNumber)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
                    .frame(
                        width: highlightedSize,
                        height: highlightedSize
                    )
            }
        }
                .overlay {
                    GeometryReader { proxy -> Color in
                        viewModel.update(frame: proxy.frame(in: .global), for: toy.id)
                        return Color.clear
                    }
                }
                .frame(width: highlightedSize, height: highlightedSize)
        }
    }

#Preview {
    ToyContainer(
        toy: Toy.all.first!,
        viewModel: ToyViewModel()
    )
}
