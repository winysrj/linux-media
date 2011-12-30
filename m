Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9RUr009109
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 16/94] [media] dibx000: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:13 -0200
Message-Id: <1325257711-12274-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib3000mc.c      |  131 +++++++++++++------------
 drivers/media/dvb/frontends/dib7000m.c       |  135 ++++++++++++++------------
 drivers/media/dvb/frontends/dib7000p.c       |  126 +++++++++++++-----------
 drivers/media/dvb/frontends/dibx000_common.h |   10 +--
 4 files changed, 211 insertions(+), 191 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index 7ec0e02..8130028 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -438,11 +438,14 @@ static void dib3000mc_set_adp_cfg(struct dib3000mc_state *state, s16 qam)
 		dib3000mc_write_word(state, reg, cfg[reg - 129]);
 }
 
-static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state, struct dvb_frontend_parameters *ch, u16 seq)
+static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state,
+				      struct dtv_frontend_properties *ch, u16 seq)
 {
 	u16 value;
-    dib3000mc_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth));
-	dib3000mc_set_timing(state, ch->u.ofdm.transmission_mode, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth), 0);
+	u32 bw = BANDWIDTH_TO_KHZ(ch->bandwidth_hz);
+
+	dib3000mc_set_bandwidth(state, bw);
+	dib3000mc_set_timing(state, ch->transmission_mode, bw, 0);
 
 //	if (boost)
 //		dib3000mc_write_word(state, 100, (11 << 6) + 6);
@@ -471,22 +474,22 @@ static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state, struct dvb_
 	dib3000mc_write_word(state, 97,0);
 	dib3000mc_write_word(state, 98,0);
 
-	dib3000mc_set_impulse_noise(state, 0, ch->u.ofdm.transmission_mode);
+	dib3000mc_set_impulse_noise(state, 0, ch->transmission_mode);
 
 	value = 0;
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= (0 << 7); break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= (1 << 7); break;
 	}
