#!/bin/bash
# inject-plist.sh
# 在云端 Mac 上，向 Capacitor 生成的 iOS 工程 Info.plist 注入相机/麦克风/相册权限说明。
# 审核必查项；缺少这些 key 会导致调用摄像头时闪退或被拒审。
# 在 mobile/ 目录下执行: bash scripts/inject-plist.sh
set -e

PLIST="ios/App/App/Info.plist"

if [ ! -f "$PLIST" ]; then
  echo "[inject-plist] 找不到 $PLIST（请先执行 npx cap add ios）"
  exit 1
fi

PB=/usr/libexec/PlistBuddy

add_key () {
  local key="$1"; local val="$2"
  if $PB -c "Print :$key" "$PLIST" >/dev/null 2>&1; then
    $PB -c "Set :$key $val" "$PLIST"
    echo "[inject-plist] 更新 $key"
  else
    $PB -c "Add :$key string $val" "$PLIST"
    echo "[inject-plist] 添加 $key"
  fi
}

add_key "NSCameraUsageDescription" "AICAM uses the camera to preview and capture photos and videos with AI filters."
add_key "NSMicrophoneUsageDescription" "AICAM uses the microphone to record sound when you capture video."
add_key "NSPhotoLibraryAddUsageDescription" "AICAM saves the photos and videos you capture to your photo library."
add_key "NSPhotoLibraryUsageDescription" "AICAM shows your saved photos in the in-app gallery."

# 出口合规（Export Compliance）：声明 App 仅使用豁免加密（HTTPS），
# 设为 false 后 TestFlight 不再对每个构建要求手动填写出口合规问卷。
if $PB -c "Print :ITSAppUsesNonExemptEncryption" "$PLIST" >/dev/null 2>&1; then
  $PB -c "Set :ITSAppUsesNonExemptEncryption false" "$PLIST"
  echo "[inject-plist] 更新 ITSAppUsesNonExemptEncryption = false"
else
  $PB -c "Add :ITSAppUsesNonExemptEncryption bool false" "$PLIST"
  echo "[inject-plist] 添加 ITSAppUsesNonExemptEncryption = false"
fi

echo "[inject-plist] 完成。"
