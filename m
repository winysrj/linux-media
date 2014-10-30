Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35009 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161068AbaJ3UNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:09 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 06/14] cx231xx: Use symbolic constants for i2c ports instead of numbers
Date: Thu, 30 Oct 2014 21:12:27 +0100
Message-Id: <1414699955-5760-7-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace numbers by the constants of same value and same meaning.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 62 +++++++++++++++----------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 092fb85..2f027c7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -104,8 +104,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -144,8 +144,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x32,
 		.norm = V4L2_STD_NTSC,
@@ -184,8 +184,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -225,8 +225,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -297,8 +297,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
 		.norm = V4L2_STD_PAL,
@@ -325,8 +325,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x32,
 		.norm = V4L2_STD_NTSC,
@@ -353,8 +353,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_NTSC,
@@ -418,9 +418,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 2,
-		.demod_i2c_master = 1,
-		.ir_i2c_master = 2,
+		.tuner_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1,
+		.ir_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
 		.norm = V4L2_STD_PAL_M,
@@ -456,9 +456,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 2,
-		.demod_i2c_master = 1,
-		.ir_i2c_master = 2,
+		.tuner_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1,
+		.ir_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
 		.norm = V4L2_STD_NTSC_M,
@@ -494,9 +494,9 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 2,
-		.demod_i2c_master = 1,
-		.ir_i2c_master = 2,
+		.tuner_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1,
+		.ir_i2c_master = I2C_2,
 		.rc_map_name = RC_MAP_PIXELVIEW_002T,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
@@ -587,7 +587,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
+		.tuner_i2c_master = I2C_1,
 		.norm = V4L2_STD_PAL,
 
 		.input = {{
@@ -622,7 +622,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
+		.tuner_i2c_master = I2C_1,
 		.norm = V4L2_STD_NTSC,
 
 		.input = {{
@@ -718,8 +718,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
@@ -757,8 +757,8 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = 1,
-		.demod_i2c_master = 2,
+		.tuner_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
@@ -1033,7 +1033,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	/* request some modules */
 	if (dev->board.decoder == CX231XX_AVDECODER) {
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-					&dev->i2c_bus[0].i2c_adap,
+					&dev->i2c_bus[I2C_0].i2c_adap,
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
 			cx231xx_info("cx25840 subdev registration failure\n");
@@ -1062,7 +1062,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 			struct i2c_client client;
 
 			memset(&client, 0, sizeof(client));
-			client.adapter = &dev->i2c_bus[1].i2c_adap;
+			client.adapter = &dev->i2c_bus[I2C_1].i2c_adap;
 			client.addr = 0xa0 >> 1;
 
 			read_eeprom(dev, &client, eeprom, sizeof(eeprom));
-- 
2.1.2

