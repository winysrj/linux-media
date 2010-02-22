Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:29103 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0BVJcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 04:32:17 -0500
Received: by ey-out-2122.google.com with SMTP id d26so508326eyd.19
        for <linux-media@vger.kernel.org>; Mon, 22 Feb 2010 01:32:16 -0800 (PST)
Date: Mon, 22 Feb 2010 18:32:15 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] fix some info messages
Message-ID: <20100222183215.682c9350@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/wJvAOOkz/87=FC6=xWMrcEZ"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/wJvAOOkz/87=FC6=xWMrcEZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Fix some messages for add information about TM6010

diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-alsa.c
--- a/linux/drivers/staging/tm6000/tm6000-alsa.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-alsa.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,6 +1,6 @@
 /*
  *
- *  Support for audio capture for tm5600/6000
+ *  Support for audio capture for tm5600/6000/6010
  *    (c) 2007-2008 Mauro Carvalho Chehab <mchehab@redhat.com>
  *
  *  Based on cx88-alsa.c
@@ -89,11 +89,12 @@
 				Module macros
  ****************************************************************************/
 
-MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000 based TV cards");
+MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},"
-			"{{Trident,tm6000}");
+			"{{Trident,tm6000},"
+			"{{Trident,tm6010}");
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-cards.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
@@ -799,6 +799,6 @@
 module_init(tm6000_module_init);
 module_exit(tm6000_module_exit);
 
-MODULE_DESCRIPTION("Trident TVMaster TM5600/TM6000 USB2 adapter");
+MODULE_DESCRIPTION("Trident TVMaster TM5600/TM6000/TM6010 USB2 adapter");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-core.c
--- a/linux/drivers/staging/tm6000/tm6000-core.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-core.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-core.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-dvb.c
--- a/linux/drivers/staging/tm6000/tm6000-dvb.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-dvb.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-dvb.c - dvb-t support for TM5600/TM6000 USB video capture devices
+   tm6000-dvb.c - dvb-t support for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-i2c.c
--- a/linux/drivers/staging/tm6000/tm6000-i2c.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-i2c.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-regs.h
--- a/linux/drivers/staging/tm6000/tm6000-regs.h	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-regs.h	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-regs.h - driver for TM5600/TM6000 USB video capture devices
+   tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
@@ -18,7 +18,7 @@
  */
 
 /*
- * Define TV Master TM5600/TM6000 Request codes
+ * Define TV Master TM5600/TM6000/TM6010 Request codes
  */
 #define REQ_00_SET_IR_VALUE		0
 #define REQ_01_SET_WAKEUP_IRCODE	1
@@ -49,7 +49,7 @@
 	/* Read : Slave Addr, register, 2, data */
 
 /*
- * Define TV Master TM5600/TM6000 GPIO lines
+ * Define TV Master TM5600/TM6000/TM6010 GPIO lines
  */
 
 #define TM6000_GPIO_CLK		0x101
@@ -74,7 +74,7 @@
 #define TM6010_GPIO_7      0x0301
 #define TM6010_GPIO_9      0x0305
 /*
- * Define TV Master TM5600/TM6000 URB message codes and length
+ * Define TV Master TM5600/TM6000/TM6010 URB message codes and length
  */
 
 enum {
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-stds.c
--- a/linux/drivers/staging/tm6000/tm6000-stds.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-stds.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-stds.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@redhat.com>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-usb-isoc.h
--- a/linux/drivers/staging/tm6000/tm6000-usb-isoc.h	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-usb-isoc.h	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-buf.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-video.c
--- a/linux/drivers/staging/tm6000/tm6000-video.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-video.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-video.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
@@ -925,7 +925,7 @@
 	//	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
 
 	strlcpy(cap->driver, "tm6000", sizeof(cap->driver));
-	strlcpy(cap->card,"Trident TVMaster TM5600/6000", sizeof(cap->card));
+	strlcpy(cap->card,"Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
 	//	strlcpy(cap->bus_info, dev->udev->dev.bus_id, sizeof(cap->bus_info));
 	cap->version = TM6000_VERSION;
 	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
@@ -1594,7 +1594,7 @@
 	video_set_drvdata(vfd, dev);
 
 	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
-	printk(KERN_INFO "Trident TVMaster TM5600/TM6000 USB2 board (Load status: %d)\n", ret);
+	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 }
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000.h
--- a/linux/drivers/staging/tm6000/tm6000.h	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000.h	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000.h - driver for TM5600/TM6000 USB video capture devices
+   tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/wJvAOOkz/87=FC6=xWMrcEZ
Content-Type: text/x-patch; name=tm6000_add_tm6010.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_add_tm6010.patch

diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-alsa.c
--- a/linux/drivers/staging/tm6000/tm6000-alsa.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-alsa.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,6 +1,6 @@
 /*
  *
- *  Support for audio capture for tm5600/6000
+ *  Support for audio capture for tm5600/6000/6010
  *    (c) 2007-2008 Mauro Carvalho Chehab <mchehab@redhat.com>
  *
  *  Based on cx88-alsa.c
@@ -89,11 +89,12 @@
 				Module macros
  ****************************************************************************/
 
-MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000 based TV cards");
+MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},"
-			"{{Trident,tm6000}");
+			"{{Trident,tm6000},"
+			"{{Trident,tm6010}");
 static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "enable debug messages");
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-cards.c
--- a/linux/drivers/staging/tm6000/tm6000-cards.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-cards.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-cards.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-cards.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
@@ -799,6 +799,6 @@
 module_init(tm6000_module_init);
 module_exit(tm6000_module_exit);
 
