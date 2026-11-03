# وضعیت فنی و محدودیت‌ها

## آنچه تأیید شده است
- SDK رسمی دقیق برای OpenWrt 25.12.6 و target `ipq40xx/chromium` منتشر شده است.
- معماری هدف روتر ARMv7 با `arm_cortex-a7_neon-vfpv4` است.
- راهنمای Linux CLI Windscribe نسخه 2.25 گزینه‌های ManualConnectionProtocol برای WireGuard، UDP، TCP، Stealth و WStunnel و ManualConnectionPort را مستند می‌کند.
- همان راهنما `AmneziawgPreset` را مشروط به `CircumventCensorship=true` می‌داند.
- مستند رسمی می‌گوید `CircumventCensorship` به درخواست‌های API مربوط است؛ نباید آن را به‌تنهایی obfuscation تونل تلقی کرد.
- WSNet API و روش‌های متعدد ضدسانسور دسترسی به API را پوشش می‌دهد، اما manifest عمومی آن به registry خصوصی Windscribe برای curl/OpenSSL patch شده ارجاع می‌دهد.
- WStunnel رسمی Windscribe، OpenVPN TCP را از WebSocket یا TCP/Stunnel عبور می‌دهد.

## موارد پیاده‌سازی‌نشده
احراز هویت، API adapter، server catalog، port discovery، دریافت AWG profile/PSK، tunnel adapters، failover، kill switch، DNS/IPv6 leak protection، split routing، ROBERT و proxy.

## قاعده ایمنی
تا وقتی یک قابلیت روی سخت‌افزار واقعی تست نشده، در UI به‌عنوان آماده نمایش داده نمی‌شود. نصب این foundation نباید تنظیمات شبکه را تغییر دهد.
