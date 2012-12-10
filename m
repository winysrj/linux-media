Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38796 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab2LJAqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 19:46:21 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 01/11] dvb_usb_v2: make remote controller optional
Date: Mon, 10 Dec 2012 02:45:25 +0200
Message-Id: <1355100335-2123-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make it possible to compile dvb_usb_v2 driver without the remote
controller (RC-core).

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig        |  3 ++-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  9 +++++++++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 12 ++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 834bfec..60f4240 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -1,6 +1,6 @@
 config DVB_USB_V2
 	tristate "Support for various USB DVB devices v2"
-	depends on DVB_CORE && USB && I2C && RC_CORE
+	depends on DVB_CORE && USB && I2C
 	help
 	  By enabling this you will be able to choose the various supported
 	  USB1.1 and USB2.0 DVB devices.
@@ -113,6 +113,7 @@ config DVB_USB_IT913X
 config DVB_USB_LME2510
 	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
 	depends on DVB_USB_V2
+	depends on RC_CORE
 	select DVB_TDA10086 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_TDA826X if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_STV0288 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 059291b..e2678a7 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -400,4 +400,13 @@ extern int dvb_usbv2_reset_resume(struct usb_interface *);
 extern int dvb_usbv2_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16);
 extern int dvb_usbv2_generic_write(struct dvb_usb_device *, u8 *, u16);
 
+/* stub implementations that will be never called when RC-core is disabled */
+#if !defined(CONFIG_RC_CORE) && !defined(CONFIG_RC_CORE_MODULE)
+#define rc_repeat(args...)
+#define rc_keydown(args...)
+#define rc_keydown_notimeout(args...)
+#define rc_keyup(args...)
+#define rc_g_keycode_from_table(args...) 0
+#endif
+
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 671b4fa..94f134c 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -102,6 +102,7 @@ static int dvb_usbv2_i2c_exit(struct dvb_usb_device *d)
 	return 0;
 }
 
+#if defined(CONFIG_RC_CORE) || defined(CONFIG_RC_CORE_MODULE)
 static void dvb_usb_read_remote_control(struct work_struct *work)
 {
 	struct dvb_usb_device *d = container_of(work,
@@ -202,6 +203,17 @@ static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
 
 	return 0;
 }
+#else
+static int dvb_usbv2_remote_init(struct dvb_usb_device *d)
+{
+	return 0;
+}
+
+static int dvb_usbv2_remote_exit(struct dvb_usb_device *d)
+{
+	return 0;
+}
+#endif
 
 static void dvb_usb_data_complete(struct usb_data_stream *stream, u8 *buf,
 		size_t len)
-- 
1.7.11.7

