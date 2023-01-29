//
//  GetModel.swift
//  Task7
//
//  Created by Вадим Сайко on 24.01.23.
//

struct GetModel: Codable {
    let title: String
    let image: String
    let fields: [Field]
}

struct Field: Codable {
    let title, name: String
    let type: FieldTypes
    let values: Values?
}

enum FieldTypes: String, Codable {
    case text = "TEXT"
    case numeric = "NUMERIC"
    case list = "LIST"
    
    var tag: Int {
        switch self {
        case .text:
            return 0
        case .numeric:
            return 1
        case .list:
            return 2
        }
    }
}

struct Values: Codable {
    let none, v1, v2, v3: String
}
