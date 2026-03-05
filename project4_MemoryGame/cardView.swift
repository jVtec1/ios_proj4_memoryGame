//
//  cardView.swift
//  project4_MemoryGame
//
//  Created by Andy Espinoza on 3/4/26.
//

import SwiftUI

struct Card: Equatable, Identifiable {
    let id = UUID()
    let imageName: String
    
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    
}

struct cardView: View {
    
    let card: Card
    
    var body: some View {
        
        ZStack {
            if card.isMatched {
                // Disappear when matched
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.clear)
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(card.isFaceUp ? Color.blue.gradient : Color.indigo.gradient)
                    .shadow(color: .black.opacity(0.25), radius: 3, x: -1, y: 1)

                if card.isFaceUp {
                    Image(systemName: card.imageName)
                        .resizable()
                        .scaledToFit()
                        .padding(18)
                        .foregroundStyle(.white)
                }
            }
        }
        .aspectRatio(2/3, contentMode: .fit) 
        .opacity(card.isMatched ? 0 : 1)
        .animation(.default, value: card.isMatched)
    }
}

#Preview {
    cardView(card: Card(imageName: "globe"))
}
