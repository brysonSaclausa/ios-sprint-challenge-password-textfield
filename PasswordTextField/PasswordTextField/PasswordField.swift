//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit


enum PasswordStrengthValue: String {
    case weak = "too weak"
    case medium = "could be stronger"
    case strong = "strong password"
}


class PasswordField: UIControl {
    
    
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    
    private var shouldShowPassword: Bool = true
    
    
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
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    func setup() {
        // Lay out your subviews here
        configureTitle()
        configureTextField()
        configureStrengthViews()
        configureStrengthDescriptionLabel()
        configureShowHideButton()
        backgroundColor = bgColor
        
        

    }
    
   
    
// Configure SUbviews
    private func configureTitle() {
        titleLabel.text = "Enter Password"
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTextField() {
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.layer.borderWidth = 2
        textField.isSecureTextEntry = true
        
        textField.becomeFirstResponder()
        
        
        
        textField.delegate = self
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldMargin),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin),
            textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight)
        ])
     
    }
    

    
    
    private func configureShowHideButton() {
        print("eyeconfigured")
        
        addSubview(showHideButton)
        showHideButton.setImage(UIImage(named: "eyes-closed.png"), for: .normal)
        showHideButton.addTarget(self, action: #selector(toggleEye), for: .touchUpInside)
        
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showHideButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -20),
            showHideButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor)
            
            
        ])
    }
    
 
    
    private func configureStrengthViews() {
        
        weakView.backgroundColor = unusedColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        
        addSubview(weakView)
        addSubview(mediumView)
        addSubview(strongView)
        
        weakView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        strongView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            weakView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin * 2),
            weakView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: textFieldMargin),
            weakView.widthAnchor.constraint(equalToConstant: colorViewSize.width),
            weakView.heightAnchor.constraint(equalToConstant: colorViewSize.height),
            
            mediumView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin * 2),
            mediumView.leadingAnchor.constraint(equalTo: weakView.trailingAnchor, constant: 5),
            mediumView.widthAnchor.constraint(equalToConstant: colorViewSize.width),
            mediumView.heightAnchor.constraint(equalToConstant: colorViewSize.height),
            
            strongView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin * 2),
            strongView.leadingAnchor.constraint(equalTo: mediumView.trailingAnchor, constant: 5),
            strongView.widthAnchor.constraint(equalToConstant: colorViewSize.width),
            strongView.heightAnchor.constraint(equalToConstant: colorViewSize.height)
          
       ])
        
    }
    
    
    
    private func configureStrengthDescriptionLabel() {
        //
        strengthDescriptionLabel.text = "(password strength)"
        strengthDescriptionLabel.textAlignment = .right
        
        addSubview(strengthDescriptionLabel)
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            strengthDescriptionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin),
            strengthDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin)
            
        
        ])
    }
    
 
    
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
    }
    
    
    
    
    //Count characters in pw string
    private func getPasswordStrength(password: String) {
        switch password.count {
        case 1:
            
            weakView.backgroundColor = .red
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = PasswordStrengthValue.weak.rawValue
            weakAnimation()
            
        case 2...9:
            weakView.backgroundColor = .red
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = PasswordStrengthValue.weak.rawValue
            
            
        
            
        case 10:
            mediumView.backgroundColor = .orange
            weakView.backgroundColor = .orange
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = PasswordStrengthValue.medium.rawValue
            medAnimation()
            
        case 11...19:
        
        mediumView.backgroundColor = .orange
        weakView.backgroundColor = .orange
        strongView.backgroundColor = unusedColor
        strengthDescriptionLabel.text = PasswordStrengthValue.medium.rawValue
        
            
        case 20:
           
       
            mediumView.backgroundColor = .green
            weakView.backgroundColor = .green
            strongView.backgroundColor = .green
            strengthDescriptionLabel.text = PasswordStrengthValue.strong.rawValue
            strongAnimation()
            print("strong")
            
        case 21...100:
            mediumView.backgroundColor = .green
            weakView.backgroundColor = .green
            strongView.backgroundColor = .green
            strengthDescriptionLabel.text = PasswordStrengthValue.strong.rawValue
        default:
            weakView.backgroundColor = unusedColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = "(password strength)"
            
          
            
        }
    }
    
    @objc private func toggleEye(sender: UIButton ) {
        print("toggleEye")
        shouldShowPassword.toggle()
        activateToggleEye(bool: shouldShowPassword)
    }
    
    
    
    private func activateToggleEye(bool: Bool) {
        print("ActivateTgl")
        shouldShowPassword = bool
        let image = bool ? UIImage(named: "eyes-open") : UIImage(named: "eyes-closed")
        if image == UIImage(named: "eyes-open") {
            textField.isSecureTextEntry = false
        } else {
            textField.isSecureTextEntry = true
        }
        
        showHideButton.setImage(image, for: .normal)
        
    }
    
   // MARK: Animation
    
    @objc private func strongAnimation() {
        strongView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.strongView.transform = .identity
                        
        },
                       completion: nil)
        
        mediumView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.mediumView.transform = .identity
                        
        },
                       completion: nil)
        weakView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.weakView.transform = .identity
                        
        },
                       completion: nil)

    }
    
    @objc private func medAnimation() {
        mediumView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.mediumView.transform = .identity
                        
        },
                       completion: nil)
        weakView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
                        self.weakView.transform = .identity
                        
        },
                       completion: nil)

    }
    @objc private func weakAnimation() {
    weakView.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
    UIView.animate(withDuration: 1.0,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 0,
                   options: [],
                   animations: {
                    self.weakView.transform = .identity
                    
    },
                   completion: nil)
}
    
}

extension PasswordField: UITextFieldDelegate {
     
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        getPasswordStrength(password: newText)
        password = newText
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //send to VC
        sendActions(for: .valueChanged)
        print("passwordFromPF: \(password)")
        textField.resignFirstResponder()
        
        return true
        
            }
    }


