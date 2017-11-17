Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:43250 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965045AbdKQPi6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:38:58 -0500
Received: by mail-wm0-f66.google.com with SMTP id x63so7265593wmf.2
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 07:38:57 -0800 (PST)
From: Romain Reignier <r.reignier@robopec.com>
To: linux-media@vger.kernel.org
Cc: r.reignier@robopec.com
Subject: [PATCH] media: cx231xx: add support for TheImagingSource DFG/USB2pro
Date: Fri, 17 Nov 2017 16:38:55 +0100
Message-ID: <1674718.MAKsif4q92@xps-rre>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is my first patch to the kernel so please be indulgent if I have done 
anything wrong and help me produce a better submission.

This is a patch to add the support for The Imaging Source DFG/USB2pro USB 
capture device. It is based on the Conexant CX23102 chip do the patch only 
consists in adding one entry in the devices list.

Note that the inputs for the Composite and S-Video are inverted in regard to 
most of the other boards.

I could test the Composite input that is working for several months in some of 
our products. But did not have the chance to try the S-Video input because I 
do not own any device with that standard (I have tried a simple Composite to 
S-Video cable but it does not work, even on Windows). So I have applied the 
same settings as the Windows driver.

I have created a page on the Wiki to describe the board:
https://www.linuxtv.org/wiki/index.php/The_Imaging_Source_DFG-USB2pro

Sincerely,

Romain Reignier

---

>From 13d83af3e6e5c01b43875d67cdcc3312ebbc6c7a Mon Sep 17 00:00:00 2001
From: Romain Reignier <r.reignier@robopec.com>
Date: Fri, 17 Nov 2017 15:52:40 +0100
Subject: [PATCH] media: cx231xx: add support for TheImagingSource DFG/USB2pro

Signed-off-by: Romain Reignier <r.reignier@robopec.com>
---
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
