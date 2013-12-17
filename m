Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3LQSdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 13:33:47 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/6] [media] dib8000: add DVBv5 stats
Date: Tue, 17 Dec 2013 13:30:41 -0200
Message-Id: <1387294246-10155-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
References: <1387294246-10155-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The advantage of DVBv5 stats is that it allows adding proper
scales to all measures. use it for this frontend.

This patch adds a basic set of stats, basically cloning what's already
provided by DVBv3 API. Latter patches will improve it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 142 +++++++++++++++++++++++++++++++++-
 1 file changed, 141 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 13fdc3d5f762..2dbf89365a97 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -124,6 +124,8 @@ struct dib8000_state {
 	u16 agc2_max;
 	u16 agc2_min;
 #endif
+
+	unsigned long get_stats_time;
 };
 
 enum dib8000_power_mode {
@@ -804,7 +806,7 @@ int dib8000_update_pll(struct dvb_frontend *fe,
 			dprintk("PLL: Update ratio (prediv: %d, ratio: %d)", state->cfg.pll->pll_prediv, ratio);
 			dib8000_write_word(state, 901, (state->cfg.pll->pll_prediv << 8) | (ratio << 0)); /* only the PLL ratio is updated. */
 		}
-}
+	}
 
 	return 0;
 }
@@ -983,6 +985,32 @@ static u16 dib8000_identify(struct i2c_device *client)
 	return value;
 }
 
+static void dib8000_reset_stats(struct dvb_frontend *fe)
+{
+	struct dib8000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
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
+	c->post_bit_error.len = 1;
+	c->post_bit_count.len = 1;
+
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = 0;
+
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+}
+
 static int dib8000_reset(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
@@ -1088,6 +1116,8 @@ static int dib8000_reset(struct dvb_frontend *fe)
 
 	dib8000_set_power_mode(state, DIB8000_POWER_INTERFACE_ONLY);
 
+	dib8000_reset_stats(fe);
+
 	return 0;
 }
 
@@ -2983,6 +3013,8 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	switch (*tune_state) {
 	case CT_DEMOD_START: /* 30 */
+			dib8000_reset_stats(fe);
+
 			if (state->revision == 0x8090)
 				dib8090p_init_sdram(state);
 			state->status = FE_STATUS_TUNE_PENDING;
@@ -3654,6 +3686,8 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat);
+
 static int dib8000_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
@@ -3691,6 +3725,7 @@ static int dib8000_read_status(struct dvb_frontend *fe, fe_status_t * stat)
 		if (lock & 0x01)
 			*stat |= FE_HAS_VITERBI;
 	}
+	dib8000_get_stats(fe, *stat);
 
 	return 0;
 }
@@ -3797,6 +3832,111 @@ static int dib8000_read_snr(struct dvb_frontend *fe, u16 * snr)
 	return 0;
 }
 
+struct per_layer_regs {
+	u16 lock, ber, per;
+};
+
+static const struct per_layer_regs per_layer_regs[] = {
+	{ 554, 560, 562 },
+	{ 555, 576, 578 },
+	{ 556, 581, 583 },
+};
+
+static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
+{
+	struct dib8000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
+	int i, lock;
+	u32 snr, val;
+	u16 strength;
+
+	/* Get Signal strength */
+	dib8000_read_signal_strength(fe, &strength);
+	c->strength.stat[0].uvalue = strength;
+
+	/* Check if 1 second was elapsed */
+	if (!time_after(jiffies, state->get_stats_time))
+		return 0;
+	state->get_stats_time = jiffies + msecs_to_jiffies(1000);
+
+	/* Get SNR */
+	snr = dib8000_get_snr(fe);
+	for (i = 1; i < MAX_NUMBER_OF_FRONTENDS; i++) {
+		if (state->fe[i])
+			snr += dib8000_get_snr(state->fe[i]);
+	}
+	snr = snr >> 16;
+
+	if (snr) {
+		snr = 10 * intlog10(snr);
+		snr = (1000L * snr) >> 24;
+	} else {
+		snr = 0;
+	}
+	c->cnr.stat[0].svalue = snr;
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+
+	/* UCB/BER measures require lock */
+	if (!(stat & FE_HAS_LOCK)) {
+		c->block_error.len = 1;
+		c->post_bit_error.len = 1;
+		c->post_bit_count.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return 0;
+	}
+
+	/* Get UCB and post-BER measures */
+
+	/* FIXME: need to check if 1.25e6 bits already passed */
+	dib8000_read_ber(fe, &val);
+	c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_error.stat[0].uvalue += val;
+
+	c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+	c->post_bit_count.stat[0].uvalue += 100000000;
+
+	/*
+	 * FIXME: this is refreshed on every second, but a time
+	 * drift between dib8000 and PC clock may cause troubles
+	 */
+	dib8000_read_unc_blocks(fe, &val);
+
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_error.stat[0].uvalue += val;
+
+	if (state->revision < 0x8002)
+		return 0;
+
+	c->block_error.len = 4;
+	c->post_bit_error.len = 4;
+	c->post_bit_count.len = 4;
+
+	for (i = 0; i < 3; i++) {
+		lock = dib8000_read_word(state, per_layer_regs[i].lock);
+		if (lock & 0x01) {
+			/* FIXME: need to check if 1.25e6 bits already passed */
+			val = dib8000_read_word(state, per_layer_regs[i].ber);
+			c->post_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+			c->post_bit_error.stat[1 + i].uvalue += val;
+
+			c->post_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+			c->post_bit_count.stat[1 + i].uvalue += 100000000;
+
+			/*
+			 * FIXME: this is refreshed on every second, but a time
+			 * drift between dib8000 and PC clock may cause troubles
+			 */
+			val = dib8000_read_word(state, per_layer_regs[i].per);
+
+			c->block_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+			c->block_error.stat[1 + i].uvalue += val;
+		}
+	}
+	return 0;
+}
+
 int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_slave)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
-- 
1.8.3.1

