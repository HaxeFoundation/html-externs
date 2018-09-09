/*
 * typedarray.idl
 *
 * TypedArray IDL definitions scraped from the Khronos specification.
 *
 * Original Khronos Working Draft:
 *
 *   https://www.khronos.org/registry/typedarray/specs/latest/
 */

[ Constructor(unsigned long length) ]
interface ArrayBuffer_ {
    readonly attribute unsigned long byteLength;
    ArrayBuffer_ slice(long begin, optional long end);
    static boolean isView(any value);
};

/* ArrayBuffer_ implements Transferable; */

[NoInterfaceObject]
interface ArrayBufferView_ {
    readonly attribute ArrayBuffer_ buffer;
    readonly attribute unsigned long byteOffset;
    readonly attribute unsigned long byteLength;
};

callback IMapFnCallback = unsigned long (unsigned long v, unsigned long k);
callback FMapFnCallback = unrestricted float (unrestricted float v, unrestricted float k);
callback DMapFnCallback = unrestricted double (unrestricted double v, unrestricted double k);

// Int8Array
callback Int8ArrayTestCallback = boolean (long value, long index, Int8Array_ array);
callback Int8ArrayAnyCallback = any (long value, long index, Int8Array_ array);
callback Int8ArrayVoidCallback = void (long value, long index, Int8Array_ array);
callback Int8ArrayNumberCallback = long (long value, long index, Int8Array_ array);
callback Int8ArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Int8Array_ array);
callback Int8ArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Int8Array_ array);
callback Int8ArrayCompareCallback = long (long a, long b);
// The 'byte' type does not currently exist in Web IDL.
// In this IDL, it should be a signed 8 bit type.
[
    Constructor(unsigned long length),
    Constructor(Int8Array_ array),
    Constructor(sequence<byte> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Int8Array_ {
    const long BYTES_PER_ELEMENT = 1;
    [Pure]
    static Int8Array_ of(sequence<any>... items);
    [Pure]
    static Int8Array_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter byte (unsigned long index);
    //setter void set(unsigned long index, byte value);
    void set(Int8Array_ array, optional unsigned long offset);
    void set(sequence<byte> array, optional unsigned long offset);

    Int8Array_ copyWithin(long target, long start, optional long end);
    boolean every(Int8ArrayTestCallback callback, optional any thisArg);
    Int8Array_ fill(long value, optional long start, optional long end);
    Int8Array_ filter(Int8ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Int8ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Int8ArrayTestCallback predicate, optional any thisArg);
    void forEach(Int8ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Int8Array_ map(Int8ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Int8ArrayReduceCallback callbackfn);
    any reduce(Int8ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Int8ArrayReduceCallback callbackfn);
    any reduceRight(Int8ArrayReduceAnyCallback callbackfn, any initialValue);
    Int8Array_ reverse();
    Int8Array_ slice(optional long start, optional long end);
    boolean some(Int8ArrayTestCallback callbackfn, optional any thisArg);
    Int8Array_ sort(optional Int8ArrayCompareCallback compareFn);
    Int8Array_ subarray(long begin, optional long end);
};
Int8Array_ implements ArrayBufferView_;


// The 'unsigned byte' type does not currently exist in Web IDL, though
// 'octet' is equivalent.
callback Uint8ArrayTestCallback = boolean (long value, long index, Uint8Array_ array);
callback Uint8ArrayAnyCallback = any (long value, long index, Uint8Array_ array);
callback Uint8ArrayVoidCallback = void (long value, long index, Uint8Array_ array);
callback Uint8ArrayNumberCallback = long (long value, long index, Uint8Array_ array);
callback Uint8ArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Uint8Array_ array);
callback Uint8ArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Uint8Array_ array);
callback Uint8ArrayCompareCallback = long (long a, long b);
[
    Constructor(unsigned long length),
    Constructor(Uint8Array_ array),
    Constructor(sequence<octet> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Uint8Array_ {
    const long BYTES_PER_ELEMENT = 1;
    [Pure]
    static Uint8Array_ of(sequence<any>... items);
    [Pure]
    static Uint8Array_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter octet(unsigned long index);
    //setter void set(unsigned long index, octet value);
    void set(Uint8Array_ array, optional unsigned long offset);
    void set(sequence<octet> array, optional unsigned long offset);
    
    Uint8Array_ copyWithin(long target, long start, optional long end);
    boolean every(Uint8ArrayTestCallback callback, optional any thisArg);
    Uint8Array_ fill(long value, optional long start, optional long end);
    Uint8Array_ filter(Uint8ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Uint8ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Uint8ArrayTestCallback predicate, optional any thisArg);
    void forEach(Uint8ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Uint8Array_ map(Uint8ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Uint8ArrayReduceCallback callbackfn);
    any reduce(Uint8ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Uint8ArrayReduceCallback callbackfn);
    any reduceRight(Uint8ArrayReduceAnyCallback callbackfn, any initialValue);
    Uint8Array_ reverse();
    Uint8Array_ slice(optional long start, optional long end);
    boolean some(Uint8ArrayTestCallback callbackfn, optional any thisArg);
    Uint8Array_ sort(optional Uint8ArrayCompareCallback compareFn);
    Uint8Array_ subarray(long begin, optional long end);
};
Uint8Array_ implements ArrayBufferView_;

callback Uint8ClampedArrayTestCallback = boolean (long value, long index, Uint8ClampedArray_ array);
callback Uint8ClampedArrayAnyCallback = any (long value, long index, Uint8ClampedArray_ array);
callback Uint8ClampedArrayVoidCallback = void (long value, long index, Uint8ClampedArray_ array);
callback Uint8ClampedArrayNumberCallback = long (long value, long index, Uint8ClampedArray_ array);
callback Uint8ClampedArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Uint8ClampedArray_ array);
callback Uint8ClampedArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Uint8ClampedArray_ array);
callback Uint8ClampedArrayCompareCallback = long (long a, long b);
[
    Constructor(unsigned long length),
    Constructor(Uint8ClampedArray_ array),
    Constructor(sequence<octet> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Uint8ClampedArray_ {
    const long BYTES_PER_ELEMENT = 1;
    [Pure]
    static Uint8ClampedArray_ of(sequence<any>... items);
    [Pure]
    static Uint8ClampedArray_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter octet (unsigned long index);
    //setter void set(unsigned long index, [Clamp] octet value);
    void set(Uint8ClampedArray_ array, optional unsigned long offset);
    void set(sequence<octet> array, optional unsigned long offset);
    
    Uint8ClampedArray_ copyWithin(long target, long start, optional long end);
    boolean every(Uint8ClampedArrayTestCallback callback, optional any thisArg);
    Uint8ClampedArray_ fill(long value, optional long start, optional long end);
    Uint8ClampedArray_ filter(Uint8ClampedArrayAnyCallback callbackfn, optional any thisArg);
    any find(Uint8ClampedArrayTestCallback predicate, optional any thisArg);
    long findIndex(Uint8ClampedArrayTestCallback predicate, optional any thisArg);
    void forEach(Uint8ClampedArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Uint8ClampedArray_ map(Uint8ClampedArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Uint8ClampedArrayReduceCallback callbackfn);
    any reduce(Uint8ClampedArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Uint8ClampedArrayReduceCallback callbackfn);
    any reduceRight(Uint8ClampedArrayReduceAnyCallback callbackfn, any initialValue);
    Uint8ClampedArray_ reverse();
    Uint8ClampedArray_ slice(optional long start, optional long end);
    boolean some(Uint8ClampedArrayTestCallback callbackfn, optional any thisArg);
    Uint8ClampedArray_ sort(optional Uint8ClampedArrayCompareCallback compareFn);
    Uint8ClampedArray_ subarray(long begin, optional long end);
};
Uint8ClampedArray_ implements ArrayBufferView_;

callback Int16ArrayTestCallback = boolean (long value, long index, Int16Array_ array);
callback Int16ArrayAnyCallback = any (long value, long index, Int16Array_ array);
callback Int16ArrayVoidCallback = void (long value, long index, Int16Array_ array);
callback Int16ArrayNumberCallback = long (long value, long index, Int16Array_ array);
callback Int16ArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Int16Array_ array);
callback Int16ArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Int16Array_ array);
callback Int16ArrayCompareCallback = long (long a, long b);
[
    Constructor(unsigned long length),
    Constructor(Int16Array_ array),
    Constructor(sequence<short> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Int16Array_ {
    const long BYTES_PER_ELEMENT = 2;
    [Pure]
    static Int16Array_ of(sequence<any>... items);
    [Pure]
    static Int16Array_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter short(unsigned long index);
    //setter void set(unsigned long index, short value);
    void set(Int16Array_ array, optional unsigned long offset);
    void set(sequence<short> array, optional unsigned long offset);

    Int16Array_ copyWithin(long target, long start, optional long end);
    boolean every(Int16ArrayTestCallback callback, optional any thisArg);
    Int16Array_ fill(long value, optional long start, optional long end);
    Int16Array_ filter(Int16ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Int16ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Int16ArrayTestCallback predicate, optional any thisArg);
    void forEach(Int16ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Int16Array_ map(Int16ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Int16ArrayReduceCallback callbackfn);
    any reduce(Int16ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Int16ArrayReduceCallback callbackfn);
    any reduceRight(Int16ArrayReduceAnyCallback callbackfn, any initialValue);
    Int16Array_ reverse();
    Int16Array_ slice(optional long start, optional long end);
    boolean some(Int16ArrayTestCallback callbackfn, optional any thisArg);
    Int16Array_ sort(optional Int16ArrayCompareCallback compareFn);
    Int16Array_ subarray(long begin, optional long end);
};
Int16Array_ implements ArrayBufferView_;

callback Uint16ArrayTestCallback = boolean (long value, long index, Uint16Array_ array);
callback Uint16ArrayAnyCallback = any (long value, long index, Uint16Array_ array);
callback Uint16ArrayVoidCallback = void (long value, long index, Uint16Array_ array);
callback Uint16ArrayNumberCallback = long (long value, long index, Uint16Array_ array);
callback Uint16ArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Uint16Array_ array);
callback Uint16ArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Uint16Array_ array);
callback Uint16ArrayCompareCallback = long (long a, long b);
[
    Constructor(unsigned long length),
    Constructor(Uint16Array_ array),
    Constructor(sequence<unsigned short> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Uint16Array_ {
    const long BYTES_PER_ELEMENT = 2;
    [Pure]
    static Uint16Array_ of(sequence<any>... items);
    [Pure]
    static Uint16Array_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter unsigned short(unsigned long index);
    //setter void set(unsigned long index, unsigned short value);
    void set(Uint16Array_ array, optional unsigned long offset);
    void set(sequence<unsigned short> array, optional unsigned long offset);

    Uint16Array_ copyWithin(long target, long start, optional long end);
    boolean every(Uint16ArrayTestCallback callback, optional any thisArg);
    Uint16Array_ fill(long value, optional long start, optional long end);
    Uint16Array_ filter(Uint16ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Uint16ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Uint16ArrayTestCallback predicate, optional any thisArg);
    void forEach(Uint16ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Uint16Array_ map(Uint16ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Uint16ArrayReduceCallback callbackfn);
    any reduce(Uint16ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Uint16ArrayReduceCallback callbackfn);
    any reduceRight(Uint16ArrayReduceAnyCallback callbackfn, any initialValue);
    Uint16Array_ reverse();
    Uint16Array_ slice(optional long start, optional long end);
    boolean some(Uint16ArrayTestCallback callbackfn, optional any thisArg);
    Uint16Array_ sort(optional Uint16ArrayCompareCallback compareFn);
    Uint16Array_ subarray(long begin, optional long end);
};
Uint16Array_ implements ArrayBufferView_;

callback Int32ArrayTestCallback = boolean (long value, long index, Int32Array_ array);
callback Int32ArrayAnyCallback = any (long value, long index, Int32Array_ array);
callback Int32ArrayVoidCallback = void (long value, long index, Int32Array_ array);
callback Int32ArrayNumberCallback = long (long value, long index, Int32Array_ array);
callback Int32ArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Int32Array_ array);
callback Int32ArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Int32Array_ array);
callback Int32ArrayCompareCallback = long (long a, long b);
[
    Constructor(unsigned long length),
    Constructor(Int32Array_ array),
    Constructor(sequence<long> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Int32Array_ {
    const long BYTES_PER_ELEMENT = 4;
    [Pure]
    static Int32Array_ of(sequence<any>... items);
    [Pure]
    static Int32Array_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter long(unsigned long index);
    //setter void set(unsigned long index, long value);
    void set(Int32Array_ array, optional unsigned long offset);
    void set(sequence<long> array, optional unsigned long offset);

    Int32Array_ copyWithin(long target, long start, optional long end);
    boolean every(Int32ArrayTestCallback callback, optional any thisArg);
    Int32Array_ fill(long value, optional long start, optional long end);
    Int32Array_ filter(Int32ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Int32ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Int32ArrayTestCallback predicate, optional any thisArg);
    void forEach(Int32ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Int32Array_ map(Int32ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Int32ArrayReduceCallback callbackfn);
    any reduce(Int32ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Int32ArrayReduceCallback callbackfn);
    any reduceRight(Int32ArrayReduceAnyCallback callbackfn, any initialValue);
    Int32Array_ reverse();
    Int32Array_ slice(optional long start, optional long end);
    boolean some(Int32ArrayTestCallback callbackfn, optional any thisArg);
    Int32Array_ sort(optional Int32ArrayCompareCallback compareFn);
    Int32Array_ subarray(long begin, optional long end);
};
Int32Array_ implements ArrayBufferView_;

callback Uint32ArrayTestCallback = boolean (long value, long index, Uint32Array_ array);
callback Uint32ArrayAnyCallback = any (long value, long index, Uint32Array_ array);
callback Uint32ArrayVoidCallback = void (long value, long index, Uint32Array_ array);
callback Uint32ArrayNumberCallback = long (long value, long index, Uint32Array_ array);
callback Uint32ArrayReduceCallback = long (long previousValue, long currentValue, long currentIndex, Uint32Array_ array);
callback Uint32ArrayReduceAnyCallback = any (any previousValue, long currentValue, long currentIndex, Uint32Array_ array);
callback Uint32ArrayCompareCallback = long (long a, long b);
[
    Constructor(unsigned long length),
    Constructor(Uint32Array_ array),
    Constructor(sequence<unsigned long> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Uint32Array_ {
    const long BYTES_PER_ELEMENT = 4;
    [Pure]
    static Uint32Array_ of(sequence<any>... items);
    [Pure]
    static Uint32Array_ from(sequence<unsigned long> source, optional IMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter unsigned long(unsigned long index);
    //setter void set(unsigned long index, unsigned long value);
    void set(Uint32Array_ array, optional unsigned long offset);
    void set(sequence<unsigned long> array, optional unsigned long offset);
    
    Uint32Array_ copyWithin(long target, long start, optional long end);
    boolean every(Uint32ArrayTestCallback callback, optional any thisArg);
    Uint32Array_ fill(long value, optional long start, optional long end);
    Uint32Array_ filter(Uint32ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Uint32ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Uint32ArrayTestCallback predicate, optional any thisArg);
    void forEach(Uint32ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(long searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(long searchElement, optional long fromIndex);
    Uint32Array_ map(Uint32ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Uint32ArrayReduceCallback callbackfn);
    any reduce(Uint32ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Uint32ArrayReduceCallback callbackfn);
    any reduceRight(Uint32ArrayReduceAnyCallback callbackfn, any initialValue);
    Uint32Array_ reverse();
    Uint32Array_ slice(optional long start, optional long end);
    boolean some(Uint32ArrayTestCallback callbackfn, optional any thisArg);
    Uint32Array_ sort(optional Uint32ArrayCompareCallback compareFn);
    Uint32Array_ subarray(long begin, optional long end);
};
Uint32Array_ implements ArrayBufferView_;

callback Float32ArrayTestCallback = boolean (float value, long index, Float32Array_ array);
callback Float32ArrayAnyCallback = any (float value, long index, Float32Array_ array);
callback Float32ArrayVoidCallback = void (float value, long index, Float32Array_ array);
callback Float32ArrayNumberCallback = float (float value, long index, Float32Array_ array);
callback Float32ArrayReduceCallback = float (float previousValue, float currentValue, long currentIndex, Float32Array_ array);
callback Float32ArrayReduceAnyCallback = any (any previousValue, float currentValue, long currentIndex, Float32Array_ array);
callback Float32ArrayCompareCallback = long (float a, float b);
[
    Constructor(unsigned long length),
    Constructor(Float32Array_ array),
    Constructor(sequence<unrestricted float> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Float32Array_  {
    const long BYTES_PER_ELEMENT = 4;
    [Pure]
    static Float32Array_ of(sequence<any>... items);
    [Pure]
    static Float32Array_ from(sequence<unrestricted float> source, optional FMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter unrestricted float(unsigned long index);
    //setter void set(unsigned long index, unrestricted float value);
    void set(Float32Array_ array, optional unsigned long offset);
    void set(sequence<unrestricted float> array, optional unsigned long offset);
    
    Float32Array_ copyWithin(long target, long start, optional long end);
    boolean every(Float32ArrayTestCallback callback, optional any thisArg);
    Float32Array_ fill(float value, optional long start, optional long end);
    Float32Array_ filter(Float32ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Float32ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Float32ArrayTestCallback predicate, optional any thisArg);
    void forEach(Float32ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(float searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(float searchElement, optional long fromIndex);
    Float32Array_ map(Float32ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Float32ArrayReduceCallback callbackfn);
    any reduce(Float32ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Float32ArrayReduceCallback callbackfn);
    any reduceRight(Float32ArrayReduceAnyCallback callbackfn, any initialValue);
    Float32Array_ reverse();
    Float32Array_ slice(optional long start, optional long end);
    boolean some(Float32ArrayTestCallback callbackfn, optional any thisArg);
    Float32Array_ sort(optional Float32ArrayCompareCallback compareFn);
    Float32Array_ subarray(long begin, optional long end);
};
Float32Array_ implements ArrayBufferView_;

callback Float64ArrayTestCallback = boolean (float value, long index, Float64Array_ array);
callback Float64ArrayAnyCallback = any (float value, long index, Float64Array_ array);
callback Float64ArrayVoidCallback = void (float value, long index, Float64Array_ array);
callback Float64ArrayNumberCallback = float (float value, long index, Float64Array_ array);
callback Float64ArrayReduceCallback = float (float previousValue, float currentValue, long currentIndex, Float64Array_ array);
callback Float64ArrayReduceAnyCallback = any (any previousValue, float currentValue, long currentIndex, Float64Array_ array);
callback Float64ArrayCompareCallback = long (float a, float b);
[
    Constructor(unsigned long length),
    Constructor(Float64Array_ array),
    Constructor(sequence<unrestricted double> array),
    Constructor(ArrayBuffer_ buffer,
                optional unsigned long byteOffset, optional unsigned long length)
]
interface Float64Array_ {
    const long BYTES_PER_ELEMENT = 8;
    [Pure]
    static Float64Array_ of(sequence<any>... items);
    [Pure]
    static Float64Array_ from(sequence<unrestricted double> source, optional DMapFnCallback mapFn, optional any thisArg);

    readonly attribute unsigned long BYTES_PER_ELEMENT_;
    readonly attribute unsigned long length;

    [Pure]
    getter unrestricted double(unsigned long index);
    //setter void set(unsigned long index, unrestricted double value);
    void set(Float64Array_ array, optional unsigned long offset);
    void set(sequence<unrestricted double> array, optional unsigned long offset);
    
    Float64Array_ copyWithin(long target, long start, optional long end);
    boolean every(Float64ArrayTestCallback callback, optional any thisArg);
    Float64Array_ fill(float value, optional long start, optional long end);
    Float64Array_ filter(Float64ArrayAnyCallback callbackfn, optional any thisArg);
    any find(Float64ArrayTestCallback predicate, optional any thisArg);
    long findIndex(Float64ArrayTestCallback predicate, optional any thisArg);
    void forEach(Float64ArrayVoidCallback callbackfn, optional any thisArg);
    long indexOf(float searchElement, optional long fromIndex);
    DOMString join(optional DOMString separator);
    long lastIndexOf(float searchElement, optional long fromIndex);
    Float64Array_ map(Float64ArrayNumberCallback callbackfn, optional any thisArg);
    long reduce(Float64ArrayReduceCallback callbackfn);
    any reduce(Float64ArrayReduceAnyCallback callbackfn, any initialValue);
    long reduceRight(Float64ArrayReduceCallback callbackfn);
    any reduceRight(Float64ArrayReduceAnyCallback callbackfn, any initialValue);
    Float64Array_ reverse();
    Float64Array_ slice(optional long start, optional long end);
    boolean some(Float64ArrayTestCallback callbackfn, optional any thisArg);
    Float64Array_ sort(optional Float64ArrayCompareCallback compareFn);
    Float64Array_ subarray(long begin, optional long end);
};
Float64Array_ implements ArrayBufferView_;


[
  Constructor(ArrayBuffer_ buffer,
              optional unsigned long byteOffset,
              optional unsigned long byteLength)
]
interface DataView_ {
    // Gets the value of the given type at the specified byte offset
    // from the start of the view. There is no alignment constraint;
    // multi-byte values may be fetched from any offset.
    //
    // For multi-byte values, the optional littleEndian argument
    // indicates whether a big-endian or little-endian value should be
    // read. If false or undefined, a big-endian value is read.
    //
    // These methods raise an INDEX_SIZE_ERR exception if they would read
    // beyond the end of the view.
    [Pure]
    byte getInt8(unsigned long byteOffset);
    [Pure]
    octet getUint8(unsigned long byteOffset);
    [Pure]
    short getInt16(unsigned long byteOffset,
                   optional boolean littleEndian);
    [Pure]
    unsigned short getUint16(unsigned long byteOffset,
                             optional boolean littleEndian);
    [Pure]
    long getInt32(unsigned long byteOffset,
                  optional boolean littleEndian);
    [Pure]
    unsigned long getUint32(unsigned long byteOffset,
                            optional boolean littleEndian);
    [Pure]
    unrestricted float getFloat32(unsigned long byteOffset,
                                  optional boolean littleEndian);
    [Pure]
    unrestricted double getFloat64(unsigned long byteOffset,
                                   optional boolean littleEndian);

    // Stores a value of the given type at the specified byte offset
    // from the start of the view. There is no alignment constraint;
    // multi-byte values may be stored at any offset.
    //
    // For multi-byte values, the optional littleEndian argument
    // indicates whether the value should be stored in big-endian or
    // little-endian byte order. If false or undefined, the value is
    // stored in big-endian byte order.
    //
    // These methods throw exceptions if they would write beyond the end
    // of the view.
    void setInt8(unsigned long byteOffset,
                 byte value);
    void setUint8(unsigned long byteOffset,
                  octet value);
    void setInt16(unsigned long byteOffset,
                  short value,
                  optional boolean littleEndian);
    void setUint16(unsigned long byteOffset,
                   unsigned short value,
                   optional boolean littleEndian);
    void setInt32(unsigned long byteOffset,
                  long value,
                  optional boolean littleEndian);
    void setUint32(unsigned long byteOffset,
                   unsigned long value,
                   optional boolean littleEndian);
    void setFloat32(unsigned long byteOffset,
                    unrestricted float value,
                    optional boolean littleEndian);
    void setFloat64(unsigned long byteOffset,
                    unrestricted double value,
                    optional boolean littleEndian);
};
DataView_ implements ArrayBufferView_;
