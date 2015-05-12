Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43538 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbbELRvK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 13:51:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 1/3] e4000: revise synthesizer calculation
Date: Tue, 12 May 2015 20:50:42 +0300
Message-Id: <1431453044-3775-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update synthesizer calculation to model I prefer nowadays. It is
mostly just renaming some variables to ones I think are most standard.
Also add 'schematic' of synthesizer following my current understanding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c      | 44 +++++++++++++++++++++++++++------------
 drivers/media/tuners/e4000_priv.h |  4 ++--
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 510239f..cda8bcf 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -115,8 +115,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
 {
 	struct e4000 *s = fe->tuner_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i, sigma_delta;
-	unsigned int pll_n, pll_f;
+	int ret, i;
+	unsigned int div_n, k, k_cw, div_out;
 	u64 f_vco;
 	u8 buf[5], i_data[4], q_data[4];
 
@@ -129,7 +129,21 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* PLL */
+	/*
+	 * Fractional-N synthesizer
+	 *
+	 *           +----------------------------+
+	 *           v                            |
+	 *  Fref   +----+     +-------+         +------+     +---+
+	 * ------> | PD | --> |  VCO  | ------> | /N.F | <-- | K |
+	 *         +----+     +-------+         +------+     +---+
+	 *                      |
+	 *                      |
+	 *                      v
+	 *                    +-------+  Fout
+	 *                    | /Rout | ------>
+	 *                    +-------+
+	 */
 	for (i = 0; i < ARRAY_SIZE(e4000_pll_lut); i++) {
 		if (c->frequency <= e4000_pll_lut[i].freq)
 			break;
@@ -140,18 +154,22 @@ static int e4000_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	f_vco = 1ull * c->frequency * e4000_pll_lut[i].mul;
-	pll_n = div_u64_rem(f_vco, s->clock, &pll_f);
-	sigma_delta = div_u64(0x10000ULL * pll_f, s->clock);
-	buf[0] = pll_n;
-	buf[1] = (sigma_delta >> 0) & 0xff;
-	buf[2] = (sigma_delta >> 8) & 0xff;
-	buf[3] = 0x00;
-	buf[4] = e4000_pll_lut[i].div;
+	#define F_REF s->clock
+	div_out = e4000_pll_lut[i].div_out;
+	f_vco = (u64) c->frequency * div_out;
+	/* calculate PLL integer and fractional control word */
+	div_n = div_u64_rem(f_vco, F_REF, &k);
+	k_cw = div_u64((u64) k * 0x10000, F_REF);
 
-	dev_dbg(&s->client->dev, "f_vco=%llu pll div=%d sigma_delta=%04x\n",
-			f_vco, buf[0], sigma_delta);
+	dev_dbg(&s->client->dev,
+		"frequency=%u f_vco=%llu F_REF=%u div_n=%u k=%u k_cw=%04x div_out=%u\n",
+		c->frequency, f_vco, F_REF, div_n, k, k_cw, div_out);
 
+	buf[0] = div_n;
+	buf[1] = (k_cw >> 0) & 0xff;
+	buf[2] = (k_cw >> 8) & 0xff;
+	buf[3] = 0x00;
+	buf[4] = e4000_pll_lut[i].div_out_reg;
 	ret = regmap_bulk_write(s->regmap, 0x09, buf, 5);
 	if (ret)
 		goto err;
diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
index cb00704..6214fc0 100644
--- a/drivers/media/tuners/e4000_priv.h
+++ b/drivers/media/tuners/e4000_priv.h
@@ -49,8 +49,8 @@ struct e4000 {
 
 struct e4000_pll {
 	u32 freq;
-	u8 div;
-	u8 mul;
+	u8 div_out_reg;
+	u8 div_out;
 };
 
 static const struct e4000_pll e4000_pll_lut[] = {
-- 
http://palosaari.fi/

