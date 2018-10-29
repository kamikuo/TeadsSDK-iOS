//
//  AdMobController.swift
//  TeadsDemoApp
//
//  Copyright © 2018 Teads. All rights reserved.
//

import GoogleMobileAds
import TeadsAdMobAdapter
import UIKit

class AdMobController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    @IBOutlet weak var slotView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Init AdMob (could be done in your Application class)
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3570580224725271~8055914490")

        // 2. Create AdMob view and add it to hierarchy
        self.bannerView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        self.bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.slotView.addSubview(bannerView)
        NSLayoutConstraint.activate(
            [self.bannerView.centerXAnchor.constraint(equalTo: self.slotView.centerXAnchor),
             self.bannerView.centerYAnchor.constraint(equalTo: self.slotView.centerYAnchor)])

        // 3. Attach Delegate (will include Teads events)
        bannerView.adUnitID = "ca-app-pub-3570580224725271/5615499706"
        bannerView.rootViewController = self
        bannerView.delegate = self

        // 4. Load a new ad (this will call AdMob and Teads afterward)
        let request = GADRequest()
        let teadsExtras = GADMAdapterTeadsExtras()
        
        // Needed by european regulation
        // See https://mobile.teads.tv/sdk/documentation/ios/gdpr-consent
        teadsExtras.subjectToGDPR = "1"
        teadsExtras.consent = "0001100101010101"
        
        // The article url if you are a news publisher
        teadsExtras.pageUrl = "http://page.com/article1"
        
        request.register(teadsExtras.getCustomEventExtras(forCustomEventLabel: "__custom_event_label__"))
        
        bannerView.load(request)
    }
    
    // MARK: GADBannerViewDelegate
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        // not used
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        // not used
    }

}
