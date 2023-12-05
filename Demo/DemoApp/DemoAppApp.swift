import SwiftUI
import MarkWalkthrough

@main
struct DemoAppApp: App {
    let viewModel = try! MarkWalkthroughModel(
        from: Bundle.main.url(forResource: "Walkthrough", withExtension: "md")!
    )

    var body: some Scene {
        WindowGroup {
            MarkWalkthroughWindow(viewModel: viewModel, closeAction: {
                // When the walkthrough is completed:
                NSSound(named: "Morse")!.play()
            })
            .background(Color("BackgroundColor"))
            .frame(width: 650, height: 500, alignment: .top)
            .walkthroughImageStyle(.screenshot)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
