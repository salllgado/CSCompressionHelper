//
//  VideoCompressionHelper.swift
//  CSVideoCompression
//
//  Created by Chrystian (Pessoal) on 27/01/2019.
//

import Foundation
import AVFoundation

class VideoCompressionHelper {
    
    var assetReader: AVAssetReader?
    var assetWriter: AVAssetWriter?
    
    public init() {}
    
    /**
     Método que comprime um video a partir da url path do video.
     
     - parameter urlToCompress: video url path.
     */
    func compressVideo(from urlToCompress: URL, customFileName: String, completion:@escaping (URL?, NSData?, Error?)->Void) {
        compressVideo(from: urlToCompress, customFileName: customFileName, fileNameType: nil, fileExtension: nil, completion: completion)
    }
    
    func compressVideo(from urlToCompress: URL, fileNameType: NameType, completion:@escaping (URL?, NSData?, Error?)->Void) {
        compressVideo(from: urlToCompress, customFileName: nil, fileNameType: fileNameType, fileExtension: nil, completion: completion)
    }
    
    private func compressVideo(from urlToCompress: URL, customFileName: String? = nil, fileNameType: NameType? = nil, fileExtension: VideoExtension? = .mov,  completion:@escaping (URL?, NSData?, Error?)->Void) {
        
        guard let _ = urlToCompress.pathComponents.last else {
            fatalError("Has no video file in this path.")
            return
        }
        
        let _fileExtension = fileExtension?.rawValue ?? VideoExtension.mov.rawValue
        let sourceAsset = AVURLAsset(url: urlToCompress, options: nil)
        let outputPathURL = generateFileURLWithPath(using: _fileExtension, nameType: fileNameType, customName: customFileName)
        
        // Search for file in new future video file local and delete if exists.
        tryRemoveFile(from: outputPathURL)
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetMediumQuality)!
        assetExport.outputFileType = getAVFileType(fileExtension)
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.outputURL = outputPathURL
        assetExport.exportAsynchronously { () -> Void in
            
            switch assetExport.status {
            case AVAssetExportSessionStatus.completed:
                DispatchQueue.main.async {
                    do {
                        let videoData = try NSData(contentsOf: outputPathURL, options: NSData.ReadingOptions())
                        
                        print("File size: \(self.getFileSize(from: outputPathURL))")
                        completion(outputPathURL, videoData, nil)
                    } catch {
                        completion(nil, nil, assetExport.error)
                    }
                }
            case  AVAssetExportSessionStatus.failed:
                completion(nil, nil, assetExport.error)
            case AVAssetExportSessionStatus.cancelled:
                completion(nil, nil, assetExport.error)
            default:
                // ... Completed.
                break
            }
        }
    }
    
    /**
     This method generete a random uuid or file by date or filename by custom name.
     
     - parameter fileExtension:
     - parameter name:
     */
    private func generateFileURLWithPath(using fileExtension: String, nameType: NameType? = nil, customName: String?) -> URL {
        let documentsPath = NSTemporaryDirectory()
        var fileName = ""
        
        if let name = nameType {
            switch name {
            case .uuidName:
                fileName = UUIDFormatedHelper().createUUID()
            case .dateName:
                fileName = DateNameHelper().generateFileDateName()
            }
        }
        else {
            fileName = customName ?? DateNameHelper().generateFileDateName()
        }
        
        let outputPath = "\(documentsPath)/\(fileName)\(fileExtension)"
        
        return URL(fileURLWithPath: outputPath)
    }
    
    
    /// This method remove will try remove file fro specific url.
    private func tryRemoveFile(from customURL: URL) {
        if FileManager.default.fileExists(atPath: customURL.absoluteString) {
            do {
                try FileManager.default.removeItem(at: customURL)
            } catch {
                fatalError("Error trying to remove file from system files.")
            }
        }
    }
    
    /**
     Método que retorna o tamanho de um arquivo vindo de uma url, formatado em duas casas decimais.
     
     - parameter url: File path url.
     */
    private func getFileSize(from url: URL) -> String {
        if let data = NSData(contentsOf: url) {
            let doubleValue = Double(data.length) / 1048576.0
            let valueFormated = String(format: "%.2f", doubleValue)
            return "\(valueFormated) mb"
        }
        else {
            return "No file size available."
        }
    }
    
    private func getAVFileType(_ videoExtension: VideoExtension?) -> AVFileType {
        guard let _videoExtension = videoExtension else { return AVFileType.mov }
        
        switch _videoExtension {
        case .mp4:
            return AVFileType.mp4
        case .mov:
            return AVFileType.mov
        }
    }
}
