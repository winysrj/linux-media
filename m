Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:55482 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab0E3MVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 08:21:11 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 3/3] tm6000: move dvb into a separate kern module
Date: Sun, 30 May 2010 14:19:04 +0200
Message-Id: <1275221944-27887-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1275221944-27887-1-git-send-email-stefan.ringel@arcor.de>
References: <1275221944-27887-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

move dvb into a separate kern module


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/Kconfig        |    4 +-
 drivers/staging/tm6000/Makefile       |    5 +--
 drivers/staging/tm6000/tm6000-cards.c |   31 +-----------
 drivers/staging/tm6000/tm6000-core.c  |    1 +
 drivers/staging/tm6000/tm6000-dvb.c   |   83 ++++++++++++++++++++++++++++++++-
 drivers/staging/tm6000/tm6000.h       |    1 +
 6 files changed, 89 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/tm6000/Kconfig b/drivers/staging/tm6000/Kconfig
index 3657e33..c725356 100644
--- a/drivers/staging/tm6000/Kconfig
+++ b/drivers/staging/tm6000/Kconfig
@@ -26,8 +26,8 @@ config VIDEO_TM6000_ALSA
 	  module will be called tm6000-alsa.
 
 config VIDEO_TM6000_DVB
-	bool "DVB Support for tm6000 based TV cards"
-	depends on VIDEO_TM6000 && DVB_CORE && EXPERIMENTAL
+	tristate "DVB Support for tm6000 based TV cards"
+	depends on VIDEO_TM6000 && DVB_CORE && USB && EXPERIMENTAL
 	select DVB_ZL10353
 	---help---
 	  This adds support for DVB cards based on the tm5600/tm6000 chip.
diff --git a/drivers/staging/tm6000/Makefile b/drivers/staging/tm6000/Makefile
index 93370fc..4129c18 100644
--- a/drivers/staging/tm6000/Makefile
+++ b/drivers/staging/tm6000/Makefile
@@ -4,12 +4,9 @@ tm6000-objs := tm6000-cards.o \
 		   tm6000-video.o \
 		   tm6000-stds.o
 
-ifeq ($(CONFIG_VIDEO_TM6000_DVB),y)
-tm6000-objs += tm6000-dvb.o
-endif
-
 obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
 obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
+obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
 EXTRA_CFLAGS = -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 553ebe4..87b0bc4 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -346,7 +346,7 @@ int tm6000_xc5000_callback(void *ptr, int component, int command, int arg)
 	}
 	return (rc);
 }
-
+EXPORT_SYMBOL_GPL(tm6000_xc5000_callback);
 
 /* Tuner callback to provide the proper gpio changes needed for xc2028 */
 
@@ -436,6 +436,7 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 	}
 	return rc;
 }
