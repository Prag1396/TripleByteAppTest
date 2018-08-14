//
//  DataPetModel.swift
//  TripleByteApp
//
//  Created by Pragun Sharma on 8/13/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import Foundation

//
//  CurrentPetData.swift
//  PetFinderApp
//
//  Created by Pragun Sharma on 7/24/18.
//  Copyright © 2018 Pragun Sharma. All rights reserved.
//

import UIKit
import Alamofire

class DataPetModel {
    
    private var _description: String!
    private var _ImageURL: String!
    private var _title: String!
    private var _timeStamp: String!

    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var imageURL: String {
        if _ImageURL == nil {
            _ImageURL = ""
        }
        return _ImageURL
    }

    var title: String {
        if _title == nil {
            _title = ""
        }
        return _title
    }
    
    var timestamp: String {
        if _timeStamp == nil {
            _timeStamp = ""
        }
        return _timeStamp
    }
    
    
    init(petdict: Dictionary<String, AnyObject>) {
        
        if let description = petdict["description"] as? String {
            self._description = description
        }
        
        if let title = petdict["title"] as? String {
            self._title = title
        }
        
        if let imageURL = petdict["image_url"] as? String {
            self._ImageURL = imageURL
        }
        
        if let timeStamp = petdict["timestamp"] as? String {
            self._timeStamp = timeStamp
        }
        
    }
}
