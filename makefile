# LyricBar makefile

build:
	xcodebuild -project LyricBar.xcodeproj/
	mv build/Release/LyricBar.app ./
	rm -rf build
