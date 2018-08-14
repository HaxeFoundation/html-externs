import datetime
import os
import re
import string
import sys
import textwrap

from WebIDL import *

RESERVED_WORDS = set([
	"abstract", "as", "boolean", "break", "byte", "case", "catch", "char", "class", "continue", "const",
	"debugger", "default", "delete", "do", "double", "else", "enum", "export", "extends", "false", "final",
	"finally", "float", "for", "function", "goto", "if", "implements", "import", "in", "instanceof", "int",
	"interface", "is", "let", "long", "namespace", "native", "new", "null", "package", "private", "protected",
	"public", "return", "short", "static", "super", "switch", "synchronized", "this", "throw", "throws",
	"transient", "true", "try", "typeof", "use", "var", "void", "volatile", "while", "with", "yield", "inline"
])

WHITELIST = set([
	"Console",
])

BLACKLIST = set([
	"CallsList",
	"Promise",
	"LegacyMozTCPSocket",
	"PushManagerImpl",
	"APZTestData",
	"APZBucket",
	"APZHitResult",
	"WebExtensionContentScriptInit",
	"TreeView",
	"TreeBoxObject",
	# blacklist webgpu files for now (remove these when WebGPU is ready)
	"WebGPUBufferBinding",
	"WebGPUBindGroupBinding",
	"WebGPUBinding",
	"WebGPUBlendDescriptor",
	"WebGPUExtensions",
	"WebGPUPipelineStageDescriptor",
	"WebGPUPowerPreference",
	"WebGPURenderPassAttachmentDescriptor",
	"WebGPUStencilStateFaceDescriptor",
	"WebGPUVertexAttributeDescriptor",
	"WebGPUVertexInputDescriptor",
	"InstallTrigger",
	"VoidCallback",
])

PREFS = set([
	"beacon.enabled",
	"canvas.customfocusring.enabled",
	"canvas.filters.enabled",
	"canvas.focusring.enabled",
	"canvas.hitregions.enabled",
	"canvas.path.enabled",
	"dom.animations-api.core.enabled",
	"dom.battery.enabled",
	"dom.gamepad.enabled",
	"dom.webaudio.enabled",
	"dom.image.picture.enabled",
	"dom.image.srcset.enabled",
	"dom.imagecapture.enabled",
	"dom.w3c_pointer_events.enabled",
	"dom.webcrypto.enabled",
	"dom.webnotifications.enabled",
	"dom.workers.sharedWorkers.enabled",
	"geo.enabled",
	"layout.css.DOMMatrix.enabled",
	"layout.css.DOMPoint.enabled",
	"layout.css.DOMQuad.enabled",
	"layout.css.convertFromNode.enabled",
	"layout.css.font-loading-api.enabled",
	"media.eme.enabled",
	"media.mediasource.enabled",
	"media.track.enabled",
	"media.webspeech.recognition.enable", # sic
	"media.webspeech.synth.enabled",
	"media.webvtt.enabled",
	"media.webvtt.regions.enabled",
	"svg.svg-iframe.enabled",
	# "dom.identity.enabled",
	"media.peerconnection.enabled",
	"media.peerconnection.identity.enabled",

	"media.peerconnection.dtmf.enabled",
	"media.peerconnection.remoteTrackId.enabled",
	"media.peerconnection.rtpsourcesapi.enabled",
	"media.ondevicechange.enabled",

	"webgl.enable-webgl2",

	"canvas.capturestream.enabled"
])

FUNCS = set([
	"TextTrackRegion::RegionsEnabled",
	"mozilla::dom::EventSource::PrefEnabled",
	"mozilla::dom::MediaSource::Enabled",
	"mozilla::dom::Notification::PrefEnabled",
	"mozilla::dom::Touch::PrefEnabled",
	"mozilla::dom::TouchEvent::PrefEnabled",
	"mozilla::dom::TouchList::PrefEnabled",
	"mozilla::dom::WebSocket::PrefEnabled",
	"mozilla::dom::workers::WorkerPrivate::WorkerAvailable",
	"mozilla::dom::DOMPrefs::FetchObserverEnabled",
	"mozilla::dom::DOMPrefs::ServiceWorkersEnabled",
	"nsDocument::IsWebAnimationsEnabled",
	"nsDocument::IsWebComponentsEnabled",
	"nsDocument::AreWebAnimationsTimelinesEnabled",
	"nsDocument::IsWebAnimationsGetAnimationsEnabled",
	"nsDocument::IsShadowDOMEnabled",
	"nsGenericHTMLElement::TouchEventsEnabled",
	# "mozilla::dom::OffscreenCanvas::PrefEnabled",
	"mozilla::dom::OffscreenCanvas::PrefEnabledOnWorkerThread",
	"SpeechRecognition::IsAuthorized",
	"mozilla::dom::ServiceWorkerRegistrationVisible",
	"mozilla::dom::workers::ServiceWorkerVisible",
	"HTMLInputElement::ValueAsDateEnabled",
	"ServiceWorkerVisible",
])

