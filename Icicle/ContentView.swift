//
//  ContentView.swift
//  Icicle
//
//  Created on 6/26/23.
//

import SwiftUI

// Struct for flavors
struct Flavor: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let allergies: [String]
    let nutritionFacts: String
}

// Struct for orderItem
struct OrderItem {
    let flavor: Flavor
    let size: String
    let cone: String
    let toppings: [String]
    let price: Double
}

// Struct for TotalOrder
struct TotalOrder {
    var orderItems: [OrderItem] = []
    var subtotal: Double {
        return orderItems.reduce(0.0) { $0 + $1.price }
    }
    var total: Double {
        return subtotal
    }
}

// View for browsing flavors
struct BrowseFlavorsView: View {
    var flavors: [Flavor]
    
    var body: some View {
        // Display a list of flavors with their icons and names
        List(flavors) { flavor in
            NavigationLink(destination: FlavorDetailView(flavor: flavor)) {
                VStack {
                    // Display flavor icon
                    Image(systemName: "photo") // Replace with actual image
                        .font(.largeTitle)
                    Text(flavor.name)
                }
            }
        }
        .navigationTitle("Flavors")
    }
}

// View for flavor details
struct FlavorDetailView: View {
    var flavor: Flavor
    
    var body: some View {
        VStack {
            // Display flavor image
            Image(systemName: "photo") // Replace with actual image
                .font(.largeTitle)
            Text(flavor.name)
            Text(flavor.description)
            Text(flavor.nutritionFacts)
            // Display allergies
            ForEach(flavor.allergies, id: \.self) { allergy in
                Text(allergy)
            }
        }
        .padding()
        .navigationTitle("Flavor Details")
    }
}



// View for making an order
struct MakeOrderView: View {
    @State private var selectedFlavors: [Flavor] = []
    @State private var selectedSize: String = ""
    @State private var selectedCone: String = ""
    @State private var selectedToppings: [String] = []
    @State private var orderItems: [OrderItem] = []
    
    var flavors: [Flavor]
    var sizes: [String] = ["Kiddie", "Small", "Medium", "Large"]
    var cones: [String] = ["Sugar", "Cake", "Waffle", "Dipped Waffle", "Rainbow Waffle", "Jimmy Waffle", "Coconut Waffle"]
    var toppings: [String] = [] // Get toppings from administrator
    
    var body: some View {
        VStack {
            // Display selected flavors
            Text("Selected Flavors:")
            ForEach(selectedFlavors, id: \.name) { flavor in
                Text(flavor.name)
            }
            
            // Display flavor options
            List(flavors) { flavor in
                Button(action: {
                    // Add selected flavor to the order item
                    selectedFlavors.append(flavor)
                }) {
                    VStack {
                        // Display flavor icon
                        Image(systemName: "photo") // Replace with actual image
                            .font(.largeTitle)
                        Text(flavor.name)
                    }
                }
            }
            
            // Display size options
            Picker("Size", selection: $selectedSize) {
                ForEach(sizes, id: \.self) { size in
                    Text(size)
                }
            }
            
            // Display cone options
            Picker("Cone", selection: $selectedCone) {
                ForEach(cones, id: \.self) { cone in
                    Text(cone)
                }
            }
            
            // Display topping options
            List(toppings, id: \.self) { topping in
                Button(action: {
                    // Add selected topping to the order item
                    selectedToppings.append(topping)
                }) {
                    Text(topping)
                }
            }
            
            // Add button
            Button("Add to Cart") {
                // Create order item with selected attributes
                let orderItem = OrderItem(flavor: selectedFlavors.first!,
                                          size: selectedSize,
                                          cone: selectedCone,
                                          toppings: selectedToppings,
                                          price: 0.0) // Calculate price based on selected attributes
                
                // Add order item to cart
                orderItems.append(orderItem)
                
                // Reset selections for next order item
                selectedFlavors = []
                selectedSize = ""
                selectedCone = ""
                selectedToppings = []
            }
            
            // Cart button
            NavigationLink(destination: CartView(orderItems: orderItems)) {
                Image(systemName: "cart")
                    .font(.title)
            }
        }
        .navigationTitle("Make Order")
    }
}

// View for cart
struct CartView: View {
    var orderItems: [OrderItem]
    
    var body: some View {
        VStack {
            // Display order items in the cart
            ForEach(orderItems, id: \.flavor.name) { orderItem in
                VStack {
                    Text(orderItem.flavor.name)
                    Text(orderItem.size)
                    Text(orderItem.cone)
                    // Display toppings
                    ForEach(orderItem.toppings, id: \.self) { topping in
                        Text(topping)
                    }
                    Text("$\(orderItem.price)")
                }
                .padding()
                .border(Color.gray)
            }
            
            // Finish button
            Button("Finish") {
                // Handle payment logic here
            }
            .padding()
        }
        .navigationTitle("Cart")
    }
}

// View for other items
struct OtherItemsView: View {
    var body: some View {
        Text("Other Items")
            .navigationTitle("Other")
    }
}



// View for viewing orders
struct ViewOrdersView: View {
    var body: some View {
        Text("View Orders")
            .navigationTitle("View Orders")
    }
}

// View for generating report
struct ReportView: View {
    var body: some View {
        Text("Report")
            .navigationTitle("Report")
    }
}

// View for editing items
struct EditView: View {
    var body: some View {
        VStack {
            NavigationLink(destination: EditSectionView(section: "Flavor")) {
                Text("Flavor")
            }
            NavigationLink(destination: EditSectionView(section: "Size")) {
                Text("Size")
            }
            NavigationLink(destination: EditSectionView(section: "Cone")) {
                Text("Cone")
            }
            NavigationLink(destination: EditSectionView(section: "Toppings")) {
                Text("Toppings")
            }
            NavigationLink(destination: EditSectionView(section: "Other")) {
                Text("Other")
            }
        }
        .navigationTitle("Edit")
    }
}

// View for editing a specific section
struct EditSectionView: View {
    var section: String
    
    var body: some View {
        Text("Edit \(section)")
            .navigationTitle(section)
    }
}

// View for logging in and admin
struct LoginAdminView: View {
    @State private var password: String = ""
    @State private var loggedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Log In") {
                    if password == "IScream4IceCream" {
                        loggedIn = true
                    }
                }
                .padding()
                
                
            }
            .navigationTitle("Log In")
        }
        if loggedIn {
            AdminView() // Pass flavors array here
                .tabItem {
                    Image(systemName: "lock.open.fill")
                    Text("Unlocked")
                }
        }
    }
}



// Administrator view
struct AdminView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ViewOrdersView()) {
                    Text("View Orders")
                }
                NavigationLink(destination: ReportView()) {
                    Text("Report")
                }
                NavigationLink(destination: EditView()) {
                    Text("Edit")
                }
            }
            .navigationTitle("Administrator")
        }
    }
}

// Main app view
struct AppView: View {
    var body: some View {
        TabView {
            BrowseFlavorsView(flavors: []) // Pass flavors array here
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Browse")
                }
            
            MakeOrderView(flavors: []) // Pass flavors array here
                .tabItem {
                    Image(systemName: "cart")
                    Text("Make Order")
                }
            
            LoginAdminView() // LoginAdminView
                .tabItem {
                    Image(systemName: "lock.fill")
                    Text("Log In")
                }
        }
    }
}


