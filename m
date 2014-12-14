Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaLNI3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:48 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/18] rtl2830: carry pointer to I2C client for every function
Date: Sun, 14 Dec 2014 10:28:30 +0200
Message-Id: <1418545723-9536-5-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a I2C driver struct i2c_client is top level structure representing
the driver. Use it as parameter to carry all needed information for
each function in order to simplify things.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2830.c | 97 +++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 43 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 44643d9..e7ba665 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -31,8 +31,9 @@
 #define MAX_XFER_SIZE  64
 
 /* write multiple hardware registers */
-static int rtl2830_wr(struct rtl2830_dev *dev, u8 reg, const u8 *val, int len)
+static int rtl2830_wr(struct i2c_client *client, u8 reg, const u8 *val, int len)
 {
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
@@ -66,8 +67,9 @@ static int rtl2830_wr(struct rtl2830_dev *dev, u8 reg, const u8 *val, int len)
 }
 
 /* read multiple hardware registers */
-static int rtl2830_rd(struct rtl2830_dev *dev, u8 reg, u8 *val, int len)
+static int rtl2830_rd(struct i2c_client *client, u8 reg, u8 *val, int len)
 {
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	struct i2c_msg msg[2] = {
 		{
@@ -95,59 +97,60 @@ static int rtl2830_rd(struct rtl2830_dev *dev, u8 reg, u8 *val, int len)
 }
 
 /* write multiple registers */
-static int rtl2830_wr_regs(struct rtl2830_dev *dev, u16 reg, const u8 *val,
-		int len)
+static int rtl2830_wr_regs(struct i2c_client *client, u16 reg, const u8 *val, int len)
 {
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 reg2 = (reg >> 0) & 0xff;
 	u8 page = (reg >> 8) & 0xff;
 
 	/* switch bank if needed */
 	if (page != dev->page) {
-		ret = rtl2830_wr(dev, 0x00, &page, 1);
+		ret = rtl2830_wr(client, 0x00, &page, 1);
 		if (ret)
 			return ret;
 
 		dev->page = page;
 	}
 
-	return rtl2830_wr(dev, reg2, val, len);
+	return rtl2830_wr(client, reg2, val, len);
 }
 
 /* read multiple registers */
-static int rtl2830_rd_regs(struct rtl2830_dev *dev, u16 reg, u8 *val, int len)
+static int rtl2830_rd_regs(struct i2c_client *client, u16 reg, u8 *val, int len)
 {
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 reg2 = (reg >> 0) & 0xff;
 	u8 page = (reg >> 8) & 0xff;
 
 	/* switch bank if needed */
 	if (page != dev->page) {
-		ret = rtl2830_wr(dev, 0x00, &page, 1);
+		ret = rtl2830_wr(client, 0x00, &page, 1);
 		if (ret)
 			return ret;
 
 		dev->page = page;
 	}
 
-	return rtl2830_rd(dev, reg2, val, len);
+	return rtl2830_rd(client, reg2, val, len);
 }
 
 /* read single register */
-static int rtl2830_rd_reg(struct rtl2830_dev *dev, u16 reg, u8 *val)
+static int rtl2830_rd_reg(struct i2c_client *client, u16 reg, u8 *val)
 {
-	return rtl2830_rd_regs(dev, reg, val, 1);
+	return rtl2830_rd_regs(client, reg, val, 1);
 }
 
 /* write single register with mask */
-static int rtl2830_wr_reg_mask(struct rtl2830_dev *dev, u16 reg, u8 val, u8 mask)
+static int rtl2830_wr_reg_mask(struct i2c_client *client, u16 reg, u8 val, u8 mask)
 {
 	int ret;
 	u8 tmp;
 
 	/* no need for read if whole reg is written */
 	if (mask != 0xff) {
-		ret = rtl2830_rd_regs(dev, reg, &tmp, 1);
+		ret = rtl2830_rd_regs(client, reg, &tmp, 1);
 		if (ret)
 			return ret;
 
@@ -156,16 +159,16 @@ static int rtl2830_wr_reg_mask(struct rtl2830_dev *dev, u16 reg, u8 val, u8 mask
 		val |= tmp;
 	}
 
-	return rtl2830_wr_regs(dev, reg, &val, 1);
+	return rtl2830_wr_regs(client, reg, &val, 1);
 }
 
 /* read single register with mask */
-static int rtl2830_rd_reg_mask(struct rtl2830_dev *dev, u16 reg, u8 *val, u8 mask)
+static int rtl2830_rd_reg_mask(struct i2c_client *client, u16 reg, u8 *val, u8 mask)
 {
 	int ret, i;
 	u8 tmp;
 
-	ret = rtl2830_rd_regs(dev, reg, &tmp, 1);
+	ret = rtl2830_rd_regs(client, reg, &tmp, 1);
 	if (ret)
 		return ret;
 
@@ -183,7 +186,8 @@ static int rtl2830_rd_reg_mask(struct rtl2830_dev *dev, u16 reg, u8 *val, u8 mas
 
 static int rtl2830_init(struct dvb_frontend *fe)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret, i;
 	struct rtl2830_reg_val_mask tab[] = {
 		{ 0x00d, 0x01, 0x03 },
@@ -225,17 +229,17 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	};
 
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
-		ret = rtl2830_wr_reg_mask(dev, tab[i].reg, tab[i].val,
+		ret = rtl2830_wr_reg_mask(client, tab[i].reg, tab[i].val,
 			tab[i].mask);
 		if (ret)
 			goto err;
 	}
 
-	ret = rtl2830_wr_regs(dev, 0x18f, "\x28\x00", 2);
+	ret = rtl2830_wr_regs(client, 0x18f, "\x28\x00", 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_regs(dev, 0x195,
+	ret = rtl2830_wr_regs(client, 0x195,
 		"\x04\x06\x0a\x12\x0a\x12\x1e\x28", 8);
 	if (ret)
 		goto err;
@@ -243,11 +247,11 @@ static int rtl2830_init(struct dvb_frontend *fe)
 	/* TODO: spec init */
 
 	/* soft reset */
-	ret = rtl2830_wr_reg_mask(dev, 0x101, 0x04, 0x04);
+	ret = rtl2830_wr_reg_mask(client, 0x101, 0x04, 0x04);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_reg_mask(dev, 0x101, 0x00, 0x04);
+	ret = rtl2830_wr_reg_mask(client, 0x101, 0x00, 0x04);
 	if (ret)
 		goto err;
 
@@ -261,7 +265,8 @@ err:
 
 static int rtl2830_sleep(struct dvb_frontend *fe)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	dev->sleeping = true;
 	return 0;
 }
@@ -278,7 +283,8 @@ static int rtl2830_get_tune_settings(struct dvb_frontend *fe,
 
 static int rtl2830_set_frontend(struct dvb_frontend *fe)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, i;
 	u64 num;
@@ -331,7 +337,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	ret = rtl2830_wr_reg_mask(dev, 0x008, i << 1, 0x06);
+	ret = rtl2830_wr_reg_mask(client, 0x008, i << 1, 0x06);
 	if (ret)
 		goto err;
 
@@ -352,7 +358,7 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	dev_dbg(&dev->i2c->dev, "%s: if_frequency=%d if_ctl=%08x\n",
 			__func__, if_frequency, if_ctl);
 
-	ret = rtl2830_rd_reg_mask(dev, 0x119, &tmp, 0xc0); /* b[7:6] */
+	ret = rtl2830_rd_reg_mask(client, 0x119, &tmp, 0xc0); /* b[7:6] */
 	if (ret)
 		goto err;
 
@@ -361,21 +367,21 @@ static int rtl2830_set_frontend(struct dvb_frontend *fe)
 	buf[1] = (if_ctl >>  8) & 0xff;
 	buf[2] = (if_ctl >>  0) & 0xff;
 
-	ret = rtl2830_wr_regs(dev, 0x119, buf, 3);
+	ret = rtl2830_wr_regs(client, 0x119, buf, 3);
 	if (ret)
 		goto err;
 
 	/* 1/2 split I2C write */
-	ret = rtl2830_wr_regs(dev, 0x11c, &bw_params1[i][0], 17);
+	ret = rtl2830_wr_regs(client, 0x11c, &bw_params1[i][0], 17);
 	if (ret)
 		goto err;
 
 	/* 2/2 split I2C write */
-	ret = rtl2830_wr_regs(dev, 0x12d, &bw_params1[i][17], 17);
+	ret = rtl2830_wr_regs(client, 0x12d, &bw_params1[i][17], 17);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_wr_regs(dev, 0x19d, bw_params2[i], 6);
+	ret = rtl2830_wr_regs(client, 0x19d, bw_params2[i], 6);
 	if (ret)
 		goto err;
 
@@ -387,7 +393,8 @@ err:
 
 static int rtl2830_get_frontend(struct dvb_frontend *fe)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
@@ -395,11 +402,11 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(dev, 0x33c, buf, 2);
+	ret = rtl2830_rd_regs(client, 0x33c, buf, 2);
 	if (ret)
 		goto err;
 
-	ret = rtl2830_rd_reg(dev, 0x351, &buf[2]);
+	ret = rtl2830_rd_reg(client, 0x351, &buf[2]);
 	if (ret)
 		goto err;
 
@@ -499,6 +506,7 @@ err:
 
 static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
+	struct i2c_client *client = fe->demodulator_priv;
 	struct rtl2830_dev *dev = fe->demodulator_priv;
 	int ret;
 	u8 tmp;
@@ -507,7 +515,7 @@ static int rtl2830_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_reg_mask(dev, 0x351, &tmp, 0x78); /* [6:3] */
+	ret = rtl2830_rd_reg_mask(client, 0x351, &tmp, 0x78); /* [6:3] */
 	if (ret)
 		goto err;
 
@@ -527,7 +535,8 @@ err:
 
 static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret, hierarchy, constellation;
 	u8 buf[2], tmp;
 	u16 tmp16;
@@ -544,7 +553,7 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 
 	/* reports SNR in resolution of 0.1 dB */
 
-	ret = rtl2830_rd_reg(dev, 0x33c, &tmp);
+	ret = rtl2830_rd_reg(client, 0x33c, &tmp);
 	if (ret)
 		goto err;
 
@@ -556,7 +565,7 @@ static int rtl2830_read_snr(struct dvb_frontend *fe, u16 *snr)
 	if (hierarchy > HIERARCHY_NUM - 1)
 		goto err;
 
-	ret = rtl2830_rd_regs(dev, 0x40c, buf, 2);
+	ret = rtl2830_rd_regs(client, 0x40c, buf, 2);
 	if (ret)
 		goto err;
 
@@ -576,14 +585,15 @@ err:
 
 static int rtl2830_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 buf[2];
 
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(dev, 0x34e, buf, 2);
+	ret = rtl2830_rd_regs(client, 0x34e, buf, 2);
 	if (ret)
 		goto err;
 
@@ -603,7 +613,8 @@ static int rtl2830_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
-	struct rtl2830_dev *dev = fe->demodulator_priv;
+	struct i2c_client *client = fe->demodulator_priv;
+	struct rtl2830_dev *dev = i2c_get_clientdata(client);
 	int ret;
 	u8 buf[2];
 	u16 if_agc_raw, if_agc;
@@ -611,7 +622,7 @@ static int rtl2830_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	if (dev->sleeping)
 		return 0;
 
-	ret = rtl2830_rd_regs(dev, 0x359, buf, 2);
+	ret = rtl2830_rd_regs(client, 0x359, buf, 2);
 	if (ret)
 		goto err;
 
@@ -774,7 +785,7 @@ static int rtl2830_probe(struct i2c_client *client,
 	dev->cfg.agc_targ_val = pdata->agc_targ_val;
 
 	/* check if the demod is there */
-	ret = rtl2830_rd_reg(dev, 0x000, &u8tmp);
+	ret = rtl2830_rd_reg(client, 0x000, &u8tmp);
 	if (ret)
 		goto err_kfree;
 
@@ -788,7 +799,7 @@ static int rtl2830_probe(struct i2c_client *client,
 
 	/* create dvb frontend */
 	memcpy(&dev->fe.ops, &rtl2830_ops, sizeof(dev->fe.ops));
-	dev->fe.demodulator_priv = dev;
+	dev->fe.demodulator_priv = client;
 
 	/* setup callbacks */
 	pdata->get_dvb_frontend = rtl2830_get_dvb_frontend;
-- 
http://palosaari.fi/

