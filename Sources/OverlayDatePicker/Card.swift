//
//  Card.swift
//  OverlayDatePicker
//
//  Created by David Walter on 12.03.22.
//
import SwiftUI

struct Card<Label>: View where Label: View {
    var color = Color(.secondarySystemGroupedBackground)
    var label: () -> Label

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            label()
        }
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    init(color: Color = Color(.tertiarySystemBackground), @ViewBuilder label: @escaping () -> Label) {
        self.color = color
        self.label = label
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Card(color: .red) {
                Text("Hello")
                    .padding()
            }
        }
    }
}
