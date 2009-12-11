Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:57529 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722AbZLKXFK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 18:05:10 -0500
Message-ID: <4B22D026.2090104@freemail.hu>
Date: Sat, 12 Dec 2009 00:05:10 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] sanio-ms: clean up init, exit and id_table
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Make module_init static and mark it with __init.
Make module_exit static and mark it with __exit.
Mark probe functions with __devinit.
Make id table static and mark with __devinitconst.

This will eliminate the following sparse warnings (see "make C=1"):
 * smsdvb.c:668:5: warning: symbol 'smsdvb_module_init' was not declared. Should it be static?
 * smsdvb.c:682:6: warning: symbol 'smsdvb_module_exit' was not declared. Should it be static?
 * smsusb.c:491:22: warning: symbol 'smsusb_id_table' was not declared. Should it be static?
 * smsusb.c:567:5: warning: symbol 'smsusb_module_init' was not declared. Should it be static?
 * smsusb.c:578:6: warning: symbol 'smsusb_module_exit' was not declared. Should it be static?
 * smssdio.c:341:5: warning: symbol 'smssdio_module_init' was not declared. Should it be static?
 * smssdio.c:353:6: warning: symbol 'smssdio_module_exit' was not declared. Should it be static?

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r f5662ce08663 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Fri Dec 11 09:53:41 2009 +0100
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Fri Dec 11 23:58:27 2009 +0100
@@ -665,7 +665,7 @@
 	return rc;
 }

-int smsdvb_module_init(void)
+static int __init smsdvb_module_init(void)
 {
 	int rc;

@@ -679,7 +679,7 @@
 	return rc;
 }

-void smsdvb_module_exit(void)
+static void __exit smsdvb_module_exit(void)
 {
 	smscore_unregister_hotplug(smsdvb_hotplug);

diff -r f5662ce08663 linux/drivers/media/dvb/siano/smssdio.c
--- a/linux/drivers/media/dvb/siano/smssdio.c	Fri Dec 11 09:53:41 2009 +0100
+++ b/linux/drivers/media/dvb/siano/smssdio.c	Fri Dec 11 23:58:27 2009 +0100
@@ -48,7 +48,7 @@
 #define SMSSDIO_INT		0x04
 #define SMSSDIO_BLOCK_SIZE	128

-static const struct sdio_device_id smssdio_ids[] = {
+static const struct sdio_device_id smssdio_ids[] __devinitconst = {
 	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_STELLAR),
 	 .driver_data = SMS1XXX_BOARD_SIANO_STELLAR},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_NOVA_A0),
@@ -222,7 +222,7 @@
 	smscore_onresponse(smsdev->coredev, cb);
 }

-static int smssdio_probe(struct sdio_func *func,
+static int __devinit smssdio_probe(struct sdio_func *func,
 			 const struct sdio_device_id *id)
 {
 	int ret;
@@ -338,7 +338,7 @@
 /* Module functions                                                */
 /*******************************************************************/

-int smssdio_module_init(void)
+static int __init smssdio_module_init(void)
 {
 	int ret = 0;

@@ -350,7 +350,7 @@
 	return ret;
 }

-void smssdio_module_exit(void)
+static void __exit smssdio_module_exit(void)
 {
 	sdio_unregister_driver(&smssdio_driver);
 }
diff -r f5662ce08663 linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Fri Dec 11 09:53:41 2009 +0100
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Fri Dec 11 23:58:27 2009 +0100
@@ -394,7 +394,7 @@
 	return rc;
 }

-static int smsusb_probe(struct usb_interface *intf,
+static int __devinit smsusb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
@@ -488,7 +488,7 @@
 	return 0;
 }

-struct usb_device_id smsusb_id_table[] = {
+static const struct usb_device_id smsusb_id_table[] __devinitconst = {
 	{ USB_DEVICE(0x187f, 0x0010),
 		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
 	{ USB_DEVICE(0x187f, 0x0100),
@@ -564,7 +564,7 @@
 	.resume			= smsusb_resume,
 };

-int smsusb_module_init(void)
+static int __init smsusb_module_init(void)
 {
 	int rc = usb_register(&smsusb_driver);
 	if (rc)
@@ -575,7 +575,7 @@
 	return rc;
 }

-void smsusb_module_exit(void)
+static void __exit smsusb_module_exit(void)
 {
 	/* Regular USB Cleanup */
 	usb_deregister(&smsusb_driver);
