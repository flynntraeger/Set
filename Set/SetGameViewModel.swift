//
//  SetGameViewModel.swift
//  Memorize
//
//  Created by Flynn Traeger on 06/04/2021.
//
// VIEWMODEL  // enables reactive architecture

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGameModel<CardType>.Card
    
    static var deck = createDeck()
    
    static func createDeck() -> [CardType]  {
        var deck: [CardType] = []
        var id = 0
        for pattern in 0..<3 {
            for colour in 0..<3 {
                for shading in 0..<3 {
                    for numberOfShapes in 0..<3 {
                        let cardPattern = findPatternInt(patternNum: pattern)
                        let cardColour = findColorInt(colourNum: colour)
                        let cardShading = findShadingInt(shadingNum: shading)
                        deck.append(CardType(id: id,
                                             pattern: cardPattern,
                                             colour: cardColour,
                                             shading: cardShading,
                                             numberOfShapes: numberOfShapes))
                        id += 1
                    }
                }
            }
        }
        return deck
    }
    
    var cardsInDeck: [Card] {
        model.cardsInDeck
    }
    
    var displayedCards: [Card] {
        model.dealtCards
    }
    
    var selectedCards: [Card] {
        model.selectedCards
    }
    
    var discardedCards: [Card] {
        model.discardCards
    }
    
    static func findPatternInt(patternNum: Int) -> CardType.ShapePattern{
        switch patternNum {
        case 0:
            return .circle
        case 1:
            return .rectangle
        case 2:
            return .diamond
        default:
            return .circle
        }
    }
    
    static func findColorInt(colourNum: Int) -> CardType.ShapeColor{
        switch colourNum {
        case 0:
            return .purple
        case 1:
            return .red
        case 2:
            return .green
        default:
            return .purple
        }
    }
    
    static func findShadingInt(shadingNum: Int) -> CardType.ShapeShading{
        switch shadingNum {
        case 0:
            return .solid
        case 1:
            return .striped
        case 2:
            return .open
        default:
            return .solid
        }
    }
    
    static func createShapeSetGame(deck: [CardType]) -> SetGameModel<CardType> {
        return SetGameModel<CardType>(deck: deck) //initialise for 81 cards in deck with 12 displayed
    }
    
    @Published private var model = createShapeSetGame(deck: deck)

    init() { //initialisation needs to createShapeSetGame upon startup
        model = SetGameViewModel.createShapeSetGame(deck: SetGameViewModel.deck)
    }

//  MARK: - Intent(s)

    func newGame() { //need to shuffle the emojis chosen within a theme so the same emojis don't keep coming up repeatedly
        model = SetGameViewModel.createShapeSetGame(deck: SetGameViewModel.deck)
    }

    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealThreeNewCards() {
        return model.dealThreeNewCards()
    }
    
    func dealTwelveCards() {
        return model.dealFirstTwelveCards()
    }
    
    func deal(_ card: Card) {
        model.dealtCards.append(card)
    }
}
