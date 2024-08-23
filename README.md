# LivsyComparisonSliderView

## SwiftUI View container for the two other Views, stacked on each other, allows users to partially or fully hide the upper View using a gesture-controlled slider.

<img src="https://github.com/Livsy90/LivsyComparisonSliderView/blob/main/LivsyComparisonViewDemo.gif" width ="300">

## Installation

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/Livsy90/LivsyComparisonSliderView.git")
]
```
## Example

```swift
import SwiftUI
import LivsyComparisonSliderView

struct ContentView: View {
    
    var body: some View {
        SliderComparisonView(
            lhs: {
                ZStack {
                    Color.purple
                    Image(systemName: "heart")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .padding()
                }
            },
            rhs: {
                ZStack {
                    Color.orange
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .padding()
                }
            }
        )
        .edgesIgnoringSafeArea(.all)
    }
}
```
