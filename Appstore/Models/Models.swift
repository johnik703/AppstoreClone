//
//  Models.swift
//  Appstore
//
//  Created by John Nik on 10/9/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "categiries" {
            
            appCategories = [AppCategory]()
            
            for dict in value as! [[String: AnyObject]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
            
        } else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
            
        }
        
        else {
            super.setValue(value, forKey: key)
        }
        
    }
    
}

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "apps" {
            
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
        
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping (FeaturedApps) -> ()) {
        let urlString = "http://www.statsallday.com/appstore/feature"
        let url = URL(string: urlString)
        
//        URLSession.shared.dataTask(with: url!) { (data, response, error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            do {
//                
//                let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! [String: AnyObject]
//                
//                let featuredApps = FeaturedApps()
//                featuredApps.setValuesForKeys(json)
//                
////                var appCategories = [AppCategory]()
////                
////                for dict in json["categories"] as! [[String: AnyObject]] {
////                    let appCategory = AppCategory()
////                    appCategory.setValuesForKeys(dict)
////                    appCategories.append(appCategory)
////                }
//                
//                DispatchQueue.main.async {
//                    
//                    completionHandler(featuredApps)
//                    
//                }
//                
//            } catch let err {
//                print(err)
//            }
//            
//            
//            
//        }.resume()
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            do {
                
                let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! [String: AnyObject]
                
                let featuredApps = FeaturedApps()
                featuredApps.setValuesForKeys(json)
                
                //                var appCategories = [AppCategory]()
                //
                //                for dict in json["categories"] as! [[String: AnyObject]] {
                //                    let appCategory = AppCategory()
                //                    appCategory.setValuesForKeys(dict)
                //                    appCategories.append(appCategory)
                //                }
                
                DispatchQueue.main.async {
                    
                    completionHandler(featuredApps)
                    
                }
                
            } catch let err {
                print(err)
            }
            
            
        }).resume()
        
    }
    
    static func sampleAppCategories() -> [AppCategory] {
        let bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var apps = [App]()
        
        let frozenApp = App()
        frozenApp.name = "Disney Build it: Frozen"
        frozenApp.imageName = "bodakapp_high"
        frozenApp.category = "Entertainment"
        frozenApp.price = NSNumber(value: 3.99)
        apps.append(frozenApp)
        
        bestNewAppsCategory.apps = apps
        
        
        let bestNewGameCategory = AppCategory()
        bestNewGameCategory.name = "Best New Games"
        var bestNewGamesApps = [App]()
        let telepainApp = App()
        telepainApp.name = "TElepaint"
        telepainApp.category = "Games"
        telepainApp.imageName = "bankaccountapp_high"
        telepainApp.price = NSNumber(value: 2.99)
        bestNewGamesApps.append(telepainApp)
        bestNewGameCategory.apps = bestNewGamesApps
        return [bestNewAppsCategory, bestNewGameCategory]
        
        
        
    }
}

class App: NSObject {
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
    var screenshots: [String]?
    var desc: String?
    var appInformation: AnyObject?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description" {
            self.desc = value as? String
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
