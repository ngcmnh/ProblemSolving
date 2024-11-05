//
//  CurrencyPickerView.swift
//  CurrencyConverter
//
//  Created by ngminh on 05/11/2024.
//

import SwiftUI

struct CurrencyPickerView: View {
    var currencies: [String]
    @Binding var selectedCurrency: String
    @State private var searchText: String = ""
    
    var filteredCurrencies: [String] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .padding()
                
                List(filteredCurrencies, id: \.self) { currency in
                    Button(action: {
                        selectedCurrency = currency
                    }) {
                        HStack {
                            Text(currency)
                            Spacer()
                            if currency == selectedCurrency {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Select Currency", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

