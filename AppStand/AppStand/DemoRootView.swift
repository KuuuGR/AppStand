import SwiftUI

struct HeroItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let systemIcon: String
    let tagline: String
    let detail: String
}

struct WrappedHeroItem: Identifiable, Equatable {
    let id = UUID()
    let originalIndex: Int
    let content: HeroItem
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
    @State var selectedHeroIndex: Int = 0
    @State var heroPageIndex: Int = 1
    @State private var showSplash = true
    @State private var splashTaskScheduled = false

    private(set) var heroItems: [HeroItem] = [
        .init(
            title: "Arena",
            systemIcon: "trophy.fill",
            tagline: "Climb the ranked ladder",
            detail: "Challenge rival squads, earn trophies, and unlock weekly rewards tailored to your team."),
        .init(
            title: "World",
            systemIcon: "map.fill",
            tagline: "Chart new territories",
            detail: "Scout fresh zones, reveal secrets, and secure fast-travel routes for the guild."),
        .init(
            title: "Expedition",
            systemIcon: "paperplane.fill",
            tagline: "Deploy your specialists",
            detail: "Send operatives on timed missions to gather intel, materials, and rare crafting cores."),
        .init(
            title: "Calendar",
            systemIcon: "calendar",
            tagline: "Plan the week ahead",
            detail: "Sync upcoming events, seasonal quests, and collaborative raids with your crew.")
    ]

    var wrappedHeroItems: [WrappedHeroItem] {
        guard !heroItems.isEmpty else { return [] }

        let extended = [heroItems.last!] + heroItems + [heroItems.first!]

        return extended.enumerated().map { index, hero in
            let originalIndex: Int
            if index == 0 {
                originalIndex = heroItems.count - 1
            } else if index == extended.count - 1 {
                originalIndex = 0
            } else {
                originalIndex = index - 1
            }

            return WrappedHeroItem(originalIndex: originalIndex, content: hero)
        }
    }
    
    static func buildWrappedHeroItems(from items: [HeroItem]) -> [WrappedHeroItem] {
        guard !items.isEmpty else { return [] }

        let extended = [items.last!] + items + [items.first!]

        return extended.enumerated().map { index, hero in
            let originalIndex: Int
            if index == 0 {
                originalIndex = items.count - 1
            } else if index == extended.count - 1 {
                originalIndex = 0
            } else {
                originalIndex = index - 1
            }

            return WrappedHeroItem(originalIndex: originalIndex, content: hero)
        }
    }

    static func normalizedIndices(for wrappedIndex: Int, realItemCount: Int) -> (pageIndex: Int, selectedHeroIndex: Int) {
        precondition(realItemCount > 0, "realItemCount must be positive")
        let lastWrappedIndex = realItemCount + 1
        if wrappedIndex == 0 {
            return (lastWrappedIndex - 1, realItemCount - 1)
        } else if wrappedIndex == lastWrappedIndex {
            return (1, 0)
        } else {
            return (wrappedIndex, wrappedIndex - 1)
        }
    }

    var body: some View {
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
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 1) {
                    if selectedTab == .home {
                        heroRail
                    }

                    bottomBar
                }
                .padding(.horizontal, 20)
                .padding(.top, selectedTab == .home ? 1 : 12)
                .padding(.bottom, 16)
            }
        }
        .overlay {
            if showSplash {
                splashScreen
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear(perform: scheduleSplashDismissal)
        .onChange(of: heroPageIndex) { _, newValue in
            normalizeHeroPageIndex(newValue)
        }
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

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .home:
            homeContent
        default:
            placeholderContent
        }
    }

    private var homeContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(heroItems[selectedHeroIndex].title)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .accessibilityIdentifier("HomeScreenTitle")

            Text(heroItems[selectedHeroIndex].tagline)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))

            Text(heroItems[selectedHeroIndex].detail)
                .font(.body)
                .foregroundStyle(.white.opacity(0.7))
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: selectedHeroIndex)
    }

    private var placeholderContent: some View {
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

    private var stageBackground: some View {
        LinearGradient(colors: [Color.black.opacity(0.3), Color.black.opacity(0.45)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var heroRail: some View {
        TabView(selection: $heroPageIndex) {
            ForEach(Array(wrappedHeroItems.enumerated()), id: \.offset) { index, item in
                HStack(spacing: 12) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.75))

                    Image(systemName: item.content.systemIcon)
                        .font(.system(size: 22, weight: .semibold))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.white, Color.white.opacity(0.65))
                        .frame(width: 46, height: 46)
                        .background(Color.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.content.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Swipe to explore")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.65))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.14))
                )
                .padding(.horizontal, 4)
                .tag(index)
                .accessibilityIdentifier("HeroCard_\(item.content.title)")
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 88)
        .overlay(alignment: .bottom) {
            heroPageIndicator
                .padding(.bottom, 8)
        }
        .accessibilityIdentifier("HeroRail")
        .onAppear {
            guard !heroItems.isEmpty else { return }
            heroPageIndex = 1
            selectedHeroIndex = 0
        }
    }

    func normalizeHeroPageIndex(_ index: Int, immediate: Bool = false) {
        guard !wrappedHeroItems.isEmpty else { return }

        let lastWrappedIndex = wrappedHeroItems.count - 1

        if index == 0 {
            let update = {
                heroPageIndex = lastWrappedIndex - 1
                selectedHeroIndex = wrappedHeroItems[heroPageIndex].originalIndex
            }
            if immediate { update() } else { DispatchQueue.main.async(execute: update) }
        } else if index == lastWrappedIndex {
            let update = {
                heroPageIndex = 1
                selectedHeroIndex = wrappedHeroItems[heroPageIndex].originalIndex
            }
            if immediate { update() } else { DispatchQueue.main.async(execute: update) }
        } else {
            selectedHeroIndex = wrappedHeroItems[index].originalIndex
        }
    }

    var heroPageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(heroItems.indices, id: \.self) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(index == selectedHeroIndex ? Color.white : Color.white.opacity(0.35))
                    .accessibilityIdentifier("HeroIndicator_\(index)")
                    .accessibilityValue(index == selectedHeroIndex ? Text("active") : Text("inactive"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 2)
    }

    private var bottomBar: some View {
        VStack(spacing: 10) {
            Divider()
                .background(Color.white.opacity(0.25))
            HStack(spacing: 8) {
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
            .padding(.horizontal, 4)
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
                        .accessibilityIdentifier("SplashLogo")
                } else {
                    Image(systemName: "seal.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(radius: 12)
                        .accessibilityIdentifier("SplashLogo")
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
