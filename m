Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1BHTvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 14:51:46 -0500
Received: by iwn9 with SMTP id 9so6101544iwn.19
        for <linux-media@vger.kernel.org>; Tue, 08 Feb 2011 11:51:46 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Feb 2011 20:51:45 +0100
Message-ID: <AANLkTim1beU2KZKyHJpjE=93nAyt8jXv8pEw4Y-ivGwJ@mail.gmail.com>
Subject: Re: [PATCH] Technisat AirStar TeleStick 2
From: Lukas Max Fisch <lukas.fisch@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Veit.Berwig@fimi.landsh.de
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Based on staging 2.6.39.



This patch is based on Veit Berwig's work.

Signed-off-by: Lukas Fisch <lukas.fisch@gmail.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c
b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index c6022af..d3dd09a 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -2784,6 +2784,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_NIM9090MD) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_NIM7090) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7090PVR) },
+	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -3393,7 +3394,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},

-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{   "DiBcom STK7770P reference design",
 				{ &dib0700_usb_id_table[59], NULL },
@@ -3405,6 +3406,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 					&dib0700_usb_id_table[60], NULL},
 				{ NULL },
 			},
+			{   "TechniSat AirStar TeleStick 2",
+				{ &dib0700_usb_id_table[69], NULL },
+				{ NULL },
+			},
 		},

 		.rc.core = {
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index b71540d..3a8b744 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -317,5 +317,6 @@
 #define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
 #define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
 #define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002
+#define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2		0x0004
 #define USB_PID_TECHNISAT_USB2_DVB_S2			0x0500
 #endif
-- 
1.7.2.3
