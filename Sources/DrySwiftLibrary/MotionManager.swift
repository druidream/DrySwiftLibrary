//
//  MotionManager.swift
//  DrySwiftLibrary
//
//  Created by Jun Gu on 2/17/25.
//

import UIKit
import CoreMotion

@MainActor
public class MotionManager: ObservableObject {

    public static let shared = MotionManager()

    private let motionManager = CMMotionManager()

    @Published public var motion: CMDeviceMotion?

    var initialized: Bool = false

    private func setup() {
        setInternal(0.1)
        NotificationCenter.default.addObserver(self, selector: #selector(startMotionUpdates), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopMotionUpdates), name: UIApplication.willResignActiveNotification, object: nil)
        initialized = true
    }

    @objc public func startMotionUpdates() {
        if !initialized {
            setup()
        }
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
                self?.motion = motion
            }
        }
    }

    @objc public func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }

    public func setInternal(_ val: CGFloat) {
        motionManager.deviceMotionUpdateInterval = val
    }
}
