//
//  ViewController.swift
//  OneOfManyCaptureSample
//
//  Created by Mac-OBS-46 on 01/12/22.
//

import UIKit
import ScanflowCore
import ScanflowBarcode

class ViewController: UIViewController {

    //This is the main view where a AVCaptureSession session will be added in this view
    @IBOutlet weak var scannerView: UIView!
    
    //This is the lable we are showing result from ScanflowBarcode Manager
    @IBOutlet weak var resultLabel: UILabel!
    
    //We are init the ScanflowManager function in which we have barcode related functions
    private lazy var scanflowManager = ScanflowBarCodeManager(previewView: scannerView, installedDate: Date(), scannerType: "pivotView", overCropNeed: false, overlayApperance: .square, leftTopArc: .red, leftDownArc: .blue, rightTopArc: .yellow, rightDownArc: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We have to validate license for processing image and getting output
        scanflowManager.validateLicense(authKey: "____Auth Key_____")
        
        //We are setting modelFiles inorder to detect objects in captured frame
        ScanflowBarcodeDetectionClassifier.shared.setupFiles(scannerType: .oneOfMany)
        
        //In this we are start capturing camera frames by using AVCaptureSession
        scanflowManager.startSession()
        
        scanflowManager.delegate = self
        
    }


}

// MARK: - ScanflowCameraManagerDelegate

extension ViewController: ScanflowCameraManagerDelegate {
    
    func presentCameraPermissionsDeniedAlert() {
        
    }
    
    func presentVideoConfigurationErrorAlert() {
        
    }
    
    func sessionRunTimeErrorOccurred() {
        
    }
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        
    }
    
    func sessionInterruptionEnded() {
        
    }
    
    func captured(originalframe: CVPixelBuffer, overlayFrame: CGRect, croppedImage: UIImage) {
        // this for debug purpose in our SDK
        var codeInfo:CodeInfo = CodeInfo()
        
        //In this we are sending captured frames for detecting barcodes
        scanflowManager.detectionClassiferHandler(originalframe, &codeInfo)
    }
    
    func capturedOutput(result: String, codeType: String, results: [String]?, processedImage: UIImage?) {
        
        // Since updating UI, we have to run in  main thread.
        DispatchQueue.main.async {
            //loading result to resaults lable
            resultLabel.text = result
            //This is for mentionting code type like CODE128, CODE39 and etc
            print(codeType)
        }
        
    }
    
    func showAlert(title: String?, message: String) {
        
    }
    
    
}
