Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaGDRRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:17:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 13/14] dib8000: improve debug messages
Date: Fri,  4 Jul 2014 14:15:39 -0300
Message-Id: <1404494140-17777-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When debug is enabled:
	- Report when frontend gets restarted;
	- Be coherent on the displayed lines;
	- Show the transmission mode;
	- Hide unused layers.

No functional changes (except at the printk's).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 64 ++++++++++++++++++++++++-----------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index be57e6831572..8f0ac5c16e26 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3392,7 +3392,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 	if (!(stat & FE_HAS_SYNC))
 		return 0;
 
-	dprintk("TMCC lock");
+	dprintk("dib8000_get_frontend: TMCC lock");
 	for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 		state->fe[index_frontend]->ops.read_status(state->fe[index_frontend], &stat);
 		if (stat&FE_HAS_SYNC) {
@@ -3428,94 +3428,117 @@ static int dib8000_get_frontend(struct dvb_frontend *fe)
 	switch ((val & 0x30) >> 4) {
 	case 1:
 		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_2K;
+		dprintk("dib8000_get_frontend: transmission mode 2K");
 		break;
 	case 2:
 		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_4K;
+		dprintk("dib8000_get_frontend: transmission mode 4K");
 		break;
 	case 3:
 	default:
 		fe->dtv_property_cache.transmission_mode = TRANSMISSION_MODE_8K;
+		dprintk("dib8000_get_frontend: transmission mode 8K");
 		break;
 	}
 
 	switch (val & 0x3) {
 	case 0:
 		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_32;
-		dprintk("dib8000_get_frontend GI = 1/32 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/32 ");
 		break;
 	case 1:
 		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_16;
-		dprintk("dib8000_get_frontend GI = 1/16 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/16 ");
 		break;
 	case 2:
-		dprintk("dib8000_get_frontend GI = 1/8 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/8 ");
 		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_8;
 		break;
 	case 3:
-		dprintk("dib8000_get_frontend GI = 1/4 ");
+		dprintk("dib8000_get_frontend: Guard Interval = 1/4 ");
 		fe->dtv_property_cache.guard_interval = GUARD_INTERVAL_1_4;
 		break;
 	}
 
 	val = dib8000_read_word(state, 505);
 	fe->dtv_property_cache.isdbt_partial_reception = val & 1;
-	dprintk("dib8000_get_frontend : partial_reception = %d ", fe->dtv_property_cache.isdbt_partial_reception);
+	dprintk("dib8000_get_frontend: partial_reception = %d ", fe->dtv_property_cache.isdbt_partial_reception);
 
 	for (i = 0; i < 3; i++) {
-		val = dib8000_read_word(state, 493 + i);
-		fe->dtv_property_cache.layer[i].segment_count = val & 0x0F;
-		dprintk("dib8000_get_frontend : Layer %d segments = %d ", i, fe->dtv_property_cache.layer[i].segment_count);
+		int show;
+
+		val = dib8000_read_word(state, 493 + i) & 0x0f;
+		fe->dtv_property_cache.layer[i].segment_count = val;
+
+		if (val == 0 || val > 13)
+			show = 0;
+		else
+			show = 1;
+
+		if (show)
+			dprintk("dib8000_get_frontend: Layer %d segments = %d ",
+				i, fe->dtv_property_cache.layer[i].segment_count);
 
 		val = dib8000_read_word(state, 499 + i) & 0x3;
 		/* Interleaving can be 0, 1, 2 or 4 */
 		if (val == 3)
 			val = 4;
 		fe->dtv_property_cache.layer[i].interleaving = val;
-		dprintk("dib8000_get_frontend : Layer %d time_intlv = %d ",
-			i, fe->dtv_property_cache.layer[i].interleaving);
+		if (show)
+			dprintk("dib8000_get_frontend: Layer %d time_intlv = %d ",
+				i, fe->dtv_property_cache.layer[i].interleaving);
 
 		val = dib8000_read_word(state, 481 + i);
 		switch (val & 0x7) {
 		case 1:
 			fe->dtv_property_cache.layer[i].fec = FEC_1_2;
-			dprintk("dib8000_get_frontend : Layer %d Code Rate = 1/2 ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 1/2 ", i);
 			break;
 		case 2:
 			fe->dtv_property_cache.layer[i].fec = FEC_2_3;
-			dprintk("dib8000_get_frontend : Layer %d Code Rate = 2/3 ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 2/3 ", i);
 			break;
 		case 3:
 			fe->dtv_property_cache.layer[i].fec = FEC_3_4;
-			dprintk("dib8000_get_frontend : Layer %d Code Rate = 3/4 ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 3/4 ", i);
 			break;
 		case 5:
 			fe->dtv_property_cache.layer[i].fec = FEC_5_6;
-			dprintk("dib8000_get_frontend : Layer %d Code Rate = 5/6 ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 5/6 ", i);
 			break;
 		default:
 			fe->dtv_property_cache.layer[i].fec = FEC_7_8;
-			dprintk("dib8000_get_frontend : Layer %d Code Rate = 7/8 ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d Code Rate = 7/8 ", i);
 			break;
 		}
 
 		val = dib8000_read_word(state, 487 + i);
 		switch (val & 0x3) {
 		case 0:
-			dprintk("dib8000_get_frontend : Layer %d DQPSK ", i);
 			fe->dtv_property_cache.layer[i].modulation = DQPSK;
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d DQPSK ", i);
 			break;
 		case 1:
 			fe->dtv_property_cache.layer[i].modulation = QPSK;
-			dprintk("dib8000_get_frontend : Layer %d QPSK ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d QPSK ", i);
 			break;
 		case 2:
 			fe->dtv_property_cache.layer[i].modulation = QAM_16;
-			dprintk("dib8000_get_frontend : Layer %d QAM16 ", i);
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d QAM16 ", i);
 			break;
 		case 3:
 		default:
-			dprintk("dib8000_get_frontend : Layer %d QAM64 ", i);
 			fe->dtv_property_cache.layer[i].modulation = QAM_64;
+			if (show)
+				dprintk("dib8000_get_frontend: Layer %d QAM64 ", i);
 			break;
 		}
 	}
@@ -3645,6 +3668,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 
 					for (l = 0; (l < MAX_NUMBER_OF_FRONTENDS) && (state->fe[l] != NULL); l++) {
 						if (l != index_frontend) { /* and for all frontend except the successful one */
+							dprintk("Restarting frontend %d\n", l);
 							dib8000_tune_restart_from_demod(state->fe[l]);
 
 							state->fe[l]->dtv_property_cache.isdbt_sb_mode = state->fe[index_frontend]->dtv_property_cache.isdbt_sb_mode;
-- 
1.9.3

