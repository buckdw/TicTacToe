//
//  ContentView.swift
//  TicTac
//
//  Created by Diederick de Buck on 30/08/2021.
//

import SwiftUI
import AVFoundation


struct ContentView: View {
    var columns: [GridItem] = [GridItem(.flexible())
                               , GridItem(.flexible())
                               , GridItem(.flexible())
                                ]
    @State private var moves: [Move?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
    @State private var disableTap: Bool = false
    
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
                        ForEach(0..<9) { i in
                            ZStack {
                                let diameter:CGFloat = (geo.size.width / 3) - 15
                                Circle()
                                    .frame(width: diameter, height: diameter)
                                    .opacity(0.8)
                                    .foregroundColor(Color.white)
                                Image(systemName:moves[i]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: diameter * 0.5, height: diameter * 0.5)
                                    
                            }
                            .onTapGesture {
                                if isFree(moves: moves, index: i) {
                                    moves[i] = Move(player: .human, boardIndex: i)
                                    disableTap = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        let computerIndex = computeComputerIndex(moves: moves)
                                        moves[computerIndex] = Move(player: .computer
                                                        , boardIndex: computerIndex)
                                        disableTap = false
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .disabled(disableTap)
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
