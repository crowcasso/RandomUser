//
//  RestApiManager.swift
//  RandomUser
//
//  Created by Joel Hollingsworth on 11/3/17.
//  Copyright © 2017 Joel Hollingsworth. All rights reserved.
//

import Foundation

class RestApiManager {
    
    // singleton pattern
    static let singleton = RestApiManager()
    
    //: GET Request
    func makeHTTPGetRequest(theURL: String, resultsHandler: @escaping ((JSON) -> Void)) {
        
        // setup the connection to the web server
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: theURL)!
        
        // in a new thread, ask the server for data
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                // no error, do we have data?
                if let jsonData = data {
                    // package up the String as a JSON object
                    let json = try! JSON(data: jsonData)
                    
                    // call the results handler to deal with the JSON
                    resultsHandler(json)
                }
            }
        })
        task.resume()
    }
}
