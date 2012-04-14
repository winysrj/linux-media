Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37563 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2DNNPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Apr 2012 09:15:24 -0400
Received: by wibhr17 with SMTP id hr17so6540512wib.1
        for <linux-media@vger.kernel.org>; Sat, 14 Apr 2012 06:15:23 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	daniel.videodvb@berthereau.net
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] dib0700: add new USB PID for the Elgato EyeTV DTT stick
Date: Sat, 14 Apr 2012 15:14:07 +0200
Message-Id: <1334409247-32467-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <4F891F54.6030802@Berthereau.net>
References: <4F891F54.6030802@Berthereau.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported working here:
http://ubuntuforums.org/archive/index.php/t-1510188.html
http://ubuntuforums.org/archive/index.php/t-1756828.html
https://sites.google.com/site/slackwarestuff/home/elgato-eyetv

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index f9e966a..510001d 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -3569,6 +3569,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7090E) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7790E) },
 /* 80 */{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE8096P) },
+	{ USB_DEVICE(USB_VID_ELGATO,	USB_PID_ELGATO_EYETV_DTT_2) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -3832,7 +3833,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.num_device_descs = 11,
+		.num_device_descs = 12,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -3878,6 +3879,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ &dib0700_usb_id_table[50], NULL },
 				{ NULL },
 			},
+			{   "Elgato EyeTV DTT rev. 2",
+				{ &dib0700_usb_id_table[81], NULL },
+				{ NULL },
+			},
 		},
 
 		.rc.core = {
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 94d3f8a..2418e41 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -335,6 +335,7 @@
 #define USB_PID_MYGICA_D689				0xd811
 #define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 #define USB_PID_ELGATO_EYETV_DTT			0x0021
+#define USB_PID_ELGATO_EYETV_DTT_2			0x003f
 #define USB_PID_ELGATO_EYETV_DTT_Dlx			0x0020
 #define USB_PID_ELGATO_EYETV_SAT			0x002a
 #define USB_PID_DVB_T_USB_STICK_HIGH_SPEED_COLD		0x5000
-- 
1.7.5.4

