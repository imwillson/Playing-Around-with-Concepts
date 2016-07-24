//
//  callbackHell.swift
//  test-API
//
//  Created by Willson Li on 7/24/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

//
//  CoordinateConvert.swift
//  test-API
//
//  Created by Willson Li on 7/19/16.
//  Copyright © 2016 Willson Li. All rights reserved.
//

import Foundation
import SwiftyJSON
import GoogleMaps

class AddressToCoordinatesConverter {
    var longitude: Double
    var latitude: Double
    var address = ""
    var addressLink = ""
    //var coordinateTuple: (Double,Double)
    
    init(longitudeY: Double, latitudeX: Double, addressString: String, addressLink: String){
        self.longitude = longitudeY
        self.latitude = latitudeX
        self.address = addressString
        self.addressLink = addressLink
    }
    
    convenience init(addressString: String) {
        self.init(longitudeY: 0.0, latitudeX: 0.0, addressString: addressString, addressLink: "")
    }
    
    
    func convertAddressToLinkFormat() {
        let addressArr = self.address.componentsSeparatedByString(" ")
        let addressLinkString = addressArr.joinWithSeparator("+")
        
        self.addressLink = addressLinkString
        
    }
    //callback is the closure
    // paramters.... returns a void
    
    // takes parametesr
    
    func getCoordinatesAPI(callback: (coordinates: (Double, Double)) -> Void ) {
        
        let headers =
            [
                "cache-control": "no-cache",
                "postman-token": "b3a0a6b1-0bca-1d24-2cce-925aefc1d94b"
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(self.addressLink)&key=AIzaSyC-xkDe7GaH-4Q9byIcAw-HEgkr_AEOFUk")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession() //sharedsession, returns a singleton object, shared has constraints
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil)
            {
                print(error)
            }
            else
            {
                let httpResponse = response as? NSHTTPURLResponse
                //print(httpResponse)
                
                let json = JSON(data: data!)
                
                //print(json)
                
                
                let latLongData = ((json["results"][0]["geometry"]["location"]["lat"].doubleValue), (json["results"][0]["geometry"]["location"]["lng"].doubleValue))
                
                callback(coordinates: latLongData)
                //closure that calls back the longitude latitude data
                
            }
            
            
        })
        
        dataTask.resume()
        
        
        //print(coordinates)
        //return coordinates
    }
    
    
    
    
    
    //    func convertAddressToLinkFormat(address: String) -> String {
    //        let addressArr = address.componentsSeparatedByString(" ")
    //        let addressLinkString = addressArr.joinWithSeparator("+")
    //
    //        return addressLinkString
    //    }
    //    
    
    
}