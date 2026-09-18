ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = CarPlay
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = TestTa
TestTa_FILES = Tweak.xm
TestTa_FRAMEWORKS = UIKit QuartzCore Foundation
TestTa_CFLAGS = -fobjc-arc -Werror
include $(THEOS_MAKE_PATH)/tweak.mk
