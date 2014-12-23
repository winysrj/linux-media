Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60167 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 27/66] rtl2832: enhance / fix logging
Date: Tue, 23 Dec 2014 22:49:20 +0200
Message-Id: <1419367799-14263-27-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass correct device pointer to dev_* logging functions in order
print logs correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 102 +++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 068a833..943446d 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -159,6 +159,7 @@ static const struct rtl2832_reg_entry registers[] = {
 /* write multiple hardware registers */
 static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 {
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
@@ -171,9 +172,8 @@ static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&dev->i2c->dev,
-			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
-			 KBUILD_MODNAME, reg, len);
+		dev_warn(&client->dev, "i2c wr reg=%04x: len=%d is too big!\n",
+			 reg, len);
 		return -EINVAL;
 	}
 
@@ -184,9 +184,8 @@ static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev,
-				"%s: i2c wr failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c wr failed=%d reg=%02x len=%d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -195,6 +194,7 @@ static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 /* read multiple hardware registers */
 static int rtl2832_rd(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 {
+	struct i2c_client *client = dev->client;
 	int ret;
 	struct i2c_msg msg[2] = {
 		{
@@ -214,9 +214,8 @@ static int rtl2832_rd(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&dev->i2c->dev,
-				"%s: i2c rd failed=%d reg=%02x len=%d\n",
-				KBUILD_MODNAME, ret, reg, len);
+		dev_warn(&client->dev, "i2c rd failed=%d reg=%02x len=%d\n",
+			 ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -235,9 +234,8 @@ static int rtl2832_wr_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val,
 			return ret;
 
 		dev->page = page;
-}
-
-return rtl2832_wr(dev, reg, val, len);
+	}
+	return rtl2832_wr(dev, reg, val, len);
 }
 
 /* read multiple registers */
@@ -254,7 +252,6 @@ static int rtl2832_rd_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val,
 
 		dev->page = page;
 	}
-
 	return rtl2832_rd(dev, reg, val, len);
 }
 
@@ -272,6 +269,7 @@ static int rtl2832_rd_reg(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val)
 
 static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 {
+	struct i2c_client *client = dev->client;
 	int ret;
 
 	u8 reg_start_addr;
@@ -305,13 +303,14 @@ static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 	return ret;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 
 }
 
 static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 {
+	struct i2c_client *client = dev->client;
 	int ret, i;
 	u8 len;
 	u8 reg_start_addr;
@@ -357,17 +356,18 @@ static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 	return ret;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 
 }
 
 static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
-	int ret;
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
+	int ret;
 
-	dev_dbg(&dev->i2c->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&client->dev, "enable=%d\n", enable);
 
 	/* gate already open or close */
 	if (dev->i2c_gate_state == enable)
@@ -381,7 +381,7 @@ static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	return ret;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -389,6 +389,7 @@ err:
 static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u64 pset_iffreq;
 	u8 en_bbin = (if_freq == 0 ? 0x1 : 0x0);
@@ -403,8 +404,8 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 	pset_iffreq = div_u64(pset_iffreq, dev->cfg.xtal);
 	pset_iffreq = -pset_iffreq;
 	pset_iffreq = pset_iffreq & 0x3fffff;
-	dev_dbg(&dev->i2c->dev, "%s: if_frequency=%d pset_iffreq=%08x\n",
-			__func__, if_freq, (unsigned)pset_iffreq);
+	dev_dbg(&client->dev, "if_frequency=%d pset_iffreq=%08x\n",
+		if_freq, (unsigned)pset_iffreq);
 
 	ret = rtl2832_wr_demod_reg(dev, DVBT_EN_BBIN, en_bbin);
 	if (ret)
@@ -418,9 +419,9 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 static int rtl2832_init(struct dvb_frontend *fe)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	const struct rtl2832_reg_value *init;
 	int i, ret, len;
