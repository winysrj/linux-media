Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38076 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbbFFL7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 07:59:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/8] ts2020: re-implement PLL calculations
Date: Sat,  6 Jun 2015 14:58:41 +0300
Message-Id: <1433591928-30915-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used frequency synthesizer is simple Integer-N PLL, with configurable
reference divider, output divider and of course N itself. Old
calculations were working fine, but not so easy to understand.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ts2020.c | 76 +++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 90164a3..bc48388 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -32,8 +32,8 @@ struct ts2020_priv {
 	struct i2c_adapter *i2c;
 	u8 clk_out:2;
 	u8 clk_out_div:5;
-	u32 frequency;
-	u32 frequency_div;
+	u32 frequency_div; /* LO output divider switch frequency */
+	u32 frequency_khz; /* actual used LO frequency */
 #define TS2020_M88TS2020 0
 #define TS2020_M88TS2022 1
 	u8 tuner;
@@ -233,45 +233,62 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct ts2020_priv *priv = fe->tuner_priv;
 	int ret;
-	u32 frequency = c->frequency;
-	s32 offset_khz;
 	u32 symbol_rate = (c->symbol_rate / 1000);
 	u32 f3db, gdiv28;
-	u16 value, ndiv, lpf_coeff;
-	u8 lpf_mxdiv, mlpf_max, mlpf_min, nlpf;
-	u8 lo = 0x01, div4 = 0x0;
-
-	/* Calculate frequency divider */
-	if (frequency < priv->frequency_div) {
-		lo |= 0x10;
-		div4 = 0x1;
-		ndiv = (frequency * 14 * 4) / TS2020_XTAL_FREQ;
-	} else
-		ndiv = (frequency * 14 * 2) / TS2020_XTAL_FREQ;
-	ndiv = ndiv + ndiv % 2;
-	ndiv = ndiv - 1024;
+	u16 u16tmp, value, lpf_coeff;
+	u8 buf[3], reg10, lpf_mxdiv, mlpf_max, mlpf_min, nlpf;
+	unsigned int f_ref_khz, f_vco_khz, div_ref, div_out, pll_n;
+	unsigned int frequency_khz = c->frequency;
+
+	/*
+	 * Integer-N PLL synthesizer
+	 * kHz is used for all calculations to keep calculations within 32-bit
+	 */
+	f_ref_khz = TS2020_XTAL_FREQ;
+	div_ref = DIV_ROUND_CLOSEST(f_ref_khz, 2000);
+
+	/* select LO output divider */
+	if (frequency_khz < priv->frequency_div) {
+		div_out = 4;
+		reg10 = 0x10;
+	} else {
+		div_out = 2;
+		reg10 = 0x00;
+	}
+
+	f_vco_khz = frequency_khz * div_out;
+	pll_n = f_vco_khz * div_ref / f_ref_khz;
+	pll_n += pll_n % 2;
+	priv->frequency_khz = pll_n * f_ref_khz / div_ref / div_out;
+
+	pr_debug("frequency=%u offset=%d f_vco_khz=%u pll_n=%u div_ref=%u div_out=%u\n",
+		 priv->frequency_khz, priv->frequency_khz - c->frequency,
+		 f_vco_khz, pll_n, div_ref, div_out);
 
 	if (priv->tuner == TS2020_M88TS2020) {
 		lpf_coeff = 2766;
-		ret = ts2020_writereg(fe, 0x10, 0x80 | lo);
+		reg10 |= 0x01;
+		ret = ts2020_writereg(fe, 0x10, reg10);
 	} else {
 		lpf_coeff = 3200;
-		ret = ts2020_writereg(fe, 0x10, 0x0b);
+		reg10 |= 0x0b;
+		ret = ts2020_writereg(fe, 0x10, reg10);
 		ret |= ts2020_writereg(fe, 0x11, 0x40);
 	}
 
-	/* Set frequency divider */
-	ret |= ts2020_writereg(fe, 0x01, (ndiv >> 8) & 0xf);
-	ret |= ts2020_writereg(fe, 0x02, ndiv & 0xff);
+	u16tmp = pll_n - 1024;
+	buf[0] = (u16tmp >> 8) & 0xff;
+	buf[1] = (u16tmp >> 0) & 0xff;
+	buf[2] = div_ref - 8;
+
+	ret |= ts2020_writereg(fe, 0x01, buf[0]);
+	ret |= ts2020_writereg(fe, 0x02, buf[1]);
+	ret |= ts2020_writereg(fe, 0x03, buf[2]);
 
-	ret |= ts2020_writereg(fe, 0x03, 0x06);
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x10);
 	if (ret < 0)
 		return -ENODEV;
 
-	/* Tuner Frequency Range */
-	ret = ts2020_writereg(fe, 0x10, lo);
-
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x08);
 
 	/* Tuner RF */
@@ -335,11 +352,6 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x01);
 
 	msleep(80);
-	/* calculate offset assuming 96000kHz*/
-	offset_khz = (ndiv - ndiv % 2 + 1024) * TS2020_XTAL_FREQ
-		/ (6 + 8) / (div4 + 1) / 2;
-
-	priv->frequency = offset_khz;
 
 	return (ret < 0) ? -EINVAL : 0;
 }
@@ -347,8 +359,8 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 static int ts2020_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
-	*frequency = priv->frequency;
 
+	*frequency = priv->frequency_khz;
 	return 0;
 }
 
-- 
http://palosaari.fi/

