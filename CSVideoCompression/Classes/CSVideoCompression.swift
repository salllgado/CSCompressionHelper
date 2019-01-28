//
//  CSVideoCompression.swift
//  CSVideoCompression
//
//  Created by Chrystian (Pessoal) on 27/01/2019.
//

import Foundation

public class CSVideoCompression {
    
    public init() {
        // ...
    }
    
    /**
     Compress video from some video file path url.
     
     - parameter urlToCompress: video url path.
     - parameter customFileName: custom file name to save video as.
     - parameter videoCompessedQuality: Video will be compressed using this quality, remember highest quality will compress less than lowest quality.
     */
    open class func compressVideo(videoURL: URL, customFileName: String, videoCompessedQuality: VideoQuality, completionHandler:@escaping (URL?, NSData?, Error?)->Void) {
        VideoCompressionHelper().compressVideo(from: videoURL, customFileName: customFileName, videoCompessedQuality: videoCompessedQuality, completion: completionHandler)
    }
    
    /**
     Compress video from some video file path url.
     
     - parameter urlToCompress: video url path.
     - parameter fileNameType: custom file gerenate by system criteria.
     - parameter videoCompessedQuality: Video will be compressed using this quality, remember highest quality will compress less than lowest quality.
     */
    open class func compressVideo(videoURL: URL, fileNameType: NameType, videoCompessedQuality: VideoQuality, completionHandler:@escaping (URL?, NSData?, Error?)->Void) {
        VideoCompressionHelper().compressVideo(from: videoURL, fileNameType: fileNameType, videoCompessedQuality: videoCompessedQuality, completion: completionHandler)
    }
}
