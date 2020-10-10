//
//  LoginViewController.swift
//  Twitter
//
//  Created by Sambhav Jain on 10/9/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
   /*
    @IBAction func onLoginButton(_ sender: Any) {
     
   
 */
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true  {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            UserDefaults.standard.set(false, forKey: "userLoggedIn")
        }
    }
    
    
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: myUrl, success: {
            // anytime anyone logs in this is going to create a variables called "userLoggedIn = true"
            // The next time the user opens the app, then we will check if the user was logged in..
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Could not login!")
        })
     }
    }
    
    


