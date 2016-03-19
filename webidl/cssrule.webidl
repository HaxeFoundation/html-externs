
  // Introduced in DOM Level 2:
  interface CSSRule_ {

    // RuleType
    const unsigned short      UNKNOWN_RULE                   = 0;
    const unsigned short      STYLE_RULE                     = 1;
    const unsigned short      CHARSET_RULE                   = 2;
    const unsigned short      IMPORT_RULE                    = 3;
    const unsigned short      MEDIA_RULE                     = 4;
    const unsigned short      FONT_FACE_RULE                 = 5;
    const unsigned short      PAGE_RULE                      = 6;

    readonly attribute unsigned short   type;
             attribute DOMString        cssText;
                                        // raises(dom::DOMException) on setting

    readonly attribute CSSStyleSheet    parentStyleSheet;
    readonly attribute CSSRule_          parentRule;
  };

  // Introduced in DOM Level 2:
  interface CSSStyleRule : CSSRule_ {
             attribute DOMString        selectorText;
                                        // raises(dom::DOMException) on setting

    readonly attribute CSSStyleDeclaration  style;
  };

  // Introduced in DOM Level 2:
  interface CSSMediaRule : CSSRule_ {
    readonly attribute MediaList  media;
    readonly attribute CSSRuleList      cssRules;
    unsigned long      insertRule(DOMString rule, 
                                  unsigned long index);
                                        /* raises(dom::DOMException); */
    void               deleteRule(unsigned long index);
                                        /* raises(dom::DOMException); */
  };

  // Introduced in DOM Level 2:
  interface CSSFontFaceRule : CSSRule_ {
    readonly attribute CSSStyleDeclaration  style;
  };

  // Introduced in DOM Level 2:
  interface CSSPageRule : CSSRule_ {
             attribute DOMString        selectorText;
                                        // raises(dom::DOMException) on setting

    readonly attribute CSSStyleDeclaration  style;
  };

  // Introduced in DOM Level 2:
  interface CSSImportRule : CSSRule_ {
    readonly attribute DOMString        href;
    readonly attribute MediaList  media;
    readonly attribute CSSStyleSheet    styleSheet;
  };

  // Introduced in DOM Level 2:
  interface CSSCharsetRule : CSSRule_ {
             attribute DOMString        encoding;
                                        // raises(dom::DOMException) on setting

  };

  // Introduced in DOM Level 2:
  interface CSSUnknownRule : CSSRule_ {
  };
