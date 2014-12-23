Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56647 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbaLWUuc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:32 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 26/66] rtl2832: rename driver state variable from 'priv' to 'dev'
Date: Tue, 23 Dec 2014 22:49:19 +0200
Message-Id: <1419367799-14263-26-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename it device state variable to dev. Both priv and dev are very
common terms for such variable in kernel, but I like use dev in
order to keep drivers consistent.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      | 272 ++++++++++++++---------------
 drivers/media/dvb-frontends/rtl2832_priv.h |   2 +-
 2 files changed, 137 insertions(+), 137 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 7047320..068a833 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -157,13 +157,13 @@ static const struct rtl2832_reg_entry registers[] = {
 };
 
 /* write multiple hardware registers */
-static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
+static int rtl2832_wr(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 {
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = 1 + len,
 			.buf = buf,
@@ -171,7 +171,7 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -180,11 +180,11 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c_adapter, msg, 1);
+	ret = i2c_transfer(dev->i2c_adapter, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 				"%s: i2c wr failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -193,28 +193,28 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 }
 
 /* read multiple hardware registers */
-static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
+static int rtl2832_rd(struct rtl2832_dev *dev, u8 reg, u8 *val, int len)
 {
 	int ret;
 	struct i2c_msg msg[2] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = 1,
 			.buf = &reg,
 		}, {
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = I2C_M_RD,
 			.len = len,
 			.buf = val,
 		}
 	};
 
-	ret = i2c_transfer(priv->i2c_adapter, msg, 2);
+	ret = i2c_transfer(dev->i2c_adapter, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 				"%s: i2c rd failed=%d reg=%02x len=%d\n",
 				KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
@@ -223,54 +223,54 @@ static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 }
 
 /* write multiple registers */
-static int rtl2832_wr_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val,
+static int rtl2832_wr_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val,
 	int len)
 {
 	int ret;
 
 	/* switch bank if needed */
-	if (page != priv->page) {
-		ret = rtl2832_wr(priv, 0x00, &page, 1);
+	if (page != dev->page) {
+		ret = rtl2832_wr(dev, 0x00, &page, 1);
 		if (ret)
 			return ret;
 
-		priv->page = page;
+		dev->page = page;
 }
 
-return rtl2832_wr(priv, reg, val, len);
+return rtl2832_wr(dev, reg, val, len);
 }
 
 /* read multiple registers */
-static int rtl2832_rd_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val,
+static int rtl2832_rd_regs(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val,
 	int len)
 {
 	int ret;
 
 	/* switch bank if needed */
-	if (page != priv->page) {
-		ret = rtl2832_wr(priv, 0x00, &page, 1);
+	if (page != dev->page) {
+		ret = rtl2832_wr(dev, 0x00, &page, 1);
 		if (ret)
 			return ret;
 
-		priv->page = page;
+		dev->page = page;
 	}
 
-	return rtl2832_rd(priv, reg, val, len);
+	return rtl2832_rd(dev, reg, val, len);
 }
 
 /* write single register */
-static int rtl2832_wr_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 val)
+static int rtl2832_wr_reg(struct rtl2832_dev *dev, u8 reg, u8 page, u8 val)
 {
-	return rtl2832_wr_regs(priv, reg, page, &val, 1);
+	return rtl2832_wr_regs(dev, reg, page, &val, 1);
 }
 
 /* read single register */
-static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val)
+static int rtl2832_rd_reg(struct rtl2832_dev *dev, u8 reg, u8 page, u8 *val)
 {
-	return rtl2832_rd_regs(priv, reg, page, val, 1);
+	return rtl2832_rd_regs(dev, reg, page, val, 1);
 }
 
-static int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
+static int rtl2832_rd_demod_reg(struct rtl2832_dev *dev, int reg, u32 *val)
 {
 	int ret;
 
@@ -292,7 +292,7 @@ static int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
 	len = (msb >> 3) + 1;
 	mask = REG_MASK(msb - lsb);
 
-	ret = rtl2832_rd_regs(priv, reg_start_addr, page, &reading[0], len);
+	ret = rtl2832_rd_regs(dev, reg_start_addr, page, &reading[0], len);
 	if (ret)
 		goto err;
 
@@ -305,12 +305,12 @@ static int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val)
 	return ret;
 
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 
 }
 
