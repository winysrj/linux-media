Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab3AVQo7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 11:44:59 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0MGix9b011680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 11:44:59 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [REVIEW PATCHv12 5/6] [media] mb86a20s: improve bit error count for BER
Date: Tue, 22 Jan 2013 14:44:19 -0200
Message-Id: <1358873060-27609-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
References: <1358873060-27609-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do a better job on setting the bit error counters, in order to
have all layer measures to happen in a little less than one
second.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

v12: some improvements:

- Add a macro that defines the desired time for the bit count registers;
- Don't divide the counter by two anymore;
- avoid counter registers underflow/overflow.

 drivers/media/dvb-frontends/mb86a20s.c | 161 ++++++++++++++++++++++++++++++++-
 1 file changed, 158 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 0017ecb..4440df6 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -27,9 +27,12 @@ MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");
 struct mb86a20s_state {
 	struct i2c_adapter *i2c;
 	const struct mb86a20s_config *config;
+	u32 last_frequency;
 
 	struct dvb_frontend frontend;
 
+	u32 estimated_rate[3];
+
 	bool need_init;
 };
 
@@ -38,6 +41,8 @@ struct regdata {
 	u8 data;
 };
 
+#define BER_SAMPLING_RATE	1	/* Seconds */
+
 /*
  * Initialization sequence: Use whatevere default values that PV SBTVD
  * does on its initialisation, obtained via USB snoop
@@ -86,7 +91,7 @@ static struct regdata mb86a20s_init[] = {
 	 * it collects the bit error count. The bit counters are initialized
 	 * to 65535 here. This warrants that all of them will be quickly
 	 * calculated when device gets locked. As TMCC is parsed, the values
-	 * can be adjusted later in the driver's code.
+	 * will be adjusted later in the driver's code.
 	 */
 	{ 0x52, 0x01 },				/* Turn on BER before Viterbi */
 	{ 0x50, 0xa7 }, { 0x51, 0x00 },
@@ -484,6 +489,113 @@ static void mb86a20s_reset_frontend_cache(struct dvb_frontend *fe)
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
+	 * If modulation/fec/interleaving is not detected, the default is
+	 * to consider the lowest bit rate, to avoid taking too long time
+	 * to get BER.
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
+	/* Samples BER at BER_SAMPLING_RATE seconds */
+	rate = isdbt_rate[m][f][i] * segment * BER_SAMPLING_RATE;
+
+	/* Avoids sampling too quickly or to overflow the register */
+	if (rate < 256)
+		rate = 256;
+	else if (rate > (1 << 24) - 1)
+		rate = (1 << 24) - 1;
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
@@ -513,10 +625,11 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
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
@@ -538,6 +651,10 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe)
 		dev_dbg(&state->i2c->dev, "%s: interleaving %d.\n",
 			__func__, rc);
 		c->layer[i].interleaving = rc;
+		mb86a20s_layer_bitrate(fe, i, c->layer[i].modulation,
+				       c->layer[i].fec,
+				       c->layer[i].interleaving,
+				       c->layer[i].segment_count);
 	}
 
 	rc = mb86a20s_writereg(state, 0x6d, 0x84);
@@ -729,6 +846,42 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
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
@@ -921,8 +1074,10 @@ static int mb86a20s_set_frontend(struct dvb_frontend *fe)
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
+
 	rc = mb86a20s_writeregdata(state, mb86a20s_reset_reception);
 	mb86a20s_reset_counters(fe);
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
-- 
1.7.11.7

