import UIKit

class ViewController: UIViewController {
override func viewDidLoad() {
super.viewDidLoad()
view.backgroundColor = .black

    let logoImageView = UIImageView(image: UIImage(named: "logo")) // حط صورتك في مجلد Assets
    logoImageView.contentMode = .scaleAspectFit
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(logoImageView)
    
    let label = UILabel()
    label.text = "TRUST STORE\nجاري استيراد الصور..."
    label.textColor = .yellow
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
        logoImageView.widthAnchor.constraint(equalToConstant: 150),
        logoImageView.heightAnchor.constraint(equalToConstant: 150),
        
        label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
}
}
