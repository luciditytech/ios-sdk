//
//  KR8OS.swift
//  KR8OS
//
//  Created by Jon Kent on 1/22/18.
//  Copyright © 2018 KR8OS. All rights reserved.
//

import Foundation
import AdSupport

final public class KR8OS {
    
    private static let KR8OS_URL = URL(string: "https://transponder.kr8os.com/v1/postbacks")!
    private static let defaults = UserDefaults(suiteName: String(describing: KR8OS.self))
    
    /**
     Registers an app installation with KR8OS.
     
     - parameter appId: `String` provided by KR8OS.
     */
    @objc public static func registerInstall(appId: String) {
        // Objective-c compatible initializer as objective-c does not support default method parameter values.
        registerInstall(appId: appId, debug: false)
    }
    
    /**
     Registers an app installation with KR8OS.
     
     - parameter appId: `String` provided by KR8OS.
     - parameter debug: `Bool` specifies that registration is being requested for a debug build. This should be set to `false` before deploying to the App Store.
     */
    @objc public static func registerInstall(appId: String, debug: Bool) {
        guard let idfa = identifierForAdvertising else {
            printWarning("ASIdentifierManager.shared().isAdvertisingTrackingEnabled returned false.")
            return
        }
        
        if let registrationDate = registrationDate {
            print("KR8OS previously registered an install for IDFA \(idfa) on \(registrationDate).")
            return
        }
        
        var bodyParameters = [
            "device_id": idfa,
            "app_id": appId
        ]
        if debug {
            bodyParameters["mode"] = "debug"
        }
        
        let bodyData = try! JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
        
        var request = URLRequest(url: KR8OS_URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                printWarning(error!.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                printWarning("unexpected response type.")
                return
            }
            
            guard  response.statusCode == 201 else {
                printWarning("expected 201 but received \(response.statusCode) from \(KR8OS_URL)")
                return
            }
            
            // Store success
            register()
        }
        
        task.resume()
    }
    
    // Returns the IDFA if available.
    private static var identifierForAdvertising: String? {
        // Check whether advertising tracking is enabled
        guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else {
            return nil
        }
        
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    // Returns a stored date from a previous registration if it exists.
    private static var registrationDate: Date? {
        guard let defaults = defaults else {
            printWarning("unable to access UserDefaults.")
            return nil
        }
        
        let registrationDate = defaults.value(forKey: "registered") as? Date
        return registrationDate
    }
    
    // Stores the current date for registration.
    private static func register() {
        let date = Date()
        defaults?.set(date, forKey: "registered")
        print("KR8OS successfully registered IDFA \(identifierForAdvertising!) on \(date).")
    }
    
    // Prints warning messages prefixed with the KR8OS tag.
    private static func printWarning(_ message: String) {
        print("KR8OS failed to register:", message)
    }
    
}
