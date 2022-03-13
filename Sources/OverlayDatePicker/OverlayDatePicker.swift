//
//  OverlayDatePicker.swift
//  OverlayDatePicker
//
//  Created by David Walter on 12.03.22.
//

import SwiftUI
import UIKit

/// A control for selecting an absolute date in an overlay
public struct OverlayDatePicker<Header>: View where Header: View {
    var isPresented: Binding<Bool>
    var date: Date?
    var header: (() -> Header)?
    var completion: (Date?) -> Void

    @State private var selection: Date
    private var canReset = false

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
                        
                        DatePicker("Date".localized(), selection: $selection, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                        
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
    
    public func canReset(_ value: Bool) -> Self {
        var view = self
        view.canReset = value
        return view
    }
    
    // MARK: - init
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - date: The initially selected date. Defaults to now
    ///     - completion: The date selection has been completed.
    ///     - header: A view to use as the date picker's header.
    public init(date: Date?,
                initialDate: Date = .now,
                completion: @escaping (Date?) -> Void,
                @ViewBuilder header: @escaping () -> Header) {
        self.isPresented = .constant(true)
        self.date = date
        _selection = State(initialValue: date ?? initialDate)
        self.header = header
        self.completion = completion
    }
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - isPresented: binding to a Boolean value that determines whether to present the date picker
    ///     - date: The initially selected date. Defaults to now
    ///     - completion: The date selection has been completed.
    ///     - header: A view to use as the date picker's header.
    public init(isPresented: Binding<Bool>,
                date: Date?,
                initialDate: Date = .now,
                completion: @escaping (Date?) -> Void,
                @ViewBuilder header: @escaping () -> Header) {
        self.isPresented = isPresented
        self.date = date
        _selection = State(initialValue: date ?? initialDate)
        self.header = header
        self.completion = {
            isPresented.wrappedValue = false
            completion($0)
        }
    }
}

extension OverlayDatePicker where Header == EmptyView {
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - date: The initially selected date. Defaults to now
    ///     - completion: The date selection has been completed.
    public init(date: Date?,
                initialDate: Date = .now,
                completion: @escaping (Date?) -> Void) {
        self.isPresented = .constant(true)
        self.date = date
        _selection = State(initialValue: date ?? initialDate)
        self.header = nil
        self.completion = completion
    }
    
    /// Creates an instance that selects a `Date`.
    ///
    /// - Parameters:
    ///     - isPresented: binding to a Boolean value that determines whether to present the date picker
    ///     - date: The initially selected date. Defaults to now
    ///     - completion: The date selection has been completed.
    public init(isPresented: Binding<Bool>,
                date: Date?,
                initialDate: Date = .now,
                completion: @escaping (Date?) -> Void) {
        self.isPresented = isPresented
        self.date = date
        _selection = State(initialValue: date ?? initialDate)
        self.header = nil
        self.completion = {
            isPresented.wrappedValue = false
            completion($0)
        }
    }
}

struct OverlayDatePicker_Previews: PreviewProvider {
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
                OverlayDatePicker(date: nil) { _ in
                    
                } header: {
                    Text("Header")
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
