// See the LICENSE file for this code's license information.

import Foundation
import Combine
import MarkCodable
import SwiftUI

struct Step: Decodable {
    var image: String
    var transition: [AnyTransition]
    var text: String
    var sticker: String?
    var stickerOffset: [CGFloat]?
    var stickerScale: CGFloat?
}

public class MarkWalkthroughModel: ObservableObject {
    var steps: [Step]

    public init(from url: URL) throws {
        let markdown = try String(contentsOf: url)
        steps = try MarkDecoder().decode([Step].self, from: markdown)
    }

    var initialized = false

    var lastStepIndex = -1

    @Published public var currentStep = -1 {
        willSet {
            if currentStep != newValue {
                lastStepIndex = currentStep
            }
        }

        didSet {
            if currentStep < 0 { currentStep = 0 }
            if currentStep >= steps.count { currentStep = steps.count - 1 }

            let step = steps[currentStep]

            if initialized {
                if currentStep.isMultiple(of: 2) {
                    evenImageName = step.image
                    oddImageName = nil
                } else {
                    evenImageName = nil
                    oddImageName = step.image
                }

                if mainText != step.text {
                    mainText = nil
                }
                if stickerImageName != step.sticker {
                    stickerImageName = nil
                    offsetEffect = false
                }
            }

            if self.currentStep.isMultiple(of: 2) {
                self.evenAddTransition = step.transition.first ?? .identity
                self.evenRemoveTransition = step.transition.last ?? .identity
            } else {
                self.oddAddTransition = step.transition.first ?? .identity
                self.oddRemoveTransition = step.transition.last ?? .identity
            }

            DispatchQueue.main.asyncAfter(wallDeadline: .now() + (initialized ? 1.0 : 0)) {
                withAnimation {
                    if self.currentStep.isMultiple(of: 2) {
                        self.evenImageName = step.image
                    } else {
                        self.oddImageName = step.image
                    }
                    if self.mainText == nil {
                        self.mainText = step.text
                    }
                    if self.stickerImageName == nil {
                        self.stickerImageName = step.sticker
                        if let center = step.stickerOffset {
                            self.stickerOffset = center
                        } else {
                            self.stickerOffset = [0,0]
                        }
                        if let scale = step.stickerScale {
                            self.stickerScale = scale
                        } else {
                            self.stickerScale = 1.0
                        }

                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                            self.offsetEffect = true
                            self.stickerOffset[1] -= 10
                        }
                    }
                }
            }
            initialized = true
        }
    }

    @Published public var evenImageName: String?
    @Published public var evenAddTransition: AnyTransition = .identity
    @Published public var evenRemoveTransition: AnyTransition = .identity

    @Published public var oddImageName: String?
    @Published public var oddAddTransition: AnyTransition = .identity
    @Published public var oddRemoveTransition: AnyTransition = .identity

    @Published public var mainText: String?
    @Published public var stickerImageName: String?
    @Published public var stickerOffset: [CGFloat] = [0, 0]
    @Published public var stickerScale: CGFloat = 1.0
    @Published public var offsetEffect = false
}
