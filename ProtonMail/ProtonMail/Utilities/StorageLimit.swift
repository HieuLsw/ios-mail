//
//  StorageLimit.swift
//  ProtonMail
//
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of ProtonMail.
//
//  ProtonMail is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonMail is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonMail.  If not, see <https://www.gnu.org/licenses/>.


import Foundation

let storageLimit = StorageLimit()

class StorageLimit {
    
    // MARK: - Public methods
    
    func checkSpace(_ usedSpace: Int64, maxSpace: Int64) {
        
        if userCachedStatus.isCheckSpaceDisabled {
            return
        }
        
        let maxSpace : Double = Double(maxSpace)
        let usedSpace : Double = Double(usedSpace) // * 160)
        let percentage : Double = Double(Constants.App.SpaceWarningThresholdDouble / 100)
        let threshold : Double = percentage * maxSpace
        
        if maxSpace == 0 || usedSpace < threshold {
            return
        }
        
        let formattedMaxSpace : String = ByteCountFormatter.string(fromByteCount: Int64(maxSpace), countStyle: ByteCountFormatter.CountStyle.file)
        var message = ""
        
        if usedSpace >= maxSpace {
            let localized = NSLocalizedString("You have used up all of your storage space (%@).", comment: "Description")
            if localized.count <= 0 || !localized.contains(check: "%@") {
                message = String(format: "You have used up all of your storage space (%@).", formattedMaxSpace);
            } else {
                message = String(format: localized, formattedMaxSpace);
            }
        } else {
            message = String(format: NSLocalizedString("You have used %d%% of your storage space (%@).", comment: "Description"), Constants.App.SpaceWarningThreshold, formattedMaxSpace);
        }
        
        let alertController = UIAlertController(title: LocalString._space_warning,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addOKAction()
        alertController.addAction(UIAlertAction(title: LocalString._hide, style: .destructive, handler: { action in
            userCachedStatus.isCheckSpaceDisabled = true
        }))

        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
