//
//  DateExtension.swift
//  Tracker
//
//  Created by Roaa on 2/2/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.string(from: self)
    }
}
