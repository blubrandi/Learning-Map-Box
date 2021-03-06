//
//  ViewController.swift
//  GeoSeekPlayProject
//
//  Created by Brandi Bailey on 2/19/20.
//  Copyright © 2020 Brandi Bailey. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var myMapView: MGLMapView!
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
    
    var pressedLocation:CLLocation? = nil {
        didSet{
                continueButton.isEnabled = true
            print("pressedLocation was set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: MGLStyle.satelliteStyleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 33.812794, longitude: -117.9190981), zoomLevel: 15, animated: false)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = false
        mapView.addGestureRecognizer(lpgr)
        
        view.addSubview(mapView)
        
    }
    
    //MARK: - UILongPressGestureRecognizer Action -
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
        } else {
            print("I was long pressed...")
            
            myMapView.setCenter(CLLocationCoordinate2D(latitude: 33.812794, longitude: -117.9190981), zoomLevel: 15, animated: false)
            let touchPoint = gestureReconizer.location(in: myMapView)
            let coordsFromTouchPoint = myMapView.convert(touchPoint, toCoordinateFrom: myMapView)
            pressedLocation = CLLocation(latitude: coordsFromTouchPoint.latitude, longitude: coordsFromTouchPoint.longitude)
            print("Location:", coordsFromTouchPoint.latitude, coordsFromTouchPoint.longitude)
            
            let wayAnnotation = MGLPointAnnotation()
            wayAnnotation.coordinate = coordsFromTouchPoint
            wayAnnotation.title = "waypoint"
            
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        print("The button was tapped...")
        performSegue(withIdentifier: "ToAddGemSegue", sender: self)
        
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAddGemSegue" {
            guard let destinationVC = segue.destination as? AddGemViewController,
                let pressedLocation = pressedLocation else { return }
            
            destinationVC.gemLocation = pressedLocation
        }
    }
}
