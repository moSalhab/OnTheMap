//
//  LoginViewController.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/19/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: Any) {
        if (!email.text!.isEmpty && !password.text!.isEmpty) {
            let email = self.email.text
            let password = self.password.text
            API.login(email, password){(success, key, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        let alert = UIAlertController(title: "ERROR", message: "Request Failed", preferredStyle: .alert )
                        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    if !success {//invalid email or passworrd
                        let alert = UIAlertController(title: "Alert", message: "Password or Email address are incorrect", preferredStyle: .alert )
                        alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.goToMainPage()
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Password or Email address are empty", preferredStyle: .alert )
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let url = URL(string: "https://auth.udacity.com/sign-up"), UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:])
    }
    
    
    func goToMainPage() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let tabBarViewController = storyBoard.instantiateViewController(identifier: "tabBarViewController")
//        UIApplication.shared.keyWindow?.rootViewController = tabBarViewController
        present(tabBarViewController, animated: true, completion: nil)
    }

}
