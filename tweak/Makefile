include $(THEOS)/makefiles/common.mk

THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 22222

TWEAK_NAME = FirstTweak
FirstTweak_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
