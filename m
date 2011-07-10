Return-path: <mchehab@localhost>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:60700 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755470Ab1GJUAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:38 -0400
Date: Sun, 10 Jul 2011 12:53:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 2/9] media/radio: fix aimslab CONFIG IO PORT
Message-Id: <20110710125356.b6cb17c2.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-aimslab to use HEX_STRING(CONFIG_RADIO_RTRACK_PORT)
so that the correct IO port value is used.

Fixes this error message when CONFIG_RADIO_RTRACK_PORT=20f:
drivers/media/radio/radio-aimslab.c:49:17: error: invalid suffix "f" on integer constant

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-aimslab.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-aimslab.c
+++ linux-next-20110707/drivers/media/radio/radio-aimslab.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>		/* Initdata			*/
 #include <linux/ioport.h>	/* request_region		*/
 #include <linux/delay.h>	/* msleep			*/
+#include <linux/stringify.h>
 #include <linux/videodev2.h>	/* kernel radio structs		*/
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
@@ -43,10 +44,12 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.3");
 
 #ifndef CONFIG_RADIO_RTRACK_PORT
-#define CONFIG_RADIO_RTRACK_PORT -1
+#define __RADIO_RTRACK_PORT -1
+#else
+#define __RADIO_RTRACK_PORT HEX_STRING(CONFIG_RADIO_RTRACK_PORT)
 #endif
 
-static int io = CONFIG_RADIO_RTRACK_PORT;
+static int io = __RADIO_RTRACK_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
