Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaADR0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:26:08 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 14/22] [media] em28xx: unify module version
Date: Sat,  4 Jan 2014 08:55:43 -0200
Message-Id: <1388832951-11195-15-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the same module version on all em28xx sub-modules, and use
the same naming convention to describe the driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 3 ++-
 drivers/media/usb/em28xx/em28xx-core.c  | 2 --
 drivers/media/usb/em28xx/em28xx-dvb.c   | 4 +++-
 drivers/media/usb/em28xx/em28xx-input.c | 3 ++-
 drivers/media/usb/em28xx/em28xx-video.c | 4 +---
 drivers/media/usb/em28xx/em28xx.h       | 1 +
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 263886adcf26..a6eef06ffdcd 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -747,7 +747,8 @@ static void __exit em28xx_alsa_unregister(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Markus Rechberger <mrechberger@gmail.com>");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
-MODULE_DESCRIPTION("Em28xx Audio driver");
+MODULE_DESCRIPTION(DRIVER_DESC " - audio interface");
+MODULE_VERSION(EM28XX_VERSION);
 
 module_init(em28xx_alsa_register);
 module_exit(em28xx_alsa_unregister);
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 36b2f1ab4474..2ad84ff1fc4f 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -39,8 +39,6 @@
 		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
 		      "Sascha Sommer <saschasommer@freenet.de>"
 
-#define DRIVER_DESC         "Empia em28xx based USB core driver"
-
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index f72663a9b5c5..7fa1c804c34c 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -54,9 +54,11 @@
 #include "m88ds3103.h"
 #include "m88ts2022.h"
 
-MODULE_DESCRIPTION("driver for em28xx based DVB cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION(DRIVER_DESC " - digital TV interface");
+MODULE_VERSION(EM28XX_VERSION);
+
 
 static unsigned int debug;
 module_param(debug, int, 0644);
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index eed7dd79f734..f3b629dd57ae 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -836,7 +836,8 @@ static void __exit em28xx_rc_unregister(void)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
-MODULE_DESCRIPTION("Em28xx Input driver");
+MODULE_DESCRIPTION(DRIVER_DESC " - input interface");
+MODULE_VERSION(EM28XX_VERSION);
 
 module_init(em28xx_rc_register);
 module_exit(em28xx_rc_unregister);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 328d724a13ea..999cbfe766a3 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -50,8 +50,6 @@
 		      "Mauro Carvalho Chehab <mchehab@infradead.org>, " \
 		      "Sascha Sommer <saschasommer@freenet.de>"
 
-#define DRIVER_DESC         "Empia em28xx based USB video device driver"
-
 static unsigned int isoc_debug;
 module_param(isoc_debug, int, 0644);
 MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
@@ -78,7 +76,7 @@ do {\
   } while (0)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_DESCRIPTION(DRIVER_DESC " - v4l2 interface");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EM28XX_VERSION);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index ac79501f5d9f..db47c2236ca4 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -27,6 +27,7 @@
 #define _EM28XX_H
 
 #define EM28XX_VERSION "0.2.1"
+#define DRIVER_DESC    "Empia em28xx device driver"
 
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
-- 
1.8.3.1

