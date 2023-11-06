//
//  DraggableToy.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 10/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DraggableToy<Draggable: Gesture>: View {
    @State var isAnimating: Bool = true
    let toy: Toy
    private let size: CGFloat = 100
    let position: CGPoint
    let gesture: Draggable
    
    var body: some View {
        Image(toy.imageNumber)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .shadow(radius: 10)
            .position(position)
            .gesture(gesture)
    }
}

#Preview {
    DraggableToy(
        toy: Toy.all.first!,
        position: .zero,
        gesture: DragGesture()
    )
    .previewInterfaceOrientation(.landscapeLeft)
}
