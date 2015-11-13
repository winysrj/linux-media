Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41601 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbKMWzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 17:55:45 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 1/4] cx231xx_dvb: use demod_i2c for demod attach
Date: Fri, 13 Nov 2015 23:54:55 +0100
Message-Id: <1447455298-5562-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested:
* CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx
* CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx

Not Tested:
* CX231XX_BOARD_HAUPPAUGE_EXETER
* CX231XX_BOARD_HAUPPAUGE_955Q

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 8 ++++----
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 4a117a5..5d4b285 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -352,7 +352,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_1_MUX_1,
-		.demod_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1_MUX_1,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_NTSC,
@@ -713,7 +713,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_1_MUX_3,
-		.demod_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
@@ -752,7 +752,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_1_MUX_3,
-		.demod_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_PAL,
@@ -791,7 +791,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.agc_analog_digital_select_gpio = 0x0c,
 		.gpio_pin_status_mask = 0x4001000,
 		.tuner_i2c_master = I2C_1_MUX_3,
-		.demod_i2c_master = I2C_2,
+		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
 		.demod_addr = 0x0e,
 		.norm = V4L2_STD_NTSC,
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 66ee161..e3594b9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -725,7 +725,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(lgdt3305_attach,
 						&hcw_lgdt3305_config,
-						tuner_i2c);
+						demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
@@ -746,7 +746,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(si2165_attach,
 			&hauppauge_930C_HD_1113xx_si2165_config,
-			tuner_i2c
+			demod_i2c
 			);
 
 		if (dev->dvb->frontend == NULL) {
@@ -779,7 +779,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(si2165_attach,
 			&pctv_quatro_stick_1114xx_si2165_config,
-			tuner_i2c
+			demod_i2c
 			);
 
 		if (dev->dvb->frontend == NULL) {
@@ -835,7 +835,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(lgdt3306a_attach,
 			&hauppauge_955q_lgdt3306a_config,
-			tuner_i2c
+			demod_i2c
 			);
 
 		if (dev->dvb->frontend == NULL) {
-- 
2.6.3

