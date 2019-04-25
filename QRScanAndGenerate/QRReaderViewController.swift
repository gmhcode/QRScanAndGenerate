//
//  QRReaderViewController.swift
//  QRScanAndGenerate
//
//  Created by Greg Hughes on 4/24/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit
import AVFoundation
import NetworkExtension

class QRReaderViewController: UIViewController {
    
    var video = AVCaptureVideoPreviewLayer()
    
    @IBOutlet weak var square: UIImageView!
    @IBOutlet weak var generateCodeScreenButton: UIButton!
    @IBOutlet weak var networkNameTextFIeld: UITextField!
    @IBOutlet weak var networkPasswordTextField: UITextField!
    @IBOutlet weak var connectButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let session = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video){
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                session.addInput(input)
            }catch{
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
            }
            
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            //setting up the delegate to read qr
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            video = AVCaptureVideoPreviewLayer(session: session)
            video.frame = view.layer.bounds
            view.layer.addSublayer(video)
            
            self.view.bringSubviewToFront(square)
            self.view.bringSubviewToFront(generateCodeScreenButton)
            self.view.bringSubviewToFront(networkNameTextFIeld)
            self.view.bringSubviewToFront(networkPasswordTextField)
            self.view.bringSubviewToFront(connectButton)
            
            session.startRunning()
            
        }
    }
    
    @IBAction func connect(_ sender: Any) {
        
        if networkPasswordTextField.text != "" && networkNameTextFIeld.text != "" {
            
            connectToNetwork()
        }
    }
    
    
    
    
}


extension QRReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // heres where the qr is actually read
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    guard let networkStrings = object.stringValue else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

                    if networkStrings.contains("\n") {
                        let splitArray = networkStrings.split(separator: "\n")
                        
                        if splitArray.contains("^n:") && splitArray.contains("^p:"){
                            
                            
                            guard let nameIndex = splitArray.firstIndex(of: "^n:"), let pwIndex = splitArray.firstIndex(of: "^p:") else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                            
                            
                            networkNameTextFIeld.text = String(splitArray[nameIndex + 1])
                            networkPasswordTextField.text = String(splitArray[pwIndex + 1])
                        }
                    }
                    
//                    let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
//                    alert.addAction(UIAlertAction(title: "copy", style: .default, handler: { (nil) in
//                        UIPasteboard.general.string = object.stringValue
//                    }))
//                    present(alert, animated: true)
                }
            }
        }
    }
}

extension QRReaderViewController{
    func connectToNetwork(){
        
        guard let networkNameTextFIeldText = networkNameTextFIeld.text,
            let networkPasswordTextFieldText = networkPasswordTextField.text else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        let hotspotConfig = NEHotspotConfiguration(ssid: "\(networkNameTextFIeldText)", passphrase: "\(networkPasswordTextFieldText)", isWEP: false)
        
        NEHotspotConfigurationManager.shared.apply(hotspotConfig) {[unowned self] (error) in
            if let error = error {
                print("error = ",error)
            }
            else {
                print("Success!")
                
                print("🏧\(networkNameTextFIeldText)")
                print("✅\(networkPasswordTextFieldText)")
            }
        }
    }
}
