Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110804.mail.gq1.yahoo.com ([67.195.13.227]:32871 "HELO
	web110804.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751016AbZDELmN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 07:42:13 -0400
Message-ID: <629811.69312.qm@web110804.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 04:42:11 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_14] Siano: assemble all components to one kernel module
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238756860 -10800
# Node ID 616e696ce6f0c0d76a1aaea8b36e0345112c5ab6
# Parent  f65a29f0f9a66f82a91525ae0085a15f00ac91c2
[PATCH] [0904_14] Siano: assemble all components to one kernel module

From: Uri Shkolnik <uris@siano-ms.com>

Previously, the support for Siano-based devices
has been combined from several kernel modules. 
This patch assembles all into single kernel module.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r f65a29f0f9a6 -r 616e696ce6f0 linux/drivers/media/dvb/siano/Makefile
--- a/linux/drivers/media/dvb/siano/Makefile	Fri Apr 03 13:40:04 2009 +0300
+++ b/linux/drivers/media/dvb/siano/Makefile	Fri Apr 03 14:07:40 2009 +0300
@@ -1,8 +1,6 @@ sms1xxx-objs := smscoreapi.o sms-cards.o
-sms1xxx-objs := smscoreapi.o sms-cards.o
+sms1xxx-objs := smscoreapi.o sms-cards.o smsusb.o smsdvb.o smsendian.o
 
 obj-$(CONFIG_DVB_SIANO_SMS1XXX) += sms1xxx.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsusb.o
-obj-$(CONFIG_DVB_SIANO_SMS1XXX) += smsdvb.o
 
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 
diff -r f65a29f0f9a6 -r 616e696ce6f0 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Fri Apr 03 13:40:04 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Fri Apr 03 14:07:40 2009 +0300
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
@@ -1339,7 +1339,7 @@ static int __init smscore_module_init(vo
 	}
 #endif
 
-#if 0 /* def SMS_USB_BUS_DRV */
+#ifdef SMS_USB_DRV
 	/* USB Register */
 	rc = smsusb_register();
 	if (rc) {
@@ -1385,8 +1385,7 @@ static void __exit smscore_module_exit(v
 	smschar_unregister();
 #endif
 
-#if 0 /* def SMS_DVB_CLIENT */
-	/* DVB UnRegister */
+#ifdef SMS_DVB3_SUBSYS
 	smsdvb_unregister();
 #endif
 
@@ -1395,8 +1394,9 @@ static void __exit smscore_module_exit(v
 	smsnet_unregister();
 #endif
 
-#if 0 /* def SMS_USB_BUS_DRV */
-	/* Unregister USB */
+	/* Unegister interfaces objects */
+#ifdef SMS_USB_DRV
+	/* USB unregister */
 	smsusb_unregister();
 #endif
 
diff -r f65a29f0f9a6 -r 616e696ce6f0 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Apr 03 13:40:04 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Fri Apr 03 14:07:40 2009 +0300
@@ -617,6 +617,17 @@ int smscore_get_board_id(struct smscore_
 
 int smscore_led_state(struct smscore_device_t *core, int led);
 
+
+#ifdef SMS_DVB3_SUBSYS
+extern int smsdvb_register(void);
+extern void smsdvb_unregister(void);
+#endif
+
+#ifdef SMS_USB_DRV
+extern int smsusb_register(void);
+extern void smsusb_unregister(void);
+#endif
+
 /* ------------------------------------------------------------------------ */
 
 #define DBG_INFO 1
diff -r f65a29f0f9a6 -r 616e696ce6f0 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 13:40:04 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Apr 03 14:07:40 2009 +0300
@@ -638,7 +638,7 @@ adapter_error:
 	return rc;
 }
 
-int smsdvb_module_init(void)
+int smsdvb_register(void)
 {
 	int rc;
 
@@ -652,7 +652,7 @@ int smsdvb_module_init(void)
 	return rc;
 }
 
-void smsdvb_module_exit(void)
+void smsdvb_unregister(void)
 {
 	smscore_unregister_hotplug(smsdvb_hotplug);
 
@@ -665,9 +665,6 @@ void smsdvb_module_exit(void)
 	kmutex_unlock(&g_smsdvb_clientslock);
 }
 
-module_init(smsdvb_module_init);
-module_exit(smsdvb_module_exit);
-
 MODULE_DESCRIPTION("SMS DVB subsystem adaptation module");
 MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
 MODULE_LICENSE("GPL");
diff -r f65a29f0f9a6 -r 616e696ce6f0 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Fri Apr 03 13:40:04 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Fri Apr 03 14:07:40 2009 +0300
@@ -539,7 +539,7 @@ static struct usb_driver smsusb_driver =
 	.resume			= smsusb_resume,
 };
 
-int smsusb_module_init(void)
+int smsusb_register(void)
 {
 	int rc = usb_register(&smsusb_driver);
 	if (rc)
@@ -550,16 +550,13 @@ int smsusb_module_init(void)
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
 
-module_init(smsusb_module_init);
-module_exit(smsusb_module_exit);
-
-MODULE_DESCRIPTION("Driver for the Siano SMS1XXX USB dongle");
+MODULE_DESCRIPTION("Driver for the Siano SMS1xxx USB dongle");
 MODULE_AUTHOR("Siano Mobile Silicon, INC. (uris@siano-ms.com)");
 MODULE_LICENSE("GPL");



      
