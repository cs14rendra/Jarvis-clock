//
//  APIManager.swift
//  My Jarvis
//
//  Created by surendra kumar on 3/4/17.
//  Copyright © 2017 weza. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol APIManagerDelegate {
    func weatherDatafromServer(weather : Weather)
}

class APIManager {
    static public var getManager = APIManager()
    var delegate : APIManagerDelegate?
    
    func loadWeatherData(url : String){
        Alamofire.request(url).responseJSON { (response) in
            self.parseData(data : response.data!)
            
        }
        }
    func parseData(data : Data){
        let result = JSON(data)
        let weather = Weather(temp: result["main"]["temp"].number,
                              pressure: result["main"]["pressure"].number,
                              humadity: result["main"]["humidity"].number,
                              temp_min: result["main"]["temp_min"].number,
                              temp_max: result["main"]["temp_max"].number,
                              wind_speed: result["wind"]["speed"].number,
                              wind_degree: result["wind"]["deg"].number,
                              cloud: result["clouds"]["all"].number,cityName:result["name"].string)
        
        print("CITYNAME : \(result["name"].string)")
        
        DispatchQueue.main.async {
            
           self.delegate?.weatherDatafromServer(weather: weather)
         
        }
        
        //print(result["main"]["temp"].number)
        
    }
}
