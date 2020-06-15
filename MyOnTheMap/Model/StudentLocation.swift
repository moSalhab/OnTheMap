//
//  StudentLocation.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/23/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import Foundation
import UIKit

struct StudentLocation: Codable {

    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
}

extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}