# Types that are renamed, but still have their @:native pointing to the original name
ALIASES = {
	"Element": "DOMElement",
	"HTMLElement": "Element",
}

# Types that are completely renamed from one thing to another, including the @:native
RENAMES = {
	"OfflineResourceList": "ApplicationCache",
}

# Whitelisted moz-prefixed APIs
ALLOWED_MOZ_PREFIXES = [
	re.compile("(on)?moz.*pointerlock.*", re.IGNORECASE),
	# re.compile("mozImageSmoothingEnabled"),
	# re.compile("mozMovement[XY]"),
]

HTML_ELEMENTS = {
	"AnchorElement": "a",
	# "AppletElement": "applet",
	"AreaElement": "area",
	"AudioElement": "audio",
	"BaseElement": "base",
	# "BaseFontElement": "basefont",
	"BodyElement": "body",
	"BRElement": "br",
	"ButtonElement": "button",
	"CanvasElement": "canvas",
	# "ContentElement": "content",
	"DataListElement": "datalist",
	# "DetailsElement": "details",
	"DirectoryElement": "dir",
	"DivElement": "div",
	"DListElement": "dl",
	# "Element",
	"EmbedElement": "embed",
	"FieldSetElement": "fieldset",
	"FontElement": "font",
	"FormElement": "form",
	"FrameElement": "frame",
	"FrameSetElement": "frameset",
	"HeadElement": "head",
	# "HeadingElement"
	"HRElement": "hr",
	"HtmlElement": "html",
	"IFrameElement": "iframe",
	"ImageElement": "img",
	"InputElement": "input",
	# "KeygenElement": "keygen",
	"LabelElement": "label",
	"LegendElement": "legend",
	"LIElement": "li",
	"LinkElement": "link",
	"MapElement": "map",
	# "MarqueeElement": "marquee",
	"MediaElement": "media",
	"MenuElement": "menu",
	"MetaElement": "meta",
	"MeterElement": "meter",
	"ModElement": "mod",
	"ObjectElement": "object",
	"OListElement": "ol",
	"OptGroupElement": "optgroup",
	"OptionElement": "option",
	"OutputElement": "output",
	"ParagraphElement": "p",
	"ParamElement": "param",
	"PictureElement": "picture",
	"PreElement": "pre",
	"ProgressElement": "progress",
	"QuoteElement": "quote",
	"ScriptElement": "script",
	"SelectElement": "select",
	# "ShadowElement": "shadow",
	"SourceElement": "source",
	"SpanElement": "span",
	"StyleElement": "style",
	"TableCaptionElement": "caption",
	"TableCellElement": "td",
	"TableColElement": "col",
	"TableElement": "table",
	"TableRowElement": "tr",
	"TableSectionElement": "thead",
	"TextAreaElement": "textarea",
	"TitleElement": "title",
	"TrackElement": "track",
	"UListElement": "ul",
	# "UnknownElement",
	"VideoElement": "video",
}

class PackageGroup:
	def __init__ (self, names, removePrefix=None):
		self.names = set(names)
		self.removePrefix = removePrefix

