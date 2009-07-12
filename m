Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f185.google.com ([209.85.216.185]:49361 "EHLO
	mail-px0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZGLO6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 10:58:42 -0400
Received: by pxi15 with SMTP id 15so144544pxi.33
        for <linux-media@vger.kernel.org>; Sun, 12 Jul 2009 07:58:41 -0700 (PDT)
Subject: [PATCH] Add support for Humax/Coex DVB-T USB Stick 2.0 High Speed
From: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-SPRcxuVTpuVCXAEaQj9/"
Date: Sun, 12 Jul 2009 21:51:10 +0700
Message-Id: <1247410270.32281.0.camel@AcerAspire4710>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-SPRcxuVTpuVCXAEaQj9/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch adds support for Humax/Coex DVB-T USB Stick 2.0 High Speed
which is a very popular tuner sold in Vietnam.
Tested with at least 3 tuners.
It's very likely that this patch will not cause any regression.
Thanks

Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
diff -ur a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	2009-07-12
20:52:32.000000000 +0700
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	2009-07-12
20:12:56.000000000 +0700
@@ -42,6 +42,8 @@
 /* 11 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,
USB_PID_ARTEC_T14_WARM) },
 /* 12 */	{ USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_COLD) },
 /* 13 */	{ USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_WARM) },
+/* 14 */	{ USB_DEVICE(USB_VID_HUMAX_COEX,
USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD) },
+/* 15 */	{ USB_DEVICE(USB_VID_HUMAX_COEX,
USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM) },
 			{ }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, dibusb_dib3000mc_table);
@@ -66,7 +68,7 @@
 	/* parameter for the MPEG2-data transfer */
 			.stream = {
 				.type = USB_BULK,
-				.count = 7,
+				.count = 8,
 				.endpoint = 0x06,
 				.u = {
 					.bulk = {
@@ -88,7 +90,7 @@
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.num_device_descs = 7,
+	.num_device_descs = 8,
 	.devices = {
 		{   "DiBcom USB2.0 DVB-T reference design (MOD3000P)",
 			{ &dibusb_dib3000mc_table[0], NULL },
@@ -119,6 +121,10 @@
 			{ &dibusb_dib3000mc_table[12], NULL },
 			{ &dibusb_dib3000mc_table[13], NULL },
 		},
+		{   "Humax/Coex DVB-T USB Stick 2.0 High Speed",
+			{ &dibusb_dib3000mc_table[14], NULL },
+			{ &dibusb_dib3000mc_table[15], NULL },
+		},
 		{ NULL },
 	}
 };
diff -ur a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-07-12
20:52:32.000000000 +0700
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-07-12
21:23:29.000000000 +0700
@@ -58,6 +58,7 @@
 #define USB_VID_GIGABYTE			0x1044
 #define USB_VID_YUAN				0x1164
 #define USB_VID_XTENSIONS			0x1ae7
+#define USB_VID_HUMAX_COEX			0x10b9
 
 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD			0xa333
@@ -259,5 +260,7 @@
 #define USB_PID_SONY_PLAYTV				0x0003
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
+#define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
+#define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 
 #endif

--=-SPRcxuVTpuVCXAEaQj9/
Content-Disposition: attachment; filename="HumaxDVBTUSBStick.patch"
Content-Type: text/x-patch; name="HumaxDVBTUSBStick.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Signed-off-by: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>
Add support for Humax/Coex DVB-T USB Stick 2.0 High Speed (popular in Vietnam)

diff -ur a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c
--- a/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	2009-07-12 20:52:32.000000000 +0700
+++ b/linux/drivers/media/dvb/dvb-usb/dibusb-mc.c	2009-07-12 20:12:56.000000000 +0700
@@ -42,6 +42,8 @@
 /* 11 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ARTEC_T14_WARM) },
 /* 12 */	{ USB_DEVICE(USB_VID_LEADTEK,		USB_PID_WINFAST_DTV_DONGLE_COLD) },
 /* 13 */	{ USB_DEVICE(USB_VID_LEADTEK,		USB_PID_WINFAST_DTV_DONGLE_WARM) },
+/* 14 */	{ USB_DEVICE(USB_VID_HUMAX_COEX,	USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD) },
+/* 15 */	{ USB_DEVICE(USB_VID_HUMAX_COEX,	USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM) },
 			{ }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, dibusb_dib3000mc_table);
@@ -66,7 +68,7 @@
 	/* parameter for the MPEG2-data transfer */
 			.stream = {
 				.type = USB_BULK,
-				.count = 7,
+				.count = 8,
 				.endpoint = 0x06,
 				.u = {
 					.bulk = {
@@ -88,7 +90,7 @@
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.num_device_descs = 7,
+	.num_device_descs = 8,
 	.devices = {
 		{   "DiBcom USB2.0 DVB-T reference design (MOD3000P)",
 			{ &dibusb_dib3000mc_table[0], NULL },
@@ -119,6 +121,10 @@
 			{ &dibusb_dib3000mc_table[12], NULL },
 			{ &dibusb_dib3000mc_table[13], NULL },
 		},
+		{   "Humax/Coex DVB-T USB Stick 2.0 High Speed",
+			{ &dibusb_dib3000mc_table[14], NULL },
+			{ &dibusb_dib3000mc_table[15], NULL },
+		},
 		{ NULL },
 	}
 };
diff -ur a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-07-12 20:52:32.000000000 +0700
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-07-12 21:23:29.000000000 +0700
@@ -58,6 +58,7 @@
 #define USB_VID_GIGABYTE			0x1044
 #define USB_VID_YUAN				0x1164
 #define USB_VID_XTENSIONS			0x1ae7
+#define USB_VID_HUMAX_COEX			0x10b9
 
 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD			0xa333
@@ -259,5 +260,7 @@
 #define USB_PID_SONY_PLAYTV				0x0003
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
+#define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
+#define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 
 #endif

--=-SPRcxuVTpuVCXAEaQj9/--

