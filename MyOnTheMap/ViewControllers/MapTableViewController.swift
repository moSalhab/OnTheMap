//
//  MapTableViewController.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/26/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import UIKit

class MapTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell")!
        guard let studentLocation = DataModel.data?[indexPath.row] else {
            return UITableViewCell()
        }
        let name = studentLocation.firstName ?? "" + (studentLocation.lastName ?? "")
        cell.textLabel?.text = name
        
        cell.detailTextLabel?.text = studentLocation.mediaURL!
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let studentLocation = DataModel.data?[indexPath.row] else { return }
        guard let url = studentLocation.mediaURL else { return }
        print(studentLocation.uniqueKey!)
        UIApplication.shared.open(URL(string: url) ?? URL(string: "")!, options: [:], completionHandler: nil)
    }
    
    
    
    //my unique key = 167657490790

    func getData(){
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
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        toLogout()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshData(_ sender: Any) {
        getData()
    }
    
    @IBAction func addLocation(_ sender: Any) {
        if let addLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "addLocationViewController") {
        self.present(addLocationViewController, animated: true, completion: nil)
        }
    }
    
    func toLogout() {
        API.logout() { (success) in
            DispatchQueue.main.async {
                if success {
                    self.tabBarController?.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Erorr", message: "Error in Logout", preferredStyle: .alert )
                    alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return}
            }
        }
    }
}
