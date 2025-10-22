import SwiftUI

/// The View container for the two Views, stacked on each other, allows users to partially or fully hide the upper View using a gesture-controlled slider.
public struct SliderComparisonView<Left: View, Right: View>: View {
    
    private let indicatorImage: Image
    private let indicatorImageWidth: CGFloat
    private let indicatorImageColor: Color
    private let indicatorColor: Color
    private let indicatorWidth: CGFloat
    
    private let dividerColor: Color
    private let dividerWidth: CGFloat
    
    private let lhs: () -> Left
    private let rhs: () -> Right
    
    @State private var dividerLocation: CGFloat = .zero
    
    /// LivsyComparisonView initializer.
    /// - Parameters:
    ///   - indicatorImage: The image that will be overlaid on top of the slider indicator.
    ///   - indicatorImageColor: Slider indicator color.
    ///   - indicatorImageWidth: Slider indicator image height.
    ///   - indicatorWidth: Slider indicator height
    ///   - indicatorColor: Slider indicator color.
    ///   - dividerColor: Slider indicator divider color.
    ///   - dividerWidth: Slider indicator divider width.
    ///   - lhs: Left hand side View
    ///   - rhs: Right hand side View
    public init(
        indicatorImage: Image = Image(systemName: "arrow.left.and.right"),
        indicatorImageColor: Color = .gray,
        indicatorImageWidth: CGFloat = 22,
        indicatorWidth: CGFloat = 44,
        indicatorColor: Color = .white,
        dividerColor: Color = .clear,
        dividerWidth: CGFloat = .zero,
        lhs: @escaping () -> Left,
        rhs: @escaping () -> Right
    ) {
        self.indicatorImage = indicatorImage
        self.indicatorImageColor = indicatorImageColor
        self.indicatorImageWidth = indicatorImageWidth
        self.indicatorWidth = indicatorWidth
        self.indicatorColor = indicatorColor
        self.dividerWidth = dividerWidth
        self.dividerColor = dividerColor
        self.lhs = lhs
        self.rhs = rhs
    }
    
    public var body: some View {
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
                        dividerLocation = min(
                            max(gesture.location.x - geometry.size.width / 2, -geometry.size.width / 2),
                            geometry.size.width / 2
                        )
                    }
            )
        }
        .ignoresSafeArea()
    }
    
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
