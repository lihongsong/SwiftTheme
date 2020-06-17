//
//  ThemeManager.swift
//  SwiftTheme
//
//  Created by Gesen on 16/1/22.
//  Copyright © 2016年 Gesen. All rights reserved.
//

import Foundation

public let ThemeUpdateNotification = "ThemeUpdateNotification"

public enum ThemePath {
    
    case mainBundle
    case sandbox(Foundation.URL)
    
    public var URL: Foundation.URL? {
        switch self {
        case .mainBundle        : return nil
        case .sandbox(let path) : return path
        }
    }
    
    public func jsonPath(name: String) -> String? {
        return filePath(name: name, ofType: "json")
    }
    
    private func filePath(name: String, ofType type: String) -> String? {
        switch self {
        case .mainBundle:
            return Bundle.main.path(forResource: name, ofType: type)
        case .sandbox(let path):
            let name = name.hasSuffix(".\(type)") ? name : "\(name).\(type)"
            let url = path.appendingPathComponent(name)
            return url.path
        }
    }
}

@objc public final class ThemeManager: NSObject {
    
    @objc public static let shareInstance: ThemeManager = ThemeManager()
    
    @objc public static var animationDuration = 0.3
    
    @objc public fileprivate(set) static var currentTheme: NSDictionary?
    @objc public fileprivate(set) static var currentThemeIndex: Int = 0
    
    @objc fileprivate static var darkIgnoreControllers: [String]?
    
    @objc fileprivate static var themeItems: NSHashTable = NSHashTable<NSObject>.init(options: .weakMemory)
    
    public fileprivate(set) static var currentThemePath: ThemePath?
    
    public override init() {
        super.init()
        
        // 初始化 hook 方法
//        UIView.initializeMethod()
        UIViewController.initializeMethod()
    }
}

extension ThemeManager {
    
    @objc class func hookViewDidLoad( viewControlelr: UIViewController) {
        
        guard let vcs = darkIgnoreControllers else {
            return
        }
        
        let className = NSStringFromClass(type(of: viewControlelr))
        
        if vcs.contains(className) {
            return
        }
        
        if #available(iOS 13, *) {
            viewControlelr.overrideUserInterfaceStyle = .light
        }
    }
}

public extension ThemeManager {
    
    @objc class func setDarkIgnore(_ viewControllers: [String]) {
        darkIgnoreControllers = viewControllers
    }
    
    @objc class func addThemeItem(_ themeObject: NSObject) {
        
        if themeObject.onThemeStack {
            return
        }
        themeItems.add(themeObject)
        themeObject.onThemeStack = true
    }
    
    @objc class func removeThemeItem(_ themeObject: NSObject) {
        
        if !themeObject.onThemeStack {
            return
        }
        themeItems.remove(themeObject)
        themeObject.onThemeStack = false
    }
    
    @objc class func updateTheme() {
        themeItems.allObjects.forEach{ $0._updateTheme() }
        NotificationCenter.default.post(name: Notification.Name(rawValue: ThemeUpdateNotification), object: nil)
    }
}

public extension ThemeManager {
    
    @objc class func setTheme(index: Int) {
        currentThemeIndex = index
        updateTheme()
    }
    
    class func setTheme(jsonName: String, path: ThemePath) {
        guard let jsonPath = path.jsonPath(name: jsonName) else {
            print("SwiftTheme WARNING: Can't find json '\(jsonName)' at: \(path)")
            return
        }
        guard
            let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)),
            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
            let jsonDict = json as? NSDictionary else {
            print("SwiftTheme WARNING: Can't read json '\(jsonName)' at: \(jsonPath)")
            return
        }
        self.setTheme(dict: jsonDict, path: path)
    }
    
    class func setTheme(dict: NSDictionary, path: ThemePath) {
        currentTheme = dict
        currentThemePath = path
        updateTheme()
    }
    
}
