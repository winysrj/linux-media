Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab3AXNUA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 08:20:00 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0ODJxfk027892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Jan 2013 08:19:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] mb86a20s: add block count measures (PER/UCB)
Date: Thu, 24 Jan 2013 11:19:54 -0200
Message-Id: <1359033594-16303-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add both per-layer and global block error count and block count,
for PER and UCB measurements.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 190 +++++++++++++++++++++++++++++++--
 1 file changed, 180 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 4f3e222..4de5304 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -111,13 +111,21 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x50, 0xdf }, { 0x51, 0xf4 },
 	{ 0x50, 0xe0 }, { 0x51, 0x01 },
 	{ 0x50, 0xe1 }, { 0x51, 0xf4 },
-	{ 0x50, 0xb0 }, { 0x51, 0x07 },
-	{ 0x50, 0xb2 }, { 0x51, 0xff },
-	{ 0x50, 0xb3 }, { 0x51, 0xff },
-	{ 0x50, 0xb4 }, { 0x51, 0xff },
-	{ 0x50, 0xb5 }, { 0x51, 0xff },
-	{ 0x50, 0xb6 }, { 0x51, 0xff },
-	{ 0x50, 0xb7 }, { 0x51, 0xff },
+
+	/*
+	 * On this demod, when the block count reaches the count below,
+	 * it collects the block error count. The block counters are initialized
+	 * to 127 here. This warrants that all of them will be quickly
+	 * calculated when device gets locked. As TMCC is parsed, the values
+	 * will be adjusted later in the driver's code.
+	 */
+	{ 0x50, 0xb0 }, { 0x51, 0x07 },		/* Enable PER */
+	{ 0x50, 0xb2 }, { 0x51, 0x7f },
+	{ 0x50, 0xb3 }, { 0x51, 0x00 },
+	{ 0x50, 0xb4 }, { 0x51, 0x7f },
+	{ 0x50, 0xb5 }, { 0x51, 0x00 },
+	{ 0x50, 0xb6 }, { 0x51, 0x7f },
+	{ 0x50, 0xb7 }, { 0x51, 0x00 },
 
 	{ 0x50, 0x50 }, { 0x51, 0x02 },		/* MER manual mode */
 	{ 0x50, 0x51 }, { 0x51, 0x04 },		/* MER symbol 4 */
@@ -893,6 +901,123 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 	return 0;
 }
 
+static int mb86a20s_get_blk_error(struct dvb_frontend *fe,
+			    unsigned layer,
+			    u32 *error, u32 *count)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	int rc;
+	u32 collect_rate;
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
+	if (layer >= 3)
+		return -EINVAL;
+
+	/* Check if the PER measures are already available */
+	rc = mb86a20s_writereg(state, 0x50, 0xb8);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+
+	/* Check if data is available for that layer */
+
+	if (!(rc & (1 << layer))) {
+		dev_dbg(&state->i2c->dev,
+			"%s: block counts for layer %c aren't available yet.\n",
+			__func__, 'A' + layer);
+		return -EBUSY;
+	}
+
+	/* Read Packet error Count */
+	rc = mb86a20s_writereg(state, 0x50, 0xb9 + layer * 2);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*error = rc << 8;
+	rc = mb86a20s_writereg(state, 0x50, 0xba + layer * 2);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*error |= rc;
+	dev_err(&state->i2c->dev, "%s: block error for layer %c: %d.\n",
+		__func__, 'A' + layer, *error);
+
+	/* Read Bit Count */
+	rc = mb86a20s_writereg(state, 0x50, 0xb2 + layer * 2);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*count = rc << 8;
+	rc = mb86a20s_writereg(state, 0x50, 0xb3 + layer * 2);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	*count |= rc;
+
+	dev_dbg(&state->i2c->dev,
+		"%s: block count for layer %c: %d.\n",
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
+
+	if (collect_rate < 32)
+		collect_rate = 32;
+	if (collect_rate > 65535)
+		collect_rate = 65535;
+
+	if (collect_rate != *count) {
+		dev_dbg(&state->i2c->dev,
+			"%s: updating PER counter on layer %c to %d.\n",
+			__func__, 'A' + layer, collect_rate);
+		rc = mb86a20s_writereg(state, 0x50, 0xb2 + layer * 2);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, collect_rate >> 8);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x50, 0xb3 + layer * 2);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51, collect_rate & 0xff);
+		if (rc < 0)
+			return rc;
+	}
+
+reset_measurement:
+	/* Reset counter to collect new data */
+	rc = mb86a20s_writereg(state, 0x50, 0xb1);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x51, (1 << layer));
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x51, 0x00);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 struct linear_segments {
 	unsigned x, y;
 };
@@ -1115,7 +1240,7 @@ static int mb86a20s_get_main_CNR(struct dvb_frontend *fe)
 	return rc;
 }
 
-static int mb86a20s_get_per_layer_CNR(struct dvb_frontend *fe)
+static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1258,14 +1383,16 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	int rc = 0, i;
 	u32 bit_error = 0, bit_count = 0;
 	u32 t_pre_bit_error = 0, t_pre_bit_count = 0;
-	int active_layers = 0, ber_layers = 0;
+	u32 block_error = 0, block_count = 0;
+	u32 t_block_error = 0, t_block_count = 0;
+	int active_layers = 0, ber_layers = 0, per_layers = 0;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
 	mb86a20s_get_main_CNR(fe);
 
 	/* Get per-layer stats */
-	mb86a20s_get_per_layer_CNR(fe);
+	mb86a20s_get_blk_error_layer_CNR(fe);
 
 	for (i = 0; i < 3; i++) {
 		if (c->isdbt_layer_enabled & (1 << i)) {
@@ -1297,9 +1424,38 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
 				ber_layers++;
 
+			/* Handle Block errors for PER/UCB reports */
+			rc = mb86a20s_get_blk_error(fe, i,
+						&block_error,
+						&block_count);
+			if (rc >= 0) {
+				c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->block_error.stat[1 + i].uvalue += block_error;
+				c->block_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->block_count.stat[1 + i].uvalue += block_count;
+			} else if (rc != -EBUSY) {
+				/*
+					* If an I/O error happened,
+					* measures are now unavailable
+					*/
+				c->block_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->block_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				dev_err(&state->i2c->dev,
+					"%s: Can't get PER for layer %c (error %d).\n",
+					__func__, 'A' + i, rc);
+
+			}
+
+			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
+				per_layers++;
+
 			/* Update total BER */
 			t_pre_bit_error += c->pre_bit_error.stat[1 + i].uvalue;
 			t_pre_bit_count += c->pre_bit_count.stat[1 + i].uvalue;
+
+			/* Update total PER */
+			t_block_error += c->block_error.stat[1 + i].uvalue;
+			t_block_count += c->block_count.stat[1 + i].uvalue;
 		}
 	}
 
@@ -1321,6 +1477,20 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		c->pre_bit_count.stat[0].uvalue = t_pre_bit_count;
 	}
 
+	if (per_layers) {
+		/*
+		 * At least one per-layer UCB measure was read. We can now
+		 * calculate the total UCB
+		 *
+		 * Total block Error/Count is calculated as the sum of the
+		 * block errors on all active layers.
+		 */
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = t_block_error;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue = t_block_count;
+	}
+
 	return rc;
 }
 
-- 
1.8.1

