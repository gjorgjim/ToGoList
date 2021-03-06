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
    var latitude: Double
    var longitude: Double
    
    init(title: String, latitude: Double, longitude: Double) {
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
    var inNotificationCenter: Bool
    var done: Bool
    
    init(name: String, description: String, place: Place, inNotificationCenter: Bool, done: Bool) {
        self.name = name
        self.description = description
        self.place = place
        self.inNotificationCenter = inNotificationCenter
        self.done = done
    }
    
    func toNSDictionary() -> NSDictionary {
        let list: NSDictionary = [
            "name": self.name,
            "description": self.description,
            "place": self.place.title,
            "inNotificationCenter": self.inNotificationCenter,
            "done": self.done]
        
        return list
    }
}
