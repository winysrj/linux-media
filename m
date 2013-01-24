Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967Ab3AXQ24 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 11:28:56 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0OGSukI002481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 11:28:56 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/5] [media] mb86a20s: add a logic for post-BER measurement
Date: Thu, 24 Jan 2013 14:28:50 -0200
Message-Id: <1359044931-13058-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
References: <1359044931-13058-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic here is similar to the preBER.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 220 +++++++++++++++++++++++++++++----
 1 file changed, 196 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 7d4e911..ed39ee1 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -104,13 +104,20 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x50, 0xae }, { 0x51, 0xff },
 	{ 0x50, 0xaf }, { 0x51, 0xff },
 
-	{ 0x5e, 0x00 },				/* Turn off BER after Viterbi */
-	{ 0x50, 0xdc }, { 0x51, 0x01 },
-	{ 0x50, 0xdd }, { 0x51, 0xf4 },
-	{ 0x50, 0xde }, { 0x51, 0x01 },
-	{ 0x50, 0xdf }, { 0x51, 0xf4 },
-	{ 0x50, 0xe0 }, { 0x51, 0x01 },
-	{ 0x50, 0xe1 }, { 0x51, 0xf4 },
+	/*
+	 * On this demod, post BER counts blocks. When the count reaches the
+	 * value below, it collects the block error count. The block counters
+	 * are initialized to 127 here. This warrants that all of them will be
+	 * quickly calculated when device gets locked. As TMCC is parsed, the
+	 * values will be adjusted later in the driver's code.
+	 */
+	{ 0x5e, 0x07 },				/* Turn on BER after Viterbi */
+	{ 0x50, 0xdc }, { 0x51, 0x00 },
+	{ 0x50, 0xdd }, { 0x51, 0x7f },
+	{ 0x50, 0xde }, { 0x51, 0x00 },
+	{ 0x50, 0xdf }, { 0x51, 0x7f },
+	{ 0x50, 0xe0 }, { 0x51, 0x00 },
+	{ 0x50, 0xe1 }, { 0x51, 0x7f },
 
 	/*
 	 * On this demod, when the block count reaches the count below,
@@ -187,12 +194,13 @@ static struct regdata mb86a20s_reset_reception[] = {
 	{ 0x08, 0x00 },
 };
 
-static struct regdata mb86a20s_vber_reset[] = {
-	{ 0x53, 0x00 },	/* VBER Counter reset */
+static struct regdata mb86a20s_per_ber_reset[] = {
+	{ 0x53, 0x00 },	/* pre BER Counter reset */
 	{ 0x53, 0x07 },
-};
 
-static struct regdata mb86a20s_per_reset[] = {
+	{ 0x5f, 0x00 },	/* post BER Counter reset */
+	{ 0x5f, 0x07 },
+
 	{ 0x50, 0xb1 },	/* PER Counter reset */
 	{ 0x51, 0x07 },
 	{ 0x51, 0x00 },
@@ -731,6 +739,8 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 		memset(&c->cnr, 0, sizeof(c->cnr));
 		memset(&c->pre_bit_error, 0, sizeof(c->pre_bit_error));
 		memset(&c->pre_bit_count, 0, sizeof(c->pre_bit_count));
+		memset(&c->post_bit_error, 0, sizeof(c->post_bit_error));
+		memset(&c->post_bit_count, 0, sizeof(c->post_bit_count));
 		memset(&c->block_error, 0, sizeof(c->block_error));
 		memset(&c->block_count, 0, sizeof(c->block_count));
 
@@ -739,13 +749,8 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 
 	/* Clear status for most stats */
 
-	/* BER counter reset */
-	rc = mb86a20s_writeregdata(state, mb86a20s_vber_reset);
-	if (rc < 0)
-		goto err;
-
-	/* MER, PER counter reset */
-	rc = mb86a20s_writeregdata(state, mb86a20s_per_reset);
+	/* BER/PER counter reset */
+	rc = mb86a20s_writeregdata(state, mb86a20s_per_ber_reset);
 	if (rc < 0)
 		goto err;
 
@@ -915,7 +920,124 @@ static int mb86a20s_get_pre_ber(struct dvb_frontend *fe,
 		rc = mb86a20s_writereg(state, 0x53, val | (1 << layer));
 	}
 
+	return rc;
+}
+
+static int mb86a20s_get_post_ber(struct dvb_frontend *fe,
+				 unsigned layer,
+				  u32 *error, u32 *count)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	u32 counter, collect_rate;
+	int rc, val;
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
+	if (layer >= 3)
+		return -EINVAL;
+
+	/* Check if the BER measures are already available */
+	rc = mb86a20s_readreg(state, 0x60);
+	if (rc < 0)
+		return rc;
+
+	/* Check if data is available for that layer */
+	if (!(rc & (1 << layer))) {
+		dev_dbg(&state->i2c->dev,
+			"%s: post BER for layer %c is not available yet.\n",
+			__func__, 'A' + layer);
+		return -EBUSY;
+	}
 
