//
//  ThemeManager+OC.swift
//  SwiftTheme
//
//  Created by Gesen on 16/9/18.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import Foundation

@objc extension ThemeManager {
    
    /**
       extension for Objective-C, Use setTheme(jsonName: String, path: ThemePath) in Swift
    */
    public class func setThemeWithJsonInMainBundle(_ jsonName: String) {
        setTheme(jsonName: jsonName, path: .mainBundle)
    }
    
    /**
       extension for Objective-C, Use setTheme(jsonName: String, path: ThemePath) in Swift
    */
    public class func setThemeWithJsonInSandbox(_ jsonName: String, path: URL) {
        setTheme(jsonName: jsonName, path: .sandbox(path))
    }

    /**
        extension for Objective-C, Use setTheme(dict: NSDictionary, path: ThemePath) in Swift
     */
    public class func setThemeWithDictInMainBundle(_ dict: NSDictionary) {
        setTheme(dict: dict, path: .mainBundle)
    }
    
    /**
        extension for Objective-C, Use setTheme(dict: NSDictionary, path: ThemePath) in Swift
     */
    public class func setThemeWithDictInSandbox(_ dict: NSDictionary, path: URL) {
        setTheme(dict: dict, path: .sandbox(path))
    }
    
}
