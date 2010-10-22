Return-path: <mchehab@pedra>
Received: from realvnc.com ([146.101.152.142]:41573 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab0JVLbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Oct 2010 07:31:00 -0400
Received: from 07050307.dsl.redstone-isp.net ([212.44.6.81] helo=[192.168.5.21])
	by realvnc.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
	(Exim 4.71)
	(envelope-from <adrian.taylor@realvnc.com>)
	id 1P9Fpq-00065N-P6
	for linux-media@vger.kernel.org; Fri, 22 Oct 2010 12:30:59 +0100
From: Adrian Taylor <adrian.taylor@realvnc.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Support for Elgato Video Capture.
Date: Fri, 22 Oct 2010 12:30:50 +0100
Message-Id: <20E008D5-74E6-4BD7-8337-08A27646E265@realvnc.com>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch allows this device successfully to show video, at least from
its composite input.

I have no information about the true hardware contents of this device and so
this patch is based solely on fiddling with things until it worked. The
chip appears to be em2860, and the closest device with equivalent inputs
is the Typhoon DVD Maker. Copying the settings for that device appears
to do the trick. That's what this patch does.

Patch redone against the staging/v2.6.37 branch of the v4l/dvb
media_tree as requested.

Signed-off-by: Adrian Taylor <adrian.taylor@realvnc.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |   16 ++++++++++++++++
 drivers/media/video/em28xx/em28xx.h       |    1 +
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ffbe544..f4d39c6 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1693,6 +1693,20 @@ struct em28xx_board em28xx_boards[] = {
 		.dvb_gpio   = kworld_a340_digital,
 		.tuner_gpio = default_tuner_gpio,
 	},
+	[EM2860_BOARD_ELGATO_VIDEO_CAPTURE] = {
+		.name         = "Elgato Video Capture",
+		.decoder      = EM28XX_SAA711X,
+		.tuner_type   = TUNER_ABSENT,	/* Capture only device */
+		.input        = { {
+			.type  = EM28XX_VMUX_COMPOSITE1,
+			.vmux  = SAA7115_COMPOSITE0,
+			.amux  = EM28XX_AMUX_LINE_IN,
+		}, {
+			.type  = EM28XX_VMUX_SVIDEO,
+			.vmux  = SAA7115_SVIDEO3,
+			.amux  = EM28XX_AMUX_LINE_IN,
+		} },
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -1816,6 +1830,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2860_BOARD_GADMEI_UTV330 },
 	{ USB_DEVICE(0x1b80, 0xa340),
 			.driver_info = EM2870_BOARD_KWORLD_A340 },
+	{ USB_DEVICE(0x0fd9, 0x0033),
+			.driver_info = EM2860_BOARD_ELGATO_VIDEO_CAPTURE},
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index adb20eb..4e878c2 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -116,6 +116,7 @@
 #define EM2800_BOARD_VC211A			  74
 #define EM2882_BOARD_DIKOM_DK300		  75
 #define EM2870_BOARD_KWORLD_A340		  76
+#define EM2860_BOARD_ELGATO_VIDEO_CAPTURE		  77
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.0.4

