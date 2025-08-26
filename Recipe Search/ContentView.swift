//
//  ContentView.swift
//  Recipe Search
//
//  Created by Dev Soni on 24/08/25.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(RecipeSearchViewModel.self) var vm
    
    // To dismiss keyboard after search
    @FocusState private var isFieldFocused: Bool
    
    var body: some View {
        @Bindable var vm = vm
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    TextField("Search recipes (e.g., pasta)", text: $vm.queryText)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .focused($isFieldFocused)
                        .onSubmit {
                            Task {
                                await vm.search()
                                isFieldFocused = false
                            }
                        }
                    Button {
                        Task {
                            await vm.search()
                            isFieldFocused = false
                        }
                    } label: {
                        Text("Search")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .disabled(vm.queryText.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty || vm.isLoading)
                }
                .padding()
                
                Group {
                    if vm.isLoading {
                        ProgressView("Searching...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding()
                    }
                    else if let message = vm.errorMessage {
                        VStack(spacing: 12) {
                            Text(message)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                            Button("Try again") {
                                Task {
                                    await vm.search()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                    }
                    else if vm.recipes.isEmpty {
                        ContentUnavailableView("Search recipes", systemImage: "fork.knife", description: Text("Type something above and serach"))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.horizontal)
                    }
                    else {
                        List(vm.recipes) { recipe in
                            HStack() {
                                AsyncImage(url: URL(string: recipe.image)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 64, height: 64)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .scaledToFit()
                                            .frame(width: 64, height: 64)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .scaledToFit()
                                            .frame(width: 64, height: 64)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                Text(recipe.title)
                                    .font(.body)
                                    .lineLimit(2)
                            }
                            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            // .listRowSeparator(.hidden)
                            // Divider()
                        }
                        .listStyle(.plain)
                    }
                }
                .animation(.default, value: vm.isLoading)
            }
            .navigationTitle("Recipe Search")
        }
    }
}

#Preview {
    ContentView()
        .environment(RecipeSearchViewModel(dataService: DataService()))
}
