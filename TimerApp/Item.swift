//
//  Item.swift
//  TimerApp
//
//  Created by Norris Wise Jr on 10/13/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
