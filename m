Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430Ab3AQS7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:13 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0HIxDoP027502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 13:59:13 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv11 13/16] [media] mb86a20s: improve bit error count for BER
Date: Thu, 17 Jan 2013 16:58:27 -0200
Message-Id: <1358449110-11203-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
References: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do a better job on setting the bit error counters, in order to
have all layer measures to happen in a little less than one
second.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 186 ++++++++++++++++++++++++++++-----
 1 file changed, 162 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 6265003..b612985 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -30,6 +30,8 @@ struct mb86a20s_state {
 
 	struct dvb_frontend frontend;
 
+	u32 estimated_rate[3];
+
 	bool need_init;
 
 	/*
@@ -89,31 +91,20 @@ static struct regdata mb86a20s_init[] = {
 
 	/*
 	 * On this demod, when the bit count reaches the count below,
-	 * it collects the bit error count.
-	 *
-	 * As FE thread runs on every 3 seconds, adjust the counters to
-	 * provide one collect before 3 seconds, at the worse case (DQPSK,
-	 * 1/4 guard interval, 1/2 FEC, 1-seg rate is 280 Mbps, and
-	 * 3 seconds takes 0xcdb9f bits. Rounds it down to 0xccfff
-	 *
-	 * It should be noticed, however, that, with QAM-64 1/32 guard interval,
-	 * 1 segment bit rate is 1.78 Mbps, and 12-seg is about 21.5 Mbps.
-	 * At such rate, the time to measure BER is about 40 ms.
-	 *
-	 * It makes sense to change the logic there to use TMCC parameters and
-	 * adjust the counters in order to have all of them to take a little
-	 * less than 3 seconds, in order to have a more realistic BER rate,
-	 * instead of having short samples for 12-segs.
+	 * it collects the bit error count. The bit counters are initialized
+	 * to 65535 here. This warrants that all of them will be quickly
+	 * calculated when device gets locked. As TMCC is parsed, the values
+	 * will be adjusted later in the driver's code.
 	 */
 	{ 0x52, 0x01 },				/* Turn on BER before Viterbi */
-	{ 0x50, 0xa7 }, { 0x51, 0x0c },
-	{ 0x50, 0xa8 }, { 0x51, 0xcf },
+	{ 0x50, 0xa7 }, { 0x51, 0x00 },
+	{ 0x50, 0xa8 }, { 0x51, 0xff },
 	{ 0x50, 0xa9 }, { 0x51, 0xff },
-	{ 0x50, 0xaa }, { 0x51, 0x0c },
-	{ 0x50, 0xab }, { 0x51, 0xcf },
+	{ 0x50, 0xaa }, { 0x51, 0x00 },
+	{ 0x50, 0xab }, { 0x51, 0xff },
 	{ 0x50, 0xac }, { 0x51, 0xff },
-	{ 0x50, 0xad }, { 0x51, 0x0c },
-	{ 0x50, 0xae }, { 0x51, 0xcf },
+	{ 0x50, 0xad }, { 0x51, 0x00 },
+	{ 0x50, 0xae }, { 0x51, 0xff },
 	{ 0x50, 0xaf }, { 0x51, 0xff },
 
 	{ 0x5e, 0x07 },
@@ -208,7 +199,7 @@ static struct regdata mb86a20s_clear_stats[] = {
  */
 
 static int mb86a20s_i2c_writereg(struct mb86a20s_state *state,
-			     u8 i2c_addr, int reg, int data)
+			     u8 i2c_addr, u8 reg, u8 data)
 {
 	u8 buf[] = { reg, data };
 	struct i2c_msg msg = {
@@ -504,6 +495,112 @@ static void mb86a20s_reset_frontend_cache(struct dvb_frontend *fe)
 	c->isdbt_sb_segment_count = 0;
 }
 
+/*
+ * Estimates the bit rate using the per-segment bit rate given by
+ * ABNT/NBR 15601 spec (table 4).
+ */
+static u32 isdbt_rate[3][5][4] = {
+	{	/* DQPSK/QPSK */
+		{  280850,  312060,  330420,  340430 },	/* 1/2 */
+		{  374470,  416080,  440560,  453910 },	/* 2/3 */
+		{  421280,  468090,  495630,  510650 },	/* 3/4 */
+		{  468090,  520100,  550700,  567390 },	/* 5/6 */
+		{  491500,  546110,  578230,  595760 },	/* 7/8 */
+	}, {	/* QAM16 */
+		{  561710,  624130,  660840,  680870 },	/* 1/2 */
+		{  748950,  832170,  881120,  907820 },	/* 2/3 */
+		{  842570,  936190,  991260, 1021300 },	/* 3/4 */
+		{  936190, 1040210, 1101400, 1134780 },	/* 5/6 */
+		{  983000, 1092220, 1156470, 1191520 },	/* 7/8 */
+	}, {	/* QAM64 */
+		{  842570,  936190,  991260, 1021300 },	/* 1/2 */
+		{ 1123430, 1248260, 1321680, 1361740 },	/* 2/3 */
+		{ 1263860, 1404290, 1486900, 1531950 },	/* 3/4 */
+		{ 1404290, 1560320, 1652110, 1702170 },	/* 5/6 */
+		{ 1474500, 1638340, 1734710, 1787280 },	/* 7/8 */
+	}
+};
+
+static void mb86a20s_layer_bitrate(struct dvb_frontend *fe, u32 layer,
+				   u32 modulation, u32 fec, u32 interleaving,
+				   u32 segment)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	u32 rate;
+	int m, f, i;
+
+	/*
+	 * default is always the lowest bit rate, to be sure that it will
+	 * take less than 1 second to count the bits
+	 */
+	switch (modulation) {
+	case DQPSK:
+	case QPSK:
+	default:
+		m = 0;
+		break;
+	case QAM_16:
+		m = 1;
+		break;
+	case QAM_64:
+		m = 2;
+		break;
+	}
+
+	switch (fec) {
+	default:
+	case FEC_1_2:
+	case FEC_AUTO:
+		f = 0;
+		break;
+	case FEC_2_3:
+		f = 1;
+		break;
+	case FEC_3_4:
+		f = 2;
+		break;
+	case FEC_5_6:
+		f = 3;
+		break;
+	case FEC_7_8:
+		f = 4;
+		break;
+	}
+
+	switch (interleaving) {
+	default:
+	case GUARD_INTERVAL_1_4:
+		i = 0;
+		break;
+	case GUARD_INTERVAL_1_8:
+		i = 1;
+		break;
+	case GUARD_INTERVAL_1_16:
+		i = 2;
+		break;
+	case GUARD_INTERVAL_1_32:
+		i = 3;
+		break;
+	}
+
+	/*
+	 * Estimates a rate below the real one, to have more hope that the
+	 * BER calculus will finish before 1 second.
+	 */
+	rate = (isdbt_rate[m][f][i] >> 16) << 15;
+
+	/* Multiplies the rate by the number of segments */
+	rate *= segment;
+
+	dev_dbg(&state->i2c->dev,
+		"%s: layer %c bitrate: %d kbps; counter = %d (0x%06x)\n",
+	       __func__, 'A' + layer, segment * isdbt_rate[m][f][i]/1000,
+		rate, rate);
+
+	state->estimated_rate[i] = rate;
+}
+
+
 static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -533,10 +630,11 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 		rc = mb86a20s_get_segment_count(state, i);
 		if (rc < 0)
 			goto noperlayer_error;
-		if (rc >= 0 && rc < 14)
+		if (rc >= 0 && rc < 14) {
 			c->layer[i].segment_count = rc;
-		else {
+		} else {
 			c->layer[i].segment_count = 0;
+			state->estimated_rate[i] = 0;
 			continue;
 		}
 		c->isdbt_layer_enabled |= 1 << i;
@@ -558,6 +656,10 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 		dev_dbg(&state->i2c->dev, "%s: interleaving %d.\n",
 			__func__, rc);
 		c->layer[i].interleaving = rc;
+		mb86a20s_layer_bitrate(fe, i, c->layer[i].modulation,
+				       c->layer[i].fec,
+				       c->layer[i].interleaving,
+				       c->layer[i].segment_count);
 	}
 
 	rc = mb86a20s_writereg(state, 0x6d, 0x84);
@@ -754,6 +856,42 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 		"%s: bit count before Viterbi for layer %c: %d.\n",
 		__func__, 'A' + layer, *count);
 
+	/*
+	 * As we get TMCC data from the frontend, we can better estimate the
+	 * BER bit counters, in order to do the BER measure during a longer
+	 * time. Use those data, if available, to update the bit count
+	 * measure.
+	 */
+
+	if (state->estimated_rate[layer]
+	    && state->estimated_rate[layer] != *count) {
+		dev_dbg(&state->i2c->dev,
+			"%s: updating layer %c counter to %d.\n",
+			__func__, 'A' + layer, state->estimated_rate[layer]);
+		rc = mb86a20s_writereg(state, 0x50, 0xa7 + layer * 3);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51,
+				       state->estimated_rate[layer] >> 16);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x50, 0xa8 + layer * 3);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51,
+				       state->estimated_rate[layer] >> 8);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x50, 0xa9 + layer * 3);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_writereg(state, 0x51,
+				       state->estimated_rate[layer]);
+		if (rc < 0)
+			return rc;
+	}
+
+
 	/* Reset counter to collect new data */
 	rc = mb86a20s_writereg(state, 0x53, 0x07 & ~(1 << layer));
 	if (rc < 0)
-- 
1.7.11.7

