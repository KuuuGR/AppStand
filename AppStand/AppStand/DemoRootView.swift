import SwiftUI

private struct HeroItem: Identifiable {
    let id = UUID()
    let title: String
    let systemIcon: String
}

private struct MetricCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let systemIcon: String
}

private enum DemoTab: String, CaseIterable, Identifiable {
    case home
    case units
    case items
    case shop
    case friends

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .units: return "Units"
        case .items: return "Items"
        case .shop: return "Shop"
        case .friends: return "Friends"
        }
    }

    var systemIcon: String {
        switch self {
        case .home: return "house.fill"
        case .units: return "person.3.fill"
        case .items: return "bag.fill"
        case .shop: return "cart.fill"
        case .friends: return "person.2.fill"
        }
    }
}

struct DemoRootView: View {
    let logoImageName: String?

    @State private var selectedTab: DemoTab = .home
    @State private var selectedHeroIndex: Int = 0
    @State private var showSplash = true
    @State private var splashTaskScheduled = false

    private let heroItems: [HeroItem] = [
        .init(title: "Arena", systemIcon: "trophy"),
        .init(title: "World", systemIcon: "map"),
        .init(title: "Expedition", systemIcon: "paperplane"),
        .init(title: "Calendar", systemIcon: "calendar"),
        .init(title: "Weather", systemIcon: "cloud.sun"),
        .init(title: "Luck", systemIcon: "sparkles"),
        .init(title: "Balcony", systemIcon: "building.columns")
    ]

    private let metrics: [MetricCard] = [
        .init(title: "Gold", value: "7.5M", systemIcon: "creditcard"),
        .init(title: "Gems", value: "31.6K", systemIcon: "diamond"),
        .init(title: "Rank", value: "63", systemIcon: "rosette")
    ]

    var body: some View {
        ZStack {
            NavigationStack {
                ZStack(alignment: .top) {
                    background

                    VStack(spacing: 20) {
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(stageBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 28, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.12))
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 16)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 12)
                }
                .navigationTitle("Vortex")
                .toolbarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("AppStand")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.9))
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Inbox tapped")
                        } label: {
                            Image(systemName: "tray.fill")
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("Menu tapped")
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
                .safeAreaInset(edge: .top, spacing: 0) {
                    topStats
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    bottomBar
                        .padding(.horizontal, 20)
                }
            }

            if showSplash {
                splashScreen
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear(perform: scheduleSplashDismissal)
    }

    private var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 32/255, green: 38/255, blue: 68/255),
                Color(red: 54/255, green: 20/255, blue: 70/255)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var playerStats: some View {
        LazyHGrid(rows: [GridItem(.flexible(minimum: 60))], spacing: 12) {
            ForEach(metrics) { metric in
                VStack(alignment: .leading, spacing: 8) {
                    Label(metric.title, systemImage: metric.systemIcon)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.75))
                        .labelStyle(.titleAndIcon)
                    Text(metric.value)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 66)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.14))
                )
            }
        }
    }

    private var topStats: some View {
        VStack(spacing: 12) {
            handleBar
            playerStats
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 12)
        .background(.ultraThinMaterial)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.white.opacity(0.2))
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }

    private var handleBar: some View {
        Capsule()
            .fill(Color.white.opacity(0.4))
            .frame(width: 38, height: 4)
            .padding(.top, 4)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .home:
            VStack(alignment: .leading, spacing: 16) {
                Text("Featured Destinations")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 20)

                Text("Stay on top of the world with curated objectives and limited-time adventures.")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.75))

                heroRail

                Spacer()
            }
            .padding(.horizontal, 20)
        default:
            VStack(spacing: 16) {
                Image(systemName: selectedTab.systemIcon)
                    .symbolRenderingMode(.hierarchical)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.white.opacity(0.08), in: Circle())

                Text("No content yet for \(selectedTab.title)")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)

                Text("Use this space to mock the experience with SwiftUI components while iterating on BarsKit replacement views.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.top, 32)
        }
    }

    private var heroRail: some View {
        TabView(selection: $selectedHeroIndex) {
            ForEach(Array(heroItems.enumerated()), id: \.offset) { index, item in
                VStack(spacing: 16) {
                    LinearGradient(colors: [Color.white.opacity(0.22), Color.white.opacity(0.05)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .mask(
                            RoundedRectangle(cornerRadius: 26, style: .continuous)
                                .frame(height: 220)
                        )
                        .overlay(
                            VStack(spacing: 16) {
                                Image(systemName: item.systemIcon)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.white, Color.white.opacity(0.6))
                                    .font(.system(size: 54, weight: .semibold))
                                    .padding()
                                    .background(Color.white.opacity(0.12), in: Circle())

                                Text(item.title.uppercased())
                                    .font(.headline)
                                    .foregroundStyle(.white)
                            }
                            .padding(.vertical, 32)
                        )
                        .padding(.horizontal, 12)
                }
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [Color(red: 148/255, green: 87/255, blue: 235/255).opacity(0.7),
                                 Color(red: 75/255, green: 123/255, blue: 236/255).opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .padding(.horizontal, 12)
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 320)
    }

    private var stageBackground: some View {
        LinearGradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var bottomBar: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.25))
            HStack(spacing: 12) {
                ForEach(DemoTab.allCases) { tab in
                    Button {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: tab.systemIcon)
                                .font(.system(size: 20, weight: .semibold))
                                .symbolVariant(selectedTab == tab ? .fill : .none)
                            Text(tab.title)
                                .font(.caption2.weight(.medium))
                        }
                        .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.6))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if selectedTab == tab {
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(Color.white.opacity(0.18))
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 10)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.black.opacity(0.28), radius: 20, x: 0, y: -10)
    }

    private var splashScreen: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 16) {
                if let logoImageName,
                   UIImage(named: logoImageName) != nil {
                    Image(logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .shadow(radius: 12)
                } else {
                    Image(systemName: "seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(radius: 12)
                }

                Text("Welcome")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(40)
        }
    }

    private func scheduleSplashDismissal() {
        guard !splashTaskScheduled else { return }
        splashTaskScheduled = true

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation(.easeOut(duration: 0.35)) {
                showSplash = false
            }
        }
    }
}

#Preview {
    DemoRootView(logoImageName: "AppIcon")
}
