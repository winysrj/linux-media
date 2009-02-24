Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:42059 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZBXRvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2009 12:51:47 -0500
Received: by fxm11 with SMTP id 11so2996052fxm.13
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2009 09:51:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090222233839.566f2870@pedra.chehab.org>
References: <9160c0600902190120w705b3d55jf4aa1af3418e5c62@mail.gmail.com>
	 <49A1AFBD.7030208@rogers.com>
	 <20090222233839.566f2870@pedra.chehab.org>
Date: Tue, 24 Feb 2009 18:51:43 +0100
Message-ID: <9160c0600902240951j75ad7543p1f356f1426bb378a@mail.gmail.com>
Subject: Re: [PATCH] Add "Sony PlayTV" to dibcom driver
From: sebastian.blanes@gmail.com
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: CityK <cityk@rogers.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/2/23 Mauro Carvalho Chehab <mchehab@infradead.org>:
> [...]
> Sebastian,
>
> could you please send it again, being sure that your email won't break long
> lines?
>

diff -uprN -X dontdiff.txt
a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed Feb 18 13:49:37 2009
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Feb 24 18:23:12 2009
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
@@ -1705,7 +1706,11 @@ struct dvb_usb_device_properties dib0700
 			{  "Terratec Cinergy DT USB XS Diversity",
 				{ &dib0700_usb_id_table[43], NULL },
 				{ NULL },
-			}
+			},
+			{  "Sony PlayTV",
+				{ &dib0700_usb_id_table[44], NULL },
+				{ NULL },
+			}		
 		},
 		.rc_interval      = DEFAULT_RC_INTERVAL,
 		.rc_key_map       = dib0700_rc_keys,
diff -uprN -X dontdiff.txt
a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Wed Feb 18 13:49:37 2009
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Feb 24 18:24:59 2009
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
+#define USB_PID_SONY_PLAYTV				0x0003

 #endif
