//
//  CreateRideViewController.swift
//  RideAppNetwinAssignment
//
//  Created by Bhushan Udawant on 16/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import UIKit
import GoogleMaps

class CreateRideViewController: UIViewController {

    // MARK: IBoutlets

    @IBOutlet weak var mapView: GMSMapView!

    // MARK: Properties

    var createRideBottomSheetViewController: CreateRideBottomSheetViewController?
    let navTitle = "Create Trip"

    
    // MARK: View controller life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        showBottomSheet()
    }
}

// MARK: - Private Methods -

extension CreateRideViewController {
    private func setupView() {
        // Map view
        let camera = GMSCameraPosition.camera(withLatitude: 20.5937, longitude: 78.9629, zoom: 6.0)
        mapView.camera = camera

        // Navigation Bar
        setupNavigationBar()
    }

    private func showBottomSheet() {
        if let viewController = self.storyboard?.instantiateViewController(identifier: Constants.CreateRideBottomSheetViewController) as? CreateRideBottomSheetViewController {
            self.createRideBottomSheetViewController = viewController
            self.createRideBottomSheetViewController?.fixLowerHeight = self.view.frame.size.height - Constants.partialViewYPostion
            self.addChild(self.createRideBottomSheetViewController!)
            self.view.addSubview(self.createRideBottomSheetViewController!.view)
            self.createRideBottomSheetViewController!.didMove(toParent: self)

            let height = self.view.frame.size.height
            let width = self.view.frame.size.width

            self.createRideBottomSheetViewController!.view.frame = CGRect(x: 0, y: self.view.frame.size.height - Constants.partialViewYPostion, width: width, height: height)
        }
    }

    private func setupNavigationBar() {
        self.navigationItem.title = navTitle
    }
}


// MARK: - IBActions -

extension CreateRideViewController {
    @IBAction func createTrip(_ sender: UIBarButtonItem) {
        if let _ = self.createRideBottomSheetViewController {
            createRideBottomSheetViewController?.validateFields()
        }
    }
}