+EXPORT_SYMBOL_GPL(tm6000_tuner_callback);
 
 int tm6000_cards_setup(struct tm6000_core *dev)
 {
@@ -693,31 +694,12 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		goto err;
 
 	tm6000_add_into_devlist(dev);
-
 	tm6000_init_extension(dev);
 
-	if (dev->caps.has_dvb) {
-		dev->dvb = kzalloc(sizeof(*(dev->dvb)), GFP_KERNEL);
-		if (!dev->dvb) {
-			rc = -ENOMEM;
-			goto err2;
-		}
-
-#ifdef CONFIG_VIDEO_TM6000_DVB
-		rc = tm6000_dvb_register(dev);
-		if (rc < 0) {
-			kfree(dev->dvb);
-			dev->dvb = NULL;
-			goto err2;
-		}
-#endif
 	}
 	mutex_unlock(&dev->lock);
 	return 0;
 
-err2:
-	v4l2_device_unregister(&dev->v4l2_dev);
-
 err:
 	mutex_unlock(&dev->lock);
 	return rc;
@@ -918,13 +900,6 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 
 	mutex_lock(&dev->lock);
 
-#ifdef CONFIG_VIDEO_TM6000_DVB
-	if (dev->dvb) {
-		tm6000_dvb_unregister(dev);
-		kfree(dev->dvb);
-	}
-#endif
-
 	if (dev->gpio.power_led) {
 		switch (dev->model) {
 		case TM6010_BOARD_HAUPPAUGE_900H:
@@ -954,8 +929,8 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 
 	usb_put_dev(dev->udev);
 
-	tm6000_remove_from_devlist(dev);
 	tm6000_close_extension(dev);
+	tm6000_remove_from_devlist(dev);
 
 	mutex_unlock(&dev->lock);
 	kfree(dev);
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index b5965a8..cd87b14 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -396,6 +396,7 @@ int tm6000_init_digital_mode (struct tm6000_core *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL(tm6000_init_digial_mode);
 
 struct reg_init {
 	u8 req;
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index b9e9ef1..7830826 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -38,6 +38,19 @@
 			dev->name, __FUNCTION__, ##arg);	\
 	} while (0)
 
+MODULE_DESCRIPTION("DVB driver extension module for tm5600/6000/6010 based TV cards");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_LICENSE("GPL");
+
+MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},"
+			"{{Trident, tm6000},"
+			"{{Trident, tm6010}");
+
+static int debug
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "enable debug message");
+
 static void inline print_err_status (struct tm6000_core *dev,
 				     int packet, int status)
 {
@@ -245,7 +258,7 @@ int tm6000_dvb_attach_frontend(struct tm6000_core *dev)
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-int tm6000_dvb_register(struct tm6000_core *dev)
+int register_dvb(struct tm6000_core *dev)
 {
 	int ret = -1;
 	struct tm6000_dvb *dvb = dev->dvb;
@@ -356,7 +369,7 @@ err:
 	return ret;
 }
 
-void tm6000_dvb_unregister(struct tm6000_core *dev)
+void unregister_dvb(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
@@ -382,3 +395,69 @@ void tm6000_dvb_unregister(struct tm6000_core *dev)
 /*	mutex_unlock(&tm6000_driver.open_close_mutex); */
 
 }
+
+static int dvb_init(struct tm6000_core *dev)
+{
+	struct tm6000_dvb *dvb;
+	int rc;
+
+	if (!dev)
+		retrun 0;
+
+	if (!dev->caps.has_dvb)
+		return 0;
+
+	dvb = kzalloc(sizeof(struct tm6000_dvb), GFP_KERNEL);
+	if (!dvb) {
+		printk(KERN_INFO "Cannot allocate memory\n");
+		return -ENOMEM;
+	}
+
+	dev->dvb = dvb;
+
+	rc = register_dvb(dev);
+	if (rc < 0) {
+		kfree(dvb);
+		dev->dvb = NULL;
+		return 0;
+	}
+
+	return 0;
+}
+
+static int dvb_fini(struct tm6000_core *dev)
+{
+	if (!dev)
+		return 0;
+
+	if (!dev->caps.has_dvb)
+		return 0;
+
+	if (dev->dvb) {
+		unregister_dvb(dev);
+		kfree(dev->dvb);
+		dev->dvb = NULL;
+	}
+
+	retrun 0;
+}
+
+static struct tm6000_ops dvb_ops = {
+	.id	= TM6000_DVB,
+	.name	= "TM6000 dvb Extension",
+	.init	= dvb_init,
+	.fini	= dvb_fini,
+};
+
+static int __init tm6000_dvb_register(void)
+{
+	return tm6000_register_extension(&dvb_ops);
+}
+
+static void __exit tm6000_dvb_unregister(void)
+{
+	tm6000_unregister_extension(&dvb_ops);
+}
+
+module_init(tm6000_dvb_register);
+module_exit(tm6000_dvb_unregister);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index fd94ed6..97bc14e 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -223,6 +223,7 @@ struct tm6000_core {
 };
 
 #define TM6000_AUDIO 0x10
+#define TM6000_DVB	0x20 
 
 struct tm6000_ops {
 	struct list_head	next;
-- 
1.7.0.3

