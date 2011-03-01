Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:47130 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab1CANL2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 08:11:28 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, mchehab@redhat.com, hverkuil@xs4all.nl,
	sameo@linux.intel.com, linux-media@vger.kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v22 2/3] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver
Date: Tue,  1 Mar 2011 15:10:36 +0200
Message-Id: <1298985037-2714-3-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1298985037-2714-2-git-send-email-matti.j.aaltonen@nokia.com>
References: <1298985037-2714-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1298985037-2714-2-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This module implements V4L2 controls for the Texas Instruments
WL1273 FM Radio and handles the communication with the chip.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/media/radio/radio-wl1273.c |  360 +++++++++++-------------------------
 1 files changed, 106 insertions(+), 254 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 7ecc8e6..9e177dc 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1,7 +1,7 @@
 /*
  * Driver for the Texas Instruments WL1273 FM radio.
  *
- * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2011 Nokia Corporation
  * Author: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
  *
  * This program is free software; you can redistribute it and/or
@@ -104,58 +104,6 @@ static unsigned int rds_buf = 100;
 module_param(rds_buf, uint, 0);
 MODULE_PARM_DESC(rds_buf, "Number of RDS buffer entries. Default = 100");
 
-static int wl1273_fm_read_reg(struct wl1273_core *core, u8 reg, u16 *value)
-{
-	struct i2c_client *client = core->client;
-	u8 b[2];
-	int r;
-
-	r = i2c_smbus_read_i2c_block_data(client, reg, sizeof(b), b);
-	if (r != 2) {
-		dev_err(&client->dev, "%s: Read: %d fails.\n", __func__, reg);
-		return -EREMOTEIO;
-	}
-
-	*value = (u16)b[0] << 8 | b[1];
-
-	return 0;
-}
-
-static int wl1273_fm_write_cmd(struct wl1273_core *core, u8 cmd, u16 param)
-{
-	struct i2c_client *client = core->client;
-	u8 buf[] = { (param >> 8) & 0xff, param & 0xff };
-	int r;
-
-	r = i2c_smbus_write_i2c_block_data(client, cmd, sizeof(buf), buf);
-	if (r) {
-		dev_err(&client->dev, "%s: Cmd: %d fails.\n", __func__, cmd);
-		return r;
-	}
-
-	return 0;
-}
-
-static int wl1273_fm_write_data(struct wl1273_core *core, u8 *data, u16 len)
-{
-	struct i2c_client *client = core->client;
-	struct i2c_msg msg;
-	int r;
-
-	msg.addr = client->addr;
-	msg.flags = 0;
-	msg.buf = data;
-	msg.len = len;
-
-	r = i2c_transfer(client->adapter, &msg, 1);
-	if (r != 1) {
-		dev_err(&client->dev, "%s: write error.\n", __func__);
-		return -EREMOTEIO;
-	}
-
-	return 0;
-}
-
 static int wl1273_fm_write_fw(struct wl1273_core *core,
 			      __u8 *fw, int len)
 {
@@ -188,94 +136,6 @@ static int wl1273_fm_write_fw(struct wl1273_core *core,
 	return r;
 }
 
-/**
- * wl1273_fm_set_audio() -	Set audio mode.
- * @core:			A pointer to the device struct.
- * @new_mode:			The new audio mode.
- *
- * Audio modes are WL1273_AUDIO_DIGITAL and WL1273_AUDIO_ANALOG.
- */
-static int wl1273_fm_set_audio(struct wl1273_core *core, unsigned int new_mode)
-{
-	int r = 0;
-
-	if (core->mode == WL1273_MODE_OFF ||
-	    core->mode == WL1273_MODE_SUSPENDED)
-		return -EPERM;
-
-	if (core->mode == WL1273_MODE_RX && new_mode == WL1273_AUDIO_DIGITAL) {
-		r = wl1273_fm_write_cmd(core, WL1273_PCM_MODE_SET,
-					WL1273_PCM_DEF_MODE);
-		if (r)
-			goto out;
-
-		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
-					core->i2s_mode);
-		if (r)
-			goto out;
-
-		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
-					WL1273_AUDIO_ENABLE_I2S);
-		if (r)
-			goto out;
-
-	} else if (core->mode == WL1273_MODE_RX &&
-		   new_mode == WL1273_AUDIO_ANALOG) {
-		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_ENABLE,
-					WL1273_AUDIO_ENABLE_ANALOG);
-		if (r)
-			goto out;
-
-	} else if (core->mode == WL1273_MODE_TX &&
-		   new_mode == WL1273_AUDIO_DIGITAL) {
-		r = wl1273_fm_write_cmd(core, WL1273_I2S_MODE_CONFIG_SET,
-					core->i2s_mode);
-		if (r)
-			goto out;
-
-		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
-					WL1273_AUDIO_IO_SET_I2S);
-		if (r)
-			goto out;
-
-	} else if (core->mode == WL1273_MODE_TX &&
-		   new_mode == WL1273_AUDIO_ANALOG) {
-		r = wl1273_fm_write_cmd(core, WL1273_AUDIO_IO_SET,
-					WL1273_AUDIO_IO_SET_ANALOG);
-		if (r)
-			goto out;
-	}
-
-	core->audio_mode = new_mode;
-out:
-	return r;
-}
-
-/**
- * wl1273_fm_set_volume() -	Set volume.
- * @core:			A pointer to the device struct.
- * @volume:			The new volume value.
- */
-static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
-{
-	u16 val;
-	int r;
-
-	if (volume > WL1273_MAX_VOLUME)
-		return -EINVAL;
-
-	if (core->volume == volume)
-		return 0;
-
-	val = volume;
-	r = wl1273_fm_read_reg(core, WL1273_VOLUME_SET, &val);
-	if (r)
-		return r;
-
-	core->volume = volume;
-	return 0;
-}
-
 #define WL1273_FIFO_HAS_DATA(status)	(1 << 5 & status)
 #define WL1273_RDS_CORRECTABLE_ERROR	(1 << 3)
 #define WL1273_RDS_UNCORRECTABLE_ERROR	(1 << 4)
