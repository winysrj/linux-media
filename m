Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63735 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab1FHSyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 14:54:20 -0400
Received: by qwk3 with SMTP id 3so376532qwk.19
        for <linux-media@vger.kernel.org>; Wed, 08 Jun 2011 11:54:19 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jun 2011 20:54:19 +0200
Message-ID: <BANLkTinW=CPZ-OBO9twp5WW7gT0-s0-kFw@mail.gmail.com>
Subject: [PATCH] cx231xx: Add support for Hauppauge WinTV USB2-FM
From: Peter Moon <pomoon@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for the "Hauppauge WinTV USB2-FM" Analog TV Stick.
It includes support for both the PAL and NTSC variants of the device.

Signed-off-by: Peter Moon <pomoon@gmail.com>


diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c
b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 8d78134..53ff26e 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -355,6 +355,8 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 	case CX231XX_BOARD_HAUPPAUGE_USBLIVE2:
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
+	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
+	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
 		if (avmode == POLARIS_AVMODE_ANALOGT_TV) {
 			while (afe_power_status != (FLD_PWRDN_TUNING_BIAS |
 						FLD_PWRDN_ENABLE_PLL)) {
@@ -1733,6 +1735,8 @@ int cx231xx_dif_set_standard(struct cx231xx
*dev, u32 standard)
 		break;
 	case CX231XX_BOARD_CNXT_RDE_253S:
 	case CX231XX_BOARD_CNXT_RDU_253S:
+	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
+	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
 		func_mode = 0x01;
 		break;
 	default:
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c
b/drivers/media/video/cx231xx/cx231xx-cards.c
index 2270381..4b22afe 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -532,6 +532,76 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+	[CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL] = {
+		.name = "Hauppauge WinTV USB2 FM (PAL)",
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
+		.tuner_gpio = RDE250_XCV_TUNER,
+		.tuner_sif_gpio = 0x05,
+		.tuner_scl_gpio = 0x1a,
+		.tuner_sda_gpio = 0x1b,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x0c,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 1,
+		.norm = V4L2_STD_PAL,
+
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
+	[CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC] = {
+		.name = "Hauppauge WinTV USB2 FM (NTSC)",
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
+		.tuner_gpio = RDE250_XCV_TUNER,
+		.tuner_sif_gpio = 0x05,
+		.tuner_scl_gpio = 0x1a,
+		.tuner_sda_gpio = 0x1b,
+		.decoder = CX231XX_AVDECODER,
+		.output_mode = OUT_MODE_VIP11,
+		.ctl_pin_status_mask = 0xFFFFFFC4,
+		.agc_analog_digital_select_gpio = 0x0c,
+		.gpio_pin_status_mask = 0x4001000,
+		.tuner_i2c_master = 1,
+		.norm = V4L2_STD_NTSC,
+
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
 };
 const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);

@@ -553,6 +623,10 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
 	{USB_DEVICE(0x0572, 0x58A0),
 	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+	{USB_DEVICE(0x2040, 0xb110),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL},
+	{USB_DEVICE(0x2040, 0xb111),
+	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC},
 	{USB_DEVICE(0x2040, 0xb120),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_EXETER},
 	{USB_DEVICE(0x2040, 0xb140),
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c
b/drivers/media/video/cx231xx/cx231xx-core.c
index abe500f..d4457f9 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -742,6 +742,8 @@ int cx231xx_set_mode(struct cx231xx *dev, enum
cx231xx_mode set_mode)
 		case CX231XX_BOARD_CNXT_RDU_253S:
 		case CX231XX_BOARD_HAUPPAUGE_EXETER:
 		case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
+		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
+		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
 		errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 0);
 			break;
 		default:
@@ -1381,6 +1383,8 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	case CX231XX_BOARD_CNXT_RDU_253S:
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
+	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
+	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
 	errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 0);
 		break;
 	default:
diff --git a/drivers/media/video/cx231xx/cx231xx.h
b/drivers/media/video/cx231xx/cx231xx.h
index 46dd840..b39b85e73 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -67,6 +67,8 @@
 #define CX231XX_BOARD_PV_XCAPTURE_USB 11
 #define CX231XX_BOARD_KWORLD_UB430_USB_HYBRID 12
 #define CX231XX_BOARD_ICONBIT_U100 13
+#define CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL 14
+#define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15

 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
