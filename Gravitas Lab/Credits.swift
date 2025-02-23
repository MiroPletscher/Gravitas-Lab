//
//  Credits.swift
//  Gravitas Lab
//
//  Created by Miro Pletscher on 23/02/25.
//

import SwiftUI

struct Credits: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Credits")
                .font(.system(size: 40))
            Text("""
Elephant: Flaticon.com
Horse: Flaticon.com
Mouse/Rat: Flaticon.com
Rocket: Flaticon.com
""")
        }
    }
}

#Preview {
    Credits()
}
