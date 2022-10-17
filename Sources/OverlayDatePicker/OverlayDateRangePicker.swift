//
//  OverlayDateRangePicker.swift
//  OverlayDatePicker
//
//  Created by David Walter on 13.03.22.
//

import MultiDatePicker
import SwiftUI
import UIKit

/// A control for selecting a date range in an overlay
public struct OverlayDateRangePicker<Header, Footer>: View where Header: View, Footer: View {
    var isPresented: Binding<Bool>
    var date: ClosedRange<Date>?
    
    var header: (() -> Header)?
    var footer: ((ClosedRange<Date>?) -> Footer)?
    var completion: (ClosedRange<Date>?) -> Void
    
    @State private var selection: ClosedRange<Date>?
    
    private var canReset = false
    private var range: ClosedRange<Date> = Date.distantPast ... Date.distantFuture
    private var includeDays: MultiDayPicker.DateSelectionChoices = .allDays
    
    @Environment(\.sizeCategory) var sizeCategory
    
    public var body: some View {
        if isPresented.wrappedValue {
            ZStack {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)

                Card {
                    VStack(spacing: 0) {
                        header?()

                        MultiDayPicker(dateRange: $selection,
                                       includeDays: includeDays,
                                       in: range)
                            .animate(false)
                            .padding(.top)

                        footer?(selection)
                            .padding(.bottom)
                        
                        buttons
                    }
                    .padding()
                }
                .padding()
                .transition(.scale)
            }
            .onAppear {
                UIApplication.shared.endEditing()
            }
        }
    }
    
    @ViewBuilder
    var buttons: some View {
        if sizeCategory.isAccessibilityCategory {
            vButtons
        } else {
            hButtons
        }
    }
    
    var vButtons: some View {
        VStack {
            Button {
                completion(selection)
            } label: {
                Text("OK".localized())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            if canReset {
                Button(role: .destructive) {
                    completion(nil)
                } label: {
                    Text("Reset".localized())
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Button(role: .cancel) {
                completion(date)
            } label: {
                Text("Cancel".localized())
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
    
    var hButtons: some View {
        HStack {
            if canReset {
                Button(role: .destructive) {
                    completion(nil)
                } label: {
                    Text("Reset".localized())
                        .frame(minWidth: 50)
                }
                .buttonStyle(.bordered)
            }

            Spacer()
            
            Button(role: .cancel) {
                completion(date)
            } label: {
                Text("Cancel".localized())
                    .frame(minWidth: 50)
            }
            .buttonStyle(.bordered)

            Button {
                completion(selection)
            } label: {
                Text("OK".localized())
                    .frame(minWidth: 50)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    // MARK: - Modifier
    
    /// Wether the control gives a reset option or not
    public func canReset(_ value: Bool) -> Self {
        var view = self
        view.canReset = value
        return view
    }
    
    /// The inclusive range of selectable dates.
    public func range(_ value: ClosedRange<Date>) -> Self {
        var view = self
        view.range = value
        return view
    }
    
    /// The eligible days to select
    public func includeDays(_ value: MultiDayPicker.DateSelectionChoices) -> Self {
        var view = self
        view.includeDays = value
        return view
    }
    
    // MARK: - init
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    ///     - header: A view to use as the date picker's header.
    ///     - footer: A view to use as the date picker's footer. Displays the currently selected date range
    public init(range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void,
                @ViewBuilder header: @escaping () -> Header,
                @ViewBuilder footer: @escaping (ClosedRange<Date>?) -> Footer) {
        self.isPresented = .constant(true)
        self.date = range
        _selection = State(initialValue: range)
        self.header = header
        self.footer = footer
        self.completion = completion
    }
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - isPresented: binding to a Boolean value that determines whether to present the date picker
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    ///     - header: A view to use as the date picker's header.
    ///     - footer: A view to use as the date picker's footer. Displays the currently selected date range
    public init(isPresented: Binding<Bool>,
                range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void,
                @ViewBuilder header: @escaping () -> Header,
                @ViewBuilder footer: @escaping (ClosedRange<Date>?) -> Footer) {
        self.isPresented = isPresented
        self.date = range
        _selection = State(initialValue: range)
        self.header = header
        self.footer = footer
        self.completion = {
            isPresented.wrappedValue = false
            completion($0)
        }
    }
}

extension OverlayDateRangePicker where Header == EmptyView, Footer == EmptyView {
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    public init(range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void) {
        self.isPresented = .constant(true)
        self.date = range
        _selection = State(initialValue: range)
        self.header = nil
        self.footer = nil
        self.completion = completion
    }
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - isPresented: binding to a Boolean value that determines whether to present the date picker
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    public init(isPresented: Binding<Bool>,
                range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void) {
        self.isPresented = isPresented
        self.date = range
        _selection = State(initialValue: range)
        self.header = nil
        self.footer = nil
        self.completion = {
            isPresented.wrappedValue = false
            completion($0)
        }
    }
}

extension OverlayDateRangePicker where Footer == EmptyView {
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    ///     - header: A view to use as the date picker's header.
    public init(range: ClosedRange<Date>?,
                canReset: Bool = false,
                completion: @escaping (ClosedRange<Date>?) -> Void,
                @ViewBuilder header: @escaping () -> Header) {
        self.isPresented = .constant(true)
        self.date = range
        _selection = State(initialValue: range)
        self.header = header
        self.footer = nil
        self.completion = completion
    }
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - isPresented: binding to a Boolean value that determines whether to present the date picker
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    ///     - header: A view to use as the date picker's header.
    public init(isPresented: Binding<Bool>,
                range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void,
                @ViewBuilder header: @escaping () -> Header) {
        self.isPresented = isPresented
        self.date = range
        _selection = State(initialValue: range)
        self.header = header
        self.footer = nil
        self.completion = {
            isPresented.wrappedValue = false
            completion($0)
        }
    }
}

extension OverlayDateRangePicker where Header == EmptyView {
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    ///     - footer: A view to use as the date picker's footer. Displays the currently selected date rang
    public init(range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void,
                @ViewBuilder footer: @escaping (ClosedRange<Date>?) -> Footer) {
        self.isPresented = .constant(true)
        self.date = range
        _selection = State(initialValue: range)
        self.header = nil
        self.footer = footer
        self.completion = completion
    }
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - isPresented: binding to a Boolean value that determines whether to present the date picker
    ///     - range: The initially selected date range. Defaults to `nil`
    ///     - completion: The date range selection has been completed.
    ///     - footer: A view to use as the date picker's footer. Displays the currently selected date range
    public init(isPresented: Binding<Bool>,
                range: ClosedRange<Date>?,
                completion: @escaping (ClosedRange<Date>?) -> Void,
                @ViewBuilder footer: @escaping (ClosedRange<Date>?) -> Footer) {
        self.isPresented = isPresented
        self.date = range
        _selection = State(initialValue: range)
        self.header = nil
        self.footer = footer
        self.completion = {
            isPresented.wrappedValue = false
            completion($0)
        }
    }
}

// MARK: - Previews

struct OverlayDateRangePicker_Previews: PreviewProvider {
    static var view: some View {
        NavigationView {
            List {
                ForEach(0 ..< 20) { _ in
                    Text("Some Row")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Preview")
            .overlay {
                OverlayDateRangePicker(range: nil) { _ in
                    
                } header: {
                    Text("Header")
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
    
    static var previews: some View {
        view
        
        view.preferredColorScheme(.dark)
        
        view.environment(\.sizeCategory, .extraExtraLarge)
        
        view.environment(\.sizeCategory, .accessibilityLarge)
    }
}
