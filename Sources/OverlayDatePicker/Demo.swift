//
//  Demo.swift
//  OverlayDatePicker
//
//  Created by David Walter on 12.03.22.
//

#if DEBUG
import SwiftUI

struct Demo: View {
    @StateObject private var viewModel = ViewModel()
    
    @State private var selectDate = false
    @State private var selectOptionalDate = false
    @State private var selectDateRange = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        selectDate = true
                    } label: {
                        Text(viewModel.date.formatted())
                    }
                } header: {
                    Text("Date")
                }
                
                Section {
                    Button {
                        selectOptionalDate = true
                    } label: {
                        Text(viewModel.optionalDate?.formatted() ?? "-")
                    }
                } header: {
                    Text("Optional Date")
                }
            }
            .navigationTitle("Demo")
            .overlay {
                // An OverlayDatePicker
                OverlayDatePicker(isPresented: $selectDate, date: viewModel.optionalDate) { date in
                    viewModel.optionalDate = date
                }
            }
            .overlay {
                // A more manual way to present an OverlayDatePicker
                if selectOptionalDate {
                    OverlayDatePicker(date: viewModel.optionalDate) { date in
                        self.selectOptionalDate = false
                        viewModel.optionalDate = date
                    }
                    .canReset(true)
                }
            }
            .overlay {
                // An OverlayDateRangePicker
                OverlayDateRangePicker(isPresented: $selectDateRange, range: viewModel.range) { range in
                    viewModel.range = range
                } footer: { range in
                    if let range = range {
                        Text("\(range)")
                    } else {
                        Text("Select two dates")
                    }
                }
            }
        }
    }
}

extension Demo {
    class ViewModel: ObservableObject {
        @Published var date: Date = .now
        @Published var optionalDate: Date?
        @Published var range: ClosedRange<Date>? = nil
    }
}

struct Demo_Previews: PreviewProvider {
    static var previews: some View {
        Demo()
    }
}
#endif
