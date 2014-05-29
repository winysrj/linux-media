Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984AbaE2RpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 13:45:11 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] dib7000p: Add DVBv5 stats support
Date: Thu, 29 May 2014 14:44:56 -0300
Message-Id: <1401385497-20538-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds DVBv5 stats support. For now, just mimic whatever dib8000
does, as they're very similar, with regards to statistics.

However, dib7000p_get_time_us() likely require some
adjustments, as I didn't actually reviewed the formula
for it to work with DVB-T. Still, better than nothing,
as latter patches can improve it.

This patch also doesn't show the signal strength in dB
yet. The code is already there, but it requires to be
callibrated.

A latter patch will do the calibration.

It seems that this patch is also a bug fix: Before this
patch, the frontend were not tuning with some userspace
tools. I suspect that dib7000p firmware or hardware
internally expects that the statistics to be collected,
in order for it to work. With this patch, the DVB core
will always retrive statistics, even if userspace doesn't
request. So, it makes the device work on all tested apps.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib7000p.c | 322 ++++++++++++++++++++++++++++++++-
 1 file changed, 321 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index d36fa0d74259..880e15389d8e 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
+#include <asm/div64.h>
 
 #include "dvb_math.h"
 #include "dvb_frontend.h"
@@ -72,6 +73,12 @@ struct dib7000p_state {
 	struct mutex i2c_buffer_lock;
 
 	u8 input_mode_mpeg;
+
+	/* for DVBv5 stats */
+	s64 old_ucb;
+	unsigned long per_jiffies_stats;
+	unsigned long ber_jiffies_stats;
+	unsigned long get_stats_time;
 };
 
 enum dib7000p_power_mode {
@@ -631,6 +638,8 @@ static u16 dib7000p_defaults[] = {
 	0,
 };
 
+static void dib7000p_reset_stats(struct dvb_frontend *fe);
+
 static int dib7000p_demod_reset(struct dib7000p_state *state)
 {
 	dib7000p_set_power_mode(state, DIB7000P_POWER_ALL);
@@ -1354,6 +1363,9 @@ static int dib7000p_tune(struct dvb_frontend *demod)
 		dib7000p_spur_protect(state, ch->frequency / 1000, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
 
 	dib7000p_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
+
+	dib7000p_reset_stats(demod);
+
 	return 0;
 }
 
@@ -1546,6 +1558,8 @@ static int dib7000p_set_frontend(struct dvb_frontend *fe)
 	return ret;
 }
 
+static int dib7000p_get_stats(struct dvb_frontend *fe, fe_status_t stat);
+
 static int dib7000p_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
@@ -1564,6 +1578,8 @@ static int dib7000p_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 	if ((lock & 0x0038) == 0x38)
 		*stat |= FE_HAS_LOCK;
 
+	dib7000p_get_stats(fe, *stat);
+
 	return 0;
 }
 
@@ -1589,7 +1605,7 @@ static int dib7000p_read_signal_strength(struct dvb_frontend *fe, u16 * strength
 	return 0;
 }
 
-static int dib7000p_read_snr(struct dvb_frontend *fe, u16 * snr)
+static u32 dib7000p_get_snr(struct dvb_frontend *fe)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
 	u16 val;
@@ -1619,10 +1635,312 @@ static int dib7000p_read_snr(struct dvb_frontend *fe, u16 * snr)
 	else
 		result -= intlog10(2) * 10 * noise_exp - 100;
 
+	return result;
+}
+
+static int dib7000p_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	u32 result;
+
+	result = dib7000p_get_snr(fe);
+
 	*snr = result / ((1 << 24) / 10);
 	return 0;
 }
 
