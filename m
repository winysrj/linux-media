Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35960 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/8] xc5000: get rid of positive error codes
Date: Wed, 21 May 2014 15:19:58 -0300
Message-Id: <1400696402-1805-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Errors should also be negative and should follow the Kernel
standards.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/xc5000.c | 104 +++++++++++++++++++-----------------------
 1 file changed, 48 insertions(+), 56 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 5cd09a681b6a..94278cc5f3ef 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -75,13 +75,6 @@ struct xc5000_priv {
 #define XC_RF_MODE_AIR			0
 #define XC_RF_MODE_CABLE		1
 
-/* Result codes */
-#define XC_RESULT_SUCCESS		0
-#define XC_RESULT_RESET_FAILURE		1
-#define XC_RESULT_I2C_WRITE_FAILURE	2
-#define XC_RESULT_I2C_READ_FAILURE	3
-#define XC_RESULT_OUT_OF_RANGE		5
-
 /* Product id */
 #define XC_PRODUCT_ID_FW_NOT_LOADED	0x2000
 #define XC_PRODUCT_ID_FW_LOADED 	0x1388
@@ -258,9 +251,9 @@ static int xc_send_i2c_data(struct xc5000_priv *priv, u8 *buf, int len)
 
 	if (i2c_transfer(priv->i2c_props.adap, &msg, 1) != 1) {
 		printk(KERN_ERR "xc5000: I2C write failed (len=%i)\n", len);
-		return XC_RESULT_I2C_WRITE_FAILURE;
+		return -EREMOTEIO;
 	}
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
 #if 0
@@ -297,7 +290,7 @@ static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
 	}
 
 	*val = (bval[0] << 8) | bval[1];
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
 static void xc_wait(int wait_ms)
@@ -320,13 +313,13 @@ static int xc5000_TunerReset(struct dvb_frontend *fe)
 					   XC5000_TUNER_RESET, 0);
 		if (ret) {
 			printk(KERN_ERR "xc5000: reset failed\n");
-			return XC_RESULT_RESET_FAILURE;
+			return ret;
 		}
 	} else {
 		printk(KERN_ERR "xc5000: no tuner reset callback function, fatal\n");
-		return XC_RESULT_RESET_FAILURE;
+		return -EINVAL;
 	}
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
 static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
@@ -340,11 +333,11 @@ static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
 	buf[2] = (i2cData >> 8) & 0xFF;
 	buf[3] = i2cData & 0xFF;
 	result = xc_send_i2c_data(priv, buf, 4);
