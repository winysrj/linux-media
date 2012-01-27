Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm3.telefonica.net ([213.4.138.19]:55516 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176Ab2A0AE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 19:04:28 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] add another Terratec H7 usb id to az6007
Date: Fri, 27 Jan 2012 01:02:52 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tmeIPGlUKBIOAEk"
Message-Id: <201201270102.53455.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_tmeIPGlUKBIOAEk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch add another Terratec H7 usb id to az6007 driver.

Jose Alberto

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

--Boundary-00=_tmeIPGlUKBIOAEk
Content-Type: text/x-patch;
  charset="UTF-8";
  name="az6007.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="az6007.diff"

diff -ur linux/drivers/media/dvb/dvb-usb/az6007.c linux.new/drivers/media/dvb/dvb-usb/az6007.c
--- linux/drivers/media/dvb/dvb-usb/az6007.c	2012-01-22 02:53:17.000000000 +0100
+++ linux.new/drivers/media/dvb/dvb-usb/az6007.c	2012-01-23 00:17:57.859087470 +0100
@@ -481,6 +481,7 @@
 static struct usb_device_id az6007_usb_table[] = {
 	{USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007)},
 	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7)},
+	{USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2)},
 	{0},
 };
 
@@ -534,7 +535,7 @@
 		  .warm_ids = { NULL },
 		},
 		{ .name = "TerraTec DTV StarBox DVB-T/C USB2.0 (az6007)",
-		  .cold_ids = { &az6007_usb_table[1], NULL },
+		  .cold_ids = { &az6007_usb_table[1], &az6007_usb_table[2], NULL },
 		  .warm_ids = { NULL },
 		},
 		{ NULL },
diff -ur linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h linux.new/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-01-22 02:53:17.000000000 +0100
+++ linux.new/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-01-23 00:16:49.993324303 +0100
@@ -228,6 +228,7 @@
 #define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
 #define USB_PID_TERRATEC_CINERGY_T_XXS_2		0x00ab
 #define USB_PID_TERRATEC_H7				0x10b4
+#define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e

--Boundary-00=_tmeIPGlUKBIOAEk--
