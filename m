Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39100 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab3LAVGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:24 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so8390296eaj.15
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:23 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 7/7] em28xx: add support for the SpeedLink Vicious And Devine Laplace webcams
Date: Sun,  1 Dec 2013 22:06:57 +0100
Message-Id: <1385932017-2276-8-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SpeedLink Vicious And Devine Laplace webcam is using an EM2765 bridge and
an OV2640 sensor. It has a built-in microphone (USB standard device class)
and provides 3 buttons (snapshot, illumination, mute) and 2 LEDs (capturing/mute
and illumination/flash). It is also equipped with an eeprom.
The device is available in two colors: white (1ae7:9003) and black (1ae7:9004).
For further details see http://linuxtv.org/wiki/index.php/VAD_Laplace.

Please note the following limitations that need to be addressed later:
- resolution limited to 640x480 (sensor supports 1600x1200)
- picture quality needs to be improved
- AV-mute button doesn't work yet

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   72 +++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 2 Dateien geändert, 73 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index ebb112c..6454309 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -412,6 +412,21 @@ static struct em28xx_reg_seq pctv_520e[] = {
 	{	-1,			-1,	-1,	-1},
 };
 
+/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
+ * reg 0x80/0x84:
+ * GPIO_0: capturing LED, 0=on, 1=off
+ * GPIO_2: AV mute button, 0=pressed, 1=unpressed
+ * GPIO 3: illumination button, 0=pressed, 1=unpressed
+ * GPIO_6: illumination/flash LED, 0=on, 1=off
+ * reg 0x81/0x85:
+ * GPIO_7: snapshot button, 0=pressed, 1=unpressed
+ */
+static struct em28xx_reg_seq speedlink_vad_laplace_reg_seq[] = {
+	{EM2820_R08_GPIO_CTRL,		0xf7,	0xff,	10},
+	{EM2874_R80_GPIO_P0_CTRL,	0xff,	0xb2,	10},
+	{	-1,			-1,	-1,	-1},
+};
+
 /*
  *  Button definitions
  */
@@ -426,6 +441,41 @@ static struct em28xx_button std_snapshot_button[] = {
 	{-1, 0, 0, 0, 0},
 };
 
+static struct em28xx_button speedlink_vad_laplace_buttons[] = {
+	{
+		.role     = EM28XX_BUTTON_SNAPSHOT,
+		.reg_r    = EM2874_R85_GPIO_P1_STATE,
+		.mask     = 0x80,
+		.inverted = 1,
+	},
+	{
+		.role     = EM28XX_BUTTON_ILLUMINATION,
+		.reg_r    = EM2874_R84_GPIO_P0_STATE,
+		.mask     = 0x08,
+		.inverted = 1,
+	},
+	{-1, 0, 0, 0, 0},
+};
+
+/*
+ *  LED definitions
+ */
+static struct em28xx_led speedlink_vad_laplace_leds[] = {
+	{
+		.role      = EM28XX_LED_ANALOG_CAPTURING,
+		.gpio_reg  = EM2874_R80_GPIO_P0_CTRL,
+		.gpio_mask = 0x01,
+		.inverted  = 1,
+	},
+	{
+		.role      = EM28XX_LED_ILLUMINATION,
+		.gpio_reg  = EM2874_R80_GPIO_P0_CTRL,
+		.gpio_mask = 0x40,
+		.inverted  = 1,
+	},
+	{-1, 0, 0, 0},
+};
+
 /*
  *  Board definitions
  */
@@ -2057,6 +2107,24 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_gpio	= default_tuner_gpio,
 		.def_i2c_bus	= 1,
 	},
+	/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
+	 * Empia EM2765 + OmniVision OV2640 */
+	[EM2765_BOARD_SPEEDLINK_VAD_LAPLACE] = {
+		.name         = "SpeedLink Vicious And Devine Laplace webcam",
+		.xclk         = EM28XX_XCLK_FREQUENCY_24MHZ,
+		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
+				EM28XX_I2C_FREQ_100_KHZ,
+		.def_i2c_bus  = 1,
+		.tuner_type   = TUNER_ABSENT,
+		.is_webcam    = 1,
+		.input        = { {
+			.type     = EM28XX_VMUX_COMPOSITE1,
+			.amux     = EM28XX_AMUX_VIDEO,
+			.gpio     = speedlink_vad_laplace_reg_seq,
+		} },
+		.buttons = speedlink_vad_laplace_buttons,
+		.leds = speedlink_vad_laplace_leds,
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2222,6 +2290,10 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_PCTV_520E },
 	{ USB_DEVICE(0x1b80, 0xe1cc),
 			.driver_info = EM2874_BOARD_DELOCK_61959 },
+	{ USB_DEVICE(0x1ae7, 0x9003),
+			.driver_info = EM2765_BOARD_SPEEDLINK_VAD_LAPLACE },
+	{ USB_DEVICE(0x1ae7, 0x9004),
+			.driver_info = EM2765_BOARD_SPEEDLINK_VAD_LAPLACE },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 43e2968..6e26fba 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -132,6 +132,7 @@
 #define EM2884_BOARD_C3TECH_DIGITAL_DUO		  88
 #define EM2874_BOARD_DELOCK_61959		  89
 #define EM2874_BOARD_KWORLD_UB435Q_V2		  90
+#define EM2765_BOARD_SPEEDLINK_VAD_LAPLACE	  91
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.10.4

