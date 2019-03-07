//
//  UUIDFormatedHelper.swift
//  CSVideoCompression
//
//  Created by Chrystian (Pessoal) on 27/01/2019.
//

import Foundation

class UUIDFormatedHelper {
    
    func createUUID() -> String {
        let UUIDFormated = NSUUID().uuidString.lowercased().removeFromString(character: "-")
        return UUIDFormated
    }
}

extension String {
    
    func removeFromString(character: String) -> String {
        var stringFormated = ""
        for char in self {
            if char != "-" {
                stringFormated.append(char)
            }
        }
        return stringFormated
    }
}