@@ -306,7 +166,7 @@ static int wl1273_fm_rds(struct wl1273_device *radio)
 	if (core->mode != WL1273_MODE_RX)
 		return 0;
 
-	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+	r = core->read(core, WL1273_RDS_SYNC_GET, &val);
 	if (r)
 		return r;
 
@@ -374,7 +234,7 @@ static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
 	u16 flags;
 	int r;
 
-	r = wl1273_fm_read_reg(core, WL1273_FLAG_GET, &flags);
+	r = core->read(core, WL1273_FLAG_GET, &flags);
 	if (r)
 		goto out;
 
@@ -398,7 +258,7 @@ static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
 	if (flags & WL1273_LEV_EVENT) {
 		u16 level;
 
-		r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &level);
+		r = core->read(core, WL1273_RSSI_LVL_GET, &level);
 		if (r)
 			goto out;
 
@@ -439,8 +299,8 @@ static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
 		dev_dbg(radio->dev, "IRQ: FR:\n");
 
 		if (core->mode == WL1273_MODE_RX) {
-			r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
-						TUNER_MODE_STOP_SEARCH);
+			r = core->write(core, WL1273_TUNER_MODE_SET,
+					TUNER_MODE_STOP_SEARCH);
 			if (r) {
 				dev_err(radio->dev,
 					"%s: TUNER_MODE_SET fails: %d\n",
@@ -448,7 +308,7 @@ static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
 				goto out;
 			}
 
-			r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &freq);
+			r = core->read(core, WL1273_FREQ_SET, &freq);
 			if (r)
 				goto out;
 
@@ -467,7 +327,7 @@ static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
 			dev_dbg(radio->dev, "%dkHz\n", radio->rx_frequency);
 
 		} else {
-			r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &freq);
+			r = core->read(core, WL1273_CHANL_SET, &freq);
 			if (r)
 				goto out;
 
@@ -477,8 +337,7 @@ static irqreturn_t wl1273_fm_irq_thread_handler(int irq, void *dev_id)
 	}
 
 out:
-	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
-			    radio->irq_flags);
+	core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
 	complete(&radio->busy);
 
 	return IRQ_HANDLED;
@@ -512,7 +371,7 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 	dev_dbg(radio->dev, "%s: freq: %d kHz\n", __func__, freq);
 
 	/* Set the current tx channel */
-	r = wl1273_fm_write_cmd(core, WL1273_CHANL_SET, freq / 10);
+	r = core->write(core, WL1273_CHANL_SET, freq / 10);
 	if (r)
 		return r;
 
@@ -526,7 +385,7 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 	dev_dbg(radio->dev, "WL1273_CHANL_SET: %d\n", r);
 
 	/* Enable the output power */
-	r = wl1273_fm_write_cmd(core, WL1273_POWER_ENB_SET, 1);
+	r = core->write(core, WL1273_POWER_ENB_SET, 1);
 	if (r)
 		return r;
 
