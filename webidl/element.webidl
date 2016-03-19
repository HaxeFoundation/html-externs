// Hoist all HTMLElement attributes up into Element for convenience

partial interface Element {
  // metadata attributes
           attribute DOMString title;
           attribute DOMString lang;
  //         attribute boolean translate;
  [SetterThrows, Pure]
           attribute DOMString dir;
  [Constant]
  readonly attribute DOMStringMap dataset;

  [GetterThrows, Pure]
           attribute DOMString innerText;

  // microdata 
  [SetterThrows, Pure]
           attribute boolean itemScope;
  [PutForwards=value,Constant] readonly attribute DOMTokenList itemType;
  [SetterThrows, Pure]
           attribute DOMString itemId;
  [PutForwards=value,Constant] readonly attribute DOMTokenList itemRef;
  [PutForwards=value,Constant] readonly attribute DOMTokenList itemProp;
  [Constant]
  readonly attribute HTMLPropertiesCollection properties;
  [Throws]
           attribute any itemValue;

  // user interaction
  [SetterThrows, Pure]
           attribute boolean hidden;
  void click();
  [SetterThrows, Pure]
           attribute long tabIndex;
  [Throws]
  void focus();
  [Throws]
  void blur();
  [SetterThrows, Pure]
           attribute DOMString accessKey;
  [Pure]
  readonly attribute DOMString accessKeyLabel;
  [SetterThrows, Pure]
           attribute boolean draggable;
  //[PutForwards=value] readonly attribute DOMTokenList dropzone;
  [SetterThrows, Pure]
           attribute DOMString contentEditable;
  [Pure]
  readonly attribute boolean isContentEditable;
  [Pure]
  readonly attribute HTMLMenuElement? contextMenu;
  //[SetterThrows]
  //         attribute HTMLMenuElement? contextMenu;
  [SetterThrows, Pure]
           attribute boolean spellcheck;

  // command API
  //readonly attribute DOMString? commandType;
  //readonly attribute DOMString? commandLabel;
  //readonly attribute DOMString? commandIcon;
  //readonly attribute boolean? commandHidden;
  //readonly attribute boolean? commandDisabled;
  //readonly attribute boolean? commandChecked;

  // styling
  [PutForwards=cssText, Constant]
  readonly attribute CSSStyleDeclaration style;

  // Mozilla specific stuff
           attribute EventHandler oncopy;
           attribute EventHandler oncut;
           attribute EventHandler onpaste;
};

// http://dev.w3.org/csswg/cssom-view/#extensions-to-the-htmlelement-interface
partial interface Element {
  // CSSOM things are not [Pure] because they can flush
  readonly attribute Element? offsetParent;
  readonly attribute long offsetTop;
  readonly attribute long offsetLeft;
  readonly attribute long offsetWidth;
  readonly attribute long offsetHeight;
};

// Extension for scroll-grabbing, used in the B2G dynamic toolbar.
// This is likely to be revised.
partial interface Element {
  [Func="nsGenericHTMLElement::IsScrollGrabAllowed"]
           attribute boolean scrollgrab;
};

Element implements GlobalEventHandlers;
Element implements TouchEventHandlers;
Element implements OnErrorEventHandlerForNodes;
