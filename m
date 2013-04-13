Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:47710 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3DMKUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 06:20:55 -0400
Received: by mail-ea0-f170.google.com with SMTP id a15so1520125eae.1
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 03:20:53 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: add basic support for the "SpeedLink Vicious And Devine Laplace" webcam
Date: Sat, 13 Apr 2013 12:21:44 +0200
Message-Id: <1365848504-3689-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SpeedLink Vicious And Devine Laplace webcam uses an EM2765 bridge and an
OV2640 sensor which allows capturing at a max. resoultion of 1600x1200 at
max. 7-8 fps. It has a built-in microphone (USB standard device class) and
provides 3 buttons (snapshot, mute, illumination) and 2 LEDs (capturing/mute and
illumination/flash). It is also equipped with an eeprom.
The device is available in two colors: white (1ae7:9003) and black (1ae7:9004).

This patch adds only basic support for this device, the limitations are:
- resolution limited to max. 640x480
- image quality needs to be improved
- support for the 3 buttons (snapshot, mute, illumination) is missing
- illumination/flash LED support is missing (capturing LED is functional)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   34 ++++++++++++++++++++++++++++++-
 drivers/media/usb/em28xx/em28xx-video.c |   14 +++++++++++++
 drivers/media/usb/em28xx/em28xx.h       |    1 +
 3 Dateien geändert, 48 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index e328159..c5d3fa56 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -411,6 +411,19 @@ static struct em28xx_reg_seq pctv_520e[] = {
 	{             -1,   -1,   -1,  -1},
 };
 
+/* 1ae7:9003/9004 SpeedLink Vicious And Devine Laplace webcam
+ * reg 0x80/0x84:
+ * GPIO_0: capturing LED, 0=on, 1=off
+ * GPIO_2: mute button, 0=pressed, 1=unpressed
+ * GPIO 3: illumination button, 0=pressed, 1=unpressed
+ * GPIO_6: illumination/flash LED, 0=on, 1=off
+ */
+static struct em28xx_reg_seq speedlink_vad_laplace_reg_seq[] = {
+	{EM28XX_R08_GPIO,	0xf7,	0xff,		10},
+	{EM25XX_R80_GPIO_P0_W,	0xff,	0xff,		10},
+	{	-1,		-1,	-1,		-1},
+};
+
 /*
  *  Board definitions
  */
@@ -1787,7 +1800,6 @@ struct em28xx_board em28xx_boards[] = {
 			.type     = EM28XX_VMUX_TELEVISION,
 			.vmux     = TVP5150_COMPOSITE0,
 			.amux     = EM28XX_AMUX_VIDEO,
-
 		}, {
 			.type     = EM28XX_VMUX_COMPOSITE1,
 			.vmux     = TVP5150_COMPOSITE1,
@@ -2016,6 +2028,22 @@ struct em28xx_board em28xx_boards[] = {
 		.i2c_speed    = EM28XX_I2C_CLK_WAIT_ENABLE |
 				EM28XX_I2C_FREQ_400_KHZ,
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
+	},
 };
 const unsigned int em28xx_bcount = ARRAY_SIZE(em28xx_boards);
 
@@ -2177,6 +2205,10 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_PCTV_510E },
 	{ USB_DEVICE(0x2013, 0x0251),
 			.driver_info = EM2884_BOARD_PCTV_520E },
+	{ USB_DEVICE(0x1ae7, 0x9003),
+			.driver_info = EM2765_BOARD_SPEEDLINK_VAD_LAPLACE },
+	{ USB_DEVICE(0x1ae7, 0x9004),
+			.driver_info = EM2765_BOARD_SPEEDLINK_VAD_LAPLACE },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, em28xx_id_table);
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 792ead1..f949cdc 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -660,6 +660,13 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 		if (rc < 0)
 			goto fail;
 
+		/* Switch on capturing LED */
+		if (dev->model == EM2765_BOARD_SPEEDLINK_VAD_LAPLACE)
+			em28xx_write_regs_bits(dev,
+					       EM25XX_R84_GPIO_P0_R,
+					       EM25XX_R80_GPIO_P0_W,
+					       0x00, 0x01);
+
 		/*
 		 * djh: it's not clear whether this code is still needed.  I'm
 		 * leaving it in here for now entirely out of concern for
@@ -693,6 +700,13 @@ static int em28xx_stop_streaming(struct vb2_queue *vq)
 	if (dev->streaming_users-- == 1) {
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
+
+		/* Switch off capturing LED */
+		if (dev->model == EM2765_BOARD_SPEEDLINK_VAD_LAPLACE)
+			em28xx_write_regs_bits(dev,
+					       EM25XX_R84_GPIO_P0_R,
+					       EM25XX_R80_GPIO_P0_W,
+					       0x01, 0x01);
 	}
 
 	spin_lock_irqsave(&dev->slock, flags);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index a817c3d..d51f38f 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -130,6 +130,7 @@
 #define EM2884_BOARD_PCTV_520E			  86
 #define EM2884_BOARD_TERRATEC_HTC_USB_XS	  87
 #define EM2884_BOARD_C3TECH_DIGITAL_DUO		  88
+#define EM2765_BOARD_SPEEDLINK_VAD_LAPLACE	  89
 
 /* Limits minimum and default number of buffers */
 #define EM28XX_MIN_BUF 4
-- 
1.7.10.4

