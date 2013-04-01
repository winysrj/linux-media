Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758318Ab3DAOnI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 10:43:08 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5/5] [media] mb86a20s: better name temp vars at mb86a20s_layer_bitrate()
Date: Mon,  1 Apr 2013 11:41:59 -0300
Message-Id: <1364827319-18332-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364827319-18332-1-git-send-email-mchehab@redhat.com>
References: <20130401072529.GL18466@mwanda>
 <1364827319-18332-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using 'i' for the guard interval temporary var is a bad idea, as
'i' is generally used by "anonymous" indexes.

Let's rename modulation, fec and guard interval temp vars with
a meaningful name, as that makes easier to understand the code
and avoids cut-and-paste types of error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 37 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index d25df75..0e6c535 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -566,12 +566,13 @@ static u32 isdbt_rate[3][5][4] = {
 };
 
 static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
-				   u32 modulation, u32 fec, u32 interleaving,
+				   u32 modulation, u32 forward_error_correction,
+				   u32 interleaving,
 				   u32 segment)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	u32 rate;
-	int m, f, i;
+	int mod, fec, guard;
 
 	/*
 	 * If modulation/fec/interleaving is not detected, the default is
@@ -582,54 +583,54 @@ static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
 	case DQPSK:
 	case QPSK:
 	default:
-		m = 0;
+		mod = 0;
 		break;
 	case QAM_16:
-		m = 1;
+		mod = 1;
 		break;
 	case QAM_64:
-		m = 2;
+		mod = 2;
 		break;
 	}
 
-	switch (fec) {
+	switch (forward_error_correction) {
 	default:
 	case FEC_1_2:
 	case FEC_AUTO:
-		f = 0;
+		fec = 0;
 		break;
 	case FEC_2_3:
-		f = 1;
+		fec = 1;
 		break;
 	case FEC_3_4:
-		f = 2;
+		fec = 2;
 		break;
 	case FEC_5_6:
-		f = 3;
+		fec = 3;
 		break;
 	case FEC_7_8:
-		f = 4;
+		fec = 4;
 		break;
 	}
 
 	switch (interleaving) {
 	default:
 	case GUARD_INTERVAL_1_4:
-		i = 0;
+		guard = 0;
 		break;
 	case GUARD_INTERVAL_1_8:
-		i = 1;
+		guard = 1;
 		break;
 	case GUARD_INTERVAL_1_16:
-		i = 2;
+		guard = 2;
 		break;
 	case GUARD_INTERVAL_1_32:
-		i = 3;
+		guard = 3;
 		break;
 	}
 
 	/* Samples BER at BER_SAMPLING_RATE seconds */
-	rate = isdbt_rate[m][f][i] * segment * BER_SAMPLING_RATE;
+	rate = isdbt_rate[mod][fec][guard] * segment * BER_SAMPLING_RATE;
 
 	/* Avoids sampling too quickly or to overflow the register */
 	if (rate < 256)
@@ -639,13 +640,13 @@ static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
 
 	dev_dbg(&state->i2c->dev,
 		"%s: layer %c bitrate: %d kbps; counter = %d (0x%06x)\n",
-	       __func__, 'A' + layer, segment * isdbt_rate[m][f][i]/1000,
+	        __func__, 'A' + layer,
+	        segment * isdbt_rate[mod][fec][guard]/1000,
 		rate, rate);
 
 	state->estimated_rate[layer] = rate;
 }
 
-
 static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-- 
1.8.1.4

