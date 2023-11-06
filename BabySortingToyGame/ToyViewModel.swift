//
//  ToyViewModel.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 10/31/23.
//

import SwiftUI
import Foundation
import UIKit
import AVFoundation

class ToyViewModel: ObservableObject {
    @Published var currentToy: Toy?
    @Published var currentPosition = initialPosition
    @Published var highlightedId: Int?
    @Published var draggableToyOpacity: CGFloat = 1.0
    @Published var isGameOver = false
    @Published var current: String = ""
    @Published var currentDave: Dave?
    var audioFiles = ["fits.mp3", "biteof87.mp3"]
    private(set) var attempts = 0
    private static let initialPosition = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY + 270)
    private var frames: [Int: CGRect] = [:]
    private var toys = Array(Toy.all.shuffled().prefix(upTo: 5))
    var toyContainers = Toy.all.shuffled()
    var player: AVAudioPlayer?
    var daveContainers = Dave.all
    var videoNames = ["whatsappwednesday", "hellome", "drugproblem"]
    func confirmWhereToyWasDropped() {
        defer { highlightedId = nil }
        guard let highlightedId = highlightedId else {
            resetPosition()
            return
        }
        if highlightedId == currentToy?.id {
            setCurrentPositionToHighlightedContainer(WithId: highlightedId)
            generateNextRound()
        } else {
            resetPosition()
        }
        attempts += 1
    }
    func resetPosition() {
        currentPosition = ToyViewModel.initialPosition
    }
    func setCurrentPositionToHighlightedContainer(WithId id: Int) {
        guard let frame = frames[id] else {
            return
        }
        currentPosition = CGPoint(x: frame.midX, y: frame.midY)
        makeToyInvisible()
    }
    func makeToyInvisible() {
        draggableToyOpacity = 0
    }
    func generateNextRound() {
        setNextToy()
        if currentToy == nil {
            gameOver()
        } else {
            preparedObjects()
        }
    }
    func setNextToy() {
        currentToy = toys.popLast()
    }
    func gameOver() {
        isGameOver = true
    }
    func preparedObjects() {
        shuffleToyContainersWithAnimation()
        resetCurrentToyWithoutAnimation()
    }
    func shuffleToyContainersWithAnimation() {
        withAnimation {
            toyContainers.shuffle()
        }
    }
    func resetCurrentToyWithoutAnimation() {
        withAnimation(.none) {
            resetPosition()
            restoreOpacityWithAnimation()
        }
    }
    func restoreOpacityWithAnimation() {
        withAnimation {
            draggableToyOpacity = 1.0
        }
    }
    func generateNewGame() {
        toys = Array(Toy.all.shuffled().prefix(upTo: 5))
        attempts = 0
        generateNextRound()
    }
    func update(frame: CGRect, for id: Int) {
        frames[id] = frame
    }
    func update(dragPosition: CGPoint) {
        currentPosition = dragPosition
        for (id, frame) in frames where frame.contains(dragPosition) {
            highlightedId = id
            return
        }
        highlightedId = nil
    }
    func isHighlighted(id: Int) -> Bool {
        highlightedId == id
    }
    func playSound() {
        guard let path = Bundle.main.path(forResource: self.current, ofType: nil) else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func stopSound() {
        player!.stop()
        }
}

struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY ))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.height/4), control1:CGPoint(x: rect.midX, y: rect.height*3/4), control2: CGPoint(x: rect.minX, y: rect.midY))
        path.addArc(center: CGPoint( x: rect.width/4,y: rect.height/4), radius: (rect.width/4), startAngle: Angle(radians: Double.pi), endAngle: Angle(radians: 0), clockwise: false)
        path.addArc(center: CGPoint( x: rect.width * 3/4,y: rect.height/4), radius: (rect.width/4), startAngle: Angle(radians: Double.pi), endAngle: Angle(radians: 0), clockwise: false)
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.height), control1: CGPoint(x: rect.width, y: rect.midY), control2: CGPoint(x: rect.midX, y: rect.height*3/4))
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct InvertedTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}
