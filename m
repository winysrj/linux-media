Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45888 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbbEEVmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:42:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/4] msi001: revise synthesizer calculation
Date: Wed,  6 May 2015 00:41:59 +0300
Message-Id: <1430862122-9326-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update synthesizer calculation to model I prefer nowadays. It is mostly
just renaming some variables, but also minor functionality change how
integer and fractional part are divided (using div_u64_rem()). Also, add
'schematic' of synthesizer following my current understanding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/msi001.c | 74 +++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index 74cfc3c..d0ec4e3 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -91,15 +91,15 @@ err:
 static int msi001_set_tuner(struct msi001 *s)
 {
 	int ret, i;
-	unsigned int n, m, thresh, frac, vco_step, tmp, f_if1;
+	unsigned int uitmp, div_n, k, k_thresh, k_frac, div_lo, f_if1;
 	u32 reg;
-	u64 f_vco, tmp64;
-	u8 mode, filter_mode, lo_div;
+	u64 f_vco;
+	u8 mode, filter_mode;
 
 	static const struct {
 		u32 rf;
 		u8 mode;
-		u8 lo_div;
+		u8 div_lo;
 	} band_lut[] = {
 		{ 50000000, 0xe1, 16}, /* AM_MODE2, antenna 2 */
 		{108000000, 0x42, 32}, /* VHF_MODE */
@@ -144,15 +144,15 @@ static int msi001_set_tuner(struct msi001 *s)
 	 */
 	unsigned int f_if = 0;
 	#define F_REF 24000000
-	#define R_REF 4
-	#define F_OUT_STEP 1
+	#define DIV_PRE_N 4
+	#define	F_VCO_STEP div_lo
 
 	dev_dbg(&s->spi->dev, "f_rf=%d f_if=%d\n", f_rf, f_if);
 
 	for (i = 0; i < ARRAY_SIZE(band_lut); i++) {
 		if (f_rf <= band_lut[i].rf) {
 			mode = band_lut[i].mode;
-			lo_div = band_lut[i].lo_div;
+			div_lo = band_lut[i].div_lo;
 			break;
 		}
 	}
@@ -200,32 +200,46 @@ static int msi001_set_tuner(struct msi001 *s)
 
 	dev_dbg(&s->spi->dev, "bandwidth selected=%d\n", bandwidth_lut[i].freq);
 
-	f_vco = (u64) (f_rf + f_if + f_if1) * lo_div;
-	tmp64 = f_vco;
-	m = do_div(tmp64, F_REF * R_REF);
-	n = (unsigned int) tmp64;
+	/*
+	 * Fractional-N synthesizer
+	 *
+	 *           +---------------------------------------+
+	 *           v                                       |
+	 *  Fref   +----+     +-------+         +----+     +------+     +---+
+	 * ------> | PD | --> |  VCO  | ------> | /4 | --> | /N.F | <-- | K |
+	 *         +----+     +-------+         +----+     +------+     +---+
+	 *                      |
+	 *                      |
+	 *                      v
+	 *                    +-------+  Fout
+	 *                    | /Rout | ------>
+	 *                    +-------+
+	 */
 
-	vco_step = F_OUT_STEP * lo_div;
-	thresh = (F_REF * R_REF) / vco_step;
-	frac = 1ul * thresh * m / (F_REF * R_REF);
+	/* Calculate PLL integer and fractional control word. */
+	f_vco = (u64) (f_rf + f_if + f_if1) * div_lo;
+	div_n = div_u64_rem(f_vco, DIV_PRE_N * F_REF, &k);
+	k_thresh = (DIV_PRE_N * F_REF) / F_VCO_STEP;
+	k_frac = div_u64((u64) k * k_thresh, (DIV_PRE_N * F_REF));
 
 	/* Find out greatest common divisor and divide to smaller. */
-	tmp = gcd(thresh, frac);
-	thresh /= tmp;
-	frac /= tmp;
+	uitmp = gcd(k_thresh, k_frac);
+	k_thresh /= uitmp;
+	k_frac /= uitmp;
 
 	/* Force divide to reg max. Resolution will be reduced. */
-	tmp = DIV_ROUND_UP(thresh, 4095);
-	thresh = DIV_ROUND_CLOSEST(thresh, tmp);
-	frac = DIV_ROUND_CLOSEST(frac, tmp);
+	uitmp = DIV_ROUND_UP(k_thresh, 4095);
+	k_thresh = DIV_ROUND_CLOSEST(k_thresh, uitmp);
+	k_frac = DIV_ROUND_CLOSEST(k_frac, uitmp);
 
-	/* calc real RF set */
-	tmp = 1ul * F_REF * R_REF * n;
-	tmp += 1ul * F_REF * R_REF * frac / thresh;
-	tmp /= lo_div;
+	/* Calculate real RF set. */
+	uitmp = (unsigned int) F_REF * DIV_PRE_N * div_n;
+	uitmp += (unsigned int) F_REF * DIV_PRE_N * k_frac / k_thresh;
+	uitmp /= div_lo;
 
-	dev_dbg(&s->spi->dev, "rf=%u:%u n=%d thresh=%d frac=%d\n",
-				f_rf, tmp, n, thresh, frac);
+	dev_dbg(&s->spi->dev,
+		"f_rf=%u:%u f_vco=%llu div_n=%u k_thresh=%u k_frac=%u div_lo=%u\n",
+		f_rf, uitmp, f_vco, div_n, k_thresh, k_frac, div_lo);
 
 	ret = msi001_wreg(s, 0x00000e);
 	if (ret)
@@ -246,7 +260,7 @@ static int msi001_set_tuner(struct msi001 *s)
 		goto err;
 
 	reg = 5 << 0;
-	reg |= thresh << 4;
+	reg |= k_thresh << 4;
 	reg |= 1 << 19;
 	reg |= 1 << 21;
 	ret = msi001_wreg(s, reg);
@@ -254,8 +268,8 @@ static int msi001_set_tuner(struct msi001 *s)
 		goto err;
 
 	reg = 2 << 0;
-	reg |= frac << 4;
-	reg |= n << 16;
+	reg |= k_frac << 4;
+	reg |= div_n << 16;
 	ret = msi001_wreg(s, reg);
 	if (ret)
 		goto err;
@@ -276,7 +290,7 @@ static int msi001_set_tuner(struct msi001 *s)
 err:
 	dev_dbg(&s->spi->dev, "failed %d\n", ret);
 	return ret;
-};
+}
 
 static int msi001_s_power(struct v4l2_subdev *sd, int on)
 {
-- 
http://palosaari.fi/

