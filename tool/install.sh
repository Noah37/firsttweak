#!/bin/sh

#  install.sh
#
#
#  Created by daye on 2021/1/8.
#  Copyright © 2021 Noah. All rights reserved.


rm -rf Payload/

cp -rf FiirstTweakDemo.app Payload/FiirstTweakDemo.app

mkdir Payload

install_name_tool -change /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate @executable_path/Frameworks/libsubstrate.dylib FirstTweak.dylib

otool -l FirstTweak.dylib | grep name

codesign -fs 'Apple Development: shan qing (98CAZ6JP9W)' FirstTweak.dylib

mkdir Payload/FiirstTweakDemo.app/Frameworks/

cp FirstTweak.dylib Payload/FiirstTweakDemo.app/Frameworks/
cp libsubstrate.dylib Payload/FiirstTweakDemo.app/Frameworks/

./optool install -c load -p "@executable_path/Frameworks/FirstTweak.dylib" -t Payload/FiirstTweakDemo.app/FiirstTweakDemo

codesign -fs 'Apple Development: shan qing (98CAZ6JP9W)' --no-strict --entitlements=entitlements.plist Payload/FiirstTweakDemo.app

rm FirstTweakDemo.ipa

zip -ry FirstTweakDemo.ipa Payload
