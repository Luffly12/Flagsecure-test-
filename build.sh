#!/bin/bash
set -e
ROOT=/sandbox/workspace/apkbuild
BT=$ROOT/bt/android-14
JAR=$ROOT/pf/android-34/android.jar
SRC=$ROOT/src
OUT=$ROOT/out
rm -rf $OUT
mkdir -p $OUT/gen $OUT/classes $OUT/dex

echo "== 1. compile resources =="
$BT/aapt2 compile --dir $SRC/res -o $OUT/res.zip

echo "== 2. link =="
$BT/aapt2 link -o $OUT/base.apk -I $JAR \
  --manifest $SRC/AndroidManifest.xml \
  -R $OUT/res.zip \
  --auto-add-overlay \
  --java $OUT/gen \
  --min-sdk-version 24 --target-sdk-version 34 \
  --version-code 1 --version-name 1.0

echo "== 3. javac =="
if javac --release 8 -d $OUT/classes -classpath $JAR \
     $SRC/java/fun/test/flagsecure/MainActivity.java \
     $OUT/gen/fun/test/flagsecure/R.java 2>/tmp/jc8.log; then
  echo "compiled with release 8"
else
  echo "release 8 failed, trying 11"; cat /tmp/jc8.log
  javac --release 11 -d $OUT/classes -classpath $JAR \
     $SRC/java/fun/test/flagsecure/MainActivity.java \
     $OUT/gen/fun/test/flagsecure/R.java
fi

echo "== 4. d8 =="
java -cp $ROOT/r8.jar com.android.tools.r8.D8 --lib $JAR --min-api 24 --output $OUT/dex $(find $OUT/classes -name '*.class')

echo "== 5. add classes.dex =="
python3 - <<'PY'
import zipfile
base="/sandbox/workspace/apkbuild/out/base.apk"
dex="/sandbox/workspace/apkbuild/out/dex/classes.dex"
with zipfile.ZipFile(base,"a",zipfile.ZIP_DEFLATED) as z:
    z.write(dex,"classes.dex")
print("classes.dex added")
PY

echo "== 6. zipalign =="
$BT/zipalign -f 4 $OUT/base.apk $OUT/aligned.apk

echo "== 7. keystore =="
keytool -genkeypair -keystore $OUT/ks.jks -alias k -keyalg RSA -keysize 2048 \
  -validity 10000 -storepass android -keypass android \
  -dname "CN=flagsecuretest,O=test,C=CN" 2>/dev/null

echo "== 8. sign =="
$BT/apksigner sign --ks $OUT/ks.jks --ks-pass pass:android --key-pass pass:android \
  --out $OUT/FlagSecureTest.apk $OUT/aligned.apk

echo "== 9. verify =="
$BT/apksigner verify --verbose $OUT/FlagSecureTest.apk
ls -la $OUT/FlagSecureTest.apk
echo "BUILD OK"
