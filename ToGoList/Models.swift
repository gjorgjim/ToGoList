//
//  Models.swift
//  ToGoList
//
//  Created by Gjorgji Markov on 6/16/18.
//  Copyright © 2018 Gjorgji Markov. All rights reserved.
//

import Foundation

class Place {
    var title: String
    var latitude: Float
    var longitude: Float
    
    init(title: String, latitude: Float, longitude: Float) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toNSDictionary() -> NSDictionary {
        let place: NSDictionary = [
            "title": self.title,
            "latitude": self.latitude,
            "longitude": self.longitude]
        
        return place
    }
}

class List {
    var name: String
    var description: String
    var place: Place
    
    init(name: String, description: String, place: Place) {
        self.name = name
        self.description = description
        self.place = place
    }
    
    func toNSDictionary() -> NSDictionary {
        let list: NSDictionary = [
            "name": self.name,
            "description": self.description,
            "place": self.place.title]
        
        return list
    }
}
