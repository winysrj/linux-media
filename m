Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43853 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaIYFI2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 01:08:28 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 09/12] cx231xx: change usage of I2C_1 to the real i2c port
Date: Thu, 25 Sep 2014 07:08:01 +0200
Message-Id: <1411621684-8295-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

change almost all instances of I2C_1 to I2C_3

Keep I2C_1 for these cases:
* All that have dont_use_port_3 set.
* CX231XX_BOARD_HAUPPAUGE_EXETER, old code did explicitly not switch to port3.
* eeprom access for 930C

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 330fe39..a6fdb6f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -104,7 +104,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
@@ -144,7 +144,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x32,
@@ -184,7 +184,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
@@ -225,7 +225,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x1c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
@@ -297,7 +297,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x02,
@@ -325,7 +325,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x32,
@@ -419,7 +419,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_2,
-		.demod_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_3,
 		.ir_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
@@ -457,7 +457,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_2,
-		.demod_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_3,
 		.ir_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x10,
@@ -495,7 +495,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.tuner_sda_gpio = -1,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_2,
-		.demod_i2c_master = I2C_1,
+		.demod_i2c_master = I2C_3,
 		.ir_i2c_master = I2C_2,
 		.rc_map_name = RC_MAP_PIXELVIEW_002T,
 		.has_dvb = 1,
@@ -587,7 +587,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.norm = V4L2_STD_PAL,
 
 		.input = {{
@@ -622,7 +622,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.norm = V4L2_STD_NTSC,
 
 		.input = {{
@@ -718,7 +718,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
@@ -757,7 +757,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.ctl_pin_status_mask = 0xFFFFFFC4,
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
-		.tuner_i2c_master = I2C_1,
+		.tuner_i2c_master = I2C_3,
 		.demod_i2c_master = I2C_2,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
-- 
2.1.1

