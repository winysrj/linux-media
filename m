Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39251 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758895Ab0CMQJf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 11:09:35 -0500
Received: by fxm19 with SMTP id 19so2047772fxm.21
        for <linux-media@vger.kernel.org>; Sat, 13 Mar 2010 08:09:33 -0800 (PST)
MIME-Version: 1.0
From: Piotr Oleszczyk <pataczek@gmail.com>
Date: Sat, 13 Mar 2010 16:09:13 +0000
Message-ID: <d3858cac1003130809n5cb056f9g8c7e1a0e3dab0f8b@mail.gmail.com>
Subject: [PATCH] support for Hama DVB-T Hybrid (147f:2758)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
i made a patch that adds support for digital part of Hama DVB-T Hybrid
USB Stick. This card is identical as Terratec Cinergy HT USB XE so it
needed only adding USB IDs.
It'd be great if anybody could test it too.
Piotr

Signed-off-by: Piotr Oleszczyk <pataczek@gmail.com>
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Thu Mar 11
09:10:14 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sat Mar 13
15:25:08 2010 +0000
@@ -2053,6 +2053,7 @@
 /* 65 */{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV73ESE) },
 	{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV282E) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8096GP) },
+	{ USB_DEVICE(USB_VID_HAMA,	USB_PID_HAMA_DVBT_HYBRID) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2448,7 +2449,7 @@
 			},
 		},

-		.num_device_descs = 9,
+		.num_device_descs = 10,
 		.devices = {
 			{   "Terratec Cinergy HT USB XE",
 				{ &dib0700_usb_id_table[27], NULL },
@@ -2486,6 +2487,10 @@
 				{ &dib0700_usb_id_table[54], NULL },
 				{ NULL },
 			},
+			{   "Hama DVB-T Hybrid USB Stick",
+				{ &dib0700_usb_id_table[68], NULL },
+				{ NULL },
+			},
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
diff -r 0d06fd6b500e linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Thu Mar 11
09:10:14 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Mar 13
15:25:08 2010 +0000
@@ -66,6 +66,7 @@
 #define USB_VID_EVOLUTEPC			0x1e59
 #define USB_VID_AZUREWAVE			0x13d3
 #define USB_VID_TECHNISAT			0x14f7
+#define USB_VID_HAMA				0x147f

 /* Product IDs */
 #define USB_PID_ADSTECH_USB2_COLD			0xa333
@@ -298,4 +299,5 @@
 #define USB_PID_AZUREWAVE_AZ6027			0x3275
 #define USB_PID_TERRATEC_DVBS2CI			0x3275
 #define USB_PID_TECHNISAT_USB2_HDCI			0x0002
+#define USB_PID_HAMA_DVBT_HYBRID			0x2758
 #endif
