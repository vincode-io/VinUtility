//
//  Zavala
//
//  Created by Maurice Parker on 3/5/21.
//
#if canImport(UIKit)
import UIKit

public extension UIColor {

	static let definedAccentColor = UIColor(named: "AccentColor")!

	static var accentColor: UIColor {
		guard let systemAccentColorNumber = UserDefaults.standard.string(forKey: "AppleAccentColor") else {
			return .definedAccentColor
		}
		
		switch systemAccentColorNumber {
		case "-1": return .systemGray
		case "0": return .systemRed
		case "1": return .systemOrange
		case "2": return .systemYellow
		case "3": return .systemGreen
		case "4": return .systemBlue
		case "5": return .systemPurple
		case "6": return .systemPink
		default: return .definedAccentColor
		}
	}
	
	static var highlightColor: UIColor {
		guard let systemHighlightColor = UserDefaults.standard.string(forKey: "AppleHighlightColor"),
			  let colorName = systemHighlightColor.components(separatedBy: " ").last else { return .accentColor }
		
		guard colorName != "Graphite" else { return UIColor.systemGray }
		
		let selector = NSSelectorFromString(NSString.localizedStringWithFormat("system%@Color", colorName) as String)
		guard UIColor.responds(to: selector) else { return .accentColor }
		return UIColor.perform(selector).takeUnretainedValue() as? UIColor ?? .accentColor
	}
	
	var isDefinedAccentColor: Bool {
		return self == UIColor.definedAccentColor
	}
	
	func asImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image(actions: { (context) in
			context.cgContext.setFillColor(cgColor)
			context.fill(.init(origin: .zero, size: size))
		})
	}
	
	/**
	 Create a lighter color
	 */
	func brighten(by percentage: CGFloat = 30.0) -> UIColor {
		return self.adjustBrightness(by: abs(percentage))
	}
	
	/**
	 Create a darker color
	 */
	func darken(by percentage: CGFloat = 30.0) -> UIColor {
		return self.adjustBrightness(by: -abs(percentage))
	}
	
}

// MARK: Helpers

private extension UIColor {

	/**
	 Try to increase brightness or decrease saturation
	 See: https://stackoverflow.com/a/42381754
	 */
	func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
		var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
			if b < 1.0 {
				let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
				return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
			} else {
				let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
				return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
			}
		}
		return self
	}
	
}

#endif
