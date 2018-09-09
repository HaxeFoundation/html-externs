HAXE_DIR="../haxe-git"

rm -rf "$HAXE_DIR/std/js/html" &&
mkdir -p "$HAXE_DIR/std/js/html" &&
./bin/generate "$HAXE_DIR/std" && 
{
	echo "-------"
	echo "> Adding documentation"
	echo "-------"

	pushd html-extern-api-docs && haxe build.hxml && popd &&
	neko html-extern-api-docs/htmlexterns.n "$HAXE_DIR/std/js/html/" &&
	
	cp -r _output_documented_html/ "$HAXE_DIR/std/js/html" &&
	{
		echo "-------"
		echo "> Validating"
		echo "-------"
		$HAXE_DIR/haxe validate.hxml && {
			echo 'Validated!'
		} || {
			echo 'Validation failed.'
		}
	}

} 