Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48668 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757229AbZKBWvT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:19 -0500
Message-ID: <4AEF6269.9060709@gmx.de>
Date: Mon, 02 Nov 2009 23:51:21 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 6/9] stv090x: several small fixes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch contains several fixes for the stv090x driver:
- added missing else
- use calculated timeout instead of fixed one
- use correct frequency when doing zigzag scan
- added missing read of GENCFG register

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r e87448c29625 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:43:25 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:02:34 2009 +0100
@@ -2167,9 +2167,7 @@
 			}
 			if (STV090x_WRITE_DEMOD(state, CARHDR, 0x40) < 0)
 				goto err;
-		}
-
-		if (state->srate < 10000000) {
+		} else if (state->srate < 10000000) {
 			if (STV090x_WRITE_DEMOD(state, CARFREQ, 0x4c) < 0)
 				goto err;
 		} else {
@@ -2420,7 +2418,7 @@
 				goto err;
 
 			if (state->config->tuner_set_frequency) {
-				if (state->config->tuner_set_frequency(fe, state->frequency) < 0)
+				if (state->config->tuner_set_frequency(fe, freq) < 0)
 					goto err;
 			}
 
@@ -2598,7 +2596,7 @@
 static int stv090x_blind_search(struct stv090x_state *state)
 {
 	u32 agc2, reg, srate_coarse;
-	s32 timeout_dmd = 500, cpt_fail, agc2_ovflw, i;
+	s32 cpt_fail, agc2_ovflw, i;
 	u8 k_ref, k_max, k_min;
 	int coarse_fail, lock;
 
@@ -2642,7 +2640,8 @@
 				srate_coarse = stv090x_srate_srch_fine(state);
 				if (srate_coarse != 0) {
 					stv090x_get_lock_tmg(state);
-					lock = stv090x_get_dmdlock(state, timeout_dmd);
+					lock = stv090x_get_dmdlock(state,
+							state->DemodTimeout);
 				} else {
 					lock = 0;
 				}
@@ -2804,7 +2803,7 @@
 						goto err;
 
 					if (state->config->tuner_set_frequency) {
-						if (state->config->tuner_set_frequency(fe, state->frequency) < 0)
+						if (state->config->tuner_set_frequency(fe, freq) < 0)
 							goto err;
 					}
 
@@ -3865,7 +3864,7 @@
 	struct dvb_frontend *fe = &state->frontend;
 	enum stv090x_signal_state signal_state = STV090x_NOCARRIER;
 	u32 reg;
-	s32 timeout_dmd = 500, timeout_fec = 50, agc1_power, power_iq = 0, i;
+	s32 agc1_power, power_iq = 0, i;
 	int lock = 0, low_sr = 0, no_signal = 0;
 
 	reg = STV090x_READ_DEMOD(state, TSCFGH);
@@ -4030,10 +4029,10 @@
 		lock = stv090x_blind_search(state);
 
 	else if (state->algo == STV090x_COLD_SEARCH)
-		lock = stv090x_get_coldlock(state, timeout_dmd);
+		lock = stv090x_get_coldlock(state, state->DemodTimeout);
 
 	else if (state->algo == STV090x_WARM_SEARCH)
-		lock = stv090x_get_dmdlock(state, timeout_dmd);
+		lock = stv090x_get_dmdlock(state, state->DemodTimeout);
 
 	if ((!lock) && (state->algo == STV090x_COLD_SEARCH)) {
 		if (!low_sr) {
@@ -4068,8 +4067,9 @@
 				goto err;
 		}
 
-		if (stv090x_get_lock(state, timeout_fec, timeout_fec)) {
-			lock = 1;
+		lock = stv090x_get_lock(state, state->FecTimeout,
+				state->FecTimeout);
+		if (lock) {
 			if (state->delsys == STV090x_DVBS2) {
 				stv090x_set_s2rolloff(state);
 
@@ -4096,7 +4096,6 @@
 			if (STV090x_WRITE_DEMOD(state, ERRCTRL2, 0xc1) < 0)
 				goto err;
 		} else {
-			lock = 0;
 			signal_state = STV090x_NODATA;
 			no_signal = stv090x_chk_signal(state);
 		}
@@ -4580,6 +4579,8 @@
 static int stv090x_ldpc_mode(struct stv090x_state *state, enum stv090x_mode ldpc_mode)
 {
 	u32 reg = 0;
+
+	reg = stv090x_read_reg(state, STV090x_GENCFG);
 
 	switch (ldpc_mode) {
 	case STV090x_DUAL:
