//
//  ViewController.swift
//  MapModul
//
//  Created by smallHappy on 2017/5/21.
//  Copyright © 2017年 SmallHappy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    enum BarButtonItemTag: Int {
        case left = 1, right
    }

    var segmented: UISegmentedControl!
    var mapView: MKMapView!
    
    var isUserLocationShow = false
    var region: MKCoordinateRegion!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: - selector
    func onBarButtonItemAction(sender: UIBarButtonItem) {
        guard let tag = BarButtonItemTag(rawValue: sender.tag) else { return }
        switch tag {
        case .left:
            self.isUserLocationShow = !self.isUserLocationShow
            mapView.showsUserLocation = self.isUserLocationShow
        case .right:
            let region = self.mapView.region
            // 座標中心
            print(region.center.latitude)
            print(region.center.longitude)
            // 顯示範圍
            print(region.span.latitudeDelta)   // 1緯度差距，相當於111km(69miles)。
            print(region.span.longitudeDelta)  // 1經度差距，在赤道上相當於111km(69miles)。
        }
    }
    
    func onSegmentedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satellite
        case 2:
            self.mapView.mapType = .hybrid
        default:
            self.mapView.mapType = .standard
            sender.selectedSegmentIndex = 0
        }
    }
    
    //MARK: - function
    private func setNavigationItem() {
        // left
        let leftButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.onBarButtonItemAction(sender:)))
        leftButton.tag = BarButtonItemTag.left.rawValue
        self.navigationItem.leftBarButtonItem = leftButton
        // right
        let rightButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(self.onBarButtonItemAction(sender:)))
        rightButton.tag = BarButtonItemTag.right.rawValue
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func initUI() {
        if self.segmented == nil {
            let segmentW: CGFloat = 240
            let segmentH: CGFloat = 29
            let segmentX = (self.navigationController!.navigationBar.frame.width - segmentW) / 2
            let segmentY = (self.navigationController!.navigationBar.frame.height - segmentH) / 2
            self.segmented = UISegmentedControl(items: ["Map", "Satellite", "Hybrid"])
            self.segmented.frame = CGRect(x: segmentX, y: segmentY, width: segmentW, height: segmentH)
            self.segmented.selectedSegmentIndex = 0
            self.segmented.addTarget(self, action: #selector(self.onSegmentedAction(_:)), for: .valueChanged)
            self.navigationController?.navigationBar.addSubview(self.segmented)
        }
        if self.mapView == nil {
            let mapY = self.navigationController!.navigationBar.frame.maxY
            let mapW = UIScreen.main.bounds.width
            let mapH = UIScreen.main.bounds.height - mapY
            self.mapView = MKMapView()
            self.mapView.frame = CGRect(x: 0, y: mapY, width: mapW, height: mapH)
//            self.mapView.delegate = self
            self.view.addSubview(self.mapView)
        }
    }

}

//extension ViewController: MKMapViewDelegate {
//    
//}