+static void dib7000p_reset_stats(struct dvb_frontend *demod)
+{
+	struct dib7000p_state *state = demod->demodulator_priv;
+	struct dtv_frontend_properties *c = &demod->dtv_property_cache;
+	u32 ucb;
+
+	memset(&c->strength, 0, sizeof(c->strength));
+	memset(&c->cnr, 0, sizeof(c->cnr));
+	memset(&c->post_bit_error, 0, sizeof(c->post_bit_error));
+	memset(&c->post_bit_count, 0, sizeof(c->post_bit_count));
+	memset(&c->block_error, 0, sizeof(c->block_error));
+
+	c->strength.len = 1;
+	c->cnr.len = 1;
+	c->block_error.len = 1;
+	c->block_count.len = 1;
+	c->post_bit_error.len = 1;
+	c->post_bit_count.len = 1;
+
+	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	c->strength.stat[0].uvalue = 0;
+
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+	dib7000p_read_unc_blocks(demod, &ucb);
+
+	state->old_ucb = ucb;
+	state->ber_jiffies_stats = 0;
+	state->per_jiffies_stats = 0;
+}
+
+struct linear_segments {
+	unsigned x;
+	signed y;
+};
+
+/*
+ * Table to estimate signal strength in dBm.
+ * This table should be empirically determinated by measuring the signal
+ * strength generated by a RF generator directly connected into
+ * a device.
+ */
+/* FIXME: Calibrate the table */
+
+#define DB_OFFSET 0
+
+static struct linear_segments strength_to_db_table[] = {
+	{ 65535,  65535},
+	{     0,      0},
+};
+
+static u32 interpolate_value(u32 value, struct linear_segments *segments,
+			     unsigned len)
+{
+	u64 tmp64;
+	u32 dx;
+	s32 dy;
+	int i, ret;
+
+	if (value >= segments[0].x)
+		return segments[0].y;
+	if (value < segments[len-1].x)
+		return segments[len-1].y;
+
+	for (i = 1; i < len - 1; i++) {
+		/* If value is identical, no need to interpolate */
+		if (value == segments[i].x)
+			return segments[i].y;
+		if (value > segments[i].x)
+			break;
+	}
+
+	/* Linear interpolation between the two (x,y) points */
+	dy = segments[i - 1].y - segments[i].y;
+	dx = segments[i - 1].x - segments[i].x;
+
+	tmp64 = value - segments[i].x;
+	tmp64 *= dy;
+	do_div(tmp64, dx);
+	ret = segments[i].y + tmp64;
+
+	return ret;
+}
+
+/* FIXME: may require changes - this one was borrowed from dib8000 */
+static u32 dib7000p_get_time_us(struct dvb_frontend *demod, int layer)
+{
+	struct dtv_frontend_properties *c = &demod->dtv_property_cache;
+	u64 time_us, tmp64;
+	u32 tmp, denom;
+	int guard, rate_num, rate_denum = 1, bits_per_symbol;
+	int interleaving = 0, fft_div;
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
+	switch (c->modulation) {
+	case DQPSK:
+	case QPSK:
+		bits_per_symbol = 2;
+		break;
+	case QAM_16:
+		bits_per_symbol = 4;
+		break;
+	default:
+	case QAM_64:
+		bits_per_symbol = 6;
+		break;
+	}
+
+	switch ((c->hierarchy == 0 || 1 == 1) ? c->code_rate_HP : c->code_rate_LP) {
+	case FEC_1_2:
+		rate_num = 1;
+		rate_denum = 2;
+		break;
+	case FEC_2_3:
+		rate_num = 2;
+		rate_denum = 3;
+		break;
+	case FEC_3_4:
+		rate_num = 3;
+		rate_denum = 4;
+		break;
+	case FEC_5_6:
+		rate_num = 5;
+		rate_denum = 6;
+		break;
+	default:
+	case FEC_7_8:
+		rate_num = 7;
+		rate_denum = 8;
+		break;
+	}
+
+	interleaving = interleaving;
+
+	denom = bits_per_symbol * rate_num * fft_div * 384;
+
+	/* If calculus gets wrong, wait for 1s for the next stats */
+	if (!denom)
+		return 0;
+
+	/* Estimate the period for the total bit rate */
+	time_us = rate_denum * (1008 * 1562500L);
+	tmp64 = time_us;
+	do_div(tmp64, guard);
+	time_us = time_us + tmp64;
+	time_us += denom / 2;
+	do_div(time_us, denom);
+
+	tmp = 1008 * 96 * interleaving;
+	time_us += tmp + tmp / guard;
+
+	return time_us;
+}
+
+static int dib7000p_get_stats(struct dvb_frontend *demod, fe_status_t stat)
+{
+	struct dib7000p_state *state = demod->demodulator_priv;
+	struct dtv_frontend_properties *c = &demod->dtv_property_cache;
+	int i;
+	int show_per_stats = 0;
+	u32 time_us = 0, val, snr;
+	u64 blocks, ucb;
+	s32 db;
+	u16 strength;
+
+	/* Get Signal strength */
+	dib7000p_read_signal_strength(demod, &strength);
+	val = strength;
+	db = interpolate_value(val,
+			       strength_to_db_table,
+			       ARRAY_SIZE(strength_to_db_table)) - DB_OFFSET;
+	c->strength.stat[0].svalue = db;
+
+	/* FIXME: Remove this when calibrated to DB */
+	c->strength.stat[0].scale = FE_SCALE_COUNTER;
+
+	/* UCB/BER/CNR measures require lock */
+	if (!(stat & FE_HAS_LOCK)) {
+		c->cnr.len = 1;
+		c->block_count.len = 1;
+		c->block_error.len = 1;
+		c->post_bit_error.len = 1;
+		c->post_bit_count.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return 0;
+	}
+
+	/* Check if time for stats was elapsed */
+	if (time_after(jiffies, state->per_jiffies_stats)) {
+		state->per_jiffies_stats = jiffies + msecs_to_jiffies(1000);
+
+		/* Get SNR */
+		snr = dib7000p_get_snr(demod);
+		if (snr) {
+			snr = (1000L * snr) >> 24;
+		} else {
+			snr = 0;
+		}
+		c->cnr.stat[0].svalue = snr;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+
+		/* Get UCB measures */
+		dib7000p_read_unc_blocks(demod, &val);
+		ucb = val - state->old_ucb;
+		if (val < state->old_ucb)
+			ucb += 0x100000000LL;
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = ucb;
+
+		/* Estimate the number of packets based on bitrate */
+		if (!time_us)
+			time_us = dib7000p_get_time_us(demod, -1);
+
+		if (time_us) {
+			blocks = 1250000ULL * 1000000ULL;
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
+		time_us = dib7000p_get_time_us(demod, -1);
+		state->ber_jiffies_stats = jiffies + msecs_to_jiffies((time_us + 500) / 1000);
+
+		dprintk("Next all layers stats available in %u us.", time_us);
+
+		dib7000p_read_ber(demod, &val);
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += val;
+
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += 100000000;
+	}
+
+	/* Get PER measures */
+	if (show_per_stats) {
+		dib7000p_read_unc_blocks(demod, &val);
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue += val;
+
+		time_us = dib7000p_get_time_us(demod, i);
+		if (time_us) {
+			blocks = 1250000ULL * 1000000ULL;
+			do_div(blocks, time_us * 8 * 204);
+			c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+			c->block_count.stat[0].uvalue += blocks;
+		}
+	}
+	return 0;
+}
+
 static int dib7000p_fe_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings *tune)
 {
 	tune->min_delay_ms = 1000;
@@ -2408,6 +2726,8 @@ static struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_a
 
 	dib7000p_demod_reset(st);
 
+	dib7000p_reset_stats(demod);
+
 	if (st->version == SOC7090) {
 		dib7090_set_output_mode(demod, st->cfg.output_mode);
 		dib7090_set_diversity_in(demod, 0);
-- 
1.9.3

