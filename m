Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab3LQSdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 13:33:47 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 6/6] [media] dib8000: improve block statistics
Date: Tue, 17 Dec 2013 13:30:46 -0200
Message-Id: <1387294246-10155-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
References: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PER/UCB statistics are collected once on each 1 second.
However, it doesn't provide the total number of packets
needed to calculate PER.

Yet, as we know the bit rate, it is possible to estimate
such number. So, do it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 109 +++++++++++++++++++++++-----------
 1 file changed, 75 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index c67a3dba116c..7539d7af2cf7 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -121,8 +121,9 @@ struct dib8000_state {
 
 	/* for DVBv5 stats */
 	s64 init_ucb;
-	unsigned long jiffies_stats;
-	unsigned long jiffies_stats_layer[3];
+	unsigned long per_jiffies_stats;
+	unsigned long ber_jiffies_stats;
+	unsigned long ber_jiffies_stats_layer[3];
 
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1_max;
@@ -1006,6 +1007,7 @@ static void dib8000_reset_stats(struct dvb_frontend *fe)
 	c->strength.len = 1;
 	c->cnr.len = 1;
 	c->block_error.len = 1;
+	c->block_count.len = 1;
 	c->post_bit_error.len = 1;
 	c->post_bit_count.len = 1;
 
@@ -1014,15 +1016,17 @@ static void dib8000_reset_stats(struct dvb_frontend *fe)
 
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	dib8000_read_unc_blocks(fe, &ucb);
 
 	state->init_ucb = -ucb;
-	state->jiffies_stats = 0;
-	memset(&state->jiffies_stats_layer, 0,
-	       sizeof(state->jiffies_stats_layer));
+	state->ber_jiffies_stats = 0;
+	state->per_jiffies_stats = 0;
+	memset(&state->ber_jiffies_stats_layer, 0,
+	       sizeof(state->ber_jiffies_stats_layer));
 }
 
 static int dib8000_reset(struct dvb_frontend *fe)
@@ -4059,7 +4063,9 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	struct dib8000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	int i;
-	u32 time_us, snr, val;
+	int show_per_stats = 0;
+	u32 time_us = 0, snr, val;
+	u64 blocks;
 	s32 db;
 	u16 strength;
 
@@ -4074,6 +4080,7 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	/* UCB/BER/CNR measures require lock */
 	if (!(stat & FE_HAS_LOCK)) {
 		c->cnr.len = 1;
+		c->block_count.len = 1;
 		c->block_error.len = 1;
 		c->post_bit_error.len = 1;
 		c->post_bit_count.len = 1;
@@ -4081,15 +4088,13 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		return 0;
 	}
 
 	/* Check if time for stats was elapsed */
-	if (time_after(jiffies, state->jiffies_stats)) {
-		time_us = dib8000_get_time_us(fe, -1);
-		state->jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
-
-		dprintk("Next all layers stats available in %u us.\n", time_us);
+	if (time_after(jiffies, state->per_jiffies_stats)) {
+		state->per_jiffies_stats = jiffies + msecs_to_jiffies(1000);
 
 		/* Get SNR */
 		snr = dib8000_get_snr(fe);
@@ -4108,7 +4113,34 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 		c->cnr.stat[0].svalue = snr;
 		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 
-		/* Get UCB and post-BER measures */
+		/* Get UCB measures */
+		dib8000_read_unc_blocks(fe, &val);
+		if (val < state->init_ucb)
+			state->init_ucb += 0x100000000L;
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = val + state->init_ucb;
+
+		/* Estimate the number of packets based on bitrate */
+		if (!time_us)
+			time_us = dib8000_get_time_us(fe, -1);
+
+		if (time_us) {
+			blocks = 1250000UL * 1000000UL;
+			do_div(blocks, time_us * 8 * 204);
+			c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+			c->block_count.stat[0].uvalue += blocks;
+		}
+
+		show_per_stats = 1;
+	}
+
+	/* Get post-BER measures */
+	if (time_after(jiffies, state->ber_jiffies_stats)) {
+		time_us = dib8000_get_time_us(fe, -1);
+		state->ber_jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
+
+		dprintk("Next all layers stats available in %u us.", time_us);
 
 		dib8000_read_ber(fe, &val);
 		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
@@ -4116,13 +4148,6 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 
 		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
 		c->post_bit_count.stat[0].uvalue += 100000000;
-
-		dib8000_read_unc_blocks(fe, &val);
-		if (val < state->init_ucb)
-			state->init_ucb += 1L << 32;
-
-		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[0].uvalue = val + state->init_ucb;
 	}
 
 	if (state->revision < 0x8002)
@@ -4133,27 +4158,43 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	c->post_bit_count.len = 4;
 
 	for (i = 0; i < 3; i++) {
-		if (!time_after(jiffies, state->jiffies_stats_layer[i]))
-			continue;
-		time_us = dib8000_get_time_us(fe, i);
-		if (!time_us)
+		unsigned nsegs = c->layer[i].segment_count;
+
+		if (nsegs == 0 || nsegs > 13)
 			continue;
 
-		state->jiffies_stats_layer[i] = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
-		dprintk("Next layer %c  stats will be available in %u us\n",
-			'A' + i, time_us);
+		time_us = 0;
+
+		if (time_after(jiffies, state->ber_jiffies_stats_layer[i])) {
+			time_us = dib8000_get_time_us(fe, i);
+
+			state->ber_jiffies_stats_layer[i] = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
+			dprintk("Next layer %c  stats will be available in %u us\n",
+				'A' + i, time_us);
 
-		val = dib8000_read_word(state, per_layer_regs[i].ber);
-		c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[1 + i].uvalue += val;
+			val = dib8000_read_word(state, per_layer_regs[i].ber);
+			c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+			c->post_bit_error.stat[1 + i].uvalue += val;
 
-		c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[1 + i].uvalue += 100000000;
+			c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+			c->post_bit_count.stat[1 + i].uvalue += 100000000;
+		}
+
+		if (show_per_stats) {
+			val = dib8000_read_word(state, per_layer_regs[i].per);
 
-		val = dib8000_read_word(state, per_layer_regs[i].per);
+			c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+			c->block_error.stat[1 + i].uvalue += val;
 
-		c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[1 + i].uvalue += val;
+			if (!time_us)
+				time_us = dib8000_get_time_us(fe, i);
+			if (time_us) {
+				blocks = 1250000UL * 1000000UL;
+				do_div(blocks, time_us * 8 * 204);
+				c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+				c->block_count.stat[0].uvalue += blocks;
+			}
+		}
 	}
 	return 0;
 }
-- 
1.8.3.1

