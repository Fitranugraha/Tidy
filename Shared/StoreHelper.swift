//
//  StoreHelper.swift
//  Tidy iOS
//
//  Created by Chris Danford on 3/9/19.
//  Copyright © 2019 Chris Danford. All rights reserved.
//

import StoreKit

class StoreHelper {
    private static var currentVersion: String? {
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return nil
        }
        return currentVersion
    }

    static let key = "lastVersionPromptedForReview"

    static func shouldAskUserForReview(state: AppState) -> Bool {
        let minSavingsBytes: UInt64 = 2 * 1024 * 1024 * 1024
        if state.totalSavingsBytes < minSavingsBytes {
            return false
        }
        
        guard let version = StoreHelper.currentVersion else {
            return false
        }
        
        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: key)
        if lastVersionPromptedForReview == version {
            return false
        }
        
        return true
    }
    
    static func requestReview() {
        SKStoreReviewController.requestReview()
        UserDefaults.standard.set(currentVersion, forKey: key)
    }
}
