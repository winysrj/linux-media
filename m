Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65279 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3EHWvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 18:51:07 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M9M3c-1UhOkB3QSM-00Ci8e for
 <linux-media@vger.kernel.org>; Thu, 09 May 2013 00:51:05 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH 3/3] stb0899: use autodetected inversion instead of configured inversion
Date: Thu,  9 May 2013 00:50:56 +0200
Message-Id: <1368053456-18475-3-git-send-email-rnissl@gmx.de>
In-Reply-To: <1368053456-18475-1-git-send-email-rnissl@gmx.de>
References: <1368053456-18475-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For consistency, it is necessary to use the autodetected inversion
instead of the configured one.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index 4ce542c..a338e06 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -226,8 +226,8 @@ static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 			next_loop--;
 
 		if (next_loop) {
-			STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-			STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
+			STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(internal->inversion * derot_freq));
+			STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(internal->inversion * derot_freq));
 			stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency		*/
 		}
 		internal->direction = -internal->direction;	/* Change zigzag direction		*/
@@ -235,7 +235,7 @@ static enum stb0899_status stb0899_search_tmg(struct stb0899_state *state)
 
 	if (internal->status == TIMINGOK) {
 		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency		*/
-		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
+		internal->derot_freq = internal->inversion * MAKEWORD16(cfr[0], cfr[1]);
 		dprintk(state->verbose, FE_DEBUG, 1, "------->TIMING OK ! Derot Freq = %d", internal->derot_freq);
 	}
 
@@ -306,8 +306,8 @@ static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 				STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
 				stb0899_write_reg(state, STB0899_CFD, reg);
 
-				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
+				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(internal->inversion * derot_freq));
+				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(internal->inversion * derot_freq));
 				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 			}
 		}
@@ -317,7 +317,7 @@ static enum stb0899_status stb0899_search_carrier(struct stb0899_state *state)
 
 	if (internal->status == CARRIEROK) {
 		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency */
-		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
+		internal->derot_freq = internal->inversion * MAKEWORD16(cfr[0], cfr[1]);
 		dprintk(state->verbose, FE_DEBUG, 1, "----> CARRIER OK !, Derot Freq=%d", internal->derot_freq);
 	} else {
 		internal->derot_freq = last_derot_freq;
@@ -412,8 +412,8 @@ static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 				STB0899_SETFIELD_VAL(CFD_ON, reg, 1);
 				stb0899_write_reg(state, STB0899_CFD, reg);
 
-				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(state->config->inversion * derot_freq));
-				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(state->config->inversion * derot_freq));
+				STB0899_SETFIELD_VAL(CFRM, cfr[0], MSB(internal->inversion * derot_freq));
+				STB0899_SETFIELD_VAL(CFRL, cfr[1], LSB(internal->inversion * derot_freq));
 				stb0899_write_regs(state, STB0899_CFRM, cfr, 2); /* derotator frequency	*/
 
 				stb0899_check_carrier(state);
@@ -433,7 +433,7 @@ static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 		else
 			internal->inversion = IQ_SWAP_OFF;
 
-		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
+		internal->derot_freq = internal->inversion * MAKEWORD16(cfr[0], cfr[1]);
 		dprintk(state->verbose, FE_DEBUG, 1, "------> DATAOK ! Derot Freq=%d", internal->derot_freq);
 	}
 
-- 
1.8.1.4

