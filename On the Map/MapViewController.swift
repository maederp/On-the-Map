//
//  MapViewController.swift
//  On the Map
//
//  Created by Peter Mäder on 08.05.16.
//  Copyright © 2016 Peter Mäder. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewController: UIViewController {
    
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
    
    @IBOutlet weak var mapView: MKMapView!
    
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
        
        //Clean Map from previous annotations
        mapView.removeAnnotations(self.mapView.annotations)
        
        // MARK: Load Student Information Data (max 100)
        loadStudentLocations()
        mapView.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: set region for Map (Default: Bern Bundesplatz Switzerland
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 46.9470, longitude: 7.4439)
        
        if let longitude = students.first?.longitude,
            let latitude = students.first?.latitude {
            center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 6.0, longitudeDelta: 6.0)
        let currentRegion = MKCoordinateRegion(center: center , span: span)
        mapView.setRegion(currentRegion, animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    
    }
    
    private func loadStudentLocations() {
        OTMClient.sharedInstance().getStudentLocations() { (students, errorString ) in
            performUIUpdatesOnMain{
                if let students = students{
                    self.students = students
                    self.setStudentPins()
                }else{
                    let alert = UIAlertController(title: "Loading Student Information", message: errorString, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func setStudentPins() {

        for student in students{
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: Double(student.latitude), longitude: Double(student.longitude))
            pin.title = "\(student.firstName) \(student.lastName)"
            pin.subtitle = "\(student.mediaURL)"
            
            //pins.append(pin)
            mapView.addAnnotation(pin)
            mapView.viewForAnnotation(pin)
        }
        
        //mapView.addAnnotations(pins)
        mapView.reloadInputViews()
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
        mapView.removeAnnotations(self.mapView.annotations)
        loadStudentLocations()
    }
}

extension MapViewController: MKMapViewDelegate{
    
    // MARK: Non standard pin annotation to achieve callout image view
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let customPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "studentPinView")
        
        customPinView.pinTintColor = MKPinAnnotationView.redPinColor()
        customPinView.animatesDrop = true
        customPinView.canShowCallout = true
        
        let rightButton = UIButton(type: .DetailDisclosure)
        rightButton.addTarget(nil, action: nil, forControlEvents: .TouchUpInside)
        customPinView.rightCalloutAccessoryView = rightButton
        
        return customPinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        func alert(error: String){
            let alert = UIAlertController(title: "Open Safari failed", message: error, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        guard let annotation : MKAnnotation = view.annotation else{
            return
        }
        
        if let urlString : String = annotation.subtitle!  {
            let url = NSURL(string: urlString)
            
            let app = UIApplication.sharedApplication()
            if !app.openURL(url!){
                alert("Student-URL invalid: \(url!.absoluteString)")
            }
        }else{
            alert("No Student-URLfound")
        }
    }
}
