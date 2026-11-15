import UIKit
import Photos

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
var window: UIWindow?

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if url.scheme == "truststoreimport" {
        // تم استدعاء التطبيق من الكمبيوتر، ابدأ الاستيراد
        importPhotos()
    }
    return true
}

func importPhotos() {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let inboxURL = documentsURL.appendingPathComponent("Inbox")
    
    do {
        let files = try fileManager.contentsOfDirectory(at: inboxURL, includingPropertiesForKeys: nil)
        if files.isEmpty { return }
        
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            if status == .authorized || status == .limited {
                PHPhotoLibrary.shared().performChanges({
                    for fileURL in files {
                        if fileURL.pathExtension.lowercased() == "jpg" || fileURL.pathExtension.lowercased() == "png" || fileURL.pathExtension.lowercased() == "mp4" {
                            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                            // إضافة الفيديو مشروحة هنا (للفيديوهات)
                        }
                    }
                }) { success, error in
                    if success {
                        // مسح الملفات بعد نقلها بنجاح
                        for fileURL in files { try? fileManager.removeItem(at: fileURL) }
                        print("تم النقل بنجاح!")
                    }
                }
            }
        }
    } catch {
        print("Error reading inbox: \(error)")
    }
}
}
