//
//  API.swift
//  MyOnTheMap
//
//  Created by Mohammad Salhab on 4/20/20.
//  Copyright © 2020 Mohammad Salhab. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class API {

    static func login (_ email : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->())  {
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\": \"\(email!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    completion (false, "", error)
                    return
                }
                guard let status = (response as? HTTPURLResponse)?.statusCode else {
                    let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    completion (false, "", error)
                    return
                }
                
                if status >= 200 && status < 399 {
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range)
                    let jsonLogin = try! JSONSerialization.jsonObject(with: newData!, options: [])
                    let loginDictionary = jsonLogin as? [String : Any]
                    let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                    let key = accountDictionary? ["key"] as? String ?? " "
                    completion (true, key, nil)
                } else {
                    completion (false, "", nil)
                }
            }
            task.resume()
        }
    
    static func logout(completion: @escaping (_ success: Bool)->())  {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (false)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
                completion(true)
            }
        }
        task.resume()
    }
    
    static func getStudentsLocations(completion: @escaping ([StudentLocation]?, Error?)->()){
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&skip=0&order=-updatedAt"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            guard let dataMap = data else {
                completion(nil, error)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                print("response error")
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let result = try! decoder.decode(Result.self, from: dataMap)
            completion(result.results, nil)
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    static func postStudentLocation(_ location: StudentLocation, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = [
            "uniqueKey": location.uniqueKey ?? "1234",
            "firstName": location.firstName ?? "First Name",
            "lastName": location.lastName ?? "Last Name",
            "mapString" :location.mapString!,
            "mediaURL": location.mediaURL!,
            "latitude": location.latitude!,
            "longitude":location.longitude!,
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error?.localizedDescription)
                return
            }
            guard let status = (response as? HTTPURLResponse)?.statusCode else {
                let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion(false, error.localizedDescription)
                return
            }
            if status >= 200 && status <= 399 {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(StudentLocation.self, from: data)
                    completion(true, nil)
                } catch let error {
                    print(error.localizedDescription)
                    return
                }
            } else {
                completion(false, error?.localizedDescription)
                return
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}