+	/* Read Bit Error Count */
+	rc = mb86a20s_readreg(state, 0x64 + layer * 3);
+	if (rc < 0)
+		return rc;
+	*error = rc << 16;
+	rc = mb86a20s_readreg(state, 0x65 + layer * 3);
+	if (rc < 0)
+		return rc;
+	*error |= rc << 8;
+	rc = mb86a20s_readreg(state, 0x66 + layer * 3);
+	if (rc < 0)
+		return rc;
+	*error |= rc;
+
+	dev_dbg(&state->i2c->dev,
+		"%s: post bit error for layer %c: %d.\n",
+		__func__, 'A' + layer, *error);
+
+	/* Read Bit Count */
+	rc = mb86a20s_writereg(state, 0x50, 0xdc + layer * 2);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	counter = rc << 8;
+	rc = mb86a20s_writereg(state, 0x50, 0xdd + layer * 2);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	counter |= rc;
+	*count = counter * 204 * 8;
+
+	dev_dbg(&state->i2c->dev,
+		"%s: post bit count for layer %c: %d.\n",
+		__func__, 'A' + layer, *count);
+
+	/*
+	 * As we get TMCC data from the frontend, we can better estimate the
+	 * BER bit counters, in order to do the BER measure during a longer
+	 * time. Use those data, if available, to update the bit count
+	 * measure.
+	 */
+
+	if (!state->estimated_rate[layer])
+		goto reset_measurement;
+
+	collect_rate = state->estimated_rate[layer] / 204 / 8;
+	if (collect_rate < 32)
+		collect_rate = 32;
+	if (collect_rate > 65535)
+		collect_rate = 65535;
+	if (collect_rate != counter) {
+		dev_dbg(&state->i2c->dev,
+			"%s: updating postBER counter on layer %c to %d.\n",
+			__func__, 'A' + layer, collect_rate);
+
+		/* Turn off BER after Viterbi */
+		rc = mb86a20s_writereg(state, 0x5e, 0x00);
+
+		/* Update counter for this layer */
+		rc = mb86a20s_writereg(state, 0x50, 0xdc + layer * 2);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, collect_rate >> 8);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x50, 0xdd + layer * 2);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, collect_rate & 0xff);
+		if (rc < 0)
+			return rc;
+
+		/* Turn on BER after Viterbi */
+		rc = mb86a20s_writereg(state, 0x5e, 0x07);
+
+		/* Reset all preBER counters */
+		rc = mb86a20s_writereg(state, 0x5f, 0x00);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x5f, 0x07);
+
+		return rc;
+	}
+
+reset_measurement:
 	/* Reset counter to collect new data */
 	rc = mb86a20s_readreg(state, 0x5f);
 	if (rc < 0)
@@ -924,7 +1046,7 @@ static int mb86a20s_get_pre_ber(struct dvb_frontend *fe,
 	rc = mb86a20s_writereg(state, 0x5f, val & ~(1 << layer));
 	if (rc < 0)
 		return rc;
-	rc = mb86a20s_writereg(state, 0x5f, val);
+	rc = mb86a20s_writereg(state, 0x5f, val | (1 << layer));
 
 	return rc;
 }
