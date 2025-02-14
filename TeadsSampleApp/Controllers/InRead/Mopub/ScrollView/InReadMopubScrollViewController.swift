//
//  InReadMopubScrollViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2020 Teads. All rights reserved.
//

import TeadsSDK
import UIKit
#if canImport(MoPubSDK)
import MoPubSDK
#else
import MoPub
#endif
import TeadsMoPubAdapter

class InReadMopubScrollViewController: TeadsViewController {
    @IBOutlet var slotHeight: NSLayoutConstraint!
    var bannerView: MPAdView!

    @IBOutlet var slotView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME: This ids should be replaced by your own MoPub id
        let MOPUB_AD_UNIT_ID = pid

        let config = MPMoPubConfiguration(adUnitIdForAppInitialization: MOPUB_AD_UNIT_ID)
        bannerView = MPAdView(adUnitId: MOPUB_AD_UNIT_ID)
        bannerView.delegate = self
        bannerView.frame = slotView.bounds

        if MoPub.sharedInstance().isSdkInitialized {
            loadAd()
        }

        MoPub.sharedInstance().initializeSdk(with: config) { [weak self] in
            DispatchQueue.main.async {
                self?.loadAd()
            }
        }
    }

    func loadAd() {
        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            try? settings.registerAdView(bannerView, delegate: self)
        }
        bannerView.register(teadsAdSettings: settings)
        bannerView.stopAutomaticallyRefreshingContents() // usefull to perform validationTool https://support.teads.tv/support/solutions/articles/36000209100-validation-tool
        bannerView.loadAd(withMaxAdSize: kMPPresetMaxAdSizeMatchFrame)
        addConstraints()
    }

    func addConstraints() {
        guard let adView = bannerView else {
            return
        }
        slotView.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false

        let margins = slotView.layoutMarginsGuide
        adView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        adView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        adView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        adView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
    }
}

extension InReadMopubScrollViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
}

extension InReadMopubScrollViewController: TeadsMediatedAdViewDelegate {
    func didUpdateRatio(_: UIView, adRatio: TeadsAdRatio) {
        let width = slotView.frame.width
        slotHeight.constant = adRatio.calculateHeight(for: width)
    }
}
