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
        
        let myString = "^n:\n\(String(describing: networkNameTextField.text!))\n" + "^p:\n\(String(describing: networkPasswordTextField.text!))"
        
        print("⚡️\(myString)")
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            
            let ciImage = filter?.outputImage
            
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let transformImage = ciImage?.transformed(by: transform)
            
            
            let img = convert(cmage: transformImage!)
            myImageView.image = img
            
            
        
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
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
