Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbZKQObP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:31:15 -0500
Message-ID: <4B02B3B3.5050502@redhat.com>
Date: Tue, 17 Nov 2009 12:31:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "'Patrick Boettcher'" <patrick.boettcher@desy.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: New DibCom based ISDB-T device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

A friend of mine got a Geniatech S870 ISDB-T card. According to him, this device is based 
on stk8090 chipset and wants to use it in Brazil.

The board has the following USB ID:

	Bus 002 Device 002: ID 10b8:1fa0 DiBcom

I was wandering if the existing dib8000 driver will work with such device.

If so, would the following patch be enough?

Cheers,
Mauro.

---

Add support for Dibcom STK8090

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff --git a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1950,6 +1950,7 @@ struct usb_device_id dib0700_usb_id_tabl
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XP) },
 	{ USB_DEVICE(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD) },
 	{ USB_DEVICE(USB_VID_EVOLUTEPC, USB_PID_TVWAY_PLUS) },
+	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK8090) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -2496,7 +2497,7 @@ struct dvb_usb_device_properties dib0700
 			},
 		},
 
-		.num_device_descs = 3,
+		.num_device_descs = 4,
 		.devices = {
 			{   "DiBcom STK807xP reference design",
 				{ &dib0700_usb_id_table[62], NULL },
@@ -2510,6 +2511,10 @@ struct dvb_usb_device_properties dib0700
 				{ &dib0700_usb_id_table[64], NULL },
 				{ NULL },
 			},
+			{   "DiBcom STK8090 reference design",
+				{ &dib0700_usb_id_table[65], NULL },
+				{ NULL },
+			},
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
diff --git a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -100,6 +100,7 @@
 #define USB_PID_DIBCOM_STK7070PD			0x1ebe
 #define USB_PID_DIBCOM_STK807XP				0x1f90
 #define USB_PID_DIBCOM_STK807XPVR			0x1f98
+#define USB_PID_DIBCOM_STK8090				0x1fa0
 #define USB_PID_DIBCOM_ANCHOR_2135_COLD			0x2131
 #define USB_PID_DIBCOM_STK7770P				0x1e80
 #define USB_PID_DPOSH_M9206_COLD			0x9206
