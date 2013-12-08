Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60016 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760034Ab3LHWb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 13/18] m88ts2022: reimplement synthesizer calculations
Date: Mon,  9 Dec 2013 00:31:30 +0200
Message-Id: <1386541895-8634-14-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Used synthesizer is very typical integer-N PLL, with configurable
reference frequency divider, output frequency divider and of
course N itself. Most common method to calculate values is first
select output divider, then calculate VCO frequency and finally
calculate PLL N from VCO frequency. Do it that way.

Also make some cleanups for filter logic and signal strength.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/m88ts2022.c | 121 +++++++++++++++++----------------------
 1 file changed, 53 insertions(+), 68 deletions(-)

diff --git a/drivers/media/tuners/m88ts2022.c b/drivers/media/tuners/m88ts2022.c
index 4b3eec2..b11e740 100644
--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -175,27 +175,33 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret = 0, div;
-	u8 buf[3], u8tmp, cap_code, lpf_mxdiv, div_max, div_min;
-	u16 N_reg, N, K;
-	u32 lpf_gm, lpf_coeff, gdiv28, frequency_khz, frequency_offset;
-	u32 freq_3db;
+	int ret;
+	unsigned int frequency_khz, frequency_offset_khz, f_3db_hz;
+	unsigned int f_ref_khz, f_vco_khz, div_ref, div_out, pll_n, gdiv28;
+	u8 buf[3], u8tmp, cap_code, lpf_gm, lpf_mxdiv, div_max, div_min;
+	u16 u16tmp;
 	dev_dbg(&priv->i2c->dev,
 			"%s: frequency=%d symbol_rate=%d rolloff=%d\n",
 			__func__, c->frequency, c->symbol_rate, c->rolloff);
+	/*
+	 * Integer-N PLL synthesizer
+	 * kHz is used for all calculations to keep calculations within 32-bit
+	 */
+	f_ref_khz = DIV_ROUND_CLOSEST(priv->cfg->clock, 1000);
+	div_ref = DIV_ROUND_CLOSEST(f_ref_khz, 2000);
 
 	if (c->symbol_rate < 5000000)
-		frequency_offset = 3000000; /* 3 MHz */
+		frequency_offset_khz = 3000; /* 3 MHz */
 	else
-		frequency_offset = 0;
+		frequency_offset_khz = 0;
 
-	frequency_khz = c->frequency + (frequency_offset / 1000);
+	frequency_khz = c->frequency + frequency_offset_khz;
 
 	if (frequency_khz < 1103000) {
-		div = 2;
+		div_out = 4;
 		u8tmp = 0x1b;
 	} else {
-		div = 1;
+		div_out = 2;
 		u8tmp = 0x0b;
 	}
 
@@ -205,30 +211,30 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	K = DIV_ROUND_CLOSEST((priv->cfg->clock / 2), 1000000);
-	N = 1ul * frequency_khz * K * div * 2 / (priv->cfg->clock / 1000);
-	N += N % 2;
+	f_vco_khz = frequency_khz * div_out;
+	pll_n = f_vco_khz * div_ref / f_ref_khz;
+	pll_n += pll_n % 2;
+	priv->frequency_khz = pll_n * f_ref_khz / div_ref / div_out;
 
-	if (N < 4095)
-		N_reg = N - 1024;
-	else if (N < 6143)
-		N_reg = N + 1024;
+	if (pll_n < 4095)
+		u16tmp = pll_n - 1024;
+	else if (pll_n < 6143)
+		u16tmp = pll_n + 1024;
 	else
-		N_reg = N + 3072;
+		u16tmp = pll_n + 3072;
 
-	buf[0] = (N_reg >> 8) & 0x3f;
-	buf[1] = (N_reg >> 0) & 0xff;
-	buf[2] = K - 8;
+	buf[0] = (u16tmp >> 8) & 0x3f;
+	buf[1] = (u16tmp >> 0) & 0xff;
+	buf[2] = div_ref - 8;
 	ret = m88ts2022_wr_regs(priv, 0x01, buf, 3);
 	if (ret)
 		goto err;
 
-	priv->frequency_khz = 1ul * N * (priv->cfg->clock / 1000) / K / div / 2;
-
 	dev_dbg(&priv->i2c->dev,
-			"%s: frequency=%d offset=%d K=%d N=%d div=%d\n",
+			"%s: frequency=%u offset=%d f_vco_khz=%u pll_n=%u div_ref=%u div_out=%u\n",
 			__func__, priv->frequency_khz,
-			priv->frequency_khz - c->frequency, K, N, div);
+			priv->frequency_khz - c->frequency, f_vco_khz, pll_n,
+			div_ref, div_out);
 
 	ret = m88ts2022_cmd(fe, 0x10, 5, 0x15, 0x40, 0x00, NULL);
 	if (ret)
