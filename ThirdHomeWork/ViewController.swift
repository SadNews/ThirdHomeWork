//
//  ViewController.swift
//  ThirdHomeWork
//
//  Created by Admin on 01.02.2020.
//  Copyright © 2020 UshakovAndrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redValueTF: UITextField!
    @IBOutlet weak var greenValueTF: UITextField!
    @IBOutlet weak var blueValueTF: UITextField!
    
    @IBOutlet weak var viewRGB: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redValueTF.delegate = self
        greenValueTF.delegate = self
        blueValueTF.delegate = self
        
        externalSetup()
        addDoneButtonOnKeyboard()
        
    }
    // Обновляем значение view
    func displayColors() {
        let red = CGFloat(redSlider.value)
        let blue = CGFloat(blueSlider.value)
        let green = CGFloat(greenSlider.value)
        let color = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1.0)
        viewRGB.backgroundColor = color
        
    }
    
    // Настраиваем внешний вид
    func externalSetup() {
        
        (redSlider.minimumValue,  greenSlider.minimumValue, blueSlider.minimumValue) = (0.0, 0.0, 0.0)
        (redSlider.maximumValue, greenSlider.maximumValue, blueSlider.maximumValue) = (1.0, 1.0, 1.0)
        (redValueTF.keyboardType, greenValueTF.keyboardType, blueValueTF.keyboardType)  = (.decimalPad, .decimalPad, .decimalPad)
        (redValueTF.backgroundColor, greenValueTF.backgroundColor,blueValueTF.backgroundColor)  = (.white, .white, .white)
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        blueSlider.minimumTrackTintColor = .blue
        
        redValueTF.text = String(format: "%.2f", redSlider.value)
        greenValueTF.text = String(format: "%.2f", greenSlider.value)
        blueValueTF.text = String(format: "%.2f", blueSlider.value)
        
    }
    
    // Добавляем кнопку Done на клавиатуру
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        redValueTF.inputAccessoryView = doneToolbar
        greenValueTF.inputAccessoryView = doneToolbar
        blueValueTF.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction() {
        redValueTF.resignFirstResponder()
        greenValueTF.resignFirstResponder()
        blueValueTF.resignFirstResponder()
        
    }
    // Обновляем значение лэйблов и филдов
    func updateValues() {
        redValueTF.text = String(format: "%.2f", redSlider.value)
        redValueLabel.text = redValueTF.text
        blueValueTF.text = String(format: "%.2f", blueSlider.value)
        blueValueLabel.text = blueValueTF.text
        greenValueTF.text = String(format: "%.2f", greenSlider.value)
        greenValueLabel.text = greenValueTF.text
        
        
    }
    
    @IBAction func rgbSlider(_ sendr: UISlider){
        updateValues()
        displayColors()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    
    // Ограничиваем возможность ввода символов кроме цифр и точки
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let inputText = textField.text else { return }
        
        if let currentText = Float(inputText) {
            if currentText >= redSlider.minimumValue && currentText <= redSlider.maximumValue {
                
                switch textField.tag {
                case 0:
                    redSlider.value = currentText
                case 1:
                    greenSlider.value = currentText
                case 2:
                    blueSlider.value = currentText
                default:
                    break
                }
                updateValues()
            }else{
                showAlert(with: "Неверное значение", and: "Введенное значение должно быть в пределах от 0.00 до 1.00")
                updateValues()
            }
        }else{
            showAlert(with: "Отсутсвует значение", and: "Ведите значение от 0.00 до 1.00")
            updateValues()
        }
    }
}

extension ViewController {
    private func showAlert(with Title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
}



