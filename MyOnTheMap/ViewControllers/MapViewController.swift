//
//  MapViewController.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/20/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    @IBAction func refreshData(_ sender: Any) {
        getData()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        toLogout()
        self.dismiss(animated: true, completion: nil)
    }
    
    func toLogout() {
        API.logout() { (success) in
            DispatchQueue.main.async {
                if success {
                    self.tabBarController?.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "ERROR", message: "Logout error", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return}
            }
        }
    }
    

    
    @IBAction func addLocation(_ sender: Any) {
        if let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "addLocationViewController") {
            self.present(addLocationViewController, animated: true, completion: nil)
        }
    }
    
    func getData() {
        API.getStudentsLocations { (locations, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Attention", message: "There is an error", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    print("error")
                    return
                }
                guard locations != nil else {
                    let alert = UIAlertController(title: "Attention", message: "There is no data found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    return
                }
                DataModel.data = locations
                var Locations = [MKPointAnnotation]()
                for location in locations! {
                    let long = CLLocationDegrees(location.longitude ?? 0.0)
                    let lat = CLLocationDegrees(location.latitude ?? 0.0)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let mediaURL = location.mediaURL ?? " "
                    let firstName = location.firstName ?? " "
                    let lastName = location.lastName ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    Locations.append(annotation)
                }
                self.mapView.addAnnotations(Locations)
            }
        }
    }
    
    
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

       let reuseId = "pin"

       var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

       if pinView == nil {
           pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
           pinView!.canShowCallout = true
           pinView!.pinTintColor = .red
           pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
       } else {
           pinView!.annotation = annotation
       }

       return pinView
   }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let link = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: link) ?? URL(string: "")!, options: [:], completionHandler: nil)
            }
        }
    }
}
