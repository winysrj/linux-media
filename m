Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28280 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761249Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 17/22] mt2063: chane set_analog_params
Date: Tue, 14 Feb 2012 22:47:41 +0100
Message-Id: <1329256066-8844-17-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   97 ++++++++++++++-------------------
 1 files changed, 41 insertions(+), 56 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index e5d96e9..2a2cce3 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -261,22 +261,63 @@ static int mt2063_tune(struct mt2063_state *state)
 	return 0;
 }
 
+static int mt2063_set_analog_params(struct dvb_frontend *fe,
+				struct analog_parameters *params)
 {
+	struct mt2063_state *state = fe->tuner_priv;
+	u32 freq, bw;
+	int ret = 0;
 
+	dprintk(1, "\n");
 
+	mutex_lock(&state->lock);
 
+	/* open gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
 
+	/* all calculation is in kHz */
+	freq = params->frequency / 1000;
 
+	switch(params->mode) {
+	case V4L2_TUNER_RADIO:
+		state->mode = MT2063_OFFAIR_ANALOG;
+		state->if2 = 38900;
+		bw = 8000; /* TODO */
 		break;
+	case V4L2_TUNER_ANALOG_TV:
+		state->mode = MT2063_CABLE_ANALOG;
+		state->if2 = 38900;
+		if (params->std & ~V4L2_STD_MN)
+			bw = 6000;
+		else if (params->std & V4L2_STD_PAL_G)
+			bw = 7000;
+		else
+			bw = 8000;
 		break;
 	default:
+		ret = -EINVAL;
+		goto err;
 	}
 
+	state->frequency = freq;
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
 
 {
@@ -500,68 +541,12 @@ static int mt2063_release(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2063_set_analog_params(struct dvb_frontend *fe,
-				    struct analog_parameters *params)
 {
 	struct mt2063_state *state = fe->tuner_priv;
-	s32 pict_car;
-	s32 pict2chanb_vsb;
-	s32 ch_bw;
-	s32 if_mid;
-	s32 rcvr_mode;
-	int status;
-
-	dprintk(2, "\n");
-
-	if (!state->init) {
-		status = mt2063_init(fe);
-		if (status < 0)
-			return status;
-	}
-
-	switch (params->mode) {
-	case V4L2_TUNER_RADIO:
-		pict_car = 38900000;
-		ch_bw = 8000000;
-		pict2chanb_vsb = -(ch_bw / 2);
-		rcvr_mode = MT2063_OFFAIR_ANALOG;
-		break;
-	case V4L2_TUNER_ANALOG_TV:
-		rcvr_mode = MT2063_CABLE_ANALOG;
-		if (params->std & ~V4L2_STD_MN) {
-			pict_car = 38900000;
-			ch_bw = 6000000;
-			pict2chanb_vsb = -1250000;
-		} else if (params->std & V4L2_STD_PAL_G) {
-			pict_car = 38900000;
-			ch_bw = 7000000;
-			pict2chanb_vsb = -1250000;
-		} else {		/* PAL/SECAM standards */
-			pict_car = 38900000;
-			ch_bw = 8000000;
-			pict2chanb_vsb = -1250000;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-	if_mid = pict_car - (pict2chanb_vsb + (ch_bw / 2));
 
-	state->AS_Data.f_LO2_Step = 125000;	/* FIXME: probably 5000 for FM */
-	state->AS_Data.f_out = if_mid;
-	state->AS_Data.f_out_bw = ch_bw + 750000;
-	status = MT2063_SetReceiverMode(state, rcvr_mode);
-	if (status < 0)
-		return status;
 
-	dprintk(1, "Tuning to frequency: %d, bandwidth %d, foffset %d\n",
-		params->frequency, ch_bw, pict2chanb_vsb);
 
-	status = MT2063_Tune(state, (params->frequency + (pict2chanb_vsb + (ch_bw / 2))));
-	if (status < 0)
-		return status;
 
-	state->frequency = params->frequency;
 	return 0;
 }
 
-- 
1.7.7.6

