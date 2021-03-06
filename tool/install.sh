#!/bin/sh

#  install.sh
#
#
#  Created by daye on 2021/1/8.
#  Copyright © 2021 Noah. All rights reserved.

TOOL_PATH="."
PAYLOAD_PATH="${TOOL_PATH}/Payload/"
TWEAK_PATH="../tweak"
TWEAK_DYLIB_NAME="FirstTweak.dylib"
TWEAK_DYLIB_PATH="${TWEAK_PATH}/.theos/_/Library/MobileSubstrate/DynamicLibraries/${TWEAK_DYLIB_NAME}"
TWEAK_CUR_DYLIB_PATH="${TOOL_PATH}/FirstTweak.dylib"
SUBSTRATE_LIB_NAME="libsubstrate.dylib"
ENTITLEMENTS_NAME="Entitlements.plist"
EN_PATH="en.plist"
ENTITLEMENTS_PATH="${TOOL_PATH}/${ENTITLEMENTS_NAME}"
ENTITLEMENTS_BAK_PATH="${TOOL_PATH}/entitlements_generator.plist"
OPTOOL_PATH="${TOOL_PATH}/optool"
PROVISION_NAME="embedded.mobileprovision"
XCODE_ENTITLEMENTS_PATH="${CONFIGURATION_TEMP_DIR}/${PRODUCT_NAME}.build/DerivedSources/${ENTITLEMENTS_NAME}"

# entitlements.plist key
TEAM_IDENTIFIER_KEY="com.apple.developer.team-identifier"
GET_TASK_ALLOW_KEY="get-task-allow"
KEYCHAIN_ACCESS_GROUPS="keychain-access-groups"
APPLICATION_IDENTIFIER_KEY="application-identifier"

cd "../tool/"

# 以下为app签名用的plist文件生成方法
#
#
# 该方法较复杂，建议直接从build目录中拷贝Entitlements.plist

function generate_plist() {
    
    #拷贝描述文件
    cp "${PAYLOAD_PATH}/${PRODUCT_NAME}.app/${PROVISION_NAME}" "${TOOL_PATH}/${PROVISION_NAME}"

    # 删除原来的entitlements.plist与en.plist并重新生成
    rm $ENTITLEMENTS_PATH
    rm $EN_PATH
    
    # 用模板生成en.plist
    cp $ENTITLEMENTS_BAK_PATH $EN_PATH
    
    # 生成entitlements.plist
    security cms -D -i "${TOOL_PATH}/${PROVISION_NAME}" > "${ENTITLEMENTS_PATH}"
    
    # 获取en.plist所需要的key对应的value
    team_identifier=$(/usr/libexec/PlistBuddy -c "Print Entitlements:${TEAM_IDENTIFIER_KEY}" $ENTITLEMENTS_PATH)
    get_task_allow=$(/usr/libexec/PlistBuddy -c "Print Entitlements:${GET_TASK_ALLOW_KEY}" $ENTITLEMENTS_PATH)
    application_identifier=$(/usr/libexec/PlistBuddy -c "Print Entitlements:${APPLICATION_IDENTIFIER_KEY}" $ENTITLEMENTS_PATH)
#    keychain_access_groups=$(/usr/libexec/PlistBuddy -c "Print Entitlements:${KEYCHAIN_ACCESS_GROUPS}" $ENTITLEMENTS_PATH)
    
    # 获取 KEYCHAIN_ACCESS_GROUPS 数组中的两个值
    keychain_access_groups_item0=$(/usr/libexec/PlistBuddy -c "Print Entitlements:${KEYCHAIN_ACCESS_GROUPS}:0" $ENTITLEMENTS_PATH)
    keychain_access_groups_item1=$(/usr/libexec/PlistBuddy -c "Print Entitlements:${KEYCHAIN_ACCESS_GROUPS}:1" $ENTITLEMENTS_PATH)

    # 为en.plist添加对应的key:value
    /usr/libexec/PlistBuddy -c "Add ${TEAM_IDENTIFIER_KEY} string ${team_identifier}" $EN_PATH
    /usr/libexec/PlistBuddy -c "Add ${GET_TASK_ALLOW_KEY} bool ${get_task_allow}" $EN_PATH
    /usr/libexec/PlistBuddy -c "Add ${APPLICATION_IDENTIFIER_KEY} string ${application_identifier}" $EN_PATH
    /usr/libexec/PlistBuddy -c "Add :${KEYCHAIN_ACCESS_GROUPS} array" $EN_PATH
    /usr/libexec/PlistBuddy -c "Add ${KEYCHAIN_ACCESS_GROUPS}: string ${keychain_access_groups_item0}" $EN_PATH
    /usr/libexec/PlistBuddy -c "Add ${KEYCHAIN_ACCESS_GROUPS}: string ${keychain_access_groups_item1}" $EN_PATH
    
    # 删除entitlements.plist
    rm $ENTITLEMENTS_PATH
}

