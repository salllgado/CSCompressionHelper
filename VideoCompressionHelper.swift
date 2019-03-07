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
    func compressVideo(from urlToCompress: URL, customFileName: String, videoCompessedQuality: VideoQuality, completion: @escaping (URL?, NSData?, Error?)->Void) {
        compressVideo(from: urlToCompress, customFileName: customFileName, fileNameType: nil, fileExtension: nil, videoCompessedQuality: videoCompessedQuality, completion: completion)
    }
    
    func compressVideo(from urlToCompress: URL, fileNameType: NameType, videoCompessedQuality: VideoQuality, completion: @escaping (URL?, NSData?, Error?)->Void) {
        compressVideo(from: urlToCompress, customFileName: nil, fileNameType: fileNameType, fileExtension: nil, videoCompessedQuality: videoCompessedQuality, completion: completion)
    }
    
    private func compressVideo(from urlToCompress: URL, customFileName: String? = nil, fileNameType: NameType? = nil, fileExtension: VideoExtension? = .mov, videoCompessedQuality: VideoQuality, completion:@escaping (URL?, NSData?, Error?)->Void) {
        
        guard let _ = urlToCompress.pathComponents.last else {
            fatalError("Has no video file in this path.")
        }
        
        print("Old file size: \(FileSizeHelper.getFileSize(from: urlToCompress))")
        
        let _fileExtension = fileExtension?.rawValue ?? VideoExtension.mov.rawValue
        let sourceAsset = AVURLAsset(url: urlToCompress, options: nil)
        let outputPathURL = generateFileURLWithPath(using: _fileExtension, nameType: fileNameType, customName: customFileName)
        
        // Search for file in new future video file local and delete if exists.
        tryRemoveFile(from: outputPathURL)
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: sourceAsset, presetName: getAVVideoQuality(videoCompessedQuality))!
        assetExport.outputFileType = getAVFileType(fileExtension)
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.outputURL = outputPathURL
        assetExport.exportAsynchronously { () -> Void in
            
            switch assetExport.status {
            case AVAssetExportSession.Status.completed:
                DispatchQueue.main.async {
                    do {
                        let videoData = try NSData(contentsOf: outputPathURL, options: NSData.ReadingOptions())
                        print("File size: \(FileSizeHelper.getFileSize(from: outputPathURL)), Success !!!")
                        completion(outputPathURL, videoData, nil)
                    } catch {
                        completion(nil, nil, assetExport.error)
                    }
                }
            case  AVAssetExportSession.Status.failed:
                completion(nil, nil, assetExport.error)
            case AVAssetExportSession.Status.cancelled:
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
    
    
    /// Get video quality by enum
    private func getAVVideoQuality(_ videoQuality: VideoQuality) -> String {
        switch videoQuality {
        case .high:
            return AVAssetExportPresetHighestQuality
        case .medium:
            return AVAssetExportPresetMediumQuality
        case .low:
            return AVAssetExportPresetLowQuality
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