@@ -1417,6 +1539,8 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 	c->cnr.len = 4;
 	c->pre_bit_error.len = 4;
 	c->pre_bit_count.len = 4;
+	c->post_bit_error.len = 4;
+	c->post_bit_count.len = 4;
 	c->block_error.len = 4;
 	c->block_count.len = 4;
 
@@ -1429,6 +1553,8 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->pre_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->pre_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 	}
@@ -1441,9 +1567,11 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	int rc = 0, i;
 	u32 bit_error = 0, bit_count = 0;
 	u32 t_pre_bit_error = 0, t_pre_bit_count = 0;
+	u32 t_post_bit_error = 0, t_post_bit_count = 0;
 	u32 block_error = 0, block_count = 0;
 	u32 t_block_error = 0, t_block_count = 0;
-	int active_layers = 0, ber_layers = 0, per_layers = 0;
+	int active_layers = 0, pre_ber_layers = 0, post_ber_layers = 0;
+	int per_layers = 0;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -1457,7 +1585,6 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 			/* Layer is active and has rc segments */
 			active_layers++;
 
-			/* Read per-layer BER */
 			/* Handle BER before vterbi */
 			rc = mb86a20s_get_pre_ber(fe, i,
 						  &bit_error, &bit_count);
@@ -1479,7 +1606,30 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 			}
 
 			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
-				ber_layers++;
+				pre_ber_layers++;
+
+			/* Handle BER post vterbi */
+			rc = mb86a20s_get_post_ber(fe, i,
+						   &bit_error, &bit_count);
+			if (rc >= 0) {
+				c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->post_bit_error.stat[1 + i].uvalue += bit_error;
+				c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->post_bit_count.stat[1 + i].uvalue += bit_count;
+			} else if (rc != -EBUSY) {
+				/*
+					* If an I/O error happened,
+					* measures are now unavailable
+					*/
+				c->post_bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->post_bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				dev_err(&state->i2c->dev,
+					"%s: Can't get BER for layer %c (error %d).\n",
+					__func__, 'A' + i, rc);
+			}
+
+			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
+				post_ber_layers++;
 
 			/* Handle Block errors for PER/UCB reports */
 			rc = mb86a20s_get_blk_error(fe, i,
@@ -1506,10 +1656,14 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
 				per_layers++;
 
-			/* Update total BER */
+			/* Update total preBER */
 			t_pre_bit_error += c->pre_bit_error.stat[1 + i].uvalue;
 			t_pre_bit_count += c->pre_bit_count.stat[1 + i].uvalue;
 
+			/* Update total postBER */
+			t_post_bit_error += c->post_bit_error.stat[1 + i].uvalue;
+			t_post_bit_count += c->post_bit_count.stat[1 + i].uvalue;
+
 			/* Update total PER */
 			t_block_error += c->block_error.stat[1 + i].uvalue;
 			t_block_count += c->block_count.stat[1 + i].uvalue;
@@ -1520,7 +1674,7 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	 * Start showing global count if at least one error count is
 	 * available.
 	 */
-	if (ber_layers) {
+	if (pre_ber_layers) {
 		/*
 		 * At least one per-layer BER measure was read. We can now
 		 * calculate the total BER
@@ -1534,6 +1688,24 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		c->pre_bit_count.stat[0].uvalue = t_pre_bit_count;
 	}
 
+	/*
+	 * Start showing global count if at least one error count is
+	 * available.
+	 */
+	if (post_ber_layers) {
+		/*
+		 * At least one per-layer BER measure was read. We can now
+		 * calculate the total BER
+		 *
+		 * Total Bit Error/Count is calculated as the sum of the
+		 * bit errors on all active layers.
+		 */
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = t_post_bit_error;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = t_post_bit_count;
+	}
+
 	if (per_layers) {
 		/*
 		 * At least one per-layer UCB measure was read. We can now
-- 
1.8.1

