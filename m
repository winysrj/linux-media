Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53603 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZBSJU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 04:20:58 -0500
Received: by ey-out-2122.google.com with SMTP id 25so33680eya.37
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 01:20:56 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 19 Feb 2009 10:20:56 +0100
Message-ID: <9160c0600902190120w705b3d55jf4aa1af3418e5c62@mail.gmail.com>
Subject: [PATCH] Add "Sony PlayTV" to dibcom driver
From: sebastian.blanes@gmail.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces support for DVB-T for the following dibcom based card:
  Sony PlayTV (USB-ID: 1415:0003)

Signed-off-by: Sebastián Blanes <sebastian.blanes@gmail.com>

diff -uprN -X dontdiff.txt
v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-02-18
13:49:37.000000000 +0100
+++ v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-02-19
00:35:30.000000000 +0100
@@ -1419,6 +1419,7 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,
 			USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
+	{ USB_DEVICE(USB_VID_SONY,	USB_PID_SONY_PLAYTV) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1684,7 +1685,7 @@ struct dvb_usb_device_properties dib0700
 			}
 		},

-		.num_device_descs = 5,
+		.num_device_descs = 6,
 		.devices = {
 			{   "DiBcom STK7070PD reference design",
 				{ &dib0700_usb_id_table[17], NULL },
@@ -1705,6 +1706,10 @@ struct dvb_usb_device_properties dib0700
 			{  "Terratec Cinergy DT USB XS Diversity",
 				{ &dib0700_usb_id_table[43], NULL },
 				{ NULL },
+			},
+			{   "Sony PlayTV",
+				{ &dib0700_usb_id_table[44], NULL },
+				{ NULL },
 			}
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
diff -uprN -X dontdiff.txt
v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb-359d95e1d541-vanilla/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18
13:49:37.000000000 +0100
+++ v4l-dvb-359d95e1d541/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2009-02-18
23:45:43.000000000 +0100
@@ -55,6 +55,7 @@
 #define USB_VID_GIGABYTE			0x1044
 #define USB_VID_YUAN				0x1164
 #define USB_VID_XTENSIONS			0x1ae7
+#define USB_VID_SONY				0x1415

 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD			0xa333
@@ -237,5 +238,6 @@
 #define USB_PID_XTENSIONS_XD_380			0x0381
 #define USB_PID_TELESTAR_STARSTICK_2			0x8000
 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
+#define USB_PID_SONY_PLAYTV		                0x0003

 #endif
