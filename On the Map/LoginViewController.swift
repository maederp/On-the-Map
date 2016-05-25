//
//  LoginViewController.swift
//  On the Map
//
//  Created by Peter Mäder on 27.04.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    let userData = UserData.sharedInstance
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureBackground()
        
        loginEmailTextField.text = "User Name"
        loginPasswordTextField.text = ""
    }
    
    // MARK: Actions
    @IBAction func LoginButtonPressed(sender: AnyObject) {
        
        let userName = getUserName()
        let password = getPassword()
        
        OTMClient.sharedInstance().authenticateWithCredentials(userName, password: password) { (success,  errorString) in
            performUIUpdatesOnMain {
                if success {
                    OTMClient.sharedInstance().getUserInformation(self.userData.user.uniquekey) { (success, userInfo, errorString) in
                        if errorString != nil{
                            print(errorString)
                        }
                    }
                    self.completeLogin()
                } else {
                    self.showLoginFailureAlert(errorString!)
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("OTMNavigationController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func showLoginFailureAlert(failure: String){
        let alert = UIAlertController(title: "Login", message: "Login not successful: \(failure)", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(defaultAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func displayError(errorString: String?) {
        if let errorString = errorString {
            debugTextLabel.text = errorString
        }
    }
    
    // MARK: GET Textfield Data
    private func getUserName() -> String {
        guard let userName = loginEmailTextField.text else{
            return ""
        }
        return userName
    }
    
    private func getPassword() -> String {
        guard let password = loginPasswordTextField.text else{
            return ""
        }
        return password
    }
    
    private func configureBackground() {
        let backgroundGradient = CAGradientLayer()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        view.layer.insertSublayer(backgroundGradient, atIndex: 0)
    }
}