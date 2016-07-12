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
    
    var currentLatitude : Float = 0.0
    var currentLongitude : Float = 0.0
    var locationName : String = ""
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    
    let status = CLLocationManager.authorizationStatus()
        
    if status == .NotDetermined || status == .Denied || status == .AuthorizedWhenInUse {
    
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType(rawValue: 0)!
        mapView.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        // LOAD THE VALUE
//        self.currentLatitude = NSUserDefaults.standardUserDefaults().floatForKey(kLATITUDE)
//        
//        self.currentLongitude = NSUserDefaults.standardUserDefaults().floatForKey(kLONGITUDE)

    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        self.addPin(40.546655, longitude: -111.954564, titleString: "Home Address", subtitleString: "Street Name")
        
        let latitude = 40.546655
        
        let longitude = -111.954564
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        self.centerMapOnLocation(location)
        
        let alert = UIAlertController(title: "Add Pin",
                                      message: "", preferredStyle: .Alert)
        
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: {
                                        (action) in
                                        

                                        
//                                        if let textField = alert.textFields?.first {
//                                            
//                                            if let name = textField.text {
//                                                print(name)
//                                                self.currentCity?.name = name
//                                            }
//                                        }
                                        
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
        
        // SAVE THE VALUES
    
//        NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: kLATITUDE)
//        NSUserDefaults.standardUserDefaults().setFloat(sender.value, forKey: kLONGITUDE)
//        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func addPin(latitude: Double, longitude: Double, titleString: String, subtitleString: String) {
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = "Home Address"
        annotation.subtitle = "South Jordan"
        
        mapView.addAnnotation(annotation)
        
        centerMapOnLocation(location)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation:MKAnnotation) -> MKAnnotationView?
//    {
//        if annotation.isKindOfClass(MKPointAnnotation) {
//            
//            // 1. Create identifier
//            let identifier = "MapPin"
//            
//            let annotationView = MKAnnotationView(annotation: annotation,reuseIdentifier: identifier)
//            
//            annotationView.canShowCallout = true
//            
//            let imageView = UIImageView(frame: CGRectMake(0,0,44,44))
//            imageView.image = UIImage(named: "map")
//            annotationView.image = imageView.image
//            
//            return annotationView
//        }
//        
//        return nil
//    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        print("present location : \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
    }

}