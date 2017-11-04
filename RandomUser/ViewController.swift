//
//  ViewController.swift
//  RandomUser
//
//  Created by Joel Hollingsworth on 11/3/17.
//  Copyright © 2017 Joel Hollingsworth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //: Outlets to UI
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var userBirthDateLabel: UILabel!
    @IBOutlet weak var userPhoneNumberLabel: UILabel!
    
    // the API URL
    let baseURL = "https://api.randomuser.me/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update the UI with a random user
        getOneRandomUser()
    }
    
    //: Button Action
    @IBAction func getNewRandomUser(_ sender: Any) {
        // update the UI with a random user
        getOneRandomUser()
    }
    
    //: Main Code
    
    // Request/receive/parse a random user
    func getOneRandomUser() {
        RestApiManager.singleton.makeHTTPGetRequest(theURL: baseURL, resultsHandler: self.myResultsHandler)
    }
    
    // Called when a response has arrived
    func myResultsHandler(json: JSON) {
        
        // get access to the "results" array
        if let results = json["results"].array {
            
            // look through the array
            for entry in results {
                
                // we want to update the UI but can't do that directly
                DispatchQueue.main.async() {
                    // update the labels
                    self.userNameLabel.text = entry["name"]["first"].stringValue + " " + entry["name"]["last"].stringValue
                    self.userEmailLabel.text = entry["email"].stringValue
                    self.userAddressLabel.text = entry["location"]["street"].stringValue
                    self.userBirthDateLabel.text = entry["dob"].stringValue
                    self.userPhoneNumberLabel.text = entry["phone"].stringValue
                    
                    // get the image at the URL and update the photo
                    if let url = URL(string: entry["picture"]["large"].stringValue) {
                        do {
                            let data = try Data(contentsOf: url)
                            self.userImageView.image = UIImage(data: data)
                        } catch {
                            print("no image")
                        }
                    }
                }
            }
        }
    }
}
