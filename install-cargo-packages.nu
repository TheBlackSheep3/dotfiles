if not ('./installed-cargo-packages.json' | path exists) {
	echo "Cannot find './installed-cargo-packages.json'"
	exit 1
}

echo 'Installing cargo packages ...'
let installed = (cargo install --list | lines | parse -r "(?P<package>[a-z_-]+) v(?P<major>\\d+)\\.(?P<minor>\\d+)\\.(?P<patch>\\d+):" | each { |e| {package:$e.package, version:{major:$e.major, minor:$e.minor, patch:$e.patch}}})
open ./installed-cargo-packages.json | each {
	|entry|
	if ($installed | where package == $entry.package) == [] {
		echo ""
		echo $"Installing ($entry.package) ..."
		cargo install $entry.package --version $"($entry.version.major).($entry.version.minor).($entry.version.patch)"
	}
}
echo
echo 'All packages are installed'
exit 0
