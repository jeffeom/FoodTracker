//
//  LogInViewController.swift
//  FoodTracker
//
//  Created by Jeff Eom on 2016-08-01.
//  Copyright © 2016 Jeff Eom. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var postData: NSDictionary = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func logIn(){
        
        postData = [
            "username": self.usernameField.text!,
            "password": self.passwordField.text!
        ]
        
        guard let postJSON = try? NSJSONSerialization.dataWithJSONObject(postData, options: [])else{
            print("Could not serialize json")
            
            return
        }
        
        let req = NSMutableURLRequest(URL: NSURL(string: "http://159.203.243.24:8000/login")!)
        
        req.HTTPBody = postJSON
        req.HTTPMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { (data, resp, err) in
            
            guard let data = data else {
                print("no data returned from server \(err)")
                return
            }
            
            guard let resp = resp as? NSHTTPURLResponse else {
                print("no response returned from server \(err)")
                return
            }
            
            guard let rawJson = try? NSJSONSerialization.JSONObjectWithData(data, options: []) else {
                print("data returned is not json, or not valid")
                return
            }
            
            guard resp.statusCode == 200 else {
                // handle error
                print("an error occurred \(rawJson["error"])")
                return
            }
            
            
            let fetchedUser = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! NSDictionary
            let fetchedInfo = fetchedUser["user"] as! NSDictionary
            
            let userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            
            userDefaults.setValue(fetchedInfo["token"], forKey: "token")
            
            userDefaults.synchronize()
            
            
        }
        
        task.resume()
        
    }
    
    @IBAction func pressedLogIn(sender: AnyObject) {
        
        logIn()
        self.navigationController!.popViewControllerAnimated(true)

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}