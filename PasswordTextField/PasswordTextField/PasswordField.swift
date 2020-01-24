//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class PasswordField: UIControl {
    // MARK: - Attributes
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var strength: PasswordStrength = .weak
    
    // Default Values
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    // Init of Views
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = bgColor
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: standardMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -standardMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: standardMargin).isActive = true
        titleLabel.font = labelFont
        titleLabel.text = "ENTER PASSWORD"
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: standardMargin).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -standardMargin).isActive = true
        textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin).isActive = true
        textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight).isActive = true
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 5
        textField.setBorder(width: 3, color: textFieldBorderColor)
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10+textFieldContainerHeight-standardMargin*2)
        textField.delegate = self
        
        addSubview(showHideButton)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -standardMargin*2).isActive = true
        showHideButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin*2).isActive = true
        showHideButton.heightAnchor.constraint(equalToConstant: textFieldContainerHeight-standardMargin*2).isActive = true
        showHideButton.widthAnchor.constraint(equalToConstant: textFieldContainerHeight-standardMargin*2).isActive = true
        showHideButton.setBackgroundImage(UIImage(imageLiteralResourceName: "eyes-closed"), for: .normal)
        showHideButton.setBackgroundImage(UIImage(imageLiteralResourceName: "eyes-open"), for: .selected)
        showHideButton.imageView?.contentMode = .scaleAspectFit
        showHideButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        addSubview(weakView)
        weakView.translatesAutoresizingMaskIntoConstraints = false
        weakView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: standardMargin).isActive = true
        weakView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin*2).isActive = true
        weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        weakView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -standardMargin*2).isActive = true
        weakView.backgroundColor = weakColor
        weakView.layer.cornerRadius = colorViewSize.height/2
        
        addSubview(mediumView)
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.leadingAnchor.constraint(equalTo: weakView.trailingAnchor, constant: standardMargin/2).isActive = true
        mediumView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin*2).isActive = true
        mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        mediumView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -standardMargin*2).isActive = true
        mediumView.backgroundColor = unusedColor
        mediumView.layer.cornerRadius = colorViewSize.height/2
        
        addSubview(strongView)
        strongView.translatesAutoresizingMaskIntoConstraints = false
        strongView.leadingAnchor.constraint(equalTo: mediumView.trailingAnchor, constant: standardMargin/2).isActive = true
        strongView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin*2).isActive = true
        strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width).isActive = true
        strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height).isActive = true
        strongView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -standardMargin*2).isActive = true
        strongView.backgroundColor = unusedColor
        strongView.layer.cornerRadius = colorViewSize.height/2
        
        addSubview(strengthDescriptionLabel)
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        strengthDescriptionLabel.leadingAnchor.constraint(equalTo: strongView.trailingAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin).isActive = true
        strengthDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -standardMargin).isActive = true
        strengthDescriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -standardMargin).isActive = true
        strengthDescriptionLabel.text = "Too weak"
    }
    
    // MARK: - Functions
    @objc private func showPassword() {
        textField.isSecureTextEntry.toggle()
        showHideButton.isSelected.toggle()
    }
    
    private func animateElement(_ view: UIView) {
        UIView.animate(withDuration: 1/7, animations: { view.transform = CGAffineTransform(scaleX: 1, y: 1.5) })
        { _ in view.transform = .identity }
    }
    
    private func setToWeak() {
        strength = .weak
        strengthDescriptionLabel.text = "Too weak"
        animateElement(weakView)
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
    }
    
    private func setToMedium() {
        strength = .medium
        strengthDescriptionLabel.text = "Could be stronger"
        animateElement(mediumView)
        mediumView.backgroundColor = mediumColor
        strongView.backgroundColor = unusedColor
    }
    
    private func setToHigh() {
        strength = .high
        strengthDescriptionLabel.text = "Strong password"
        animateElement(strongView)
        mediumView.backgroundColor = mediumColor
        strongView.backgroundColor = strongColor
    }
}

// MARK: - Password Grading
extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        determineStrength(of: newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendActions(for: .valueChanged)
        guard let text = textField.text else { return true }
        password = text
        textField.text = ""
        print("Password: \(password), Strength: \(strength)")
        setToWeak()
        return true
    }
    
        private func determineStrength(of text: String) {
        let bgQueue = DispatchQueue(label: "bg1")
        bgQueue.async() {
            let isInDict = UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: text)
            var strength: PasswordStrength {
                switch text.count {
                case 10...19: return .medium
                case 20...: return .high
                default: return .weak
                }
            }
            if strength == .weak || strength == .medium && isInDict { if self.strength != .weak { DispatchQueue.main.async { self.setToWeak() } } else { return } }
            if strength == .medium || strength == .high && isInDict { if self.strength != .medium { DispatchQueue.main.async { self.setToMedium() } } else { return } }
            if strength == .high { if self.strength != .high { DispatchQueue.main.async { self.setToHigh() } } }
        }
    }
}

// MARK: - Other Class-Extensions
extension UIView {
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
// MARK: - Enums
enum PasswordStrength {
    case weak
    case medium
    case high
}
