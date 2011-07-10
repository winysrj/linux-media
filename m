Return-path: <mchehab@localhost>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:47926 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755939Ab1GJUAm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:42 -0400
Date: Sun, 10 Jul 2011 12:57:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 6/9] media/radio: fix terratec CONFIG IO PORT
Message-Id: <20110710125736.0a16e25d.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-terratec to use HEX_STRING(CONFIG_RADIO_TERRATEC_PORT)
so that the correct IO port value is used.

Fixes the IO port value that is used since this is hex:
CONFIG_RADIO_TERRATEC_PORT=590
but it was being interpreted as decimal instead of hex.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-terratec.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-terratec.c
+++ linux-next-20110707/drivers/media/radio/radio-terratec.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>	/* Modules 			*/
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
@@ -39,10 +40,12 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_TERRATEC_PORT
-#define CONFIG_RADIO_TERRATEC_PORT 0x590
+#define __RADIO_TERRATEC_PORT 0x590
+#else
+#define __RADIO_TERRATEC_PORT HEX_STRING(CONFIG_RADIO_TERRATEC_PORT)
 #endif
 
-static int io = CONFIG_RADIO_TERRATEC_PORT;
+static int io = __RADIO_TERRATEC_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
