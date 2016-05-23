//
//  AddURLViewController.swift
//  On the Map
//
//  Created by Peter Mäder on 12.05.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import UIKit
import MapKit

class AddURLViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var studentLocationMapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    
    var mediaURL = String()
    var studentLocation = CLLocation()
    var geocodeLocationSeachString = String()
    
    var user : StudentInformation {
        get{
            return (UIApplication.sharedApplication().delegate as! AppDelegate).user
        }
        set{
            (UIApplication.sharedApplication().delegate as! AppDelegate).user = newValue
        }
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        // MARK: set region for Map
       
        let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        let currentRegion = MKCoordinateRegion(center: studentLocation.coordinate , span: span)
        studentLocationMapView.setRegion(currentRegion, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = studentLocation.coordinate
        pin.title = "\(user.firstName) \(user.lastName)"
        pin.subtitle = "\(user.mediaURL)"
        
        studentLocationMapView.addAnnotation(pin)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Actions
    @IBAction func cancelBarButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        
        if let text = urlTextField.text {
            user.mediaURL = text
        }
        user.latitude = studentLocation.coordinate.latitude
        user.longitude = studentLocation.coordinate.longitude
        user.mapString = geocodeLocationSeachString
        
        OTMClient.sharedInstance().setStudentLocationAndUrl() { (success, error) in
            if success {
                performUIUpdatesOnMain{
                    let alert = UIAlertController(title: "Successful update !", message: error, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil )
                    
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                performUIUpdatesOnMain{
                    let alert = UIAlertController(title: "Update of Student Information failed", message: error, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func backToRoot() {
        performUIUpdatesOnMain{
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}

extension AddURLViewController {
    
    // MARK: Handle Keyboard shift to reach button
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddURLViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddURLViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        //Keyboard must shift view ONLY if bottom Text field is editing
        if urlTextField.editing {
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

