# KeyboardDismisser
A lightweight SwiftUI helper that automatically dismisses the keyboard when users tap outside of text fields.  

---

## Requirements
- iOS **13.0+**
- Swift **5.7+**
- Xcode **14+**

---

## Usage
Apply the `tapToDismissKeyboard()` modifier to any SwiftUI view:

```swift
import SwiftUI
import KeyboardDismisser

struct ContentView: View {
 @State private var text = ""

 var body: some View {
     VStack(spacing: 20) {
         Text("Tap anywhere to dismiss the keyboard")
             .font(.headline)

         TextField("Enter text...", text: $text)
             .textFieldStyle(RoundedBorderTextFieldStyle())
             .padding()
     }
     .padding()
     .tapToDismissKeyboard()
 }
}
