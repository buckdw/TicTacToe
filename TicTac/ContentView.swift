//
//  ContentView.swift
//  TicTac
//
//  Created by Diederick de Buck on 30/08/2021.
//

import SwiftUI

var columns: [GridItem] = [GridItem(.flexible())
                           , GridItem(.flexible())
                           , GridItem(.flexible())
                            ]

struct ContentView: View {
    var columns: [GridItem] = [GridItem(.flexible())
                               , GridItem(.flexible())
                               , GridItem(.flexible())
                                ]
    var moves:[Move] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
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
                                Image(systemName:"xmark")
                                    .resizable()
                                    .frame(width: diameter * 0.5, height: diameter * 0.5)
                                    
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
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
}