PACKAGES = {
	# http://www.w3.org/TR/webaudio/
	"audio": PackageGroup([
		"AnalyserNode",
		"AudioBuffer",
		"AudioBufferSourceNode",
		"AudioContext",
		"AudioDestinationNode",
		"AudioListener",
		"AudioNode",
		"AudioParam",
		"AudioProcessingEvent",
		"BiquadFilterNode",
		"BiquadFilterType",
		"ChannelCountMode",
		"ChannelInterpretation",
		"ChannelMergerNode",
		"ChannelSplitterNode",
		"ConvolverNode",
		"DelayNode",
		"DistanceModelType",
		"DynamicsCompressorNode",
		"GainNode",
		"MediaElementAudioSourceNode",
		"MediaStreamAudioDestinationNode",
		"MediaStreamAudioSourceNode",
		"OfflineAudioCompletionEvent",
		"OfflineAudioContext",
		"OscillatorNode",
		"OscillatorType",
		"OverSampleType",
		"PannerNode",
		"PanningModelType",
		"PeriodicWave",
		"ScriptProcessorNode",
		"StereoPannerNode",
		"WaveShaperNode",
		# new as of aug 2018
		"AnalyserOptions",
		"AudioBufferOptions",
		"AudioBufferSourceOptions",
		"AudioContextOptions",
		"AudioScheduledSourceNode",
		"BiquadFilterOptions",
		"ChannelMergerOptions",
		"ChannelSplitterOptions",
		"ConstantSourceNode",
		"ConstantSourceOptions",
		"ConvolverOptions",
		"DelayOptions",
		"DynamicsCompressorOptions",
		"GainOptions",
		"IIRFilterNode",
		"IIRFilterOptions",
		"MediaElementAudioSourceOptions",
		"MediaStreamAudioSourceOptions",
		"OfflineAudioContextOptions",
		"OscillatorOptions",
		"PannerOptions",
		"PeriodicWaveOptions",
		"StereoPannerOptions",
		"WaveShaperOptions",
		"AudioParamMap",
		"AudioWorklet",
		"AudioWorkletGlobalScope",
		"AudioWorkletNode",
		"AudioWorkletProcessor",
		"BaseAudioContext",
		"AudioContextState",
		"AudioNodeOptions",
		"AudioWorkletNodeOptions",
		"PeriodicWaveConstraints",
	]),
	"rtc": PackageGroup([
		"DataChannel",
	]),
	"eme": PackageGroup([
		"KeyIdsInitData",
		"MediaEncryptedEvent",
		"MediaKeyError",
		"MediaKeyMessageEvent",
		"MediaKeys",
		"MediaKeySession",
		"MediaKeyStatusMap",
		"MediaKeySystemAccess",
		"MediaKeyNeededEventInit",
		"MediaKeyMessageType",
		"MediaKeyMessageEventInit",
		"MediaKeySessionType",
		"MediaKeysPolicy",
		"MediaKeyStatus",
		"MediaKeysRequirement",
		"MediaKeySystemMediaCapability",
		"MediaKeySystemConfiguration",
	])
}

class Program ():
	idls = None
	cssProperties = []

	def __init__ (self, idls):
		self.idls = idls

	def generate (self, outputDir):
		knownTypes = []
		for idl in self.idls:
			if isinstance(idl, IDLInterface) or \
					isinstance(idl, IDLEnum) or \
					isinstance(idl, IDLDictionary) and isAvailable(idl):
				knownTypes.append(stripTrailingUnderscore(idl.identifier.name))

		usedTypes = set()
		for idl in self.idls:
			if (isinstance(idl, IDLInterface)) and isAvailable(idl):
				usedTypes |= checkUsage(idl)

		# expand used types along edges (check usage of references)
		# this is a simple fix to avoid cycles when expanding references
		usedTypeReferenceDistance = 3
		for number in range(usedTypeReferenceDistance):
			for idl in self.idls:
				if (isinstance(idl, IDLInterface) or \
						isinstance(idl, IDLEnum) or \
						isinstance(idl, IDLDictionary)) and \
						stripTrailingUnderscore(idl.identifier.name) in usedTypes:
					usedTypes |= checkUsage(idl)

		def addDictParent(idl):
			if idl.parent:
				usedTypes.add(idl.parent.identifier.name)
				addDictParent(idl.parent)

		for idl in self.idls:
			if isinstance(idl, IDLDictionary) and stripTrailingUnderscore(idl.identifier.name) in usedTypes:
				addDictParent(idl)

		# Discard all implemented interfaces
		for idl in self.idls:
			if isinstance(idl, IDLImplementsStatement) and idl.implementee.getExtendedAttribute("NoInterfaceObject"):
				usedTypes.discard(idl.implementee.identifier.name)

		for idl in self.idls:
			if (isinstance(idl, IDLInterface) or \
					isinstance(idl, IDLEnum) or \
					isinstance(idl, IDLDictionary)) and \
					stripTrailingUnderscore(idl.identifier.name) in usedTypes:

				if (isAvailable(idl)):
					generate(idl, usedTypes, knownTypes, self.cssProperties, outputDir)
				else:
					# report if used type is unavailable due to feature setting
					if not isBlacklisted(idl):
						if hasattr(idl, "getExtendedAttribute"):
							pref = idl.getExtendedAttribute("Pref")
							func = idl.getExtendedAttribute("Func")
							if isDisabled(pref, PREFS) or isDisabled(func, FUNCS):
								print('> Warning: Type "%s" requires Pref "%s", Func "%s"' % (idl.identifier.name, pref, func))

