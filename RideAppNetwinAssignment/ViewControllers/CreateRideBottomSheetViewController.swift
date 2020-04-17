//
//  CreateRideBottomSheetViewController.swift
//  RideAppNetwinAssignment
//
//  Created by Bhushan Udawant on 16/04/20.
//  Copyright © 2020 Bhushan Udawant. All rights reserved.
//

import UIKit


enum PickerType {
    case date
    case time
    case unknown
}

enum FieldType {
    case textField
    case textView
    case unknown
}

class CreateRideBottomSheetViewController: UIViewController {

    // MARK: IBoutlets

    @IBOutlet weak var rideNameField: UITextField!
    @IBOutlet weak var pickupLocationTextView: UITextView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var vehicleTypeField: UITextField!
    @IBOutlet weak var vehicleNameField: UITextField!
    @IBOutlet weak var vehicleNumberField: UITextField!
    @IBOutlet weak var seatCountLabel: UILabel!
    @IBOutlet weak var isPaidToggleSwitch: UISwitch!
    @IBOutlet weak var seatCountStepper: UIStepper!
    @IBOutlet weak var datePickerContainerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var rideAmountLabel: UILabel!
    @IBOutlet weak var rideAmountField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraintContentView: NSLayoutConstraint!
    @IBOutlet weak var rideDetailsContainerView: UIView!


    // MARK: Properties

    var pickerType: PickerType = .unknown
    var activeField: UITextField?
    var activeTextView: UITextView?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat!
    var fieldType: FieldType = .unknown
    var shuldScrollEnabled = false
    var fixLowerHeight: CGFloat = 0

    private enum State {
        case partial
        case full
    }

    private enum Const {
        static let fullViewYPosition: CGFloat = Constants.fullViewYPosition
        static var partialViewYPostion: CGFloat { UIScreen.main.bounds.height - Constants.partialViewYPostion }
    }

    // MARK: View Controller Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}


// MARK: - Internal Methods -

extension CreateRideBottomSheetViewController {
    func validateFields() {
        let result = validateVehicleNumber(vehicleNumber: self.vehicleNumberField.text ?? "")

        if !result {
            showAlert(withTitle: Constants.alertTileValidationError, andMessage: Constants.alertMessageValidationError)
        }
    }
}


// MARK: - Private Methods -

extension CreateRideBottomSheetViewController {

    private func setupView() {
        // Pan Gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        self.view.addGestureRecognizer(panGesture)

        // seatCountStepper
        self.seatCountStepper.maximumValue = 0

        // datePickerContainerView
        datePickerContainerView.isHidden = true

        // date field
        dateField.text = Date().dateToString(with: Constants.dateFormat)
        dateField.rightViewMode = .always
        dateField.rightView = UIImageView(image: UIImage(named: Constants.downArrowImage))

        // time field
        timeField.rightViewMode = .always
        timeField.rightView = UIImageView(image: UIImage(named: Constants.downArrowImage))

        // Vehicle type
        vehicleTypeField.rightViewMode = .always
        vehicleTypeField.rightView = UIImageView(image: UIImage(named: Constants.downArrowImage))

        // Date picker
        datePicker.minimumDate = Date()

        // Date time delegate
        dateField.delegate = self
        timeField.delegate = self
        rideNameField.delegate = self
        vehicleTypeField.delegate = self
        vehicleNameField.delegate = self
        rideAmountField.delegate = self
        vehicleNumberField.delegate = self

        // toggleRideAmountView
        toggleRideAmountView(state: true)

        // isPaidToggleSwitch
        isPaidToggleSwitch.isOn = false

        // scrollView
        scrollView.isScrollEnabled = shuldScrollEnabled
        scrollView.delegate = self

        // Keyboard
        addKeyboardObservers()
        addTapGestureToDismissKeyboard()

        // Text view
        setupTextView()
    }

    private func validateVehicleNumber(vehicleNumber: String) -> Bool {
        // For Indian Standard Number Plate
        let nameRegex = Constants.vehicleNumberRegex
        let trimmedString = vehicleNumber.trimmingCharacters(in: .whitespaces)
        let validateNumber = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidNumber = validateNumber.evaluate(with: trimmedString)

        return isValidNumber
    }

    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Constants.cancelText, style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    private func toggleRideAmountView(state: Bool) {
        rideAmountLabel.isHidden = state
        rideAmountField.isHidden = state
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}


// MARK: - Sliding Action -

extension CreateRideBottomSheetViewController {
    private func moveView(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let minY = self.view.frame.minY

        guard let gestureView = gesture.view else {
            return
        }

        if (minY + translation.y >= Const.fullViewYPosition) && (minY + translation.y <= Const.partialViewYPostion) {
            gestureView.center = CGPoint(
                x: gestureView.center.x,
                y: gestureView.center.y + translation.y
            )
        } else {
            if (minY + translation.y >= Const.fullViewYPosition) {
                shuldScrollEnabled = false
            } else {
                shuldScrollEnabled = true
                
            }
        }

        gesture.setTranslation(.zero, in: view)
    }

    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        moveView(gesture)

        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = gesture.velocity(in: self.view).y >= 0 ? State.partial : .full
                let yPosition = state == .partial ? Const.partialViewYPostion : Const.fullViewYPosition
                self.view.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.width, height: self.view.frame.height)

            }) { (condition) in
                if self.shuldScrollEnabled {
                    self.scrollView.isScrollEnabled = true
                } else {
                    self.scrollView.isScrollEnabled = false
                }
            }
        }

    }

    private func setupTextView() {
        pickupLocationTextView.delegate = self

        pickupLocationTextView.layer.borderWidth = 1
        pickupLocationTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        pickupLocationTextView.layer.cornerRadius = 5.0

        setPlaceholderToTextView()
    }

    private func addTapGestureToDismissKeyboard() {
        let tapGesutre = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tapGesutre.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesutre)
    }

    private func setPlaceholderToTextView() {
        pickupLocationTextView.text = Constants.locationTextViewPlaceholder
        pickupLocationTextView.textColor = UIColor.lightGray
    }
}


