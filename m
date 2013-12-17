Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3LQSdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 13:33:47 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/6] [media] dib8000: be sure that stats are available before reading them
Date: Tue, 17 Dec 2013 13:30:45 -0200
Message-Id: <1387294246-10155-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
References: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On dib8000, the BER statistics are updated on every 1.25e6 bits.
Adjust the code to only update the statistics after having it
done.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 240 ++++++++++++++++++++++++++--------
 1 file changed, 182 insertions(+), 58 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index ef0d9ec0df23..c67a3dba116c 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -119,15 +119,17 @@ struct dib8000_state {
 	u8 longest_intlv_layer;
 	u16 output_mode;
 
+	/* for DVBv5 stats */
 	s64 init_ucb;
+	unsigned long jiffies_stats;
+	unsigned long jiffies_stats_layer[3];
+
 #ifdef DIB8000_AGC_FREEZE
 	u16 agc1_max;
 	u16 agc1_min;
 	u16 agc2_max;
 	u16 agc2_min;
 #endif
-
-	unsigned long get_stats_time;
 };
 
 enum dib8000_power_mode {
@@ -1016,7 +1018,11 @@ static void dib8000_reset_stats(struct dvb_frontend *fe)
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	dib8000_read_unc_blocks(fe, &ucb);
+
 	state->init_ucb = -ucb;
+	state->jiffies_stats = 0;
+	memset(&state->jiffies_stats_layer, 0,
+	       sizeof(state->jiffies_stats_layer));
 }
 
 static int dib8000_reset(struct dvb_frontend *fe)
@@ -3936,12 +3942,124 @@ static u32 interpolate_value(u32 value, struct linear_segments *segments,
 	return ret;
 }
 
+static u32 dib8000_get_time_us(struct dvb_frontend *fe, int layer)
+{
+	struct dib8000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
+	int ini_layer, end_layer, i;
+	u64 time_us;
+	u32 tmp, denom;
+	int guard, rate_num, rate_denum, bits_per_symbol, nsegs;
+	int interleaving, fft_div;
+
+	if (layer >= 0) {
+		ini_layer = layer;
+		end_layer = layer + 1;
+	} else {
+		ini_layer = 0;
+		end_layer = 3;
+	}
+
+	switch (c->guard_interval) {
+	case GUARD_INTERVAL_1_4:
+		guard = 4;
+		break;
+	case GUARD_INTERVAL_1_8:
+		guard = 8;
+		break;
+	case GUARD_INTERVAL_1_16:
+		guard = 16;
+		break;
+	default:
+	case GUARD_INTERVAL_1_32:
+		guard = 32;
+		break;
+	}
+
+	switch (c->transmission_mode) {
+	case TRANSMISSION_MODE_2K:
+		fft_div = 4;
+		break;
+	case TRANSMISSION_MODE_4K:
+		fft_div = 2;
+		break;
+	default:
+	case TRANSMISSION_MODE_8K:
+		fft_div = 1;
+		break;
+	}
+
+	denom = 0;
+	for (i = ini_layer; i < end_layer; i++) {
+		nsegs = c->layer[i].segment_count;
+		if (nsegs == 0 || nsegs > 13)
+			continue;
+
+		switch (c->layer[i].modulation) {
+		case DQPSK:
+		case QPSK:
+			bits_per_symbol = 2;
+			break;
+		case QAM_16:
+			bits_per_symbol = 4;
+			break;
+		default:
+		case QAM_64:
+			bits_per_symbol = 6;
+			break;
+		}
+
+		switch (c->layer[i].fec) {
+		case FEC_1_2:
+			rate_num = 1;
+			rate_denum = 2;
+			break;
+		case FEC_2_3:
+			rate_num = 2;
+			rate_denum = 3;
+			break;
+		case FEC_3_4:
+			rate_num = 3;
+			rate_denum = 4;
+			break;
+		case FEC_5_6:
+			rate_num = 5;
+			rate_denum = 6;
+			break;
+		default:
+		case FEC_7_8:
+			rate_num = 7;
+			rate_denum = 8;
+			break;
+		}
+
+		interleaving = c->layer[i].interleaving;
+
+		denom += bits_per_symbol * rate_num * fft_div * nsegs * 384;
+	}
+
+	/* If all goes wrong, wait for 1s for the next stats */
+	if (!denom)
+		return 0;
+
+	/* Estimate the period for the total bit rate */
+	time_us = rate_denum * (1008 * 1562500L);
+	time_us = time_us + time_us / guard;
+	time_us += denom / 2;
+	do_div(time_us, denom);
+
+	tmp = 1008 * 96 * interleaving;
+	time_us += tmp + tmp / guard;
+
+	return time_us;
+}
+
 static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