@@ -566,20 +425,20 @@ static int wl1273_fm_set_rx_freq(struct wl1273_device *radio, unsigned int freq)
 
 	dev_dbg(radio->dev, "%s: %dkHz\n", __func__, freq);
 
-	wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, radio->irq_flags);
+	core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
 
 	if (radio->band == WL1273_BAND_JAPAN)
 		f = (freq - WL1273_BAND_JAPAN_LOW) / 50;
 	else
 		f = (freq - WL1273_BAND_OTHER_LOW) / 50;
 
-	r = wl1273_fm_write_cmd(core, WL1273_FREQ_SET, f);
+	r = core->write(core, WL1273_FREQ_SET, f);
 	if (r) {
 		dev_err(radio->dev, "FREQ_SET fails\n");
 		goto err;
 	}
 
-	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET, TUNER_MODE_PRESET);
+	r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_PRESET);
 	if (r) {
 		dev_err(radio->dev, "TUNER_MODE_SET fails\n");
 		goto err;
@@ -609,7 +468,7 @@ static int wl1273_fm_get_freq(struct wl1273_device *radio)
 	int r;
 
 	if (core->mode == WL1273_MODE_RX) {
-		r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &f);
+		r = core->read(core, WL1273_FREQ_SET, &f);
 		if (r)
 			return r;
 
@@ -619,7 +478,7 @@ static int wl1273_fm_get_freq(struct wl1273_device *radio)
 		else
 			freq = WL1273_BAND_OTHER_LOW + 50 * f;
 	} else {
-		r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &f);
+		r = core->read(core, WL1273_CHANL_SET, &f);
 		if (r)
 			return r;
 
@@ -670,7 +529,7 @@ static int wl1273_fm_upload_firmware_patch(struct wl1273_device *radio)
 	}
 
 	/* ignore possible error here */
-	wl1273_fm_write_cmd(core, WL1273_RESET, 0);
+	core->write(core, WL1273_RESET, 0);
 
 	dev_dbg(dev, "%s - download OK, r: %d\n", __func__, r);
 out:
@@ -683,14 +542,14 @@ static int wl1273_fm_stop(struct wl1273_device *radio)
 	struct wl1273_core *core = radio->core;
 
 	if (core->mode == WL1273_MODE_RX) {
-		int r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+		int r = core->write(core, WL1273_POWER_SET,
 				    WL1273_POWER_SET_OFF);
 		if (r)
 			dev_err(radio->dev, "%s: POWER_SET fails: %d\n",
 				__func__, r);
 	} else if (core->mode == WL1273_MODE_TX) {
-		int r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
-					    WL1273_PUPD_SET_OFF);
+		int r = core->write(core, WL1273_PUPD_SET,
+				    WL1273_PUPD_SET_OFF);
 		if (r)
 			dev_err(radio->dev,
 				"%s: PUPD_SET fails: %d\n", __func__, r);
@@ -725,11 +584,11 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
 			val |= WL1273_POWER_SET_RDS;
 
 		/* If this fails try again */
