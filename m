Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49828 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZIXK7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 06:59:16 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com,
	Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 1/2] media: video: pwc: Use kernel's simple_strtol()
Date: Thu, 24 Sep 2009 13:58:09 +0300
Message-Id: <1253789890-31262-1-git-send-email-andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Change own implementation of pwc_atoi() by simple_strtol(x, NULL, 10).

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/media/video/pwc/pwc-if.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f976df4..89b620f 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -68,6 +68,7 @@
 #endif
 #include <linux/vmalloc.h>
 #include <asm/io.h>
+#include <linux/kernel.h>		/* simple_strtol() */
 
 #include "pwc.h"
 #include "pwc-kiara.h"
@@ -1916,19 +1917,6 @@ disconnect_out:
 	unlock_kernel();
 }
 
-/* *grunt* We have to do atoi ourselves :-( */
-static int pwc_atoi(const char *s)
-{
-	int k = 0;
-
-	k = 0;
-	while (*s != '\0' && *s >= '0' && *s <= '9') {
-		k = 10 * k + (*s - '0');
-		s++;
-	}
-	return k;
-}
-
 
 /*
  * Initialization code & module stuff
@@ -2078,13 +2066,16 @@ static int __init usb_pwc_init(void)
 				}
 				else {
 					/* No type or serial number specified, just a number. */
-					device_hint[i].device_node = pwc_atoi(s);
+					device_hint[i].device_node =
+						simple_strtol(s, NULL, 10);
 				}
 			}
 			else {
 				/* There's a colon, so we have at least a type and a device node */
-				device_hint[i].type = pwc_atoi(s);
-				device_hint[i].device_node = pwc_atoi(colon + 1);
+				device_hint[i].type =
+					simple_strtol(s, NULL, 10);
+				device_hint[i].device_node =
+					simple_strtol(colon + 1, NULL, 10);
 				if (*dot != '\0') {
 					/* There's a serial number as well */
 					int k;
-- 
1.5.6.5

