import SwiftUI

public enum WalkthroughImageStyleEnvironmentKey: EnvironmentKey {
    public static var defaultValue: WalkthroughImageStyle = .none
}

extension EnvironmentValues {
    public var walkthroughImageStyle: WalkthroughImageStyle {
        get { self[WalkthroughImageStyleEnvironmentKey.self] }
        set { self[WalkthroughImageStyleEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Sets the ``WalkthroughImageStyle`` in the environment to `newStyle`.
    @inlinable
    @ViewBuilder
    public func walkthroughImageStyle(_ newStyle: WalkthroughImageStyle) -> some View {
        environment(\.walkthroughImageStyle, newStyle)
    }
}

extension Scene {
    /// Sets the ``WalkthroughImageStyle`` in the environment to `newStyle`.
    @inlinable
    @SceneBuilder
    public func walkthroughImageStyle(_ newStyle: WalkthroughImageStyle) -> some Scene {
        self.environment(\.walkthroughImageStyle, newStyle)
    }
}


// MARK: -

public enum WalkthroughImageStyle {
    /// Shows the image to fit the window without any decoration.
    case none

    /// Shows the image to fit the window with a drop shadow, ideal for app screenshots.
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
