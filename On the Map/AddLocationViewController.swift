//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Peter Mäder on 12.05.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    var studentLocation = CLLocation()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    @IBAction func findLocationOnMap(sender: UIButton) {
        
        //start animating the activity view
        performUIUpdatesOnMain{
            self.activityView.startAnimating()
            self.view.bringSubviewToFront(self.activityView)
        }
        
        let geoCoder = CLGeocoder()
        
        guard let locationSearchString = locationTextField.text else{
            let alert = UIAlertController(title: "Error", message: "Please enter Location to search", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil )
            
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        geoCoder.geocodeAddressString(locationSearchString, completionHandler: { (placemarks, error) in
            performUIUpdatesOnMain {
                if let pms = placemarks{
                    if let placemark = pms.first{
                        self.activityView.stopAnimating()
                        self.studentLocation = placemark.location!
                        self.performSegueWithIdentifier("addURL", sender: self)
                    } else{
                        print(error)
                        self.activityView.stopAnimating()
                    }
                } else {
                    print(error)
                    self.activityView.stopAnimating()
                }
            }
        })
        
    }
    
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Helper Functions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addURL" {
            if let destinationVC = segue.destinationViewController as? AddURLViewController,
            let locationSearchString = locationTextField.text {
                destinationVC.studentLocation = studentLocation
                destinationVC.geocodeLocationSeachString = locationSearchString
            }
        }
    }
}

extension AddLocationViewController {
    
    // MARK: Handle Keyboard shift to reach button

    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddLocationViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddLocationViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        //Keyboard must shift view ONLY if bottom Text field is editing
        if locationTextField.editing {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        //Shift entire view back to bottom after Keyboard hide
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
}