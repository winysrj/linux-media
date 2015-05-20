Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34945 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbETHwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 03:52:03 -0400
From: Tommi Rantala <tt.rantala@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>
Subject: [PATCH] [media] cx231xx: Add support for Terratec Grabby
Date: Wed, 20 May 2015 10:51:29 +0300
Message-Id: <1432108289-15072-1-git-send-email-tt.rantala@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the Terratec Grabby with USB ID 0ccd:00a6.

Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 28 ++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index fe00da1..404e17c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -815,6 +815,32 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_TERRATEC_GRABBY] = {
+		.name = "Terratec Grabby",
+		.tuner_type = TUNER_ABSENT,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x0c,
+		.gpio_pin_status_mask = 0x4001000,
+		.norm = V4L2_STD_PAL,
+		.no_alt_vanc = 1,
+		.external_av = 1,
+		.input = {{
+			.type = CX231XX_VMUX_COMPOSITE1,
+			.vmux = CX231XX_VIN_2_1,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_SVIDEO,
+			.vmux = CX231XX_VIN_1_1 |
+				(CX231XX_VIN_1_2 << 8) |
+				CX25840_SVIDEO_ON,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		} },
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -880,6 +906,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2},
 	{USB_DEVICE(0x1f4d, 0x0102),
 	 .driver_info = CX231XX_BOARD_OTG102},
+	{USB_DEVICE(USB_VID_TERRATEC, 0x00a6),
+	 .driver_info = CX231XX_BOARD_TERRATEC_GRABBY},
 	{},
 };
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 00d3bce..54790fb 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -77,6 +77,7 @@
 #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx 19
 #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx 20
 #define CX231XX_BOARD_HAUPPAUGE_955Q 21
+#define CX231XX_BOARD_TERRATEC_GRABBY 22
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
1.9.3

