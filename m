Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbcF2Wng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 10/10] lgdt3306a: better handle RF fake strength
Date: Wed, 29 Jun 2016 19:43:26 -0300
Message-Id: <1b52edc257e266b814302fb3f5035b66104ebffb.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a logic at lgdt3306a with emulates the signal strength
via SNR measures. Such logic should be used for dvbv5 stats
as well, so change the code to provide a more coherent
data to userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 121 ++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 54 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 6b686c3a44ce..446dc264701a 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -65,6 +65,7 @@ struct lgdt3306a_state {
 	enum fe_modulation current_modulation;
 	u32 current_frequency;
 	u32 snr;
+	u16 strength;
 };
 
 /*
@@ -1573,10 +1574,74 @@ lgdt3306a_qam_lock_poll(struct lgdt3306a_state *state)
 	return LG3306_UNLOCK;
 }
 
+
+static u16 lgdt3306a_fake_strength(struct dvb_frontend *fe)
+{
+	struct lgdt3306a_state *state = fe->demodulator_priv;
+	u16 snr; /* snr_x10 */
+	int ret;
+	u32 ref_snr; /* snr*100 */
+	u32 str;
+
+	/*
+	 * Calculate some sort of "strength" from SNR
+	 */
+
+	switch (state->current_modulation) {
+	case VSB_8:
+		 ref_snr = 1600; /* 16dB */
+		 break;
+	case QAM_64:
+		 ref_snr = 2200; /* 22dB */
+		 break;
+	case QAM_256:
+		 ref_snr = 2800; /* 28dB */
+		 break;
+	default:
+		return 0;
+	}
+
+	ret = fe->ops.read_snr(fe, &snr);
+	if (lg_chkerr(ret))
+		return 0;
+
+	if (state->snr <= (ref_snr - 100))
+		str = 0;
+	else if (state->snr <= ref_snr)
+		str = (0xffff * 65) / 100; /* 65% */
+	else {
+		str = state->snr - ref_snr;
+		str /= 50;
+		str += 78; /* 78%-100% */
+		if (str > 100)
+			str = 100;
+		str = (0xffff * str) / 100;
+	}
+
+	return (u16)str;
+}
+
 static void lgdt3306a_get_stats(struct dvb_frontend *fe, enum fe_status status)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgdt3306a_state *state = fe->demodulator_priv;
+	int ret;
+
+	if (fe->ops.tuner_ops.get_rf_strength) {
+		state->strength = 0;
+
+		ret = fe->ops.tuner_ops.get_rf_strength(fe, &state->strength);
+		if (ret == 0)
+			dbg_info("strength=%d\n", state->strength);
+		else
+			dbg_info("fe->ops.tuner_ops.get_rf_strength() failed\n");
+
+	} else {
+		state->strength = lgdt3306a_fake_strength(fe);
+		p->cnr.stat[0].scale = FE_SCALE_RELATIVE;
+
+		dbg_info("strength=%d\n", state->strength);
+	}
 
 	if (!(status & FE_HAS_LOCK))
 		return;
@@ -1589,17 +1654,8 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe,
 				 enum fe_status *status)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
-	u16 strength = 0;
 	int ret = 0;
 
-	if (fe->ops.tuner_ops.get_rf_strength) {
-		ret = fe->ops.tuner_ops.get_rf_strength(fe, &strength);
-		if (ret == 0)
-			dbg_info("strength=%d\n", strength);
-		else
-			dbg_info("fe->ops.tuner_ops.get_rf_strength() failed\n");
-	}
-
 	*status = 0;
 	if (lgdt3306a_neverlock_poll(state) == LG3306_NL_LOCK) {
 		*status |= FE_HAS_SIGNAL;
@@ -1633,13 +1689,11 @@ static int lgdt3306a_read_status(struct dvb_frontend *fe,
 		state->snr = 0;
 	}
 
-
 	lgdt3306a_get_stats(fe, *status);
 
 	return ret;
 }
 
-
 static int lgdt3306a_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct lgdt3306a_state *state = fe->demodulator_priv;
@@ -1652,52 +1706,11 @@ static int lgdt3306a_read_snr(struct dvb_frontend *fe, u16 *snr)
 static int lgdt3306a_read_signal_strength(struct dvb_frontend *fe,
 					 u16 *strength)
 {
-	/*
-	 * Calculate some sort of "strength" from SNR
-	 */
 	struct lgdt3306a_state *state = fe->demodulator_priv;
-	u16 snr; /* snr_x10 */
-	int ret;
-	u32 ref_snr; /* snr*100 */
-	u32 str;
 
-	*strength = 0;
+	*strength = state->strength;
 
-	switch (state->current_modulation) {
-	case VSB_8:
-		 ref_snr = 1600; /* 16dB */
-		 break;
-	case QAM_64:
-		 ref_snr = 2200; /* 22dB */
-		 break;
-	case QAM_256:
-		 ref_snr = 2800; /* 28dB */
-		 break;
-	default:
-		return -EINVAL;
-	}
-
-	ret = fe->ops.read_snr(fe, &snr);
-	if (lg_chkerr(ret))
-		goto fail;
-
-	if (state->snr <= (ref_snr - 100))
-		str = 0;
-	else if (state->snr <= ref_snr)
-		str = (0xffff * 65) / 100; /* 65% */
-	else {
-		str = state->snr - ref_snr;
-		str /= 50;
-		str += 78; /* 78%-100% */
-		if (str > 100)
-			str = 100;
-		str = (0xffff * str) / 100;
-	}
-	*strength = (u16)str;
-	dbg_info("strength=%u\n", *strength);
-
-fail:
-	return ret;
+	return 0;
 }
 
 /* ------------------------------------------------------------------------ */
-- 
2.7.4

