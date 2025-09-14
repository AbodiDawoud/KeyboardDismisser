//
//  KeyboardDismisser.swift
//
//  Provides a SwiftUI-friendly way to dismiss the keyboard
//  when users tap outside of a text field.
//


import SwiftUI


/// A helper class that automatically dismisses the keyboard
/// when the user taps outside of a text field.
///
/// This class listens for keyboard show/hide events and
/// attaches a tap gesture to the main window while the
/// keyboard is visible.
@MainActor
public final class KeyboardDismisser {
    // A unique string used to identify the tap gesture recognizer added to the window.
    private let gestureIdentifier = "KeyboardTapGesture"
    
    /// Initializes the dismisser and starts listening for keyboard events.
    public init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIWindow.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIWindow.keyboardDidHideNotification,
            object: nil
        )
    }
    
    /// Called when the keyboard appears.
    /// Adds a tap gesture recognizer to the window if not already present.
    @objc private func keyboardDidShow() {
        if keyWindow.gestureRecognizers?.contains(where: { $0.name == gestureIdentifier }) ?? false { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.name = gestureIdentifier
        keyWindow.addGestureRecognizer(tapGesture)
    }

    /// Called when the keyboard disappears.
    /// Removes the previously added tap gesture recognizer.
    @objc private func keyboardDidHide() {
        if keyWindow.gestureRecognizers?.contains(where: { $0.name == gestureIdentifier }) ?? false {
            keyWindow.gestureRecognizers!.removeLast()
        }
    }
    
    /// Dismisses the keyboard by ending editing on the key window.
    @objc private func endEditing() {
        keyWindow.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidHideNotification, object: nil)
    }
    
    private var keyWindow: UIWindow {
        let windowScene = UIApplication.shared.connectedScenes
            .filter { $0 is UIWindowScene }
            .first as! UIWindowScene
        
        return windowScene.windows.first ?? UIWindow()
    }
}

/// A SwiftUI `ViewModifier` that attaches a `KeyboardDismisser`.
private struct KeyboardDismisserViewModifier: ViewModifier {
    let dismisser: KeyboardDismisser?
    
    init(_ active: Bool) {
        self.dismisser = active ? KeyboardDismisser() : nil
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    /// Adds tap-to-dismiss functionality for the keyboard.
    ///
    /// By applying this modifier, any tap outside of a text field
    /// will automatically dismiss the keyboard.
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     TextField("Type here", text: $text)
    /// }
    /// .tapToDismissKeyboard()
    /// ```
    ///
    /// - Parameter active: Enables or disables the behavior. Default is `true`.
    /// - Returns: A modified view that dismisses the keyboard when tapped outside.
    public func dismissKeyboardOnTap(active: Bool = true) -> some View {
        modifier(KeyboardDismisserViewModifier(active))
    }
}
