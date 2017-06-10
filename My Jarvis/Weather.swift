//
//  Weather.swift
//  My Jarvis
//
//  Created by surendra kumar on 3/4/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation

class Weather{

    var temp : NSNumber?
    var pressure : NSNumber?
    var humadity : NSNumber?
    var temp_min : NSNumber?
    var temp_max : NSNumber?
    var wind_speed : NSNumber?
    var wind_degree : NSNumber?
    var cloud : NSNumber?
    var cityName : String?
    
    public init(temp : NSNumber?, pressure : NSNumber?, humadity : NSNumber?, temp_min : NSNumber?, temp_max : NSNumber?, wind_speed : NSNumber?, wind_degree : NSNumber?, cloud : NSNumber?,cityName : String?) {
        self.temp  = temp 
        self.pressure  = pressure 
        self.humadity  = humadity 
        self.temp_min  = temp_min 
        self.temp_max  = temp_max 
        self.wind_speed  = wind_speed 
        self.wind_degree  = wind_degree 
        self.cloud  = cloud
        self.cityName = cityName
    }
  
//    if let t = temp{
//        self.temp = t
//    }
//    else{
//    self.temp = 0
//    }
//    if let t = pressure{
//        self.pressure = t
//        
//    }
//    else{
//    self.pressure = 0
//    }
//    if let t = humadity{
//        self.humadity = t
//    }
//    else{
//    self.humadity = 0
//    }
//    if let t = temp_min{
//        self.temp_min = t
//    }
//    else{
//    self.temp_min = 0
//    }
//    if let t = temp_max{
//        self.temp_max = t
//    }
//    else{
//    self.temp_max = 0
//    }
//    if let t = wind_speed{
//        self.wind_speed = t
//    }
//    else{
//    self.wind_speed = 0
//    }
//    if let t = wind_degree{
//        self.wind_degree = t
//    }
//    else{
//    self.wind_degree = 0
//    }
//    if let t = cloud{
//        self.cloud = t
//    }
//    else{
//    self.cloud = 0
//    }
//
//    
}