-
 	/* initialization values for the demodulator registers */
 	struct rtl2832_reg_value rtl2832_initial_regs[] = {
 		{DVBT_AD_EN_REG,		0x1},
@@ -467,7 +468,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		{DVBT_CR_THD_SET2,		0x1},
 	};
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 
 	for (i = 0; i < ARRAY_SIZE(rtl2832_initial_regs); i++) {
 		ret = rtl2832_wr_demod_reg(dev, rtl2832_initial_regs[i].reg,
@@ -477,8 +478,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	}
 
 	/* load tuner specific settings */
-	dev_dbg(&dev->i2c->dev, "%s: load settings for tuner=%02x\n",
-			__func__, dev->cfg.tuner);
+	dev_dbg(&client->dev, "load settings for tuner=%02x\n", dev->cfg.tuner);
 	switch (dev->cfg.tuner) {
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
@@ -530,15 +530,16 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	return ret;
 
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int rtl2832_sleep(struct dvb_frontend *fe)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 	dev->sleeping = true;
 	return 0;
 }
@@ -547,8 +548,9 @@ static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
 	s->min_delay_ms = 1000;
 	s->step_size = fe->ops.info.frequency_stepsize * 2;
 	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
@@ -558,6 +560,7 @@ static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 static int rtl2832_set_frontend(struct dvb_frontend *fe)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, j;
 	u64 bw_mode, num, num2;
@@ -589,9 +592,8 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	};
 
 
-	dev_dbg(&dev->i2c->dev,
-			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
-			__func__, c->frequency, c->bandwidth_hz, c->inversion);
+	dev_dbg(&client->dev, "frequency=%u bandwidth_hz=%u inversion=%u\n",
+		c->frequency, c->bandwidth_hz, c->inversion);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -629,8 +631,10 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		bw_mode = 64000000;
 		break;
 	default:
-		dev_dbg(&dev->i2c->dev, "%s: invalid bandwidth\n", __func__);
-		return -EINVAL;
+		dev_err(&client->dev, "invalid bandwidth_hz %u\n",
+			c->bandwidth_hz);
+		ret = -EINVAL;
+		goto err;
 	}
 
 	for (j = 0; j < sizeof(bw_params[0]); j++) {
@@ -675,13 +679,14 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int rtl2832_get_frontend(struct dvb_frontend *fe)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
@@ -697,7 +702,7 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&dev->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
+	dev_dbg(&client->dev, "TPS=%*ph\n", 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
@@ -787,18 +792,20 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u32 tmp;
-	*status = 0;
 
-	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&client->dev, "\n");
+
+	*status = 0;
 	if (dev->sleeping)
 		return 0;
 
@@ -818,13 +825,14 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret, hierarchy, constellation;
 	u8 buf[2], tmp;
 	u16 tmp16;
@@ -864,13 +872,14 @@ static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct rtl2832_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[2];
 
@@ -882,7 +891,7 @@ static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -897,6 +906,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 {
 	struct rtl2832_dev *dev = container_of(work,
 			struct rtl2832_dev, i2c_gate_work.work);
+	struct i2c_client *client = dev->client;
 	struct i2c_adapter *adap = dev->i2c;
 	int ret;
 	u8 buf[2];
@@ -909,6 +919,8 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 		}
 	};
 
+	dev_dbg(&client->dev, "\n");
+
 	/* select reg bank 1 */
 	buf[0] = 0x00;
 	buf[1] = 0x01;
@@ -929,14 +941,14 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 
 	return;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return;
 }
 
 static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 {
 	struct rtl2832_dev *dev = mux_priv;
+	struct i2c_client *client = dev->client;
 	int ret;
 	u8 buf[2], val;
 	struct i2c_msg msg[1] = {
@@ -996,8 +1008,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 
 	return 0;
 err:
-	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
-
+	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return -EREMOTEIO;
 }
 
@@ -1005,6 +1016,7 @@ static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
 		u32 chan_id)
 {
 	struct rtl2832_dev *dev = mux_priv;
+
 	schedule_delayed_work(&dev->i2c_gate_work, usecs_to_jiffies(100));
 	return 0;
 }
@@ -1077,7 +1089,7 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
-	dev_dbg(&client->dev, "setting PIP mode\n");
+	dev_dbg(&client->dev, "\n");
 
 	ret = rtl2832_wr_regs(dev, 0x0c, 1, "\x5f\xff", 2);
 	if (ret)
-- 
http://palosaari.fi/

