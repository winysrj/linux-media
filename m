Return-path: <mchehab@gaivota>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50363 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754702Ab0LRP6z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 10:58:55 -0500
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.messagingengine.com (Postfix) with ESMTP id B76CA27C
	for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 10:58:54 -0500 (EST)
Message-Id: <1292687934.20639.1410996951@webmail.messagingengine.com>
From: sam@metal-fish.co.uk
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Subject: [PATCH] drivers:media:dvb: add USB PIDs for Elgato EyeTV Sat
Date: Sat, 18 Dec 2010 15:58:54 +0000
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Adds USB PIDs for the Elgato EyeTV Sat device. 
This device is a clone of the Terratec S7.

Signed-off-by: Sam Doshi <sam@metal-fish.co.uk>

diff -r abd3aac6644e linux/drivers/media/dvb/dvb-usb/az6027.c
--- a/linux/drivers/media/dvb/dvb-usb/az6027.c	Fri Jul 02 00:38:54 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/az6027.c	Sat Dec 18 15:38:23 2010 +0000
@@ -1089,6 +1089,7 @@
	{ USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V2) },
	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
+	{ USB_DEVICE(USB_VID_ELGATO, USB_PID_ELGATO_EYETV_SAT) },
	{ },
};

@@ -1131,7 +1132,7 @@
	.rc_query         = az6027_rc_query,
	.i2c_algo         = &az6027_i2c_algo,

-	.num_device_descs = 5,
+	.num_device_descs = 6,
	.devices = {
		{
			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
@@ -1153,6 +1154,10 @@
			.name = "Technisat SkyStar USB 2 HD CI",
			.cold_ids = { &az6027_usb_table[4], NULL },
			.warm_ids = { NULL },
+		}, {
+			.name = "Elgato EyeTV Sat",
+			.cold_ids = { &az6027_usb_table[5], NULL },
+			.warm_ids = { NULL },
		},
		{ NULL },
	}
diff -r abd3aac6644e linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Fri Jul 02 00:38:54 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sat Dec 18 15:38:23 2010 +0000
@@ -294,6 +294,7 @@
#define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
#define USB_PID_ELGATO_EYETV_DTT			0x0021
#define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
+#define USB_PID_ELGATO_EYETV_SAT			0x002a
#define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
#define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_WARM		0x5001
#define USB_PID_FRIIO_WHITE				0x0001
