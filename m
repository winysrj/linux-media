Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58651 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757222AbZKBWvP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:15 -0500
Message-ID: <4AEF6264.20808@gmx.de>
Date: Mon, 02 Nov 2009 23:51:16 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 5/9] stv090x: fix calculation of AGC2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes calculation of AGC2 and uses a different AGC2 threshold for cut 3 chips.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r 6e8847485f78 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:33:03 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:42:33 2009 +0100
@@ -2216,7 +2216,7 @@
 
 static int stv090x_get_agc2_min_level(struct stv090x_state *state)
 {
-	u32 agc2_min = 0, agc2 = 0, freq_init, freq_step, reg;
+	u32 agc2_min = 0xffff, agc2 = 0, freq_init, freq_step, reg;
 	s32 i, j, steps, dir;
 
 	if (STV090x_WRITE_DEMOD(state, AGC2REF, 0x38) < 0)
@@ -2267,13 +2267,14 @@
 		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x58) < 0) /* Demod RESET */
 			goto err;
 		msleep(10);
+
+		agc2 = 0;
 		for (j = 0; j < 10; j++) {
-			agc2 += STV090x_READ_DEMOD(state, AGC2I1) << 8;
-			agc2 |= STV090x_READ_DEMOD(state, AGC2I0);
+			agc2 += (STV090x_READ_DEMOD(state, AGC2I1) << 8) |
+				STV090x_READ_DEMOD(state, AGC2I0);
 		}
 		agc2 /= 10;
-		agc2_min = 0xffff;
-		if (agc2 < 0xffff)
+		if (agc2 < agc2_min)
 			agc2_min = agc2;
 	}
 
@@ -2315,6 +2316,12 @@
 	int tmg_lock = 0, i;
 	s32 tmg_cpt = 0, dir = 1, steps, cur_step = 0, freq;
 	u32 srate_coarse = 0, agc2 = 0, car_step = 1200, reg;
+	u32 agc2th;
+
+	if (state->dev_ver >= 0x30)
+		agc2th = 0x2e00;
+	else
+		agc2th = 0x1f00;
 
 	reg = STV090x_READ_DEMOD(state, DMDISTATE);
 	STV090x_SETFIELD_Px(reg, I2C_DEMOD_MODE_FIELD, 0x1f); /* Demod RESET */
@@ -2342,7 +2349,7 @@
 		goto err;
 	if (STV090x_WRITE_DEMOD(state, DMDTOM, 0x00) < 0)
 		goto err;
-	if (STV090x_WRITE_DEMOD(state, AGC2REF, 0x60) < 0)
+	if (STV090x_WRITE_DEMOD(state, AGC2REF, 0x50) < 0)
 		goto err;
 
 	if (state->dev_ver >= 0x30) {
@@ -2392,14 +2399,15 @@
 			reg = STV090x_READ_DEMOD(state, DSTATUS);
 			if (STV090x_GETFIELD_Px(reg, TMGLOCK_QUALITY_FIELD) >= 2)
 				tmg_cpt++;
-			agc2 += STV090x_READ_DEMOD(state, AGC2I1) << 8;
-			agc2 |= STV090x_READ_DEMOD(state, AGC2I0);
+			agc2 += (STV090x_READ_DEMOD(state, AGC2I1) << 8) |
+				STV090x_READ_DEMOD(state, AGC2I0);
 		}
 		agc2 /= 10;
 		srate_coarse = stv090x_get_srate(state, state->mclk);
 		cur_step++;
 		dir *= -1;
-		if ((tmg_cpt >= 5) && (agc2 < 0x1f00) && (srate_coarse < 55000000) && (srate_coarse > 850000))
+		if ((tmg_cpt >= 5) && (agc2 < agc2th) &&
+		    (srate_coarse < 50000000) && (srate_coarse > 850000))
 			tmg_lock = 1;
 		else if (cur_step < steps) {
 			if (dir > 0)
@@ -2480,6 +2488,9 @@
 		reg = STV090x_READ_DEMOD(state, DMDCFGMD);
 		STV090x_SETFIELD_Px(reg, CFR_AUTOSCAN_FIELD, 0x00);
 		if (STV090x_WRITE_DEMOD(state, DMDCFGMD, reg) < 0)
+			goto err;
+
+		if (STV090x_WRITE_DEMOD(state, AGC2REF, 0x38) < 0)
 			goto err;
 
 		if (state->dev_ver >= 0x30) {
@@ -2639,8 +2650,8 @@
 				cpt_fail = 0;
 				agc2_ovflw = 0;
 				for (i = 0; i < 10; i++) {
-					agc2  = STV090x_READ_DEMOD(state, AGC2I1) << 8;
-					agc2 |= STV090x_READ_DEMOD(state, AGC2I0);
+					agc2 += (STV090x_READ_DEMOD(state, AGC2I1) << 8) |
+						STV090x_READ_DEMOD(state, AGC2I0);
 					if (agc2 >= 0xff00)
 						agc2_ovflw++;
 					reg = STV090x_READ_DEMOD(state, DSTATUS2);
diff -r 6e8847485f78 linux/drivers/media/dvb/frontends/stv090x_priv.h
--- a/linux/drivers/media/dvb/frontends/stv090x_priv.h	Mon Nov 02 22:33:03 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x_priv.h	Mon Nov 02 22:42:33 2009 +0100
@@ -83,7 +83,7 @@
 
 #define STV090x_IQPOWER_THRESHOLD	  30
 #define STV090x_SEARCH_AGC2_TH_CUT20	 700
-#define STV090x_SEARCH_AGC2_TH_CUT30	1200
+#define STV090x_SEARCH_AGC2_TH_CUT30	1400
 
 #define STV090x_SEARCH_AGC2_TH(__ver)	\
 	((__ver <= 0x20) ?		\
