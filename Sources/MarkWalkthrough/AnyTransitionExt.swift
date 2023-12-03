// See the LICENSE file for this code's license information.

import Foundation
import SwiftUI

extension AnyTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let name = try container.decode(String.self)
        switch name {
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
        default:
            preconditionFailure("Unrecognized transition '\(name)'")
        }
    }
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