-		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
+		r = core->write(core, WL1273_POWER_SET, val);
 		if (r) {
 			msleep(100);
 
-			r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
+			r = core->write(core, WL1273_POWER_SET, val);
 			if (r) {
 				dev_err(dev, "%s: POWER_SET fails\n", __func__);
 				goto fail;
@@ -742,11 +601,10 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
 
 	} else if (new_mode == WL1273_MODE_TX) {
 		/* If this fails try again once */
-		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
-					WL1273_PUPD_SET_ON);
+		r = core->write(core, WL1273_PUPD_SET, WL1273_PUPD_SET_ON);
 		if (r) {
 			msleep(100);
-			r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+			r = core->write(core, WL1273_PUPD_SET,
 					WL1273_PUPD_SET_ON);
 			if (r) {
 				dev_err(dev, "%s: PUPD_SET fails\n", __func__);
@@ -755,9 +613,9 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
 		}
 
 		if (radio->rds_on)
-			r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
+			r = core->write(core, WL1273_RDS_DATA_ENB, 1);
 		else
-			r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
+			r = core->write(core, WL1273_RDS_DATA_ENB, 0);
 	} else {
 		dev_warn(dev, "%s: Illegal mode.\n", __func__);
 	}
@@ -777,14 +635,14 @@ static int wl1273_fm_start(struct wl1273_device *radio, int new_mode)
 			if (radio->rds_on)
 				val |= WL1273_POWER_SET_RDS;
 
-			r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, val);
+			r = core->write(core, WL1273_POWER_SET, val);
 			if (r) {
 				dev_err(dev, "%s: POWER_SET fails\n", __func__);
 				goto fail;
 			}
 		} else if (new_mode == WL1273_MODE_TX) {
-			r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
-						WL1273_PUPD_SET_ON);
+			r = core->write(core, WL1273_PUPD_SET,
+					WL1273_PUPD_SET_ON);
 			if (r) {
 				dev_err(dev, "%s: PUPD_SET fails\n", __func__);
 				goto fail;
@@ -808,10 +666,10 @@ static int wl1273_fm_suspend(struct wl1273_device *radio)
 
 	/* Cannot go from OFF to SUSPENDED */
 	if (core->mode == WL1273_MODE_RX)
-		r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+		r = core->write(core, WL1273_POWER_SET,
 				WL1273_POWER_SET_RETENTION);
 	else if (core->mode == WL1273_MODE_TX)
-		r = wl1273_fm_write_cmd(core, WL1273_PUPD_SET,
+		r = core->write(core, WL1273_PUPD_SET,
 				WL1273_PUPD_SET_RETENTION);
 	else
 		r = -EINVAL;
@@ -852,8 +710,7 @@ static int wl1273_fm_set_mode(struct wl1273_device *radio, int mode)
 		}
 
 		core->mode = mode;
-		r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
-					radio->irq_flags);
+		r = core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
 		if (r) {
 			dev_err(dev, "INT_MASK_SET fails.\n");
 			goto out;
@@ -951,22 +808,21 @@ static int wl1273_fm_set_seek(struct wl1273_device *radio,
 	INIT_COMPLETION(radio->busy);
 	dev_dbg(radio->dev, "%s: BUSY\n", __func__);
 
-	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, radio->irq_flags);
+	r = core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
 	if (r)
 		goto out;
 
 	dev_dbg(radio->dev, "%s\n", __func__);
 
-	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_LVL_SET, level);
+	r = core->write(core, WL1273_SEARCH_LVL_SET, level);
 	if (r)
 		goto out;
 
-	r = wl1273_fm_write_cmd(core, WL1273_SEARCH_DIR_SET, dir);
+	r = core->write(core, WL1273_SEARCH_DIR_SET, dir);
 	if (r)
 		goto out;
 
-	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
-				TUNER_MODE_AUTO_SEEK);
+	r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_AUTO_SEEK);
 	if (r)
 		goto out;
 
@@ -994,8 +850,7 @@ static int wl1273_fm_set_seek(struct wl1273_device *radio,
 	INIT_COMPLETION(radio->busy);
 	dev_dbg(radio->dev, "%s: BUSY\n", __func__);
 
-	r = wl1273_fm_write_cmd(core, WL1273_TUNER_MODE_SET,
-				TUNER_MODE_AUTO_SEEK);
+	r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_AUTO_SEEK);
 	if (r)
 		goto out;
 
@@ -1020,7 +875,7 @@ static unsigned int wl1273_fm_get_tx_ctune(struct wl1273_device *radio)
 	    core->mode == WL1273_MODE_SUSPENDED)
 		return -EPERM;
 
-	r = wl1273_fm_read_reg(core, WL1273_READ_FMANT_TUNE_VALUE, &val);
+	r = core->read(core, WL1273_READ_FMANT_TUNE_VALUE, &val);
 	if (r) {
 		dev_err(dev, "%s: read error: %d\n", __func__, r);
 		goto out;
@@ -1066,7 +921,7 @@ static int wl1273_fm_set_preemphasis(struct wl1273_device *radio,
 		goto out;
 	}
 
-	r = wl1273_fm_write_cmd(core, WL1273_PREMPH_SET, em);
+	r = core->write(core, WL1273_PREMPH_SET, em);
 	if (r)
 		goto out;
 
@@ -1086,7 +941,7 @@ static int wl1273_fm_rds_on(struct wl1273_device *radio)
 	if (radio->rds_on)
 		return 0;
 
-	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET,
+	r = core->write(core, WL1273_POWER_SET,
 			WL1273_POWER_SET_FM | WL1273_POWER_SET_RDS);
 	if (r)
 		goto out;
@@ -1108,7 +963,7 @@ static int wl1273_fm_rds_off(struct wl1273_device *radio)
 
 	radio->irq_flags &= ~WL1273_RDS_EVENT;
 
-	r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET, radio->irq_flags);
+	r = core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
 	if (r)
 		goto out;
 
@@ -1120,7 +975,7 @@ static int wl1273_fm_rds_off(struct wl1273_device *radio)
 
 	dev_dbg(radio->dev, "%s\n", __func__);
 
