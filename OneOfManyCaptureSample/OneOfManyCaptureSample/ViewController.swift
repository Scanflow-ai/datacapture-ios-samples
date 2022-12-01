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

    //This is the main view where aout av
    @IBOutlet weak var scannerView: UIView!
    
    private lazy var scanflowManager = ScanflowBarCodeManager(previewView: scannerView, installedDate: Date(), scannerType: "oneOfMany", overCropNeed: false, overlayApperance: .square, leftTopArc: .red, leftDownArc: .blue, rightTopArc: .yellow, rightDownArc: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanflowManager.validateLicense(authKey: "____Auth Key_____")
        
        ScanflowBarcodeDetectionClassifier.shared.setupFiles(scannerType: .oneOfMany)
        scanflowManager.startSession()
        
        scanflowManager.delegate = self
        
    }


}

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
        var codeInfo:CodeInfo = CodeInfo()
        scanflowManager.detectionClassiferHandler(originalframe, &codeInfo)
    }
    
    func capturedOutput(result: String, codeType: String, results: [String]?, processedImage: UIImage?) {
        
    }
    
    func showAlert(title: String?, message: String) {
        
    }
    
    
}
