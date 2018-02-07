//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Sajjad Patel on 2018-01-31.
//  Copyright © 2018 Sajjad Patel. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController{
    
    //Create map view
    let mapView = MKMapView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
    override func loadView(){
        
        //Set up as *the* view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["standard", "Hybrid", "Satillite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
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
        default:
            break
        }
    }
}
