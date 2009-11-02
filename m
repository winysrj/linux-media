Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58621 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932408AbZKBWvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:51:24 -0500
Message-ID: <4AEF626E.1070605@gmx.de>
Date: Mon, 02 Nov 2009 23:51:26 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 7/9] stv090x: additional check for signal presence based on
 AGC1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds an additional check for signal presence based on AGC1.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r c6b33af45211 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:03:44 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 23:08:29 2009 +0100
@@ -3997,7 +3997,7 @@
 	if ((agc1_power == 0) && (power_iq < STV090x_IQPOWER_THRESHOLD)) {
 		dprintk(FE_ERROR, 1, "No Signal: POWER_IQ=0x%02x", power_iq);
 		lock = 0;
-
+		signal_state = STV090x_NOAGC1;
 	} else {
 		reg = STV090x_READ_DEMOD(state, DEMOD);
 		STV090x_SETFIELD_Px(reg, SPECINV_CONTROL_FIELD, state->inversion);
@@ -4021,9 +4021,8 @@
 		}
 	}
 
-	/* need to check for AGC1 state */
-
-
+	if (signal_state == STV090x_NOAGC1)
+		return signal_state;
 
 	if (state->algo == STV090x_BLIND_SEARCH)
 		lock = stv090x_blind_search(state);
diff -r c6b33af45211 linux/drivers/media/dvb/frontends/stv090x_priv.h
--- a/linux/drivers/media/dvb/frontends/stv090x_priv.h	Mon Nov 02 23:03:44 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x_priv.h	Mon Nov 02 23:08:29 2009 +0100
@@ -91,6 +91,7 @@
 	STV090x_SEARCH_AGC2_TH_CUT30)
 
 enum stv090x_signal_state {
+	STV090x_NOAGC1,
 	STV090x_NOCARRIER,
 	STV090x_NODATA,
 	STV090x_DATAOK,