// MARK: - IBActions -

extension CreateRideBottomSheetViewController {

    @IBAction func seatCountValueChanged(_ sender: UIStepper) {
        self.seatCountLabel.text = Int(sender.value).description
    }

    @IBAction func selectVehicleType(_ sender: UITextField) {
        datePickerContainerView.isHidden = true

        let defautSeatCount = "0"

        let actionSheet = UIAlertController(title: Constants.selectVehicleTypeTitle, message: nil, preferredStyle: .actionSheet)

        let twoWheeler = UIAlertAction(title: Constants.twoWheelerTypeText, style: .default) { (action) in
            self.vehicleTypeField.text = Constants.twoWheelerTypeText
            self.seatCountStepper.maximumValue = Constants.twoWheelerSeatCount
            self.seatCountLabel.text = defautSeatCount
        }
        let twoWheelerImage = UIImage(named: Constants.twoWheelerImage)
        twoWheeler.setValue(twoWheelerImage?.withRenderingMode(.alwaysOriginal), forKey: "image")

        let fourWheeler = UIAlertAction(title: Constants.fourWheelerTypeText, style: .default) { (action) in
            self.vehicleTypeField.text = Constants.fourWheelerTypeText
            self.seatCountStepper.maximumValue = Constants.fourWheelerSeatCount
            self.seatCountLabel.text = defautSeatCount
        }
        let fourWheelerImage = UIImage(named: Constants.fourWheelerImage)
        fourWheeler.setValue(fourWheelerImage?.withRenderingMode(.alwaysOriginal), forKey: "image")

        let other = UIAlertAction(title: Constants.otherTypeText, style: .default) { (action) in
            self.vehicleTypeField.text = Constants.otherTypeText
            self.seatCountStepper.maximumValue = Constants.otherWheelerSeatCount
            self.seatCountLabel.text = defautSeatCount
        }
        let otherWheelerImage = UIImage(named: Constants.otherWheelerImage)
        other.setValue(otherWheelerImage?.withRenderingMode(.alwaysOriginal), forKey: "image")

        let cancel = UIAlertAction(title: Constants.cancelText, style: .cancel)

        actionSheet.addAction(twoWheeler)
        actionSheet.addAction(fourWheeler)
        actionSheet.addAction(other)
        actionSheet.addAction(cancel)

        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func beginSettingTime(_ sender: UITextField) {
        rideDetailsContainerView.endEditing(true)
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .time
        pickerType = .time
    }

    @IBAction func beginSettingDate(_ sender: UITextField) {
        rideDetailsContainerView.endEditing(true)
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .date
        pickerType = .date
    }

    @IBAction func cancelDateSelection(_ sender: UIButton) {
        datePickerContainerView.isHidden = true
    }

    // Done button tapped
    @IBAction func setDateOrTime(_ sender: UIButton) {
        datePickerContainerView.isHidden = true

        switch pickerType {
        case .date:
            self.dateField.text = datePicker.date.dateToString(with: Constants.dateFormat)
        case .time:
            self.timeField.text = datePicker.date.dateToString(with: Constants.timeFormat)
        case .unknown:
            break
        }
    }

    @IBAction func isPaidSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            toggleRideAmountView(state: false)
        } else {
            toggleRideAmountView(state: true)
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height

            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraintContentView.constant += self.keyboardHeight
            })

            var distanceToBottom: CGFloat

            switch fieldType {
            case .textField:
                guard let _ = activeField else {
                    return
                }

                distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            case .textView:
                guard let _ = activeTextView else {
                    return
                }

                distanceToBottom = self.scrollView.frame.size.height - (activeTextView?.frame.origin.y)! - (activeTextView?.frame.size.height)!
            case .unknown:
                return
            }

            let collapseSpace = keyboardHeight - distanceToBottom

            if collapseSpace < 0 {
                return
            }

            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraintContentView.constant -= self.keyboardHeight

            self.scrollView.contentOffset = self.lastOffset
        }

        keyboardHeight = nil
    }
}


// MARK: - UITextFieldDelegate -

extension CreateRideBottomSheetViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == dateField || textField == timeField || textField == vehicleTypeField {
            rideDetailsContainerView.endEditing(true)

            return false
        }

        datePickerContainerView.isHidden = true
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        fieldType = .textField

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        fieldType = .unknown

        return true
    }
}


// MARK: - UIScrollViewDelegate -

extension CreateRideBottomSheetViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if !(scrollView.frame.size.height <= fixLowerHeight) {
            if scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset = CGPoint.zero
                self.scrollView.isScrollEnabled = false
                self.shuldScrollEnabled = false
            } else {
                self.scrollView.isScrollEnabled = true
                self.shuldScrollEnabled = true
            }
        }
    }
    
}


// MARK: - UITextViewDelegate -

extension CreateRideBottomSheetViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }

        activeTextView = textView
        lastOffset = self.scrollView.contentOffset
        fieldType = .textView
        datePickerContainerView.isHidden = false

        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.locationTextViewPlaceholder
            textView.textColor = UIColor.lightGray
        }

        activeTextView?.resignFirstResponder()
        activeTextView = nil
        fieldType = .unknown
    }
}
