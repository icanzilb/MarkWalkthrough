import SwiftUI

enum WalkthroughImageStyle {
    case none
    case screenshot
}

extension Image {
    @ViewBuilder
    func walkthroughStyle(_ style: WalkthroughImageStyle) -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .modifier(style.modifier)
    }
}

// MARK: - ViewModifier

extension WalkthroughImageStyle {
    fileprivate var modifier: some ViewModifier { StyleModifier(style: self) }
}

fileprivate struct StyleModifier: ViewModifier {
    let style: WalkthroughImageStyle

    @ViewBuilder
    func body(content: Content) -> some View {
        switch style {
        case .none:
            content
        case .screenshot:
            content.modifier(ScreenshotModifier())
        }
    }
}

fileprivate struct ScreenshotModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content.shadow(color: .init(white: 0, opacity: 0.1), radius: 20)
            .shadow(color: .init(white: 0, opacity: 0.1), radius: 8, y: 2)
    }
}