-	r = wl1273_fm_write_cmd(core, WL1273_POWER_SET, WL1273_POWER_SET_FM);
+	r = core->write(core, WL1273_POWER_SET, WL1273_POWER_SET_FM);
 	if (r)
 		goto out;
 
@@ -1143,14 +998,14 @@ static int wl1273_fm_set_rds(struct wl1273_device *radio, unsigned int new_mode)
 		return -EPERM;
 
 	if (new_mode == WL1273_RDS_RESET) {
-		r = wl1273_fm_write_cmd(core, WL1273_RDS_CNTRL_SET, 1);
+		r = core->write(core, WL1273_RDS_CNTRL_SET, 1);
 		return r;
 	}
 
 	if (core->mode == WL1273_MODE_TX && new_mode == WL1273_RDS_OFF) {
-		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 0);
+		r = core->write(core, WL1273_RDS_DATA_ENB, 0);
 	} else if (core->mode == WL1273_MODE_TX && new_mode == WL1273_RDS_ON) {
-		r = wl1273_fm_write_cmd(core, WL1273_RDS_DATA_ENB, 1);
+		r = core->write(core, WL1273_RDS_DATA_ENB, 1);
 	} else if (core->mode == WL1273_MODE_RX && new_mode == WL1273_RDS_OFF) {
 		r = wl1273_fm_rds_off(radio);
 	} else if (core->mode == WL1273_MODE_RX && new_mode == WL1273_RDS_ON) {
@@ -1171,12 +1026,13 @@ static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
 				    size_t count, loff_t *ppos)
 {
 	struct wl1273_device *radio = video_get_drvdata(video_devdata(file));
+	struct wl1273_core *core = radio->core;
 	u16 val;
 	int r;
 
 	dev_dbg(radio->dev, "%s\n", __func__);
 
-	if (radio->core->mode != WL1273_MODE_TX)
+	if (core->mode != WL1273_MODE_TX)
 		return count;
 
 	if (radio->rds_users == 0) {
@@ -1184,7 +1040,7 @@ static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
 		return 0;
 	}
 
-	if (mutex_lock_interruptible(&radio->core->lock))
+	if (mutex_lock_interruptible(&core->lock))
 		return -EINTR;
 	/*
 	 * Multiple processes can open the device, but only
@@ -1202,7 +1058,7 @@ static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
 	else
 		val = count;
 
-	wl1273_fm_write_cmd(radio->core, WL1273_RDS_CONFIG_DATA_SET, val);
+	core->write(core, WL1273_RDS_CONFIG_DATA_SET, val);
 
 	if (copy_from_user(radio->write_buf + 1, buf, val)) {
 		r = -EFAULT;
@@ -1213,11 +1069,11 @@ static ssize_t wl1273_fm_fops_write(struct file *file, const char __user *buf,
 	dev_dbg(radio->dev, "From user: \"%s\"\n", radio->write_buf);
 
 	radio->write_buf[0] = WL1273_RDS_DATA_SET;
-	wl1273_fm_write_data(radio->core, radio->write_buf, val + 1);
+	core->write_data(core, radio->write_buf, val + 1);
 
 	r = val;
 out:
-	mutex_unlock(&radio->core->lock);
+	mutex_unlock(&core->lock);
 
 	return r;
 }
@@ -1263,8 +1119,8 @@ static int wl1273_fm_fops_open(struct file *file)
 
 		radio->irq_flags |= WL1273_RDS_EVENT;
 
-		r = wl1273_fm_write_cmd(core, WL1273_INT_MASK_SET,
-					radio->irq_flags);
+		r = core->write(core, WL1273_INT_MASK_SET,
+				radio->irq_flags);
 		if (r) {
 			mutex_unlock(&core->lock);
 			goto out;
@@ -1295,9 +1151,9 @@ static int wl1273_fm_fops_release(struct file *file)
 			radio->irq_flags &= ~WL1273_RDS_EVENT;
 
 			if (core->mode == WL1273_MODE_RX) {
-				r = wl1273_fm_write_cmd(core,
-							WL1273_INT_MASK_SET,
-							radio->irq_flags);
+				r = core->write(core,
+						WL1273_INT_MASK_SET,
+						radio->irq_flags);
 				if (r) {
 					mutex_unlock(&core->lock);
 					goto out;
@@ -1324,7 +1180,7 @@ static ssize_t wl1273_fm_fops_read(struct file *file, char __user *buf,
 
 	dev_dbg(radio->dev, "%s\n", __func__);
 
-	if (radio->core->mode != WL1273_MODE_RX)
+	if (core->mode != WL1273_MODE_RX)
 		return 0;
 
 	if (radio->rds_users == 0) {
@@ -1345,7 +1201,7 @@ static ssize_t wl1273_fm_fops_read(struct file *file, char __user *buf,
 	}
 	radio->owner = file;
 
-	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+	r = core->read(core, WL1273_RDS_SYNC_GET, &val);
 	if (r) {
 		dev_err(radio->dev, "%s: Get RDS_SYNC fails.\n", __func__);
 		goto out;
@@ -1466,23 +1322,24 @@ static int wl1273_fm_vidioc_s_input(struct file *file, void *priv,
  */
 static int wl1273_fm_set_tx_power(struct wl1273_device *radio, u16 power)
 {
+	struct wl1273_core *core = radio->core;
 	int r;
 
-	if (radio->core->mode == WL1273_MODE_OFF ||
-	    radio->core->mode == WL1273_MODE_SUSPENDED)
+	if (core->mode == WL1273_MODE_OFF ||
+	    core->mode == WL1273_MODE_SUSPENDED)
 		return -EPERM;
 
-	mutex_lock(&radio->core->lock);
+	mutex_lock(&core->lock);
 
 	/* Convert the dBuV value to chip presentation */
-	r = wl1273_fm_write_cmd(radio->core, WL1273_POWER_LEV_SET, 122 - power);
+	r = core->write(core, WL1273_POWER_LEV_SET, 122 - power);
 	if (r)
 		goto out;
 
 	radio->tx_power = power;
 
 out:
-	mutex_unlock(&radio->core->lock);
+	mutex_unlock(&core->lock);
 	return r;
 }
 
@@ -1493,23 +1350,24 @@ out:
 static int wl1273_fm_tx_set_spacing(struct wl1273_device *radio,
 				    unsigned int spacing)
 {
+	struct wl1273_core *core = radio->core;
 	int r;
 
 	if (spacing == 0) {
-		r = wl1273_fm_write_cmd(radio->core, WL1273_SCAN_SPACING_SET,
-					WL1273_SPACING_100kHz);
+		r = core->write(core, WL1273_SCAN_SPACING_SET,
+				WL1273_SPACING_100kHz);
 		radio->spacing = 100;
 	} else if (spacing - 50000 < 25000) {
-		r = wl1273_fm_write_cmd(radio->core, WL1273_SCAN_SPACING_SET,
-					WL1273_SPACING_50kHz);
+		r = core->write(core, WL1273_SCAN_SPACING_SET,
+				WL1273_SPACING_50kHz);
 		radio->spacing = 50;
 	} else if (spacing - 100000 < 50000) {
-		r = wl1273_fm_write_cmd(radio->core, WL1273_SCAN_SPACING_SET,
-					WL1273_SPACING_100kHz);
+		r = core->write(core, WL1273_SCAN_SPACING_SET,
+				WL1273_SPACING_100kHz);
 		radio->spacing = 100;
 	} else {
-		r = wl1273_fm_write_cmd(radio->core, WL1273_SCAN_SPACING_SET,
-					WL1273_SPACING_200kHz);
+		r = core->write(core, WL1273_SCAN_SPACING_SET,
+				WL1273_SPACING_200kHz);
 		radio->spacing = 200;
 	}
 
@@ -1567,17 +1425,17 @@ static int wl1273_fm_vidioc_s_ctrl(struct v4l2_ctrl *ctrl)
 			return -EINTR;
 
 		if (core->mode == WL1273_MODE_RX && ctrl->val)
-			r = wl1273_fm_write_cmd(core,
-						WL1273_MUTE_STATUS_SET,
-						WL1273_MUTE_HARD_LEFT |
-						WL1273_MUTE_HARD_RIGHT);
+			r = core->write(core,
+					WL1273_MUTE_STATUS_SET,
+					WL1273_MUTE_HARD_LEFT |
+					WL1273_MUTE_HARD_RIGHT);
 		else if (core->mode == WL1273_MODE_RX)
-			r = wl1273_fm_write_cmd(core,
-						WL1273_MUTE_STATUS_SET, 0x0);
+			r = core->write(core,
+					WL1273_MUTE_STATUS_SET, 0x0);
 		else if (core->mode == WL1273_MODE_TX && ctrl->val)
-			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 1);
+			r = core->write(core, WL1273_MUTE, 1);
 		else if (core->mode == WL1273_MODE_TX)
-			r = wl1273_fm_write_cmd(core, WL1273_MUTE, 0);
+			r = core->write(core, WL1273_MUTE, 0);
 
 		mutex_unlock(&core->lock);
 		break;
@@ -1672,7 +1530,7 @@ static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
 	if (mutex_lock_interruptible(&core->lock))
 		return -EINTR;
 
-	r = wl1273_fm_read_reg(core, WL1273_STEREO_GET, &val);
+	r = core->read(core, WL1273_STEREO_GET, &val);
 	if (r)
 		goto out;
 
@@ -1681,7 +1539,7 @@ static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
 	else
 		tuner->rxsubchans = V4L2_TUNER_SUB_MONO;
 
-	r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &val);
+	r = core->read(core, WL1273_RSSI_LVL_GET, &val);
 	if (r)
 		goto out;
 