# Return all the types used by this IDL
def checkUsage (idl):
	used = set()

	if isinstance(idl, IDLInterface):
		def isAvailableRecursive (idl):
			if not isAvailable(idl):
				return False
			if idl.parent:
				return isAvailableRecursive(idl.parent)
			return True
		if not isAvailableRecursive(idl):
			return used

		used |= checkUsage(idl.identifier)
		if idl.parent:
			used |= checkUsage(idl.parent)

		for member in idl.members:
			if isAvailable(member):
				used |= checkUsage(member)
		used |= checkUsage(idl.ctor())

	elif isinstance(idl, IDLDictionary):
		used |= checkUsage(idl.identifier)

		for member in idl.members:
			if isAvailable(member):
				used |= checkUsage(member)

	elif isinstance(idl, IDLCallbackType):
		callback = idl.callback
		returnType, arguments = callback.signatures()[0]
		for argument in arguments:
			used |= checkUsage(argument.type)
		used |= checkUsage(returnType)

	# TODO: prevent cycles
	# elif isinstance(idl, IDLWrapperType):
	# 	print("### checkUsage:IDLWrapperType %s, dict: %s" % (idl, idl.isDictionary()))
	# 	used |= checkUsage(idl.inner)

	elif isinstance(idl, IDLType):
		if idl.nullable():
			used |= checkUsage(idl.inner)
		elif idl.isSequence():
			used |= checkUsage(idl.inner)
		elif idl.isPromise():
			used |= checkUsage(idl.promiseInnerType())
		elif idl.isUnion():
			for t in idl.memberTypes:
				used |= checkUsage(t)
		elif not idl.isPrimitive():
			used.add(stripTrailingUnderscore(idl.name))

	elif isinstance(idl, IDLIdentifier):
		used.add(stripTrailingUnderscore(idl.name))

	elif isinstance(idl, IDLAttribute) or isinstance(idl, IDLConst):
		used |= checkUsage(idl.type)

	elif isinstance(idl, IDLMethod):
		for returnType, arguments in idl.signatures():
			for argument in arguments:
				used |= checkUsage(argument)
			used |= checkUsage(returnType)

	elif isinstance(idl, IDLArgument):
		used |= checkUsage(idl.type)

	return used

