Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47400 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbaIDChD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 22:37:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 25/37] af9033: clean up logging
Date: Thu,  4 Sep 2014 05:36:33 +0300
Message-Id: <1409798205-25645-25-git-send-email-crope@iki.fi>
In-Reply-To: <1409798205-25645-1-git-send-email-crope@iki.fi>
References: <1409798205-25645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It uses I2C client so logging system prints module name
automatically. Function name is also added automatically, if it is
requested from dynamic debug by setting proper format.
Because of that, we could simplify logging in our driver.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 98 +++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 52 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index c40ae49..1bd5a9a 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -55,8 +55,8 @@ static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
 
 	if (3 + len > sizeof(buf)) {
 		dev_warn(&dev->client->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+				"i2c wr reg=%04x: len=%d is too big!\n",
+				reg, len);
 		return -EINVAL;
 	}
 
@@ -69,9 +69,8 @@ static int af9033_wr_regs(struct af9033_dev *dev, u32 reg, const u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->client->dev,
-				"%s: i2c wr failed=%d reg=%06x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&dev->client->dev, "i2c wr failed=%d reg=%06x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -102,9 +101,8 @@ static int af9033_rd_regs(struct af9033_dev *dev, u32 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->client->dev,
-				"%s: i2c rd failed=%d reg=%06x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&dev->client->dev, "i2c rd failed=%d reg=%06x len=%d\n",
+				ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -176,11 +174,10 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 	int ret, i, j;
 	u8 buf[1 + MAX_TAB_LEN];
 
-	dev_dbg(&dev->client->dev, "%s: tab_len=%d\n", __func__, tab_len);
+	dev_dbg(&dev->client->dev, "tab_len=%d\n", tab_len);
 
 	if (tab_len > sizeof(buf)) {
-		dev_warn(&dev->client->dev, "%s: tab len %d is too big\n",
-				KBUILD_MODNAME, tab_len);
+		dev_warn(&dev->client->dev, "tab len %d is too big\n", tab_len);
 		return -EINVAL;
 	}
 
@@ -201,7 +198,7 @@ static int af9033_wr_reg_val_tab(struct af9033_dev *dev,
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -210,7 +207,7 @@ static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
 {
 	u32 r = 0, c = 0, i;
 
-	dev_dbg(&dev->client->dev, "%s: a=%d b=%d x=%d\n", __func__, a, b, x);
+	dev_dbg(&dev->client->dev, "a=%d b=%d x=%d\n", a, b, x);
 
 	if (a > b) {
 		c = a / b;
@@ -227,8 +224,7 @@ static u32 af9033_div(struct af9033_dev *dev, u32 a, u32 b, u32 x)
 	}
 	r = (c << (u32)x) + r;
 
-	dev_dbg(&dev->client->dev, "%s: a=%d b=%d x=%d r=%d r=%x\n",
-			__func__, a, b, x, r, r);
+	dev_dbg(&dev->client->dev, "a=%d b=%d x=%d r=%d r=%x\n", a, b, x, r, r);
 
 	return r;
 }
@@ -276,8 +272,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	buf[2] = (clock_cw >> 16) & 0xff;
 	buf[3] = (clock_cw >> 24) & 0xff;
 
-	dev_dbg(&dev->client->dev, "%s: clock=%d clock_cw=%08x\n",
-			__func__, dev->cfg.clock, clock_cw);
+	dev_dbg(&dev->client->dev, "clock=%d clock_cw=%08x\n",
+			dev->cfg.clock, clock_cw);
 
 	ret = af9033_wr_regs(dev, 0x800025, buf, 4);
 	if (ret < 0)
@@ -294,8 +290,8 @@ static int af9033_init(struct dvb_frontend *fe)
 	buf[1] = (adc_cw >>  8) & 0xff;
 	buf[2] = (adc_cw >> 16) & 0xff;
 
-	dev_dbg(&dev->client->dev, "%s: adc=%d adc_cw=%06x\n",
-			__func__, clock_adc_lut[i].adc, adc_cw);
+	dev_dbg(&dev->client->dev, "adc=%d adc_cw=%06x\n",
+			clock_adc_lut[i].adc, adc_cw);
 
 	ret = af9033_wr_regs(dev, 0x80f1cd, buf, 3);
 	if (ret < 0)
@@ -336,7 +332,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	}
 
 	/* load OFSM settings */
-	dev_dbg(&dev->client->dev, "%s: load ofsm settings\n", __func__);
+	dev_dbg(&dev->client->dev, "load ofsm settings\n");
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_IT9135_38:
 	case AF9033_TUNER_IT9135_51:
@@ -361,8 +357,7 @@ static int af9033_init(struct dvb_frontend *fe)
 		goto err;
 
 	/* load tuner specific settings */
-	dev_dbg(&dev->client->dev, "%s: load tuner specific settings\n",
-			__func__);
+	dev_dbg(&dev->client->dev, "load tuner specific settings\n");
 	switch (dev->cfg.tuner) {
 	case AF9033_TUNER_TUA9001:
 		len = ARRAY_SIZE(tuner_init_tua9001);
@@ -413,8 +408,8 @@ static int af9033_init(struct dvb_frontend *fe)
 		init = tuner_init_it9135_62;
 		break;
 	default:
-		dev_dbg(&dev->client->dev, "%s: unsupported tuner ID=%d\n",
-				__func__, dev->cfg.tuner);
+		dev_dbg(&dev->client->dev, "unsupported tuner ID=%d\n",
+				dev->cfg.tuner);
 		ret = -ENODEV;
 		goto err;
 	}
@@ -451,7 +446,7 @@ static int af9033_init(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -478,7 +473,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 		usleep_range(200, 10000);
 	}
 
-	dev_dbg(&dev->client->dev, "%s: loop=%d\n", __func__, i);
+	dev_dbg(&dev->client->dev, "loop=%d\n", i);
 
 	if (i == 0) {
 		ret = -ETIMEDOUT;
@@ -504,7 +499,7 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -528,8 +523,8 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	u8 tmp, buf[3], bandwidth_reg_val;
 	u32 if_frequency, freq_cw, adc_freq;
 
-	dev_dbg(&dev->client->dev, "%s: frequency=%d bandwidth_hz=%d\n",
-			__func__, c->frequency, c->bandwidth_hz);
+	dev_dbg(&dev->client->dev, "frequency=%d bandwidth_hz=%d\n",
+			c->frequency, c->bandwidth_hz);
 
 	/* check bandwidth */
 	switch (c->bandwidth_hz) {
@@ -543,8 +538,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 		bandwidth_reg_val = 0x02;
 		break;
 	default:
-		dev_dbg(&dev->client->dev, "%s: invalid bandwidth_hz\n",
-				__func__);
+		dev_dbg(&dev->client->dev, "invalid bandwidth_hz\n");
 		ret = -EINVAL;
 		goto err;
 	}
@@ -646,7 +640,7 @@ static int af9033_set_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -658,7 +652,7 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	int ret;
 	u8 buf[8];
 
-	dev_dbg(&dev->client->dev, "%s:\n", __func__);
+	dev_dbg(&dev->client->dev, "\n");
 
 	/* read all needed registers */
 	ret = af9033_rd_regs(dev, 0x80f900, buf, sizeof(buf));
@@ -773,7 +767,7 @@ static int af9033_get_frontend(struct dvb_frontend *fe)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -819,7 +813,7 @@ static int af9033_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -873,7 +867,7 @@ static int af9033_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -895,7 +889,7 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -941,7 +935,7 @@ static int af9033_update_ch_stat(struct af9033_dev *dev)
 
 	return 0;
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -979,7 +973,7 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&dev->client->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&dev->client->dev, "enable=%d\n", enable);
 
 	ret = af9033_wr_reg_mask(dev, 0x00fa04, enable, 0x01);
 	if (ret < 0)
@@ -988,7 +982,7 @@ static int af9033_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -998,7 +992,7 @@ static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	struct af9033_dev *dev = fe->demodulator_priv;
 	int ret;
 
-	dev_dbg(&dev->client->dev, "%s: onoff=%d\n", __func__, onoff);
+	dev_dbg(&dev->client->dev, "onoff=%d\n", onoff);
 
 	ret = af9033_wr_reg_mask(dev, 0x80f993, onoff, 0x01);
 	if (ret < 0)
@@ -1007,7 +1001,7 @@ static int af9033_pid_filter_ctrl(struct dvb_frontend *fe, int onoff)
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1019,8 +1013,8 @@ static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 	int ret;
 	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
 
-	dev_dbg(&dev->client->dev, "%s: index=%d pid=%04x onoff=%d\n",
-			__func__, index, pid, onoff);
+	dev_dbg(&dev->client->dev, "index=%d pid=%04x onoff=%d\n",
+			index, pid, onoff);
 
 	if (pid > 0x1fff)
 		return 0;
@@ -1040,7 +1034,7 @@ static int af9033_pid_filter(struct dvb_frontend *fe, int index, u16 pid,
 	return 0;
 
 err:
-	dev_dbg(&dev->client->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1110,8 +1104,8 @@ static int af9033_probe(struct i2c_client *client,
 	if (dev->cfg.clock != 12000000) {
 		ret = -ENODEV;
 		dev_err(&dev->client->dev,
-				"%s: af9033: unsupported clock=%d, only 12000000 Hz is supported currently\n",
-				KBUILD_MODNAME, dev->cfg.clock);
+				"unsupported clock %d Hz, only 12000000 Hz is supported currently\n",
+				dev->cfg.clock);
 		goto err_kfree;
 	}
 
@@ -1139,9 +1133,9 @@ static int af9033_probe(struct i2c_client *client,
 		goto err_kfree;
 
 	dev_info(&dev->client->dev,
-			"%s: firmware version: LINK=%d.%d.%d.%d OFDM=%d.%d.%d.%d\n",
-			KBUILD_MODNAME, buf[0], buf[1], buf[2], buf[3], buf[4],
-			buf[5], buf[6], buf[7]);
+			"firmware version: LINK %d.%d.%d.%d - OFDM %d.%d.%d.%d\n",
+			buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6],
+			buf[7]);
 
 	/* sleep */
 	switch (dev->cfg.tuner) {
@@ -1192,7 +1186,7 @@ static int af9033_probe(struct i2c_client *client,
 err_kfree:
 	kfree(dev);
 err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -1200,7 +1194,7 @@ static int af9033_remove(struct i2c_client *client)
 {
 	struct af9033_dev *dev = i2c_get_clientdata(client);
 
-	dev_dbg(&client->dev, "%s\n", __func__);
+	dev_dbg(&dev->client->dev, "\n");
 
 	dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = NULL;
-- 
http://palosaari.fi/

