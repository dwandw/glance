import Foundation
import JavaScriptCore
import os.log

class CodeRenderer: Renderer {
	private let binaryUrl = Bundle.main.url(forAuxiliaryExecutable: "chroma-0.7.0")
	private let cssUrl = Bundle.main.url(forResource: "code", withExtension: "css")

	override func getCssFiles() -> [URL] {
		var cssFiles = super.getCssFiles()
		if let cssUrlResolved = cssUrl {
			cssFiles.append(cssUrlResolved)
		} else {
			os_log("Could not find code stylesheet", type: .error)
		}
		return cssFiles
	}

	override func getHtml() -> String {
		guard let binaryUrlResolved = binaryUrl else {
			os_log("Could not find Chroma binary", type: .error)
			return errorHtml
		}

		let (status, stdout, stderr) = Shell.run(
			url: binaryUrlResolved,
			arguments: [fileUrl.path, "--html", "--html-only"]
		)

		guard status == 0 else {
			os_log("Chroma returned exit code %s: %s", type: .error, status, stderr ?? "")
			return errorHtml
		}

		return stdout ?? ""
	}
}