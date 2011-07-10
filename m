Return-path: <mchehab@localhost>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:42397 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754922Ab1GJUAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:39 -0400
Date: Sun, 10 Jul 2011 12:54:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 3/9] media/radio: fix aztech CONFIG IO PORT
Message-Id: <20110710125454.acdc6758.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-aztech to use HEX_STRING(CONFIG_RADIO_AZTECH_PORT)
so that the correct IO port value is used.

Fixes the IO port value that is used since this is hex:
CONFIG_RADIO_AZTECH_PORT=350
but it was being interpreted as decimal instead of hex.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-aztech.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-aztech.c
+++ linux-next-20110707/drivers/media/radio/radio-aztech.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* udelay			*/
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
@@ -42,10 +43,12 @@ MODULE_VERSION("0.0.3");
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
 
 #ifndef CONFIG_RADIO_AZTECH_PORT
-#define CONFIG_RADIO_AZTECH_PORT -1
+#define __RADIO_AZTECH_PORT -1
+#else
+#define __RADIO_AZTECH_PORT HEX_STRING(CONFIG_RADIO_AZTECH_PORT)
 #endif
 
-static int io = CONFIG_RADIO_AZTECH_PORT;
+static int io = __RADIO_AZTECH_PORT;
 static int radio_nr = -1;
 static int radio_wait_time = 1000;
 
