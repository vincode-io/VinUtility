//
//  Created by Maurice Parker on 7/9/24.
//

import UniformTypeIdentifiers

public extension UTType {
	static let opml = UTType(filenameExtension: "opml", conformingTo: .xml)!
	static let markdown = UTType(filenameExtension: "md", conformingTo: .plainText)!
}
