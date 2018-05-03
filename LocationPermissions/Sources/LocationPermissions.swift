//
//  LocationServicePermissions.swift
//  SKUtilsSwift
//
//  Created by Sergey Kostyan on 25.09.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import UIKit
import CoreLocation
import SKServicePermissions

public enum LocationAuthorizationType: String {
    case requestAlwaysAuthorization
    case requestWhenInUseAuthorization
}

open class LocationPermissions: NSObject, ServicePermissions {

    private var authType: LocationAuthorizationType
    private var locationManager: CLLocationManager
    private var requestPermissionsHandler: ((PermissionsState) -> Void)?

    public typealias PermissionsState = CLAuthorizationStatus
    
    public init(authType: LocationAuthorizationType = .requestAlwaysAuthorization) {
        self.authType = authType
        locationManager = CLLocationManager()
    }
    
    public func requestPermissions(handler: @escaping (PermissionsState) -> Void) {
        requestPermissionsHandler = handler
        locationManager.delegate = self
        switch authType {
        case .requestAlwaysAuthorization:
            locationManager.requestAlwaysAuthorization()
        case .requestWhenInUseAuthorization:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func permissionsState() -> PermissionsState {
        return CLLocationManager.authorizationStatus()
    }
    
}

// MARK: - CLLocationManagerDelegate -

extension LocationPermissions: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // WARNING: - delegate method called for notDetermined state too -
        requestPermissionsHandler?(permissionsState())
    }

}
