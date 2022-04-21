//
//  SetGameView.swift
//  Memorize
//
//  Created by Flynn Traeger on 29/03/2021.
//
//  VIEW  /  UI

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                startNewGame
                gameBody
            }
            HStack {
                deckBody
                discardBody
            }
        }
        .padding()
    }
    
    private func isUndealt(_ card: SetGameViewModel.Card) -> Bool {
        !game.displayedCards.contains(card)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.displayedCards, aspectRatio: 2/3) { cardViewModel in
            CardView(cardViewModel: cardViewModel)
                .matchedGeometryEffect(id: cardViewModel.id, in: dealingNamespace)
                .padding(4)
                .onTapGesture {
                    withAnimation {
                        game.choose(cardViewModel) //asking viewModel to express the user's intent
                    }
                }
                .foregroundColor(cardViewModel.match == false ? .red :
                                    cardViewModel.match == true ? .green :
                                    game.selectedCards.contains(cardViewModel) ? .yellow : .black).animation(Animation.linear(duration: 0.5))
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cardsInDeck.filter(isUndealt)) { card in
                CardView(cardViewModel: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
            if game.displayedCards.count != 0 {
                withAnimation() {
                    game.dealThreeNewCards()
                }
            } else {
                withAnimation() {
                    game.dealTwelveCards()
                }
            }
        }
    }
    
    var discardBody: some View {
        ZStack {
            ForEach(game.discardedCards) { card in
                CardView(cardViewModel: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    }
    
    var startNewGame : some View {
        Button(action: {
            //Start new  game with 12 randomly chosen cards
                withAnimation {
                    game.newGame()
                }
        }, label: {
            Text("New Game")
                .font(.headline)
            }
        )}
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}

struct CardView: View {
    let cardViewModel: SetGameViewModel.Card
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if cardViewModel.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    drawMultipleShapes(numberOfShapes: cardViewModel.content.numberOfShapes,
                                       shapePattern: cardViewModel.content.pattern,
                                       shapeColour: cardViewModel.content.colour,
                                       shapeShading: cardViewModel.content.shading).padding()
    //                    .frame(minWidth: 100, maxWidth: 120, minHeight: 80, maxHeight: 80)
//                    if cardViewModel.match == true {
//                        shape.animation(Animation.linear(duration: 1).repeatForever())
//                    } else if cardViewModel.match == false {
//                        shape.animation(Animation.spring().repeatForever())
//                    }
                } else {
                    shape.fill()
                }
            }
        }
    }
}

@ViewBuilder
func drawOneShape(shapePattern: CardType.ShapePattern, shapeColour: CardType.ShapeColor, shapeShading: CardType.ShapeShading) -> some View {
    switch shapePattern {
    case .circle:
        if shapeShading == .solid || shapeShading == .striped {
            Ellipse().foregroundColor(getColour(shapeColour: shapeColour)).opacity(getShading(shapeShading: shapeShading))
        } else {
            Ellipse().stroke(lineWidth: DrawingConstants.lineWidth).foregroundColor(getColour(shapeColour: shapeColour))
        }
    case .rectangle:
        if shapeShading == .solid || shapeShading == .striped {
            Rectangle().foregroundColor(getColour(shapeColour: shapeColour)).opacity(getShading(shapeShading: shapeShading))
        } else {
            Rectangle().stroke(lineWidth: DrawingConstants.lineWidth).foregroundColor(getColour(shapeColour: shapeColour))
        }
    case .diamond:
        if shapeShading == .solid || shapeShading == .striped {
            Diamond().foregroundColor(getColour(shapeColour: shapeColour)).opacity(getShading(shapeShading: shapeShading))
        } else {
            Diamond().stroke(lineWidth: DrawingConstants.lineWidth).foregroundColor(getColour(shapeColour: shapeColour))
        }
    }
}

func getColour(shapeColour: CardType.ShapeColor) -> Color {
    switch shapeColour {
    case .purple:
        return .purple
    case .red:
        return .red
    case .green:
        return .green
    }
}

func getShading(shapeShading: CardType.ShapeShading) -> Double {
    switch shapeShading {
    case .solid:
        return 1.0
    case .striped:
        return 0.2
    case .open:
        return 0.0
    }
}

@ViewBuilder
func drawMultipleShapes(numberOfShapes: Int, shapePattern: CardType.ShapePattern, shapeColour: CardType.ShapeColor, shapeShading: CardType.ShapeShading) -> some View {
    if numberOfShapes == 1 {
        drawOneShape(shapePattern: shapePattern, shapeColour: shapeColour, shapeShading: shapeShading)
    } else if numberOfShapes == 2 {
        VStack {
            drawOneShape(shapePattern: shapePattern, shapeColour: shapeColour, shapeShading: shapeShading)
            drawOneShape(shapePattern: shapePattern, shapeColour: shapeColour, shapeShading: shapeShading)
        }
    } else {
        VStack {
            drawOneShape(shapePattern: shapePattern, shapeColour: shapeColour, shapeShading: shapeShading)
            drawOneShape(shapePattern: shapePattern, shapeColour: shapeColour, shapeShading: shapeShading)
            drawOneShape(shapePattern: shapePattern, shapeColour: shapeColour, shapeShading: shapeShading)
        }
    }
}
    
private struct DrawingConstants {
    static let cornerRadius: CGFloat = 10
    static let lineWidth: CGFloat = 3
}


struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x:rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x:rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x:rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        return SetGameView(game: game)
            .preferredColorScheme(.light)
    }
}