# Convert an IDL to Haxe
def generate (idl, usedTypes, knownTypes, cssProperties, outputDir):
	package = toHaxePackage(idl.identifier.name)

	needsIndent = [False]
	indentDepth = [0]
	def beginIndent ():
		indentDepth[0] += 1
		pass
	def endIndent ():
		indentDepth[0] -= 1
		pass

	def writeln (*args):
		write(*args)
		write("\n")

	def write (*args):
		for arg in args:
			if arg is None:
				pass

			elif isinstance(arg, str) or isinstance(arg, unicode):
				if needsIndent[0]:
					file.write("\t" * indentDepth[0])
				file.write(arg)
				needsIndent[0] = arg.endswith("\n")

			else:
				writeIdl(arg)

	def writeNativeMeta (idl):
		nativeName = stripTrailingUnderscore(idl.name)
		if nativeName != toHaxeIdentifier(idl.name):
			writeln("@:native(\"%s\")" % nativeName)

	def writeHaxeType (name):
		# Include the package name if the type is in a different package
		typePackage = toHaxePackage(name)
		if package != typePackage:
			write(".".join(typePackage)+".")
		write(toHaxeType(name))

	def writeIdl (idl):
		if isinstance(idl, IDLInterface):
			nativeName = stripTrailingUnderscore(idl.identifier.name)
			if nativeName == "ArrayBuffer" or nativeName == "DataView" \
					or nativeName == "Float32Array" or nativeName == "Float64Array" \
					or nativeName == "Uint8Array":
				writeln("// Explicitly include the compatibility class")
				writeln("import js.html.compat.%s;" % nativeName)
				writeln()

			# It's a compile-time only type if it has the [NoInterfaceObject] attribute or it's a callback type
			# if the type has constants then we need a concrete class to host them
			if (idl.isCallback() or idl.getExtendedAttribute("NoInterfaceObject")) and not idl.hasConstants():
				write("typedef ", toHaxeType(idl.identifier.name), " =")
			else:
				writeln("@:native(\"%s\")" % nativeName)
				write("extern class ", toHaxeType(idl.identifier.name))
				if idl.parent:
					write(" extends ")
					writeHaxeType(idl.parent.identifier.name)

			arrayAccess = None
			staticVars = []
			staticMethods = []
			vars = []
			methods = []
			for member in idl.members:
				if member.isMethod() and member.isGetter():
					returnType, arguments = member.signatures()[0]
					if len(arguments) == 1 and arguments[0].type.isInteger():
						arrayAccess = returnType
				if isAvailable(member):
					collection = None
					if isDefinedInParents(idl, member):
						continue
					if member.isConst() or member.isStatic():
						collection = staticMethods if member.isMethod() else staticVars
					else:
						collection = methods if member.isMethod() else vars
					collection.append(member)

			if arrayAccess:
				write(" implements ArrayAccess<", arrayAccess, ">")

			if idl.identifier.name == "DOMStringMap":
				write(" implements Dynamic<String>")

			writeln()
			writeln("{")
			beginIndent()
			if staticVars:
				for member in staticVars:
					writeln(member)
				writeln()
			for member in staticMethods:
				writeln(member)
			if vars:
				for member in vars:
					writeln(member)
				writeln()

			# For CSSStyleDeclaration, add all CSS property shorthands
			if idl.identifier.name == "CSSStyleDeclaration":
				def repl (match):
					return match.group(1).upper()
				for prop in cssProperties:
					prop = prop.strip()
					haxeName = re.sub(r"-+(.)", repl, prop)
					writeln("/** Shorthand for the \"%s\" CSS property. */" % prop)
					writeln("var %s :String;" % haxeName)
				writeln()

			ctor = idl.ctor()
			if ctor and not ctor.isHTMLConstructor():
				writeln(ctor)
			for member in methods:
				writeln(member)

			# For HTMLDocument, add all createFooElement shortcuts
			if idl.identifier.name == "HTMLDocument":
				for name, html in HTML_ELEMENTS.iteritems():
					writeln("/** Shorthand for creating an HTML <%s> element. */" % html)
					write("inline function create%s() : %s {" % (name, toHaxeType(name)))
					writeln(" return cast createElement(\"%s\"); }" % html)
				writeln()

			# For HTMLCanvasElement, add getContext shortcuts
			if idl.identifier.name == "HTMLCanvasElement":
				writeln()
				def beginContext (name, attribsType, haxeType):
					writeln("/** Shorthand for getting a %s. */" % haxeType)
					writeln("inline function getContext%s( ?attribs : %s ) : %s {" % (name, attribsType, haxeType))
					beginIndent()
				def endContext ():
					endIndent()
					writeln("}")

				beginContext("2d", "{}", "CanvasRenderingContext2D")
				writeln("return cast getContext(\"2d\", attribs);")
				endContext()

				beginContext("WebGL", "js.html.webgl.ContextAttributes", "js.html.webgl.RenderingContext")
				writeln("return CanvasUtil.getContextWebGL(this, attribs);")
				endContext()

				beginContext("WebGL2", "js.html.webgl.ContextAttributes", "js.html.webgl.WebGL2RenderingContext")
				writeln("return this.getContext('webgl2', attribs);")
				endContext()

			endIndent()
			write("}")

			if idl.identifier.name == "HTMLCanvasElement":
				writeln()
				write(textwrap.dedent("""
					private class CanvasUtil {
						public static function getContextWebGL( canvas :CanvasElement, attribs :{} ) {
							for (name in ["webgl", "experimental-webgl"]) {
								var ctx = canvas.getContext(name, attribs);
								if (ctx != null) return ctx;
							}
							return null;
						}
					}
				"""))

		elif isinstance(idl, IDLCallbackType):
			callback = idl.callback
			if callback.identifier.name == "EventHandlerNonNull":
				# Special case for event handler convenience
				write("haxe.Constraints.Function")
			else:
				returnType, arguments = callback.signatures()[0]
				if len(arguments) > 0:
					if len(arguments) == 1 and arguments[0].type.isAny() and returnType.isAny():
						# Assume that Dynamic -> Dynamic should be Function
						write("haxe.Constraints.Function")
					else:
						for argument in arguments:
							write(argument.type, " -> ")
						write(returnType)
				else:
					write("Void -> ", returnType)

		elif isinstance(idl, IDLDictionary):
			# writeln("typedef ", idl.identifier, " =")
			writeln("typedef ", toHaxeType(idl.identifier.name), " =")
			writeln("{")
			beginIndent()
			if idl.parent:
				name = idl.parent.identifier.name
				# if name not in usedTypes or name not in knownTypes:
				# 	write("// ")
				writeln("> ", toHaxeType(idl.parent.identifier.name), ",")
			for member in idl.members:
				if isAvailable(member):
					writeNativeMeta(member.identifier)
					if member.optional:
						write("@:optional ")
					writeln("var ", member.identifier, " : ", member.type, ";")
			endIndent()
			write("}")

		elif isinstance(idl, IDLEnum):
			writeln("enum abstract ", toHaxeType(idl.identifier.name), "(String)")
			writeln("{")
			beginIndent()
			for value in idl.values():
				if not isMozPrefixed(value):
					writeln("var ", toEnumValue(value), " = \"", value, "\";")
			endIndent()
			write("}")

		elif isinstance(idl, IDLType):
			name = stripTrailingUnderscore(idl.name)
			if idl.nullable():
				# write("Null<", idl.inner, ">")
				write(idl.inner)
			elif idl.isSequence():
				write("Array<", idl.inner, ">")
			elif idl.isPromise():
				write("Promise<")
				write(idl.promiseInnerType())
				write(">")
			elif idl.isUnion():
				def writeUnion (memberTypes):
					if len(memberTypes) > 1:
						if memberTypes[1].name == "OffscreenCanvas":
							# Special case for WebGLRenderingContext.canvas
							write(memberTypes[0])
						else:
							write("haxe.extern.EitherType<", memberTypes[0], ",")
							writeUnion(memberTypes[1:])
							write(">")
					else:
						write(memberTypes[0])
				writeUnion(idl.memberTypes)
			elif idl.isString() or idl.isByteString() or idl.isDOMString() or idl.isUSVString():
				write("String")
			elif idl.isNumeric():
				write("Int" if idl.isInteger() else "Float")
			elif idl.isBoolean():
				write("Bool")
			elif idl.isVoid():
				write("Void")
			elif idl.isDate():
				write("Date")
			elif idl.isRecord() and (idl.keyType.isString() or idl.keyType.isByteString() or idl.keyType.isDOMString() or idl.keyType.isUSVString()):
				write("haxe.DynamicAccess<");
				writeIdl(idl.inner);
				write(">")
			elif idl.isObject() or idl.isAny():
				write("Any")
			elif name not in usedTypes or name not in knownTypes:
				if name == "WindowProxy":
					write("Window") # Special case hack
				elif name in ["nsISupports", "nsIVariant"]:
					write("Any")
				else:
					write("Dynamic/*MISSING %s*/" % name)
			else:
				# Force Element and Document to HTMLElement and HTMLDocument to make things more
				# convenient for typical web development and preserve 3.1 compat:
				# https://github.com/HaxeFoundation/haxe/issues/4081
				if name == "Element":
					name = "HTMLElement"
				elif name == "Document":
					name = "HTMLDocument"
				writeHaxeType(name)

		elif isinstance(idl, IDLIdentifier):
			write(toHaxeIdentifier(stripMozPrefix(idl.name, lowerCase=True)))

		elif isinstance(idl, IDLAttribute):
			writeNativeMeta(idl.identifier)
			if idl.isStatic():
				write("static ")
			write("var ", idl.identifier)
			if idl.readonly:
				write("(default,null)")
			write(" : ", idl.type, ";")

		elif isinstance(idl, IDLConst):
			writeNativeMeta(idl.identifier)
			write("static inline var ", idl.identifier, " : ", idl.type, " = ", idl.value, ";")

		elif isinstance(idl, IDLMethod):
			if idl.getExtendedAttribute("Throws"):
				writeln("/** @throws DOMError */")

			constructor = idl.identifier.name == "constructor"

			writeNativeMeta(idl.identifier)
			signatures = idl.signatures()
			for idx, (returnType, arguments) in enumerate(signatures):
				overload = (idx < len(signatures)-1)
				if overload:
					write("@:overload( function(")
				else:
					if idl.getExtendedAttribute("Pure"):
						write("@:pure ")
					if idl.isStatic() and not constructor:
						write("static ")
					write("function ", "new" if constructor else idl.identifier, "(")

				# Write the argument list
				if len(arguments) > 0:
					write(" ")
					for idx, argument in enumerate(arguments):
						write(argument)
						if idx < len(arguments)-1:
							write(", ")
					write(" ")
				write(") : ", "Void" if constructor else returnType)
				if overload:
					writeln(" {} )")
				else:
					write(";")

		elif isinstance(idl, IDLArgument):
			if idl.optional and not idl.variadic:
				write("?")
			write(idl.identifier, " : ")
			if idl.variadic:
				write("haxe.extern.Rest<", idl.type, ">")
			else:
				write(idl.type)
			if idl.defaultValue and not isinstance(idl.defaultValue, IDLNullValue) and not isinstance(idl.defaultValue, IDLUndefinedValue):
				write(" = ", idl.defaultValue)

		elif isinstance(idl, IDLValue):
			if idl.type.isString():
				write("\"%s\"" % idl.value)
			elif idl.type.isBoolean():
				write("true" if idl.value else "false")
			elif idl.type.isInteger() and idl.value >= 2147483648:
				write("cast %s" % idl.value)
			else:
				write(str(idl.value))

		elif isinstance(idl, IDLNullValue):
			write("null")

		elif isinstance(idl, IDLEmptySequenceValue):
			write("[]")

		else:
			assert False, "Unhandled IDL type: %s" % type(idl)

	dir = "%s/%s" % (outputDir, "/".join(package))
	try:
		os.makedirs(dir)
	except OSError as e:
		pass
	fileName = "%s/%s.hx" % (dir, toHaxeType(idl.identifier.name))
	print("Generating %s..." % fileName)

	file = open(fileName, "w")
	header = textwrap.dedent("""\
		/*
		 * Copyright (C)2005-%s Haxe Foundation
		 *
		 * Permission is hereby granted, free of charge, to any person obtaining a
		 * copy of this software and associated documentation files (the "Software"),
		 * to deal in the Software without restriction, including without limitation
		 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
		 * and/or sell copies of the Software, and to permit persons to whom the
		 * Software is furnished to do so, subject to the following conditions:
		 *
		 * The above copyright notice and this permission notice shall be included in
		 * all copies or substantial portions of the Software.
		 *
		 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
		 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
		 * DEALINGS IN THE SOFTWARE.
		 */

		// This file is generated from %s. Do not edit!
		""" % (datetime.date.today().year, idl.location.filename().replace("/","\\")))
	writeln(header)
	writeln("package %s;" % (".".join(package)))
	writeln()
	writeIdl(idl)
	file.close()

