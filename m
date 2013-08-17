Return-path: <linux-media-owner@vger.kernel.org>
Received: from murphy.sventech.com ([208.68.36.220]:56165 "EHLO
	murphy.sventech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3HQBhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 21:37:35 -0400
Received: from mail.sventech.com (mail.sventech.com [199.168.103.203])
	by murphy.sventech.com (Postfix) with ESMTP id 0D1E424001B
	for <linux-media@vger.kernel.org>; Sat, 17 Aug 2013 01:29:03 +0000 (UTC)
Date: Fri, 16 Aug 2013 18:29:02 -0700
From: Johannes Erdfelt <johannes@erdfelt.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] cx231xx: Add support for KWorld UB445-U
Message-ID: <20130817012902.GV11927@sventech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The KWorld UB445-U is similar to the UB430-AF but with a Samsung S5H1411
frontend. Luckily all of the hardware is already well supported, just the
device and USB ids need to be added to get it to work.

Signed-off-by: Johannes Erdfelt <johannes@erdfelt.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 40 +++++++++++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |  1 +
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 3 files changed, 42 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 27948e1..a384f80 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -443,6 +443,44 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_KWORLD_UB445_USB_HYBRID] = {
+		.name = "Kworld UB445 USB Hybrid",
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.demod_xfer_mode = 0,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x11,	/* According with PV cxPolaris.inf file */
+		.tuner_sif_gpio = -1,
+		.tuner_scl_gpio = -1,
+		.tuner_sda_gpio = -1,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 2,
+		.demod_i2c_master = 1,
+		.ir_i2c_master = 2,
+		.has_dvb = 1,
+		.demod_addr = 0x10,
+		.norm = V4L2_STD_NTSC_M,
+		.input = {{
+			.type = CX231XX_VMUX_TELEVISION,
+			.vmux = CX231XX_VIN_3_1,
+			.amux = CX231XX_AMUX_VIDEO,
+			.gpio = NULL,
+		}, {
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
 	[CX231XX_BOARD_PV_PLAYTV_USB_HYBRID] = {
 		.name = "Pixelview PlayTV USB Hybrid",
 		.tuner_type = TUNER_NXP_TDA18271,
@@ -703,6 +741,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_PV_XCAPTURE_USB},
 	{USB_DEVICE(0x1b80, 0xe424),
 	 .driver_info = CX231XX_BOARD_KWORLD_UB430_USB_HYBRID},
+	{USB_DEVICE(0x1b80, 0xe421),
+	 .driver_info = CX231XX_BOARD_KWORLD_UB445_USB_HYBRID},
 	{USB_DEVICE(0x1f4d, 0x0237),
 	 .driver_info = CX231XX_BOARD_ICONBIT_U100},
 	{USB_DEVICE(0x0fd9, 0x0037),
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 14e2610..4504bc6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -657,6 +657,7 @@ static int dvb_init(struct cx231xx *dev)
 		}
 		break;
 	case CX231XX_BOARD_CNXT_RDU_253S:
+	case CX231XX_BOARD_KWORLD_UB445_USB_HYBRID:
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &tda18271_s5h1411_config,
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index e812119..babca7f 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -72,6 +72,7 @@
 #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15
 #define CX231XX_BOARD_ELGATO_VIDEO_CAPTURE_V2 16
 #define CX231XX_BOARD_OTG102 17
+#define CX231XX_BOARD_KWORLD_UB445_USB_HYBRID 18
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
-- 
1.8.3.4

