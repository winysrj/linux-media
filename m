Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35031 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161153AbaJ3UNV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:21 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 13/14] cx231xx: drop unconditional port3 switching
Date: Thu, 30 Oct 2014 21:12:34 +0100
Message-Id: <1414699955-5760-14-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All switching should be done by i2c mux adapters.
Drop explicit dont_use_port_3 flag.
Drop info message about switch.

Only the removed code in start_streaming is questionable:
It did switch the port_3 flag without accessing i2c in between.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 18 ------------------
 drivers/media/usb/cx231xx/cx231xx-cards.c  |  8 --------
 drivers/media/usb/cx231xx/cx231xx-core.c   |  4 +---
 drivers/media/usb/cx231xx/cx231xx-dvb.c    |  4 ----
 drivers/media/usb/cx231xx/cx231xx.h        |  1 -
 5 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index a3e4915..781908b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1270,9 +1270,6 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	int status = 0;
 	bool current_is_port_3;
 
-	if (dev->board.dont_use_port_3)
-		is_port_3 = false;
-
 	/*
 	 * Should this code check dev->port_3_switch_enabled first
 	 * to skip unnecessary reading of the register?
@@ -1296,9 +1293,6 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	else
 		value[0] &= ~I2C_DEMOD_EN;
 
-	cx231xx_info("Changing the i2c master port to %d\n",
-		     is_port_3 ?  3 : 1);
-
 	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
 					PWR_CTL_EN, value, 4);
 
@@ -2328,9 +2322,6 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 		}
 
 		if (dev->board.tuner_type != TUNER_ABSENT) {
-			/* Enable tuner */
-			cx231xx_enable_i2c_port_3(dev, true);
-
 			/* reset the Tuner */
 			if (dev->board.tuner_gpio)
 				cx231xx_gpio_set(dev, dev->board.tuner_gpio);
@@ -2395,15 +2386,6 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 		}
 
 		if (dev->board.tuner_type != TUNER_ABSENT) {
-			/*
-			 * Enable tuner
-			 *	Hauppauge Exeter seems to need to do something different!
-			 */
-			if (dev->model == CX231XX_BOARD_HAUPPAUGE_EXETER)
-				cx231xx_enable_i2c_port_3(dev, false);
-			else
-				cx231xx_enable_i2c_port_3(dev, true);
-
 			/* reset the Tuner */
 			if (dev->board.tuner_gpio)
 				cx231xx_gpio_set(dev, dev->board.tuner_gpio);
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 4eb2057..432cbcf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -262,7 +262,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_PAL,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		/* Actually, it has a 417, but it isn't working correctly.
 		 * So set to 0 for now until someone can manage to get this
 		 * to work reliably. */
@@ -390,7 +389,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		.input = {{
 			.type = CX231XX_VMUX_COMPOSITE1,
 			.vmux = CX231XX_VIN_2_1,
@@ -532,7 +530,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 
 		.input = {{
 				.type = CX231XX_VMUX_COMPOSITE1,
@@ -656,7 +653,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		.input = {{
 			.type = CX231XX_VMUX_COMPOSITE1,
 			.vmux = CX231XX_VIN_2_1,
@@ -683,7 +679,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.norm = V4L2_STD_NTSC,
 		.no_alt_vanc = 1,
 		.external_av = 1,
-		.dont_use_port_3 = 1,
 		/*.has_417 = 1, */
 		/* This board is believed to have a hardware encoding chip
 		 * supporting mpeg1/2/4, but as the 417 is apparently not
@@ -1012,9 +1007,6 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 		len_todo -= msg_read.len;
 	}
 
-	cx231xx_enable_i2c_port_3(dev, true);
-	/* mutex_unlock(&dev->i2c_lock); */
-
 	for (i = 0; i + 15 < len; i += 16)
 		cx231xx_info("i2c eeprom %02x: %*ph\n", i, 16, &eedata[i]);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index c8a6d20..c49022f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1407,9 +1407,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	if (dev->board.has_dvb)
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 
-	/* set the I2C master port to 3 on channel 1 */
-	errCode = cx231xx_enable_i2c_port_3(dev, true);
-
+	errCode = 0;
 	return errCode;
 }
 EXPORT_SYMBOL_GPL(cx231xx_dev_init);
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 869c433..2ea6946 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -266,11 +266,7 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 
 	if (dev->USE_ISO) {
 		cx231xx_info("DVB transfer mode is ISO.\n");
-		mutex_lock(&dev->i2c_lock);
-		cx231xx_enable_i2c_port_3(dev, false);
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
-		cx231xx_enable_i2c_port_3(dev, true);
-		mutex_unlock(&dev->i2c_lock);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
 			return rc;
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index c90aa44..a0ec241 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -368,7 +368,6 @@ struct cx231xx_board {
 	unsigned int valid:1;
 	unsigned int no_alt_vanc:1;
 	unsigned int external_av:1;
-	unsigned int dont_use_port_3:1;
 
 	unsigned char xclk, i2c_speed;
 
-- 
2.1.2

