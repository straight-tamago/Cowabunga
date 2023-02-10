//
//  OperationPlistEditView.swift
//  Cowabunga
//
//  Created by lemin on 2/10/23.
//

import SwiftUI

struct PlistModifiable: Identifiable {
    var id = UUID()
    var key: String
    var value: Any
}

struct PlistEditView: View {
    @State var plistValues: [String: Any]
    @State var plistViews: [PlistModifiable] = []
    
    var body: some View {
        VStack {
            List {
                ForEach($plistViews) { property in
                    HStack {
                        Button(action: {
                            // create and configure alert controller
                            let alert = UIAlertController(title: NSLocalizedString("Choose a value type", comment: ""), message: "", preferredStyle: .actionSheet)
                            
                            func applyType(_ value: Any) {
                                property.value.wrappedValue = value
                                plistValues[property.key.wrappedValue] = value
                            }
                            
                            // create the actions
                            let strAction = UIAlertAction(title: "String", style: .default) { (action) in
                                applyType("")
                            }
                            let intAction = UIAlertAction(title: "Int", style: .default) { (action) in
                                applyType(Int(0))
                            }
                            let doubleAction = UIAlertAction(title: "Double", style: .default) { (action) in
                                applyType(Double(0))
                            }
                            let boolAction = UIAlertAction(title: "Boolean", style: .default) { (action) in
                                applyType(false)
                            }
                            
                            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
                                // cancels the action
                            }
                            
                            // add the actions
                            alert.addAction(strAction)
                            alert.addAction(intAction)
                            alert.addAction(doubleAction)
                            alert.addAction(boolAction)
                            
                            alert.addAction(cancelAction)
                            
                            let view: UIView = UIApplication.shared.windows.first!.rootViewController!.view
                            // present popover for iPads
                            alert.popoverPresentationController?.sourceView = view // prevents crashing on iPads
                            alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0) // show up at center bottom on iPads
                            
                            // present the alert
                            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                        }) {
                            Text(String(describing: type(of: property.value.wrappedValue)))
                        }
                    }
                }
            }
        }
        .navigationTitle(NSLocalizedString("Edit Plist Values", comment: "editing operation plist keys and values"))
        .onAppear {
            for (k, v) in plistValues {
                plistViews.append(.init(key: k, value: v))
            }
        }
    }
}