-MODULE_DESCRIPTION("Trident TVMaster TM5600/TM6000 USB2 adapter");
+MODULE_DESCRIPTION("Trident TVMaster TM5600/TM6000/TM6010 USB2 adapter");
 MODULE_AUTHOR("Mauro Carvalho Chehab");
 MODULE_LICENSE("GPL");
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-core.c
--- a/linux/drivers/staging/tm6000/tm6000-core.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-core.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-core.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-core.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-dvb.c
--- a/linux/drivers/staging/tm6000/tm6000-dvb.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-dvb.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-dvb.c - dvb-t support for TM5600/TM6000 USB video capture devices
+   tm6000-dvb.c - dvb-t support for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2007 Michel Ludwig <michel.ludwig@gmail.com>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-i2c.c
--- a/linux/drivers/staging/tm6000/tm6000-i2c.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-i2c.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-i2c.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-i2c.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-regs.h
--- a/linux/drivers/staging/tm6000/tm6000-regs.h	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-regs.h	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-regs.h - driver for TM5600/TM6000 USB video capture devices
+   tm6000-regs.h - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
@@ -18,7 +18,7 @@
  */
 
 /*
- * Define TV Master TM5600/TM6000 Request codes
+ * Define TV Master TM5600/TM6000/TM6010 Request codes
  */
 #define REQ_00_SET_IR_VALUE		0
 #define REQ_01_SET_WAKEUP_IRCODE	1
@@ -49,7 +49,7 @@
 	/* Read : Slave Addr, register, 2, data */
 
 /*
- * Define TV Master TM5600/TM6000 GPIO lines
+ * Define TV Master TM5600/TM6000/TM6010 GPIO lines
  */
 
 #define TM6000_GPIO_CLK		0x101
@@ -74,7 +74,7 @@
 #define TM6010_GPIO_7      0x0301
 #define TM6010_GPIO_9      0x0305
 /*
- * Define TV Master TM5600/TM6000 URB message codes and length
+ * Define TV Master TM5600/TM6000/TM6010 URB message codes and length
  */
 
 enum {
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-stds.c
--- a/linux/drivers/staging/tm6000/tm6000-stds.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-stds.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-stds.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@redhat.com>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-usb-isoc.h
--- a/linux/drivers/staging/tm6000/tm6000-usb-isoc.h	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-usb-isoc.h	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-buf.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-buf.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000-video.c
--- a/linux/drivers/staging/tm6000/tm6000-video.c	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000-video.c	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000-video.c - driver for TM5600/TM6000 USB video capture devices
+   tm6000-video.c - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 
@@ -925,7 +925,7 @@
 	//	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
 
 	strlcpy(cap->driver, "tm6000", sizeof(cap->driver));
-	strlcpy(cap->card,"Trident TVMaster TM5600/6000", sizeof(cap->card));
+	strlcpy(cap->card,"Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
 	//	strlcpy(cap->bus_info, dev->udev->dev.bus_id, sizeof(cap->bus_info));
 	cap->version = TM6000_VERSION;
 	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
@@ -1594,7 +1594,7 @@
 	video_set_drvdata(vfd, dev);
 
 	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, video_nr);
-	printk(KERN_INFO "Trident TVMaster TM5600/TM6000 USB2 board (Load status: %d)\n", ret);
+	printk(KERN_INFO "Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: %d)\n", ret);
 	return ret;
 }
 
diff -r ac88a0dd8fb7 linux/drivers/staging/tm6000/tm6000.h
--- a/linux/drivers/staging/tm6000/tm6000.h	Sun Feb 21 21:00:16 2010 -0300
+++ b/linux/drivers/staging/tm6000/tm6000.h	Mon Feb 22 07:36:15 2010 -0500
@@ -1,5 +1,5 @@
 /*
-   tm6000.h - driver for TM5600/TM6000 USB video capture devices
+   tm6000.h - driver for TM5600/TM6000/TM6010 USB video capture devices
 
    Copyright (C) 2006-2007 Mauro Carvalho Chehab <mchehab@infradead.org>
 

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/wJvAOOkz/87=FC6=xWMrcEZ--
