//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Toph Matta on 12/22/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    
    lazy var locationManager = CLLocationManager()
    
    
    var lat: CLLocationDegrees? = nil
    var long: CLLocationDegrees? = nil
    
    var location: CLLocationCoordinate2D?
    
    let latDelta: CLLocationDegrees = 0.1
    let longDelta: CLLocationDegrees = 0.1
    
    let hometownCoordinates = CLLocationCoordinate2DMake(28.707718, -81.351971)
    let residenceCoordinates = CLLocationCoordinate2DMake(30.304647, -97.744170)
    let goodTraveledPlaceCoordinates = CLLocationCoordinate2DMake(37.788351, -122.426622)
    
    var mapCounter: Int?
    

    override func loadView() {
        
        // Create a map view instance
        mapView = MKMapView()
        
        // Set it as the view of this view controller
        view = mapView
        
        
        
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString( "Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(segmentedControl)
        
        let margins = view.layoutMarginsGuide
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
    
        
        addLocationButton()
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        setToHometownLoc()
        
        let dropPinHome = MKPointAnnotation()
        dropPinHome.coordinate = hometownCoordinates
        dropPinHome.title = "Hometown"
        
        let dropPinResidence = MKPointAnnotation()
        dropPinResidence.coordinate = residenceCoordinates
        dropPinResidence.title = "Residence"
        
        let dropPinGoodTraveledPlace = MKPointAnnotation()
        dropPinGoodTraveledPlace.coordinate = goodTraveledPlaceCoordinates
        dropPinGoodTraveledPlace.title = "I traveled here and I liked it"
        
        mapView.addAnnotations([dropPinHome, dropPinResidence, dropPinGoodTraveledPlace])
        
        
        
        mapCounter = 1
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        checkCoreLocationPermission()
        
    }
    
    func setToHometownLoc() {
        
        let span = MKCoordinateSpanMake(latDelta, longDelta)
        
        location = hometownCoordinates
        
        let region = MKCoordinateRegionMake(location!, span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        if annotation is MKUserLocation {
//            
//            return nil
//        }
//        
//        let reuseId = "pin"
//        
//        
//            
//            
//        
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
        
        lat = userLocation?.coordinate.latitude
        long = userLocation?.coordinate.longitude
        
    }
    
    func checkCoreLocationPermission(){
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            
        case .notDetermined, .restricted:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            
        case .denied:
            print("denied")
            
        default:
            break
        }
        
    }
    
    func addLocationButton(){
        
        let btn = UIButton()
        
        btn.backgroundColor = UIColor.magenta
        
        btn.setTitle("loc", for: .normal)
        btn.titleLabel?.textColor = UIColor.white
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        btn.layer.cornerRadius = 25.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(locButtonTapped), for: .touchUpInside)
        
        view.addSubview(btn)
        
        let heightConstraint = NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute , multiplier: 1.0, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let trailingConstraint = NSLayoutConstraint(item: btn, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10)
        let bottomConstraint = NSLayoutConstraint(item: btn, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: -20)
        
        view.addConstraints([heightConstraint, widthConstraint, trailingConstraint, bottomConstraint])
        
    }
    
    func locButtonTapped(){
        
        mapCounter = mapCounter! + 1
        
        if mapCounter! <= 3 && mapCounter! >= 1 {
            
            let span = MKCoordinateSpanMake(latDelta, longDelta)
            
            switch mapCounter! {
                
            case 1:
                location = hometownCoordinates
            case 2:
                location = residenceCoordinates
            case 3:
                location = goodTraveledPlaceCoordinates
                
            default:
                break
            }
            
            let region = MKCoordinateRegionMake(location!, span)
            
            mapView.setRegion(region, animated: true)
            
            
        } else {
            
            mapCounter = 1
            
            setToHometownLoc()
        }
        
        
        
        
    }
    
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        
        switch segControl.selectedSegmentIndex {
            
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
            
        default:
            break
            
        }
    }
}
