//
//  ViewController.swift
//  CSVideoCompression
//
//  Created by salllgado@hotmail.com.br on 01/27/2019.
//  Copyright (c) 2019 salllgado@hotmail.com.br. All rights reserved.
//

import UIKit
import SwiftyCam
import CSVideoCompression

class ViewController: SwiftyCamViewController {
    
    @IBOutlet weak var btnRecord: RecordButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnRecord.delegate = self
    }
    
    private func setPreferences() {
        maximumVideoDuration = 10.0
        shouldPrompToAppSettings = true
        flashMode = .auto
        btnRecord.buttonEnabled = true
    }
}

extension ViewController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        CSCompression.compressImage(expectedSizeInMb: 1, imageToCompress: photo) { (imageCompressed, error) in
            if let _image = imageCompressed {
                
            }
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        btnRecord.growButton()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        btnRecord.shrinkButton()
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        CSCompression.compressVideo(videoURL: url, fileNameType: NameType.uuidName, videoCompessedQuality: .low) { (newUrl, videoFileData, error) in
            if let _ = newUrl {
                // ...
            }
        }
    }
}

