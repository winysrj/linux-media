Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50775 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab1LXJre (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 04:47:34 -0500
Received: by wgbdr13 with SMTP id dr13so18390882wgb.1
        for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 01:47:33 -0800 (PST)
From: Gareth Williams <gareth@garethwilliams.me.uk>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] Added USB Id & configuration array for Honestech Vidbox NW03
Date: Sat, 24 Dec 2011 09:47:29 +0000
Message-ID: <1678583.ZtWKZmGDtk@kubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds support for the Honestech Vidbox NW03 USB capture device.

The device has an eMpia EMP202 audio chip which in my Vidbox has a Vendor Id 
identical to the STAC9750 therefore my previous patch to change the driver's 
Vendor ID recognition is also required for audio to work with this device.

Signed-off-by: Gareth Williams <gareth@garethwilliams.me.uk>
---
 linux/drivers/media/video/em28xx/em28xx-cards.c |   18 ++++++++++++++++++
 linux/drivers/media/video/em28xx/em28xx.h       |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/linux/drivers/media/video/em28xx/em28xx-cards.c 
b/linux/drivers/media/video/em28xx/em28xx-cards.c
index 1704da0..4f55962 100644
--- a/linux/drivers/media/video/em28xx/em28xx-cards.c
+++ b/linux/drivers/media/video/em28xx/em28xx-cards.c
@@ -1888,6 +1888,22 @@ struct em28xx_board em28xx_boards[] = {
 		.has_dvb       = 1,
 		.ir_codes      = RC_MAP_PINNACLE_PCTV_HD,
 	},
+	/* eb1a:5006 Honestech VIDBOX NW03
+	 * Empia EM2860, Philips SAA7113, Empia EMP202, No Tuner */
+	[EM2860_BOARD_HT_VIDBOX_NW03] = {
+		.name                = "Honestech Vidbox NW03",
+		.tuner_type          = TUNER_ABSENT,
+		.decoder             = EM28XX_SAA711X,
+		.input               = { {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.vmux     = SAA7115_COMPOSITE0,
+			.amux     = EM28XX_AMUX_LINE_IN,
+		}, {
+			.type     = EM28XX_VMUX_SVIDEO,
+			.vmux     = SAA7115_SVIDEO3,  /* S-VIDEO needs confirming */
+			.amux     = EM28XX_AMUX_LINE_IN,
+		} },
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2027,6 +2043,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM28174_BOARD_PCTV_460E },
 	{ USB_DEVICE(0x2040, 0x1605),
 			.driver_info = EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C },
+	{ USB_DEVICE(0xeb1a, 0x5006),
+			.driver_info = EM2860_BOARD_HT_VIDBOX_NW03 },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/linux/drivers/media/video/em28xx/em28xx.h 
b/linux/drivers/media/video/em28xx/em28xx.h
index b1199ef..2dbb12c 100644
--- a/linux/drivers/media/video/em28xx/em28xx.h
+++ b/linux/drivers/media/video/em28xx/em28xx.h
@@ -124,6 +124,7 @@
 #define EM28174_BOARD_PCTV_460E                   80
 #define EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C	  81
 #define EM2884_BOARD_CINERGY_HTC_STICK		  82
+#define EM2860_BOARD_HT_VIDBOX_NW03 		  83
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
