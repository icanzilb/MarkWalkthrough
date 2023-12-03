// See the LICENSE file for this code's license information.

import SwiftUI
import Pow
import MarkCodable

public struct MarkWalkthroughWindow: View {
    @ObservedObject var viewModel: MarkWalkthroughModel
    @State var controlsDisabled = false

    public init(viewModel: MarkWalkthroughModel, closeAction: @escaping () -> Void) {
        self.viewModel = viewModel
        self.closeAction = closeAction
    }
    let closeAction: () -> Void

    public var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    if viewModel.currentStep.isMultiple(of: 2) {
                        if let name = viewModel.evenImageName {
                            Image(name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .transition(
                                    .asymmetric(
                                        insertion: viewModel.evenAddTransition,
                                        removal: viewModel.evenRemoveTransition
                                    )
                                )
                                .animation(.movingParts.easeInExponential(duration: 0.5), value: viewModel.evenImageName)
                        }
                    } else {
                        if let name = viewModel.oddImageName {
                            Image(name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .transition(
                                    .asymmetric(
                                        insertion: viewModel.oddAddTransition,
                                        removal: viewModel.oddRemoveTransition
                                    )
                                )
                                .animation(.movingParts.easeInExponential(duration: 0.5), value: viewModel.oddImageName)
                        }
                    }

                    if let name = viewModel.stickerImageName {
                        Image(name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 500)
                            .scaleEffect(viewModel.stickerScale, anchor: .center)
                            .offset(x: viewModel.stickerOffset[0], y: viewModel.stickerOffset[1])
                            .transition(.movingParts.flip)
                            .animation(
                                .linear(duration: 3.5)
                                .repeatForever(),
                                value: viewModel.offsetEffect
                            )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            HStack(alignment: .center, spacing: 8) {
                VStack {
                    if let text = viewModel.mainText {
                        Text(text)
                            .font(.title2)
                            .padding(.horizontal)
                            .transition(.movingParts.flip)
                            .animation(.movingParts.easeInExponential(duration: 0.5), value: viewModel.stickerImageName)
                            .frame(height: 70)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 70)

                Spacer()

                if viewModel.currentStep < viewModel.steps.count - 1 {
                    HStack {
                        Button(action: {
                            guard !controlsDisabled else { return }
                            withAnimation {
                                viewModel.currentStep -= 1
                            }
                            self.controlsDisabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.controlsDisabled = false
                            }
                        }, label: {
                            Image(systemName: "arrow.left")
                        })
                        .buttonStyle(.borderless)
                        .foregroundColor(viewModel.currentStep <= 0 ? Color.secondary : Color.accentColor)
                        .keyboardShortcut(.leftArrow, modifiers: [])

                        Text("\(viewModel.currentStep + 1)/\(viewModel.steps.count)")
                            .padding(.horizontal, 8)

                        Button(action: {
                            guard !controlsDisabled else { return }
                            withAnimation {
                                viewModel.currentStep += 1
                            }
                            self.controlsDisabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.controlsDisabled = false
                            }
                        }, label: {
                            Image(systemName: "arrow.right")
                        })
                        .buttonStyle(.borderless)
                        .foregroundColor(viewModel.currentStep >= viewModel.steps.count - 1 ? Color.secondary : Color.accentColor)
                        .keyboardShortcut(.rightArrow, modifiers: [])
                    }
                    .opacity(controlsDisabled ? 0.5 : 1.0)
                } else {
                    // Finished
                    Button(action: {
                        NSApp.keyWindow?.close()
                        closeAction()
                    }, label: {
                        Text("Close")
                            .foregroundColor(.accentColor)
                    })
                    .buttonStyle(.borderless)
                    .keyboardShortcut(.escape, modifiers: [])
                }
            }
            .frame(height: 40, alignment: .center)
            .font(.title2)
            .padding()
        }
        .padding()
        .task {
            try? await Task.sleep(for: .milliseconds(500))

            withAnimation {
                viewModel.currentStep = 0
            }
        }
    }
}
