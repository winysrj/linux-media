Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:61517 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbdLEVxS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 16:53:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kasan-dev@googlegroups.com,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        linux-kbuild@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Wilck <mwilck@suse.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] string.h: work around for increased stack usage
Date: Tue,  5 Dec 2017 22:51:19 +0100
Message-Id: <20171205215143.3085755-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardened strlen() function causes rather large stack usage in at
least one file in the kernel, in particular when CONFIG_KASAN is enabled:

drivers/media/usb/em28xx/em28xx-dvb.c: In function 'em28xx_dvb_init':
drivers/media/usb/em28xx/em28xx-dvb.c:2062:1: error: the frame size of 3256 bytes is larger than 204 bytes [-Werror=frame-larger-than=]

Analyzing this problem led to the discovery that gcc fails to merge the
stack slots for the i2c_board_info[] structures after we strlcpy() into
them, due to the 'noreturn' attribute on the source string length check.

I reported this as a gcc bug, but it is unlikely to get fixed for gcc-8,
since it is relatively easy to work around, and it gets triggered rarely.
An earlier workaround I did added an empty inline assembly statement
before the call to fortify_panic(), which works surprisingly well,
but is really ugly and unintuitive.

This is a new approach to the same problem, this time addressing it by
not calling the 'extern __real_strnlen()' function for string constants
where __builtin_strlen() is a compile-time constant and therefore known
to be safe. We do this by checking if the last character in the string
is a compile-time constant '\0'. If it is, we can assume that
strlen() of the string is also constant. As a side-effect, this should
also improve the object code output for any other call of strlen()
on a string constant.

Cc: stable@vger.kernel.org
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82365
Link: https://patchwork.kernel.org/patch/9980413/
Link: https://patchwork.kernel.org/patch/9974047/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v3: don't use an asm barrier but use a constant string change.

Aside from two other patches for drivers/media that I sent last week,
this should fix all stack frames above 2KB, once all three are merged,
I'll send the patch to re-enable the warning.
---
 include/linux/string.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 410ecf17de3c..e5cc3f27f6e0 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -259,7 +259,8 @@ __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 {
 	__kernel_size_t ret;
 	size_t p_size = __builtin_object_size(p, 0);
-	if (p_size == (size_t)-1)
+	if (p_size == (size_t)-1 ||
+	    (__builtin_constant_p(p[p_size - 1]) && p[p_size - 1] == '\0'))
 		return __builtin_strlen(p);
 	ret = strnlen(p, p_size);
 	if (p_size <= ret)
-- 
2.9.0
