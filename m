Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49414 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbaIDChD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 24/37] af9033: convert to I2C client
Date: Thu,  4 Sep 2014 05:36:32 +0300
Message-Id: <1409798205-25645-24-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert driver to kernel I2C model.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c  | 236 +++++++++++++++++++---------------
 drivers/media/dvb-frontends/af9033.h  |  44 ++-----
 drivers/media/usb/dvb-usb-v2/af9035.c |  50 +++++--
 drivers/media/usb/dvb-usb-v2/af9035.h |   2 +-
 4 files changed, 183 insertions(+), 149 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 43b7335..c40ae49 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -25,7 +25,7 @@
 #define MAX_XFER_SIZE  64
 
 struct af9033_dev {
-	struct i2c_adapter *i2c;
+	struct i2c_client *client;
 	struct dvb_frontend fe;
 	struct af9033_config cfg;
 
@@ -46,7 +46,7 @@ static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = dev->client->addr,
 			.flags = 0,
 			.len = 3 + len,
 			.buf = buf,
@@ -54,7 +54,7 @@ static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
 	};
 
 	if (3 + len > sizeof(buf)) {
-		dev_warn(&dev->i2c->dev,
+		dev_warn(&dev->client->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -65,11 +65,11 @@ static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
 	buf[2] = (reg >>  0) & 0xff;
 	memcpy(&buf[3], val, len);
 
-	ret = i2c_transfer(dev->i2c, msg, 1);
+	ret = i2c_transfer(dev->client->adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev,
+		dev_warn(&dev->client->dev,
 				"%s: i2c wr failed=%d reg=%06x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -86,23 +86,23 @@ static int af9033_rd_regs(struct af9033_dev *dev, u32 reg, u8 *val, int len)
 			(reg >> 0) & 0xff };
 	struct i2c_msg msg[2] = {
 		{
-			.addr = dev->cfg.i2c_addr,
+			.addr = dev->client->addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf
 		}, {
-			.addr = dev->cfg.i2c_addr,
+			.addr = dev->client->addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val
 		}
 	};
 
-	ret = i2c_transfer(dev->i2c, msg, 2);
+	ret = i2c_transfer(dev->client->adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev,
+		dev_warn(&dev->client->dev,
 				"%s: i2c rd failed=%d reg=%06x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -176,10 +176,10 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 	int ret, i, j;
 	u8 buf[1 + MAX_TAB_LEN];
 
-	dev_dbg(&dev->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
+	dev_dbg(&dev->client->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
 	if (tab_len > sizeof(buf)) {
-		dev_warn(&dev->i2c->dev, "%s: tab len %d is too big\n",
+		dev_warn(&dev->client->dev, "%s: tab len %d is too big\n",
 				KBUILD_MODNAME, tab_len);
 		return -EINVAL;
 	}
@@ -201,7 +201,7 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -210,7 +210,7 @@ static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
 
-	dev_dbg(&dev->i2c->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
+	dev_dbg(&dev->client->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
 
 	if (a > b) {
 		c = a / b;
@@ -227,19 +227,12 @@ static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
 	}
 	r = (c << (u32)x) + r;
 
-	dev_dbg(&dev->i2c->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
+	dev_dbg(&dev->client->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
 			__func__, a, b, x, r, r);
 
 	return r;
 }
 
-static void af9033_release(struct dvb_frontend *fe)
-{
-	struct af9033_dev *dev = fe->demodulator_priv;
-
-	kfree(dev);
-}
-
 static int af9033_init(struct dvb_frontend *fe)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
@@ -283,7 +276,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	buf[2] = (clock_cw >> 16) & 0xff;
 	buf[3] = (clock_cw >> 24) & 0xff;
 
-	dev_dbg(&dev->i2c->dev, "%s: clock=%d clock_cw=%08x\n",
+	dev_dbg(&dev->client->dev, "%s: clock=%d clock_cw=%08x\n",
 			__func__, dev->cfg.clock, clock_cw);
 
 	ret = af9033_wr_regs(dev, 0x800025, buf, 4);
@@ -301,7 +294,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
 
-	dev_dbg(&dev->i2c->dev, "%s: adc=%d adc_cw=%06x\n",
+	dev_dbg(&dev->client->dev, "%s: adc=%d adc_cw=%06x\n",
 			__func__, clock_adc_lut[i].adc, adc_cw);
 
 	ret = af9033_wr_regs(dev, 0x80f1cd, buf, 3);
@@ -343,7 +336,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	/* load OFSM settings */
-	dev_dbg(&dev->i2c->dev, "%s: load ofsm settings\n", __func__);
+	dev_dbg(&dev->client->dev, "%s: load ofsm settings\n", __func__);
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
@@ -368,7 +361,7 @@ static int af9033_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* load tuner specific settings */
-	dev_dbg(&dev->i2c->dev, "%s: load tuner specific settings\n",
+	dev_dbg(&dev->client->dev, "%s: load tuner specific settings\n",
 			__func__);
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_TUA9001:
@@ -420,7 +413,7 @@ static int af9033_init(struct dvb_frontend *fe)
 		init = tuner_init_it9135_62;
 		break;
 	default:
-		dev_dbg(&dev->i2c->dev, "%s: unsupported tuner ID=%d\n",
+		dev_dbg(&dev->client->dev, "%s: unsupported tuner ID=%d\n",
 				__func__, dev->cfg.tuner);
 		ret = -ENODEV;
 		goto err;
@@ -458,7 +451,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -485,7 +478,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 		usleep_range(200, 10000);
 	}
 
-	dev_dbg(&dev->i2c->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&dev->client->dev, "%s: loop=%d\n", __func__, i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -511,7 +504,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -535,7 +528,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	u8 tmp, buf[3], bandwidth_reg_val;
 	u32 if_frequency, freq_cw, adc_freq;
 
-	dev_dbg(&dev->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
+	dev_dbg(&dev->client->dev, "%s: frequency=%d bandwidth_hz=%d\n",
 			__func__, c->frequency, c->bandwidth_hz);
 
 	/* check bandwidth */
@@ -550,7 +543,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		bandwidth_reg_val = 0x02;
 		break;
 	default:
-		dev_dbg(&dev->i2c->dev, "%s: invalid bandwidth_hz\n",
+		dev_dbg(&dev->client->dev, "%s: invalid bandwidth_hz\n",
 				__func__);
 		ret = -EINVAL;
 		goto err;
@@ -653,7 +646,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -665,7 +658,7 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[8];
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "%s:\n", __func__);
 
 	/* read all needed registers */
 	ret = af9033_rd_regs(dev, 0x80f900, buf, sizeof(buf));
@@ -780,7 +773,7 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -826,7 +819,7 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -880,7 +873,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -902,7 +895,7 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -948,7 +941,7 @@ static int af9033_update_ch_stat(struct af9033_dev *dev)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -986,7 +979,7 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&dev->i2c->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&dev->client->dev, "%s: enable=%d\n", __func__, enable);
 
 	ret = af9033_wr_reg_mask(dev, 0x00fa04, enable, 0x01);
 	if (ret < 0)
@@ -995,7 +988,7 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -1005,7 +998,7 @@ static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&dev->i2c->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&dev->client->dev, "%s: onoff=%d\n", __func__, onoff);
 
 	ret = af9033_wr_reg_mask(dev, 0x80f993, onoff, 0x01);
 	if (ret < 0)
@@ -1014,7 +1007,7 @@ static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -1026,7 +1019,7 @@ static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 	int ret;
 	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
 
-	dev_dbg(&dev->i2c->dev, "%s: index=%d pid=%04x onoff=%d\n",
+	dev_dbg(&dev->client->dev, "%s: index=%d pid=%04x onoff=%d\n",
 			__func__, index, pid, onoff);
 
 	if (pid > 0x1fff)
@@ -1047,38 +1040,79 @@ static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 	return 0;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
 
-static struct dvb_frontend_ops af9033_ops;
+static struct dvb_frontend_ops af9033_ops = {
+	.delsys = { SYS_DVBT },
+	.info = {
+		.name = "Afatech AF9033 (DVB-T)",
+		.frequency_min = 174000000,
+		.frequency_max = 862000000,
+		.frequency_stepsize = 250000,
+		.frequency_tolerance = 0,
+		.caps =	FE_CAN_FEC_1_2 |
+			FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 |
+			FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK |
+			FE_CAN_QAM_16 |
+			FE_CAN_QAM_64 |
+			FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO |
+			FE_CAN_HIERARCHY_AUTO |
+			FE_CAN_RECOVER |
+			FE_CAN_MUTE_TS
+	},
+
+	.init = af9033_init,
+	.sleep = af9033_sleep,
+
+	.get_tune_settings = af9033_get_tune_settings,
+	.set_frontend = af9033_set_frontend,
+	.get_frontend = af9033_get_frontend,
+
+	.read_status = af9033_read_status,
+	.read_snr = af9033_read_snr,
+	.read_signal_strength = af9033_read_signal_strength,
+	.read_ber = af9033_read_ber,
+	.read_ucblocks = af9033_read_ucblocks,
+
+	.i2c_gate_ctrl = af9033_i2c_gate_ctrl,
+};
 
-struct dvb_frontend *af9033_attach(const struct af9033_config *config,
-				   struct i2c_adapter *i2c,
-				   struct af9033_ops *ops)
+static int af9033_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
-	int ret;
+	struct af9033_config *cfg = client->dev.platform_data;
 	struct af9033_dev *dev;
+	int ret;
 	u8 buf[8];
 	u32 reg;
 
-	dev_dbg(&i2c->dev, "%s:\n", __func__);
-
 	/* allocate memory for the internal state */
 	dev = kzalloc(sizeof(struct af9033_dev), GFP_KERNEL);
-	if (dev == NULL)
+	if (dev == NULL) {
+		ret = -ENOMEM;
+		dev_err(&client->dev, "Could not allocate memory for state\n");
 		goto err;
+	}
 
 	/* setup the state */
-	dev->i2c = i2c;
-	memcpy(&dev->cfg, config, sizeof(struct af9033_config));
+	dev->client = client;
+	memcpy(&dev->cfg, cfg, sizeof(struct af9033_config));
 
 	if (dev->cfg.clock != 12000000) {
-		dev_err(&dev->i2c->dev,
+		ret = -ENODEV;
+		dev_err(&dev->client->dev,
 				"%s: af9033: unsupported clock=%d, only 12000000 Hz is supported currently\n",
 				KBUILD_MODNAME, dev->cfg.clock);
-		goto err;
+		goto err_kfree;
 	}
 
 	/* firmware version */
@@ -1098,13 +1132,13 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 
 	ret = af9033_rd_regs(dev, reg, &buf[0], 4);
 	if (ret < 0)
-		goto err;
+		goto err_kfree;
 
 	ret = af9033_rd_regs(dev, 0x804191, &buf[4], 4);
 	if (ret < 0)
-		goto err;
+		goto err_kfree;
 
-	dev_info(&dev->i2c->dev,
+	dev_info(&dev->client->dev,
 			"%s: firmware version: LINK=%d.%d.%d.%d OFDM=%d.%d.%d.%d\n",
 			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3], buf[4],
 			buf[5], buf[6], buf[7]);
@@ -1122,11 +1156,11 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	default:
 		ret = af9033_wr_reg(dev, 0x80004c, 1);
 		if (ret < 0)
-			goto err;
+			goto err_kfree;
 
 		ret = af9033_wr_reg(dev, 0x800000, 0);
 		if (ret < 0)
-			goto err;
+			goto err_kfree;
 	}
 
 	/* configure internal TS mode */
@@ -1146,63 +1180,53 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &af9033_ops, sizeof(struct dvb_frontend_ops));
 	dev->fe.demodulator_priv = dev;
-
-	if (ops) {
-		ops->pid_filter = af9033_pid_filter;
-		ops->pid_filter_ctrl = af9033_pid_filter_ctrl;
+	*cfg->fe = &dev->fe;
+	if (cfg->ops) {
+		cfg->ops->pid_filter = af9033_pid_filter;
+		cfg->ops->pid_filter_ctrl = af9033_pid_filter_ctrl;
 	}
+	i2c_set_clientdata(client, dev);
 
-	return &dev->fe;
-
-err:
+	dev_info(&dev->client->dev, "Afatech AF9033 successfully attached\n");
+	return 0;
+err_kfree:
 	kfree(dev);
-	return NULL;
+err:
+	dev_dbg(&client->dev, "failed %d\n", ret);
+	return ret;
 }
-EXPORT_SYMBOL(af9033_attach);
 
-static struct dvb_frontend_ops af9033_ops = {
-	.delsys = { SYS_DVBT },
-	.info = {
-		.name = "Afatech AF9033 (DVB-T)",
-		.frequency_min = 174000000,
-		.frequency_max = 862000000,
-		.frequency_stepsize = 250000,
-		.frequency_tolerance = 0,
-		.caps =	FE_CAN_FEC_1_2 |
-			FE_CAN_FEC_2_3 |
-			FE_CAN_FEC_3_4 |
-			FE_CAN_FEC_5_6 |
-			FE_CAN_FEC_7_8 |
-			FE_CAN_FEC_AUTO |
-			FE_CAN_QPSK |
-			FE_CAN_QAM_16 |
-			FE_CAN_QAM_64 |
-			FE_CAN_QAM_AUTO |
-			FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO |
-			FE_CAN_HIERARCHY_AUTO |
-			FE_CAN_RECOVER |
-			FE_CAN_MUTE_TS
-	},
+static int af9033_remove(struct i2c_client *client)
+{
+	struct af9033_dev *dev = i2c_get_clientdata(client);
 
-	.release = af9033_release,
+	dev_dbg(&client->dev, "%s\n", __func__);
 
-	.init = af9033_init,
-	.sleep = af9033_sleep,
+	dev->fe.ops.release = NULL;
+	dev->fe.demodulator_priv = NULL;
+	kfree(dev);
 
-	.get_tune_settings = af9033_get_tune_settings,
-	.set_frontend = af9033_set_frontend,
-	.get_frontend = af9033_get_frontend,
+	return 0;
+}
 
-	.read_status = af9033_read_status,
-	.read_snr = af9033_read_snr,
-	.read_signal_strength = af9033_read_signal_strength,
-	.read_ber = af9033_read_ber,
-	.read_ucblocks = af9033_read_ucblocks,
+static const struct i2c_device_id af9033_id_table[] = {
+	{"af9033", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, af9033_id_table);
 
-	.i2c_gate_ctrl = af9033_i2c_gate_ctrl,
+static struct i2c_driver af9033_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "af9033",
+	},
+	.probe		= af9033_probe,
+	.remove		= af9033_remove,
+	.id_table	= af9033_id_table,
 };
 
+module_i2c_driver(af9033_driver);
+
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9033 DVB-T demodulator driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index b95a6d4..1b968d0 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -80,8 +80,18 @@ struct af9033_config {
 	 *
 	 */
 	bool dyn0_clk;
-};
 
+	/*
+	 * PID filter ops
+	 */
+	struct af9033_ops *ops;
+
+	/*
+	 * frontend
+	 * returned by that driver
+	 */
+	struct dvb_frontend **fe;
+};
 
 struct af9033_ops {
 	int (*pid_filter_ctrl)(struct dvb_frontend *fe, int onoff);
@@ -89,36 +99,4 @@ struct af9033_ops {
 			  int onoff);
 };
 
-
-#if IS_ENABLED(CONFIG_DVB_AF9033)
-extern
-struct dvb_frontend *af9033_attach(const struct af9033_config *config,
-				   struct i2c_adapter *i2c,
-				   struct af9033_ops *ops);
-
-#else
-static inline
-struct dvb_frontend *af9033_attach(const struct af9033_config *config,
-				   struct i2c_adapter *i2c,
-				   struct af9033_ops *ops)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
-	int onoff)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-#endif
-
 #endif /* AF9033_H */
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 533c96e..6534e44 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -305,6 +305,19 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 	 * NOTE: As a firmware knows tuner type there is very small possibility
 	 * there could be some tuner I2C hacks done by firmware and this may
 	 * lead problems if firmware expects those bytes are used.
+	 *
+	 * TODO: Here is few hacks. AF9035 chip integrates AF9033 demodulator.
+	 * IT9135 chip integrates AF9033 demodulator and RF tuner. For dual
+	 * tuner devices, there is also external AF9033 demodulator connected
+	 * via external I2C bus. All AF9033 demod I2C traffic, both single and
+	 * dual tuner configuration, is covered by firmware - actual USB IO
+	 * looks just like a memory access.
+	 * In case of IT913x chip, there is own tuner driver. It is implemented
+	 * currently as a I2C driver, even tuner IP block is likely build
+	 * directly into the demodulator memory space and there is no own I2C
+	 * bus. I2C subsystem does not allow register multiple devices to same
+	 * bus, having same slave address. Due to that we reuse demod address,
+	 * shifted by one bit, on that case.
 	 */
 	if (num == 2 && !(msg[0].flags & I2C_M_RD) &&
 			(msg[1].flags & I2C_M_RD)) {
@@ -312,12 +325,14 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
-			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
+			   (msg[0].addr == state->af9033_config[1].i2c_addr) ||
+			   (state->chip_type == 0x9135)) {
 			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
 
-			if (msg[0].addr == state->af9033_config[1].i2c_addr)
+			if (msg[0].addr == state->af9033_config[1].i2c_addr ||
+			    msg[0].addr == (state->af9033_config[1].i2c_addr >> 1))
 				reg |= 0x100000;
 
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
@@ -349,12 +364,14 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
-			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
+			   (msg[0].addr == state->af9033_config[1].i2c_addr) ||
+			   (state->chip_type == 0x9135)) {
 			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
 
-			if (msg[0].addr == state->af9033_config[1].i2c_addr)
+			if (msg[0].addr == state->af9033_config[1].i2c_addr ||
+			    msg[0].addr == (state->af9033_config[1].i2c_addr >> 1))
 				reg |= 0x100000;
 
 			ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
@@ -1066,6 +1083,8 @@ static int af9035_get_adapter_count(struct dvb_usb_device *d)
 	return state->dual_mode + 1;
 }
 
+static void af9035_exit(struct dvb_usb_device *d);
+
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
@@ -1080,9 +1099,14 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 		goto err;
 	}
 
-	/* attach demodulator */
-	adap->fe[0] = dvb_attach(af9033_attach, &state->af9033_config[adap->id],
-			&d->i2c_adap, &state->ops);
+	state->af9033_config[adap->id].fe = &adap->fe[0];
+	state->af9033_config[adap->id].ops = &state->ops;
+	ret = af9035_add_i2c_dev(d, "af9033",
+			state->af9033_config[adap->id].i2c_addr,
+			&state->af9033_config[adap->id]);
+	if (ret)
+		goto err;
+
 	if (adap->fe[0] == NULL) {
 		ret = -ENODEV;
 		goto err;
@@ -1095,6 +1119,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
+	af9035_exit(d); /* remove I2C clients */
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
@@ -1332,7 +1357,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 
 		ret = af9035_add_i2c_dev(d, "it913x",
-				state->af9033_config[adap->id].i2c_addr,
+				state->af9033_config[adap->id].i2c_addr >> 1,
 				&it913x_config);
 		if (ret)
 			goto err;
@@ -1357,7 +1382,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		}
 
 		ret = af9035_add_i2c_dev(d, "it913x",
-				state->af9033_config[adap->id].i2c_addr,
+				state->af9033_config[adap->id].i2c_addr >> 1,
 				&it913x_config);
 		if (ret)
 			goto err;
@@ -1377,6 +1402,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
+	af9035_exit(d); /* remove I2C clients */
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
@@ -1435,6 +1461,12 @@ static void af9035_exit(struct dvb_usb_device *d)
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
+	if (state->i2c_client[3])
+		af9035_del_i2c_dev(d);
+
+	if (state->i2c_client[2])
+		af9035_del_i2c_dev(d);
+
 	if (state->i2c_client[1])
 		af9035_del_i2c_dev(d);
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 0911c4fc..2196077 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -63,7 +63,7 @@ struct state {
 	u16 eeprom_addr;
 	struct af9033_config af9033_config[2];
 	struct af9033_ops ops;
-	#define AF9035_I2C_CLIENT_MAX 2
+	#define AF9035_I2C_CLIENT_MAX 4
 	struct i2c_client *i2c_client[AF9035_I2C_CLIENT_MAX];
 };
 
-- 
http://palosaari.fi/

