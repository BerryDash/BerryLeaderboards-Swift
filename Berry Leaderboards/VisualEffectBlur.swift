//
//  VisualEffectBlur.swift
//  BerryLeaderboards
//
//  Created by Lncvrt on 6/9/25.
//

import SwiftUI

#if os(macOS)
struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.material = .underWindowBackground
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
#endif
