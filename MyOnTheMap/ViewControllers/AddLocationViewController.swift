//
//  AddLocationViewController.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/23/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var myLocation: UITextField!
    @IBOutlet weak var myURL: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var location: StudentLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.isHidden = true
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        activityIndicator.isHidden = false
        if !myLocation.text!.isEmpty && !myURL.text!.isEmpty {
            let location = myLocation.text
            let url = myURL.text
            let studentLocation = StudentLocation(mapString: location, mediaURL: url)
            findLocation(studentLocation)
        } else {
            let alert = UIAlertController(title: "Error", message: "Location and URL cannot be empty.", preferredStyle: .alert )
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func findLocation(_ search: StudentLocation){
        CLGeocoder().geocodeAddressString(search.mapString!) { (placemarks, error) in
            if error != nil {
                let alert = UIAlertController(title: "Attention", message: "There is an error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard let firstLocation = placemarks?.first?.location else {
                let alert = UIAlertController(title: "Error", message: "Location not found ", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.location = search
            self.location.latitude = firstLocation.coordinate.latitude
            self.location.longitude = firstLocation.coordinate.longitude
            //self.location.firstName =
            self.performSegue(withIdentifier: "ConfirmLocation", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmLocation", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = self.location
        }
    }
}
