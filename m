Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52372 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932493AbZKBWvm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:42 -0500
Message-ID: <4AEF6280.20609@gmx.de>
Date: Mon, 02 Nov 2009 23:51:44 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 9/9] stv090x: corrections of some register values, blind scan
 related fixes
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds corrections of some register values. It also contains some blind scan related fixes.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r e8ae419fa64f linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:16:29 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:25:35 2009 +0100
@@ -1969,6 +1969,8 @@
 				goto err;
 		}
 
+		if (stv090x_set_vit_thtracq(state) < 0)
+			goto err;
 		break;
 
 	case STV090x_SEARCH_AUTO:
@@ -2009,17 +2011,8 @@
 				goto err;
 		}
 
-		if (state->srate >= 2000000) {
-			/* Srate >= 2MSPS, Viterbi threshold to acquire */
-			if (stv090x_set_vit_thacq(state) < 0)
-				goto err;
-		} else {
-			/* Srate < 2MSPS, Reset Viterbi thresholdto track
-			 * and then re-acquire
-			 */
-			if (stv090x_set_vit_thtracq(state) < 0)
-				goto err;
-		}
+		if (stv090x_set_vit_thacq(state) < 0)
+			goto err;
 
 		if (stv090x_set_viterbi(state) < 0)
 			goto err;
@@ -2153,6 +2146,9 @@
 	if (STV090x_WRITE_DEMOD(state, DMDCFG2, reg) < 0)
 		goto err;
 
+	if (STV090x_WRITE_DEMOD(state, RTC, 0x88) < 0)
+		goto err;
+
 	if (state->dev_ver >= 0x20) {
 		/*Frequency offset detector setting*/
 		if (state->srate < 2000000) {
@@ -2161,7 +2157,7 @@
 				if (STV090x_WRITE_DEMOD(state, CARFREQ, 0x39) < 0)
 					goto err;
 			} else {
-				/* Cut 2 */
+				/* Cut 3 */
 				if (STV090x_WRITE_DEMOD(state, CARFREQ, 0x89) < 0)
 					goto err;
 			}
@@ -2170,8 +2166,12 @@
 		} else if (state->srate < 10000000) {
 			if (STV090x_WRITE_DEMOD(state, CARFREQ, 0x4c) < 0)
 				goto err;
+			if (STV090x_WRITE_DEMOD(state, CARHDR, 0x20) < 0)
+				goto err;
 		} else {
 			if (STV090x_WRITE_DEMOD(state, CARFREQ, 0x4b) < 0)
+				goto err;
+			if (STV090x_WRITE_DEMOD(state, CARHDR, 0x20) < 0)
 				goto err;
 		}
 	} else {
@@ -2220,8 +2220,8 @@
 	if (STV090x_WRITE_DEMOD(state, AGC2REF, 0x38) < 0)
 		goto err;
 	reg = STV090x_READ_DEMOD(state, DMDCFGMD);
-	STV090x_SETFIELD_Px(reg, SCAN_ENABLE_FIELD, 1);
-	STV090x_SETFIELD_Px(reg, CFR_AUTOSCAN_FIELD, 1);
+	STV090x_SETFIELD_Px(reg, SCAN_ENABLE_FIELD, 0);
+	STV090x_SETFIELD_Px(reg, CFR_AUTOSCAN_FIELD, 0);
 	if (STV090x_WRITE_DEMOD(state, DMDCFGMD, reg) < 0)
 		goto err;
 
@@ -2238,10 +2238,8 @@
 	if (stv090x_set_srate(state, 1000000) < 0)
 		goto err;
 
-	steps  = -1 + state->search_range / 1000000;
-	steps /= 2;
-	steps  = (2 * steps) + 1;
-	if (steps < 0)
+	steps  = state->search_range / 1000000;
+	if (steps <= 0)
 		steps = 1;
 
 	dir = 1;
@@ -2327,13 +2325,15 @@
 		goto err;
 	if (STV090x_WRITE_DEMOD(state, TMGCFG, 0x12) < 0)
 		goto err;
+	if (STV090x_WRITE_DEMOD(state, TMGCFG2, 0xc0) < 0)
+		goto err;
 	if (STV090x_WRITE_DEMOD(state, TMGTHRISE, 0xf0) < 0)
 		goto err;
 	if (STV090x_WRITE_DEMOD(state, TMGTHFALL, 0xe0) < 0)
 		goto err;
 	reg = STV090x_READ_DEMOD(state, DMDCFGMD);
 	STV090x_SETFIELD_Px(reg, SCAN_ENABLE_FIELD, 1);
-	STV090x_SETFIELD_Px(reg, CFR_AUTOSCAN_FIELD, 1);
+	STV090x_SETFIELD_Px(reg, CFR_AUTOSCAN_FIELD, 0);
 	if (STV090x_WRITE_DEMOD(state, DMDCFGMD, reg) < 0)
 		goto err;
 
@@ -2353,7 +2353,7 @@
 	if (state->dev_ver >= 0x30) {
 		if (STV090x_WRITE_DEMOD(state, CARFREQ, 0x99) < 0)
 			goto err;
-		if (STV090x_WRITE_DEMOD(state, SFRSTEP, 0x95) < 0)
+		if (STV090x_WRITE_DEMOD(state, SFRSTEP, 0x98) < 0)
 			goto err;
 
 	} else if (state->dev_ver >= 0x20) {
@@ -2388,9 +2388,16 @@
 	while ((!tmg_lock) && (cur_step < steps)) {
 		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x5f) < 0) /* Demod RESET */
 			goto err;
-		reg = STV090x_READ_DEMOD(state, DMDISTATE);
-		STV090x_SETFIELD_Px(reg, I2C_DEMOD_MODE_FIELD, 0x00); /* trigger acquisition */
-		if (STV090x_WRITE_DEMOD(state, DMDISTATE, reg) < 0)
+		if (STV090x_WRITE_DEMOD(state, CFRINIT1, 0x00) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, CFRINIT0, 0x00) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, SFRINIT1, 0x00) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, SFRINIT0, 0x00) < 0)
+			goto err;
+		/* trigger acquisition */
+		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x40) < 0)
 			goto err;
 		msleep(50);
 		for (i = 0; i < 10; i++) {
@@ -2475,7 +2482,7 @@
 	else {
 		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0) /* Demod RESET */
 			goto err;
-		if (STV090x_WRITE_DEMOD(state, TMGCFG2, 0x01) < 0)
+		if (STV090x_WRITE_DEMOD(state, TMGCFG2, 0xc1) < 0)
 			goto err;
 		if (STV090x_WRITE_DEMOD(state, TMGTHRISE, 0x20) < 0)
 			goto err;
@@ -2600,8 +2607,8 @@
 	u8 k_ref, k_max, k_min;
 	int coarse_fail, lock;
 
-	k_max = 120;
-	k_min = 30;
+	k_max = 110;
+	k_min = 10;
 
 	agc2 = stv090x_get_agc2_min_level(state);
 
@@ -2664,7 +2671,7 @@
 
 				lock = 0;
 			}
