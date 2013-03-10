Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46699 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab3CJCEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:39 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: =?y?q?=5BREVIEW=20PATCH=2013/41=5D=20af9035=3A=20IT9135=20dual=20tuner=20related=20changes?=
Date: Sun, 10 Mar 2013 04:03:05 +0200
Message-Id: <1362881013-5271-13-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now it supports IT9135 based dual tuner devices.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 201 +++++++++++++++++-----------------
 drivers/media/usb/dvb-usb-v2/af9035.h |   3 +-
 2 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 0b92277..1db9c76 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -320,8 +320,10 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 			*name = AF9035_FIRMWARE_IT9135_V2;
 		else
 			*name = AF9035_FIRMWARE_IT9135_V1;
+		state->eeprom_addr = EEPROM_BASE_IT9135;
 	} else {
 		*name = AF9035_FIRMWARE_AF9035;
+		state->eeprom_addr = EEPROM_BASE_AF9035;
 	}
 
 	ret = af9035_ctrl_msg(d, &req);
@@ -347,63 +349,14 @@ static int af9035_download_firmware_af9035(struct dvb_usb_device *d,
 {
 	int ret, i, j, len;
 	u8 wbuf[1];
-	u8 rbuf[4];
 	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
 	struct usb_req req_fw_dl = { CMD_FW_DL, 0, 0, wbuf, 0, NULL };
-	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf } ;
-	u8 hdr_core, tmp;
+	u8 hdr_core;
 	u16 hdr_addr, hdr_data_len, hdr_checksum;
 	#define MAX_DATA 58
 	#define HDR_SIZE 7
 
 	/*
-	 * In case of dual tuner configuration we need to do some extra
-	 * initialization in order to download firmware to slave demod too,
-	 * which is done by master demod.
-	 * Master feeds also clock and controls power via GPIO.
-	 */
-	ret = af9035_rd_reg(d, EEPROM_BASE_AF9035 + EEPROM_DUAL_MODE, &tmp);
-	if (ret < 0)
-		goto err;
-
-	if (tmp) {
-		/* configure gpioh1, reset & power slave demod */
-		ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
-
-		ret = af9035_wr_reg_mask(d, 0x00d8b1, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
-
-		ret = af9035_wr_reg_mask(d, 0x00d8af, 0x00, 0x01);
-		if (ret < 0)
-			goto err;
-
-		usleep_range(10000, 50000);
-
-		ret = af9035_wr_reg_mask(d, 0x00d8af, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
-
-		/* tell the slave I2C address */
-		ret = af9035_rd_reg(d,
-				EEPROM_BASE_AF9035 + EEPROM_2ND_DEMOD_ADDR,
-				&tmp);
-		if (ret < 0)
-			goto err;
-
-		ret = af9035_wr_reg(d, 0x00417f, tmp);
-		if (ret < 0)
-			goto err;
-
-		/* enable clock out */
-		ret = af9035_wr_reg_mask(d, 0x00d81a, 0x01, 0x01);
-		if (ret < 0)
-			goto err;
-	}
-
-	/*
 	 * Thanks to Daniel Glöckner <daniel-gl@gmx.net> about that info!
 	 *
 	 * byte 0: MCS 51 core
@@ -469,28 +422,6 @@ static int af9035_download_firmware_af9035(struct dvb_usb_device *d,
 	if (i)
 		dev_warn(&d->udev->dev, "%s: bad firmware\n", KBUILD_MODNAME);
 
-	/* firmware loaded, request boot */
-	req.cmd = CMD_FW_BOOT;
-	ret = af9035_ctrl_msg(d, &req);
-	if (ret < 0)
-		goto err;
-
-	/* ensure firmware starts */
-	wbuf[0] = 1;
-	ret = af9035_ctrl_msg(d, &req_fw_ver);
-	if (ret < 0)
-		goto err;
-
-	if (!(rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])) {
-		dev_err(&d->udev->dev, "%s: firmware did not run\n",
-				KBUILD_MODNAME);
-		ret = -ENODEV;
-		goto err;
-	}
-
-	dev_info(&d->udev->dev, "%s: firmware version=%d.%d.%d.%d",
-			KBUILD_MODNAME, rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
-
 	return 0;
 
 err:
@@ -503,11 +434,7 @@ static int af9035_download_firmware_it9135(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
 	int ret, i, i_prev;
-	u8 wbuf[1];
-	u8 rbuf[4];
-	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
 	struct usb_req req_fw_dl = { CMD_FW_SCATTER_WR, 0, 0, NULL, 0, NULL };
-	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf } ;
 	#define HDR_SIZE 7
 
 	/*
@@ -522,7 +449,6 @@ static int af9035_download_firmware_it9135(struct dvb_usb_device *d,
 	 * 5: addr LSB
 	 * 6: count of data bytes ?
 	 */
-
 	for (i = HDR_SIZE, i_prev = 0; i <= fw->size; i++) {
 		if (i == fw->size ||
 				(fw->data[i + 0] == 0x03 &&
@@ -541,6 +467,86 @@ static int af9035_download_firmware_it9135(struct dvb_usb_device *d,
 		}
 	}
 
+	return 0;
+
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
+static int af9035_download_firmware(struct dvb_usb_device *d,
+		const struct firmware *fw)
+{
+	struct state *state = d_to_priv(d);
+	int ret;
+	u8 wbuf[1];
+	u8 rbuf[4];
+	u8 tmp;
+	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
+	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf } ;
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	/*
+	 * In case of dual tuner configuration we need to do some extra
+	 * initialization in order to download firmware to slave demod too,
+	 * which is done by master demod.
+	 * Master feeds also clock and controls power via GPIO.
+	 */
+	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_DUAL_MODE, &tmp);
+	if (ret < 0)
+		goto err;
+
+	if (tmp) {
+		/* configure gpioh1, reset & power slave demod */
+		ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg_mask(d, 0x00d8b1, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg_mask(d, 0x00d8af, 0x00, 0x01);
+		if (ret < 0)
+			goto err;
+
+		usleep_range(10000, 50000);
+
+		ret = af9035_wr_reg_mask(d, 0x00d8af, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		/* tell the slave I2C address */
+		ret = af9035_rd_reg(d,
+				state->eeprom_addr + EEPROM_2ND_DEMOD_ADDR,
+				&tmp);
+		if (ret < 0)
+			goto err;
+
+		if (state->chip_type == 0x9135) {
+			ret = af9035_wr_reg(d, 0x004bfb, tmp);
+			if (ret < 0)
+				goto err;
+		} else {
+			ret = af9035_wr_reg(d, 0x00417f, tmp);
+			if (ret < 0)
+				goto err;
+
+			/* enable clock out */
+			ret = af9035_wr_reg_mask(d, 0x00d81a, 0x01, 0x01);
+			if (ret < 0)
+				goto err;
+		}
+	}
+
+	if (state->chip_type == 0x9135)
+		ret = af9035_download_firmware_it9135(d, fw);
+	else
+		ret = af9035_download_firmware_af9035(d, fw);
+	if (ret < 0)
+		goto err;
+
 	/* firmware loaded, request boot */
 	req.cmd = CMD_FW_BOOT;
 	ret = af9035_ctrl_msg(d, &req);
@@ -571,17 +577,6 @@ err:
 	return ret;
 }
 
-static int af9035_download_firmware(struct dvb_usb_device *d,
-		const struct firmware *fw)
-{
-	struct state *state = d_to_priv(d);
-
-	if (state->chip_type == 0x9135)
-		return af9035_download_firmware_it9135(d, fw);
-	else
-		return af9035_download_firmware_af9035(d, fw);
-}
-
 static int af9035_read_config(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
@@ -592,14 +587,17 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	/* demod I2C "address" */
 	state->af9033_config[0].i2c_addr = 0x38;
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
+	state->af9033_config[1].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 
 	/* eeprom memory mapped location */
 	if (state->chip_type == 0x9135) {
 		if (state->chip_version == 0x02) {
 			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
+			state->af9033_config[1].tuner = AF9033_TUNER_IT9135_60;
 			tmp16 = 0x00461d;
 		} else {
 			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
+			state->af9033_config[1].tuner = AF9033_TUNER_IT9135_38;
 			tmp16 = 0x00461b;
 		}
 
@@ -678,8 +676,14 @@ static int af9035_read_config(struct dvb_usb_device *d)
 
 		/* disable dual mode if driver does not support it */
 		if (i == 1)
-			switch (tmp) {
+			switch (state->af9033_config[i].tuner) {
 			case AF9033_TUNER_FC0012:
+			case AF9033_TUNER_IT9135_38:
+			case AF9033_TUNER_IT9135_51:
+			case AF9033_TUNER_IT9135_52:
+			case AF9033_TUNER_IT9135_60:
+			case AF9033_TUNER_IT9135_61:
+			case AF9033_TUNER_IT9135_62:
 				break;
 			default:
 				state->dual_mode = false;
@@ -891,6 +895,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	if (!state->af9033_config[adap->id].tuner) {
 		/* unsupported tuner */
@@ -901,15 +906,6 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	if (adap->id == 0) {
 		state->af9033_config[0].ts_mode = AF9033_TS_MODE_USB;
 		state->af9033_config[1].ts_mode = AF9033_TS_MODE_SERIAL;
-
-		ret = af9035_wr_reg(d, 0x00417f,
-				state->af9033_config[1].i2c_addr);
-		if (ret < 0)
-			goto err;
-
-		ret = af9035_wr_reg(d, 0x00d81a, state->dual_mode);
-		if (ret < 0)
-			goto err;
 	}
 
 	/* attach demodulator */
@@ -1004,6 +1000,8 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_frontend *fe;
 	struct i2c_msg msg[1];
 	u8 tuner_addr;
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
 	/*
 	 * XXX: Hack used in that function: we abuse unused I2C address bit [7]
 	 * to carry info about used I2C bus for dual tuner configuration.
@@ -1165,10 +1163,11 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9033_TUNER_IT9135_60:
 	case AF9033_TUNER_IT9135_61:
 	case AF9033_TUNER_IT9135_62:
-		/* attach tuner */
 		af9035_it913x_config.tuner_id_0 = state->af9033_config[0].tuner;
-		fe = dvb_attach(it913x_attach, adap->fe[0],
-				&d->i2c_adap, 0x38, &af9035_it913x_config);
+		/* attach tuner */
+		fe = dvb_attach(it913x_attach, adap->fe[0], &d->i2c_adap,
+				state->af9033_config[adap->id].i2c_addr,
+				&af9035_it913x_config);
 		break;
 	default:
 		fe = NULL;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 4d918ee..59843c7 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -54,10 +54,11 @@ struct usb_req {
 
 struct state {
 	u8 seq; /* packet sequence number */
-	bool dual_mode;
 	u8 prechip_version;
 	u8 chip_version;
 	u16 chip_type;
+	bool dual_mode;
+	u16 eeprom_addr;
 	struct af9033_config af9033_config[2];
 };
 
-- 
1.7.11.7

