//
//  ConditionalOverlayModifier.swift
//  DrySwiftLibrary
//
//  Created by Jun Gu on 2/13/25.
//

import SwiftUI

public struct ConditionalOverlayModifier<OverlayContent: View>: ViewModifier {
    @Binding var isVisible: Bool
    let overlayContent: OverlayContent

    public func body(content: Content) -> some View {
        content
            .overlay(
                overlayContent
                    .opacity(isVisible ? 1 : 0)
            )
    }
}

extension View {
    public func conditionalOverlay<OverlayContent: View>(isVisible: Binding<Bool>, @ViewBuilder overlayContent: () -> OverlayContent) -> some View {
        self.modifier(ConditionalOverlayModifier(isVisible: isVisible, overlayContent: overlayContent()))
    }
}