def isDefinedInParents (idl, member, checkMembers=False):
	if idl.parent and isDefinedInParents(idl.parent, member, True):
		return True
	if checkMembers:
		for other in idl.members:
			if other.identifier.name == member.identifier.name:
				return True
	return False

def stripMozPrefix (name, lowerCase=False):
	def replacer (match):
		return match.group(1).lower()
	name = re.sub(r"^moz(.)", replacer if lowerCase else r"\1", name)
	name = re.sub(r"^onmoz", "on", name)
	return name

def stripTrailingUnderscore (name):
	if name.endswith("_"):
		name = name[0:-1]
	name = stripMozPrefix(name)
	if name in RENAMES:
		name = RENAMES[name]
	return name

def toCamelCase (name):
	# Convert a snakey case name to an upper camel case
	return string.capwords(name, sep="_").replace("_", "")

def toHaxeIdentifier (name):
	name = re.sub(r"[^A-Za-z0-9_]", "_", name)
	if name in RESERVED_WORDS:
		name += "_"
	return name

def toHaxeType (name):
	name = stripTrailingUnderscore(name)
	if name != "":
		name = name[0].upper() + name[1:]
	if name in ALIASES:
		name = ALIASES[name]
	name = re.sub("^HTML(.+Element)", "\\1", name)
	if name.startswith("SVG"):
		name = name[len("SVG"):]
	elif name.startswith("WebGL2"):
		pass
	elif name.startswith("WebGL"):
		name = name[len("WebGL"):]
	elif name.startswith("WEBGL_"):
		name = "WEBGL"+toCamelCase(name[len("WEBGL_"):])
	elif name.startswith("EXT_"):
		name = "EXT"+toCamelCase(name[len("EXT_"):])
	elif name.startswith("OES_"):
		name = "OES"+toCamelCase(name[len("OES_"):])
	elif name.startswith("ANGLE_"):
		name = "ANGLE"+toCamelCase(name[len("ANGLE_"):])
	elif name.startswith("IDB"):
		name = name[len("IDB"):]
	elif name.startswith("RTC"):
		name = name[len("RTC"):]
	else:
		for pkg, group in PACKAGES.iteritems():
			if group.removePrefix and name.startswith(group.removePrefix) and name in group.names:
				name = name[len(group.removePrefix):]
				break

	# if name.startswith("ExtensionCompressedTexture"):
	# 	name = "ExtensionCompressedTexture" + name[len("ExtensionCompressedTexture"):].upper()
	# elif name == "ExtensionSrgb":
	# 	name = "ExtensionSRGB"
	# elif name == "ExtensionBlendMinmax":
	# 	name = "ExtensionBlendMinMax"

	return name

