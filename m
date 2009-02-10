Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.27o.de ([89.110.156.182]:58270 "EHLO mail.27o.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbZBJVxT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 16:53:19 -0500
Received: from dslb-084-058-070-061.pools.arcor-ip.net ([84.58.70.61] helo=earth.lan)
	by mail.27o.de with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <klaus@flittner.org>)
	id 1LX0HV-0003hZ-Gj
	for linux-media@vger.kernel.org; Tue, 10 Feb 2009 22:36:37 +0100
Date: Tue, 10 Feb 2009 22:36:35 +0100
From: Klaus Flittner <klaus@flittner.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add Elgato EyeTV DTT to dibcom driver
Message-ID: <20090210223635.71abc667@earth.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces support for DVB-T for the following dibcom based card:
  Elgato EyeTV DTT (USB-ID: 0fd9:0021)

Signed-off-by: Klaus Flittner <klaus@flittner.org>

diff -r 9cb19f080660 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Feb 10 22:21:16 2009 +0100
@@ -1419,6 +1419,7 @@
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,
 			USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
+	{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1618,7 +1619,7 @@
 			},
 		},
 
-		.num_device_descs = 9,
+		.num_device_descs = 10,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -1654,6 +1655,10 @@
 			},
 			{   "Terratec Cinergy T USB XXS",
 				{ &dib0700_usb_id_table[33], NULL },
+				{ NULL },
+			},
+			{   "Elgato EyeTV DTT",
+				{ &dib0700_usb_id_table[44], NULL },
 				{ NULL },
 			},
 		},
diff -r 9cb19f080660 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Tue Feb 10 22:21:16 2009 +0100
@@ -27,6 +27,7 @@
 #define USB_VID_DIBCOM				0x10b8
 #define USB_VID_DPOSH				0x1498
 #define USB_VID_DVICO				0x0fe9
+#define USB_VID_ELGATO				0x0fd9
 #define USB_VID_EMPIA				0xeb1a
 #define USB_VID_GENPIX				0x09c0
 #define USB_VID_GRANDTEC			0x5032
@@ -237,5 +238,6 @@
 #define USB_PID_XTENSIONS_XD_380			0x0381
 #define USB_PID_TELESTAR_STARSTICK_2			0x8000
 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
+#define USB_PID_ELGATO_EYETV_DTT			0x0021
 
 #endif
diff -r 9cb19f080660 linux/drivers/media/dvb/dvb-usb/dvb-usb.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb.h	Tue Feb 10 05:26:05 2009 -0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb.h	Tue Feb 10 22:21:16 2009 +0100
@@ -224,7 +224,7 @@
 	int generic_bulk_ctrl_endpoint;
 
 	int num_device_descs;
-	struct dvb_usb_device_description devices[9];
+	struct dvb_usb_device_description devices[10];
 };
 
 /**
