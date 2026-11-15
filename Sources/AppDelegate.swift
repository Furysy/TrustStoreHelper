import UIKit
import Photos

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // إعداد النافذة الرئيسية والواجهة
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        // إنشاء مجلد Inbox فور فتح التطبيق
        let fileManager = FileManager.default
        if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let inboxURL = documentsURL.appendingPathComponent("Inbox")
            try? fileManager.createDirectory(at: inboxURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        return true
    }

    // استقبال الرابط من الكمبيوتر (URL Scheme)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "truststoreimport" {
            importPhotos()
        }
        return true
    }
    
    func importPhotos() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let inboxURL = documentsURL.appendingPathComponent("Inbox")
        
        do {
            let files = try fileManager.contentsOfDirectory(at: inboxURL, includingPropertiesForKeys: nil)
            if files.isEmpty { return }
            
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized || status == .limited {
                    PHPhotoLibrary.shared().performChanges({
                        for fileURL in files {
                            let ext = fileURL.pathExtension.lowercased()
                            if ext == "jpg" || ext == "png" || ext == "heic" {
                                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                            } else if ext == "mp4" || ext == "mov" {
                                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                            }
                        }
                    }) { success, error in
                        if success {
                            for fileURL in files { try? fileManager.removeItem(at: fileURL) }
                        }
                    }
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
}
