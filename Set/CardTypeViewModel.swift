//
//  CardType.swift
//  Set
//
//  Created by Flynn Traeger on 19/04/2021.
//

import Foundation
import SwiftUI

struct CardType: Equatable, Identifiable {
    var id: Int
    var pattern: ShapePattern
    var colour: ShapeColor
    var shading: ShapeShading
    var numberOfShapes: Int
    
    enum ShapePattern: Int {
        case circle = 0
        case rectangle = 1
        case diamond = 2
    }
    
    enum ShapeColor: Int {
        case purple = 0
        case red = 1
        case green = 2
    }
    
    enum ShapeShading: Int {
        case solid = 0
        case striped = 1
        case open = 2
    }
}
