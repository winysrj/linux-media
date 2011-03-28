Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59881 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab1C1SEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 14:04:35 -0400
Received: by vws1 with SMTP id 1so2502109vws.19
        for <linux-media@vger.kernel.org>; Mon, 28 Mar 2011 11:04:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 28 Mar 2011 20:04:35 +0200
Message-ID: <AANLkTik2V7FcDfhFQfA4fG9OROhXyBavm2OyLFy34n2M@mail.gmail.com>
Subject: [PATCH] Support for Medion CTX1921 DVB-T Stick for 2.6.32.35 kernel
From: Radoslaw Warowny <radoslaww@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add support for Medion CTX1921 DVB-T USB stick (DIB7770 based) using existing
Dibcom driver. The device is identified as: "ID 1660:1921 Creatix
Polymedia GmbH".

Signed-off-by: Radoslaw Warowny <radoslaww@gmail.com>

---
The patch was tested with CTX1921 V2.1.1 (white USB stick with
"Medion" inscription on top of it).

diff -uprN linux-2.6.32.35-vanilla/drivers/media/dvb/dvb-usb/dib0700_devices.c
linux-2.6.32.35/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- linux-2.6.32.35-vanilla/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-03-27
16:13:19.991002659 +0200
+++ linux-2.6.32.35/drivers/media/dvb/dvb-usb/dib0700_devices.c	2011-03-27
17:15:44.227409205 +0200
@@ -1861,6 +1861,7 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XPVR) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XP) },
 	{ USB_DEVICE(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD) },
+	{ USB_DEVICE(USB_VID_MEDION,    USB_PID_MEDION_CTX1921) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2332,7 +2333,7 @@ struct dvb_usb_device_properties dib0700
 			},
 		},

-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{   "DiBcom STK7770P reference design",
 				{ &dib0700_usb_id_table[59], NULL },
@@ -2344,6 +2345,10 @@ struct dvb_usb_device_properties dib0700
 					&dib0700_usb_id_table[60], NULL},
 				{ NULL },
 			},
+                        {   "Medion CTX1921",
+                                { &dib0700_usb_id_table[64], NULL },
+                                { NULL },
+                        }
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
diff -uprN linux-2.6.32.35-vanilla/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
linux-2.6.32.35/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- linux-2.6.32.35-vanilla/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-03-27
16:13:19.991002659 +0200
+++ linux-2.6.32.35/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-03-27
17:14:27.217407350 +0200
@@ -276,5 +276,6 @@
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
 #define USB_PID_FRIIO_WHITE				0x0001
+#define USB_PID_MEDION_CTX1921				0x1921

 #endif
