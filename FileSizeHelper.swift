//
//  FileSizeHelper.swift
//  CSVideoCompression
//
//  Created by Chrystian Salgado on 07/03/19.
//

import Foundation

public class FileSizeHelper {
    
    /// Get file size from file urlPath.
    public class func getFileSize(from url: URL) -> String {
        if let data = NSData(contentsOf: url) {
            let doubleValue = Double(data.length) / 1048576.0
            let valueFormated = String(format: "%.2f", doubleValue)
            return "\(valueFormated) mb"
        }
        else {
            return "No file size available."
        }
    }
    
    public class func getFileSize(from data: Data) -> String {
        let doubleValue = Double(data.count) / 1048576.0
        let valueFormated = String(format: "%.2f", doubleValue)
        return "\(valueFormated) mb"
    }
}