-	int i, lock;
-	u32 snr, val;
+	int i;
+	u32 time_us, snr, val;
 	s32 db;
 	u16 strength;
 
@@ -3953,55 +4071,59 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 			       ARRAY_SIZE(strength_to_db_table)) - 131000;
 	c->strength.stat[0].svalue = db;
 
-	/* Check if 1 second was elapsed */
-	if (!time_after(jiffies, state->get_stats_time))
-		return 0;
-	state->get_stats_time = jiffies + msecs_to_jiffies(1000);
-
-	/* Get SNR */
-	snr = dib8000_get_snr(fe);
-	for (i = 1; i < MAX_NUMBER_OF_FRONTENDS; i++) {
-		if (state->fe[i])
-			snr += dib8000_get_snr(state->fe[i]);
-	}
-	snr = snr >> 16;
-
-	if (snr) {
-		snr = 10 * intlog10(snr);
-		snr = (1000L * snr) >> 24;
-	} else {
-		snr = 0;
-	}
-	c->cnr.stat[0].svalue = snr;
-	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-
-	/* UCB/BER measures require lock */
+	/* UCB/BER/CNR measures require lock */
 	if (!(stat & FE_HAS_LOCK)) {
+		c->cnr.len = 1;
 		c->block_error.len = 1;
 		c->post_bit_error.len = 1;
 		c->post_bit_count.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 		return 0;
 	}
 
-	/* Get UCB and post-BER measures */
+	/* Check if time for stats was elapsed */
+	if (time_after(jiffies, state->jiffies_stats)) {
+		time_us = dib8000_get_time_us(fe, -1);
+		state->jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
+
+		dprintk("Next all layers stats available in %u us.\n", time_us);
+
+		/* Get SNR */
+		snr = dib8000_get_snr(fe);
+		for (i = 1; i < MAX_NUMBER_OF_FRONTENDS; i++) {
+			if (state->fe[i])
+				snr += dib8000_get_snr(state->fe[i]);
+		}
+		snr = snr >> 16;
 
-	/* FIXME: need to check if 1.25e6 bits already passed */
-	dib8000_read_ber(fe, &val);
-	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-	c->post_bit_error.stat[0].uvalue += val;
+		if (snr) {
+			snr = 10 * intlog10(snr);
+			snr = (1000L * snr) >> 24;
+		} else {
+			snr = 0;
+		}
+		c->cnr.stat[0].svalue = snr;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 
-	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-	c->post_bit_count.stat[0].uvalue += 100000000;
+		/* Get UCB and post-BER measures */
 
-	dib8000_read_unc_blocks(fe, &val);
-	if (val < state->init_ucb)
-		state->init_ucb += 1L << 32;
+		dib8000_read_ber(fe, &val);
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += val;
 
-	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-	c->block_error.stat[0].uvalue = val + state->init_ucb;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += 100000000;
+
+		dib8000_read_unc_blocks(fe, &val);
+		if (val < state->init_ucb)
+			state->init_ucb += 1L << 32;
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = val + state->init_ucb;
+	}
 
 	if (state->revision < 0x8002)
 		return 0;
@@ -4011,25 +4133,27 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	c->post_bit_count.len = 4;
 
 	for (i = 0; i < 3; i++) {
-		lock = dib8000_read_word(state, per_layer_regs[i].lock);
-		if (lock & 0x01) {
-			/* FIXME: need to check if 1.25e6 bits already passed */
-			val = dib8000_read_word(state, per_layer_regs[i].ber);
-			c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-			c->post_bit_error.stat[1 + i].uvalue += val;
-
-			c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
-			c->post_bit_count.stat[1 + i].uvalue += 100000000;
-
-			/*
-			 * FIXME: this is refreshed on every second, but a time
-			 * drift between dib8000 and PC clock may cause troubles
-			 */
-			val = dib8000_read_word(state, per_layer_regs[i].per);
-
-			c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-			c->block_error.stat[1 + i].uvalue += val;
-		}
+		if (!time_after(jiffies, state->jiffies_stats_layer[i]))
+			continue;
+		time_us = dib8000_get_time_us(fe, i);
+		if (!time_us)
+			continue;
+
+		state->jiffies_stats_layer[i] = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
+		dprintk("Next layer %c  stats will be available in %u us\n",
+			'A' + i, time_us);
+
+		val = dib8000_read_word(state, per_layer_regs[i].ber);
+		c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[1 + i].uvalue += val;
+
+		c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[1 + i].uvalue += 100000000;
+
+		val = dib8000_read_word(state, per_layer_regs[i].per);
+
+		c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[1 + i].uvalue += val;
 	}
 	return 0;
 }
-- 
1.8.3.1

