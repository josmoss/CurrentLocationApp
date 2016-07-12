//
//  ViewController.swift
//  CurrentLocationApp
//
//  Created by Joe Moss on 7/11/16.
//  Copyright © 2016 Iron Yard_Joe Moss. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager : CLLocationManager!
    
    var currentLatitude : Double = 0
    var currentLongitude : Double = 0
    var locationName : String = ""
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManagerFunction()
        self.loadDefaults()
        
    }
    
    func locationManagerFunction() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
            
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        self.addPin(self.currentLatitude, longitude: self.currentLongitude, titleString: self.locationName)
        
        let alert = UIAlertController(title: "Add Pin",
                                      message: "", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: {
                                        (action) in
                                        
                                        if let textField = alert.textFields?.first {
                                            
                                            if let name = textField.text {
                                                print(name)
                                                
                                        self.locationName = name
                                                
                                                self.saveDefaults()
                                                
                                                dispatch_async(dispatch_get_main_queue(), {
        
                                                    self.addPin(self.currentLatitude, longitude: self.currentLongitude, titleString: self.locationName)
                                                    
                                                })
                                                
                                            }
                                        }
                                        
        })
        
        // Add the action to the alert instance
        alert.addAction(saveAction)
        
        // Create an action called Cancel
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) {
                                            (action) in
        }
        
        alert.addAction(cancelAction)
        
        alert.addTextFieldWithConfigurationHandler {
            (textField) in
            
            textField.placeholder = "Location Name"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    func saveDefaults() {
        
        // SAVE THE VALUES
        
        NSUserDefaults.standardUserDefaults().setDouble(self.currentLatitude, forKey: kLATITUDE)
        NSUserDefaults.standardUserDefaults().setDouble(self.currentLongitude, forKey: kLONGITUDE)
        NSUserDefaults.standardUserDefaults().setObject(self.locationName, forKey: kLOCATIONNAME)
        NSUserDefaults.standardUserDefaults().synchronize()
   
    }
    
    func loadDefaults() {
        
        // LOAD THE VALUE
        let latitude = NSUserDefaults.standardUserDefaults().doubleForKey(kLATITUDE)
        
        let longitude = NSUserDefaults.standardUserDefaults().doubleForKey(kLONGITUDE)
        
        if let name = NSUserDefaults.standardUserDefaults().objectForKey(kLOCATIONNAME) as? String {
            
            self.locationName = name
            
            self.currentLatitude = latitude
            
            self.currentLongitude = longitude
            
            self.addPin(self.currentLatitude, longitude: self.currentLongitude, titleString: self.locationName)
            
            print(self.currentLatitude)
            
            print(self.currentLongitude)
            
            print(self.locationName)
            
        }

    }
    
    func addPin(latitude: Double, longitude: Double, titleString: String) {
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = titleString
        
        self.mapView.addAnnotation(annotation)
        
        self.centerMapOnLocation(location)
        
        self.saveDefaults()
    }
    
    func centerMapOnLocation(centerCoordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
        self.currentLatitude = newLocation.coordinate.latitude
    
        self.currentLongitude = newLocation.coordinate.latitude
  
    }

}