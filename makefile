# Define variables
APP_NAME := Frosty\ Keys
BUILD_DIR := build/$(APP_NAME).app
CONTENTS_DIR := $(BUILD_DIR)/Contents
MACOS_DIR := $(CONTENTS_DIR)/MacOS
VERSION := $(shell cat VERSION)
BUILD_ID := $(shell uuidgen | sed y/ABCDEF/abcdef/)
DATE := $(shell date)

# Targets and dependencies
all: clean $(MACOS_DIR)/Frosty-Keys Info.plist Frosty-Keys-build.txt

# Clean up the existing build directory
clean:
	rm -rf build

# Create necessary directories
$(CONTENTS_DIR):
	mkdir -p $(CONTENTS_DIR)

$(MACOS_DIR): $(CONTENTS_DIR)
	mkdir -p $(MACOS_DIR)

# Generate Info.plist file
Info.plist: $(CONTENTS_DIR)
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $(CONTENTS_DIR)/Info.plist
	echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $(CONTENTS_DIR)/Info.plist
	echo '<plist version="1.0">' >> $(CONTENTS_DIR)/Info.plist
	echo '<dict>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleName</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>Frosty Keys</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleDisplayName</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>Frosty Keys</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleExecutable</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>Frosty-Keys</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleIdentifier</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>com.github.gltchitm.FrostyKeys</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundlePackageType</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>APPL</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleVersion</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>$(VERSION)</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleShortVersionString</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>$(VERSION)</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>CFBundleSupportedPlatforms</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <array>' >> $(CONTENTS_DIR)/Info.plist
	echo '        <string>MacOSX</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    </array>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>LSMinimumSystemVersion</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <string>11.0</string>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <key>LSUIElement</key>' >> $(CONTENTS_DIR)/Info.plist
	echo '    <true />' >> $(CONTENTS_DIR)/Info.plist
	echo '</dict>' >> $(CONTENTS_DIR)/Info.plist
	echo '</plist>' >> $(CONTENTS_DIR)/Info.plist

# Generate Frosty-Keys-build.txt file
Frosty-Keys-build.txt: $(CONTENTS_DIR)
	echo 'Frosty Keys' > $(CONTENTS_DIR)/Frosty-Keys-build.txt
	echo '' >> $(CONTENTS_DIR)/Frosty-Keys-build.txt
	echo 'Version: $(VERSION)' >> $(CONTENTS_DIR)/Frosty-Keys-build.txt
	echo 'Build ID: $(BUILD_ID)' >> $(CONTENTS_DIR)/Frosty-Keys-build.txt
	echo 'Built: $(DATE)' >> $(CONTENTS_DIR)/Frosty-Keys-build.txt

# Compile the source code
$(MACOS_DIR)/Frosty-Keys: $(MACOS_DIR)
	clang -framework Cocoa -o $(MACOS_DIR)/Frosty-Keys src/main.m src/GradientView.m

# Print build information
.PHONY: info
info:
	@echo "Built Frosty Keys!"
	@echo "  Version: $(VERSION)"
	@echo "  Build ID: $(BUILD_ID)"
