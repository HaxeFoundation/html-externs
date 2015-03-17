// https://fullscreen.spec.whatwg.org

partial interface Element {
  void requestFullscreen();
};

partial interface Document {
  readonly attribute boolean fullscreenEnabled;
  readonly attribute Element? fullscreenElement;

  void exitFullscreen();

  attribute EventHandler onfullscreenchange;
  attribute EventHandler onfullscreenerror;
};
