Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758508Ab3DAOnK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:43:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4/5] [media] mb86a20s: Use 'layer' instead of 'i' on all places
Date: Mon,  1 Apr 2013 11:41:58 -0300
Message-Id: <1364827319-18332-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364827319-18332-1-git-send-email-mchehab@redhat.com>
References: <20130401072529.GL18466@mwanda>
 <1364827319-18332-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We're using the anonymous 'i' to indicate the layer number
on several places on the driver. That's not good, as some
cut-and-paste type of change might be doing the wrong thing.

So, call it as "layer" everywhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 148 ++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 2666ff4..d25df75 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -650,7 +650,7 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i, rc;
+	int layer, rc;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -668,43 +668,43 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 
 	/* Get per-layer data */
 
-	for (i = 0; i < NUM_LAYERS; i++) {
+	for (layer = 0; layer < NUM_LAYERS; layer++) {
 		dev_dbg(&state->i2c->dev, "%s: getting data for layer %c.\n",
-			__func__, 'A' + i);
+			__func__, 'A' + layer);
 
-		rc = mb86a20s_get_segment_count(state, i);
+		rc = mb86a20s_get_segment_count(state, layer);
 		if (rc < 0)
 			goto noperlayer_error;
 		if (rc >= 0 && rc < 14) {
-			c->layer[i].segment_count = rc;
+			c->layer[layer].segment_count = rc;
 		} else {
-			c->layer[i].segment_count = 0;
-			state->estimated_rate[i] = 0;
+			c->layer[layer].segment_count = 0;
+			state->estimated_rate[layer] = 0;
 			continue;
 		}
-		c->isdbt_layer_enabled |= 1 << i;
-		rc = mb86a20s_get_modulation(state, i);
+		c->isdbt_layer_enabled |= 1 << layer;
+		rc = mb86a20s_get_modulation(state, layer);
 		if (rc < 0)
 			goto noperlayer_error;
 		dev_dbg(&state->i2c->dev, "%s: modulation %d.\n",
 			__func__, rc);
-		c->layer[i].modulation = rc;
-		rc = mb86a20s_get_fec(state, i);
+		c->layer[layer].modulation = rc;
+		rc = mb86a20s_get_fec(state, layer);
 		if (rc < 0)
 			goto noperlayer_error;
 		dev_dbg(&state->i2c->dev, "%s: FEC %d.\n",
 			__func__, rc);
-		c->layer[i].fec = rc;
-		rc = mb86a20s_get_interleaving(state, i);
+		c->layer[layer].fec = rc;
+		rc = mb86a20s_get_interleaving(state, layer);
 		if (rc < 0)
 			goto noperlayer_error;
 		dev_dbg(&state->i2c->dev, "%s: interleaving %d.\n",
 			__func__, rc);
-		c->layer[i].interleaving = rc;
-		mb86a20s_layer_bitrate(fe, i, c->layer[i].modulation,
-				       c->layer[i].fec,
-				       c->layer[i].interleaving,
-				       c->layer[i].segment_count);
+		c->layer[layer].interleaving = rc;
+		mb86a20s_layer_bitrate(fe, layer, c->layer[layer].modulation,
+				       c->layer[layer].fec,
+				       c->layer[layer].interleaving,
+				       c->layer[layer].segment_count);
 	}
 
 	rc = mb86a20s_writereg(state, 0x6d, 0x84);
@@ -1456,7 +1456,7 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 mer, cnr;
-	int rc, val, i;
+	int rc, val, layer;
 	struct linear_segments *segs;
 	unsigned segs_len;
 
@@ -1478,27 +1478,27 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 	}
 
 	/* Read all layers */
