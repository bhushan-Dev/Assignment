//
//  Constants.swift
//  RideAppNetwinAssignment
//
//  Created by Bhushan Udawant on 16/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import UIKit

struct Constants {
    static let googleMapAPIKey = "AIzaSyDU-WcOUKOHOobPjOUb8iN-XhrTch_yk-A"

    static let fullViewYPosition: CGFloat = 100
    static let partialViewYPostion: CGFloat = 300

    // MARK: - CreateRideViewController -

    // Story board identifiers
    static let CreateRideBottomSheetViewController = "CreateRideBottomSheetViewController"
    

    // MARK: - CreateRideBottomSheetViewController Constants -

    static let dateFormat = "EEE, MMM d, YYYY"
    static let timeFormat = "h:mm a"

    // Text
    static let selectVehicleTypeTitle = "Select Vehicle Type"
    static let twoWheelerTypeText = "Two Wheeler"
    static let fourWheelerTypeText = "Four Wheeler"
    static let otherTypeText = "Other"
    static let cancelText = "Cancel"
    static let locationTextViewPlaceholder = "Enter location"

    // Images
    static let twoWheelerImage = "twoWheeler"
    static let fourWheelerImage = "fourWheeler"
    static let otherWheelerImage = "otherWheeler"
    static let downArrowImage = "downArrow"

    // Numbers
    static let twoWheelerSeatCount: Double = 1
    static let fourWheelerSeatCount: Double = 4
    static let otherWheelerSeatCount: Double = 10

    // Regex
    static let vehicleNumberRegex = "^[A-Z]{2}[ -][0-9]{1,2}(?: [A-Z])?(?: [A-Z]*)? [0-9]{4}$"

    // Alert
    static let alertTileValidationError = "Validation Error"
    static let alertMessageValidationError = "Please enter valid vehicle number."
}
