#!/bin/bash
# bump-ios-min.sh
# 将 Capacitor 7 生成的 iOS 工程最低部署版本从 14.0 提升到 15.0，
# 消除 App Store Connect 的 ITMS-90068 警告（2027 年春起强制 iOS 15.0+）。
# 在 mobile/ 目录下执行: bash scripts/bump-ios-min.sh
set -e

PBX="ios/App/App.xcodeproj/project.pbxproj"
PODFILE="ios/App/Podfile"

if [ ! -f "$PBX" ]; then
  echo "[bump-ios-min] 找不到 $PBX（请先执行 npx cap add ios）"
  exit 1
fi

# Xcode 工程：所有 target 的部署目标 14.0 -> 15.0
if grep -q "IPHONEOS_DEPLOYMENT_TARGET = 14.0;" "$PBX"; then
  sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 14.0;/IPHONEOS_DEPLOYMENT_TARGET = 15.0;/g' "$PBX"
  echo "[bump-ios-min] project.pbxproj 部署目标已提升到 15.0"
else
  echo "[bump-ios-min] project.pbxproj 中未发现 14.0，检查当前值："
  grep "IPHONEOS_DEPLOYMENT_TARGET" "$PBX" || true
fi

# Podfile：platform :ios, '14.0' -> '15.0'
if [ -f "$PODFILE" ] && grep -q "platform :ios, '14.0'" "$PODFILE"; then
  sed -i '' "s/platform :ios, '14.0'/platform :ios, '15.0'/g" "$PODFILE"
  echo "[bump-ios-min] Podfile 平台版本已提升到 15.0，重新执行 pod install"
  cd ios/App && pod install && cd ../..
fi

echo "[bump-ios-min] 完成。"
