//
//  ContentView.swift
//  StaggeredMenu
//
//  Created by Chris Eidhof on 02.11.22.
//

import SwiftUI

struct MenuAlignment: AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[HorizontalAlignment.center]
    }
}

extension HorizontalAlignment {
    static let menu = HorizontalAlignment(MenuAlignment.self)
}

struct MenuLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
                .frame(width: 40, height: 40)
                .background {
                    Circle()
                        .foregroundColor(.primary.opacity(0.1))
                }
                .alignmentGuide(.menu, computeValue: {
                    $0[HorizontalAlignment.center]
                })
        }
        .font(.footnote)
    }
}

struct Staggered: ViewModifier {
    var open: Bool
    var delay: Double

    func body(content: Content) -> some View {
        VStack {
            if open {
                content
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.default.delay(delay), value: open)
   }
}

extension View {
    func stagger(open: Bool, delay: Double) -> some View {
        modifier(Staggered(open: open, delay: delay))
    }
}

struct Menu: View {
    @State private var open = false
    var body: some View {
        VStack(alignment: .menu) {
            Label("Add Note", systemImage: "note.text")
                .stagger(open: open, delay: 1)
            Label("Add Photo", systemImage: "photo")
                .stagger(open: open, delay: 0.5)
            Label("Add Video", systemImage: "video")
                .stagger(open: open, delay: 0)
            Button {
                open.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.title)
                    .frame(width: 50, height: 50)
                    .background {
                        Circle()
                            .fill(Color.primary.opacity(0.1))
                    }
            }
        }
        .labelStyle(MenuLabelStyle())
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            Menu()
                .padding(30)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
