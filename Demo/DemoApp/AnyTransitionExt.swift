//
//  AnyTransition-debugging.swift
//  RexTables
//
//  Created by Marin Todorov on 9/8/22.
//

import Foundation
import SwiftUI

extension AnyTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "anvil": self = .movingParts.anvil
        case "blur": self = .movingParts.blur
        case "boing": self = .movingParts.boing
        case "flicker": self = .movingParts.flicker
        case "flip": self = .movingParts.flip
        case "glare": self = .movingParts.glare
        case "poof": self = .movingParts.poof
        case "swoosh": self = .movingParts.swoosh
        case "vanish": self = .movingParts.vanish
        case "wipe": self = .movingParts.wipe(angle: .degrees(45))
        case "skid": self = .asymmetric(
            insertion: .movingParts.skid,
            removal: .movingParts.skid(
                direction: .trailing
            )
        )
        case "": self = .identity
        default: unimplemented("Unsupported transition")
        }
    }
}

func print(_ transition: AnyTransition?) {
    guard let transition = transition else {
        print("nil")
        return
    }
    print(transition.name)
}

func print(_ transition: AnyTransition) {
    print(transition.name)
}

extension AnyTransition {
    var name: String {
        var text = String(describing: self)
        let regex = try! NSRegularExpression(pattern: "ModifierTransition<(.*?)>")
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

        if !results.isEmpty {
            text = results.map { result in
                let regexNSRange = result.range(at: 1)
                guard let regexRange = Range(regexNSRange, in: text) else {
                    return ""
                }
                return String(text[regexRange])
            }
            .joined(separator: ", ")
        }
        return text
    }
}
