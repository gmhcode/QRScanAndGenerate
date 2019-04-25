//
//  ViewController.swift
//  QRScanAndGenerate
//
//  Created by Greg Hughes on 4/24/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class GenerateQRCodeViewController: UIViewController {

    @IBOutlet weak var networkPasswordTextField: UITextField!
    @IBOutlet weak var networkNameTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkNameTextField.delegate = self
        
    }
    
    @IBAction func button(_ sender: Any) {
        
        guard let networkNameTextField = networkNameTextField.text,
            let networkPasswordTextField = networkPasswordTextField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        let myString = "^n:\n\(String(describing: networkNameTextField))\n" + "^p:\n\(String(describing: networkPasswordTextField))"
        
        print("⚡️\(myString)")
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            
            let ciImage = filter?.outputImage
            
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        guard let transformImage = ciImage?.transformed(by: transform) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            
            //converting ciImage to UIImage
            let img = convert(cmage: transformImage)
            myImageView.image = img
            
            
        
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        
        guard let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent) else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return UIImage()}
        
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
}


extension GenerateQRCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
}
