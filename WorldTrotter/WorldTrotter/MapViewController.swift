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
    
    //Create map view
    let mapView = MKMapView()
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
    
    var showCurrentLocation: UIButton!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        configureLocationServices()
    }
    
    override func loadView(){
        
        //Set up view of this view controller
        showCurrentLocation = UIButton.init(type: UIButtonType.system)
        view = mapView

        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //Create Show User Location UIButton
        showCurrentLocation.setTitle("Show Current Location", for: .normal)
        showCurrentLocation.bounds = CGRect(x: 0, y: 0, width: 500, height: 100)
        showCurrentLocation.center = CGPoint(x: 200, y: 650)
        showCurrentLocation.addTarget(self, action: #selector(showCurrentLocation(_:)), for: .touchUpInside)
        view.addSubview(showCurrentLocation)
        
        //Add Constraints for segmentedControl
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        //Activate the constraints
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
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
}

extension MapViewController: MKMapViewDelegate{
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else{ return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate{
    
    func configureLocationServices(){
        if authorizationStatus == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else{
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = locations[0]
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations.coordinate.latitude, locations.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
    }
}
