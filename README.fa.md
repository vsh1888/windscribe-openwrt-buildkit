# Windscribe OpenWrt Foundation — 0.3.1

## وضعیت واقعی این نسخه
این نسخه فقط بسته پایه تشخیصی LuCI است؛ کلاینت Windscribe نیست و هیچ تونل VPN ایجاد نمی‌کند. ورود حساب، API رسمی، فهرست پویای سرورها، دریافت پروفایل AmneziaWG، انتخاب پروتکل و مدیریت تونل هنوز پیاده‌سازی نشده‌اند.

## اصلاح خطای نسخه قبلی
نسخه 0.2.0 اشتباهاً تلاش می‌کرد روی خود روتر با `apk mkpkg` بسته بسازد. این نسخه این روش را حذف کرده است. بسته باید با SDK رسمی OpenWrt ساخته شود و سپس فایل APK آماده روی روتر نصب شود.

## مشخصات ساخت
- OpenWrt 25.12.6
- Target: ipq40xx/chromium
- Architecture: arm_cortex-a7_neon-vfpv4
- SDK: GCC 14.3.0 / musl EABI / Linux x86_64
- SDK SHA256: `4226c554ae78bf9ade6b6f282dc5961d0e4f56209b4970db3a87c1363b60eda2`

## ساخت در Linux یا WSL2
پیش‌نیازها: make, curl, zstd, sha256sum و وابستگی‌های build معمول OpenWrt.

```sh
chmod +x build-sdk.sh
./build-sdk.sh
```
خروجی در `dist/` قرار می‌گیرد. SDK حدود 238 MB است و checksum قبل از استخراج بررسی می‌شود.

## ساخت با GitHub Actions (روش پیشنهادی برای Windows)
این ZIP را روی کامپیوتر استخراج کن. فایل ZIP را به روتر منتقل نکن؛ هنوز APK نیست.

1. در GitHub یک repository جدید و خالی بساز؛ گزینه‌های Add a README، .gitignore و License را فعال نکن.
2. Git for Windows را نصب کن و در PowerShell با `git --version` مطمئن شو نصب است.
3. PowerShell را در پوشه استخراج‌شده پروژه باز کن؛ همان پوشه‌ای که `README.fa.md` و پوشه `.github` را دارد.
4. دستورات زیر را اجرا کن و آدرس repository خودت را جایگزین کن:

```powershell
git init -b main
git add .
git commit -m "Add Windscribe OpenWrt buildkit"
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

5. در صفحه repository در GitHub به تب Actions برو، workflow با نام `Build OpenWrt APK` را باز کن و `Run workflow` را اجرا کن. اگر workflow دیده نمی‌شود، بررسی کن پوشه `.github/workflows` در ریشه repository آپلود شده باشد.
6. پس از سبز شدن Build، وارد همان اجرای workflow شو و از قسمت Artifacts فایل `windscribe-openwrt-apk-armv7` را دانلود و از حالت ZIP خارج کن. Artifact باید APK و فایل SHA256 را داشته باشد.

در GitHub Actions از Ubuntu 24.04 استفاده می‌شود؛ بسته `python3-distutils` از وابستگی‌ها حذف شده چون در Ubuntu 24.04 وجود ندارد.

## نصب روی روتر
فقط پس از Build موفق، فایل APK داخل Artifact را با SCP به `/tmp` منتقل کن. فایل SHA256 را نیز منتقل کن. سپس در SSH روتر، از پوشه `/tmp` checksum را بررسی کن:

```sh
cd /tmp
sha256sum -c نام-واقعی-فایل.apk.sha256
```

اگر پیام `OK` گرفتی، APK را نصب کن (نام واقعی فایل را جایگزین کن):

```sh
apk add --allow-untrusted /tmp/نام-واقعی-فایل.apk
rm -f /tmp/luci-indexcache /tmp/luci-modulecache
```

برای حذف:

```sh
apk del luci-app-windscribe-bootstrap
```

این بسته هیچ تنظیمی از PassWall2، route، firewall، DNS یا interfaceهای VPN را تغییر نمی‌دهد.

## مسیر کلاینت واقعی
برای کلاینت کامل باید WSNet و وابستگی‌هایش برای musl/ARMv7 ساخته شوند؛ repository رسمی WSNet در پیکربندی vcpkg به registry اختصاصی Windscribe برای نسخه‌های patchشده curl/OpenSSL اشاره می‌کند. بنابراین بدون آن dependencyها، معادل‌سازی کامل API anti-censorship رسمی تضمین‌شدنی نیست. پروتکل WStunnel رسمی Windscribe نیز یک helper مستقل برای عبور دادن OpenVPN TCP از WebSocket یا Stunnel است و صرف نصب stunnel جایگزین آن نیست.

گام‌های بعدی باید جداگانه شامل WSNet/API، adapterهای tunnel، state manager و سیاست‌های شبکه با rollback و آزمون عدم تداخل با PassWall2 باشند. هیچ‌کدام در این نسخه ادعا نمی‌شوند.
