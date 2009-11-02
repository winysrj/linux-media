Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56815 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757193AbZKBWvC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:02 -0500
Message-ID: <4AEF6258.3030709@gmx.de>
Date: Mon, 02 Nov 2009 23:51:04 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 3/9] stv090x: fix STR and SNR calculation
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes STR and SNR calculation and normalizes the value into the 0..0xFFFF range.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r 24f72ae37236 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:06:31 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:24:07 2009 +0100
@@ -4230,14 +4230,12 @@
 	int res = 0;
 	int min = 0, med;
 
-	if (val < tab[min].read)
-		res = tab[min].real;
-	else if (val >= tab[max].read)
-		res = tab[max].real;
-	else {
+	if ((val >= tab[min].read && val < tab[max].read) ||
+	    (val >= tab[max].read && val < tab[min].read)) {
 		while ((max - min) > 1) {
 			med = (max + min) / 2;
-			if (val >= tab[min].read && val < tab[med].read)
+			if ((val >= tab[min].read && val < tab[med].read) ||
+			    (val >= tab[med].read && val < tab[min].read))
 				max = med;
 			else
 				min = med;
@@ -4246,6 +4244,18 @@
 		       (tab[max].real - tab[min].real) /
 		       (tab[max].read - tab[min].read)) +
 			tab[min].real;
+	} else {
+		if (tab[min].read < tab[max].read) {
+			if (val < tab[min].read)
+				res = tab[min].real;
+			else if (val >= tab[max].read)
+				res = tab[max].real;
+		} else {
+			if (val >= tab[min].read)
+				res = tab[min].real;
+			else if (val < tab[max].read)
+				res = tab[max].real;
+		}
 	}
 
 	return res;
@@ -4255,16 +4265,22 @@
 {
 	struct stv090x_state *state = fe->demodulator_priv;
 	u32 reg;
-	s32 agc;
+	s32 agc_0, agc_1, agc;
+	s32 str;
 
 	reg = STV090x_READ_DEMOD(state, AGCIQIN1);
-	agc = STV090x_GETFIELD_Px(reg, AGCIQ_VALUE_FIELD);
-
-	*strength = stv090x_table_lookup(stv090x_rf_tab, ARRAY_SIZE(stv090x_rf_tab) - 1, agc);
+	agc_1 = STV090x_GETFIELD_Px(reg, AGCIQ_VALUE_FIELD);
+	reg = STV090x_READ_DEMOD(state, AGCIQIN0);
+	agc_0 = STV090x_GETFIELD_Px(reg, AGCIQ_VALUE_FIELD);
+	agc = MAKEWORD16(agc_1, agc_0);
+
+	str = stv090x_table_lookup(stv090x_rf_tab,
+		ARRAY_SIZE(stv090x_rf_tab) - 1, agc);
 	if (agc > stv090x_rf_tab[0].read)
-		*strength = 5;
+		str = 0;
 	else if (agc < stv090x_rf_tab[ARRAY_SIZE(stv090x_rf_tab) - 1].read)
-		*strength = -100;
+		str = -100;
+	*strength = (str + 100) * 0xFFFF / 100;
 
 	return 0;
 }
@@ -4275,6 +4291,8 @@
 	u32 reg_0, reg_1, reg, i;
 	s32 val_0, val_1, val = 0;
 	u8 lock_f;
+	s32 div;
+	u32 last;
 
 	switch (state->delsys) {
 	case STV090x_DVBS2:
@@ -4286,14 +4304,15 @@
 				reg_1 = STV090x_READ_DEMOD(state, NNOSPLHT1);
 				val_1 = STV090x_GETFIELD_Px(reg_1, NOSPLHT_NORMED_FIELD);
 				reg_0 = STV090x_READ_DEMOD(state, NNOSPLHT0);
-				val_0 = STV090x_GETFIELD_Px(reg_1, NOSPLHT_NORMED_FIELD);
+				val_0 = STV090x_GETFIELD_Px(reg_0, NOSPLHT_NORMED_FIELD);
 				val  += MAKEWORD16(val_1, val_0);
 				msleep(1);
 			}
 			val /= 16;
-			*cnr = stv090x_table_lookup(stv090x_s2cn_tab, ARRAY_SIZE(stv090x_s2cn_tab) - 1, val);
-			if (val < stv090x_s2cn_tab[ARRAY_SIZE(stv090x_s2cn_tab) - 1].read)
-				*cnr = 1000;
+			last = ARRAY_SIZE(stv090x_s2cn_tab) - 1;
+			div = stv090x_s2cn_tab[0].read -
+			      stv090x_s2cn_tab[last].read;
+			*cnr = 0xFFFF - ((val * 0xFFFF) / div);
 		}
 		break;
 
@@ -4307,14 +4326,15 @@
 				reg_1 = STV090x_READ_DEMOD(state, NOSDATAT1);
 				val_1 = STV090x_GETFIELD_Px(reg_1, NOSDATAT_UNNORMED_FIELD);
 				reg_0 = STV090x_READ_DEMOD(state, NOSDATAT0);
-				val_0 = STV090x_GETFIELD_Px(reg_1, NOSDATAT_UNNORMED_FIELD);
+				val_0 = STV090x_GETFIELD_Px(reg_0, NOSDATAT_UNNORMED_FIELD);
 				val  += MAKEWORD16(val_1, val_0);
 				msleep(1);
 			}
 			val /= 16;
-			*cnr = stv090x_table_lookup(stv090x_s1cn_tab, ARRAY_SIZE(stv090x_s1cn_tab) - 1, val);
-			if (val < stv090x_s2cn_tab[ARRAY_SIZE(stv090x_s1cn_tab) - 1].read)
-				*cnr = 1000;
+			last = ARRAY_SIZE(stv090x_s1cn_tab) - 1;
+			div = stv090x_s1cn_tab[0].read -
+			      stv090x_s1cn_tab[last].read;
+			*cnr = 0xFFFF - ((val * 0xFFFF) / div);
 		}
 		break;
 	default:
