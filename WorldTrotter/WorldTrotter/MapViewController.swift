//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sajjad Patel on 2018-01-31.
//  Copyright © 2018 Sajjad Patel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{
    
    //Locally used variables
    let mapView                 = MKMapView()
    let authorizationStatus     = CLLocationManager.authorizationStatus()
    let span: MKCoordinateSpan  = MKCoordinateSpanMake(0.01, 0.01)
    
    var locationManager         = CLLocationManager()
    var annotationLocation      = 0
    
    //UI Variables
    var showCurrentLocation: UIButton!
    var showAnnotationLocation: UIButton!
    
    //Creates the MKAnnotationViews
    func setAnnotationLocation(_ annotationLocation:Int){
        switch annotationLocation{
        case 1:
            //Create annotation on where I was created
            let location: CLLocationCoordinate2D    = CLLocationCoordinate2DMake(37.335170, -122.013552)
            let region: MKCoordinateRegion          = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            
            let annotationCreator = MKPointAnnotation()
            annotationCreator.coordinate            = location
            annotationCreator.title                 = "Where I was Born"
            annotationCreator.subtitle              = "This is where Tim (my creator) made me"
            mapView.addAnnotation(annotationCreator)
            break
        case 2:
            //Create annotation for where I was revealed to the world
            let location: CLLocationCoordinate2D    = CLLocationCoordinate2DMake(37.331076, -122.007470)
            let region: MKCoordinateRegion          = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            
            let annotationRevealing = MKPointAnnotation()
            annotationRevealing.coordinate          = location
            annotationRevealing.title               = "This is where Tim revealed me to the world"
            annotationRevealing.subtitle            = "Steve Jobs Thearter"
            mapView.addAnnotation(annotationRevealing)
            break
        case 3:
            //Create annotation for where my enemy was created
            let location: CLLocationCoordinate2D    = CLLocationCoordinate2DMake(37.422296, -122.084103)
            let region: MKCoordinateRegion          = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
            
            let annotationEnemy = MKPointAnnotation()
            annotationEnemy.coordinate              = location
            annotationEnemy.title                   = "My Enemy"
            annotationEnemy.subtitle                = "The people who made my enemy... Android"
            mapView.addAnnotation(annotationEnemy)
            break
        default:
            break
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //Set the delegates and set up location services
        mapView.delegate                = self
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        configureLocationServices()
    }
    
    override func loadView(){
        
        //Set up view of this view controller
        showCurrentLocation = UIButton.init(type: UIButtonType.system)
        showAnnotationLocation = UIButton.init(type: UIButtonType.system)
        view = mapView

        //Create segmentedControl for the different types of mapViews
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //Add Constraints for segmentedControl
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        //Activate the constraints for segmentedControl
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        //Create showCurrentLocation UIButton
        showCurrentLocation.setTitle("Show Current Location", for: .normal)
        showCurrentLocation.bounds = CGRect(x: 0, y: 0, width: 500, height: 100)
        showCurrentLocation.center = CGPoint(x: 200, y: 650)
        showCurrentLocation.addTarget(self, action: #selector(showCurrentLocation(_:)), for: .touchUpInside)
        view.addSubview(showCurrentLocation)
        
        //Create showAnnotationLocation UIButton
        showAnnotationLocation.setTitle("Show Annotation Location", for: .normal)
        showAnnotationLocation.bounds = CGRect(x: 0, y: 0, width: 500, height: 100)
        showAnnotationLocation.center = CGPoint(x: 200, y: 550)
        showAnnotationLocation.addTarget(self, action: #selector(showAnnotionLocations(_:)), for: .touchUpInside)
        view.addSubview(showAnnotationLocation)
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
            break
        case 1:
            mapView.mapType = .hybrid
            break
        case 2:
            mapView.mapType = .satellite
            break
        case 3:
            mapView.showsUserLocation = true
            break
        default:
            break
        }
    }
    
    @objc func showCurrentLocation(_ showCurrentLocationButton: UIButton){
        centerMapOnUserLocation()
    }
    
    @objc func showAnnotionLocations(_ showCurrentLocationButton: UIButton){
        annotationLocation = (annotationLocation + 1) % 4
        
        if annotationLocation == 0{
            annotationLocation = 1
        }
        
        setAnnotationLocation(annotationLocation)
    }
}

extension MapViewController: MKMapViewDelegate{
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else{ return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate{
    /*Get users permission to get their location*/
    func configureLocationServices(){
        if authorizationStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else{
            return
        }
    }
    
    /*Find the location of the device and zoom the mapView to it*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = locations[0]
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations.coordinate.latitude, locations.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
}
