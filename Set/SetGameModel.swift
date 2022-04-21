//
//  SetGameModel.swift
//  Memorize
//
//  Created by Flynn Traeger on 06/04/2021.
//
// MODEL

import Foundation

struct SetGameModel<CardContent> where CardContent: Equatable {
    private(set) var cardsInDeck: [Card]  = []
    
    var dealtCards: [Card] = []

    var selectedCards: [Card] = []
    
    var discardCards: [Card] = []
    
    mutating func choose(_ card: Card) {
        if !selectedCards.contains(card) {
            selectedCards.append(card)
        } else {
            if let selectedIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
                selectedCards.remove(at: selectedIndex)
            }
        }
        if selectedCards.count == 3 { //check for set
            if compareSet(selectedCards: selectedCards) { //remove from view
                for card in selectedCards {
                    card.match = true
                }
            } else {
                for card in selectedCards {
                    card.match = false
                }
            }
        } else if selectedCards.count == 4 {
            if let selectedIndex = selectedCards.firstIndex(where: { $0.id == card.id }) {
                selectedCards.remove(at: selectedIndex)
            }
            dealtCards.removeAll() { Card in
                selectedCards.contains(Card)
            }
            for card in selectedCards {
                discardCards.append(card)
            }
            for card in dealtCards  {
                card.match = nil
            }
            selectedCards = []
            selectedCards.append(card)
        }
    }
    
    init(deck: Array<CardType>) { 
        cardsInDeck = []
        for index in 0..<deck.count { //should be 81
            let content = deck[index]
            cardsInDeck.append(Card(content: content, id: index))
        }
        cardsInDeck.shuffle()
    }
    
    mutating func dealFirstTwelveCards() {
        for _ in 0..<12 {
            guard let poppedCard = cardsInDeck.popLast() else { return }
            dealtCards.append(poppedCard)
        }
        for card in dealtCards {
            card.isFaceUp = true
        }
    }
    
    mutating func dealThreeNewCards() {
        for _ in 0..<3 {
            guard let lastCard = cardsInDeck.popLast() else { return }
            dealtCards.append(lastCard)
        }
        for card in dealtCards {
            card.isFaceUp = true
        }
    }
    
    
    class Card: Identifiable, Equatable {
        static func == (lhs: SetGameModel<CardContent>.Card, rhs: SetGameModel<CardContent>.Card) -> Bool {
            return lhs.id == rhs.id
        }

        var isFaceUp = false
        var content: CardType
        var onScreen: Bool = false
        var match: Bool? = nil
        var id: Int = -1

        init(content: CardType, id: Int) {
            self.content = content
            self.id = id
        }
    }
    
    func compareSet(selectedCards: [Card]) -> Bool {
        let cardOne = selectedCards[0]
        let cardTwo = selectedCards[1]
        let cardThree = selectedCards[2]
        if cardOne.content.numberOfShapes == cardTwo.content.numberOfShapes && cardOne.content.numberOfShapes == cardThree.content.numberOfShapes {
            return true
        } else if cardOne.content.colour == cardTwo.content.colour && cardOne.content.colour == cardThree.content.colour {
            return true
        } else if cardOne.content.pattern == cardTwo.content.pattern && cardOne.content.pattern == cardThree.content.pattern {
            return true
        } else if cardOne.content.shading == cardTwo.content.shading && cardOne.content.shading == cardThree.content.shading {
            return true
        } else {
            return false
        }
    }
}
