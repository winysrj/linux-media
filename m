Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:10669 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbZC2CgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 22:36:21 -0400
Received: by fk-out-0910.google.com with SMTP id 18so668113fkq.5
        for <linux-media@vger.kernel.org>; Sat, 28 Mar 2009 19:36:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 29 Mar 2009 04:36:18 +0200
Message-ID: <b0bb99640903281936u43ba9a84l6cfa5c8d3d00de0e@mail.gmail.com>
Subject: [PATCH] Add AVerMedia A310 USB IDs to CE6230 driver.
From: =?ISO-8859-1?Q?Juan_Jes=FAs_Garc=EDa_de_Soria_Lucena?=
	<skandalfo@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El día 28 de marzo de 2009 22:05, Mauro Carvalho Chehab
<mchehab@infradead.org> escribió:
> So, please send the patch you did for analysis. Please submit it as explained at [1].
>
> [1] http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

Add AVerMedia A310 USB IDs to CE6230 driver.

From: Juan Jesús García de Soria Lucena <skandalfo@gmail.com>

The CE6230 DVB USB driver works correctly for the AVerMedia A310 USB2.0
DVB-T tuner. Add the required USB ID's and hardware names so that the
driver will handle it.

Priority: normal

Signed-off-by: Juan Jesús García de Soria Lucena <skandalfo@gmail.com>

diff -r b1596c6517c9 -r 71dd4cff4eb6 linux/drivers/media/dvb/dvb-usb/ce6230.c
--- a/linux/drivers/media/dvb/dvb-usb/ce6230.c	Thu Mar 26 20:47:48 2009 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/ce6230.c	Sun Mar 29 04:27:54 2009 +0200
@@ -253,6 +253,7 @@

 static struct usb_device_id ce6230_table[] = {
 	{ USB_DEVICE(USB_VID_INTEL, USB_PID_INTEL_CE9500) },
+	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A310) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, ce6230_table);
@@ -287,12 +288,17 @@

 	.i2c_algo = &ce6230_i2c_algo,

-	.num_device_descs = 1,
+	.num_device_descs = 2,
 	.devices = {
 		{
 			.name = "Intel CE9500 reference design",
 			.cold_ids = {NULL},
 			.warm_ids = {&ce6230_table[0], NULL},
+		},
+		{
+			.name = "AVerMedia A310 USB 2.0 DVB-T tuner",
+			.cold_ids = {NULL},
+			.warm_ids = {&ce6230_table[1], NULL},
 		},
 	}
 };
diff -r b1596c6517c9 -r 71dd4cff4eb6
linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Thu Mar 26
20:47:48 2009 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Mar 29
04:27:54 2009 +0200
@@ -166,6 +166,7 @@
 #define USB_PID_AVERMEDIA_VOLAR_X			0xa815
 #define USB_PID_AVERMEDIA_VOLAR_X_2			0x8150
 #define USB_PID_AVERMEDIA_A309				0xa309
+#define USB_PID_AVERMEDIA_A310				0xa310
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
