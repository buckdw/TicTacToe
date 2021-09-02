//
//  AlertView.swift
//  TicTac
//
//  Created by Diederick de Buck on 02/09/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}
