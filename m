Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39014 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab0E3XPI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 19:15:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OIrih-0003hs-Gr
	for linux-media@vger.kernel.org; Mon, 31 May 2010 01:15:03 +0200
Received: from mil13-1-88-163-137-134.fbx.proxad.net ([88.163.137.134])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 31 May 2010 01:15:03 +0200
Received: from s_elmaleh by mil13-1-88-163-137-134.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 31 May 2010 01:15:03 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?b?U3TDqXBoYW5l?= Elmaleh <s_elmaleh@hotmail.com>
Subject: [PATCH] support for medion dvb stick 1660:1921
Date: Sun, 30 May 2010 22:46:57 +0000 (UTC)
Message-ID: <loom.20100531T003945-828@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm not sure of doing this the right way since I'm not a programmer.



diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed May 19 19:34:33 
2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon May 31 00:34:44 
2010 +0200
@@ -2083,6 +2083,7 @@
 	{ USB_DEVICE(USB_VID_PCTV,	USB_PID_PINNACLE_PCTV282E) },
 	{ USB_DEVICE(USB_VID_DIBCOM,	USB_PID_DIBCOM_STK7770P) },
 /* 60 */{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS_2) },
+	{ USB_DEVICE(USB_VID_MEDION,	USB_PID_MEDION_STICK_CTX_1921) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XPVR) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XP) },
 	{ USB_DEVICE(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD) },
@@ -2606,10 +2607,14 @@
 			},
 		},
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{   "DiBcom STK7770P reference design",
 				{ &dib0700_usb_id_table[59], NULL },
+				{ NULL },
+			},
+			{   "Medion Stick ctx 1921",
+				{ &dib0700_usb_id_table[61], NULL },
 				{ NULL },
 			},
 			{   "Terratec Cinergy T USB XXS (HD)/ T3",
diff -r b576509ea6d2 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Wed May 19 19:34:33 
2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Mon May 31 00:34:44 
2010 +0200
@@ -303,4 +303,5 @@
 #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
 #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
 #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
+#define USB_PID_MEDION_STICK_CTX_1921			0x1921
 #endif