# 移除Payload文件夹
rm -rf $PAYLOAD_PATH

# 重新创建Payload文件夹
mkdir $PAYLOAD_PATH

# 移除之前生成的FirstTweakDemo.ipa包
rm "${TOOL_PATH}/${PRODUCT_NAME}.ipa"

# 软链接build目录
ln -fhs "${BUILT_PRODUCTS_DIR}" "${TOOL_PATH}/LatestBuild"

# 拷贝FirstTweakDemo到Payload文件夹中
cp -rf "${TOOL_PATH}/LatestBuild/${PRODUCT_NAME}.app" "${PAYLOAD_PATH}"

# 拷贝FirstTweak.dylib到tool目录
cp $TWEAK_DYLIB_PATH "${TWEAK_CUR_DYLIB_PATH}"

# 修改FirstTweak.dylib的CydiaSubstrate依赖
install_name_tool -change /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate @executable_path/Frameworks/libsubstrate.dylib "${TWEAK_CUR_DYLIB_PATH}"

# 查看FirstTweak.dylib的依赖
otool -l $TWEAK_CUR_DYLIB_PATH | grep name

# 将FirstTweak.dylib注入FirstTweakDemo二进制文件中
#"./${OPTOOL_PATH}" install -c load -p "@executable_path/Frameworks/${TWEAK_DYLIB_NAME}" -t "${PAYLOAD_PATH}""${PRODUCT_NAME}.app/${PRODUCT_NAME}"

# 对FirstTweak.dylib与libsubstrate.dylib库签名
codesign -fs $EXPANDED_CODE_SIGN_IDENTITY $TWEAK_CUR_DYLIB_PATH
codesign -fs $EXPANDED_CODE_SIGN_IDENTITY "${TOOL_PATH}/${SUBSTRATE_LIB_NAME}"

# 创建FirstTweakDemo.app/Frameworks/文件夹
mkdir "${PAYLOAD_PATH}""${PRODUCT_NAME}.app/Frameworks/"

# 拷贝FirstTweak.dylib与libsubstrate.dylib到/FirstTweakDemo.app/Frameworks/文件夹
#cp $TWEAK_CUR_DYLIB_PATH "${PAYLOAD_PATH}/${PRODUCT_NAME}.app/Frameworks/${TWEAK_DYLIB_NAME}"
#cp "${TOOL_PATH}/${SUBSTRATE_LIB_NAME}" "${PAYLOAD_PATH}/${PRODUCT_NAME}.app/Frameworks/${SUBSTRATE_LIB_NAME}"

# 调用生成en.plist文件的方法
generate_plist

# 从build目录中拷贝Entitlements.plist文件
cp $XCODE_ENTITLEMENTS_PATH .

echo "EXPANDED_CODE_SIGN_IDENTITY:$EXPANDED_CODE_SIGN_IDENTITY"
# 对FirstTweakDemo.app签名
#codesign -fs $EXPANDED_CODE_SIGN_IDENTITY --no-strict --entitlements="${ENTITLEMENTS_PATH}" "${PAYLOAD_PATH}${PRODUCT_NAME}.app"

# 重新生成FirstTweakDemo.ipa包
#zip -ry "${PRODUCT_NAME}.ipa" Payload

codesign -fs $EXPANDED_CODE_SIGN_IDENTITY --no-strict --entitlements="${EN_PATH}" "${PAYLOAD_PATH}${PRODUCT_NAME}.app"

# 重新生成FirstTweakDemo.ipa包
zip -ry "${PRODUCT_NAME}.ipa" Payload
