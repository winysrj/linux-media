Return-path: <mchehab@localhost>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:51498 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755747Ab1GJUAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:39 -0400
Date: Sun, 10 Jul 2011 12:55:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 4/9] media/radio: fix gemtek CONFIG IO PORT
Message-Id: <20110710125545.8f010dd7.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-gemtek to use HEX_STRING(CONFIG_RADIO_GEMTEK_PORT)
so that the correct IO port value is used.

Fixes this error message when CONFIG_RADIO_GEMTEK_PORT=34c:
drivers/media/radio/radio-gemtek.c:49:18: error: invalid suffix "c" on integer constant

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-gemtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-gemtek.c
+++ linux-next-20110707/drivers/media/radio/radio-gemtek.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* udelay			*/
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/mutex.h>
 #include <linux/io.h>		/* outb, outb_p			*/
@@ -40,13 +41,15 @@ MODULE_VERSION("0.0.4");
  */
 
 #ifndef CONFIG_RADIO_GEMTEK_PORT
-#define CONFIG_RADIO_GEMTEK_PORT -1
+#define __RADIO_GEMTEK_PORT -1
+#else
+#define __RADIO_GEMTEK_PORT HEX_STRING(CONFIG_RADIO_GEMTEK_PORT)
 #endif
 #ifndef CONFIG_RADIO_GEMTEK_PROBE
 #define CONFIG_RADIO_GEMTEK_PROBE 1
 #endif
 
-static int io		= CONFIG_RADIO_GEMTEK_PORT;
+static int io		= __RADIO_GEMTEK_PORT;
 static int probe	= CONFIG_RADIO_GEMTEK_PROBE;
 static int hardmute;
 static int shutdown	= 1;
