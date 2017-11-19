Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40998 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdKSRZp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Nov 2017 12:25:45 -0500
Received: by mail-wm0-f68.google.com with SMTP id b189so14681681wmd.0
        for <linux-media@vger.kernel.org>; Sun, 19 Nov 2017 09:25:44 -0800 (PST)
From: Romain Reignier <r.reignier@robopec.com>
To: linux-media@vger.kernel.org
Cc: Romain Reignier <r.reignier@robopec.com>
Subject: [PATCH v2] media: cx231xx: Add support for The Imaging Source DFG/USB2pro
Date: Sun, 19 Nov 2017 18:25:10 +0100
Message-Id: <1511112310-7369-1-git-send-email-r.reignier@robopec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Note that the inputs for the Composite and S-Video are inverted in
regard to most of the other boards using a cx231xx chip.

Signed-off-by: Romain Reignier <r.reignier@robopec.com>
---

I could successfully test the Composite input but not the S-Video because I do not own a
compatible device. I have set the same configuration as the one found in the Windows driver.

A dedicated wiki page can be found at:
https://www.linuxtv.org/wiki/index.php/The_Imaging_Source_DFG-USB2pro

Changes since v1 (thanks Jacopo Mondi for the feedback)
- Amend the commit message
- Fix the email formatting to allow applying the patch with git am

Sincerely,

Romain Reignier

 drivers/media/usb/cx231xx/cx231xx-cards.c | 28 ++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 54d9d0c..99c8b1a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -896,6 +896,32 @@ struct cx231xx_board cx231xx_boards[] = {
 			},
 		},
 	},
+	[CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO] = {
+		.name = "The Imaging Source DFG/USB2pro",
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
+			.vmux = CX231XX_VIN_1_1,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		}, {
+			.type = CX231XX_VMUX_SVIDEO,
+			.vmux = CX231XX_VIN_2_1 |
+				(CX231XX_VIN_2_2 << 8) |
+				CX25840_SVIDEO_ON,
+			.amux = CX231XX_AMUX_LINE_IN,
+			.gpio = NULL,
+		} },
+	},
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
 
@@ -967,6 +993,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	.driver_info = CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD},
 	{USB_DEVICE(0x15f4, 0x0135),
 	.driver_info = CX231XX_BOARD_ASTROMETA_T2HYBRID},
+	{USB_DEVICE(0x199e, 0x8002),
+	 .driver_info = CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO},
 	{},
 };
 
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 72d5937..65b039c 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -80,6 +80,7 @@
 #define CX231XX_BOARD_TERRATEC_GRABBY 22
 #define CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD 23
 #define CX231XX_BOARD_ASTROMETA_T2HYBRID 24
+#define CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO 25
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
2.7.4
