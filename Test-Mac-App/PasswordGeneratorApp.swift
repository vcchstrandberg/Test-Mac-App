import SwiftUI

@main
struct PasswordGeneratorApp: App {
    #if os(macOS)
    @Environment(\.openWindow) private var openWindow
    #endif

    var body: some Scene {
        WindowGroup("Lösenordsgenerator") {
            ContentView()
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .help) {
                Button("Lösenordsgenerator Hjälp") {
                    openWindow(id: "hjalp")
                }
            }
        }
        #endif

        #if os(macOS)
        Window("Hjälp", id: "hjalp") {
            HelpView()
        }
        .windowResizability(.contentSize)
        #endif
    }
}
