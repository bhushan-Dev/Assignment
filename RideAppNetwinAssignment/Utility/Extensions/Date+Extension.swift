//
//  Date+Extension.swift
//  RideAppNetwinAssignment
//
//  Created by Bhushan Udawant on 16/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import Foundation

extension Date {

    /**
     *  Converts date to string with the provided format
     *
     *  - Parameter format: Format for date in which we expect the date in string form
     *
     *  - Returns: Formatted date in string form
     */
    func dateToString(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}
