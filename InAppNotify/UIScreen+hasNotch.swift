//
//  UIScreen+hasNotch.swift
//  InAppNotify
//
//  Created by CaptainYukinoshitaHachiman on 2018/10/3.
//  Copyright © 2018 Luca Becchetti. All rights reserved.
//

import UIKit

extension UIScreen {
    
    var hasNotch: Bool {
        let height = bounds.height
        let width = bounds.width
        return height == 812
        || width == 812
        || height == 896
        || width == 896
    }
    
}
