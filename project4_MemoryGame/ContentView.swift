//
//  ContentView.swift
//  project4_MemoryGame
//
//  Created by Andy Espinoza on 3/4/26.
//

import SwiftUI

struct ContentView: View {
    // All possible symbols
    private let allSymbols = [
        "globe", "star", "car", "football", "flame", "drop", "airplane",
        "flag", "bolt", "leaf", "moon", "sun.max", "heart", "gift",
        "paperplane", "bell"
    ]

    @State private var numberOfPairs: Int = 8
    @State private var cards: [Card] = []

    // Track selections
    @State private var firstSelectedIndex: Int? = nil
    @State private var isBusyResolvingPair = false

    // Grid layout
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 12) {
            header

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(cards.indices, id: \.self) { index in
                        cardView(card: cards[index])
                            .onTapGesture { tapCard(at: index) }
                            .allowsHitTesting(!cards[index].isMatched) // matched cards not tappable
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
            }
        }
        .onAppear { resetGame() }
    }

    private var header: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Memory Match")
                    .font(.title2).bold()
                Spacer()
                Button("Reset") {
                    resetGame()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            HStack {
                Text("Pairs:")
                Picker("Pairs", selection: $numberOfPairs) {
                    ForEach(2...min(10, allSymbols.count), id: \.self) { n in
                        Text("\(n)").tag(n)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            .onChange(of: numberOfPairs) { _, _ in
                resetGame()
            }
        }
    }

    // MARK: - Game Setup
    private func resetGame() {
        firstSelectedIndex = nil
        isBusyResolvingPair = false

        // Pick symbols, duplicate, shuffle
        let chosen = Array(allSymbols.shuffled().prefix(numberOfPairs))
        var newCards: [Card] = chosen.flatMap { sym in
            [Card(imageName: sym), Card(imageName: sym)]
        }
        newCards.shuffle()

        cards = newCards
    }

    // MARK: - Tap / Match Logic
    private func tapCard(at index: Int) {
        guard !isBusyResolvingPair else { return }
        guard !cards[index].isMatched else { return }
        guard !cards[index].isFaceUp else { return } // don't re-tap face-up card

        // Flip selected card up
        withAnimation(.spring) {
            cards[index].isFaceUp = true
        }

        // If no first card selected, store it
        if firstSelectedIndex == nil {
            firstSelectedIndex = index
            return
        }

        // Otherwise this is the second card
        let firstIndex = firstSelectedIndex!
        firstSelectedIndex = nil
        isBusyResolvingPair = true

        // Check match
        let isMatch = cards[firstIndex].imageName == cards[index].imageName

        if isMatch {
            // Mark both matched (disappear)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.easeInOut) {
                    cards[firstIndex].isMatched = true
                    cards[index].isMatched = true
                }
                isBusyResolvingPair = false
            }
        } else {
            // Flip both back down after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.spring) {
                    cards[firstIndex].isFaceUp = false
                    cards[index].isFaceUp = false
                }
                isBusyResolvingPair = false
            }
        }
    }
}

#Preview {
    ContentView()
}
