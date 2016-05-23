//
//  ListViewController.swift
//  On the Map
//
//  Created by Peter Mäder on 08.05.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import UIKit
import Foundation

class ListViewController: UIViewController {
    
    // MARK: Properties
    // Students Array stored at central App Delegate Location
    var students: [StudentInformation]{
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).students
        }
        set {
            (UIApplication.sharedApplication().delegate as! AppDelegate).students = newValue
        }
    }
    
    @IBOutlet var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: configure Navigation Bar
        parentViewController!.navigationItem.title = "On The Map"
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(self.logout))
        parentViewController!.navigationItem.setLeftBarButtonItem(logoutBarButtonItem, animated: true)
        
        let pinImage = UIImage(imageLiteral: "pin")
        let pinBarButtonItem = UIBarButtonItem(image: pinImage , style: .Done, target: self, action: #selector(self.addPin))
        let redoBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(self.reload))
        
        parentViewController!.navigationItem.setRightBarButtonItems([redoBarButtonItem, pinBarButtonItem], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations()
    }
    
    private func loadStudentLocations() {
        OTMClient.sharedInstance().getStudentLocations() { (students, errorString ) in
            if let students = students{
                self.students = students
                performUIUpdatesOnMain{
                    self.studentsTableView.reloadData()
                }
            }else{
                let alert = UIAlertController(title: "Loading Student Information", message: errorString, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func logout(){
        OTMClient.sharedInstance().logoutOfSession()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addPin(){
        let controller = storyboard!.instantiateViewControllerWithIdentifier("AddLocationViewController")
        controller.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func reload(){
        loadStudentLocations()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentInformationCell"
        let student = students[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        
        func alert(error: String){
            let alert = UIAlertController(title: "Open Safari failed", message: error, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if let url = NSURL(string: student.mediaURL){
            let app = UIApplication.sharedApplication()
            print(url.absoluteString)
            if !app.openURL(url){
                alert("Student-URL invalid: \(url.absoluteString)")
            }
            
        }else{
            alert("No Student-URLfound")
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}