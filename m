Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaGBPxt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:53:49 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 3/9] dib8000: Fix alignments at dib8000_tune()
Date: Wed,  2 Jul 2014 12:52:17 -0300
Message-Id: <1404316343-23856-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two tabs instead of one aligning this struct.
Worse than that, on some places, the alignment is wrong.
Fix it.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 486 +++++++++++++++++-----------------
 1 file changed, 243 insertions(+), 243 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index fc034b4e1f99..273e7a9d78a2 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3019,313 +3019,313 @@ static int dib8000_tune(struct dvb_frontend *fe)
 
 	switch (*tune_state) {
 	case CT_DEMOD_START: /* 30 */
-			dib8000_reset_stats(fe);
+		dib8000_reset_stats(fe);
 
-			if (state->revision == 0x8090)
-				dib8090p_init_sdram(state);
-			state->status = FE_STATUS_TUNE_PENDING;
-			state->channel_parameters_set = is_manual_mode(c);
+		if (state->revision == 0x8090)
+			dib8090p_init_sdram(state);
+		state->status = FE_STATUS_TUNE_PENDING;
+		state->channel_parameters_set = is_manual_mode(c);
 
-			dprintk("Tuning channel on %s search mode",
-				state->channel_parameters_set ? "manual" : "auto");
+		dprintk("Tuning channel on %s search mode",
+			state->channel_parameters_set ? "manual" : "auto");
 
-			dib8000_viterbi_state(state, 0); /* force chan dec in restart */
+		dib8000_viterbi_state(state, 0); /* force chan dec in restart */
 
-			/* Layer monitor */
-			dib8000_write_word(state, 285, dib8000_read_word(state, 285) & 0x60);
+		/* Layer monitor */
+		dib8000_write_word(state, 285, dib8000_read_word(state, 285) & 0x60);
 
-			dib8000_set_frequency_offset(state);
-			dib8000_set_bandwidth(fe, c->bandwidth_hz / 1000);
+		dib8000_set_frequency_offset(state);
+		dib8000_set_bandwidth(fe, c->bandwidth_hz / 1000);
 
-			if (state->channel_parameters_set == 0) { /* The channel struct is unknown, search it ! */
+		if (state->channel_parameters_set == 0) { /* The channel struct is unknown, search it ! */
 #ifdef DIB8000_AGC_FREEZE
-				if (state->revision != 0x8090) {
-					state->agc1_max = dib8000_read_word(state, 108);
-					state->agc1_min = dib8000_read_word(state, 109);
-					state->agc2_max = dib8000_read_word(state, 110);
-					state->agc2_min = dib8000_read_word(state, 111);
-					agc1 = dib8000_read_word(state, 388);
-					agc2 = dib8000_read_word(state, 389);
-					dib8000_write_word(state, 108, agc1);
-					dib8000_write_word(state, 109, agc1);
-					dib8000_write_word(state, 110, agc2);
-					dib8000_write_word(state, 111, agc2);
-				}
-#endif
-				state->autosearch_state = AS_SEARCHING_FFT;
-				state->found_nfft = TRANSMISSION_MODE_AUTO;
-				state->found_guard = GUARD_INTERVAL_AUTO;
-				*tune_state = CT_DEMOD_SEARCH_NEXT;
-			} else { /* we already know the channel struct so TUNE only ! */
-				state->autosearch_state = AS_DONE;
-				*tune_state = CT_DEMOD_STEP_3;
+			if (state->revision != 0x8090) {
+				state->agc1_max = dib8000_read_word(state, 108);
+				state->agc1_min = dib8000_read_word(state, 109);
+				state->agc2_max = dib8000_read_word(state, 110);
+				state->agc2_min = dib8000_read_word(state, 111);
+				agc1 = dib8000_read_word(state, 388);
+				agc2 = dib8000_read_word(state, 389);
+				dib8000_write_word(state, 108, agc1);
+				dib8000_write_word(state, 109, agc1);
+				dib8000_write_word(state, 110, agc2);
+				dib8000_write_word(state, 111, agc2);
 			}
-			state->symbol_duration = dib8000_get_symbol_duration(state);
-			break;
+#endif
+			state->autosearch_state = AS_SEARCHING_FFT;
+			state->found_nfft = TRANSMISSION_MODE_AUTO;
+			state->found_guard = GUARD_INTERVAL_AUTO;
+			*tune_state = CT_DEMOD_SEARCH_NEXT;
+		} else { /* we already know the channel struct so TUNE only ! */
+			state->autosearch_state = AS_DONE;
+			*tune_state = CT_DEMOD_STEP_3;
+		}
+		state->symbol_duration = dib8000_get_symbol_duration(state);
+		break;
 
 	case CT_DEMOD_SEARCH_NEXT: /* 51 */
-			dib8000_autosearch_start(fe);
-			if (state->revision == 0x8090)
-				ret = 50;
-			else
-				ret = 15;
-			*tune_state = CT_DEMOD_STEP_1;
-			break;
+		dib8000_autosearch_start(fe);
+		if (state->revision == 0x8090)
+			ret = 50;
+		else
+			ret = 15;
+		*tune_state = CT_DEMOD_STEP_1;
+		break;
 
 	case CT_DEMOD_STEP_1: /* 31 */
-			switch (dib8000_autosearch_irq(fe)) {
-			case 1: /* fail */
-					state->status = FE_STATUS_TUNE_FAILED;
-					state->autosearch_state = AS_DONE;
-					*tune_state = CT_DEMOD_STOP; /* else we are done here */
-					break;
-			case 2: /* Succes */
-					state->status = FE_STATUS_FFT_SUCCESS; /* signal to the upper layer, that there was a channel found and the parameters can be read */
-					*tune_state = CT_DEMOD_STEP_3;
-					if (state->autosearch_state == AS_SEARCHING_GUARD)
-						*tune_state = CT_DEMOD_STEP_2;
-					else
-						state->autosearch_state = AS_DONE;
-					break;
-			case 3: /* Autosearch FFT max correlation endded */
-					*tune_state = CT_DEMOD_STEP_2;
-					break;
-			}
+		switch (dib8000_autosearch_irq(fe)) {
+		case 1: /* fail */
+			state->status = FE_STATUS_TUNE_FAILED;
+			state->autosearch_state = AS_DONE;
+			*tune_state = CT_DEMOD_STOP; /* else we are done here */
+			break;
+		case 2: /* Succes */
+			state->status = FE_STATUS_FFT_SUCCESS; /* signal to the upper layer, that there was a channel found and the parameters can be read */
+			*tune_state = CT_DEMOD_STEP_3;
+			if (state->autosearch_state == AS_SEARCHING_GUARD)
+				*tune_state = CT_DEMOD_STEP_2;
+			else
+				state->autosearch_state = AS_DONE;
+			break;
+		case 3: /* Autosearch FFT max correlation endded */
+			*tune_state = CT_DEMOD_STEP_2;
 			break;
+		}
+		break;
 
 	case CT_DEMOD_STEP_2:
-			switch (state->autosearch_state) {
-			case AS_SEARCHING_FFT:
-					/* searching for the correct FFT */
-				if (state->revision == 0x8090) {
-					corm[2] = (dib8000_read_word(state, 596) << 16) | (dib8000_read_word(state, 597));
-					corm[1] = (dib8000_read_word(state, 598) << 16) | (dib8000_read_word(state, 599));
-					corm[0] = (dib8000_read_word(state, 600) << 16) | (dib8000_read_word(state, 601));
-				} else {
-					corm[2] = (dib8000_read_word(state, 594) << 16) | (dib8000_read_word(state, 595));
-					corm[1] = (dib8000_read_word(state, 596) << 16) | (dib8000_read_word(state, 597));
-					corm[0] = (dib8000_read_word(state, 598) << 16) | (dib8000_read_word(state, 599));
-				}
-					/* dprintk("corm fft: %u %u %u", corm[0], corm[1], corm[2]); */
+		switch (state->autosearch_state) {
+		case AS_SEARCHING_FFT:
+			/* searching for the correct FFT */
+			if (state->revision == 0x8090) {
+				corm[2] = (dib8000_read_word(state, 596) << 16) | (dib8000_read_word(state, 597));
+				corm[1] = (dib8000_read_word(state, 598) << 16) | (dib8000_read_word(state, 599));
+				corm[0] = (dib8000_read_word(state, 600) << 16) | (dib8000_read_word(state, 601));
+			} else {
+				corm[2] = (dib8000_read_word(state, 594) << 16) | (dib8000_read_word(state, 595));
+				corm[1] = (dib8000_read_word(state, 596) << 16) | (dib8000_read_word(state, 597));
+				corm[0] = (dib8000_read_word(state, 598) << 16) | (dib8000_read_word(state, 599));
+			}
+			/* dprintk("corm fft: %u %u %u", corm[0], corm[1], corm[2]); */
 
-					max_value = 0;
-					for (find_index = 1 ; find_index < 3 ; find_index++) {
-						if (corm[max_value] < corm[find_index])
-							max_value = find_index ;
-					}
+			max_value = 0;
+			for (find_index = 1 ; find_index < 3 ; find_index++) {
+				if (corm[max_value] < corm[find_index])
+					max_value = find_index ;
+			}
 
-					switch (max_value) {
-					case 0:
-							state->found_nfft = TRANSMISSION_MODE_2K;
-							break;
-					case 1:
-							state->found_nfft = TRANSMISSION_MODE_4K;
-							break;
-					case 2:
-					default:
-							state->found_nfft = TRANSMISSION_MODE_8K;
-							break;
-					}
-					/* dprintk("Autosearch FFT has found Mode %d", max_value + 1); */
-
-					*tune_state = CT_DEMOD_SEARCH_NEXT;
-					state->autosearch_state = AS_SEARCHING_GUARD;
-					if (state->revision == 0x8090)
-						ret = 50;
-					else
-						ret = 10;
-					break;
-			case AS_SEARCHING_GUARD:
-					/* searching for the correct guard interval */
-					if (state->revision == 0x8090)
-						state->found_guard = dib8000_read_word(state, 572) & 0x3;
-					else
-						state->found_guard = dib8000_read_word(state, 570) & 0x3;
-					/* dprintk("guard interval found=%i", state->found_guard); */
-
-					*tune_state = CT_DEMOD_STEP_3;
-					break;
+			switch (max_value) {
+			case 0:
+				state->found_nfft = TRANSMISSION_MODE_2K;
+				break;
+			case 1:
+				state->found_nfft = TRANSMISSION_MODE_4K;
+				break;
+			case 2:
 			default:
-					/* the demod should never be in this state */
-					state->status = FE_STATUS_TUNE_FAILED;
-					state->autosearch_state = AS_DONE;
-					*tune_state = CT_DEMOD_STOP; /* else we are done here */
-					break;
+				state->found_nfft = TRANSMISSION_MODE_8K;
+				break;
 			}
+			/* dprintk("Autosearch FFT has found Mode %d", max_value + 1); */
+
+			*tune_state = CT_DEMOD_SEARCH_NEXT;
+			state->autosearch_state = AS_SEARCHING_GUARD;
+			if (state->revision == 0x8090)
+				ret = 50;
+			else
+				ret = 10;
 			break;
+		case AS_SEARCHING_GUARD:
+			/* searching for the correct guard interval */
+			if (state->revision == 0x8090)
+				state->found_guard = dib8000_read_word(state, 572) & 0x3;
+			else
+				state->found_guard = dib8000_read_word(state, 570) & 0x3;
+			/* dprintk("guard interval found=%i", state->found_guard); */
 
-	case CT_DEMOD_STEP_3: /* 33 */
-			state->symbol_duration = dib8000_get_symbol_duration(state);
-			dib8000_set_isdbt_loop_params(state, LOOP_TUNE_1);
-			dib8000_set_isdbt_common_channel(state, 0, 0);/* setting the known channel parameters here */
-			*tune_state = CT_DEMOD_STEP_4;
+			*tune_state = CT_DEMOD_STEP_3;
 			break;
+		default:
+			/* the demod should never be in this state */
+			state->status = FE_STATUS_TUNE_FAILED;
+			state->autosearch_state = AS_DONE;
+			*tune_state = CT_DEMOD_STOP; /* else we are done here */
+			break;
+		}
+		break;
+
+	case CT_DEMOD_STEP_3: /* 33 */
+		state->symbol_duration = dib8000_get_symbol_duration(state);
+		dib8000_set_isdbt_loop_params(state, LOOP_TUNE_1);
+		dib8000_set_isdbt_common_channel(state, 0, 0);/* setting the known channel parameters here */
+		*tune_state = CT_DEMOD_STEP_4;
+		break;
 
 	case CT_DEMOD_STEP_4: /* (34) */
-			dib8000_demod_restart(state);
+		dib8000_demod_restart(state);
 
-			dib8000_set_sync_wait(state);
-			dib8000_set_diversity_in(state->fe[0], state->diversity_onoff);
+		dib8000_set_sync_wait(state);
+		dib8000_set_diversity_in(state->fe[0], state->diversity_onoff);
 
-			locks = (dib8000_read_word(state, 180) >> 6) & 0x3f; /* P_coff_winlen ? */
-			/* coff should lock over P_coff_winlen ofdm symbols : give 3 times this length to lock */
-			*timeout = dib8000_get_timeout(state, 2 * locks, SYMBOL_DEPENDENT_ON);
-			*tune_state = CT_DEMOD_STEP_5;
-			break;
+		locks = (dib8000_read_word(state, 180) >> 6) & 0x3f; /* P_coff_winlen ? */
+		/* coff should lock over P_coff_winlen ofdm symbols : give 3 times this length to lock */
+		*timeout = dib8000_get_timeout(state, 2 * locks, SYMBOL_DEPENDENT_ON);
+		*tune_state = CT_DEMOD_STEP_5;
+		break;
 
 	case CT_DEMOD_STEP_5: /* (35) */
-			locks = dib8000_read_lock(fe);
-			if (locks & (0x3 << 11)) { /* coff-lock and off_cpil_lock achieved */
-				dib8000_update_timf(state); /* we achieved a coff_cpil_lock - it's time to update the timf */
-				if (!state->differential_constellation) {
-					/* 2 times lmod4_win_len + 10 symbols (pipe delay after coff + nb to compute a 1st correlation) */
-					*timeout = dib8000_get_timeout(state, (20 * ((dib8000_read_word(state, 188)>>5)&0x1f)), SYMBOL_DEPENDENT_ON);
-					*tune_state = CT_DEMOD_STEP_7;
-				} else {
-					*tune_state = CT_DEMOD_STEP_8;
-				}
-			} else if (now > *timeout) {
-				*tune_state = CT_DEMOD_STEP_6; /* goto check for diversity input connection */
+		locks = dib8000_read_lock(fe);
+		if (locks & (0x3 << 11)) { /* coff-lock and off_cpil_lock achieved */
+			dib8000_update_timf(state); /* we achieved a coff_cpil_lock - it's time to update the timf */
+			if (!state->differential_constellation) {
+				/* 2 times lmod4_win_len + 10 symbols (pipe delay after coff + nb to compute a 1st correlation) */
+				*timeout = dib8000_get_timeout(state, (20 * ((dib8000_read_word(state, 188)>>5)&0x1f)), SYMBOL_DEPENDENT_ON);
+				*tune_state = CT_DEMOD_STEP_7;
+			} else {
+				*tune_state = CT_DEMOD_STEP_8;
 			}
-			break;
+		} else if (now > *timeout) {
+			*tune_state = CT_DEMOD_STEP_6; /* goto check for diversity input connection */
+		}
+		break;
 
 	case CT_DEMOD_STEP_6: /* (36)  if there is an input (diversity) */
-			if ((state->fe[1] != NULL) && (state->output_mode != OUTMODE_DIVERSITY)) {
-				/* if there is a diversity fe in input and this fe is has not already failled : wait here until this this fe has succedeed or failled */
-				if (dib8000_get_status(state->fe[1]) <= FE_STATUS_STD_SUCCESS) /* Something is locked on the input fe */
-					*tune_state = CT_DEMOD_STEP_8; /* go for mpeg */
-				else if (dib8000_get_status(state->fe[1]) >= FE_STATUS_TUNE_TIME_TOO_SHORT) { /* fe in input failled also, break the current one */
-					*tune_state = CT_DEMOD_STOP; /* else we are done here ; step 8 will close the loops and exit */
-					dib8000_viterbi_state(state, 1); /* start viterbi chandec */
-					dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
-					state->status = FE_STATUS_TUNE_FAILED;
-				}
-			} else {
+		if ((state->fe[1] != NULL) && (state->output_mode != OUTMODE_DIVERSITY)) {
+			/* if there is a diversity fe in input and this fe is has not already failled : wait here until this this fe has succedeed or failled */
+			if (dib8000_get_status(state->fe[1]) <= FE_STATUS_STD_SUCCESS) /* Something is locked on the input fe */
+				*tune_state = CT_DEMOD_STEP_8; /* go for mpeg */
+			else if (dib8000_get_status(state->fe[1]) >= FE_STATUS_TUNE_TIME_TOO_SHORT) { /* fe in input failled also, break the current one */
+				*tune_state = CT_DEMOD_STOP; /* else we are done here ; step 8 will close the loops and exit */
 				dib8000_viterbi_state(state, 1); /* start viterbi chandec */
 				dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
-				*tune_state = CT_DEMOD_STOP; /* else we are done here ; step 8 will close the loops and exit */
 				state->status = FE_STATUS_TUNE_FAILED;
 			}
-			break;
+		} else {
+			dib8000_viterbi_state(state, 1); /* start viterbi chandec */
+			dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
+			*tune_state = CT_DEMOD_STOP; /* else we are done here ; step 8 will close the loops and exit */
+			state->status = FE_STATUS_TUNE_FAILED;
+		}
+		break;
 
 	case CT_DEMOD_STEP_7: /* 37 */
-			locks = dib8000_read_lock(fe);
-			if (locks & (1<<10)) { /* lmod4_lock */
-				ret = 14; /* wait for 14 symbols */
-				*tune_state = CT_DEMOD_STEP_8;
-			} else if (now > *timeout)
-				*tune_state = CT_DEMOD_STEP_6; /* goto check for diversity input connection */
-			break;
+		locks = dib8000_read_lock(fe);
+		if (locks & (1<<10)) { /* lmod4_lock */
+			ret = 14; /* wait for 14 symbols */
+			*tune_state = CT_DEMOD_STEP_8;
+		} else if (now > *timeout)
+			*tune_state = CT_DEMOD_STEP_6; /* goto check for diversity input connection */
+		break;
 
 	case CT_DEMOD_STEP_8: /* 38 */
-			dib8000_viterbi_state(state, 1); /* start viterbi chandec */
-			dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
-
-			/* mpeg will never lock on this condition because init_prbs is not set : search for it !*/
-			if (c->isdbt_sb_mode
-			    && c->isdbt_sb_subchannel < 14
-			    && !state->differential_constellation) {
-				state->subchannel = 0;
-				*tune_state = CT_DEMOD_STEP_11;
-			} else {
-				*tune_state = CT_DEMOD_STEP_9;
-				state->status = FE_STATUS_LOCKED;
-			}
-			break;
+		dib8000_viterbi_state(state, 1); /* start viterbi chandec */
+		dib8000_set_isdbt_loop_params(state, LOOP_TUNE_2);
+
+		/* mpeg will never lock on this condition because init_prbs is not set : search for it !*/
+		if (c->isdbt_sb_mode
+		    && c->isdbt_sb_subchannel < 14
+		    && !state->differential_constellation) {
+			state->subchannel = 0;
+			*tune_state = CT_DEMOD_STEP_11;
+		} else {
+			*tune_state = CT_DEMOD_STEP_9;
+			state->status = FE_STATUS_LOCKED;
+		}
+		break;
 
 	case CT_DEMOD_STEP_9: /* 39 */
-			if ((state->revision == 0x8090) || ((dib8000_read_word(state, 1291) >> 9) & 0x1)) { /* fe capable of deinterleaving : esram */
-				/* defines timeout for mpeg lock depending on interleaver length of longest layer */
-				for (i = 0; i < 3; i++) {
-					if (c->layer[i].interleaving >= deeper_interleaver) {
-						dprintk("layer%i: time interleaver = %d ", i, c->layer[i].interleaving);
-						if (c->layer[i].segment_count > 0) { /* valid layer */
-							deeper_interleaver = c->layer[0].interleaving;
-							state->longest_intlv_layer = i;
-						}
+		if ((state->revision == 0x8090) || ((dib8000_read_word(state, 1291) >> 9) & 0x1)) { /* fe capable of deinterleaving : esram */
+			/* defines timeout for mpeg lock depending on interleaver length of longest layer */
+			for (i = 0; i < 3; i++) {
+				if (c->layer[i].interleaving >= deeper_interleaver) {
+					dprintk("layer%i: time interleaver = %d ", i, c->layer[i].interleaving);
+					if (c->layer[i].segment_count > 0) { /* valid layer */
+						deeper_interleaver = c->layer[0].interleaving;
+						state->longest_intlv_layer = i;
 					}
 				}
+			}
 
-				if (deeper_interleaver == 0)
-					locks = 2; /* locks is the tmp local variable name */
-				else if (deeper_interleaver == 3)
-					locks = 8;
-				else
-					locks = 2 * deeper_interleaver;
+			if (deeper_interleaver == 0)
+				locks = 2; /* locks is the tmp local variable name */
+			else if (deeper_interleaver == 3)
+				locks = 8;
+			else
+				locks = 2 * deeper_interleaver;
 
-				if (state->diversity_onoff != 0) /* because of diversity sync */
-					locks *= 2;
+			if (state->diversity_onoff != 0) /* because of diversity sync */
+				locks *= 2;
 
-				*timeout = now + (2000 * locks); /* give the mpeg lock 800ms if sram is present */
-				dprintk("Deeper interleaver mode = %d on layer %d : timeout mult factor = %d => will use timeout = %d", deeper_interleaver, state->longest_intlv_layer, locks, *timeout);
+			*timeout = now + (2000 * locks); /* give the mpeg lock 800ms if sram is present */
+			dprintk("Deeper interleaver mode = %d on layer %d : timeout mult factor = %d => will use timeout = %d", deeper_interleaver, state->longest_intlv_layer, locks, *timeout);
 
-				*tune_state = CT_DEMOD_STEP_10;
-			} else
-				*tune_state = CT_DEMOD_STOP;
-			break;
+			*tune_state = CT_DEMOD_STEP_10;
+		} else
+			*tune_state = CT_DEMOD_STOP;
+		break;
 
 	case CT_DEMOD_STEP_10: /* 40 */
-			locks = dib8000_read_lock(fe);
-			if (locks&(1<<(7-state->longest_intlv_layer))) { /* mpeg lock : check the longest one */
-				dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
-				if (c->isdbt_sb_mode
-				    && c->isdbt_sb_subchannel < 14
-				    && !state->differential_constellation)
-					/* signal to the upper layer, that there was a channel found and the parameters can be read */
-					state->status = FE_STATUS_DEMOD_SUCCESS;
-				else
+		locks = dib8000_read_lock(fe);
+		if (locks&(1<<(7-state->longest_intlv_layer))) { /* mpeg lock : check the longest one */
+			dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
+			if (c->isdbt_sb_mode
+			    && c->isdbt_sb_subchannel < 14
+			    && !state->differential_constellation)
+				/* signal to the upper layer, that there was a channel found and the parameters can be read */
+				state->status = FE_STATUS_DEMOD_SUCCESS;
+			else
+				state->status = FE_STATUS_DATA_LOCKED;
+			*tune_state = CT_DEMOD_STOP;
+		} else if (now > *timeout) {
+			if (c->isdbt_sb_mode
+			    && c->isdbt_sb_subchannel < 14
+			    && !state->differential_constellation) { /* continue to try init prbs autosearch */
+				state->subchannel += 3;
+				*tune_state = CT_DEMOD_STEP_11;
+			} else { /* we are done mpeg of the longest interleaver xas not locking but let's try if an other layer has locked in the same time */
+				if (locks & (0x7<<5)) {
+					dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
 					state->status = FE_STATUS_DATA_LOCKED;
+				} else
+					state->status = FE_STATUS_TUNE_FAILED;
 				*tune_state = CT_DEMOD_STOP;
-			} else if (now > *timeout) {
-				if (c->isdbt_sb_mode
-				    && c->isdbt_sb_subchannel < 14
-				    && !state->differential_constellation) { /* continue to try init prbs autosearch */
-					state->subchannel += 3;
-					*tune_state = CT_DEMOD_STEP_11;
-				} else { /* we are done mpeg of the longest interleaver xas not locking but let's try if an other layer has locked in the same time */
-					if (locks & (0x7<<5)) {
-						dprintk("Mpeg locks [ L0 : %d | L1 : %d | L2 : %d ]", (locks>>7)&0x1, (locks>>6)&0x1, (locks>>5)&0x1);
-						state->status = FE_STATUS_DATA_LOCKED;
-					} else
-						state->status = FE_STATUS_TUNE_FAILED;
-					*tune_state = CT_DEMOD_STOP;
-				}
 			}
-			break;
+		}
+		break;
 
 	case CT_DEMOD_STEP_11:  /* 41 : init prbs autosearch */
-			if (state->subchannel <= 41) {
-				dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
-				*tune_state = CT_DEMOD_STEP_9;
-			} else {
-				*tune_state = CT_DEMOD_STOP;
-				state->status = FE_STATUS_TUNE_FAILED;
-			}
-			break;
+		if (state->subchannel <= 41) {
+			dib8000_set_subchannel_prbs(state, dib8000_get_init_prbs(state, state->subchannel));
+			*tune_state = CT_DEMOD_STEP_9;
+		} else {
+			*tune_state = CT_DEMOD_STOP;
+			state->status = FE_STATUS_TUNE_FAILED;
+		}
+		break;
 
 	default:
-			break;
+		break;
 	}
 
 	/* tuning is finished - cleanup the demod */
 	switch (*tune_state) {
 	case CT_DEMOD_STOP: /* (42) */
 #ifdef DIB8000_AGC_FREEZE
-			if ((state->revision != 0x8090) && (state->agc1_max != 0)) {
-				dib8000_write_word(state, 108, state->agc1_max);
-				dib8000_write_word(state, 109, state->agc1_min);
-				dib8000_write_word(state, 110, state->agc2_max);
-				dib8000_write_word(state, 111, state->agc2_min);
-				state->agc1_max = 0;
-				state->agc1_min = 0;
-				state->agc2_max = 0;
-				state->agc2_min = 0;
-			}
+		if ((state->revision != 0x8090) && (state->agc1_max != 0)) {
+			dib8000_write_word(state, 108, state->agc1_max);
+			dib8000_write_word(state, 109, state->agc1_min);
+			dib8000_write_word(state, 110, state->agc2_max);
+			dib8000_write_word(state, 111, state->agc2_min);
+			state->agc1_max = 0;
+			state->agc1_min = 0;
+			state->agc2_max = 0;
+			state->agc2_min = 0;
+		}
 #endif
-			ret = FE_CALLBACK_TIME_NEVER;
-			break;
+		ret = FE_CALLBACK_TIME_NEVER;
+		break;
 	default:
-			break;
+		break;
 	}
 
 	if ((ret > 0) && (*tune_state > CT_DEMOD_STEP_3))
-- 
1.9.3

