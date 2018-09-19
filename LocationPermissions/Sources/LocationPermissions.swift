//
//  LocationServicePermissions.swift
//  SKUtilsSwift
//
//  Created by Sergey Kostyan on 25.09.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import UIKit
import CoreLocation

public enum LocationAuthorizationType: String {
    case requestAlwaysAuthorization
    case requestWhenInUseAuthorization
}

public protocol LocationPermissions {
    
    typealias PermissionsState = CLAuthorizationStatus
    func requestPermissions(handler: @escaping (PermissionsState) -> Void)
    func permissionsState() -> PermissionsState
    
}

open class DefaultLocationPermissions: NSObject, LocationPermissions {

    private var authType: LocationAuthorizationType
    private var locationManager: CLLocationManager
    private var requestPermissionsHandler: ((PermissionsState) -> Void)?

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

extension DefaultLocationPermissions: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // WARNING: - delegate method called for notDetermined state too -
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.requestPermissionsHandler?(self.permissionsState())
        }
    }

}
