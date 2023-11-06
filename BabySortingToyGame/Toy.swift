//
//  Toy.swift
//  BabySortingToyGame
//
//  Created by Dorothy Luetz on 10/30/23.
//

import SwiftUI

struct Toy {
    let id: Int
    var imageNumber: String {
        "stone\(id)"
    }
}

extension Toy {
    static let all = [
        Toy(id: 1),
        Toy(id: 2),
        Toy(id: 3),
        Toy(id: 4),
        Toy(id: 5),
        Toy(id: 6),
        Toy(id: 7),
        Toy(id: 8),
        Toy(id: 9)
    ]
}
