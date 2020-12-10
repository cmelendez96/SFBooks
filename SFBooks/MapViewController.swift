//
//  MapViewController.swift
//  SFBooks
//
//  Created by Chris Melendez on 12/7/20.
//  Copyright © 2020 Chris Melendez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //populateNearByPlaces()
        //createAnnotations(locations: annotationLocations)
    }
    
    override func viewDidAppear(_ animated: Bool ){
        
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
            populateNearByPlaces(location)
        }
    }
    
    func render(_ location: CLLocation){
        
        //SF
        /*let coordinate = CLLocationCoordinate2D(latitude: 37.77493, longitude: -122.419416)*/
        
        //New York
        //let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        
        //User
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }

    func populateNearByPlaces(_ location: CLLocation) {
        var region = MKCoordinateRegion()
        
        //SF
        /*region.center = CLLocationCoordinate2D(latitude: 37.77493, longitude: -122.419416)*/
        
        //New York
        //region.center = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        
        //User Location
        region.center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Book Stores"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start {(response, error) in
            
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                
                DispatchQueue.main.async{
                    self.mapView.addAnnotation(annotation)
                }
            }
            
            print(response.mapItems)
            
            
        }
    }

}