-	switch (ch->u.ofdm.guard_interval) {
+	switch (ch->guard_interval) {
 		case GUARD_INTERVAL_1_32: value |= (0 << 5); break;
 		case GUARD_INTERVAL_1_16: value |= (1 << 5); break;
 		case GUARD_INTERVAL_1_4:  value |= (3 << 5); break;
 		default:
 		case GUARD_INTERVAL_1_8:  value |= (2 << 5); break;
 	}
-	switch (ch->u.ofdm.constellation) {
+	switch (ch->modulation) {
 		case QPSK:  value |= (0 << 3); break;
 		case QAM_16: value |= (1 << 3); break;
 		default:
@@ -502,11 +505,11 @@ static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state, struct dvb_
 	dib3000mc_write_word(state, 5, (1 << 8) | ((seq & 0xf) << 4));
 
 	value = 0;
-	if (ch->u.ofdm.hierarchy_information == 1)
+	if (ch->hierarchy == 1)
 		value |= (1 << 4);
 	if (1 == 1)
 		value |= 1;
-	switch ((ch->u.ofdm.hierarchy_information == 0 || 1 == 1) ? ch->u.ofdm.code_rate_HP : ch->u.ofdm.code_rate_LP) {
+	switch ((ch->hierarchy == 0 || 1 == 1) ? ch->code_rate_HP : ch->code_rate_LP) {
 		case FEC_2_3: value |= (2 << 1); break;
 		case FEC_3_4: value |= (3 << 1); break;
 		case FEC_5_6: value |= (5 << 1); break;
@@ -517,12 +520,12 @@ static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state, struct dvb_
 	dib3000mc_write_word(state, 181, value);
 
 	// diversity synchro delay add 50% SFN margin
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_8K: value = 256; break;
 		case TRANSMISSION_MODE_2K:
 		default: value = 64; break;
 	}
-	switch (ch->u.ofdm.guard_interval) {
+	switch (ch->guard_interval) {
 		case GUARD_INTERVAL_1_16: value *= 2; break;
 		case GUARD_INTERVAL_1_8:  value *= 4; break;
 		case GUARD_INTERVAL_1_4:  value *= 8; break;
@@ -540,27 +543,28 @@ static void dib3000mc_set_channel_cfg(struct dib3000mc_state *state, struct dvb_
 
 	msleep(30);
 
-	dib3000mc_set_impulse_noise(state, state->cfg->impulse_noise_mode, ch->u.ofdm.transmission_mode);
+	dib3000mc_set_impulse_noise(state, state->cfg->impulse_noise_mode, ch->transmission_mode);
 }
 
-static int dib3000mc_autosearch_start(struct dvb_frontend *demod, struct dvb_frontend_parameters *chan)
+static int dib3000mc_autosearch_start(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *chan = &demod->dtv_property_cache;
 	struct dib3000mc_state *state = demod->demodulator_priv;
 	u16 reg;
 //	u32 val;
-	struct dvb_frontend_parameters schan;
+	struct dtv_frontend_properties schan;
 
 	schan = *chan;
 
 	/* TODO what is that ? */
 
 	/* a channel for autosearch */
-	schan.u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
-	schan.u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
-	schan.u.ofdm.constellation = QAM_64;
-	schan.u.ofdm.code_rate_HP = FEC_2_3;
-	schan.u.ofdm.code_rate_LP = FEC_2_3;
-	schan.u.ofdm.hierarchy_information = 0;
+	schan.transmission_mode = TRANSMISSION_MODE_8K;
+	schan.guard_interval = GUARD_INTERVAL_1_32;
+	schan.modulation = QAM_64;
+	schan.code_rate_HP = FEC_2_3;
+	schan.code_rate_LP = FEC_2_3;
+	schan.hierarchy = 0;
 
 	dib3000mc_set_channel_cfg(state, &schan, 11);
 
@@ -586,8 +590,9 @@ static int dib3000mc_autosearch_is_irq(struct dvb_frontend *demod)
 	return 0; // still pending
 }
 
-static int dib3000mc_tune(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib3000mc_tune(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib3000mc_state *state = demod->demodulator_priv;
 
 	// ** configure demod **
@@ -603,8 +608,8 @@ static int dib3000mc_tune(struct dvb_frontend *demod, struct dvb_frontend_parame
 		dib3000mc_write_word(state, 108, 0x0000); // P_pha3_force_pha_shift
 	}
 
-	dib3000mc_set_adp_cfg(state, (u8)ch->u.ofdm.constellation);
-	if (ch->u.ofdm.transmission_mode == TRANSMISSION_MODE_8K) {
+	dib3000mc_set_adp_cfg(state, (u8)ch->modulation);
+	if (ch->transmission_mode == TRANSMISSION_MODE_8K) {
 		dib3000mc_write_word(state, 26, 38528);
 		dib3000mc_write_word(state, 33, 8);
 	} else {
@@ -613,7 +618,8 @@ static int dib3000mc_tune(struct dvb_frontend *demod, struct dvb_frontend_parame
 	}
 
 	if (dib3000mc_read_word(state, 509) & 0x80)
-		dib3000mc_set_timing(state, ch->u.ofdm.transmission_mode, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth), 1);
+		dib3000mc_set_timing(state, ch->transmission_mode,
+				     BANDWIDTH_TO_KHZ(ch->bandwidth_hz), 1);
 
 	return 0;
 }
@@ -627,70 +633,70 @@ struct i2c_adapter * dib3000mc_get_tuner_i2c_master(struct dvb_frontend *demod,
 EXPORT_SYMBOL(dib3000mc_get_tuner_i2c_master);
 
 static int dib3000mc_get_frontend(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *fep)
+				  struct dtv_frontend_properties *fep)
 {
 	struct dib3000mc_state *state = fe->demodulator_priv;
 	u16 tps = dib3000mc_read_word(state,458);
 
 	fep->inversion = INVERSION_AUTO;
 
-	fep->u.ofdm.bandwidth = state->current_bandwidth;
+	fep->bandwidth_hz = state->current_bandwidth;
 
 	switch ((tps >> 8) & 0x1) {
-		case 0: fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K; break;
-		case 1: fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K; break;
+		case 0: fep->transmission_mode = TRANSMISSION_MODE_2K; break;
+		case 1: fep->transmission_mode = TRANSMISSION_MODE_8K; break;
 	}
 
 	switch (tps & 0x3) {
-		case 0: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_32; break;
-		case 1: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_16; break;
-		case 2: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_8; break;
-		case 3: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_4; break;
+		case 0: fep->guard_interval = GUARD_INTERVAL_1_32; break;
+		case 1: fep->guard_interval = GUARD_INTERVAL_1_16; break;
+		case 2: fep->guard_interval = GUARD_INTERVAL_1_8; break;
+		case 3: fep->guard_interval = GUARD_INTERVAL_1_4; break;
 	}
 
 	switch ((tps >> 13) & 0x3) {
-		case 0: fep->u.ofdm.constellation = QPSK; break;
-		case 1: fep->u.ofdm.constellation = QAM_16; break;
+		case 0: fep->modulation = QPSK; break;
+		case 1: fep->modulation = QAM_16; break;
 		case 2:
-		default: fep->u.ofdm.constellation = QAM_64; break;
+		default: fep->modulation = QAM_64; break;
 	}
 
 	/* as long as the frontend_param structure is fixed for hierarchical transmission I refuse to use it */
 	/* (tps >> 12) & 0x1 == hrch is used, (tps >> 9) & 0x7 == alpha */
 
-	fep->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+	fep->hierarchy = HIERARCHY_NONE;
 	switch ((tps >> 5) & 0x7) {
-		case 1: fep->u.ofdm.code_rate_HP = FEC_1_2; break;
-		case 2: fep->u.ofdm.code_rate_HP = FEC_2_3; break;
-		case 3: fep->u.ofdm.code_rate_HP = FEC_3_4; break;
-		case 5: fep->u.ofdm.code_rate_HP = FEC_5_6; break;
+		case 1: fep->code_rate_HP = FEC_1_2; break;
+		case 2: fep->code_rate_HP = FEC_2_3; break;
+		case 3: fep->code_rate_HP = FEC_3_4; break;
+		case 5: fep->code_rate_HP = FEC_5_6; break;
 		case 7:
-		default: fep->u.ofdm.code_rate_HP = FEC_7_8; break;
+		default: fep->code_rate_HP = FEC_7_8; break;
 
 	}
 
 	switch ((tps >> 2) & 0x7) {
-		case 1: fep->u.ofdm.code_rate_LP = FEC_1_2; break;
-		case 2: fep->u.ofdm.code_rate_LP = FEC_2_3; break;
-		case 3: fep->u.ofdm.code_rate_LP = FEC_3_4; break;
-		case 5: fep->u.ofdm.code_rate_LP = FEC_5_6; break;
+		case 1: fep->code_rate_LP = FEC_1_2; break;
+		case 2: fep->code_rate_LP = FEC_2_3; break;
+		case 3: fep->code_rate_LP = FEC_3_4; break;
+		case 5: fep->code_rate_LP = FEC_5_6; break;
 		case 7:
-		default: fep->u.ofdm.code_rate_LP = FEC_7_8; break;
+		default: fep->code_rate_LP = FEC_7_8; break;
 	}
 
 	return 0;
 }
 
-static int dib3000mc_set_frontend(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *fep)
+static int dib3000mc_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache, tmp;
 	struct dib3000mc_state *state = fe->demodulator_priv;
-    int ret;
+	int ret;
 
 	dib3000mc_set_output_mode(state, OUTMODE_HIGH_Z);
 
-	state->current_bandwidth = fep->u.ofdm.bandwidth;
-	dib3000mc_set_bandwidth(state, BANDWIDTH_TO_KHZ(fep->u.ofdm.bandwidth));
+	state->current_bandwidth = fep->bandwidth_hz;
+	dib3000mc_set_bandwidth(state, BANDWIDTH_TO_KHZ(fep->bandwidth_hz));
 
 	/* maybe the parameter has been changed */
 	state->sfn_workaround_active = buggy_sfn_workaround;
@@ -700,13 +706,15 @@ static int dib3000mc_set_frontend(struct dvb_frontend* fe,
 		msleep(100);
 	}
 
-	if (fep->u.ofdm.transmission_mode == TRANSMISSION_MODE_AUTO ||
-		fep->u.ofdm.guard_interval    == GUARD_INTERVAL_AUTO ||
-		fep->u.ofdm.constellation     == QAM_AUTO ||
-		fep->u.ofdm.code_rate_HP      == FEC_AUTO) {
+	if (fep->transmission_mode  == TRANSMISSION_MODE_AUTO ||
+	    fep->guard_interval == GUARD_INTERVAL_AUTO ||
+	    fep->modulation     == QAM_AUTO ||
+	    fep->code_rate_HP   == FEC_AUTO) {
 		int i = 1000, found;
 
-		dib3000mc_autosearch_start(fe, fep);
+		tmp = *fep;
+
+		dib3000mc_autosearch_start(fe);
 		do {
 			msleep(1);
 			found = dib3000mc_autosearch_is_irq(fe);
@@ -716,14 +724,14 @@ static int dib3000mc_set_frontend(struct dvb_frontend* fe,
 		if (found == 0 || found == 1)
 			return 0; // no channel found
 
-		dib3000mc_get_frontend(fe, fep);
+		dib3000mc_get_frontend(fe, &tmp);
 	}
 
-    ret = dib3000mc_tune(fe, fep);
+	ret = dib3000mc_tune(fe);
 
 	/* make this a config parameter */
 	dib3000mc_set_output_mode(state, OUTMODE_MPEG2_FIFO);
-    return ret;
+	return ret;
 }
 
 static int dib3000mc_read_status(struct dvb_frontend *fe, fe_status_t *stat)
@@ -897,6 +905,7 @@ error:
 EXPORT_SYMBOL(dib3000mc_attach);
 
 static struct dvb_frontend_ops dib3000mc_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 3000MC/P",
 		.type = FE_OFDM,
@@ -918,9 +927,9 @@ static struct dvb_frontend_ops dib3000mc_ops = {
 	.init                 = dib3000mc_init,
 	.sleep                = dib3000mc_sleep,
 
-	.set_frontend_legacy         = dib3000mc_set_frontend,
+	.set_frontend         = dib3000mc_set_frontend,
 	.get_tune_settings    = dib3000mc_fe_get_tune_settings,
-	.get_frontend_legacy = dib3000mc_get_frontend,
+	.get_frontend         = dib3000mc_get_frontend,
 
 	.read_status          = dib3000mc_read_status,
 	.read_ber             = dib3000mc_read_ber,
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index 45c1105..eb90c4f 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -313,6 +313,9 @@ static int dib7000m_set_bandwidth(struct dib7000m_state *state, u32 bw)
 {
 	u32 timf;
 
+	if (!bw)
+		bw = 8000;
+
 	// store the current bandwidth for later use
 	state->current_bandwidth = bw;
 
@@ -742,8 +745,9 @@ static void dib7000m_update_timf(struct dib7000m_state *state)
 	dprintk( "updated timf_frequency: %d (default: %d)",state->timf, state->timf_default);
 }
 
-static int dib7000m_agc_startup(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib7000m_agc_startup(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib7000m_state *state = demod->demodulator_priv;
 	u16 cfg_72 = dib7000m_read_word(state, 72);
 	int ret = -1;
@@ -832,28 +836,29 @@ static int dib7000m_agc_startup(struct dvb_frontend *demod, struct dvb_frontend_
 	return ret;
 }
 
-static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_frontend_parameters *ch, u8 seq)
+static void dib7000m_set_channel(struct dib7000m_state *state, struct dtv_frontend_properties *ch,
+				 u8 seq)
 {
 	u16 value, est[4];
 
-	dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth));
+	dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
 
 	/* nfft, guard, qam, alpha */
 	value = 0;
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= (0 << 7); break;
 		case TRANSMISSION_MODE_4K: value |= (2 << 7); break;
 		default:
 		case TRANSMISSION_MODE_8K: value |= (1 << 7); break;
 	}
-	switch (ch->u.ofdm.guard_interval) {
+	switch (ch->guard_interval) {
 		case GUARD_INTERVAL_1_32: value |= (0 << 5); break;
 		case GUARD_INTERVAL_1_16: value |= (1 << 5); break;
 		case GUARD_INTERVAL_1_4:  value |= (3 << 5); break;
 		default:
 		case GUARD_INTERVAL_1_8:  value |= (2 << 5); break;
 	}
-	switch (ch->u.ofdm.constellation) {
+	switch (ch->modulation) {
 		case QPSK:  value |= (0 << 3); break;
 		case QAM_16: value |= (1 << 3); break;
 		default:
@@ -872,11 +877,11 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_fronte
 	value = 0;
 	if (1 != 0)
 		value |= (1 << 6);
-	if (ch->u.ofdm.hierarchy_information == 1)
+	if (ch->hierarchy == 1)
 		value |= (1 << 4);
 	if (1 == 1)
 		value |= 1;
-	switch ((ch->u.ofdm.hierarchy_information == 0 || 1 == 1) ? ch->u.ofdm.code_rate_HP : ch->u.ofdm.code_rate_LP) {
+	switch ((ch->hierarchy == 0 || 1 == 1) ? ch->code_rate_HP : ch->code_rate_LP) {
 		case FEC_2_3: value |= (2 << 1); break;
 		case FEC_3_4: value |= (3 << 1); break;
 		case FEC_5_6: value |= (5 << 1); break;
@@ -901,13 +906,13 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_fronte
 	dib7000m_write_word(state, 33, (0 << 4) | 0x5);
 
 	/* P_dvsy_sync_wait */
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_8K: value = 256; break;
 		case TRANSMISSION_MODE_4K: value = 128; break;
 		case TRANSMISSION_MODE_2K:
 		default: value = 64; break;
 	}
-	switch (ch->u.ofdm.guard_interval) {
+	switch (ch->guard_interval) {
 		case GUARD_INTERVAL_1_16: value *= 2; break;
 		case GUARD_INTERVAL_1_8:  value *= 4; break;
 		case GUARD_INTERVAL_1_4:  value *= 8; break;
@@ -925,7 +930,7 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_fronte
 	dib7000m_set_diversity_in(&state->demod, state->div_state);
 
 	/* channel estimation fine configuration */
-	switch (ch->u.ofdm.constellation) {
+	switch (ch->modulation) {
 		case QAM_64:
 			est[0] = 0x0148;       /* P_adp_regul_cnt 0.04 */
 			est[1] = 0xfff0;       /* P_adp_noise_cnt -0.002 */
@@ -952,25 +957,26 @@ static void dib7000m_set_channel(struct dib7000m_state *state, struct dvb_fronte
 	dib7000m_set_power_mode(state, DIB7000M_POWER_COR4_DINTLV_ICIRM_EQUAL_CFROD);
 }
 
-static int dib7000m_autosearch_start(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib7000m_autosearch_start(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib7000m_state *state = demod->demodulator_priv;
-	struct dvb_frontend_parameters schan;
+	struct dtv_frontend_properties schan;
 	int ret = 0;
 	u32 value, factor;
 
 	schan = *ch;
 
-	schan.u.ofdm.constellation = QAM_64;
-	schan.u.ofdm.guard_interval        = GUARD_INTERVAL_1_32;
-	schan.u.ofdm.transmission_mode         = TRANSMISSION_MODE_8K;
-	schan.u.ofdm.code_rate_HP = FEC_2_3;
-	schan.u.ofdm.code_rate_LP = FEC_3_4;
-	schan.u.ofdm.hierarchy_information         = 0;
+	schan.modulation = QAM_64;
+	schan.guard_interval        = GUARD_INTERVAL_1_32;
+	schan.transmission_mode         = TRANSMISSION_MODE_8K;
+	schan.code_rate_HP = FEC_2_3;
+	schan.code_rate_LP = FEC_3_4;
+	schan.hierarchy    = 0;
 
 	dib7000m_set_channel(state, &schan, 7);
 
-	factor = BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth);
+	factor = BANDWIDTH_TO_KHZ(schan.bandwidth_hz);
 	if (factor >= 5000)
 		factor = 1;
 	else
@@ -1027,8 +1033,9 @@ static int dib7000m_autosearch_is_irq(struct dvb_frontend *demod)
 		return dib7000m_autosearch_irq(state, 537);
 }
 
-static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib7000m_tune(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib7000m_state *state = demod->demodulator_priv;
 	int ret = 0;
 	u16 value;
@@ -1055,7 +1062,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	//dump_reg(state);
 	/* P_timf_alpha, P_corm_alpha=6, P_corm_thres=0x80 */
 	value = (6 << 8) | 0x80;
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= (7 << 12); break;
 		case TRANSMISSION_MODE_4K: value |= (8 << 12); break;
 		default:
@@ -1065,7 +1072,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 
 	/* P_ctrl_freeze_pha_shift=0, P_ctrl_pha_off_max */
 	value = (0 << 4);
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= 0x6; break;
 		case TRANSMISSION_MODE_4K: value |= 0x7; break;
 		default:
@@ -1075,7 +1082,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 
 	/* P_ctrl_sfreq_inh=0, P_ctrl_sfreq_step */
 	value = (0 << 4);
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 		case TRANSMISSION_MODE_2K: value |= 0x6; break;
 		case TRANSMISSION_MODE_4K: value |= 0x7; break;
 		default:
@@ -1087,7 +1094,7 @@ static int dib7000m_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	if ((dib7000m_read_word(state, 535) >> 6)  & 0x1)
 		dib7000m_update_timf(state);
 
-    dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth));
+	dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
 	return ret;
 }
 
@@ -1148,56 +1155,56 @@ static int dib7000m_identify(struct dib7000m_state *state)
 
 
 static int dib7000m_get_frontend(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *fep)
+				 struct dtv_frontend_properties *fep)
 {
 	struct dib7000m_state *state = fe->demodulator_priv;
 	u16 tps = dib7000m_read_word(state,480);
 
 	fep->inversion = INVERSION_AUTO;
 
-	fep->u.ofdm.bandwidth = state->current_bandwidth;
+	fep->bandwidth_hz = BANDWIDTH_TO_HZ(state->current_bandwidth);
 
 	switch ((tps >> 8) & 0x3) {
-		case 0: fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K; break;
-		case 1: fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K; break;
-		/* case 2: fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_4K; break; */
+		case 0: fep->transmission_mode = TRANSMISSION_MODE_2K; break;
+		case 1: fep->transmission_mode = TRANSMISSION_MODE_8K; break;
+		/* case 2: fep->transmission_mode = TRANSMISSION_MODE_4K; break; */
 	}
 
 	switch (tps & 0x3) {
-		case 0: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_32; break;
-		case 1: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_16; break;
-		case 2: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_8; break;
-		case 3: fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_4; break;
+		case 0: fep->guard_interval = GUARD_INTERVAL_1_32; break;
+		case 1: fep->guard_interval = GUARD_INTERVAL_1_16; break;
+		case 2: fep->guard_interval = GUARD_INTERVAL_1_8; break;
+		case 3: fep->guard_interval = GUARD_INTERVAL_1_4; break;
 	}
 
 	switch ((tps >> 14) & 0x3) {
-		case 0: fep->u.ofdm.constellation = QPSK; break;
-		case 1: fep->u.ofdm.constellation = QAM_16; break;
+		case 0: fep->modulation = QPSK; break;
+		case 1: fep->modulation = QAM_16; break;
 		case 2:
-		default: fep->u.ofdm.constellation = QAM_64; break;
+		default: fep->modulation = QAM_64; break;
 	}
 
 	/* as long as the frontend_param structure is fixed for hierarchical transmission I refuse to use it */
 	/* (tps >> 13) & 0x1 == hrch is used, (tps >> 10) & 0x7 == alpha */
 
-	fep->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+	fep->hierarchy = HIERARCHY_NONE;
 	switch ((tps >> 5) & 0x7) {
-		case 1: fep->u.ofdm.code_rate_HP = FEC_1_2; break;
-		case 2: fep->u.ofdm.code_rate_HP = FEC_2_3; break;
-		case 3: fep->u.ofdm.code_rate_HP = FEC_3_4; break;
-		case 5: fep->u.ofdm.code_rate_HP = FEC_5_6; break;
+		case 1: fep->code_rate_HP = FEC_1_2; break;
+		case 2: fep->code_rate_HP = FEC_2_3; break;
+		case 3: fep->code_rate_HP = FEC_3_4; break;
+		case 5: fep->code_rate_HP = FEC_5_6; break;
 		case 7:
-		default: fep->u.ofdm.code_rate_HP = FEC_7_8; break;
+		default: fep->code_rate_HP = FEC_7_8; break;
 
 	}
 
 	switch ((tps >> 2) & 0x7) {
-		case 1: fep->u.ofdm.code_rate_LP = FEC_1_2; break;
-		case 2: fep->u.ofdm.code_rate_LP = FEC_2_3; break;
-		case 3: fep->u.ofdm.code_rate_LP = FEC_3_4; break;
-		case 5: fep->u.ofdm.code_rate_LP = FEC_5_6; break;
+		case 1: fep->code_rate_LP = FEC_1_2; break;
+		case 2: fep->code_rate_LP = FEC_2_3; break;
+		case 3: fep->code_rate_LP = FEC_3_4; break;
+		case 5: fep->code_rate_LP = FEC_5_6; break;
 		case 7:
-		default: fep->u.ofdm.code_rate_LP = FEC_7_8; break;
+		default: fep->code_rate_LP = FEC_7_8; break;
 	}
 
 	/* native interleaver: (dib7000m_read_word(state, 481) >>  5) & 0x1 */
@@ -1205,16 +1212,15 @@ static int dib7000m_get_frontend(struct dvb_frontend* fe,
 	return 0;
 }
 
-static int dib7000m_set_frontend(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *fep)
+static int dib7000m_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache, tmp;
 	struct dib7000m_state *state = fe->demodulator_priv;
 	int time, ret;
 
-    dib7000m_set_output_mode(state, OUTMODE_HIGH_Z);
+	dib7000m_set_output_mode(state, OUTMODE_HIGH_Z);
 
-	state->current_bandwidth = fep->u.ofdm.bandwidth;
-	dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(fep->u.ofdm.bandwidth));
+	dib7000m_set_bandwidth(state, BANDWIDTH_TO_KHZ(fep->bandwidth_hz));
 
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
@@ -1222,18 +1228,20 @@ static int dib7000m_set_frontend(struct dvb_frontend* fe,
 	/* start up the AGC */
 	state->agc_state = 0;
 	do {
-		time = dib7000m_agc_startup(fe, fep);
+		time = dib7000m_agc_startup(fe);
 		if (time != -1)
 			msleep(time);
 	} while (time != -1);
 
-	if (fep->u.ofdm.transmission_mode == TRANSMISSION_MODE_AUTO ||
-		fep->u.ofdm.guard_interval    == GUARD_INTERVAL_AUTO ||
-		fep->u.ofdm.constellation     == QAM_AUTO ||
-		fep->u.ofdm.code_rate_HP      == FEC_AUTO) {
+	if (fep->transmission_mode == TRANSMISSION_MODE_AUTO ||
+		fep->guard_interval    == GUARD_INTERVAL_AUTO ||
+		fep->modulation        == QAM_AUTO ||
+		fep->code_rate_HP      == FEC_AUTO) {
 		int i = 800, found;
 
-		dib7000m_autosearch_start(fe, fep);
+		tmp = *fep;
+
+		dib7000m_autosearch_start(fe);
 		do {
 			msleep(1);
 			found = dib7000m_autosearch_is_irq(fe);
@@ -1243,10 +1251,10 @@ static int dib7000m_set_frontend(struct dvb_frontend* fe,
 		if (found == 0 || found == 1)
 			return 0; // no channel found
 
-		dib7000m_get_frontend(fe, fep);
+		dib7000m_get_frontend(fe, &tmp);
 	}
 
-	ret = dib7000m_tune(fe, fep);
+	ret = dib7000m_tune(fe);
 
 	/* make this a config parameter */
 	dib7000m_set_output_mode(state, OUTMODE_MPEG2_FIFO);
@@ -1430,6 +1438,7 @@ error:
 EXPORT_SYMBOL(dib7000m_attach);
 
 static struct dvb_frontend_ops dib7000m_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "DiBcom 7000MA/MB/PA/PB/MC",
 		.type = FE_OFDM,
@@ -1451,9 +1460,9 @@ static struct dvb_frontend_ops dib7000m_ops = {
 	.init                 = dib7000m_wakeup,
 	.sleep                = dib7000m_sleep,
 
-	.set_frontend_legacy         = dib7000m_set_frontend,
+	.set_frontend         = dib7000m_set_frontend,
 	.get_tune_settings    = dib7000m_fe_get_tune_settings,
-	.get_frontend_legacy = dib7000m_get_frontend,
+	.get_frontend         = dib7000m_get_frontend,
 
 	.read_status          = dib7000m_read_status,
 	.read_ber             = dib7000m_read_ber,
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index feb82b0..c92c1a0 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -812,8 +812,9 @@ static void dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
 	}
 }
 
-static int dib7000p_agc_startup(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib7000p_agc_startup(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib7000p_state *state = demod->demodulator_priv;
 	int ret = -1;
 	u8 *agc_state = &state->agc_state;
@@ -936,15 +937,16 @@ u32 dib7000p_ctrl_timf(struct dvb_frontend *fe, u8 op, u32 timf)
 }
 EXPORT_SYMBOL(dib7000p_ctrl_timf);
 
-static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_frontend_parameters *ch, u8 seq)
+static void dib7000p_set_channel(struct dib7000p_state *state,
+				 struct dtv_frontend_properties *ch, u8 seq)
 {
 	u16 value, est[4];
 
-	dib7000p_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth));
+	dib7000p_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
 
 	/* nfft, guard, qam, alpha */
 	value = 0;
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 		value |= (0 << 7);
 		break;
@@ -956,7 +958,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 		value |= (1 << 7);
 		break;
 	}
-	switch (ch->u.ofdm.guard_interval) {
+	switch (ch->guard_interval) {
 	case GUARD_INTERVAL_1_32:
 		value |= (0 << 5);
 		break;
@@ -971,7 +973,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 		value |= (2 << 5);
 		break;
 	}
-	switch (ch->u.ofdm.constellation) {
+	switch (ch->modulation) {
 	case QPSK:
 		value |= (0 << 3);
 		break;
@@ -1002,11 +1004,11 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 	value = 0;
 	if (1 != 0)
 		value |= (1 << 6);
-	if (ch->u.ofdm.hierarchy_information == 1)
+	if (ch->hierarchy == 1)
 		value |= (1 << 4);
 	if (1 == 1)
 		value |= 1;
-	switch ((ch->u.ofdm.hierarchy_information == 0 || 1 == 1) ? ch->u.ofdm.code_rate_HP : ch->u.ofdm.code_rate_LP) {
+	switch ((ch->hierarchy == 0 || 1 == 1) ? ch->code_rate_HP : ch->code_rate_LP) {
 	case FEC_2_3:
 		value |= (2 << 1);
 		break;
@@ -1033,7 +1035,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 	dib7000p_write_word(state, 33, 0x0005);
 
 	/* P_dvsy_sync_wait */
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 	case TRANSMISSION_MODE_8K:
 		value = 256;
 		break;
@@ -1045,7 +1047,7 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 		value = 64;
 		break;
 	}
-	switch (ch->u.ofdm.guard_interval) {
+	switch (ch->guard_interval) {
 	case GUARD_INTERVAL_1_16:
 		value *= 2;
 		break;
@@ -1066,11 +1068,11 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 		state->div_sync_wait = (value * 3) / 2 + state->cfg.diversity_delay;
 
 	/* deactive the possibility of diversity reception if extended interleaver */
-	state->div_force_off = !1 && ch->u.ofdm.transmission_mode != TRANSMISSION_MODE_8K;
+	state->div_force_off = !1 && ch->transmission_mode != TRANSMISSION_MODE_8K;
 	dib7000p_set_diversity_in(&state->demod, state->div_state);
 
 	/* channel estimation fine configuration */
-	switch (ch->u.ofdm.constellation) {
+	switch (ch->modulation) {
 	case QAM_64:
 		est[0] = 0x0148;	/* P_adp_regul_cnt 0.04 */
 		est[1] = 0xfff0;	/* P_adp_noise_cnt -0.002 */
@@ -1094,24 +1096,25 @@ static void dib7000p_set_channel(struct dib7000p_state *state, struct dvb_fronte
 		dib7000p_write_word(state, 187 + value, est[value]);
 }
 
-static int dib7000p_autosearch_start(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib7000p_autosearch_start(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib7000p_state *state = demod->demodulator_priv;
-	struct dvb_frontend_parameters schan;
+	struct dtv_frontend_properties schan;
 	u32 value, factor;
 	u32 internal = dib7000p_get_internal_freq(state);
 
 	schan = *ch;
-	schan.u.ofdm.constellation = QAM_64;
-	schan.u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
-	schan.u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
-	schan.u.ofdm.code_rate_HP = FEC_2_3;
-	schan.u.ofdm.code_rate_LP = FEC_3_4;
-	schan.u.ofdm.hierarchy_information = 0;
+	schan.modulation = QAM_64;
+	schan.guard_interval = GUARD_INTERVAL_1_32;
+	schan.transmission_mode = TRANSMISSION_MODE_8K;
+	schan.code_rate_HP = FEC_2_3;
+	schan.code_rate_LP = FEC_3_4;
+	schan.hierarchy = 0;
 
 	dib7000p_set_channel(state, &schan, 7);
 
-	factor = BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth);
+	factor = BANDWIDTH_TO_KHZ(ch->bandwidth_hz);
 	if (factor >= 5000) {
 		if (state->version == SOC7090)
 			factor = 2;
@@ -1240,8 +1243,9 @@ static void dib7000p_spur_protect(struct dib7000p_state *state, u32 rf_khz, u32
 	dib7000p_write_word(state, 143, 0);
 }
 
-static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_parameters *ch)
+static int dib7000p_tune(struct dvb_frontend *demod)
 {
+	struct dtv_frontend_properties *ch = &demod->dtv_property_cache;
 	struct dib7000p_state *state = demod->demodulator_priv;
 	u16 tmp = 0;
 
@@ -1274,7 +1278,7 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 
 	/* P_timf_alpha, P_corm_alpha=6, P_corm_thres=0x80 */
 	tmp = (6 << 8) | 0x80;
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 		tmp |= (2 << 12);
 		break;
@@ -1290,7 +1294,7 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 
 	/* P_ctrl_freeze_pha_shift=0, P_ctrl_pha_off_max */
 	tmp = (0 << 4);
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 		tmp |= 0x6;
 		break;
@@ -1306,7 +1310,7 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 
 	/* P_ctrl_sfreq_inh=0, P_ctrl_sfreq_step */
 	tmp = (0 << 4);
-	switch (ch->u.ofdm.transmission_mode) {
+	switch (ch->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 		tmp |= 0x6;
 		break;
@@ -1338,9 +1342,9 @@ static int dib7000p_tune(struct dvb_frontend *demod, struct dvb_frontend_paramet
 	}
 
 	if (state->cfg.spur_protect)
-		dib7000p_spur_protect(state, ch->frequency / 1000, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth));
+		dib7000p_spur_protect(state, ch->frequency / 1000, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
 
-	dib7000p_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->u.ofdm.bandwidth));
+	dib7000p_set_bandwidth(state, BANDWIDTH_TO_KHZ(ch->bandwidth_hz));
 	return 0;
 }
 
@@ -1380,93 +1384,94 @@ static int dib7000p_identify(struct dib7000p_state *st)
 	return 0;
 }
 
-static int dib7000p_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib7000p_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *fep)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
 	u16 tps = dib7000p_read_word(state, 463);
 
 	fep->inversion = INVERSION_AUTO;
 
-	fep->u.ofdm.bandwidth = BANDWIDTH_TO_INDEX(state->current_bandwidth);
+	fep->bandwidth_hz = BANDWIDTH_TO_HZ(state->current_bandwidth);
 
 	switch ((tps >> 8) & 0x3) {
 	case 0:
-		fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_2K;
+		fep->transmission_mode = TRANSMISSION_MODE_2K;
 		break;
 	case 1:
-		fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_8K;
+		fep->transmission_mode = TRANSMISSION_MODE_8K;
 		break;
-	/* case 2: fep->u.ofdm.transmission_mode = TRANSMISSION_MODE_4K; break; */
+	/* case 2: fep->transmission_mode = TRANSMISSION_MODE_4K; break; */
 	}
 
 	switch (tps & 0x3) {
 	case 0:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_32;
+		fep->guard_interval = GUARD_INTERVAL_1_32;
 		break;
 	case 1:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_16;
+		fep->guard_interval = GUARD_INTERVAL_1_16;
 		break;
 	case 2:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_8;
+		fep->guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		fep->u.ofdm.guard_interval = GUARD_INTERVAL_1_4;
+		fep->guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 
 	switch ((tps >> 14) & 0x3) {
 	case 0:
-		fep->u.ofdm.constellation = QPSK;
+		fep->modulation = QPSK;
 		break;
 	case 1:
-		fep->u.ofdm.constellation = QAM_16;
+		fep->modulation = QAM_16;
 		break;
 	case 2:
 	default:
-		fep->u.ofdm.constellation = QAM_64;
+		fep->modulation = QAM_64;
 		break;
 	}
 
 	/* as long as the frontend_param structure is fixed for hierarchical transmission I refuse to use it */
 	/* (tps >> 13) & 0x1 == hrch is used, (tps >> 10) & 0x7 == alpha */
 
-	fep->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+	fep->hierarchy = HIERARCHY_NONE;
 	switch ((tps >> 5) & 0x7) {
 	case 1:
-		fep->u.ofdm.code_rate_HP = FEC_1_2;
+		fep->code_rate_HP = FEC_1_2;
 		break;
 	case 2:
-		fep->u.ofdm.code_rate_HP = FEC_2_3;
+		fep->code_rate_HP = FEC_2_3;
 		break;
 	case 3:
-		fep->u.ofdm.code_rate_HP = FEC_3_4;
+		fep->code_rate_HP = FEC_3_4;
 		break;
 	case 5:
-		fep->u.ofdm.code_rate_HP = FEC_5_6;
+		fep->code_rate_HP = FEC_5_6;
 		break;
 	case 7:
 	default:
-		fep->u.ofdm.code_rate_HP = FEC_7_8;
+		fep->code_rate_HP = FEC_7_8;
 		break;
 
 	}
 
 	switch ((tps >> 2) & 0x7) {
 	case 1:
-		fep->u.ofdm.code_rate_LP = FEC_1_2;
+		fep->code_rate_LP = FEC_1_2;
 		break;
 	case 2:
-		fep->u.ofdm.code_rate_LP = FEC_2_3;
+		fep->code_rate_LP = FEC_2_3;
 		break;
 	case 3:
-		fep->u.ofdm.code_rate_LP = FEC_3_4;
+		fep->code_rate_LP = FEC_3_4;
 		break;
 	case 5:
-		fep->u.ofdm.code_rate_LP = FEC_5_6;
+		fep->code_rate_LP = FEC_5_6;
 		break;
 	case 7:
 	default:
-		fep->u.ofdm.code_rate_LP = FEC_7_8;
+		fep->code_rate_LP = FEC_7_8;
 		break;
 	}
 
@@ -1475,8 +1480,9 @@ static int dib7000p_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_pa
 	return 0;
 }
 
-static int dib7000p_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib7000p_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache, tmp;
 	struct dib7000p_state *state = fe->demodulator_priv;
 	int time, ret;
 
@@ -1494,16 +1500,17 @@ static int dib7000p_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_pa
 	/* start up the AGC */
 	state->agc_state = 0;
 	do {
-		time = dib7000p_agc_startup(fe, fep);
+		time = dib7000p_agc_startup(fe);
 		if (time != -1)
 			msleep(time);
 	} while (time != -1);
 
-	if (fep->u.ofdm.transmission_mode == TRANSMISSION_MODE_AUTO ||
-		fep->u.ofdm.guard_interval == GUARD_INTERVAL_AUTO || fep->u.ofdm.constellation == QAM_AUTO || fep->u.ofdm.code_rate_HP == FEC_AUTO) {
+	if (fep->transmission_mode == TRANSMISSION_MODE_AUTO ||
+		fep->guard_interval == GUARD_INTERVAL_AUTO || fep->modulation == QAM_AUTO || fep->code_rate_HP == FEC_AUTO) {
 		int i = 800, found;
 
-		dib7000p_autosearch_start(fe, fep);
+		tmp = *fep;
+		dib7000p_autosearch_start(fe);
 		do {
 			msleep(1);
 			found = dib7000p_autosearch_is_irq(fe);
@@ -1513,10 +1520,10 @@ static int dib7000p_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_pa
 		if (found == 0 || found == 1)
 			return 0;
 
-		dib7000p_get_frontend(fe, fep);
+		dib7000p_get_frontend(fe, &tmp);
 	}
 
-	ret = dib7000p_tune(fe, fep);
+	ret = dib7000p_tune(fe);
 
 	/* make this a config parameter */
 	if (state->version == SOC7090) {
@@ -2421,6 +2428,7 @@ error:
 EXPORT_SYMBOL(dib7000p_attach);
 
 static struct dvb_frontend_ops dib7000p_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 7000PC",
 		 .type = FE_OFDM,
@@ -2439,9 +2447,9 @@ static struct dvb_frontend_ops dib7000p_ops = {
 	.init = dib7000p_wakeup,
 	.sleep = dib7000p_sleep,
 
-	.set_frontend_legacy = dib7000p_set_frontend,
+	.set_frontend = dib7000p_set_frontend,
 	.get_tune_settings = dib7000p_fe_get_tune_settings,
-	.get_frontend_legacy = dib7000p_get_frontend,
+	.get_frontend = dib7000p_get_frontend,
 
 	.read_status = dib7000p_read_status,
 	.read_ber = dib7000p_read_ber,
diff --git a/drivers/media/dvb/frontends/dibx000_common.h b/drivers/media/dvb/frontends/dibx000_common.h
index 02e6431..5f48488 100644
--- a/drivers/media/dvb/frontends/dibx000_common.h
+++ b/drivers/media/dvb/frontends/dibx000_common.h
@@ -146,14 +146,8 @@ enum dibx000_adc_states {
 	DIBX000_VBG_DISABLE,
 };
 
-#define BANDWIDTH_TO_KHZ(v) ((v) == BANDWIDTH_8_MHZ  ? 8000 : \
-				(v) == BANDWIDTH_7_MHZ  ? 7000 : \
-				(v) == BANDWIDTH_6_MHZ  ? 6000 : 8000)
-
-#define BANDWIDTH_TO_INDEX(v) ( \
-	(v) == 8000 ? BANDWIDTH_8_MHZ : \
-		(v) == 7000 ? BANDWIDTH_7_MHZ : \
-		(v) == 6000 ? BANDWIDTH_6_MHZ : BANDWIDTH_8_MHZ )
+#define BANDWIDTH_TO_KHZ(v)	((v) / 1000)
+#define BANDWIDTH_TO_HZ(v)	((v) * 1000)
 
 /* Chip output mode. */
 #define OUTMODE_HIGH_Z              0
-- 
1.7.8.352.g876a6

