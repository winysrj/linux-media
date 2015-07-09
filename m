Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59043 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/12] tda10071: remove legacy media attach
Date: Thu,  9 Jul 2015 07:06:26 +0300
Message-Id: <1436414792-9716-6-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All users are now using I2C binding and old attach could be removed.
Use I2C client for proper logging at the same.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c      | 275 ++++++++++------------------
 drivers/media/dvb-frontends/tda10071.h      |  63 +------
 drivers/media/dvb-frontends/tda10071_priv.h |   8 +-
 3 files changed, 108 insertions(+), 238 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index f6dc630..cc65285 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -29,11 +29,12 @@ static struct dvb_frontend_ops tda10071_ops;
 static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	int len)
 {
+	struct i2c_client *client = priv->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg.demod_i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -41,22 +42,20 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c wr reg=%04x: len=%d is too big!\n",
-				KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
+				reg, len);
 		return -EINVAL;
 	}
 
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -66,16 +65,17 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	int len)
 {
+	struct i2c_client *client = priv->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg.demod_i2c_addr,
+			.addr = client->addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg.demod_i2c_addr,
+			.addr = client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = buf,
@@ -83,20 +83,18 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	};
 
 	if (len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c wr reg=%04x: len=%d is too big!\n",
-				KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
+				reg, len);
 		return -EINVAL;
 	}
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(client->adapter, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -162,6 +160,7 @@ static int tda10071_rd_reg_mask(struct tda10071_priv *priv,
 static int tda10071_cmd_execute(struct tda10071_priv *priv,
 	struct tda10071_cmd *cmd)
 {
+	struct i2c_client *client = priv->client;
 	int ret, i;
 	u8 tmp;
 
@@ -189,7 +188,7 @@ static int tda10071_cmd_execute(struct tda10071_priv *priv,
 		usleep_range(200, 5000);
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&client->dev, "loop=%d\n", i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -198,7 +197,7 @@ static int tda10071_cmd_execute(struct tda10071_priv *priv,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -206,6 +205,7 @@ static int tda10071_set_tone(struct dvb_frontend *fe,
 	enum fe_sec_tone_mode fe_sec_tone_mode)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret;
 	u8 tone;
@@ -215,8 +215,7 @@ static int tda10071_set_tone(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: tone_mode=%d\n", __func__,
-			fe_sec_tone_mode);
+	dev_dbg(&client->dev, "tone_mode=%d\n", fe_sec_tone_mode);
 
 	switch (fe_sec_tone_mode) {
 	case SEC_TONE_ON:
@@ -226,8 +225,7 @@ static int tda10071_set_tone(struct dvb_frontend *fe,
 		tone = 0;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_tone_mode\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid fe_sec_tone_mode\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -244,7 +242,7 @@ static int tda10071_set_tone(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -252,6 +250,7 @@ static int tda10071_set_voltage(struct dvb_frontend *fe,
 	enum fe_sec_voltage fe_sec_voltage)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret;
 	u8 voltage;
@@ -261,7 +260,7 @@ static int tda10071_set_voltage(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: voltage=%d\n", __func__, fe_sec_voltage);
+	dev_dbg(&client->dev, "voltage=%d\n", fe_sec_voltage);
 
 	switch (fe_sec_voltage) {
 	case SEC_VOLTAGE_13:
@@ -274,8 +273,7 @@ static int tda10071_set_voltage(struct dvb_frontend *fe,
 		voltage = 0;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_voltage\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid fe_sec_voltage\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -290,7 +288,7 @@ static int tda10071_set_voltage(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -298,6 +296,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	struct dvb_diseqc_master_cmd *diseqc_cmd)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	u8 tmp;
@@ -307,8 +306,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: msg_len=%d\n", __func__,
-			diseqc_cmd->msg_len);
+	dev_dbg(&client->dev, "msg_len=%d\n", diseqc_cmd->msg_len);
 
 	if (diseqc_cmd->msg_len < 3 || diseqc_cmd->msg_len > 6) {
 		ret = -EINVAL;
@@ -324,7 +322,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 		usleep_range(10000, 20000);
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&client->dev, "loop=%d\n", i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -350,7 +348,7 @@ static int tda10071_diseqc_send_master_cmd(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -358,6 +356,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 	struct dvb_diseqc_slave_reply *reply)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	u8 tmp;
@@ -367,7 +366,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	/* wait LNB RX */
 	for (i = 500, tmp = 0; i && !tmp; i--) {
@@ -378,7 +377,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 		usleep_range(10000, 20000);
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&client->dev, "loop=%d\n", i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -408,7 +407,7 @@ static int tda10071_diseqc_recv_slave_reply(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -416,6 +415,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 	enum fe_sec_mini_cmd fe_sec_mini_cmd)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	u8 tmp, burst;
@@ -425,8 +425,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 		goto error;
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: fe_sec_mini_cmd=%d\n", __func__,
-			fe_sec_mini_cmd);
+	dev_dbg(&client->dev, "fe_sec_mini_cmd=%d\n", fe_sec_mini_cmd);
 
 	switch (fe_sec_mini_cmd) {
 	case SEC_MINI_A:
@@ -436,8 +435,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 		burst = 1;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid fe_sec_mini_cmd\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid fe_sec_mini_cmd\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -451,7 +449,7 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 		usleep_range(10000, 20000);
 	}
 
-	dev_dbg(&priv->i2c->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&client->dev, "loop=%d\n", i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -472,13 +470,14 @@ static int tda10071_diseqc_send_burst(struct dvb_frontend *fe,
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	int ret;
 	u8 tmp;
 
@@ -505,13 +504,14 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	int ret;
 	u8 buf[2];
 
@@ -530,13 +530,14 @@ static int tda10071_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret;
 	u8 tmp;
@@ -569,13 +570,14 @@ static int tda10071_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret, i, len;
 	u8 tmp, reg, buf[8];
@@ -607,8 +609,7 @@ static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 		goto error;
 
 	if (priv->meas_count[i] == tmp) {
-		dev_dbg(&priv->i2c->dev, "%s: meas not ready=%02x\n", __func__,
-				tmp);
+		dev_dbg(&client->dev, "meas not ready=%02x\n", tmp);
 		*ber = priv->ber;
 		return 0;
 	} else {
@@ -637,13 +638,14 @@ static int tda10071_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	int ret = 0;
 
 	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
@@ -657,24 +659,24 @@ static int tda10071_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_set_frontend(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 mode, rolloff, pilot, inversion, div;
 	enum fe_modulation modulation;
 
-	dev_dbg(&priv->i2c->dev,
-			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
-			__func__, c->delivery_system, c->modulation,
-			c->frequency, c->symbol_rate, c->inversion, c->pilot,
-			c->rolloff);
+	dev_dbg(&client->dev,
+		"delivery_system=%d modulation=%d frequency=%u symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
+		c->delivery_system, c->modulation, c->frequency, c->symbol_rate,
+		c->inversion, c->pilot, c->rolloff);
 
 	priv->delivery_system = SYS_UNDEFINED;
 
@@ -696,7 +698,7 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 		inversion = 3;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid inversion\n", __func__);
+		dev_dbg(&client->dev, "invalid inversion\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -722,8 +724,7 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 			break;
 		case ROLLOFF_AUTO:
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid rolloff\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid rolloff\n");
 			ret = -EINVAL;
 			goto error;
 		}
@@ -739,15 +740,13 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 			pilot = 2;
 			break;
 		default:
-			dev_dbg(&priv->i2c->dev, "%s: invalid pilot\n",
-					__func__);
+			dev_dbg(&client->dev, "invalid pilot\n");
 			ret = -EINVAL;
 			goto error;
 		}
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid delivery_system\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid delivery_system\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -757,15 +756,13 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 			modulation == TDA10071_MODCOD[i].modulation &&
 			c->fec_inner == TDA10071_MODCOD[i].fec) {
 			mode = TDA10071_MODCOD[i].val;
-			dev_dbg(&priv->i2c->dev, "%s: mode found=%02x\n",
-					__func__, mode);
+			dev_dbg(&client->dev, "mode found=%02x\n", mode);
 			break;
 		}
 	}
 
 	if (mode == 0xff) {
-		dev_dbg(&priv->i2c->dev, "%s: invalid parameter combination\n",
-				__func__);
+		dev_dbg(&client->dev, "invalid parameter combination\n");
 		ret = -EINVAL;
 		goto error;
 	}
@@ -807,13 +804,14 @@ static int tda10071_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_get_frontend(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u8 buf[5], tmp;
@@ -864,13 +862,14 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_init(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret, i, len, remaining, fw_size;
 	const struct firmware *fw;
@@ -890,7 +889,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 	};
 	struct tda10071_reg_val_mask tab2[] = {
 		{ 0xf1, 0x70, 0xff },
-		{ 0x88, priv->cfg.pll_multiplier, 0x3f },
+		{ 0x88, priv->pll_multiplier, 0x3f },
 		{ 0x89, 0x00, 0x10 },
 		{ 0x89, 0x10, 0x10 },
 		{ 0xc0, 0x01, 0x01 },
@@ -955,11 +954,11 @@ static int tda10071_init(struct dvb_frontend *fe)
 		/* cold state - try to download firmware */
 
 		/* request the firmware, this will block and timeout */
-		ret = request_firmware(&fw, fw_file, priv->i2c->dev.parent);
+		ret = request_firmware(&fw, fw_file, &client->dev);
 		if (ret) {
-			dev_err(&priv->i2c->dev,
-					"%s: did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)\n",
-					KBUILD_MODNAME, fw_file, ret);
+			dev_err(&client->dev,
+				"did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)\n",
+				fw_file, ret);
 			goto error;
 		}
 
@@ -988,28 +987,26 @@ static int tda10071_init(struct dvb_frontend *fe)
 		if (ret)
 			goto error_release_firmware;
 
-		dev_info(&priv->i2c->dev,
-				"%s: found a '%s' in cold state, will try to load a firmware\n",
-				KBUILD_MODNAME, tda10071_ops.info.name);
-		dev_info(&priv->i2c->dev,
-				"%s: downloading firmware from file '%s'\n",
-				KBUILD_MODNAME, fw_file);
+		dev_info(&client->dev,
+			 "found a '%s' in cold state, will try to load a firmware\n",
+			 tda10071_ops.info.name);
+		dev_info(&client->dev, "downloading firmware from file '%s'\n",
+			 fw_file);
 
 		/* do not download last byte */
 		fw_size = fw->size - 1;
 
 		for (remaining = fw_size; remaining > 0;
-			remaining -= (priv->cfg.i2c_wr_max - 1)) {
+			remaining -= (priv->i2c_wr_max - 1)) {
 			len = remaining;
-			if (len > (priv->cfg.i2c_wr_max - 1))
-				len = (priv->cfg.i2c_wr_max - 1);
+			if (len > (priv->i2c_wr_max - 1))
+				len = (priv->i2c_wr_max - 1);
 
 			ret = tda10071_wr_regs(priv, 0xfa,
 				(u8 *) &fw->data[fw_size - remaining], len);
 			if (ret) {
-				dev_err(&priv->i2c->dev,
-						"%s: firmware download failed=%d\n",
-						KBUILD_MODNAME, ret);
+				dev_err(&client->dev,
+					"firmware download failed=%d\n", ret);
 				goto error_release_firmware;
 			}
 		}
@@ -1032,8 +1029,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 			goto error;
 
 		if (tmp) {
-			dev_info(&priv->i2c->dev, "%s: firmware did not run\n",
-					KBUILD_MODNAME);
+			dev_info(&client->dev, "firmware did not run\n");
 			ret = -EFAULT;
 			goto error;
 		} else {
@@ -1050,30 +1046,30 @@ static int tda10071_init(struct dvb_frontend *fe)
 		if (ret)
 			goto error;
 
-		dev_info(&priv->i2c->dev, "%s: firmware version %d.%d.%d.%d\n",
-				KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3]);
-		dev_info(&priv->i2c->dev, "%s: found a '%s' in warm state\n",
-				KBUILD_MODNAME, tda10071_ops.info.name);
+		dev_info(&client->dev, "firmware version %d.%d.%d.%d\n",
+			 buf[0], buf[1], buf[2], buf[3]);
+		dev_info(&client->dev, "found a '%s' in warm state\n",
+			 tda10071_ops.info.name);
 
 		ret = tda10071_rd_regs(priv, 0x81, buf, 2);
 		if (ret)
 			goto error;
 
 		cmd.args[0] = CMD_DEMOD_INIT;
-		cmd.args[1] = ((priv->cfg.xtal / 1000) >> 8) & 0xff;
-		cmd.args[2] = ((priv->cfg.xtal / 1000) >> 0) & 0xff;
+		cmd.args[1] = ((priv->clk / 1000) >> 8) & 0xff;
+		cmd.args[2] = ((priv->clk / 1000) >> 0) & 0xff;
 		cmd.args[3] = buf[0];
 		cmd.args[4] = buf[1];
-		cmd.args[5] = priv->cfg.pll_multiplier;
-		cmd.args[6] = priv->cfg.spec_inv;
+		cmd.args[5] = priv->pll_multiplier;
+		cmd.args[6] = priv->spec_inv;
 		cmd.args[7] = 0x00;
 		cmd.len = 8;
 		ret = tda10071_cmd_execute(priv, &cmd);
 		if (ret)
 			goto error;
 
-		if (priv->cfg.tuner_i2c_addr)
-			tmp = priv->cfg.tuner_i2c_addr;
+		if (priv->tuner_i2c_addr)
+			tmp = priv->tuner_i2c_addr;
 		else
 			tmp = 0x14;
 
@@ -1099,7 +1095,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 
 		cmd.args[0] = CMD_MPEG_CONFIG;
 		cmd.args[1] = 0;
-		cmd.args[2] = priv->cfg.ts_mode;
+		cmd.args[2] = priv->ts_mode;
 		cmd.args[3] = 0x00;
 		cmd.args[4] = 0x04;
 		cmd.args[5] = 0x00;
@@ -1142,13 +1138,14 @@ static int tda10071_init(struct dvb_frontend *fe)
 error_release_firmware:
 	release_firmware(fw);
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int tda10071_sleep(struct dvb_frontend *fe)
 {
 	struct tda10071_priv *priv = fe->demodulator_priv;
+	struct i2c_client *client = priv->client;
 	struct tda10071_cmd cmd;
 	int ret, i;
 	struct tda10071_reg_val_mask tab[] = {
@@ -1186,7 +1183,7 @@ static int tda10071_sleep(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1200,71 +1197,6 @@ static int tda10071_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static void tda10071_release(struct dvb_frontend *fe)
-{
-	struct tda10071_priv *priv = fe->demodulator_priv;
-	kfree(priv);
-}
-
-struct dvb_frontend *tda10071_attach(const struct tda10071_config *config,
-	struct i2c_adapter *i2c)
-{
-	int ret;
-	struct tda10071_priv *priv = NULL;
-	u8 tmp;
-
-	/* allocate memory for the internal priv */
-	priv = kzalloc(sizeof(struct tda10071_priv), GFP_KERNEL);
-	if (priv == NULL) {
-		ret = -ENOMEM;
-		goto error;
-	}
-
-	/* make sure demod i2c address is specified */
-	if (!config->demod_i2c_addr) {
-		dev_dbg(&i2c->dev, "%s: invalid demod i2c address\n", __func__);
-		ret = -EINVAL;
-		goto error;
-	}
-
-	/* make sure tuner i2c address is specified */
-	if (!config->tuner_i2c_addr) {
-		dev_dbg(&i2c->dev, "%s: invalid tuner i2c address\n", __func__);
-		ret = -EINVAL;
-		goto error;
-	}
-
-	/* setup the priv */
-	priv->i2c = i2c;
-	memcpy(&priv->cfg, config, sizeof(struct tda10071_config));
-
-	/* chip ID */
-	ret = tda10071_rd_reg(priv, 0xff, &tmp);
-	if (ret || tmp != 0x0f)
-		goto error;
-
-	/* chip type */
-	ret = tda10071_rd_reg(priv, 0xdd, &tmp);
-	if (ret || tmp != 0x00)
-		goto error;
-
-	/* chip version */
-	ret = tda10071_rd_reg(priv, 0xfe, &tmp);
-	if (ret || tmp != 0x01)
-		goto error;
-
-	/* create dvb_frontend */
-	memcpy(&priv->fe.ops, &tda10071_ops, sizeof(struct dvb_frontend_ops));
-	priv->fe.demodulator_priv = priv;
-
-	return &priv->fe;
-error:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
-}
-EXPORT_SYMBOL(tda10071_attach);
-
 static struct dvb_frontend_ops tda10071_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
@@ -1289,8 +1221,6 @@ static struct dvb_frontend_ops tda10071_ops = {
 			FE_CAN_2G_MODULATION
 	},
 
-	.release = tda10071_release,
-
 	.get_tune_settings = tda10071_get_tune_settings,
 
 	.init = tda10071_init,
@@ -1337,14 +1267,12 @@ static int tda10071_probe(struct i2c_client *client,
 	}
 
 	dev->client = client;
-	dev->i2c = client->adapter;
-	dev->cfg.demod_i2c_addr = client->addr;
-	dev->cfg.i2c_wr_max = pdata->i2c_wr_max;
-	dev->cfg.ts_mode = pdata->ts_mode;
-	dev->cfg.spec_inv = pdata->spec_inv;
-	dev->cfg.xtal = pdata->clk;
-	dev->cfg.pll_multiplier = pdata->pll_multiplier;
-	dev->cfg.tuner_i2c_addr = pdata->tuner_i2c_addr;
+	dev->clk = pdata->clk;
+	dev->i2c_wr_max = pdata->i2c_wr_max;
+	dev->ts_mode = pdata->ts_mode;
+	dev->spec_inv = pdata->spec_inv;
+	dev->pll_multiplier = pdata->pll_multiplier;
+	dev->tuner_i2c_addr = pdata->tuner_i2c_addr;
 
 	/* chip ID */
 	ret = tda10071_rd_reg(dev, 0xff, &u8tmp);
@@ -1375,7 +1303,6 @@ static int tda10071_probe(struct i2c_client *client,
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &tda10071_ops, sizeof(struct dvb_frontend_ops));
-	dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = dev;
 	i2c_set_clientdata(client, dev);
 
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index 0ffbfa5..8f18402 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -21,12 +21,11 @@
 #ifndef TDA10071_H
 #define TDA10071_H
 
-#include <linux/kconfig.h>
 #include <linux/dvb/frontend.h>
 
 /*
  * I2C address
- * 0x55,
+ * 0x05, 0x55,
  */
 
 /**
@@ -53,64 +52,4 @@ struct tda10071_platform_data {
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 };
 
-struct tda10071_config {
-	/* Demodulator I2C address.
-	 * Default: none, must set
-	 * Values: 0x55,
-	 */
-	u8 demod_i2c_addr;
-
-	/* Tuner I2C address.
-	 * Default: none, must set
-	 * Values: 0x14, 0x54, ...
-	 */
-	u8 tuner_i2c_addr;
-
-	/* Max bytes I2C provider can write at once.
-	 * Note: Buffer is taken from the stack currently!
-	 * Default: none, must set
-	 * Values:
-	 */
-	u16 i2c_wr_max;
-
-	/* TS output mode.
-	 * Default: TDA10071_TS_SERIAL
-	 * Values:
-	 */
-#define TDA10071_TS_SERIAL        0
-#define TDA10071_TS_PARALLEL      1
-	u8 ts_mode;
-
-	/* Input spectrum inversion.
-	 * Default: 0
-	 * Values: 0, 1
-	 */
-	bool spec_inv;
-
-	/* Xtal frequency Hz
-	 * Default: none, must set
-	 * Values:
-	 */
-	u32 xtal;
-
-	/* PLL multiplier.
-	 * Default: none, must set
-	 * Values:
-	 */
-	u8 pll_multiplier;
-};
-
-
-#if IS_REACHABLE(CONFIG_DVB_TDA10071)
-extern struct dvb_frontend *tda10071_attach(
-	const struct tda10071_config *config, struct i2c_adapter *i2c);
-#else
-static inline struct dvb_frontend *tda10071_attach(
-	const struct tda10071_config *config, struct i2c_adapter *i2c)
-{
-	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif /* TDA10071_H */
diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 54d7c71..a6d8f8c 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -26,10 +26,14 @@
 #include <linux/firmware.h>
 
 struct tda10071_priv {
-	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
 	struct i2c_client *client;
-	struct tda10071_config cfg;
+	u32 clk;
+	u16 i2c_wr_max;
+	u8 ts_mode;
+	bool spec_inv;
+	u8 pll_multiplier;
+	u8 tuner_i2c_addr;
 
 	u8 meas_count[2];
 	u32 ber;
-- 
http://palosaari.fi/

