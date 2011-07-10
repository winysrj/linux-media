Return-path: <mchehab@localhost>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:43658 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755753Ab1GJUAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:45 -0400
Date: Sun, 10 Jul 2011 12:59:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 8/9] media/radio: fix typhoon CONFIG IO PORT
Message-Id: <20110710125917.ff61508d.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-typhoon to use HEX_STRING(CONFIG_RADIO_TYPHOON_PORT)
so that the correct IO port value is used.

Fixes the IO port value that is used since this is hex:
CONFIG_RADIO_TYPHOON_PORT=316
but it was being interpreted as decimal instead of hex.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-typhoon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-typhoon.c
+++ linux-next-20110707/drivers/media/radio/radio-typhoon.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>	/* Modules                        */
 #include <linux/init.h>		/* Initdata                       */
 #include <linux/ioport.h>	/* request_region		  */
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs           */
 #include <linux/io.h>		/* outb, outb_p                   */
 #include <media/v4l2-device.h>
@@ -44,14 +45,16 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
 
 #ifndef CONFIG_RADIO_TYPHOON_PORT
-#define CONFIG_RADIO_TYPHOON_PORT -1
+#define __RADIO_TYPHOON_PORT -1
+#else
+#define __RADIO_TYPHOON_PORT HEX_STRING(CONFIG_RADIO_TYPHOON_PORT)
 #endif
 
 #ifndef CONFIG_RADIO_TYPHOON_MUTEFREQ
 #define CONFIG_RADIO_TYPHOON_MUTEFREQ 0
 #endif
 
-static int io = CONFIG_RADIO_TYPHOON_PORT;
+static int io = __RADIO_TYPHOON_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
