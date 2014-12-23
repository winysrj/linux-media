Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51811 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbaLWUu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/66] rtl2830: rename 'priv' to 'dev'
Date: Tue, 23 Dec 2014 22:49:01 +0200
Message-Id: <1419367799-14263-8-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use name 'dev' for device state instance as it is more common and
also one letter shorter.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c      | 212 ++++++++++++++---------------
 drivers/media/dvb-frontends/rtl2830_priv.h |   2 +-
 2 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 541e244..44643d9 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -31,13 +31,13 @@
 #define MAX_XFER_SIZE  64
 
 /* write multiple hardware registers */
-static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
+static int rtl2830_wr(struct rtl2830_dev *dev, u8 reg, const u8 *val, int len)
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
@@ -45,7 +45,7 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 	};
 
 	if (1 + len > sizeof(buf)) {
-		dev_warn(&priv->i2c->dev,
+		dev_warn(&dev->i2c->dev,
 			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
 			 KBUILD_MODNAME, reg, len);
 		return -EINVAL;
@@ -54,11 +54,11 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
-	ret = i2c_transfer(priv->i2c, msg, 1);
+	ret = i2c_transfer(dev->i2c, msg, 1);
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+		dev_warn(&dev->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
 				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
@@ -66,28 +66,28 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 }
 
 /* read multiple hardware registers */
-static int rtl2830_rd(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
+static int rtl2830_rd(struct rtl2830_dev *dev, u8 reg, u8 *val, int len)
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
 
-	ret = i2c_transfer(priv->i2c, msg, 2);
+	ret = i2c_transfer(dev->i2c, msg, 2);
 	if (ret == 2) {
 		ret = 0;
 	} else {
-		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+		dev_warn(&dev->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
 				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
@@ -95,7 +95,7 @@ static int rtl2830_rd(struct rtl2830_priv *priv, u8 reg, u8 *val, int len)
 }
 
 /* write multiple registers */
-static int rtl2830_wr_regs(struct rtl2830_priv *priv, u16 reg, const u8 *val,
+static int rtl2830_wr_regs(struct rtl2830_dev *dev, u16 reg, const u8 *val,
 		int len)
 {
 	int ret;
@@ -103,51 +103,51 @@ static int rtl2830_wr_regs(struct rtl2830_priv *priv, u16 reg, const u8 *val,
 	u8 page = (reg >> 8) & 0xff;
 
 	/* switch bank if needed */
-	if (page != priv->page) {
-		ret = rtl2830_wr(priv, 0x00, &page, 1);
+	if (page != dev->page) {
+		ret = rtl2830_wr(dev, 0x00, &page, 1);
 		if (ret)
 			return ret;
 
-		priv->page = page;
+		dev->page = page;
 	}
 
-	return rtl2830_wr(priv, reg2, val, len);
+	return rtl2830_wr(dev, reg2, val, len);
 }
 
 /* read multiple registers */
-static int rtl2830_rd_regs(struct rtl2830_priv *priv, u16 reg, u8 *val, int len)
+static int rtl2830_rd_regs(struct rtl2830_dev *dev, u16 reg, u8 *val, int len)
 {
 	int ret;
 	u8 reg2 = (reg >> 0) & 0xff;
 	u8 page = (reg >> 8) & 0xff;
 
 	/* switch bank if needed */
-	if (page != priv->page) {
-		ret = rtl2830_wr(priv, 0x00, &page, 1);
+	if (page != dev->page) {
+		ret = rtl2830_wr(dev, 0x00, &page, 1);
 		if (ret)
 			return ret;
 
-		priv->page = page;
+		dev->page = page;
 	}
 
-	return rtl2830_rd(priv, reg2, val, len);
+	return rtl2830_rd(dev, reg2, val, len);
 }
 
 /* read single register */
-static int rtl2830_rd_reg(struct rtl2830_priv *priv, u16 reg, u8 *val)
+static int rtl2830_rd_reg(struct rtl2830_dev *dev, u16 reg, u8 *val)
 {
-	return rtl2830_rd_regs(priv, reg, val, 1);
+	return rtl2830_rd_regs(dev, reg, val, 1);
 }
 
 /* write single register with mask */
-static int rtl2830_wr_reg_mask(struct rtl2830_priv *priv, u16 reg, u8 val, u8 mask)
+static int rtl2830_wr_reg_mask(struct rtl2830_dev *dev, u16 reg, u8 val, u8 mask)
 {
 	int ret;
 	u8 tmp;
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = rtl2830_rd_regs(priv, reg, &tmp, 1);
+		ret = rtl2830_rd_regs(dev, reg, &tmp, 1);
 		if (ret)
 			return ret;
 
@@ -156,16 +156,16 @@ static int rtl2830_wr_reg_mask(struct rtl2830_priv *priv, u16 reg, u8 val, u8 ma
 		val |= tmp;
 	}
 
-	return rtl2830_wr_regs(priv, reg, &val, 1);
+	return rtl2830_wr_regs(dev, reg, &val, 1);
 }
 
 /* read single register with mask */
-static int rtl2830_rd_reg_mask(struct rtl2830_priv *priv, u16 reg, u8 *val, u8 mask)
+static int rtl2830_rd_reg_mask(struct rtl2830_dev *dev, u16 reg, u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 tmp;
 
-	ret = rtl2830_rd_regs(priv, reg, &tmp, 1);
+	ret = rtl2830_rd_regs(dev, reg, &tmp, 1);
 	if (ret)
 		return ret;
 
@@ -183,7 +183,7 @@ static int rtl2830_rd_reg_mask(struct rtl2830_priv *priv, u16 reg, u8 *val, u8 m
 
 static int rtl2830_init(struct dvb_frontend *fe)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	int ret, i;
 	struct rtl2830_reg_val_mask tab[] = {
 		{ 0x00d, 0x01, 0x03 },
@@ -204,10 +204,10 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		{ 0x2f1, 0x20, 0xf8 },
 		{ 0x16d, 0x00, 0x01 },
 		{ 0x1a6, 0x00, 0x80 },
-		{ 0x106, priv->cfg.vtop, 0x3f },
-		{ 0x107, priv->cfg.krf, 0x3f },
+		{ 0x106, dev->cfg.vtop, 0x3f },
+		{ 0x107, dev->cfg.krf, 0x3f },
 		{ 0x112, 0x28, 0xff },
-		{ 0x103, priv->cfg.agc_targ_val, 0xff },
+		{ 0x103, dev->cfg.agc_targ_val, 0xff },
 		{ 0x00a, 0x02, 0x07 },
 		{ 0x140, 0x0c, 0x3c },
 		{ 0x140, 0x40, 0xc0 },
@@ -215,7 +215,7 @@ static int rtl2830_init(struct dvb_frontend *fe)
 		{ 0x15b, 0x28, 0x38 },
 		{ 0x15c, 0x05, 0x07 },
 		{ 0x15c, 0x28, 0x38 },
-		{ 0x115, priv->cfg.spec_inv, 0x01 },
+		{ 0x115, dev->cfg.spec_inv, 0x01 },
 		{ 0x16f, 0x01, 0x07 },
 		{ 0x170, 0x18, 0x38 },
 		{ 0x172, 0x0f, 0x0f },
@@ -225,17 +225,17 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	};
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = rtl2830_wr_reg_mask(priv, tab[i].reg, tab[i].val,
+		ret = rtl2830_wr_reg_mask(dev, tab[i].reg, tab[i].val,
 			tab[i].mask);
 		if (ret)
 			goto err;
 	}
 
-	ret = rtl2830_wr_regs(priv, 0x18f, "\x28\x00", 2);
+	ret = rtl2830_wr_regs(dev, 0x18f, "\x28\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_regs(priv, 0x195,
+	ret = rtl2830_wr_regs(dev, 0x195,
 		"\x04\x06\x0a\x12\x0a\x12\x1e\x28", 8);
 	if (ret)
 		goto err;
@@ -243,26 +243,26 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	/* TODO: spec init */
 
 	/* soft reset */
-	ret = rtl2830_wr_reg_mask(priv, 0x101, 0x04, 0x04);
+	ret = rtl2830_wr_reg_mask(dev, 0x101, 0x04, 0x04);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_reg_mask(priv, 0x101, 0x00, 0x04);
+	ret = rtl2830_wr_reg_mask(dev, 0x101, 0x00, 0x04);
 	if (ret)
 		goto err;
 
-	priv->sleeping = false;
+	dev->sleeping = false;
 
 	return ret;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2830_sleep(struct dvb_frontend *fe)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
-	priv->sleeping = true;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
+	dev->sleeping = true;
 	return 0;
 }
 
@@ -278,7 +278,7 @@ static int rtl2830_get_tune_settings(struct dvb_frontend *fe,
 
 static int rtl2830_set_frontend(struct dvb_frontend *fe)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u64 num;
@@ -308,7 +308,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		{0xae, 0xba, 0xf3, 0x26, 0x66, 0x64}, /* 8 MHz */
 	};
 
-	dev_dbg(&priv->i2c->dev,
+	dev_dbg(&dev->i2c->dev,
 			"%s: frequency=%d bandwidth_hz=%d inversion=%d\n",
 			__func__, c->frequency, c->bandwidth_hz, c->inversion);
 
@@ -327,11 +327,11 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		i = 2;
 		break;
 	default:
-		dev_dbg(&priv->i2c->dev, "%s: invalid bandwidth\n", __func__);
+		dev_dbg(&dev->i2c->dev, "%s: invalid bandwidth\n", __func__);
 		return -EINVAL;
 	}
 
-	ret = rtl2830_wr_reg_mask(priv, 0x008, i << 1, 0x06);
+	ret = rtl2830_wr_reg_mask(dev, 0x008, i << 1, 0x06);
 	if (ret)
 		goto err;
 
@@ -344,15 +344,15 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	num = if_frequency % priv->cfg.xtal;
+	num = if_frequency % dev->cfg.xtal;
 	num *= 0x400000;
-	num = div_u64(num, priv->cfg.xtal);
+	num = div_u64(num, dev->cfg.xtal);
 	num = -num;
 	if_ctl = num & 0x3fffff;
-	dev_dbg(&priv->i2c->dev, "%s: if_frequency=%d if_ctl=%08x\n",
+	dev_dbg(&dev->i2c->dev, "%s: if_frequency=%d if_ctl=%08x\n",
 			__func__, if_frequency, if_ctl);
 
-	ret = rtl2830_rd_reg_mask(priv, 0x119, &tmp, 0xc0); /* b[7:6] */
+	ret = rtl2830_rd_reg_mask(dev, 0x119, &tmp, 0xc0); /* b[7:6] */
 	if (ret)
 		goto err;
 
@@ -361,49 +361,49 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	buf[1] = (if_ctl >>  8) & 0xff;
 	buf[2] = (if_ctl >>  0) & 0xff;
 
-	ret = rtl2830_wr_regs(priv, 0x119, buf, 3);
+	ret = rtl2830_wr_regs(dev, 0x119, buf, 3);
 	if (ret)
 		goto err;
 
 	/* 1/2 split I2C write */
-	ret = rtl2830_wr_regs(priv, 0x11c, &bw_params1[i][0], 17);
+	ret = rtl2830_wr_regs(dev, 0x11c, &bw_params1[i][0], 17);
 	if (ret)
 		goto err;
 
 	/* 2/2 split I2C write */
-	ret = rtl2830_wr_regs(priv, 0x12d, &bw_params1[i][17], 17);
+	ret = rtl2830_wr_regs(dev, 0x12d, &bw_params1[i][17], 17);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_regs(priv, 0x19d, bw_params2[i], 6);
+	ret = rtl2830_wr_regs(dev, 0x19d, bw_params2[i], 6);
 	if (ret)
 		goto err;
 
 	return ret;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2830_get_frontend(struct dvb_frontend *fe)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
 
-	if (priv->sleeping)
+	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(priv, 0x33c, buf, 2);
+	ret = rtl2830_rd_regs(dev, 0x33c, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_rd_reg(priv, 0x351, &buf[2]);
+	ret = rtl2830_rd_reg(dev, 0x351, &buf[2]);
 	if (ret)
 		goto err;
 
-	dev_dbg(&priv->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
+	dev_dbg(&dev->i2c->dev, "%s: TPS=%*ph\n", __func__, 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
@@ -493,21 +493,21 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 tmp;
 	*status = 0;
 
-	if (priv->sleeping)
+	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_reg_mask(priv, 0x351, &tmp, 0x78); /* [6:3] */
+	ret = rtl2830_rd_reg_mask(dev, 0x351, &tmp, 0x78); /* [6:3] */
 	if (ret)
 		goto err;
 
@@ -521,13 +521,13 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	int ret, hierarchy, constellation;
 	u8 buf[2], tmp;
 	u16 tmp16;
@@ -539,12 +539,12 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 		{ 92888734, 92888734, 95487525, 99770748 },
 	};
 
-	if (priv->sleeping)
+	if (dev->sleeping)
 		return 0;
 
 	/* reports SNR in resolution of 0.1 dB */
 
-	ret = rtl2830_rd_reg(priv, 0x33c, &tmp);
+	ret = rtl2830_rd_reg(dev, 0x33c, &tmp);
 	if (ret)
 		goto err;
 
@@ -556,7 +556,7 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 	if (hierarchy > HIERARCHY_NUM - 1)
 		goto err;
 
-	ret = rtl2830_rd_regs(priv, 0x40c, buf, 2);
+	ret = rtl2830_rd_regs(dev, 0x40c, buf, 2);
 	if (ret)
 		goto err;
 
@@ -570,20 +570,20 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
 static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 buf[2];
 
-	if (priv->sleeping)
+	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(priv, 0x34e, buf, 2);
+	ret = rtl2830_rd_regs(dev, 0x34e, buf, 2);
 	if (ret)
 		goto err;
 
@@ -591,7 +591,7 @@ static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -603,15 +603,15 @@ static int rtl2830_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct rtl2830_priv *priv = fe->demodulator_priv;
+	struct rtl2830_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 buf[2];
 	u16 if_agc_raw, if_agc;
 
-	if (priv->sleeping)
+	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(priv, 0x359, buf, 2);
+	ret = rtl2830_rd_regs(dev, 0x359, buf, 2);
 	if (ret)
 		goto err;
 
@@ -627,7 +627,7 @@ static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 	return 0;
 err:
-	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -675,10 +675,10 @@ static struct dvb_frontend_ops rtl2830_ops = {
 static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 {
 	struct i2c_client *client = mux_priv;
-	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	struct i2c_msg select_reg_page_msg[1] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = 2,
 			.buf = "\x00\x01",
@@ -686,7 +686,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 	};
 	struct i2c_msg gate_open_msg[1] = {
 		{
-			.addr = priv->cfg.i2c_addr,
+			.addr = dev->cfg.i2c_addr,
 			.flags = 0,
 			.len = 2,
 			.buf = "\x01\x08",
@@ -703,7 +703,7 @@ static int rtl2830_select(struct i2c_adapter *adap, void *mux_priv, u32 chan_id)
 		goto err;
 	}
 
-	priv->page = 1;
+	dev->page = 1;
 
 	/* open tuner I2C repeater for 1 xfer, closes automatically */
 	ret = __i2c_transfer(adap, gate_open_msg, 1);
@@ -723,20 +723,20 @@ err:
 
 static struct dvb_frontend *rtl2830_get_dvb_frontend(struct i2c_client *client)
 {
-	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	return &priv->fe;
+	return &dev->fe;
 }
 
 static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
 {
-	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	return priv->adapter;
+	return dev->adapter;
 }
 
 static int rtl2830_probe(struct i2c_client *client,
@@ -744,7 +744,7 @@ static int rtl2830_probe(struct i2c_client *client,
 {
 	struct rtl2830_platform_data *pdata = client->dev.platform_data;
 	struct i2c_adapter *i2c = client->adapter;
-	struct rtl2830_priv *priv;
+	struct rtl2830_dev *dev;
 	int ret;
 	u8 u8tmp;
 
@@ -756,39 +756,39 @@ static int rtl2830_probe(struct i2c_client *client,
 	}
 
 	/* allocate memory for the internal state */
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv == NULL) {
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
 	/* setup the state */
-	i2c_set_clientdata(client, priv);
-	priv->i2c = i2c;
-	priv->sleeping = true;
-	priv->cfg.i2c_addr = client->addr;
-	priv->cfg.xtal = pdata->clk;
-	priv->cfg.spec_inv = pdata->spec_inv;
-	priv->cfg.vtop = pdata->vtop;
-	priv->cfg.krf = pdata->krf;
-	priv->cfg.agc_targ_val = pdata->agc_targ_val;
+	i2c_set_clientdata(client, dev);
+	dev->i2c = i2c;
+	dev->sleeping = true;
+	dev->cfg.i2c_addr = client->addr;
+	dev->cfg.xtal = pdata->clk;
+	dev->cfg.spec_inv = pdata->spec_inv;
+	dev->cfg.vtop = pdata->vtop;
+	dev->cfg.krf = pdata->krf;
+	dev->cfg.agc_targ_val = pdata->agc_targ_val;
 
 	/* check if the demod is there */
-	ret = rtl2830_rd_reg(priv, 0x000, &u8tmp);
+	ret = rtl2830_rd_reg(dev, 0x000, &u8tmp);
 	if (ret)
 		goto err_kfree;
 
 	/* create muxed i2c adapter for tuner */
-	priv->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
+	dev->adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
 			client, 0, 0, 0, rtl2830_select, NULL);
-	if (priv->adapter == NULL) {
+	if (dev->adapter == NULL) {
 		ret = -ENODEV;
 		goto err_kfree;
 	}
 
 	/* create dvb frontend */
-	memcpy(&priv->fe.ops, &rtl2830_ops, sizeof(priv->fe.ops));
-	priv->fe.demodulator_priv = priv;
+	memcpy(&dev->fe.ops, &rtl2830_ops, sizeof(dev->fe.ops));
+	dev->fe.demodulator_priv = dev;
 
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2830_get_dvb_frontend;
@@ -798,7 +798,7 @@ static int rtl2830_probe(struct i2c_client *client,
 	return 0;
 
 err_kfree:
-	kfree(priv);
+	kfree(dev);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
@@ -806,12 +806,12 @@ err:
 
 static int rtl2830_remove(struct i2c_client *client)
 {
-	struct rtl2830_priv *priv = i2c_get_clientdata(client);
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-	i2c_del_mux_adapter(priv->adapter);
-	kfree(priv);
+	i2c_del_mux_adapter(dev->adapter);
+	kfree(dev);
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
index 545907a..9e7bd42 100644
--- a/drivers/media/dvb-frontends/rtl2830_priv.h
+++ b/drivers/media/dvb-frontends/rtl2830_priv.h
@@ -35,7 +35,7 @@ struct rtl2830_config {
 	u8 agc_targ_val;
 };
 
-struct rtl2830_priv {
+struct rtl2830_dev {
 	struct i2c_adapter *adapter;
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
-- 
http://palosaari.fi/