-static int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
+static int rtl2832_wr_demod_reg(struct rtl2832_dev *dev, int reg, u32 val)
 {
 	int ret, i;
 	u8 len;
@@ -335,7 +335,7 @@ static int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
 	mask = REG_MASK(msb - lsb);
 
 
-	ret = rtl2832_rd_regs(priv, reg_start_addr, page, &reading[0], len);
+	ret = rtl2832_rd_regs(dev, reg_start_addr, page, &reading[0], len);
 	if (ret)
 		goto err;
 
@@ -350,14 +350,14 @@ static int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
 	for (i = 0; i < len; i++)
 		writing[i] = (writing_tmp >> ((len - 1 - i) * 8)) & 0xff;
 
-	ret = rtl2832_wr_regs(priv, reg_start_addr, page, &writing[0], len);
+	ret = rtl2832_wr_regs(dev, reg_start_addr, page, &writing[0], len);
 	if (ret)
 		goto err;
 
 	return ret;
 
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 
 }
@@ -365,30 +365,30 @@ err:
 static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	int ret;
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 
-	dev_dbg(&priv->i2c->dev, "%s: enable=%d\n", __func__, enable);
+	dev_dbg(&dev->i2c->dev, "%s: enable=%d\n", __func__, enable);
 
 	/* gate already open or close */
-	if (priv->i2c_gate_state == enable)
+	if (dev->i2c_gate_state == enable)
 		return 0;
 
-	ret = rtl2832_wr_demod_reg(priv, DVBT_IIC_REPEAT, (enable ? 0x1 : 0x0));
+	ret = rtl2832_wr_demod_reg(dev, DVBT_IIC_REPEAT, (enable ? 0x1 : 0x0));
 	if (ret)
 		goto err;
 
-	priv->i2c_gate_state = enable;
+	dev->i2c_gate_state = enable;
 
 	return ret;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 
 static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	int ret;
 	u64 pset_iffreq;
 	u8 en_bbin = (if_freq == 0 ? 0x1 : 0x0);
@@ -398,26 +398,26 @@ static int rtl2832_set_if(struct dvb_frontend *fe, u32 if_freq)
 	*		/ CrystalFreqHz)
 	*/
 
-	pset_iffreq = if_freq % priv->cfg.xtal;
+	pset_iffreq = if_freq % dev->cfg.xtal;
 	pset_iffreq *= 0x400000;
-	pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
+	pset_iffreq = div_u64(pset_iffreq, dev->cfg.xtal);
 	pset_iffreq = -pset_iffreq;
 	pset_iffreq = pset_iffreq & 0x3fffff;
-	dev_dbg(&priv->i2c->dev, "%s: if_frequency=%d pset_iffreq=%08x\n",
+	dev_dbg(&dev->i2c->dev, "%s: if_frequency=%d pset_iffreq=%08x\n",
 			__func__, if_freq, (unsigned)pset_iffreq);
 
-	ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_EN_BBIN, en_bbin);
 	if (ret)
 		return ret;
 
-	ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_PSET_IFFREQ, pset_iffreq);
 
 	return ret;
 }
 
 static int rtl2832_init(struct dvb_frontend *fe)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	const struct rtl2832_reg_value *init;
 	int i, ret, len;
 
@@ -467,19 +467,19 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		{DVBT_CR_THD_SET2,		0x1},
 	};
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
 
 	for (i = 0; i < ARRAY_SIZE(rtl2832_initial_regs); i++) {
-		ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs[i].reg,
+		ret = rtl2832_wr_demod_reg(dev, rtl2832_initial_regs[i].reg,
 			rtl2832_initial_regs[i].value);
 		if (ret)
 			goto err;
 	}
 
 	/* load tuner specific settings */
-	dev_dbg(&priv->i2c->dev, "%s: load settings for tuner=%02x\n",
-			__func__, priv->cfg.tuner);
-	switch (priv->cfg.tuner) {
+	dev_dbg(&dev->i2c->dev, "%s: load settings for tuner=%02x\n",
+			__func__, dev->cfg.tuner);
+	switch (dev->cfg.tuner) {
 	case RTL2832_TUNER_FC0012:
 	case RTL2832_TUNER_FC0013:
 		len = ARRAY_SIZE(rtl2832_tuner_init_fc0012);
@@ -504,7 +504,7 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	}
 
 	for (i = 0; i < len; i++) {
-		ret = rtl2832_wr_demod_reg(priv, init[i].reg, init[i].value);
+		ret = rtl2832_wr_demod_reg(dev, init[i].reg, init[i].value);
 		if (ret)
 			goto err;
 	}
@@ -516,39 +516,39 @@ static int rtl2832_init(struct dvb_frontend *fe)
 	 */
 #if 1
 	/* soft reset */
-	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
 	if (ret)
 		goto err;
 #endif
 
-	priv->sleeping = false;
+	dev->sleeping = false;
 
 	return ret;
 
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2832_sleep(struct dvb_frontend *fe)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-	priv->sleeping = true;
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	dev->sleeping = true;
 	return 0;
 }
 
 static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
 	s->min_delay_ms = 1000;
 	s->step_size = fe->ops.info.frequency_stepsize * 2;
 	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
