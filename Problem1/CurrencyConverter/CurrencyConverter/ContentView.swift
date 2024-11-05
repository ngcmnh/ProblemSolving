//
//  ContentView.swift
//  CurrencyConverter
//
//  Created by ngminh on 05/11/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var amountTextFrom: String = ""
    @State private var amountTextTo: String = ""
    @State private var fromCurrency: String = "VND"
    @State private var toCurrency: String = "USD"
    @State private var convertedAmount: String = ""
    @State private var currencies: [String] = []
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showCurrencyPicker: Bool = false
    @State private var isSelectingFromCurrency: Bool = true
    @AppStorage("isDark") private var isDark = false
    
    private let currencyService = CurrencyService()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Currenct Converter")
                .font(.largeTitle)
                .bold()
                .padding()
                

            // From Amount and Currency Picker
            HStack {
                VStack(alignment: .leading) {
                    Text("From")
                    HStack {
                        TextField("Enter amount", text: $amountTextFrom)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .onChange(of: amountTextFrom) { newValue in
                                validateInput()
                            }
                        Button(action: {
                            isSelectingFromCurrency = true
                            showCurrencyPicker = true
                        }) {
                            HStack {
                                Text(fromCurrency)
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                        }
                    }
                }
            }
            .padding()
            
            // Switch Currencies
            Button(action: switchCurrencies) {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            
            // To Amount and Currency Picker
            HStack {
                VStack(alignment: .leading) {
                    Text("To")
                    HStack {
                        TextField("Converted amount", text: $amountTextTo)
                            .disabled(true)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                            .foregroundColor(.gray)
                        Button(action: {
                            isSelectingFromCurrency = false
                            showCurrencyPicker = true
                        }) {
                            HStack {
                                Text(toCurrency)
                                Image(systemName: "chevron.down")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5)
                        }
                    }
                }
            }
            .padding()

            // Convert Button
            Button(action: convertCurrency) {
                Text("Convert")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
            
            Button (action: {
                isDark.toggle()
            }, label: {
                VStack {
                    Image(systemName: isDark ? "moon.circle" : "sun.max.circle")
                        .font(.system(size:33))
                    Spacer().frame(height: 10)
                    Text(isDark ? "Dark" : "Light")
                }
            })
            .preferredColorScheme(isDark ? .dark : .light)
            
            Spacer()
        }
        .padding()
        .onAppear(perform: fetchCurrencies)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showCurrencyPicker) {
            CurrencyPickerView(currencies: currencies, selectedCurrency: isSelectingFromCurrency ? $fromCurrency : $toCurrency)
        }
    }
    
    private func fetchCurrencies() {
        currencyService.fetchAvailableCurrencies { result in
            switch result {
            case .success(let fetchedCurrencies):
                DispatchQueue.main.async {
                    self.currencies = fetchedCurrencies
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func convertCurrency() {
        guard let amount = Double(amountTextFrom) else {
            self.showError = true
            self.errorMessage = "Please enter a valid amount."
            return
        }
        
        if amount < 0 {
            self.showError = true
            self.errorMessage = "Amount cannot be negative."
            return
        }
        
        currencyService.convert(amount: amount, from: fromCurrency, to: toCurrency) { result in
            switch result {
            case .success(let convertedAmountValue):
                DispatchQueue.main.async {
                    let formattedAmount = formatNumber(convertedAmountValue)
                    self.amountTextTo = formattedAmount // Only format the result
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func switchCurrencies() {
        // Switch the currency values
        let tempCurrency = fromCurrency
        fromCurrency = toCurrency
        toCurrency = tempCurrency

        // Switch the amount values
        let tempAmount = amountTextFrom
        amountTextFrom = amountTextTo
        amountTextTo = tempAmount
    }
    
    private func validateInput() {
        // Only numeric input and one decimal point
        var cleanInput = amountTextFrom.replacingOccurrences(of: ",", with: "")
        
        // Allow only one decimal point
        let decimalCount = cleanInput.filter { $0 == "." }.count
        if decimalCount > 1 {
            cleanInput = String(cleanInput.dropLast())
        }
        
        // Update the text field with the validated input
        amountTextFrom = cleanInput
    }
    
    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 4
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
