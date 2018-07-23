Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42093 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388135AbeGWWmq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 18:42:46 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        David Miller <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] media: staging: omap4iss: Include asm/cacheflush.h after generic includes
Date: Mon, 23 Jul 2018 14:39:33 -0700
Message-Id: <1532381973-11856-1-git-send-email-linux@roeck-us.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Including asm/cacheflush.h first results in the following build error when
trying to build sparc32:allmodconfig.

In file included from arch/sparc/include/asm/page.h:10:0,
                 from arch/sparc/include/asm/string_32.h:13,
                 from arch/sparc/include/asm/string.h:7,
                 from include/linux/string.h:20,
                 from include/linux/bitmap.h:9,
                 from include/linux/cpumask.h:12,
                 from arch/sparc/include/asm/smp_32.h:15,
                 from arch/sparc/include/asm/smp.h:7,
                 from arch/sparc/include/asm/switch_to_32.h:5,
                 from arch/sparc/include/asm/switch_to.h:7,
                 from arch/sparc/include/asm/ptrace.h:120,
                 from arch/sparc/include/asm/thread_info_32.h:19,
                 from arch/sparc/include/asm/thread_info.h:7,
                 from include/linux/thread_info.h:38,
                 from arch/sparc/include/asm/current.h:15,
                 from include/linux/mutex.h:14,
                 from include/linux/notifier.h:14,
                 from include/linux/clk.h:17,
                 from drivers/staging/media/omap4iss/iss_video.c:15:
include/linux/highmem.h: In function 'clear_user_highpage':
include/linux/highmem.h:137:31: error:
	passing argument 1 of 'sparc_flush_page_to_ram' from incompatible
	pointer type

Include generic includes files first to fix the problem.

Fixes: fc96d58c10162 ("[media] v4l: omap4iss: Add support for OMAP4 camera interface - Video devices")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/staging/media/omap4iss/iss_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index a3a83424a926..16478fe9e3f8 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -11,7 +11,6 @@
  * (at your option) any later version.
  */
 
-#include <asm/cacheflush.h>
 #include <linux/clk.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -24,6 +23,8 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-mc.h>
 
+#include <asm/cacheflush.h>
+
 #include "iss_video.h"
 #include "iss.h"
 
-- 
2.7.4