@@ -557,7 +557,7 @@ static int rtl2832_get_tune_settings(struct dvb_frontend *fe,
 
 static int rtl2832_set_frontend(struct dvb_frontend *fe)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i, j;
 	u64 bw_mode, num, num2;
@@ -589,7 +589,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	};
 
 
-	dev_dbg(&priv->i2c->dev,
+	dev_dbg(&dev->i2c->dev,
 			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
 			__func__, c->frequency, c->bandwidth_hz, c->inversion);
 
@@ -598,7 +598,7 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		fe->ops.tuner_ops.set_params(fe);
 
 	/* PIP mode related */
-	ret = rtl2832_wr_regs(priv, 0x92, 1, "\x00\x0f\xff", 3);
+	ret = rtl2832_wr_regs(dev, 0x92, 1, "\x00\x0f\xff", 3);
 	if (ret)
 		goto err;
 
@@ -629,12 +629,12 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 		bw_mode = 64000000;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid bandwidth\n", __func__);
+		dev_dbg(&dev->i2c->dev, "%s: invalid bandwidth\n", __func__);
 		return -EINVAL;
 	}
 
 	for (j = 0; j < sizeof(bw_params[0]); j++) {
-		ret = rtl2832_wr_regs(priv, 0x1c+j, 1, &bw_params[i][j], 1);
+		ret = rtl2832_wr_regs(dev, 0x1c+j, 1, &bw_params[i][j], 1);
 		if (ret)
 			goto err;
 	}
@@ -643,11 +643,11 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	* RSAMP_RATIO = floor(CrystalFreqHz * 7 * pow(2, 22)
 	*	/ ConstWithBandwidthMode)
 	*/
-	num = priv->cfg.xtal * 7;
+	num = dev->cfg.xtal * 7;
 	num *= 0x400000;
 	num = div_u64(num, bw_mode);
 	resamp_ratio =  num & 0x3ffffff;
-	ret = rtl2832_wr_demod_reg(priv, DVBT_RSAMP_RATIO, resamp_ratio);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_RSAMP_RATIO, resamp_ratio);
 	if (ret)
 		goto err;
 
@@ -656,48 +656,48 @@ static int rtl2832_set_frontend(struct dvb_frontend *fe)
 	*	/ (CrystalFreqHz * 7))
 	*/
 	num = bw_mode << 20;
-	num2 = priv->cfg.xtal * 7;
+	num2 = dev->cfg.xtal * 7;
 	num = div_u64(num, num2);
 	num = -num;
 	cfreq_off_ratio = num & 0xfffff;
-	ret = rtl2832_wr_demod_reg(priv, DVBT_CFREQ_OFF_RATIO, cfreq_off_ratio);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_CFREQ_OFF_RATIO, cfreq_off_ratio);
 	if (ret)
 		goto err;
 
 	/* soft reset */
-	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
+	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
 	if (ret)
 		goto err;
 
 	return ret;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2832_get_frontend(struct dvb_frontend *fe)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
