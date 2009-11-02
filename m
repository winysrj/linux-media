Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41107 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756898AbZKBWvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:05 -0500
Message-ID: <4AEF625B.2030509@gmx.de>
Date: Mon, 02 Nov 2009 23:51:07 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 4/9] stv090x: fix some typos
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes some typos like wrong register or variable names.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r 817da160d9e8 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:25:01 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 22:32:06 2009 +0100
@@ -1556,7 +1556,7 @@
 		sym /= (state->mclk >> 7);
 	}
 
-	if (STV090x_WRITE_DEMOD(state, SFRLOW1, ((sym >> 8) & 0xff)) < 0) /* MSB */
+	if (STV090x_WRITE_DEMOD(state, SFRLOW1, ((sym >> 8) & 0x7f)) < 0) /* MSB */
 		goto err;
 	if (STV090x_WRITE_DEMOD(state, SFRLOW0, (sym & 0xff)) < 0) /* LSB */
 		goto err;
@@ -2048,7 +2048,7 @@
 				goto err;
 			if (STV090x_WRITE_DEMOD(state, CFRUP1, 0x0f) < 0)
 				goto err;
-			if (STV090x_WRITE_DEMOD(state, CFRUP1, 0xff) < 0)
+			if (STV090x_WRITE_DEMOD(state, CFRUP0, 0xff) < 0)
 				goto err;
 			if (STV090x_WRITE_DEMOD(state, CFRLOW1, 0xf0) < 0)
 				goto err;
@@ -2102,7 +2102,7 @@
 
 		if (STV090x_WRITE_DEMOD(state, CFRUP1, MSB(freq)) < 0)
 			goto err;
-		if (STV090x_WRITE_DEMOD(state, CFRUP1, LSB(freq)) < 0)
+		if (STV090x_WRITE_DEMOD(state, CFRUP0, LSB(freq)) < 0)
 			goto err;
 
 		freq *= -1;
@@ -2256,7 +2256,7 @@
 		else
 			freq_init = freq_init - (freq_step * i);
 
-		dir = -1;
+		dir *= -1;
 
 		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x5c) < 0) /* Demod RESET */
 			goto err;
@@ -3156,7 +3156,7 @@
 
 	derot = (int_1 * int_2) +
 		((int_1 * tmp_2) >> 12) +
-		((int_1 * tmp_1) >> 12);
+		((int_2 * tmp_1) >> 12);
 
 	return derot;
 }
@@ -3463,7 +3463,7 @@
 	switch (state->delsys) {
 	case STV090x_DVBS1:
 	case STV090x_DSS:
-		if (state->algo == STV090x_SEARCH_AUTO) {
+		if (state->search_mode == STV090x_SEARCH_AUTO) {
 			reg = STV090x_READ_DEMOD(state, DMDCFGMD);
 			STV090x_SETFIELD_Px(reg, DVBS1_ENABLE_FIELD, 1);
 			STV090x_SETFIELD_Px(reg, DVBS2_ENABLE_FIELD, 0);
