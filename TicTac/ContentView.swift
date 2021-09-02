//
//  ContentView.swift
//  TicTac
//
//  Created by Diederick de Buck on 30/08/2021.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    var columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var moves: [Move?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    @State private var disableTap: Bool = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        ZStack {
            BackgroundView()
            GeometryReader { geo in
                VStack {
                    Text("Tic Tac Toe")
                        .foregroundColor(Color.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 32, weight: .medium, design: .default))
                    Spacer()
                    LazyVGrid(columns: columns) {
                        ForEach(0..<9) { playerIndex in
                            ZStack {
                                let diameter:CGFloat = (geo.size.width / 3) - 15
                                Circle()
                                    .frame(width: diameter, height: diameter)
                                    .opacity(0.8)
                                    .foregroundColor(Color.white)
                                Image(systemName:moves[playerIndex]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: diameter * 0.5, height: diameter * 0.5)
                                
                            }
                            .onTapGesture {
                                if isFree(moves: moves, index: playerIndex) {
                                    moves[playerIndex] = Move(player: .human, boardIndex: playerIndex)
                                    if computeWin(moves: moves, player: .human) {
                                        alertItem = AlertItem(title: Text("You beat the Klute")
                                                              , message: Text("You win 1.000.000 credits!")
                                                              , buttonTitle: Text("hell yeah")
                                        )
                                        return
                                    }
                                    if computeDraw(moves: moves) {
                                        alertItem = AlertItem(title: Text("The Klute offers a draw")
                                                              , message: Text("Go home")
                                                              , buttonTitle: Text("hell yeah")
                                        )
                                        return
                                    }
                                    disableTap = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        let computerIndex = computeComputerIndex(moves: moves)
                                        moves[computerIndex] = Move(player: .computer, boardIndex: computerIndex)
                                        disableTap = false
                                        if computeWin(moves: moves, player: .computer) {
                                            alertItem = AlertItem(title: Text("The Klute beats you")
                                                                  , message: Text("You'll die!")
                                                                  , buttonTitle: Text("hell yeah")
                                            )
                                            return
                                        }
                                        if computeDraw(moves: moves) {
                                            alertItem = AlertItem(title: Text("The Klute offers a draw")
                                                                  , message: Text("Go home")
                                                                  , buttonTitle: Text("hell yeah")
                                            )
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .disabled(disableTap)
                .padding()
                .alert(item: $alertItem, content: { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: { resetGame() })
                    )
                })
            }
        }
    }
    
    func isFree(moves: [Move?], index: Int) -> Bool {
        return (moves[index] == nil)
    }
    
    
    func computeComputerIndex(moves: [Move?]) -> Int {
        var computerIndex = Int.random(in: 0..<9)
        while (!isFree(moves: moves, index: computerIndex)) {
            computerIndex = Int.random(in: 0..<9)
        }
        return computerIndex
    }
    
    func computeWin(moves: [Move?], player: Player) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        return false;
    }
    
    func computeDraw(moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BackgroundImageView: View {
    
    var body: some View {
        Image("background")
            .ignoresSafeArea()
    }
}


struct BackgroundView: View {
    
    var body: some View {
        let lightGreen = Color("lightGreen")
        let darkGreen = Color("darkGreen")
        let gradient: [Color] = [darkGreen, lightGreen]
        LinearGradient(gradient: Gradient(colors:gradient),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}


enum Player {
    case human, computer
}


struct Move {
    let player: Player
    let boardIndex: Int
    var indicator:String {
        return player == .human ? "xmark" : "circle"
    }
}
