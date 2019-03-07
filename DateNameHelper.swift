//
//  DateNameHelper.swift
//  CSVideoCompression
//
//  Created by Chrystian (Pessoal) on 27/01/2019.
//

import Foundation

class DateNameHelper {
    
    func generateFileDateName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        
        let date = Date()
        return formatter.string(from: date)
    }
}