-			k_ref -= 30;
+			k_ref -= 20;
 		} while ((k_ref >= k_min) && (!lock) && (!coarse_fail));
 	}
 
@@ -2834,17 +2841,6 @@
 						goto err;
 
 					STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1c);
-					if (state->delsys == STV090x_DVBS2) {
-						reg = STV090x_READ_DEMOD(state, DMDCFGMD);
-						STV090x_SETFIELD_Px(reg, DVBS1_ENABLE_FIELD, 0);
-						STV090x_SETFIELD_Px(reg, DVBS2_ENABLE_FIELD, 0);
-						if (STV090x_WRITE_DEMOD(state, DMDCFGMD, reg) < 0)
-							goto err;
-						STV090x_SETFIELD_Px(reg, DVBS1_ENABLE_FIELD, 1);
-						STV090x_SETFIELD_Px(reg, DVBS2_ENABLE_FIELD, 1);
-						if (STV090x_WRITE_DEMOD(state, DMDCFGMD, reg) < 0)
-							goto err;
-					}
 					if (STV090x_WRITE_DEMOD(state, CFRINIT1, 0x00) < 0)
 						goto err;
 					if (STV090x_WRITE_DEMOD(state, CFRINIT0, 0x00) < 0)
@@ -3604,6 +3600,9 @@
 			goto err;
 #endif
 		blind_tune = 1;
+
+		if (stv090x_dvbs_track_crl(state) < 0)
+			goto err;
 	}
 
 	if (state->dev_ver >= 0x20) {
@@ -3876,8 +3875,13 @@
 		goto err;
 
 	if (state->dev_ver >= 0x20) {
-		if (STV090x_WRITE_DEMOD(state, CORRELABS, 0x9e) < 0) /* cut 2.0 */
-			goto err;
+		if (state->srate > 5000000) {
+			if (STV090x_WRITE_DEMOD(state, CORRELABS, 0x9e) < 0)
+				goto err;
+		} else {
+			if (STV090x_WRITE_DEMOD(state, CORRELABS, 0x82) < 0)
+				goto err;
+		}
 	}
 
 	stv090x_get_lock_tmg(state);