-	if (result == XC_RESULT_SUCCESS) {
+	if (result == 0) {
 		/* wait for busy flag to clear */
-		while ((WatchDogTimer > 0) && (result == XC_RESULT_SUCCESS)) {
+		while ((WatchDogTimer > 0) && (result == 0)) {
 			result = xc5000_readreg(priv, XREG_BUSY, (u16 *)buf);
-			if (result == XC_RESULT_SUCCESS) {
+			if (result == 0) {
 				if ((buf[0] == 0) && (buf[1] == 0)) {
 					/* busy flag cleared */
 					break;
@@ -356,7 +349,7 @@ static int xc_write_reg(struct xc5000_priv *priv, u16 regAddr, u16 i2cData)
 		}
 	}
 	if (WatchDogTimer <= 0)
-		result = XC_RESULT_I2C_WRITE_FAILURE;
+		result = -EREMOTEIO;
 
 	return result;
 }
@@ -377,7 +370,7 @@ static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 			/* RESET command */
 			result = xc5000_TunerReset(fe);
 			index += 2;
-			if (result != XC_RESULT_SUCCESS)
+			if (result != 0)
 				return result;
 		} else if (len & 0x8000) {
 			/* WAIT command */
@@ -404,7 +397,7 @@ static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 				result = xc_send_i2c_data(priv, buf,
 					nbytes_to_send);
 
-				if (result != XC_RESULT_SUCCESS)
+				if (result != 0)
 					return result;
 
 				pos += nbytes_to_send - 2;
@@ -412,7 +405,7 @@ static int xc_load_i2c_sequence(struct dvb_frontend *fe, const u8 *i2c_sequence)
 			index += len;
 		}
 	}
-	return XC_RESULT_SUCCESS;
+	return 0;
 }
 
 static int xc_initialize(struct xc5000_priv *priv)
@@ -437,7 +430,7 @@ static int xc_SetTVStandard(struct xc5000_priv *priv,
 	}
 
 	ret = xc_write_reg(priv, XREG_VIDEO_MODE, VideoMode);
-	if (ret == XC_RESULT_SUCCESS)
+	if (ret == 0)
 		ret = xc_write_reg(priv, XREG_AUDIO_MODE, AudioMode);
 
 	return ret;
@@ -467,7 +460,7 @@ static int xc_set_RF_frequency(struct xc5000_priv *priv, u32 freq_hz)
 
 	if ((freq_hz > xc5000_tuner_ops.info.frequency_max) ||
 		(freq_hz < xc5000_tuner_ops.info.frequency_min))
-		return XC_RESULT_OUT_OF_RANGE;
+		return -EINVAL;
 
 	freq_code = (u16)(freq_hz / 15625);
 
@@ -500,7 +493,7 @@ static int xc_get_frequency_error(struct xc5000_priv *priv, u32 *freq_error_hz)
 	u32 tmp;
 
 	result = xc5000_readreg(priv, XREG_FREQ_ERROR, &regData);
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return result;
 
 	tmp = (u32)regData;
@@ -521,7 +514,7 @@ static int xc_get_version(struct xc5000_priv *priv,
 	int result;
 
 	result = xc5000_readreg(priv, XREG_VERSION, &data);
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return result;
 
 	(*hw_majorversion) = (data >> 12) & 0x0F;
@@ -543,7 +536,7 @@ static int xc_get_hsync_freq(struct xc5000_priv *priv, u32 *hsync_freq_hz)
 	int result;
 
 	result = xc5000_readreg(priv, XREG_HSYNC_FREQ, &regData);
-	if (result != XC_RESULT_SUCCESS)
+	if (result != 0)
 		return result;
 
 	(*hsync_freq_hz) = ((regData & 0x0fff) * 763)/100;
@@ -593,7 +586,7 @@ static int xc_tune_channel(struct xc5000_priv *priv, u32 freq_hz, int mode)
 
 	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
-	if (xc_set_RF_frequency(priv, freq_hz) != XC_RESULT_SUCCESS)
+	if (xc_set_RF_frequency(priv, freq_hz) != 0)
 		return 0;
 
 	if (mode == XC_TUNE_ANALOG) {
@@ -607,7 +600,7 @@ static int xc_tune_channel(struct xc5000_priv *priv, u32 freq_hz, int mode)
 static int xc_set_xtal(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	int ret = XC_RESULT_SUCCESS;
+	int ret = 0;
 
 	switch (priv->chip_id) {
 	default:
@@ -649,23 +642,22 @@ static int xc5000_fwupload(struct dvb_frontend *fe)
 		priv->i2c_props.adap->dev.parent);
 	if (ret) {
 		printk(KERN_ERR "xc5000: Upload failed. (file not found?)\n");
-		ret = XC_RESULT_RESET_FAILURE;
 		goto out;
 	} else {
 		printk(KERN_DEBUG "xc5000: firmware read %Zu bytes.\n",
 		       fw->size);
-		ret = XC_RESULT_SUCCESS;
+		ret = 0;
 	}
 
 	if (fw->size != desired_fw->size) {
 		printk(KERN_ERR "xc5000: firmware incorrect size\n");
-		ret = XC_RESULT_RESET_FAILURE;
+		ret = -EINVAL;
 	} else {
 		printk(KERN_INFO "xc5000: firmware uploading...\n");
 		ret = xc_load_i2c_sequence(fe,  fw->data);
-		if (XC_RESULT_SUCCESS == ret)
+		if (0 == ret)
 			ret = xc_set_xtal(fe);
-		if (XC_RESULT_SUCCESS == ret)
+		if (0 == ret)
 			printk(KERN_INFO "xc5000: firmware upload complete...\n");
 		else
 			printk(KERN_ERR "xc5000: firmware upload failed...\n");
@@ -744,7 +736,7 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	u32 freq = fe->dtv_property_cache.frequency;
 	u32 delsys  = fe->dtv_property_cache.delivery_system;
 
-	if (xc_load_fw_and_init_tuner(fe, 0) != XC_RESULT_SUCCESS) {
+	if (xc_load_fw_and_init_tuner(fe, 0) != 0) {
 		dprintk(1, "Unable to load firmware and init tuner\n");
 		return -EINVAL;
 	}
@@ -821,7 +813,7 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 		__func__, freq, priv->freq_hz);
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR
 			"xc5000: xc_SetSignalSource(%d) failed\n",
 			priv->rf_mode);
@@ -831,13 +823,13 @@ static int xc5000_set_params(struct dvb_frontend *fe)
 	ret = xc_SetTVStandard(priv,
 		XC5000_Standard[priv->video_standard].VideoMode,
 		XC5000_Standard[priv->video_standard].AudioMode, 0);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
 		return -EREMOTEIO;
 	}
 
 	ret = xc_set_IF_frequency(priv, priv->if_khz);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR "xc5000: xc_Set_IF_frequency(%d) failed\n",
 		       priv->if_khz);
 		return -EIO;
@@ -862,15 +854,15 @@ static int xc5000_is_firmware_loaded(struct dvb_frontend *fe)
 	u16 id;
 
 	ret = xc5000_readreg(priv, XREG_PRODUCT_ID, &id);
-	if (ret == XC_RESULT_SUCCESS) {
+	if (ret == 0) {
 		if (id == XC_PRODUCT_ID_FW_NOT_LOADED)
-			ret = XC_RESULT_RESET_FAILURE;
+			ret = -ENOENT;
 		else
-			ret = XC_RESULT_SUCCESS;
+			ret = 0;
 	}
 
 	dprintk(1, "%s() returns %s id = 0x%x\n", __func__,
-		ret == XC_RESULT_SUCCESS ? "True" : "False", id);
+		ret == 0 ? "True" : "False", id);
 	return ret;
 }
 
@@ -937,7 +929,7 @@ static int xc5000_set_tv_freq(struct dvb_frontend *fe,
 
 tune_channel:
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR
 			"xc5000: xc_SetSignalSource(%d) failed\n",
 			priv->rf_mode);
@@ -947,7 +939,7 @@ tune_channel:
 	ret = xc_SetTVStandard(priv,
 		XC5000_Standard[priv->video_standard].VideoMode,
 		XC5000_Standard[priv->video_standard].AudioMode, 0);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
 		return -EREMOTEIO;
 	}
@@ -966,7 +958,7 @@ tune_channel:
 			/* PLL is unlocked, force reload of the firmware */
 			dprintk(1, "xc5000: PLL not locked (0x%x).  Reloading...\n",
 				pll_lock_status);
-			if (xc_load_fw_and_init_tuner(fe, 1) != XC_RESULT_SUCCESS) {
+			if (xc_load_fw_and_init_tuner(fe, 1) != 0) {
 				printk(KERN_ERR "xc5000: Unable to reload fw\n");
 				return -EREMOTEIO;
 			}
@@ -1011,13 +1003,13 @@ static int xc5000_set_radio_freq(struct dvb_frontend *fe,
 	ret = xc_SetTVStandard(priv, XC5000_Standard[radio_input].VideoMode,
 			       XC5000_Standard[radio_input].AudioMode, radio_input);
 
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR "xc5000: xc_SetTVStandard failed\n");
 		return -EREMOTEIO;
 	}
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR
 			"xc5000: xc_SetSignalSource(%d) failed\n",
 			priv->rf_mode);
@@ -1044,7 +1036,7 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 	if (priv->i2c_props.adap == NULL)
 		return -EINVAL;
 
-	if (xc_load_fw_and_init_tuner(fe, 0) != XC_RESULT_SUCCESS) {
+	if (xc_load_fw_and_init_tuner(fe, 0) != 0) {
 		dprintk(1, "Unable to load firmware and init tuner\n");
 		return -EINVAL;
 	}
@@ -1105,23 +1097,23 @@ static int xc5000_get_status(struct dvb_frontend *fe, u32 *status)
 static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	int ret = XC_RESULT_SUCCESS;
+	int ret = 0;
 	u16 pll_lock_status;
 	u16 fw_ck;
 
-	if (force || xc5000_is_firmware_loaded(fe) != XC_RESULT_SUCCESS) {
+	if (force || xc5000_is_firmware_loaded(fe) != 0) {
 
 fw_retry:
 
 		ret = xc5000_fwupload(fe);
-		if (ret != XC_RESULT_SUCCESS)
+		if (ret != 0)
 			return ret;
 
 		msleep(20);
 
 		if (priv->fw_checksum_supported) {
 			if (xc5000_readreg(priv, XREG_FW_CHECKSUM, &fw_ck)
-			    != XC_RESULT_SUCCESS) {
+			    != 0) {
 				dprintk(1, "%s() FW checksum reading failed.\n",
 					__func__);
 				goto fw_retry;
@@ -1137,7 +1129,7 @@ fw_retry:
 		/* Start the tuner self-calibration process */
 		ret |= xc_initialize(priv);
 
-		if (ret != XC_RESULT_SUCCESS)
+		if (ret != 0)
 			goto fw_retry;
 
 		/* Wait for calibration to complete.
@@ -1148,7 +1140,7 @@ fw_retry:
 		xc_wait(100);
 
 		if (priv->init_status_supported) {
-			if (xc5000_readreg(priv, XREG_INIT_STATUS, &fw_ck) != XC_RESULT_SUCCESS) {
+			if (xc5000_readreg(priv, XREG_INIT_STATUS, &fw_ck) != 0) {
 				dprintk(1, "%s() FW failed reading init status.\n",
 					__func__);
 				goto fw_retry;
@@ -1191,13 +1183,13 @@ static int xc5000_sleep(struct dvb_frontend *fe)
 	   was removed in newer versions of the firmware.  The "supported"
 	   way to sleep the tuner is to pull the reset pin low for 10ms */
 	ret = xc5000_TunerReset(fe);
-	if (ret != XC_RESULT_SUCCESS) {
+	if (ret != 0) {
 		printk(KERN_ERR
 			"xc5000: %s() unable to shutdown tuner\n",
 			__func__);
 		return -EREMOTEIO;
 	} else
-		return XC_RESULT_SUCCESS;
+		return 0;
 }
 
 static int xc5000_init(struct dvb_frontend *fe)
@@ -1205,7 +1197,7 @@ static int xc5000_init(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	dprintk(1, "%s()\n", __func__);
 
-	if (xc_load_fw_and_init_tuner(fe, 0) != XC_RESULT_SUCCESS) {
+	if (xc_load_fw_and_init_tuner(fe, 0) != 0) {
 		printk(KERN_ERR "xc5000: Unable to initialise tuner\n");
 		return -EREMOTEIO;
 	}
@@ -1327,7 +1319,7 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 	/* Check if firmware has been loaded. It is possible that another
 	   instance of the driver has loaded the firmware.
 	 */
-	if (xc5000_readreg(priv, XREG_PRODUCT_ID, &id) != XC_RESULT_SUCCESS)
+	if (xc5000_readreg(priv, XREG_PRODUCT_ID, &id) != 0)
 		goto fail;
 
 	switch (id) {
-- 
1.9.0