@@ -1690,7 +1548,7 @@ static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
 
 	tuner->afc = 0;
 
-	r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+	r = core->read(core, WL1273_RDS_SYNC_GET, &val);
 	if (r)
 		goto out;
 
@@ -1736,8 +1594,7 @@ static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
 		dev_warn(radio->dev, "%s: RDS fails: %d\n", __func__, r);
 
 	if (tuner->audmode == V4L2_TUNER_MODE_MONO) {
-		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
-					WL1273_RX_MONO);
+		r = core->write(core, WL1273_MOST_MODE_SET, WL1273_RX_MONO);
 		if (r < 0) {
 			dev_warn(radio->dev, "%s: MOST_MODE fails: %d\n",
 				 __func__, r);
@@ -1745,8 +1602,7 @@ static int wl1273_fm_vidioc_s_tuner(struct file *file, void *priv,
 		}
 		radio->stereo = false;
 	} else if (tuner->audmode == V4L2_TUNER_MODE_STEREO) {
-		r = wl1273_fm_write_cmd(core, WL1273_MOST_MODE_SET,
-					WL1273_RX_STEREO);
+		r = core->write(core, WL1273_MOST_MODE_SET, WL1273_RX_STEREO);
 		if (r < 0) {
 			dev_warn(radio->dev, "%s: MOST_MODE fails: %d\n",
 				 __func__, r);
@@ -1885,10 +1741,10 @@ static int wl1273_fm_vidioc_s_modulator(struct file *file, void *priv,
 		r = wl1273_fm_set_rds(radio, WL1273_RDS_OFF);
 
 	if (modulator->txsubchans & V4L2_TUNER_SUB_MONO)
-		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET, WL1273_TX_MONO);
+		r = core->write(core, WL1273_MONO_SET, WL1273_TX_MONO);
 	else
-		r = wl1273_fm_write_cmd(core, WL1273_MONO_SET,
-					WL1273_RX_STEREO);
+		r = core->write(core, WL1273_MONO_SET,
+				WL1273_RX_STEREO);
 	if (r < 0)
 		dev_warn(radio->dev, WL1273_FM_DRIVER_NAME
 			 "MONO_SET fails: %d\n", r);
@@ -1923,7 +1779,7 @@ static int wl1273_fm_vidioc_g_modulator(struct file *file, void *priv,
 	if (mutex_lock_interruptible(&core->lock))
 		return -EINTR;
 
-	r = wl1273_fm_read_reg(core, WL1273_MONO_SET, &val);
+	r = core->read(core, WL1273_MONO_SET, &val);
 	if (r)
 		goto out;
 
@@ -1960,38 +1816,38 @@ static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
 		return 0;
 	}
 
-	r = wl1273_fm_read_reg(core, WL1273_ASIC_ID_GET, &val);
+	r = core->read(core, WL1273_ASIC_ID_GET, &val);
 	if (r)
 		dev_err(dev, "%s: Get ASIC_ID fails.\n", __func__);
 	else
 		dev_info(dev, "ASIC_ID: 0x%04x\n", val);
 
-	r = wl1273_fm_read_reg(core, WL1273_ASIC_VER_GET, &val);
+	r = core->read(core, WL1273_ASIC_VER_GET, &val);
 	if (r)
 		dev_err(dev, "%s: Get ASIC_VER fails.\n", __func__);
 	else
 		dev_info(dev, "ASIC Version: 0x%04x\n", val);
 
-	r = wl1273_fm_read_reg(core, WL1273_FIRM_VER_GET, &val);
+	r = core->read(core, WL1273_FIRM_VER_GET, &val);
 	if (r)
 		dev_err(dev, "%s: Get FIRM_VER fails.\n", __func__);
 	else
 		dev_info(dev, "FW version: %d(0x%04x)\n", val, val);
 
-	r = wl1273_fm_read_reg(core, WL1273_BAND_SET, &val);
+	r = core->read(core, WL1273_BAND_SET, &val);
 	if (r)
 		dev_err(dev, "%s: Get BAND fails.\n", __func__);
 	else
 		dev_info(dev, "BAND: %d\n", val);
 
 	if (core->mode == WL1273_MODE_TX) {
-		r = wl1273_fm_read_reg(core, WL1273_PUPD_SET, &val);
+		r = core->read(core, WL1273_PUPD_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get PUPD fails.\n", __func__);
 		else
 			dev_info(dev, "PUPD: 0x%04x\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_CHANL_SET, &val);
+		r = core->read(core, WL1273_CHANL_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get CHANL fails.\n", __func__);
 		else
@@ -1999,13 +1855,13 @@ static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
 	} else if (core->mode == WL1273_MODE_RX) {
 		int bf = radio->rangelow;
 
-		r = wl1273_fm_read_reg(core, WL1273_FREQ_SET, &val);
+		r = core->read(core, WL1273_FREQ_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get FREQ fails.\n", __func__);
 		else
 			dev_info(dev, "RX Frequency: %dkHz\n", bf + val*50);
 
-		r = wl1273_fm_read_reg(core, WL1273_MOST_MODE_SET, &val);
+		r = core->read(core, WL1273_MOST_MODE_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get MOST_MODE fails.\n",
 				__func__);
@@ -2016,7 +1872,7 @@ static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
 		else
 			dev_info(dev, "MOST_MODE: Unexpected value: %d\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_MOST_BLEND_SET, &val);
+		r = core->read(core, WL1273_MOST_BLEND_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get MOST_BLEND fails.\n", __func__);
 		else if (val == 0)
@@ -2027,7 +1883,7 @@ static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
 		else
 			dev_info(dev, "MOST_BLEND: Unexpected val: %d\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_STEREO_GET, &val);
+		r = core->read(core, WL1273_STEREO_GET, &val);
 		if (r)
 			dev_err(dev, "%s: Get STEREO fails.\n", __func__);
 		else if (val == 0)
@@ -2037,25 +1893,25 @@ static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
 		else
 			dev_info(dev, "STEREO: Unexpected value: %d\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_RSSI_LVL_GET, &val);
+		r = core->read(core, WL1273_RSSI_LVL_GET, &val);
 		if (r)
 			dev_err(dev, "%s: Get RSSI_LVL fails.\n", __func__);
 		else
 			dev_info(dev, "RX signal strength: %d\n", (s16) val);
 
-		r = wl1273_fm_read_reg(core, WL1273_POWER_SET, &val);
+		r = core->read(core, WL1273_POWER_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get POWER fails.\n", __func__);
 		else
 			dev_info(dev, "POWER: 0x%04x\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_INT_MASK_SET, &val);
+		r = core->read(core, WL1273_INT_MASK_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get INT_MASK fails.\n", __func__);
 		else
 			dev_info(dev, "INT_MASK: 0x%04x\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_RDS_SYNC_GET, &val);
+		r = core->read(core, WL1273_RDS_SYNC_GET, &val);
 		if (r)
 			dev_err(dev, "%s: Get RDS_SYNC fails.\n",
 				__func__);
@@ -2067,14 +1923,14 @@ static int wl1273_fm_vidioc_log_status(struct file *file, void *priv)
 		else
 			dev_info(dev, "RDS_SYNC: Unexpected value: %d\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_I2S_MODE_CONFIG_SET, &val);
+		r = core->read(core, WL1273_I2S_MODE_CONFIG_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get I2S_MODE_CONFIG fails.\n",
 				__func__);
 		else
 			dev_info(dev, "I2S_MODE_CONFIG: 0x%04x\n", val);
 
-		r = wl1273_fm_read_reg(core, WL1273_VOLUME_SET, &val);
+		r = core->read(core, WL1273_VOLUME_SET, &val);
 		if (r)
 			dev_err(dev, "%s: Get VOLUME fails.\n", __func__);
 		else
@@ -2184,10 +2040,6 @@ static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
 	radio->stereo = true;
 	radio->bus_type = "I2C";
 
-	radio->core->write = wl1273_fm_write_cmd;
-	radio->core->set_audio = wl1273_fm_set_audio;
-	radio->core->set_volume = wl1273_fm_set_volume;
-
 	if (radio->core->pdata->request_resources) {
 		r = radio->core->pdata->request_resources(radio->core->client);
 		if (r) {
-- 
1.6.1.3

