// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  KeyboardDismisser.swift


import SwiftUI


/// By initializing this class, the user can click anywhere to dismiss the keyboard
@MainActor
public final class KeyboardDismisser {
    private let gestureIdentifier = "KeyboardTapGesture"
    
    init() {
        // Register for keyboard notifications
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
        
        print("KeyboardDismisser: Activated")
    }
    
    /// Handles keyboard showing
    @objc private func keyboardDidShow() {
        if keyWindow.gestureRecognizers?.contains(where: { $0.name == gestureIdentifier }) ?? false { return }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tapGesture.name = gestureIdentifier
        keyWindow.addGestureRecognizer(tapGesture)
        print("KeyboardDismisser: Added Gesture")
    }

    /// Handles keyboard hiding
    @objc private func keyboardDidHide() {
        if keyWindow.gestureRecognizers?.contains(where: { $0.name == gestureIdentifier }) ?? false {
            keyWindow.gestureRecognizers!.removeLast()
            print("KeyboardDismisser: Removed Gesture")
        }
        
        print("KeyboardDismisser: No Gesture Found")
    }
    
    /// Dismisses the keyboard from the user screen
    @objc func endEditing() {
        keyWindow.endEditing(true)
        print("KeyboardDismisser: End Editing")
    }
    
    deinit {
        // Unregister from keyboard visibility notifications
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidHideNotification, object: nil)
    }
    
    private var keyWindow: UIWindow {
        let windowScene = UIApplication.shared.connectedScenes
            .filter { $0 is UIWindowScene }
            .first as! UIWindowScene
        
        return windowScene.windows[0]
    }
}


struct KeyboardDismisserViewModifier: ViewModifier {
    let dismisser: KeyboardDismisser?
    
    init(_ active: Bool) {
        self.dismisser = active ? KeyboardDismisser() : nil
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    public func dismissKeyboardOnTap(active: Bool = true) -> some View {
        modifier(KeyboardDismisserViewModifier(active))
    }
}
