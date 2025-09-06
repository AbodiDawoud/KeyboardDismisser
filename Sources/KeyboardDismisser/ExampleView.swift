//
//  ExampleView.swift
//  KeyboardDismisser
    

import SwiftUI

struct ExampleView: View {
    @State private var txt: String = ""
    @State private var dismissOnTapOutside: Bool = true
    
    
    var body: some View {
        Form {
            TextField("Enter text", text: $txt)
                .dismissKeyboardOnTap(active: dismissOnTapOutside)
            
            Toggle("Dismiss on Tap Outside", isOn: $dismissOnTapOutside)
        }
    }
}

#Preview {
    ExampleView()
}
