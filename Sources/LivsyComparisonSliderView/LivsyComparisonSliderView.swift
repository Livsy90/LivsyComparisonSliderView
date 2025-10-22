import SwiftUI

/// A container that overlays two views and reveals the right view with a draggable vertical divider.
/// - The left view is fully visible by default.
/// - Dragging the circular handle moves the divider horizontally, masking the right view accordingly.
/// - Use the chainable modifiers to customize the indicator (image, size, colors) and divider appearance.
public struct SliderComparisonView<Left: View, Right: View>: View {
    
    private var indicatorImage: Image = Image(systemName: "arrow.left.and.right") // Image shown inside the circular drag handle
    private var indicatorImageWidth: CGFloat = 22 // Width of the indicator image inside the handle
    private var indicatorImageColor: Color = .gray // Color of the indicator image
    private var indicatorColor: Color = .white // Fill color of the circular handle
    private var indicatorWidth: CGFloat = 44 // Diameter of the circular handle
    private var dividerColor: Color = .clear // Color of the thin divider line behind the handle
    private var dividerWidth: CGFloat = .zero // Width of the divider line
    private let lhs: () -> Left // Builder for the left (base) view
    private let rhs: () -> Right // Builder for the right (revealed) view
    
    /// Creates a slider comparison view from two view-building closures.
    /// - Parameters:
    ///   - lhs: Closure that builds the left (base) view, always fully rendered.
    ///   - rhs: Closure that builds the right view, which is revealed by dragging the divider.
    public init(
        @ViewBuilder lhs: @escaping () -> Left,
        @ViewBuilder rhs: @escaping () -> Right
    ) {
        self.lhs = lhs
        self.rhs = rhs
    }
    
    /// Current horizontal offset of the divider relative to the center.
    @State private var dividerLocation: CGFloat = .zero
    
    public var body: some View {
        // Layout both views and the draggable divider; mask the right view based on the divider position.
        GeometryReader { geometry in
            ZStack {
                Color.clear
                    .overlay {
                        lhs()
                    }
                
                Color.clear
                    .overlay {
                        rhs()
                    }
                    .mask {
                        Rectangle()
                            .offset(x: dividerLocation + geometry.size.width / 2)
                    }
                
                dividerView()
                    .offset(x: dividerLocation)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // Clamp the drag location so the handle stays within the view's bounds
                        dividerLocation = min(
                            max(gesture.location.x - geometry.size.width / 2, -geometry.size.width / 2),
                            geometry.size.width / 2
                        )
                    }
            )
        }
        .ignoresSafeArea()
    }
    
    /// Builds the divider with a circular drag handle and optional thin line.
    private func dividerView() -> some View {
        Rectangle()
            .fill(dividerColor)
            .frame(width: dividerWidth)
            .overlay {
                Circle()
                    .fill(indicatorColor)
                    .frame(width: indicatorWidth)
                    .overlay {
                        indicatorImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: indicatorImageWidth)
                            .foregroundColor(indicatorImageColor)
                    }
            }
    }
    
}

extension SliderComparisonView {
    /// Sets the image displayed inside the circular handle.
    public func indicatorImage(_ image: Image) -> Self {
        var copy = self
        copy.indicatorImage = image
        return copy
    }
    
    /// Sets the color of the image inside the handle.
    public func indicatorImageColor(_ color: Color) -> Self {
        var copy = self
        copy.indicatorImageColor = color
        return copy
    }
    
    /// Sets the width of the image inside the handle.
    public func indicatorImageWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy.indicatorImageWidth = width
        return copy
    }
    
    /// Sets the fill color of the circular handle.
    public func indicatorColor(_ color: Color) -> Self {
        var copy = self
        copy.indicatorColor = color
        return copy
    }
    
    /// Sets the diameter of the circular handle.
    public func indicatorWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy.indicatorWidth = width
        return copy
    }
    
    /// Sets the color of the thin divider line behind the handle.
    public func dividerColor(_ color: Color) -> Self {
        var copy = self
        copy.dividerColor = color
        return copy
    }
    
    /// Sets the width of the thin divider line behind the handle.
    public func dividerWidth(_ width: CGFloat) -> Self {
        var copy = self
        copy.dividerWidth = width
        return copy
    }
}

#Preview {
    // Example usage: compare two images with a black indicator icon.
    SliderComparisonView(
        lhs: { Image(.winter) },
        rhs: { Image(.spring) }
    )
    .indicatorImageColor(.black)
}
