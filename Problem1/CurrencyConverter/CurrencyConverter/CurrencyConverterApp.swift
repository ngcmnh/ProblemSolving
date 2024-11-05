//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by ngminh on 05/11/2024.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    @AppStorage("isDark") var isDark = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDark ? .dark: .light)
        }
    }
}
