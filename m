Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45519 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2GVTSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jul 2012 15:18:22 -0400
Received: by wibhr14 with SMTP id hr14so2195699wib.1
        for <linux-media@vger.kernel.org>; Sun, 22 Jul 2012 12:18:20 -0700 (PDT)
Message-ID: <1342984691.3141.7.camel@router7789>
Subject: [PATCH] it913x (test) - add support for AVerMedia A373
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: John Layt <jlayt@kde.org>
Date: Sun, 22 Jul 2012 20:18:11 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Initial test support for IT9137/IT9133 dual.

This test patch uses IT9135 firmware sets just in case they are version 2 chips.
dvb-usb-it9135-01.fw
dvb-usb-it9135-02.fw



Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it913x.c      |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 26c4481..99ea83f 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -91,6 +91,7 @@
 #define USB_PID_AVERMEDIA_DVBT_USB_WARM			0x0002
 #define USB_PID_AVERMEDIA_DVBT_USB2_COLD		0xa800
 #define USB_PID_AVERMEDIA_DVBT_USB2_WARM		0xa801
+#define USB_PID_AVERMEDIA_DVBT_A373			0xa373
 #define USB_PID_COMPRO_DVBU2000_COLD			0xd000
 #define USB_PID_COMPRO_DVBU2000_WARM			0xd001
 #define USB_PID_COMPRO_DVBU2000_UNK_COLD		0x010c
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 6244fe9..8d015a3 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -821,6 +821,7 @@ static struct usb_device_id it913x_table[] = {
 	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22_IT9137) },
 	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005) },
 	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006) },
+	{ USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_DVBT_A373) },
 	{}		/* Terminating entry */
 };
 
@@ -896,7 +897,7 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_codes	= RC_MAP_IT913X_V1,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
-	.num_device_descs = 5,
+	.num_device_descs = 6,
 	.devices = {
 		{   "Kworld UB499-2T T09(IT9137)",
 			{ &it913x_table[0], NULL },
@@ -913,6 +914,9 @@ static struct dvb_usb_device_properties it913x_properties = {
 		{   "ITE 9135(9006) Generic",
 			{ &it913x_table[4], NULL },
 			},
+		{   "AVerMedia A373 MiniCard Dual DVB-T",
+			{ &it913x_table[5], NULL },
+			},
 	}
 };
 
-- 
1.7.9.5


