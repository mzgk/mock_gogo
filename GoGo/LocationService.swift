//
//  LocationService.swift
//  GoGo
//
//  Created by 水垣岳志 on 2017/09/27.
//  Copyright © 2017年 mzgkworks. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationService: NSObject, CLLocationManagerDelegate {

    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation  // 精度
        locationManager.distanceFilter = 5  // 5mごとにlocationManager:didUpdateLocations:に位置情報を渡す
        
        locationManager.requestWhenInUseAuthorization()
        // バックグランドでの更新を許可
        locationManager.allowsBackgroundLocationUpdates = true
        // バッテリー消費を抑える（true）-> iOSが停止を判断して位置取得を停止する
        // ただしアプリがバックグランドにいる時に位置情報取得が停止されると、フォアグランドになるまで取得が開始されない
        // ランニングアプリなどは、falseにしておいた方がいい
        locationManager.pausesLocationUpdatesAutomatically = false


        super.init()
        locationManager.delegate = self
    }

    // 位置情報の取得開始
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        // これで位置が変わるたびに、DelegateのdidUpdateLocationsが呼ばれる
    }

    // 位置情報の取得停止
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude))")
        }
    }

}
