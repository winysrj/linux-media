Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45988 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbbCXVNK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/8] ts2020: add support for TS2022
Date: Tue, 24 Mar 2015 23:12:06 +0200
Message-Id: <1427231533-4277-2-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TS2022 is slightly newer and different version of same tuner, which
could be supported with rather small changes. Tuner type is
auto-detected.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 120 ++++++++++++++++++++++++++++++-----
 drivers/media/dvb-frontends/ts2020.h |  25 +++++++-
 2 files changed, 129 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 9aba044..24c4712 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -29,9 +29,19 @@ struct ts2020_priv {
 	/* i2c details */
 	int i2c_address;
 	struct i2c_adapter *i2c;
-	u8 clk_out_div;
+	u8 clk_out:2;
+	u8 clk_out_div:5;
 	u32 frequency;
 	u32 frequency_div;
+#define TS2020_M88TS2020 0
+#define TS2020_M88TS2022 1
+	u8 tuner;
+	u8 loop_through:1;
+};
+
+struct ts2020_reg_val {
+	u8 reg;
+	u8 val;
 };
 
 static int ts2020_release(struct dvb_frontend *fe)
@@ -121,6 +131,9 @@ static int ts2020_sleep(struct dvb_frontend *fe)
 		.len = 2
 	};
 
+	if (priv->tuner == TS2020_M88TS2022)
+		buf[0] = 0x00;
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -137,15 +150,64 @@ static int ts2020_sleep(struct dvb_frontend *fe)
 static int ts2020_init(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
+	int i;
+	u8 u8tmp;
+
+	if (priv->tuner == TS2020_M88TS2020) {
+		ts2020_writereg(fe, 0x42, 0x73);
+		ts2020_writereg(fe, 0x05, priv->clk_out_div);
+		ts2020_writereg(fe, 0x20, 0x27);
+		ts2020_writereg(fe, 0x07, 0x02);
+		ts2020_writereg(fe, 0x11, 0xff);
+		ts2020_writereg(fe, 0x60, 0xf9);
+		ts2020_writereg(fe, 0x08, 0x01);
+		ts2020_writereg(fe, 0x00, 0x41);
+	} else {
+		static const struct ts2020_reg_val reg_vals[] = {
+			{0x7d, 0x9d},
+			{0x7c, 0x9a},
+			{0x7a, 0x76},
+			{0x3b, 0x01},
+			{0x63, 0x88},
+			{0x61, 0x85},
+			{0x22, 0x30},
+			{0x30, 0x40},
+			{0x20, 0x23},
+			{0x24, 0x02},
+			{0x12, 0xa0},
+		};
+
+		ts2020_writereg(fe, 0x00, 0x01);
+		ts2020_writereg(fe, 0x00, 0x03);
+
+		switch (priv->clk_out) {
+		case TS2020_CLK_OUT_DISABLED:
+			u8tmp = 0x60;
+			break;
+		case TS2020_CLK_OUT_ENABLED:
+			u8tmp = 0x70;
+			ts2020_writereg(fe, 0x05, priv->clk_out_div);
+			break;
+		case TS2020_CLK_OUT_ENABLED_XTALOUT:
+			u8tmp = 0x6c;
+			break;
+		default:
+			u8tmp = 0x60;
+			break;
+		}
+
+		ts2020_writereg(fe, 0x42, u8tmp);
+
+		if (priv->loop_through)
+			u8tmp = 0xec;
+		else
+			u8tmp = 0x6c;
 
-	ts2020_writereg(fe, 0x42, 0x73);
-	ts2020_writereg(fe, 0x05, priv->clk_out_div);
-	ts2020_writereg(fe, 0x20, 0x27);
-	ts2020_writereg(fe, 0x07, 0x02);
-	ts2020_writereg(fe, 0x11, 0xff);
-	ts2020_writereg(fe, 0x60, 0xf9);
-	ts2020_writereg(fe, 0x08, 0x01);
-	ts2020_writereg(fe, 0x00, 0x41);
+		ts2020_writereg(fe, 0x62, u8tmp);
+
+		for (i = 0; i < ARRAY_SIZE(reg_vals); i++)
+			ts2020_writereg(fe, reg_vals[i].reg, reg_vals[i].val);
+	}
 
 	return 0;
 }
@@ -203,7 +265,14 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	ndiv = ndiv + ndiv % 2;
 	ndiv = ndiv - 1024;
 
