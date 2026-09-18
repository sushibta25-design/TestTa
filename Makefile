ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = TestTa
TestTa_FILES = Tweak.xm
TestTa_CFLAGS = -fobjc-arc -Werror
TestTa_FRAMEWORKS = UIKit Foundation QuartzCore
include $(THEOS_MAKE_PATH)/tweak.mk
