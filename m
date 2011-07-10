Return-path: <mchehab@localhost>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39799 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755984Ab1GJUAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 16:00:43 -0400
Date: Sun, 10 Jul 2011 12:58:32 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH 7/9] media/radio: fix trust CONFIG IO PORT
Message-Id: <20110710125832.fdcef732.rdunlap@xenotime.net>
In-Reply-To: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
References: <20110710125109.c72f9c2d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Modify radio-trust to use HEX_STRING(CONFIG_RADIO_TRUST_PORT)
so that the correct IO port value is used.

Fixes the IO port value that is used since this is hex:
CONFIG_RADIO_TRUST_PORT=350
but it was being interpreted as decimal instead of hex.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/media/radio/radio-trust.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- linux-next-20110707.orig/drivers/media/radio/radio-trust.c
+++ linux-next-20110707/drivers/media/radio/radio-trust.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/stringify.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
 #include <media/v4l2-device.h>
@@ -32,10 +33,12 @@ MODULE_VERSION("0.0.3");
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
 
 #ifndef CONFIG_RADIO_TRUST_PORT
-#define CONFIG_RADIO_TRUST_PORT -1
+#define __RADIO_TRUST_PORT -1
+#else
+#define __RADIO_TRUST_PORT HEX_STRING(CONFIG_RADIO_TRUST_PORT)
 #endif
 
-static int io = CONFIG_RADIO_TRUST_PORT;
+static int io = __RADIO_TRUST_PORT;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
