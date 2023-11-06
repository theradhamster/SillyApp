//
//  Dave.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 11/2/23.
//

import SwiftUI

struct Dave {
    let id: Int
    var imageNumber: String {
        "dave\(id)"
    }
    var soundTitle: String
}

extension Dave {
    static let all = [
        Dave(id: 1, soundTitle: "watchhimbecomeagod.mp3"),
        Dave(id: 2, soundTitle: "daveplums.mp3"),
        Dave(id: 3, soundTitle: "40doubled.mp3"),
        Dave(id: 4, soundTitle: "davelaser.mp3")
    ]
}