-	ret = ts2020_writereg(fe, 0x10, 0x80 | lo);
+	if (priv->tuner == TS2020_M88TS2020) {
+		lpf_coeff = 2766;
+		ret = ts2020_writereg(fe, 0x10, 0x80 | lo);
+	} else {
+		lpf_coeff = 3200;
+		ret = ts2020_writereg(fe, 0x10, 0x0b);
+		ret |= ts2020_writereg(fe, 0x11, 0x40);
+	}
 
 	/* Set frequency divider */
 	ret |= ts2020_writereg(fe, 0x01, (ndiv >> 8) & 0xf);
@@ -220,7 +289,8 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x08);
 
 	/* Tuner RF */
-	ret |= ts2020_set_tuner_rf(fe);
+	if (priv->tuner == TS2020_M88TS2020)
+		ret |= ts2020_set_tuner_rf(fe);
 
 	gdiv28 = (TS2020_XTAL_FREQ / 1000 * 1694 + 500) / 1000;
 	ret |= ts2020_writereg(fe, 0x04, gdiv28 & 0xff);
@@ -228,6 +298,15 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
+	if (priv->tuner == TS2020_M88TS2022) {
+		ret = ts2020_writereg(fe, 0x25, 0x00);
+		ret |= ts2020_writereg(fe, 0x27, 0x70);
+		ret |= ts2020_writereg(fe, 0x41, 0x09);
+		ret |= ts2020_writereg(fe, 0x08, 0x0b);
+		if (ret < 0)
+			return -ENODEV;
+	}
+
 	value = ts2020_readreg(fe, 0x26);
 
 	f3db = (symbol_rate * 135) / 200 + 2000;
@@ -243,8 +322,6 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	if (mlpf_max > 63)
 		mlpf_max = 63;
 
-	lpf_coeff = 2766;
-
 	nlpf = (f3db * gdiv28 * 2 / lpf_coeff /
 		(TS2020_XTAL_FREQ / 1000)  + 1) / 2;
 	if (nlpf > 23)
@@ -285,6 +362,13 @@ static int ts2020_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
 	*frequency = priv->frequency;
+
+	return 0;
+}
+
+static int ts2020_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	*frequency = 0; /* Zero-IF */
 	return 0;
 }
 
@@ -324,6 +408,7 @@ static struct dvb_tuner_ops ts2020_tuner_ops = {
 	.sleep = ts2020_sleep,
 	.set_params = ts2020_set_params,
 	.get_frequency = ts2020_get_frequency,
+	.get_if_frequency = ts2020_get_if_frequency,
 	.get_rf_strength = ts2020_read_signal_strength,
 };
 
@@ -340,6 +425,7 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 
 	priv->i2c_address = config->tuner_address;
 	priv->i2c = i2c;
+	priv->clk_out = config->clk_out;
 	priv->clk_out_div = config->clk_out_div;
 	priv->frequency_div = config->frequency_div;
 	fe->tuner_priv = priv;
@@ -358,9 +444,13 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 
 	/* Check the tuner version */
 	buf = ts2020_readreg(fe, 0x00);
-	if ((buf == 0x01) || (buf == 0x41) || (buf == 0x81))
+	if ((buf == 0x01) || (buf == 0x41) || (buf == 0x81)) {
 		printk(KERN_INFO "%s: Find tuner TS2020!\n", __func__);
-	else {
+		priv->tuner = TS2020_M88TS2020;
+	} else if ((buf == 0x83) || (buf == 0xc3)) {
+		printk(KERN_INFO "%s: Find tuner TS2022!\n", __func__);
+		priv->tuner = TS2020_M88TS2022;
+	} else {
 		printk(KERN_ERR "%s: Read tuner reg[0] = %d\n", __func__, buf);
 		kfree(priv);
 		return NULL;
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index b2fe6bb..8a08dcc 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -27,8 +27,31 @@
 
 struct ts2020_config {
 	u8 tuner_address;
-	u8 clk_out_div;
 	u32 frequency_div;
+
+	/*
+	 * RF loop-through
+	 */
+	u8 loop_through:1;
+
+	/*
+	 * clock output
+	 */
+#define TS2020_CLK_OUT_DISABLED        0
+#define TS2020_CLK_OUT_ENABLED         1
+#define TS2020_CLK_OUT_ENABLED_XTALOUT 2
+	u8 clk_out:2;
+
+	/*
+	 * clock output divider
+	 * 1 - 31
+	 */
+	u8 clk_out_div:5;
+
+	/*
+	 * pointer to DVB frontend
+	 */
+	struct dvb_frontend *fe;
 };
 
 #if IS_ENABLED(CONFIG_DVB_TS2020)
-- 
http://palosaari.fi/