-	for (i = 0; i < NUM_LAYERS; i++) {
-		if (!(c->isdbt_layer_enabled & (1 << i))) {
-			c->cnr.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+	for (layer = 0; layer < NUM_LAYERS; layer++) {
+		if (!(c->isdbt_layer_enabled & (1 << layer))) {
+			c->cnr.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
 			continue;
 		}
 
-		rc = mb86a20s_writereg(state, 0x50, 0x52 + i * 3);
+		rc = mb86a20s_writereg(state, 0x50, 0x52 + layer * 3);
 		if (rc < 0)
 			return rc;
 		rc = mb86a20s_readreg(state, 0x51);
 		if (rc < 0)
 			return rc;
 		mer = rc << 16;
-		rc = mb86a20s_writereg(state, 0x50, 0x53 + i * 3);
+		rc = mb86a20s_writereg(state, 0x50, 0x53 + layer * 3);
 		if (rc < 0)
 			return rc;
 		rc = mb86a20s_readreg(state, 0x51);
 		if (rc < 0)
 			return rc;
 		mer |= rc << 8;
-		rc = mb86a20s_writereg(state, 0x50, 0x54 + i * 3);
+		rc = mb86a20s_writereg(state, 0x50, 0x54 + layer * 3);
 		if (rc < 0)
 			return rc;
 		rc = mb86a20s_readreg(state, 0x51);
@@ -1506,7 +1506,7 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 			return rc;
 		mer |= rc;
 
-		switch (c->layer[i].modulation) {
+		switch (c->layer[layer].modulation) {
 		case DQPSK:
 		case QPSK:
 			segs = cnr_qpsk_table;
@@ -1524,12 +1524,12 @@ static int mb86a20s_get_blk_error_layer_CNR(struct dvb_frontend *fe)
 		}
 		cnr = interpolate_value(mer, segs, segs_len);
 
-		c->cnr.stat[1 + i].scale = FE_SCALE_DECIBEL;
-		c->cnr.stat[1 + i].svalue = cnr;
+		c->cnr.stat[1 + layer].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[1 + layer].svalue = cnr;
 
 		dev_dbg(&state->i2c->dev,
 			"%s: CNR for layer %c is %d.%03d dB (MER = %d).\n",
-			__func__, 'A' + i, cnr / 1000, cnr % 1000, mer);
+			__func__, 'A' + layer, cnr / 1000, cnr % 1000, mer);
 
 	}
 
@@ -1557,7 +1557,7 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int i;
+	int layer;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -1580,14 +1580,14 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 	c->strength.stat[0].uvalue = 0;
 
 	/* Put all of them at FE_SCALE_NOT_AVAILABLE */
-	for (i = 0; i < NUM_LAYERS + 1; i++) {
-		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->pre_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->pre_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->post_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->post_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->block_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->block_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+	for (layer = 0; layer < NUM_LAYERS + 1; layer++) {
+		c->cnr.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_error.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_count.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_error.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_error.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[layer].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 }
 
@@ -1595,7 +1595,7 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe, int status_nr)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int rc = 0, i;
+	int rc = 0, layer;
 	u32 bit_error = 0, bit_count = 0;
 	u32 t_pre_bit_error = 0, t_pre_bit_count = 0;
 	u32 t_post_bit_error = 0, t_post_bit_count = 0;
@@ -1619,90 +1619,90 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe, int status_nr)
 	if (status_nr < 9)
 		return 0;
 
-	for (i = 0; i < NUM_LAYERS; i++) {
-		if (c->isdbt_layer_enabled & (1 << i)) {
+	for (layer = 0; layer < NUM_LAYERS; layer++) {
+		if (c->isdbt_layer_enabled & (1 << layer)) {
 			/* Layer is active and has rc segments */
 			active_layers++;
 
 			/* Handle BER before vterbi */
-			rc = mb86a20s_get_pre_ber(fe, i,
+			rc = mb86a20s_get_pre_ber(fe, layer,
 						  &bit_error, &bit_count);
 			if (rc >= 0) {
-				c->pre_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->pre_bit_error.stat[1 + i].uvalue += bit_error;
-				c->pre_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->pre_bit_count.stat[1 + i].uvalue += bit_count;
+				c->pre_bit_error.stat[1 + layer].scale = FE_SCALE_COUNTER;
+				c->pre_bit_error.stat[1 + layer].uvalue += bit_error;
+				c->pre_bit_count.stat[1 + layer].scale = FE_SCALE_COUNTER;
+				c->pre_bit_count.stat[1 + layer].uvalue += bit_count;
 			} else if (rc != -EBUSY) {
 				/*
 					* If an I/O error happened,
 					* measures are now unavailable
 					*/
-				c->pre_bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
-				c->pre_bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->pre_bit_error.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
+				c->pre_bit_count.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
 				dev_err(&state->i2c->dev,
 					"%s: Can't get BER for layer %c (error %d).\n",
-					__func__, 'A' + i, rc);
+					__func__, 'A' + layer, rc);
 			}
-			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
+			if (c->block_error.stat[1 + layer].scale != FE_SCALE_NOT_AVAILABLE)
 				pre_ber_layers++;
 
 			/* Handle BER post vterbi */
-			rc = mb86a20s_get_post_ber(fe, i,
+			rc = mb86a20s_get_post_ber(fe, layer,
 						   &bit_error, &bit_count);
 			if (rc >= 0) {
-				c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->post_bit_error.stat[1 + i].uvalue += bit_error;
-				c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->post_bit_count.stat[1 + i].uvalue += bit_count;
+				c->post_bit_error.stat[1 + layer].scale = FE_SCALE_COUNTER;
+				c->post_bit_error.stat[1 + layer].uvalue += bit_error;
+				c->post_bit_count.stat[1 + layer].scale = FE_SCALE_COUNTER;
+				c->post_bit_count.stat[1 + layer].uvalue += bit_count;
 			} else if (rc != -EBUSY) {
 				/*
 					* If an I/O error happened,
 					* measures are now unavailable
 					*/
-				c->post_bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
-				c->post_bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->post_bit_error.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
+				c->post_bit_count.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
 				dev_err(&state->i2c->dev,
 					"%s: Can't get BER for layer %c (error %d).\n",
-					__func__, 'A' + i, rc);
+					__func__, 'A' + layer, rc);
 			}
-			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
+			if (c->block_error.stat[1 + layer].scale != FE_SCALE_NOT_AVAILABLE)
 				post_ber_layers++;
 
 			/* Handle Block errors for PER/UCB reports */
-			rc = mb86a20s_get_blk_error(fe, i,
+			rc = mb86a20s_get_blk_error(fe, layer,
 						&block_error,
 						&block_count);
 			if (rc >= 0) {
-				c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->block_error.stat[1 + i].uvalue += block_error;
-				c->block_count.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->block_count.stat[1 + i].uvalue += block_count;
+				c->block_error.stat[1 + layer].scale = FE_SCALE_COUNTER;
+				c->block_error.stat[1 + layer].uvalue += block_error;
+				c->block_count.stat[1 + layer].scale = FE_SCALE_COUNTER;
+				c->block_count.stat[1 + layer].uvalue += block_count;
 			} else if (rc != -EBUSY) {
 				/*
 					* If an I/O error happened,
 					* measures are now unavailable
 					*/
-				c->block_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
-				c->block_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->block_error.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
+				c->block_count.stat[1 + layer].scale = FE_SCALE_NOT_AVAILABLE;
 				dev_err(&state->i2c->dev,
 					"%s: Can't get PER for layer %c (error %d).\n",
-					__func__, 'A' + i, rc);
+					__func__, 'A' + layer, rc);
 
 			}
-			if (c->block_error.stat[1 + i].scale != FE_SCALE_NOT_AVAILABLE)
+			if (c->block_error.stat[1 + layer].scale != FE_SCALE_NOT_AVAILABLE)
 				per_layers++;
 
 			/* Update total preBER */
-			t_pre_bit_error += c->pre_bit_error.stat[1 + i].uvalue;
-			t_pre_bit_count += c->pre_bit_count.stat[1 + i].uvalue;
+			t_pre_bit_error += c->pre_bit_error.stat[1 + layer].uvalue;
+			t_pre_bit_count += c->pre_bit_count.stat[1 + layer].uvalue;
 
 			/* Update total postBER */
-			t_post_bit_error += c->post_bit_error.stat[1 + i].uvalue;
-			t_post_bit_count += c->post_bit_count.stat[1 + i].uvalue;
+			t_post_bit_error += c->post_bit_error.stat[1 + layer].uvalue;
+			t_post_bit_count += c->post_bit_count.stat[1 + layer].uvalue;
 
 			/* Update total PER */
-			t_block_error += c->block_error.stat[1 + i].uvalue;
-			t_block_count += c->block_count.stat[1 + i].uvalue;
+			t_block_error += c->block_error.stat[1 + layer].uvalue;
+			t_block_count += c->block_count.stat[1 + layer].uvalue;
 		}
 	}
 
-- 
1.8.1.4

