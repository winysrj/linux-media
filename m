Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386Ab3DYSgE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 14:36:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Olivier Grenie <olivier.grenie@parrot.com>,
	Patrick Boettcher <patrick.boettcher@parrot.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] [media] dib8000: store dtv_property_cache in a temp var
Date: Thu, 25 Apr 2013 15:35:46 -0300
Message-Id: <1366914949-32587-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
References: <1366914949-32587-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dtv_property_cache is used on several places on very long lines.

On all places it is used, a long list of struct reference is done.

Instead of doing it, at the routines where it is used more than once,
replace it by one temporary var. That may help the compiler to
use a better code. It also makes easier to review the code, as the
lines becomes closer to 80 columns, making them a way clearer
to read.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/dib8000.c | 255 ++++++++++++++++++----------------
 1 file changed, 133 insertions(+), 122 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index d065a72..77dac46 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -1941,8 +1941,9 @@ static const u8 permu_seg[] = { 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 0, 12 };
 static u16 dib8000_set_layer(struct dib8000_state *state, u8 layer_index, u16 max_constellation)
 {
 	u8  cr, constellation, time_intlv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 
-	switch (state->fe[0]->dtv_property_cache.layer[layer_index].modulation) {
+	switch (c->layer[layer_index].modulation) {
 	case DQPSK:
 			constellation = 0;
 			break;
@@ -1958,7 +1959,7 @@ static u16 dib8000_set_layer(struct dib8000_state *state, u8 layer_index, u16 ma
 			break;
 	}
 
-	switch (state->fe[0]->dtv_property_cache.layer[layer_index].fec) {
+	switch (c->layer[layer_index].fec) {
 	case FEC_1_2:
 			cr = 1;
 			break;
@@ -1977,22 +1978,22 @@ static u16 dib8000_set_layer(struct dib8000_state *state, u8 layer_index, u16 ma
 			break;
 	}
 
-	if ((state->fe[0]->dtv_property_cache.layer[layer_index].interleaving > 0) && ((state->fe[0]->dtv_property_cache.layer[layer_index].interleaving <= 3) || (state->fe[0]->dtv_property_cache.layer[layer_index].interleaving == 4 && state->fe[0]->dtv_property_cache.isdbt_sb_mode == 1)))
-		time_intlv = state->fe[0]->dtv_property_cache.layer[layer_index].interleaving;
+	if ((c->layer[layer_index].interleaving > 0) && ((c->layer[layer_index].interleaving <= 3) || (c->layer[layer_index].interleaving == 4 && c->isdbt_sb_mode == 1)))
+		time_intlv = c->layer[layer_index].interleaving;
 	else
 		time_intlv = 0;
 
-	dib8000_write_word(state, 2 + layer_index, (constellation << 10) | ((state->fe[0]->dtv_property_cache.layer[layer_index].segment_count & 0xf) << 6) | (cr << 3) | time_intlv);
-	if (state->fe[0]->dtv_property_cache.layer[layer_index].segment_count > 0) {
+	dib8000_write_word(state, 2 + layer_index, (constellation << 10) | ((c->layer[layer_index].segment_count & 0xf) << 6) | (cr << 3) | time_intlv);
+	if (c->layer[layer_index].segment_count > 0) {
 		switch (max_constellation) {
 		case DQPSK:
 		case QPSK:
-				if (state->fe[0]->dtv_property_cache.layer[layer_index].modulation == QAM_16 || state->fe[0]->dtv_property_cache.layer[layer_index].modulation == QAM_64)
-					max_constellation = state->fe[0]->dtv_property_cache.layer[layer_index].modulation;
+				if (c->layer[layer_index].modulation == QAM_16 || c->layer[layer_index].modulation == QAM_64)
+					max_constellation = c->layer[layer_index].modulation;
 				break;
 		case QAM_16:
-				if (state->fe[0]->dtv_property_cache.layer[layer_index].modulation == QAM_64)
-					max_constellation = state->fe[0]->dtv_property_cache.layer[layer_index].modulation;
+				if (c->layer[layer_index].modulation == QAM_64)
+					max_constellation = c->layer[layer_index].modulation;
 				break;
 		}
 	}
@@ -2135,30 +2136,31 @@ static void dib8000_small_fine_tune(struct dib8000_state *state)
 {
 	u16 i;
 	const s16 *ncoeff;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 
 	dib8000_write_word(state, 352, state->seg_diff_mask);
 	dib8000_write_word(state, 353, state->seg_mask);
 
 	/* P_small_coef_ext_enable=ISDB-Tsb, P_small_narrow_band=ISDB-Tsb, P_small_last_seg=13, P_small_offset_num_car=5 */
-	dib8000_write_word(state, 351, (state->fe[0]->dtv_property_cache.isdbt_sb_mode << 9) | (state->fe[0]->dtv_property_cache.isdbt_sb_mode << 8) | (13 << 4) | 5);
+	dib8000_write_word(state, 351, (c->isdbt_sb_mode << 9) | (c->isdbt_sb_mode << 8) | (13 << 4) | 5);
 
-	if (state->fe[0]->dtv_property_cache.isdbt_sb_mode) {
+	if (c->isdbt_sb_mode) {
 		/* ---- SMALL ---- */
-		switch (state->fe[0]->dtv_property_cache.transmission_mode) {
+		switch (c->transmission_mode) {
 		case TRANSMISSION_MODE_2K:
-				if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0) { /* 1-seg */
-					if (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) /* DQPSK */
+				if (c->isdbt_partial_reception == 0) { /* 1-seg */
+					if (c->layer[0].modulation == DQPSK) /* DQPSK */
 						ncoeff = coeff_2k_sb_1seg_dqpsk;
 					else /* QPSK or QAM */
 						ncoeff = coeff_2k_sb_1seg;
 				} else { /* 3-segments */
-					if (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) { /* DQPSK on central segment */
-						if (state->fe[0]->dtv_property_cache.layer[1].modulation == DQPSK) /* DQPSK on external segments */
+					if (c->layer[0].modulation == DQPSK) { /* DQPSK on central segment */
+						if (c->layer[1].modulation == DQPSK) /* DQPSK on external segments */
 							ncoeff = coeff_2k_sb_3seg_0dqpsk_1dqpsk;
 						else /* QPSK or QAM on external segments */
 							ncoeff = coeff_2k_sb_3seg_0dqpsk;
 					} else { /* QPSK or QAM on central segment */
-						if (state->fe[0]->dtv_property_cache.layer[1].modulation == DQPSK) /* DQPSK on external segments */
+						if (c->layer[1].modulation == DQPSK) /* DQPSK on external segments */
 							ncoeff = coeff_2k_sb_3seg_1dqpsk;
 						else /* QPSK or QAM on external segments */
 							ncoeff = coeff_2k_sb_3seg;
@@ -2166,19 +2168,19 @@ static void dib8000_small_fine_tune(struct dib8000_state *state)
 				}
 				break;
 		case TRANSMISSION_MODE_4K:
-				if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0) { /* 1-seg */
-					if (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) /* DQPSK */
+				if (c->isdbt_partial_reception == 0) { /* 1-seg */
+					if (c->layer[0].modulation == DQPSK) /* DQPSK */
 						ncoeff = coeff_4k_sb_1seg_dqpsk;
 					else /* QPSK or QAM */
 						ncoeff = coeff_4k_sb_1seg;
 				} else { /* 3-segments */
-					if (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) { /* DQPSK on central segment */
-						if (state->fe[0]->dtv_property_cache.layer[1].modulation == DQPSK) /* DQPSK on external segments */
+					if (c->layer[0].modulation == DQPSK) { /* DQPSK on central segment */
+						if (c->layer[1].modulation == DQPSK) /* DQPSK on external segments */
 							ncoeff = coeff_4k_sb_3seg_0dqpsk_1dqpsk;
 						else /* QPSK or QAM on external segments */
 							ncoeff = coeff_4k_sb_3seg_0dqpsk;
 					} else { /* QPSK or QAM on central segment */
-						if (state->fe[0]->dtv_property_cache.layer[1].modulation == DQPSK) /* DQPSK on external segments */
+						if (c->layer[1].modulation == DQPSK) /* DQPSK on external segments */
 							ncoeff = coeff_4k_sb_3seg_1dqpsk;
 						else /* QPSK or QAM on external segments */
 							ncoeff = coeff_4k_sb_3seg;
@@ -2188,19 +2190,19 @@ static void dib8000_small_fine_tune(struct dib8000_state *state)
 		case TRANSMISSION_MODE_AUTO:
 		case TRANSMISSION_MODE_8K:
 		default:
-				if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0) { /* 1-seg */
-					if (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) /* DQPSK */
+				if (c->isdbt_partial_reception == 0) { /* 1-seg */
+					if (c->layer[0].modulation == DQPSK) /* DQPSK */
 						ncoeff = coeff_8k_sb_1seg_dqpsk;
 					else /* QPSK or QAM */
 						ncoeff = coeff_8k_sb_1seg;
 				} else { /* 3-segments */
-					if (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) { /* DQPSK on central segment */
-						if (state->fe[0]->dtv_property_cache.layer[1].modulation == DQPSK) /* DQPSK on external segments */
+					if (c->layer[0].modulation == DQPSK) { /* DQPSK on central segment */
+						if (c->layer[1].modulation == DQPSK) /* DQPSK on external segments */
 							ncoeff = coeff_8k_sb_3seg_0dqpsk_1dqpsk;
 						else /* QPSK or QAM on external segments */
 							ncoeff = coeff_8k_sb_3seg_0dqpsk;
 					} else { /* QPSK or QAM on central segment */
-						if (state->fe[0]->dtv_property_cache.layer[1].modulation == DQPSK) /* DQPSK on external segments */
+						if (c->layer[1].modulation == DQPSK) /* DQPSK on external segments */
 							ncoeff = coeff_8k_sb_3seg_1dqpsk;
 						else /* QPSK or QAM on external segments */
 							ncoeff = coeff_8k_sb_3seg;
@@ -2218,10 +2220,11 @@ static const u16 coff_thres_1seg[3] = {300, 150, 80};
 static const u16 coff_thres_3seg[3] = {350, 300, 250};
 static void dib8000_set_sb_channel(struct dib8000_state *state)
 {
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	const u16 *coff;
 	u16 i;
 
-	if (state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_2K || state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_4K) {
+	if (c->transmission_mode == TRANSMISSION_MODE_2K || c->transmission_mode == TRANSMISSION_MODE_4K) {
 		dib8000_write_word(state, 219, dib8000_read_word(state, 219) | 0x1); /* adp_pass =1 */
 		dib8000_write_word(state, 190, dib8000_read_word(state, 190) | (0x1 << 14)); /* pha3_force_pha_shift = 1 */
 	} else {
@@ -2229,7 +2232,7 @@ static void dib8000_set_sb_channel(struct dib8000_state *state)
 		dib8000_write_word(state, 190, dib8000_read_word(state, 190) & 0xbfff); /* pha3_force_pha_shift = 0 */
 	}
 
-	if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 1) /* 3-segments */
+	if (c->isdbt_partial_reception == 1) /* 3-segments */
 		state->seg_mask = 0x00E0;
 	else /* 1-segment */
 		state->seg_mask = 0x0040;
@@ -2238,13 +2241,13 @@ static void dib8000_set_sb_channel(struct dib8000_state *state)
 
 	/* ---- COFF ---- Carloff, the most robust --- */
 	/* P_coff_cpil_alpha=4, P_coff_inh=0, P_coff_cpil_winlen=64, P_coff_narrow_band=1, P_coff_square_val=1, P_coff_one_seg=~partial_rcpt, P_coff_use_tmcc=1, P_coff_use_ac=1 */
-	dib8000_write_word(state, 187, (4 << 12) | (0 << 11) | (63 << 5) | (0x3 << 3) | ((~state->fe[0]->dtv_property_cache.isdbt_partial_reception & 1) << 2) | 0x3);
+	dib8000_write_word(state, 187, (4 << 12) | (0 << 11) | (63 << 5) | (0x3 << 3) | ((~c->isdbt_partial_reception & 1) << 2) | 0x3);
 
 	dib8000_write_word(state, 340, (16 << 6) | (8 << 0)); /* P_ctrl_pre_freq_win_len=16, P_ctrl_pre_freq_thres_lockin=8 */
 	dib8000_write_word(state, 341, (6 << 3) | (1 << 2) | (1 << 1) | (1 << 0));/* P_ctrl_pre_freq_thres_lockout=6, P_small_use_tmcc/ac/cp=1 */
 
 	/* Sound Broadcasting mode 1 seg */
-	if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0) {
+	if (c->isdbt_partial_reception == 0) {
 		/* P_coff_winlen=63, P_coff_thres_lock=15, P_coff_one_seg_width = (P_mode == 3) , P_coff_one_seg_sym = (P_mode-1) */
 		if (state->mode == 3)
 			dib8000_write_word(state, 180, 0x1fcf | ((state->mode - 1) << 14));
@@ -2264,7 +2267,7 @@ static void dib8000_set_sb_channel(struct dib8000_state *state)
 	dib8000_write_word(state, 228, 1); /* P_2d_mode_byp=1 */
 	dib8000_write_word(state, 205, dib8000_read_word(state, 205) & 0xfff0); /* P_cspu_win_cut = 0 */
 
-	if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0 && state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_2K)
+	if (c->isdbt_partial_reception == 0 && c->transmission_mode == TRANSMISSION_MODE_2K)
 		dib8000_write_word(state, 265, 15); /* P_equal_noise_sel = 15 */
 
 	/* Write COFF thres */
@@ -2280,7 +2283,7 @@ static void dib8000_set_sb_channel(struct dib8000_state *state)
 
 	dib8000_write_word(state, 266, ~state->seg_mask | state->seg_diff_mask); /* P_equal_noise_seg_inh */
 
-	if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0)
+	if (c->isdbt_partial_reception == 0)
 		dib8000_write_word(state, 178, 64); /* P_fft_powrange = 64 */
 	else
 		dib8000_write_word(state, 178, 32); /* P_fft_powrange = 32 */
@@ -2292,6 +2295,7 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	u16 tmcc_pow = 0, ana_gain = 0, tmp = 0, i = 0, nbseg_diff = 0 ;
 	u16 max_constellation = DQPSK;
 	int init_prbs;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 
 	/* P_mode */
 	dib8000_write_word(state, 10, (seq << 4));
@@ -2301,20 +2305,20 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 
 	/* set guard */
 	tmp = dib8000_read_word(state, 1);
-	dib8000_write_word(state, 1, (tmp&0xfffc) | (state->fe[0]->dtv_property_cache.guard_interval & 0x3));
+	dib8000_write_word(state, 1, (tmp&0xfffc) | (c->guard_interval & 0x3));
 
-	dib8000_write_word(state, 274, (dib8000_read_word(state, 274) & 0xffcf) | ((state->fe[0]->dtv_property_cache.isdbt_partial_reception & 1) << 5) | ((state->fe[0]->dtv_property_cache.isdbt_sb_mode & 1) << 4));
+	dib8000_write_word(state, 274, (dib8000_read_word(state, 274) & 0xffcf) | ((c->isdbt_partial_reception & 1) << 5) | ((c->isdbt_sb_mode & 1) << 4));
 
 	/* signal optimization parameter */
-	if (state->fe[0]->dtv_property_cache.isdbt_partial_reception) {
-		state->seg_diff_mask = (state->fe[0]->dtv_property_cache.layer[0].modulation == DQPSK) << permu_seg[0];
+	if (c->isdbt_partial_reception) {
+		state->seg_diff_mask = (c->layer[0].modulation == DQPSK) << permu_seg[0];
 		for (i = 1; i < 3; i++)
-			nbseg_diff += (state->fe[0]->dtv_property_cache.layer[i].modulation == DQPSK) * state->fe[0]->dtv_property_cache.layer[i].segment_count;
+			nbseg_diff += (c->layer[i].modulation == DQPSK) * c->layer[i].segment_count;
 		for (i = 0; i < nbseg_diff; i++)
 			state->seg_diff_mask |= 1 << permu_seg[i+1];
 	} else {
 		for (i = 0; i < 3; i++)
-			nbseg_diff += (state->fe[0]->dtv_property_cache.layer[i].modulation == DQPSK) * state->fe[0]->dtv_property_cache.layer[i].segment_count;
+			nbseg_diff += (c->layer[i].modulation == DQPSK) * c->layer[i].segment_count;
 		for (i = 0; i < nbseg_diff; i++)
 			state->seg_diff_mask |= 1 << permu_seg[i];
 	}
@@ -2327,8 +2331,8 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	for (i = 0; i < 3; i++)
 		max_constellation = dib8000_set_layer(state, i, max_constellation);
 	if (autosearching == 0) {
-		state->layer_b_nb_seg = state->fe[0]->dtv_property_cache.layer[1].segment_count;
-		state->layer_c_nb_seg = state->fe[0]->dtv_property_cache.layer[2].segment_count;
+		state->layer_b_nb_seg = c->layer[1].segment_count;
+		state->layer_c_nb_seg = c->layer[2].segment_count;
 	}
 
 	/* WRITE: Mode & Diff mask */
@@ -2343,16 +2347,16 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	dib8000_update_ana_gain(state, ana_gain);
 
 	/* ---- ANA_FE ---- */
-	if (state->fe[0]->dtv_property_cache.isdbt_partial_reception) /* 3-segments */
+	if (c->isdbt_partial_reception) /* 3-segments */
 		dib8000_load_ana_fe_coefs(state, ana_fe_coeff_3seg);
 	else
 		dib8000_load_ana_fe_coefs(state, ana_fe_coeff_1seg); /* 1-segment */
 
 	/* TSB or ISDBT ? apply it now */
-	if (state->fe[0]->dtv_property_cache.isdbt_sb_mode) {
+	if (c->isdbt_sb_mode) {
 		dib8000_set_sb_channel(state);
-		if (state->fe[0]->dtv_property_cache.isdbt_sb_subchannel != -1)
-			init_prbs = dib8000_get_init_prbs(state, state->fe[0]->dtv_property_cache.isdbt_sb_subchannel);
+		if (c->isdbt_sb_subchannel != -1)
+			init_prbs = dib8000_get_init_prbs(state, c->isdbt_sb_subchannel);
 		else
 			init_prbs = 0;
 	} else {
@@ -2392,7 +2396,7 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 
 	/* ---- TMCC ---- */
 	for (i = 0; i < 3; i++)
-		tmcc_pow += (((state->fe[0]->dtv_property_cache.layer[i].modulation == DQPSK) * 4 + 1) * state->fe[0]->dtv_property_cache.layer[i].segment_count) ;
+		tmcc_pow += (((c->layer[i].modulation == DQPSK) * 4 + 1) * c->layer[i].segment_count) ;
 
 	/* Quantif of "P_tmcc_dec_thres_?k" is (0, 5+mode, 9); */
 	/* Threshold is set at 1/4 of max power. */
@@ -2434,6 +2438,7 @@ static u32 dib8000_wait_lock(struct dib8000_state *state, u32 internal,
 static int dib8000_autosearch_start(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	u8 slist = 0;
 	u32 value, internal = state->cfg.pll->internal;
 
@@ -2477,16 +2482,16 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (0 << 13)); /* P_restart_ccg = 0 */
 		dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x7ff) | (0 << 15) | (1 << 13)); /* P_restart_search = 0; */
 	} else if (state->autosearch_state == AS_SEARCHING_GUARD) {
-		state->fe[0]->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_8K;
-		state->fe[0]->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_8;
-		state->fe[0]->dtv_property_cache.inversion = 0;
-		state->fe[0]->dtv_property_cache.layer[0].modulation = QAM_64;
-		state->fe[0]->dtv_property_cache.layer[0].fec = FEC_2_3;
-		state->fe[0]->dtv_property_cache.layer[0].interleaving = 0;
-		state->fe[0]->dtv_property_cache.layer[0].segment_count = 13;
+		c->transmission_mode = TRANSMISSION_MODE_8K;
+		c->guard_interval = GUARD_INTERVAL_1_8;
+		c->inversion = 0;
+		c->layer[0].modulation = QAM_64;
+		c->layer[0].fec = FEC_2_3;
+		c->layer[0].interleaving = 0;
+		c->layer[0].segment_count = 13;
 
 		slist = 16;
-		state->fe[0]->dtv_property_cache.transmission_mode = state->found_nfft;
+		c->transmission_mode = state->found_nfft;
 
 		dib8000_set_isdbt_common_channel(state, slist, 1);
 
@@ -2515,32 +2520,32 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 		dib8000_read_word(state, 1284);  /* reset the INT. n_irq_pending */
 		dib8000_write_word(state, 0, (u16)value);
 	} else {
-		state->fe[0]->dtv_property_cache.inversion = 0;
-		state->fe[0]->dtv_property_cache.layer[0].modulation = QAM_64;
-		state->fe[0]->dtv_property_cache.layer[0].fec = FEC_2_3;
-		state->fe[0]->dtv_property_cache.layer[0].interleaving = 0;
-		state->fe[0]->dtv_property_cache.layer[0].segment_count = 13;
-		if (!state->fe[0]->dtv_property_cache.isdbt_sb_mode)
-			state->fe[0]->dtv_property_cache.layer[0].segment_count = 13;
+		c->inversion = 0;
+		c->layer[0].modulation = QAM_64;
+		c->layer[0].fec = FEC_2_3;
+		c->layer[0].interleaving = 0;
+		c->layer[0].segment_count = 13;
+		if (!c->isdbt_sb_mode)
+			c->layer[0].segment_count = 13;
 
 		/* choose the right list, in sb, always do everything */
-		if (state->fe[0]->dtv_property_cache.isdbt_sb_mode) {
+		if (c->isdbt_sb_mode) {
 			slist = 7;
 			dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x9fff) | (1 << 13));
 		} else {
-			if (state->fe[0]->dtv_property_cache.guard_interval == GUARD_INTERVAL_AUTO) {
-				if (state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_AUTO) {
-					state->fe[0]->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_8K;
-					state->fe[0]->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_8;
+			if (c->guard_interval == GUARD_INTERVAL_AUTO) {
+				if (c->transmission_mode == TRANSMISSION_MODE_AUTO) {
+					c->transmission_mode = TRANSMISSION_MODE_8K;
+					c->guard_interval = GUARD_INTERVAL_1_8;
 					slist = 7;
 					dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x9fff) | (1 << 13));  /* P_mode = 1 to have autosearch start ok with mode2 */
 				} else {
-					state->fe[0]->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_8;
+					c->guard_interval = GUARD_INTERVAL_1_8;
 					slist = 3;
 				}
 			} else {
-				if (state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_AUTO) {
-					state->fe[0]->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_8K;
+				if (c->transmission_mode == TRANSMISSION_MODE_AUTO) {
+					c->transmission_mode = TRANSMISSION_MODE_8K;
 					slist = 2;
 					dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x9fff) | (1 << 13));  /* P_mode = 1 */
 				} else
@@ -2653,6 +2658,7 @@ static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 
 static void dib8000_set_frequency_offset(struct dib8000_state *state)
 {
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	int i;
 	u32 current_rf;
 	int total_dds_offset_khz;
@@ -2660,26 +2666,26 @@ static void dib8000_set_frequency_offset(struct dib8000_state *state)
 	if (state->fe[0]->ops.tuner_ops.get_frequency)
 		state->fe[0]->ops.tuner_ops.get_frequency(state->fe[0], &current_rf);
 	else
-		current_rf = state->fe[0]->dtv_property_cache.frequency;
+		current_rf = c->frequency;
 	current_rf /= 1000;
-	total_dds_offset_khz = (int)current_rf - (int)state->fe[0]->dtv_property_cache.frequency / 1000;
+	total_dds_offset_khz = (int)current_rf - (int)c->frequency / 1000;
 
-	if (state->fe[0]->dtv_property_cache.isdbt_sb_mode) {
-		state->subchannel = state->fe[0]->dtv_property_cache.isdbt_sb_subchannel;
+	if (c->isdbt_sb_mode) {
+		state->subchannel = c->isdbt_sb_subchannel;
 
 		i = dib8000_read_word(state, 26) & 1; /* P_dds_invspec */
-		dib8000_write_word(state, 26, state->fe[0]->dtv_property_cache.inversion ^ i);
+		dib8000_write_word(state, 26, c->inversion ^ i);
 
 		if (state->cfg.pll->ifreq == 0) { /* low if tuner */
-			if ((state->fe[0]->dtv_property_cache.inversion ^ i) == 0)
+			if ((c->inversion ^ i) == 0)
 				dib8000_write_word(state, 26, dib8000_read_word(state, 26) | 1);
 		} else {
-			if ((state->fe[0]->dtv_property_cache.inversion ^ i) == 0)
+			if ((c->inversion ^ i) == 0)
 				total_dds_offset_khz *= -1;
 		}
 	}
 
-	dprintk("%dkhz tuner offset (frequency = %dHz & current_rf = %dHz) total_dds_offset_hz = %d", state->fe[0]->dtv_property_cache.frequency - current_rf, state->fe[0]->dtv_property_cache.frequency, current_rf, total_dds_offset_khz);
+	dprintk("%dkhz tuner offset (frequency = %dHz & current_rf = %dHz) total_dds_offset_hz = %d", c->frequency - current_rf, c->frequency, current_rf, total_dds_offset_khz);
 
 	/* apply dds offset now */
 	dib8000_set_dds(state, total_dds_offset_khz);
@@ -2689,9 +2695,10 @@ static u16 LUT_isdbt_symbol_duration[4] = { 26, 101, 63 };
 
 static u32 dib8000_get_symbol_duration(struct dib8000_state *state)
 {
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	u16 i;
 
-	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
+	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_2K:
 			i = 0;
 			break;
@@ -2705,17 +2712,18 @@ static u32 dib8000_get_symbol_duration(struct dib8000_state *state)
 			break;
 	}
 
-	return (LUT_isdbt_symbol_duration[i] / (state->fe[0]->dtv_property_cache.bandwidth_hz / 1000)) + 1;
+	return (LUT_isdbt_symbol_duration[i] / (c->bandwidth_hz / 1000)) + 1;
 }
 
 static void dib8000_set_isdbt_loop_params(struct dib8000_state *state, enum param_loop_step loop_step)
 {
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	u16 reg_32 = 0, reg_37 = 0;
 
 	switch (loop_step) {
 	case LOOP_TUNE_1:
-			if (state->fe[0]->dtv_property_cache.isdbt_sb_mode)  {
-				if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0) {
+			if (c->isdbt_sb_mode)  {
+				if (c->isdbt_partial_reception == 0) {
 					reg_32 = ((11 - state->mode) << 12) | (6 << 8) | 0x40; /* P_timf_alpha = (11-P_mode), P_corm_alpha=6, P_corm_thres=0x40 */
 					reg_37 = (3 << 5) | (0 << 4) | (10 - state->mode); /* P_ctrl_pha_off_max=3   P_ctrl_sfreq_inh =0  P_ctrl_sfreq_step = (10-P_mode)  */
 				} else { /* Sound Broadcasting mode 3 seg */
@@ -2728,8 +2736,8 @@ static void dib8000_set_isdbt_loop_params(struct dib8000_state *state, enum para
 			}
 			break;
 	case LOOP_TUNE_2:
-			if (state->fe[0]->dtv_property_cache.isdbt_sb_mode)  {
-				if (state->fe[0]->dtv_property_cache.isdbt_partial_reception == 0) {  /* Sound Broadcasting mode 1 seg */
+			if (c->isdbt_sb_mode)  {
+				if (c->isdbt_partial_reception == 0) {  /* Sound Broadcasting mode 1 seg */
 					reg_32 = ((13-state->mode) << 12) | (6 << 8) | 0x40; /* P_timf_alpha = (13-P_mode) , P_corm_alpha=6, P_corm_thres=0x40*/
 					reg_37 = (12-state->mode) | ((5 + state->mode) << 5);
 				} else {  /* Sound Broadcasting mode 3 seg */
@@ -2755,10 +2763,11 @@ static void dib8000_demod_restart(struct dib8000_state *state)
 
 static void dib8000_set_sync_wait(struct dib8000_state *state)
 {
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	u16 sync_wait = 64;
 
 	/* P_dvsy_sync_wait - reuse mode */
-	switch (state->fe[0]->dtv_property_cache.transmission_mode) {
+	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_8K:
 			sync_wait = 256;
 			break;
@@ -2772,9 +2781,9 @@ static void dib8000_set_sync_wait(struct dib8000_state *state)
 	}
 
 	if (state->cfg.diversity_delay == 0)
-		sync_wait = (sync_wait * (1 << (state->fe[0]->dtv_property_cache.guard_interval)) * 3) / 2 + 48; /* add 50% SFN margin + compensate for one DVSY-fifo */
+		sync_wait = (sync_wait * (1 << (c->guard_interval)) * 3) / 2 + 48; /* add 50% SFN margin + compensate for one DVSY-fifo */
 	else
-		sync_wait = (sync_wait * (1 << (state->fe[0]->dtv_property_cache.guard_interval)) * 3) / 2 + state->cfg.diversity_delay; /* add 50% SFN margin + compensate for DVSY-fifo */
+		sync_wait = (sync_wait * (1 << (c->guard_interval)) * 3) / 2 + state->cfg.diversity_delay; /* add 50% SFN margin + compensate for DVSY-fifo */
 
 	dib8000_write_word(state, 273, (dib8000_read_word(state, 273) & 0x000f) | (sync_wait << 4));
 }
@@ -2847,6 +2856,7 @@ static int dib8090p_init_sdram(struct dib8000_state *state)
 static int dib8000_tune(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	enum frontend_tune_state *tune_state = &state->tune_state;
 
 	u16 locks, deeper_interleaver = 0, i;
@@ -2871,30 +2881,30 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			if (state->revision == 0x8090)
 				dib8090p_init_sdram(state);
 			state->status = FE_STATUS_TUNE_PENDING;
-			if ((state->fe[0]->dtv_property_cache.delivery_system != SYS_ISDBT) ||
-					(state->fe[0]->dtv_property_cache.inversion == INVERSION_AUTO) ||
-					(state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_AUTO) ||
-					(state->fe[0]->dtv_property_cache.guard_interval == GUARD_INTERVAL_AUTO) ||
-					(((state->fe[0]->dtv_property_cache.isdbt_layer_enabled & (1 << 0)) != 0) &&
-					 (state->fe[0]->dtv_property_cache.layer[0].segment_count != 0xff) &&
-					 (state->fe[0]->dtv_property_cache.layer[0].segment_count != 0) &&
-					 ((state->fe[0]->dtv_property_cache.layer[0].modulation == QAM_AUTO) ||
-					  (state->fe[0]->dtv_property_cache.layer[0].fec == FEC_AUTO))) ||
-					(((state->fe[0]->dtv_property_cache.isdbt_layer_enabled & (1 << 1)) != 0) &&
-					 (state->fe[0]->dtv_property_cache.layer[1].segment_count != 0xff) &&
-					 (state->fe[0]->dtv_property_cache.layer[1].segment_count != 0) &&
-					 ((state->fe[0]->dtv_property_cache.layer[1].modulation == QAM_AUTO) ||
-					  (state->fe[0]->dtv_property_cache.layer[1].fec == FEC_AUTO))) ||
-					(((state->fe[0]->dtv_property_cache.isdbt_layer_enabled & (1 << 2)) != 0) &&
-					 (state->fe[0]->dtv_property_cache.layer[2].segment_count != 0xff) &&
-					 (state->fe[0]->dtv_property_cache.layer[2].segment_count != 0) &&
-					 ((state->fe[0]->dtv_property_cache.layer[2].modulation == QAM_AUTO) ||
-					  (state->fe[0]->dtv_property_cache.layer[2].fec == FEC_AUTO))) ||
-					(((state->fe[0]->dtv_property_cache.layer[0].segment_count == 0) ||
-					  ((state->fe[0]->dtv_property_cache.isdbt_layer_enabled & (1 << 0)) == 0)) &&
-					 ((state->fe[0]->dtv_property_cache.layer[1].segment_count == 0) ||
-					  ((state->fe[0]->dtv_property_cache.isdbt_layer_enabled & (2 << 0)) == 0)) &&
-					 ((state->fe[0]->dtv_property_cache.layer[2].segment_count == 0) || ((state->fe[0]->dtv_property_cache.isdbt_layer_enabled & (3 << 0)) == 0))))
+			if ((c->delivery_system != SYS_ISDBT) ||
+					(c->inversion == INVERSION_AUTO) ||
+					(c->transmission_mode == TRANSMISSION_MODE_AUTO) ||
+					(c->guard_interval == GUARD_INTERVAL_AUTO) ||
+					(((c->isdbt_layer_enabled & (1 << 0)) != 0) &&
+					 (c->layer[0].segment_count != 0xff) &&
+					 (c->layer[0].segment_count != 0) &&
+					 ((c->layer[0].modulation == QAM_AUTO) ||
+					  (c->layer[0].fec == FEC_AUTO))) ||
+					(((c->isdbt_layer_enabled & (1 << 1)) != 0) &&
+					 (c->layer[1].segment_count != 0xff) &&
+					 (c->layer[1].segment_count != 0) &&
+					 ((c->layer[1].modulation == QAM_AUTO) ||
+					  (c->layer[1].fec == FEC_AUTO))) ||
+					(((c->isdbt_layer_enabled & (1 << 2)) != 0) &&
+					 (c->layer[2].segment_count != 0xff) &&
+					 (c->layer[2].segment_count != 0) &&
+					 ((c->layer[2].modulation == QAM_AUTO) ||
+					  (c->layer[2].fec == FEC_AUTO))) ||
+					(((c->layer[0].segment_count == 0) ||
+					  ((c->isdbt_layer_enabled & (1 << 0)) == 0)) &&
+					 ((c->layer[1].segment_count == 0) ||
+					  ((c->isdbt_layer_enabled & (2 << 0)) == 0)) &&
+					 ((c->layer[2].segment_count == 0) || ((c->isdbt_layer_enabled & (3 << 0)) == 0))))
 				state->channel_parameters_set = 0; /* auto search */
 			else
 				state->channel_parameters_set = 1; /* channel parameters are known */
@@ -2905,7 +2915,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			dib8000_write_word(state, 285, dib8000_read_word(state, 285) & 0x60);
 
 			dib8000_set_frequency_offset(state);
-			dib8000_set_bandwidth(fe, state->fe[0]->dtv_property_cache.bandwidth_hz / 1000);
+			dib8000_set_bandwidth(fe, c->bandwidth_hz / 1000);
 
 			if (state->channel_parameters_set == 0) { /* The channel struct is unknown, search it ! */
 #ifdef DIB8000_AGC_FREEZE
@@ -3092,7 +3102,7 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
 
 			/* mpeg will never lock on this condition because init_prbs is not set : search for it !*/
-			if (state->fe[0]->dtv_property_cache.isdbt_sb_mode && state->fe[0]->dtv_property_cache.isdbt_sb_subchannel == -1 && !state->differential_constellation) {
+			if (c->isdbt_sb_mode && c->isdbt_sb_subchannel == -1 && !state->differential_constellation) {
 				state->subchannel = 0;
 				*tune_state = CT_DEMOD_STEP_11;
 			} else {
@@ -3105,10 +3115,10 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			if ((state->revision == 0x8090) || ((dib8000_read_word(state, 1291) >> 9) & 0x1)) { /* fe capable of deinterleaving : esram */
 				/* defines timeout for mpeg lock depending on interleaver lenght of longest layer */
 				for (i = 0; i < 3; i++) {
-					if (state->fe[0]->dtv_property_cache.layer[i].interleaving >= deeper_interleaver) {
-						dprintk("layer%i: time interleaver = %d ", i, state->fe[0]->dtv_property_cache.layer[i].interleaving);
-						if (state->fe[0]->dtv_property_cache.layer[i].segment_count > 0) { /* valid layer */
-							deeper_interleaver = state->fe[0]->dtv_property_cache.layer[0].interleaving;
+					if (c->layer[i].interleaving >= deeper_interleaver) {
+						dprintk("layer%i: time interleaver = %d ", i, c->layer[i].interleaving);
+						if (c->layer[i].segment_count > 0) { /* valid layer */
+							deeper_interleaver = c->layer[0].interleaving;
 							state->longest_intlv_layer = i;
 						}
 					}
@@ -3136,14 +3146,14 @@ static int dib8000_tune(struct dvb_frontend *fe)
 			locks = dib8000_read_lock(fe);
 			if (locks&(1<<(7-state->longest_intlv_layer))) { /* mpeg lock : check the longest one */
 				dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
-				if (state->fe[0]->dtv_property_cache.isdbt_sb_mode && state->fe[0]->dtv_property_cache.isdbt_sb_subchannel == -1 && !state->differential_constellation)
+				if (c->isdbt_sb_mode && c->isdbt_sb_subchannel == -1 && !state->differential_constellation)
 					/* signal to the upper layer, that there was a channel found and the parameters can be read */
 					state->status = FE_STATUS_DEMOD_SUCCESS;
 				else
 					state->status = FE_STATUS_DATA_LOCKED;
 				*tune_state = CT_DEMOD_STOP;
 			} else if (now > *timeout) {
-				if (state->fe[0]->dtv_property_cache.isdbt_sb_mode && state->fe[0]->dtv_property_cache.isdbt_sb_subchannel == -1 && !state->differential_constellation) { /* continue to try init prbs autosearch */
+				if (c->isdbt_sb_mode && c->isdbt_sb_subchannel == -1 && !state->differential_constellation) { /* continue to try init prbs autosearch */
 					state->subchannel += 3;
 					*tune_state = CT_DEMOD_STEP_11;
 				} else { /* we are done mpeg of the longest interleaver xas not locking but let's try if an other layer has locked in the same time */
@@ -3389,18 +3399,19 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 static int dib8000_set_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 	int l, i, active, time, ret, time_slave = FE_CALLBACK_TIME_NEVER;
 	u8 exit_condition, index_frontend;
 	u32 delay, callback_time;
 
-	if (state->fe[0]->dtv_property_cache.frequency == 0) {
+	if (c->frequency == 0) {
 		dprintk("dib8000: must at least specify frequency ");
 		return 0;
 	}
 
-	if (state->fe[0]->dtv_property_cache.bandwidth_hz == 0) {
+	if (c->bandwidth_hz == 0) {
 		dprintk("dib8000: no bandwidth specified, set to default ");
-		state->fe[0]->dtv_property_cache.bandwidth_hz = 6000000;
+		c->bandwidth_hz = 6000000;
 	}
 
 	for (index_frontend = 0; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
-- 
1.8.1.4

