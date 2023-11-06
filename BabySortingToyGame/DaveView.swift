//
//  DaveView.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 11/1/23.
//

import SwiftUI
import AVKit
import UIKit
import SDWebImageSwiftUI

struct DaveView: View {
    @StateObject private var viewModel = ToyViewModel()
    @State var whatsappIsPresented = false
    @State var isAnimating = true
    @State private var animationAmount = 0.0
    let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            PlayerView(resourceName: viewModel.videoNames[1])
                .ignoresSafeArea()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .rotationEffect(.degrees(animationAmount))
                .onAppear {
                    withAnimation(.linear(duration: 2.0)
                        .speed(0.1).repeatForever(autoreverses: false)) {
                        animationAmount = 360.0
                    }
                }
            VStack {
                Button {
                    whatsappIsPresented.toggle()
                } label: {
                    Image(systemName: "phone.bubble.left")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                //.offset(y: -200)
                .popover(isPresented: $whatsappIsPresented) {
                    PlayerView(resourceName: viewModel.videoNames[0])
                        .padding()
                        .frame(width: 250, height: 300, alignment: .center)
                        .presentationCompactAdaptation(.popover)
                }
//                PlayerView(resourceName: viewModel.videoNames[2])
//                    .clipShape(Heart())
//                    .frame(width: 200, height: 200)
                LazyVGrid(columns: gridItems, spacing: 30) {
                    ForEach(viewModel.daveContainers, id: \.id) { dave in
                        Button {
                            viewModel.current = dave.soundTitle
                            viewModel.playSound()
                        } label: {
                            Image(dave.imageNumber)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 85)
                        }
                    }
                }
            }
        }
    }
}

struct PlayerView: UIViewRepresentable {
    let resourceName: String
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(resourceName: resourceName)
    }
}

class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    
    init(resourceName: String) {
        super.init(frame: .zero)
        
        if let fileURL = Bundle.main.url(forResource: resourceName, withExtension: "mp4") {
            let player = AVPlayer(url: fileURL)
            player.actionAtItemEnd = .none
            player.play()
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspectFill
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            layer.addSublayer(playerLayer)
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero, completionHandler: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}

#Preview {
    DaveView()
}
