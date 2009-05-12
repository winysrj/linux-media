Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110809.mail.gq1.yahoo.com ([67.195.13.232]:46413 "HELO
	web110809.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751889AbZELOPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 10:15:54 -0400
Message-ID: <13295.91916.qm@web110809.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 07:15:54 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_01_2] Siano: make single kernel object (module)
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242137970 -10800
# Node ID db8bfae234d4730f18823ca0686762a13e7997c9
# Parent  126c0974c2db4e2777e5d9b068fa976fe3a59675
[0905_01_2] Siano: make single kernel object (module)

From: Uri Shkolnik <uris@siano-ms.com>

This patch consolidates the components to single
kernel object (module)

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 126c0974c2db -r db8bfae234d4 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Tue May 12 16:47:51 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Tue May 12 17:19:30 2009 +0300
@@ -1,10 +1,8 @@ sms1xxx-objs := smscoreapi.o sms-cards.o
-sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o
+sms1xxx-objs := smscoreapi.o sms-cards.o smsendian.o  smsusb.o  smsdvb.o
 
 obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsdvb.o
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core -DSMS_DVB3_SUBSYS -DSMS_USB_DRV
 
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
 
diff -r 126c0974c2db -r db8bfae234d4 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 12 16:47:51 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 12 17:19:30 2009 +0300
@@ -1321,8 +1321,8 @@ static int __init smscore_module_init(vo
 	}
 #endif
 
-#if 0 /* def SMS_DVB_CLIENT */
-	/* DVB Register */
+#ifdef SMS_DVB3_SUBSYS
+	/* DVB v.3 Register */
 	rc = smsdvb_register();
 	if (rc) {
 		sms_err("Error registering DVB client.\n");
@@ -1339,12 +1339,12 @@ static int __init smscore_module_init(vo
 	}
 #endif
 
-#if 0 /* def SMS_USB_BUS_DRV */
+#ifdef SMS_USB_DRV
 	/* USB Register */
 	rc = smsusb_register();
 	if (rc) {
 		sms_err("Error registering USB bus driver.\n");
-		goto sms_bus_drv_error;
+		goto sms_usb_drv_error;
 	}
 #endif
 
@@ -1358,21 +1358,13 @@ static int __init smscore_module_init(vo
 #endif
 
 	return rc;
-#if 0
-sms_bus_drv_error:
-#endif /* 0 */
-#if 0 /* def SMS_NET_CLIENT */
-	smsnet_unregister();
-smsnet_error:
-#endif
-#if 0 /* def SMS_DVB_CLIENT */
+sms_usb_drv_error:
+#ifdef SMS_DVB3_SUBSYS
 	smsdvb_unregister();
 smsdvb_error:
 #endif
-#if 0 /* def SMS_CHAR_CLIENT */
-	smschar_unregister();
-smschar_error:
-#endif
+
+
 	sms_debug("rc %d", rc);
 
 	return rc;
@@ -1380,14 +1372,15 @@ smschar_error:
 
 static void __exit smscore_module_exit(void)
 {
-#if 0 /* def SMS_CHAR_CLIENT */
-	/* Char interface UnRegister */
-	smschar_unregister();
+#ifdef SMS_DVB3_SUBSYS
+	/* DVB v.3 unregister */
+	smsdvb_unregister();
 #endif
 
-#if 0 /* def SMS_DVB_CLIENT */
-	/* DVB UnRegister */
-	smsdvb_unregister();
+	/* Unegister interfaces objects */
+#ifdef SMS_USB_DRV
+	/* USB unregister */
+	smsusb_unregister();
 #endif
 
 #if 0 /* def SMS_NET_CLIENT */
diff -r 126c0974c2db -r db8bfae234d4 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 12 16:47:51 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 12 17:19:30 2009 +0300
@@ -35,7 +35,6 @@ along with this program.  If not, see <h
 #include <asm/page.h>
 #include "compat.h"
 
-#define SMS_DVB3_SUBSYS
 #ifdef SMS_DVB3_SUBSYS
 #include "dmxdev.h"
 #include "dvbdev.h"
@@ -661,6 +660,15 @@ int smscore_get_board_id(struct smscore_
 
 int smscore_led_state(struct smscore_device_t *core, int led);
 
+#ifdef SMS_DVB3_SUBSYS
+extern int smsdvb_register(void);
+extern void smsdvb_unregister(void);
+#endif
+
+#ifdef SMS_USB_DRV
+extern int smsusb_register(void);
+extern void smsusb_unregister(void);
+#endif
 
 /* ------------------------------------------------------------------------ */
 
diff -r 126c0974c2db -r db8bfae234d4 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 16:47:51 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 12 17:19:30 2009 +0300
@@ -518,7 +518,7 @@ adapter_error:
 	return rc;
 }
 
-int smsdvb_module_init(void)
+int smsdvb_register(void)
 {
 	int rc;
 
@@ -532,7 +532,7 @@ int smsdvb_module_init(void)
 	return rc;
 }
 
-void smsdvb_module_exit(void)
+void smsdvb_unregister(void)
 {
 	smscore_unregister_hotplug(smsdvb_hotplug);
 
@@ -545,9 +545,6 @@ void smsdvb_module_exit(void)
 	kmutex_unlock(&g_smsdvb_clientslock);
 }
 
-module_init(smsdvb_module_init);
-module_exit(smsdvb_module_exit);
-
 MODULE_DESCRIPTION("SMS DVB subsystem adaptation module");
 MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
 MODULE_LICENSE("GPL");
diff -r 126c0974c2db -r db8bfae234d4 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 16:47:51 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 17:19:30 2009 +0300
@@ -74,6 +74,7 @@ static void smsusb_onresponse(struct urb
 	if (urb->actual_length > 0) {
 		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *) surb->cb->p;
 
+		smsendian_handle_message_header(phdr);
 		if (urb->actual_length >= phdr->msgLength) {
 			surb->cb->size = phdr->msgLength;
 
@@ -537,7 +538,7 @@ static struct usb_driver smsusb_driver =
 	.resume			= smsusb_resume,
 };
 
-int smsusb_module_init(void)
+int smsusb_register(void)
 {
 	int rc = usb_register(&smsusb_driver);
 	if (rc)
@@ -548,15 +549,12 @@ int smsusb_module_init(void)
 	return rc;
 }
 
-void smsusb_module_exit(void)
+void smsusb_unregister(void)
 {
-	sms_debug("");
 	/* Regular USB Cleanup */
 	usb_deregister(&smsusb_driver);
+	sms_info("end");
 }
-
-module_init(smsusb_module_init);
-module_exit(smsusb_module_exit);
 
 MODULE_DESCRIPTION("Driver for the Siano SMS1XXX USB dongle");
 MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");



      
