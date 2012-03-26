Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65121 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab2CZNPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 09:15:37 -0400
Received: by yhmm54 with SMTP id m54so3730932yhm.19
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2012 06:15:36 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: rsalvaterra@gmail.com, crope@iki.fi, gennarone@gmail.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 5/5] em28xx: Make em28xx-input.c a separate module
Date: Mon, 26 Mar 2012 10:13:35 -0300
Message-Id: <1332767615-24218-5-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
References: <1332767615-24218-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/Kconfig        |    4 ++--
 drivers/media/video/em28xx/Makefile       |    5 ++---
 drivers/media/video/em28xx/em28xx-cards.c |    8 ++------
 drivers/media/video/em28xx/em28xx-input.c |   27 +++++++++++++++++++++++++--
 drivers/media/video/em28xx/em28xx.h       |   15 +--------------
 5 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index f6f622e..8a1a4d0 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -49,10 +49,10 @@ config VIDEO_EM28XX_DVB
 	  Empiatech em28xx chips.
 
 config VIDEO_EM28XX_RC
-        bool "EM28XX Remote Controller support"
+        tristate "EM28XX Remote Controller support"
         depends on RC_CORE
         depends on VIDEO_EM28XX
         depends on !(RC_CORE=m && VIDEO_EM28XX=y)
-        default y
+        default m
         ---help---
           Enables Remote Controller support on em28xx driver.
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/video/em28xx/Makefile
index 2abdf76..c8b338d 100644
--- a/drivers/media/video/em28xx/Makefile
+++ b/drivers/media/video/em28xx/Makefile
@@ -1,16 +1,15 @@
 em28xx-y :=	em28xx-video.o em28xx-i2c.o em28xx-cards.o
 em28xx-y +=	em28xx-core.o  em28xx-vbi.o
 
-em28xx-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-input.o
-
 em28xx-alsa-objs := em28xx-audio.o
+em28xx-rc-objs := em28xx-input.o
 
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx.o
 obj-$(CONFIG_VIDEO_EM28XX_ALSA) += em28xx-alsa.o
 obj-$(CONFIG_VIDEO_EM28XX_DVB) += em28xx-dvb.o
+obj-$(CONFIG_VIDEO_EM28XX_RC) += em28xx-rc.o
 
 ccflags-y += -Idrivers/media/video
 ccflags-y += -Idrivers/media/common/tuners
 ccflags-y += -Idrivers/media/dvb/dvb-core
 ccflags-y += -Idrivers/media/dvb/frontends
-
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 1cc244c..89720ab 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2795,9 +2795,6 @@ void em28xx_card_setup(struct em28xx *dev)
 	}
 
 	em28xx_tuner_setup(dev);
-
-	if(!disable_ir)
-		em28xx_ir_init(dev);
 }
 
 
@@ -2814,6 +2811,8 @@ static void request_module_async(struct work_struct *work)
 
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
+	if (dev->board.has_ir_i2c && !disable_ir)
+		request_module("em28xx-rc");
 }
 
 static void request_modules(struct em28xx *dev)
@@ -2838,9 +2837,6 @@ static void flush_request_modules(struct em28xx *dev)
 */
 void em28xx_release_resources(struct em28xx *dev)
 {
-	if (dev->ir)
-		em28xx_ir_fini(dev);
-
 	/*FIXME: I2C IR should be disconnected */
 
 	em28xx_release_analog_resources(dev);
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/video/em28xx/em28xx-input.c
index 2496625..fce5f76 100644
--- a/drivers/media/video/em28xx/em28xx-input.c
+++ b/drivers/media/video/em28xx/em28xx-input.c
@@ -519,7 +519,7 @@ static void em28xx_deregister_snapshot_button(struct em28xx *dev)
 	return;
 }
 
-int em28xx_ir_init(struct em28xx *dev)
+static int em28xx_ir_init(struct em28xx *dev)
 {
 	struct em28xx_IR *ir;
 	struct rc_dev *rc;
@@ -599,7 +599,7 @@ int em28xx_ir_init(struct em28xx *dev)
 	return err;
 }
 
-int em28xx_ir_fini(struct em28xx *dev)
+static int em28xx_ir_fini(struct em28xx *dev)
 {
 	struct em28xx_IR *ir = dev->ir;
 
@@ -618,3 +618,26 @@ int em28xx_ir_fini(struct em28xx *dev)
 	return 0;
 }
 
+static struct em28xx_ops rc_ops = {
+	.id   = EM28XX_RC,
+	.name = "Em28xx Input Extension",
+	.init = em28xx_ir_init,
+	.fini = em28xx_ir_fini,
+};
+
+static int __init em28xx_rc_register(void)
+{
+	return em28xx_register_extension(&rc_ops);
+}
+
+static void __exit em28xx_rc_unregister(void)
+{
+	em28xx_unregister_extension(&rc_ops);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_DESCRIPTION("Em28xx Input driver");
+
+module_init(em28xx_rc_register);
+module_exit(em28xx_rc_unregister);
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 75630a6..e7019b0 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -464,6 +464,7 @@ enum em28xx_dev_state {
 /* em28xx extensions */
 #define EM28XX_AUDIO   0x10
 #define EM28XX_DVB     0x20
+#define EM28XX_RC      0x30
 
 /* em28xx resource types (used for res_get/res_lock etc */
 #define EM28XX_RESOURCE_VIDEO 0x01
@@ -718,20 +719,6 @@ extern const unsigned int em28xx_bcount;
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
 void em28xx_release_resources(struct em28xx *dev);
 
-/* Provided by em28xx-input.c */
-
-#ifdef CONFIG_VIDEO_EM28XX_RC
-
-int em28xx_ir_init(struct em28xx *dev);
-int em28xx_ir_fini(struct em28xx *dev);
-
-#else
-
-static inline int em28xx_ir_init(struct em28xx *dev) { return 0; }
-static inline int em28xx_ir_fini(struct em28xx *dev) { return 0; }
-
-#endif
-
 /* Provided by em28xx-vbi.c */
 extern struct videobuf_queue_ops em28xx_vbi_qops;
 
-- 
1.7.3.4

