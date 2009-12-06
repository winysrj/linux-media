Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:56183 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbZLFQvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 11:51:10 -0500
Message-ID: <4B1BE100.6060705@freemail.hu>
Date: Sun, 06 Dec 2009 17:51:12 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca: make device_table[]s constant 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

The device_table structure is used as a constant. The driver_info field
is only copied to the struct sd so it is also not modified.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r e16961fe157d linux/drivers/media/video/gspca/conex.c
--- a/linux/drivers/media/video/gspca/conex.c	Wed Dec 02 18:39:53 2009 +0100
+++ b/linux/drivers/media/video/gspca/conex.c	Sun Dec 06 17:45:02 2009 +0100
@@ -1046,14 +1046,14 @@
 };

 /* -- module initialisation -- */
-static __devinitdata struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x0572, 0x0041)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, device_table);

 /* -- device connect -- */
-static int sd_probe(struct usb_interface *intf,
+static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
diff -r e16961fe157d linux/drivers/media/video/gspca/etoms.c
--- a/linux/drivers/media/video/gspca/etoms.c	Wed Dec 02 18:39:53 2009 +0100
+++ b/linux/drivers/media/video/gspca/etoms.c	Sun Dec 06 17:45:02 2009 +0100
@@ -870,7 +870,7 @@
 };

 /* -- module initialisation -- */
-static __devinitdata struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x102c, 0x6151), .driver_info = SENSOR_PAS106},
 #if !defined CONFIG_USB_ET61X251 && !defined CONFIG_USB_ET61X251_MODULE
 	{USB_DEVICE(0x102c, 0x6251), .driver_info = SENSOR_TAS5130CXX},
@@ -881,7 +881,7 @@
 MODULE_DEVICE_TABLE(usb, device_table);

 /* -- device connect -- */
-static int sd_probe(struct usb_interface *intf,
+static int __devinit sd_probe(struct usb_interface *intf,
 		    const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
diff -r e16961fe157d linux/drivers/media/video/gspca/pac7302.c
--- a/linux/drivers/media/video/gspca/pac7302.c	Wed Dec 02 18:39:53 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7302.c	Sun Dec 06 17:45:02 2009 +0100
@@ -1250,7 +1250,7 @@
 };

 /* -- module initialisation -- */
-static __devinitdata struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x06f8, 0x3009)},
 	{USB_DEVICE(0x093a, 0x2620)},
 	{USB_DEVICE(0x093a, 0x2621)},
@@ -1266,7 +1266,7 @@
 MODULE_DEVICE_TABLE(usb, device_table);

 /* -- device connect -- */
-static int sd_probe(struct usb_interface *intf,
+static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
diff -r e16961fe157d linux/drivers/media/video/gspca/pac7311.c
--- a/linux/drivers/media/video/gspca/pac7311.c	Wed Dec 02 18:39:53 2009 +0100
+++ b/linux/drivers/media/video/gspca/pac7311.c	Sun Dec 06 17:45:03 2009 +0100
@@ -884,7 +884,7 @@
 };

 /* -- module initialisation -- */
-static __devinitdata struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x093a, 0x2600)},
 	{USB_DEVICE(0x093a, 0x2601)},
 	{USB_DEVICE(0x093a, 0x2603)},
@@ -896,7 +896,7 @@
 MODULE_DEVICE_TABLE(usb, device_table);

 /* -- device connect -- */
-static int sd_probe(struct usb_interface *intf,
+static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
diff -r e16961fe157d linux/drivers/media/video/gspca/sonixb.c
--- a/linux/drivers/media/video/gspca/sonixb.c	Wed Dec 02 18:39:53 2009 +0100
+++ b/linux/drivers/media/video/gspca/sonixb.c	Sun Dec 06 17:45:03 2009 +0100
@@ -1256,7 +1256,7 @@
 	.driver_info = (SENSOR_ ## sensor << 8) | BRIDGE_ ## bridge


-static __devinitdata struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x0c45, 0x6001), SB(TAS5110, 102)}, /* TAS5110C1B */
 	{USB_DEVICE(0x0c45, 0x6005), SB(TAS5110, 101)}, /* TAS5110C1B */
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
@@ -1287,7 +1287,7 @@
 MODULE_DEVICE_TABLE(usb, device_table);

 /* -- device connect -- */
-static int sd_probe(struct usb_interface *intf,
+static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
diff -r e16961fe157d linux/drivers/media/video/gspca/spca506.c
--- a/linux/drivers/media/video/gspca/spca506.c	Wed Dec 02 18:39:53 2009 +0100
+++ b/linux/drivers/media/video/gspca/spca506.c	Sun Dec 06 17:45:03 2009 +0100
@@ -685,7 +685,7 @@
 };

 /* -- module initialisation -- */
-static __devinitdata struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x06e1, 0xa190)},
 /*fixme: may be IntelPCCameraPro BRIDGE_SPCA505
 	{USB_DEVICE(0x0733, 0x0430)}, */
@@ -696,7 +696,7 @@
 MODULE_DEVICE_TABLE(usb, device_table);

 /* -- device connect -- */
-static int sd_probe(struct usb_interface *intf,
+static int __devinit sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