@@ -284,7 +290,8 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	gdiv28 = DIV_ROUND_CLOSEST(priv->cfg->clock / 1000000 * 1694, 1000);
+	/* filters */
+	gdiv28 = DIV_ROUND_CLOSEST(f_ref_khz * 1694U, 1000000U);
 
 	ret = m88ts2022_wr_reg(priv, 0x04, gdiv28);
 	if (ret)
@@ -309,35 +316,20 @@ static int m88ts2022_set_params(struct dvb_frontend *fe)
 	gdiv28 = gdiv28 * 207 / (cap_code * 2 + 151);
 	div_max = gdiv28 * 135 / 100;
 	div_min = gdiv28 * 78 / 100;
-	if (div_max > 63)
-		div_max = 63;
-
-	freq_3db = 1ul * c->symbol_rate * 135 / 200 + 2000000;
-	freq_3db += frequency_offset;
-	if (freq_3db < 7000000)
-		freq_3db = 7000000;
-	if (freq_3db > 40000000)
-		freq_3db = 40000000;
-
-	lpf_coeff = 3200;
-	lpf_gm = DIV_ROUND_CLOSEST(freq_3db * gdiv28, lpf_coeff *
-			(priv->cfg->clock / 1000));
-	if (lpf_gm > 23)
-		lpf_gm = 23;
-	if (lpf_gm < 1)
-		lpf_gm = 1;
-
-	lpf_mxdiv = DIV_ROUND_CLOSEST(lpf_gm * lpf_coeff *
-			(priv->cfg->clock / 1000), freq_3db);
-
-	if (lpf_mxdiv < div_min) {
-		lpf_gm++;
-		lpf_mxdiv = DIV_ROUND_CLOSEST(lpf_gm * lpf_coeff *
-				(priv->cfg->clock / 1000), freq_3db);
-	}
+	div_max = clamp_val(div_max, 0U, 63U);
+
+	f_3db_hz = c->symbol_rate * 135UL / 200UL;
+	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
+	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
 
-	if (lpf_mxdiv > div_max)
-		lpf_mxdiv = div_max;
+#define LPF_COEFF 3200U
+	lpf_gm = DIV_ROUND_CLOSEST(f_3db_hz * gdiv28, LPF_COEFF * f_ref_khz);
+	lpf_gm = clamp_val(lpf_gm, 1U, 23U);
+
+	lpf_mxdiv = DIV_ROUND_CLOSEST(lpf_gm * LPF_COEFF * f_ref_khz, f_3db_hz);
+	if (lpf_mxdiv < div_min)
+		lpf_mxdiv = DIV_ROUND_CLOSEST(++lpf_gm * LPF_COEFF * f_ref_khz, f_3db_hz);
+	lpf_mxdiv = clamp_val(lpf_mxdiv, 0U, div_max);
 
 	ret = m88ts2022_wr_reg(priv, 0x04, lpf_mxdiv);
 	if (ret)
@@ -492,44 +484,37 @@ static int m88ts2022_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int m88ts2022_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct m88ts2022_priv *priv = fe->tuner_priv;
-	u8  u8tmp, gain1, gain2, gain3;
-	u16 gain, u16tmp;
 	int ret;
+	u8 u8tmp;
+	u16 gain, u16tmp;
+	unsigned int gain1, gain2, gain3;
 
 	ret = m88ts2022_rd_reg(priv, 0x3d, &u8tmp);
 	if (ret)
 		goto err;
 
 	gain1 = (u8tmp >> 0) & 0x1f;
-	if (gain1 > 15)
-		gain1 = 15;
+	gain1 = clamp(gain1, 0U, 15U);
 
 	ret = m88ts2022_rd_reg(priv, 0x21, &u8tmp);
 	if (ret)
 		goto err;
 
 	gain2 = (u8tmp >> 0) & 0x1f;
-	if (gain2 < 2)
-		gain2 = 2;
-	if (gain2 > 16)
-		gain2 = 16;
+	gain2 = clamp(gain2, 2U, 16U);
 
 	ret = m88ts2022_rd_reg(priv, 0x66, &u8tmp);
 	if (ret)
 		goto err;
 
 	gain3 = (u8tmp >> 3) & 0x07;
-	if (gain3 > 6)
-		gain3 = 6;
+	gain3 = clamp(gain3, 0U, 6U);
 
 	gain = gain1 * 265 + gain2 * 338 + gain3 * 285;
 
 	/* scale value to 0x0000-0xffff */
 	u16tmp = (0xffff - gain);
-	if (u16tmp < 59000)
-		u16tmp = 59000;
-	else if (u16tmp > 61500)
-		u16tmp = 61500;
+	u16tmp = clamp_val(u16tmp, 59000U, 61500U);
 
 	*strength = (u16tmp - 59000) * 0xffff / (61500 - 59000);
 err:
-- 
1.8.4.2