-	if (priv->sleeping)
+	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2832_rd_regs(priv, 0x3c, 3, buf, 2);
+	ret = rtl2832_rd_regs(dev, 0x3c, 3, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2832_rd_reg(priv, 0x51, 3, &buf[2]);
+	ret = rtl2832_rd_reg(dev, 0x51, 3, &buf[2]);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
+	dev_dbg(&dev->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
@@ -787,22 +787,22 @@ static int rtl2832_get_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	int ret;
 	u32 tmp;
 	*status = 0;
 
-	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
-	if (priv->sleeping)
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2832_rd_demod_reg(priv, DVBT_FSM_STAGE, &tmp);
+	ret = rtl2832_rd_demod_reg(dev, DVBT_FSM_STAGE, &tmp);
 	if (ret)
 		goto err;
 
@@ -818,13 +818,13 @@ static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	int ret, hierarchy, constellation;
 	u8 buf[2], tmp;
 	u16 tmp16;
@@ -838,7 +838,7 @@ static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	/* reports SNR in resolution of 0.1 dB */
 
-	ret = rtl2832_rd_reg(priv, 0x3c, 3, &tmp);
+	ret = rtl2832_rd_reg(dev, 0x3c, 3, &tmp);
 	if (ret)
 		goto err;
 
@@ -850,7 +850,7 @@ static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 	if (hierarchy > HIERARCHY_NUM - 1)
 		goto err;
 
-	ret = rtl2832_rd_regs(priv, 0x0c, 4, buf, 2);
+	ret = rtl2832_rd_regs(dev, 0x0c, 4, buf, 2);
 	if (ret)
 		goto err;
 
@@ -864,17 +864,17 @@ static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct rtl2832_priv *priv = fe->demodulator_priv;
+	struct rtl2832_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 buf[2];
 
-	ret = rtl2832_rd_regs(priv, 0x4e, 3, buf, 2);
+	ret = rtl2832_rd_regs(dev, 0x4e, 3, buf, 2);
 	if (ret)
 		goto err;
 
@@ -882,7 +882,7 @@ static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -895,14 +895,14 @@ err:
  */
 static void rtl2832_i2c_gate_work(struct work_struct *work)
 {
-	struct rtl2832_priv *priv = container_of(work,
-			struct rtl2832_priv, i2c_gate_work.work);
-	struct i2c_adapter *adap = priv->i2c;
+	struct rtl2832_dev *dev = container_of(work,
+			struct rtl2832_dev, i2c_gate_work.work);
+	struct i2c_adapter *adap = dev->i2c;
 	int ret;
 	u8 buf[2];
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -916,7 +916,7 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	if (ret != 1)
 		goto err;
 
-	priv->page = 1;
+	dev->page = 1;
 
 	/* close I2C repeater gate */
 	buf[0] = 0x01;
@@ -925,23 +925,23 @@ static void rtl2832_i2c_gate_work(struct work_struct *work)
 	if (ret != 1)
 		goto err;
 
-	priv->i2c_gate_state = false;
+	dev->i2c_gate_state = false;
 
 	return;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return;
 }
 
 static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 {
-	struct rtl2832_priv *priv = mux_priv;
+	struct rtl2832_dev *dev = mux_priv;
 	int ret;
 	u8 buf[2], val;
 	struct i2c_msg msg[1] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = sizeof(buf),
 			.buf = buf,
@@ -949,12 +949,12 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	};
 	struct i2c_msg msg_rd[2] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = 1,
 			.buf = "\x01",
 		}, {
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = I2C_M_RD,
 			.len = 1,
 			.buf = &val,
@@ -962,9 +962,9 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	};
 
 	/* terminate possible gate closing */
-	cancel_delayed_work_sync(&priv->i2c_gate_work);
+	cancel_delayed_work_sync(&dev->i2c_gate_work);
 
-	if (priv->i2c_gate_state == chan_id)
+	if (dev->i2c_gate_state == chan_id)
 		return 0;
 
 	/* select reg bank 1 */
@@ -974,7 +974,7 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	if (ret != 1)
 		goto err;
 
-	priv->page = 1;
+	dev->page = 1;
 
 	/* we must read that register, otherwise there will be errors */
 	ret = __i2c_transfer(adap, msg_rd, 2);
@@ -992,11 +992,11 @@ static int rtl2832_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	if (ret != 1)
 		goto err;
 
-	priv->i2c_gate_state = chan_id;
+	dev->i2c_gate_state = chan_id;
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 
 	return -EREMOTEIO;
 }
@@ -1004,8 +1004,8 @@ err:
 static int rtl2832_deselect(struct i2c_adapter *adap, void *mux_priv,
 		u32 chan_id)
 {
-	struct rtl2832_priv *priv = mux_priv;
-	schedule_delayed_work(&priv->i2c_gate_work, usecs_to_jiffies(100));
+	struct rtl2832_dev *dev = mux_priv;
+	schedule_delayed_work(&dev->i2c_gate_work, usecs_to_jiffies(100));
 	return 0;
 }
 
