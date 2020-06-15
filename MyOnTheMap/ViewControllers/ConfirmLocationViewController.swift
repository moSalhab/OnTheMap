//
//  ConfirmLocationViewController.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/23/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var location: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        showLocation()
    }

    
    @IBAction func finish(_ sender: Any) {
        API.postStudentLocation(self.location!) { (success, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Cannot find the location", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            if success {
                DispatchQueue.main.async {
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    let tabBarViewController = storyBoard.instantiateViewController(identifier: "tabBarViewController")
                    self.present(tabBarViewController, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Error in posting location.", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    func showLocation() {
        guard let location = location else { return }
        let latitude = CLLocationDegrees(location.latitude!)
        let longitude = CLLocationDegrees(location.longitude!)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        annotation.subtitle = location.mediaURL
        map.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
