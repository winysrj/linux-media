Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab1FSRnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2011 13:43:46 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5JHhkU6031727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:46 -0400
Received: from pedra (vpn-238-25.phx2.redhat.com [10.3.238.25])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p5JHhWq6018286
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2011 13:43:45 -0400
Date: Sun, 19 Jun 2011 14:42:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/11] [media] em28xx: Allow to compile it without RC/input
 support
Message-ID: <20110619144237.17b5c534@pedra>
In-Reply-To: <cover.1308503857.git.mchehab@redhat.com>
References: <cover.1308503857.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index 3cb78f2..49878fd 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -3,7 +3,6 @@ config VIDEO_EM28XX
 	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on RC_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_TVP5150 if VIDEO_HELPER_CHIPS_AUTO
@@ -44,3 +43,12 @@ config VIDEO_EM28XX_DVB
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
+
+config VIDEO_EM28XX_RC
+        bool "EM28XX Remote Controller support"
+        depends on RC_CORE
+        depends on VIDEO_EM28XX
+        depends on !(RC_CORE=m && VIDEO_EM28XX=y)
+        default y
+        ---help---
+          Enables Remote Controller support on em28xx driver.
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index d0f093d..38aaa00 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -1,5 +1,7 @@
-em28xx-objs     := em28xx-video.o em28xx-i2c.o em28xx-cards.o em28xx-core.o \
-		   em28xx-input.o em28xx-vbi.o
+em28xx-y :=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
+em28xx-y +=	em28xx-core.o  em28xx-vbi.o
+
+em28xx-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-input.o
 
 em28xx-alsa-objs := em28xx-audio.o
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 28b9954..f9b77b4 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -697,6 +697,9 @@ int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
 /* Provided by em28xx-input.c */
+
+#ifdef CONFIG_VIDEO_EM28XX_RC
+
 int em28xx_get_key_terratec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw);
 int em28xx_get_key_em_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw);
 int em28xx_get_key_pinnacle_usb_grey(struct IR_i2c *ir, u32 *ir_key,
@@ -709,6 +712,20 @@ void em28xx_deregister_snapshot_button(struct em28xx *dev);
 int em28xx_ir_init(struct em28xx *dev);
 int em28xx_ir_fini(struct em28xx *dev);
 
+#else
+
+#define em28xx_get_key_terratec			NULL
+#define em28xx_get_key_em_haup			NULL
+#define em28xx_get_key_pinnacle_usb_grey	NULL
+#define em28xx_get_key_winfast_usbii_deluxe	NULL
+
+static inline void em28xx_register_snapshot_button(struct em28xx *dev) {}
+static inline void em28xx_deregister_snapshot_button(struct em28xx *dev) {}
+static inline int em28xx_ir_init(struct em28xx *dev) { return 0; }
+static inline int em28xx_ir_fini(struct em28xx *dev) { return 0; }
+
+#endif
+
 /* Provided by em28xx-vbi.c */
 extern struct videobuf_queue_ops em28xx_vbi_qops;
 
-- 
1.7.1


