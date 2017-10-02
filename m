Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53058 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751065AbdJBIl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Oct 2017 04:41:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: David Laight <David.Laight@aculab.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-media @ vger . kernel . org" <linux-media@vger.kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "kasan-dev @ googlegroups . com" <kasan-dev@googlegroups.com>,
        "linux-kbuild @ vger . kernel . org" <linux-kbuild@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] string.h: work around for increased stack usage
Date: Mon,  2 Oct 2017 10:40:55 +0200
Message-Id: <20171002084119.3504771-1-arnd@arndb.de>
In-Reply-To: <CAK8P3a0WtHjvo6tOp79U4gKjLSRmVCAmjYU_xTVJfBL1Qe-hdQ@mail.gmail.com>
References: <CAK8P3a0WtHjvo6tOp79U4gKjLSRmVCAmjYU_xTVJfBL1Qe-hdQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardened strlen() function causes rather large stack usage
in at least one file in the kernel when CONFIG_KASAN is enabled:

drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_init':
drivers/media/usb/em28xx/em28xx-dvb.c:2062:1: error: the frame size of 3256 bytes is larger than 204 bytes [-Werror=frame-larger-than=]

Analyzing this problem led to the discovery that gcc fails to
merge the stack slots for the i2c_board_info[] structures after
we strlcpy() into them, due to the 'noreturn' attribute on the
source string length check.

The compiler behavior should get fixed in gcc-8, but for users
of existing gcc versions, we can work around it using an empty
inline assembly statement before the call to fortify_panic().

The workaround is unfortunately very ugly, and I tried my best
to limit it being applied to affected versions of gcc when
KASAN is used. Alternative suggestions welcome.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/string.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index c7a1132cdc93..1bf5ecdf8e01 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -228,6 +228,16 @@ static inline const char *kbasename(const char *path)
 #define __RENAME(x) __asm__(#x)
 
 void fortify_panic(const char *name) __noreturn __cold;
+
+/* work around GCC PR82365 */
+#if defined(CONFIG_KASAN) && !defined(__clang__) && GCC_VERSION <= 80000
+#define fortify_panic(x) \
+	do { \
+		asm volatile(""); \
+		fortify_panic(x); \
+	} while (0)
+#endif
+
 void __read_overflow(void) __compiletime_error("detected read beyond size of object passed as 1st parameter");
 void __read_overflow2(void) __compiletime_error("detected read beyond size of object passed as 2nd parameter");
 void __read_overflow3(void) __compiletime_error("detected read beyond size of object passed as 3rd parameter");
-- 
2.9.0
