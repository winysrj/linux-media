Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:28281 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761250Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 20/22] mt2063: change set_params function
Date: Tue, 14 Feb 2012 22:47:44 +0100
Message-Id: <1329256066-8844-20-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  111 ++++++++++++++--------------------
 1 files changed, 46 insertions(+), 65 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index fb0a38b..0c5d472 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -320,20 +320,66 @@ err:
 	return ret;
 }
 
+static int mt2063_set_params(struct dvb_frontend *fe)
 {
+	struct mt2063_state *state = fe->tuner_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 freq, bw;
+	int ret = 0;
 
+	dprintk(1, "\n");
 
+	mutex_lock(&state->lock);
 
+	/* open gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
+	/* all calculation is in kHz */
+	freq = c->frequency / 1000;
 
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		if (c->bandwidth_hz == 0) {
+			ret = -EINVAL;
+			goto err;
 		}
+		bw = c->bandwidth_hz / 1000;
+		state->mode = MT2063_OFFAIR_COFDM;
+		state->if2 = 36000;
+		break;
+	case SYS_DVBC_ANNEX_A:
+	case SYS_DVBC_ANNEX_C:
+		bw = c->bandwidth_hz / 1000;
+		state->mode = MT2063_CABLE_QAM;
+		state->if2 = 36000;
+		break;
+	case SYS_ATSC:
+		/* TODO */
+	default:
+		ret = -EINVAL;
+		goto err;
 	}
 
+	state->frequency = freq;
+	/* for spurcheck */
+	state->bw = bw;
 
+	dprintk(2, "Set input frequency to %d kHz.\n", freq);
 
+	ret = mt2063_set_mode(state, state->mode);
+	if (ret < 0)
+		goto err;
 
+	ret = mt2063_tune(state);
 
+err:
+	/* close gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
 
+	mutex_unlock(&state->lock);
+	return ret;
 }
 
 static int mt2063_init(struct dvb_frontend *fe)
@@ -570,79 +616,14 @@ static struct dvb_tuner_ops mt2063_ops = {
 	.get_if_frequency = mt2063_get_if_frequency,
 	/* TODO */
 };
-/*
- * As defined on EN 300 429, the DVB-C roll-off factor is 0.15.
- * So, the amount of the needed bandwith is given by:
- *	Bw = Symbol_rate * (1 + 0.15)
- * As such, the maximum symbol rate supported by 6 MHz is given by:
- *	max_symbol_rate = 6 MHz / 1.15 = 5217391 Bauds
- */
-#define MAX_SYMBOL_RATE_6MHz	5217391
 
-static int mt2063_set_params(struct dvb_frontend *fe)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct mt2063_state *state = fe->tuner_priv;
-	int status;
-	s32 pict_car;
-	s32 pict2chanb_vsb;
-	s32 ch_bw;
-	s32 if_mid;
-	s32 rcvr_mode;
-
-	if (!state->init) {
-		status = mt2063_init(fe);
-		if (status < 0)
-			return status;
-	}
 
-	dprintk(2, "\n");
 
-	if (c->bandwidth_hz == 0)
-		return -EINVAL;
-	if (c->bandwidth_hz <= 6000000)
-		ch_bw = 6000000;
-	else if (c->bandwidth_hz <= 7000000)
-		ch_bw = 7000000;
-	else
-		ch_bw = 8000000;
 
-	switch (c->delivery_system) {
-	case SYS_DVBT:
-		rcvr_mode = MT2063_OFFAIR_COFDM;
-		pict_car = 36125000;
-		pict2chanb_vsb = -(ch_bw / 2);
 		break;
-	case SYS_DVBC_ANNEX_A:
-	case SYS_DVBC_ANNEX_C:
-		rcvr_mode = MT2063_CABLE_QAM;
-		pict_car = 36125000;
-		pict2chanb_vsb = -(ch_bw / 2);
 		break;
 	default:
-		return -EINVAL;
-	}
-	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
-
-	state->AS_Data.f_LO2_Step = 125000;	/* FIXME: probably 5000 for FM */
-	state->AS_Data.f_out = if_mid;
-	state->AS_Data.f_out_bw = ch_bw + 750000;
-	status = MT2063_SetReceiverMode(state, rcvr_mode);
-	if (status < 0)
-		return status;
-
-	dprintk(1, "Tuning to frequency: %d, bandwidth %d, foffset %d\n",
-		c->frequency, ch_bw, pict2chanb_vsb);
-
-	status = MT2063_Tune(state, (c->frequency + (pict2chanb_vsb + (ch_bw / 2))));
-
-	if (status < 0)
-		return status;
-
-	state->frequency = c->frequency;
-	return 0;
-}
-
 		return -ENODEV;
 
 		return -ENODEV;
-- 
1.7.7.6

