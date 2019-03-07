//
//  PhotoCompressionHelper.swift
//  CSVideoCompression
//
//  Created by Chrystian Salgado on 07/03/19.
//

import UIKit

class PhotoCompressionHelper {
    
    public init() {}
    
    func compressTo(_ expectedSizeInMb: Int, imageToCompress: UIImage, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        
        while (needCompress && compressingValue > 0.0) {
            if let data = imageToCompress.jpegData(compressionQuality: compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                }
                else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                print("O tamanho do arquivo era \(FileSizeHelper.getFileSize(from: imageToCompress.jpegData(compressionQuality: 0)!))")
                print("O tamanho do arquivo comprimido ficou em \(FileSizeHelper.getFileSize(from: data))")
                completionHandler(UIImage(data: data), nil)
            }
        }
        else {
            completionHandler(nil, getPhotoCompressionError())
        }
    }
    
    private func getPhotoCompressionError() -> NSError {
        return NSError(domain: "INTERNAL", code: 01, userInfo: nil)
    }
}