def isWebGLExtension(name):
	return name.startswith("WEBGL_") or name.startswith("EXT_") or name.startswith("OES_") or name.startswith("ANGLE_")

def toHaxePackage (name):
	name = stripTrailingUnderscore(name)
	package = ["js", "html"]
	if name.startswith("WebGL"):
		package.append("webgl")
	elif isWebGLExtension(name):
		package.append("webgl")
		package.append("extension")
	elif name.startswith("IDB"):
		package.append("idb")
	elif name.startswith("SVG"):
		package.append("svg")
	elif name.startswith("RTC"):
		package.append("rtc")
	else:
		for pkg, group in PACKAGES.iteritems():
			if name in group.names:
				package.append(pkg)
				break
	return package

def toEnumValue (value):
	if value == "":
		return "NONE"
	value = toHaxeIdentifier(value)
	value = re.sub(r"([a-z])([A-Z])", r"\1_\2", value)
	value = value.upper()
	if re.search(r"^[0-9]", value):
		value = "_"+value
	return value

def isMozPrefixed (name):
	for pattern in ALLOWED_MOZ_PREFIXES:
		if pattern.match(name):
			return False
	name = name.lower()
	return name.startswith("moz") or name.startswith("onmoz") or name.startswith("__")

def isDisabled (attrs, whitelist):
	if attrs:
		for attr in attrs:
			if attr not in whitelist:
				return True
	return False

def isWhitelisted(idl):
	if idl.identifier.name in WHITELIST:
		return True

def isBlacklisted(idl):
	# blacklist all chrome-webidl/ files
	if "chrome-webidl" in idl.location.filename():
		return True

	if idl.identifier.name in BLACKLIST:
		return True

	if isMozPrefixed(idl.identifier.name):
		# Hack for WebRTC, which is moz prefixed but we want it
		if not idl.identifier.name.startswith("mozRTC"):
			return True

def isAvailable (idl):
	if isWhitelisted(idl):
		return True
	if isBlacklisted(idl):
		return False

	# check feature preferences
	if hasattr(idl, "getExtendedAttribute"):
		if idl.getExtendedAttribute("ChromeOnly") or \
				idl.getExtendedAttribute("AvailableIn") or \
				idl.getExtendedAttribute("CheckPermissions") or \
				idl.getExtendedAttribute("CheckAnyPermissions") or \
				idl.getExtendedAttribute("NavigatorProperty"):
			return False
		if isDisabled(idl.getExtendedAttribute("Pref"), PREFS):
			return False
		if isDisabled(idl.getExtendedAttribute("Func"), FUNCS):
			return False

	return True
