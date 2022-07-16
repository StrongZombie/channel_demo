# 创建文件夹 与 clean操作
if [ ! -d '../output_dir' ]; then
  mkdir '../output_dir'
fi
rm -rf ../output_dir/*

# 接收渠道参数
channel=$1
# 接收平台参数，默认android + ios  可以指定android 或者 ios
platform=$2
channel_low=`echo $channel | tr 'A-Z' 'a-z'}`
echo "[channel]：${channel}"
echo "[platform]：${platform}"

# 打包操作
if [ ! -n "$platform" ]; then
  echo 'all'
  flutter build apk --flavor ${channel} --dart-define=CHANNEL=${channel}
  mv ../build/app/outputs/flutter-apk/app-${channel_low}-release.apk ../output_dir/app-${channel}-release.apk
  flutter build ios --release
  flutter build ipa --flavor ${channel} --dart-define=CHANNEL=${channel}
  mv ../build/ios/archive/${channel}.xcarchive ../output_dir/${channel}.xcarchive
else
  if [ $platform == 'android' ]; then
    flutter build apk --flavor ${channel} --dart-define=CHANNEL=${channel}
    mv ../build/app/outputs/flutter-apk/app-${channel_low}-release.apk ../output_dir/app-${channel}-release.apk
  elif [ $platform == 'ios' ]; then
    flutter build ios --release
    flutter build ipa --flavor ${channel} --dart-define=CHANNEL=${channel}
    mv ../build/ios/archive/${channel}.xcarchive ../output_dir/${channel}.xcarchive
  else
    echo 'all'
    flutter build apk --flavor ${channel} --dart-define=CHANNEL=${channel}
    mv ../build/app/outputs/flutter-apk/app-${channel_low}-release.apk ../output_dir/app-${channel}-release.apk
    flutter build ios --release
    flutter build ipa --flavor ${channel} --dart-define=CHANNEL=${channel}
    mv ../build/ios/archive/${channel}.xcarchive ../output_dir/${channel}.xcarchive
  fi
fi

# 上传output_dir里的打包文件到cstore,钉钉,企业微信等....