@@ -1050,7 +1050,7 @@ static struct dvb_frontend_ops rtl2832_ops = {
 
 static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
 {
-	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 	return &dev->fe;
@@ -1058,7 +1058,7 @@ static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
 
 static struct i2c_adapter *rtl2832_get_i2c_adapter_(struct i2c_client *client)
 {
-	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 	return dev->i2c_adapter_tuner;
@@ -1066,7 +1066,7 @@ static struct i2c_adapter *rtl2832_get_i2c_adapter_(struct i2c_client *client)
 
 static struct i2c_adapter *rtl2832_get_private_i2c_adapter_(struct i2c_client *client)
 {
-	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 	return dev->i2c_adapter;
@@ -1074,7 +1074,7 @@ static struct i2c_adapter *rtl2832_get_private_i2c_adapter_(struct i2c_client *c
 
 static int rtl2832_enable_slave_ts(struct i2c_client *client)
 {
-	struct rtl2832_priv *dev = i2c_get_clientdata(client);
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 	int ret;
 
 	dev_dbg(&client->dev, "setting PIP mode\n");
@@ -1128,7 +1128,7 @@ static int rtl2832_probe(struct i2c_client *client,
 	struct rtl2832_platform_data *pdata = client->dev.platform_data;
 	const struct rtl2832_config *config = pdata->config;
 	struct i2c_adapter *i2c = client->adapter;
-	struct rtl2832_priv *priv;
+	struct rtl2832_dev *dev;
 	int ret;
 	u8 tmp;
 
@@ -1140,45 +1140,45 @@ static int rtl2832_probe(struct i2c_client *client,
 	}
 
 	/* allocate memory for the internal state */
-	priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
-	if (priv == NULL) {
+	dev = kzalloc(sizeof(struct rtl2832_dev), GFP_KERNEL);
+	if (dev == NULL) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	/* setup the priv */
-	priv->client = client;
-	priv->i2c = i2c;
-	priv->tuner = config->tuner;
-	priv->sleeping = true;
-	memcpy(&priv->cfg, config, sizeof(struct rtl2832_config));
-	INIT_DELAYED_WORK(&priv->i2c_gate_work, rtl2832_i2c_gate_work);
+	/* setup the state */
+	dev->client = client;
+	dev->i2c = i2c;
+	dev->tuner = config->tuner;
+	dev->sleeping = true;
+	memcpy(&dev->cfg, config, sizeof(struct rtl2832_config));
+	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
 
 	/* create muxed i2c adapter for demod itself */
-	priv->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, priv, 0, 0, 0,
+	dev->i2c_adapter = i2c_add_mux_adapter(i2c, &i2c->dev, dev, 0, 0, 0,
 			rtl2832_select, NULL);
-	if (priv->i2c_adapter == NULL) {
+	if (dev->i2c_adapter == NULL) {
 		ret = -ENODEV;
 		goto err_kfree;
 	}
 
 	/* check if the demod is there */
-	ret = rtl2832_rd_reg(priv, 0x00, 0x0, &tmp);
+	ret = rtl2832_rd_reg(dev, 0x00, 0x0, &tmp);
 	if (ret)
 		goto err_i2c_del_mux_adapter;
 
 	/* create muxed i2c adapter for demod tuner bus */
-	priv->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, priv,
+	dev->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, dev,
 			0, 1, 0, rtl2832_select, rtl2832_deselect);
-	if (priv->i2c_adapter_tuner == NULL) {
+	if (dev->i2c_adapter_tuner == NULL) {
 		ret = -ENODEV;
 		goto err_i2c_del_mux_adapter;
 	}
 
 	/* create dvb_frontend */
-	memcpy(&priv->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
-	priv->fe.demodulator_priv = priv;
-	i2c_set_clientdata(client, priv);
+	memcpy(&dev->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.demodulator_priv = dev;
+	i2c_set_clientdata(client, dev);
 
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2832_get_dvb_frontend;
@@ -1189,9 +1189,9 @@ static int rtl2832_probe(struct i2c_client *client,
 	dev_info(&client->dev, "Realtek RTL2832 successfully attached\n");
 	return 0;
 err_i2c_del_mux_adapter:
-	i2c_del_mux_adapter(priv->i2c_adapter);
+	i2c_del_mux_adapter(dev->i2c_adapter);
 err_kfree:
-	kfree(priv);
+	kfree(dev);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -1199,17 +1199,17 @@ err:
 
 static int rtl2832_remove(struct i2c_client *client)
 {
-	struct rtl2832_priv *priv = i2c_get_clientdata(client);
+	struct rtl2832_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	cancel_delayed_work_sync(&priv->i2c_gate_work);
+	cancel_delayed_work_sync(&dev->i2c_gate_work);
 
-	i2c_del_mux_adapter(priv->i2c_adapter_tuner);
+	i2c_del_mux_adapter(dev->i2c_adapter_tuner);
 
-	i2c_del_mux_adapter(priv->i2c_adapter);
+	i2c_del_mux_adapter(dev->i2c_adapter);
 
-	kfree(priv);
+	kfree(dev);
 
 	return 0;
 }
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index 05b2b62..58feb27 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -25,7 +25,7 @@
 #include "rtl2832.h"
 #include <linux/i2c-mux.h>
 
-struct rtl2832_priv {
+struct rtl2832_dev {
 	struct i2c_client *client;
 	struct i2c_adapter *i2c;
 	struct i2c_adapter *i2c_adapter;
-- 
http://palosaari.fi/

