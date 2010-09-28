Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab0I1Swc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:52:32 -0400
Date: Tue, 28 Sep 2010 15:46:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/10] V4L/DVB: cx231xx: better handle the master port
 enable command
Message-ID: <20100928154657.70843032@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Improves the logic, for it to be clearer and to avoid having
board-dependent config there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index ab9fbf8..2d773b3 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -1268,36 +1268,39 @@ int cx231xx_set_agc_analog_digital_mux_select(struct cx231xx *dev,
 	return status;
 }
 
-int cx231xx_enable_i2c_for_tuner(struct cx231xx *dev, u8 I2CIndex)
+int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
 	int status = 0;
-
-	cx231xx_info("Changing the i2c port for tuner to %d\n", I2CIndex);
+	bool current_is_port_3;
 
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
 				       PWR_CTL_EN, value, 4);
 	if (status < 0)
 		return status;
 
-	if (I2CIndex == I2C_1) {
-		if (value[0] & I2C_DEMOD_EN) {
-			value[0] &= ~I2C_DEMOD_EN;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-						   PWR_CTL_EN, value, 4);
-		}
-	} else {
-		if (!(value[0] & I2C_DEMOD_EN)) {
-			value[0] |= I2C_DEMOD_EN;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-						   PWR_CTL_EN, value, 4);
-		}
-	}
+	current_is_port_3 = value[0] & I2C_DEMOD_EN ? true : false;
+
+	/* Just return, if already using the right port */
+	if (current_is_port_3 == is_port_3)
+		return 0;
+
+	if (is_port_3)
+		value[0] |= I2C_DEMOD_EN;
+	else
+		value[0] &= ~I2C_DEMOD_EN;
+
+	cx231xx_info("Changing the i2c master port to %d\n",
+		     is_port_3 ?  3 : 1);
+
+	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+					PWR_CTL_EN, value, 4);
 
 	return status;
 
 }
-EXPORT_SYMBOL_GPL(cx231xx_enable_i2c_for_tuner);
+EXPORT_SYMBOL_GPL(cx231xx_enable_i2c_port_3);
+
 void update_HH_register_after_set_DIF(struct cx231xx *dev)
 {
 /*
@@ -2324,26 +2327,16 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 			msleep(PWR_SLEEP_INTERVAL);
 		}
 
-		if ((dev->model == CX231XX_BOARD_CNXT_CARRAERA) ||
-		    (dev->model == CX231XX_BOARD_CNXT_RDE_250) ||
-		    (dev->model == CX231XX_BOARD_CNXT_SHELBY) ||
-		    (dev->model == CX231XX_BOARD_CNXT_RDU_250)) {
-			/* tuner path to channel 1 from port 3 */
-			cx231xx_enable_i2c_for_tuner(dev, I2C_3);
+		if (dev->board.tuner_type != TUNER_ABSENT) {
+			/* Enable tuner */
+			cx231xx_enable_i2c_port_3(dev, true);
 
 			/* reset the Tuner */
-			cx231xx_gpio_set(dev, dev->board.tuner_gpio);
+			if (dev->board.tuner_gpio)
+				cx231xx_gpio_set(dev, dev->board.tuner_gpio);
 
 			if (dev->cx231xx_reset_analog_tuner)
 				dev->cx231xx_reset_analog_tuner(dev);
-		} else if ((dev->model == CX231XX_BOARD_CNXT_RDE_253S) ||
-			   (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER) ||
-			   (dev->model == CX231XX_BOARD_CNXT_RDU_253S) ||
-			   (dev->model == CX231XX_BOARD_HAUPPAUGE_EXETER)) {
-			/* tuner path to channel 1 from port 3 */
-			cx231xx_enable_i2c_for_tuner(dev, I2C_3);
-			if (dev->cx231xx_reset_analog_tuner)
-				dev->cx231xx_reset_analog_tuner(dev);
 		}
 
 		break;
@@ -2401,33 +2394,23 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 			msleep(PWR_SLEEP_INTERVAL);
 		}
 
-		if ((dev->model == CX231XX_BOARD_CNXT_CARRAERA) ||
-		    (dev->model == CX231XX_BOARD_CNXT_RDE_250) ||
-		    (dev->model == CX231XX_BOARD_CNXT_SHELBY) ||
-		    (dev->model == CX231XX_BOARD_CNXT_RDU_250)) {
-			/* tuner path to channel 1 from port 3 */
-			cx231xx_enable_i2c_for_tuner(dev, I2C_3);
+		if (dev->board.tuner_type != TUNER_ABSENT) {
+			/*
+			 * Enable tuner
+			 *	Hauppauge Exeter seems to need to do something different!
+			 */
+			if (dev->model == CX231XX_BOARD_HAUPPAUGE_EXETER)
+				cx231xx_enable_i2c_port_3(dev, false);
+			else
+				cx231xx_enable_i2c_port_3(dev, true);
 
 			/* reset the Tuner */
-			cx231xx_gpio_set(dev, dev->board.tuner_gpio);
-
-			if (dev->cx231xx_reset_analog_tuner)
-				dev->cx231xx_reset_analog_tuner(dev);
-		} else if ((dev->model == CX231XX_BOARD_CNXT_RDE_253S) ||
-		    (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER) ||
-		    (dev->model == CX231XX_BOARD_CNXT_RDU_253S)) {
-			/* tuner path to channel 1 from port 3 */
-			cx231xx_enable_i2c_for_tuner(dev, I2C_3);
-			if (dev->cx231xx_reset_analog_tuner)
-				dev->cx231xx_reset_analog_tuner(dev);
-		} else if (dev->model == CX231XX_BOARD_HAUPPAUGE_EXETER) {
-			/* tuner path to channel 1 from port 1 ?? */
-			cx231xx_enable_i2c_for_tuner(dev, I2C_1);
+			if (dev->board.tuner_gpio)
+				cx231xx_gpio_set(dev, dev->board.tuner_gpio);
 
 			if (dev->cx231xx_reset_analog_tuner)
 				dev->cx231xx_reset_analog_tuner(dev);
 		}
-
 		break;
 
 	default:
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/video/cx231xx/cx231xx-core.c
index 983b120..4af46fc 100644
--- a/drivers/media/video/cx231xx/cx231xx-core.c
+++ b/drivers/media/video/cx231xx/cx231xx-core.c
@@ -1401,9 +1401,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
 
 	/* set the I2C master port to 3 on channel 1 */
-	if (dev->model != CX231XX_BOARD_CNXT_VIDEO_GRABBER &&
-	    dev->model != CX231XX_BOARD_HAUPPAUGE_USBLIVE2)
-		errCode = cx231xx_enable_i2c_for_tuner(dev, I2C_3);
+	errCode = cx231xx_enable_i2c_port_3(dev, true);
 
 	return errCode;
 }
diff --git a/drivers/media/video/cx231xx/cx231xx-dvb.c b/drivers/media/video/cx231xx/cx231xx-dvb.c
index 4efd3d3..5feb3ee 100644
--- a/drivers/media/video/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/video/cx231xx/cx231xx-dvb.c
@@ -235,11 +235,11 @@ static int start_streaming(struct cx231xx_dvb *dvb)
 
 	if (dev->USE_ISO) {
 		cx231xx_info("DVB transfer mode is ISO.\n");
-mutex_lock(&dev->i2c_lock);
-		cx231xx_enable_i2c_for_tuner(dev, I2C_1);
+		mutex_lock(&dev->i2c_lock);
+		cx231xx_enable_i2c_port_3(dev, false);
 		cx231xx_set_alt_setting(dev, INDEX_TS1, 4);
-		cx231xx_enable_i2c_for_tuner(dev, I2C_3);
-mutex_unlock(&dev->i2c_lock);
+		cx231xx_enable_i2c_port_3(dev, true);
+		mutex_unlock(&dev->i2c_lock);
 		rc = cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 		if (rc < 0)
 			return rc;
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index 5ffdd36..b4859a0 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -929,7 +929,7 @@ int cx231xx_power_suspend(struct cx231xx *dev);
 int cx231xx_init_ctrl_pin_status(struct cx231xx *dev);
 int cx231xx_set_agc_analog_digital_mux_select(struct cx231xx *dev,
 					      u8 analog_or_digital);
-int cx231xx_enable_i2c_for_tuner(struct cx231xx *dev, u8 I2CIndex);
+int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3);
 
 /* video audio decoder related functions */
 void video_mux(struct cx231xx *dev, int index);
-- 
1.7.1


