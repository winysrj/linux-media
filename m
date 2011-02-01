Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33913 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BAWpp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:45:45 -0500
Received: by fxm20 with SMTP id 20so7355025fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:45:44 -0800 (PST)
Subject: [PATCH 7/9 v2] ds3000: remove unnecessary dnxt, dcur structures
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:41:02 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020041.03110.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

All necessary parameters already stored in frontend cache.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |  108 ++++-----------------------------
 1 files changed, 13 insertions(+), 95 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 11f1aa2..b2ba5f4 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -229,31 +229,11 @@ static u8 ds3000_dvbs2_init_tab[] = {
 	0xb8, 0x00,
 };
 
-/* DS3000 doesn't need some parameters as input and auto-detects them */
-/* save input from the application of those parameters */
-struct ds3000_tuning {
-	u32 frequency;
-	u32 symbol_rate;
-	fe_spectral_inversion_t inversion;
-	enum fe_code_rate fec;
-
-	/* input values */
-	u8 inversion_val;
-	fe_modulation_t delivery;
-	u8 rolloff;
-};
-
 struct ds3000_state {
 	struct i2c_adapter *i2c;
 	const struct ds3000_config *config;
-
 	struct dvb_frontend frontend;
-
-	struct ds3000_tuning dcur;
-	struct ds3000_tuning dnxt;
-
 	u8 skip_fw_load;
-
 	/* previous uncorrected block counter for DVB-S2 */
 	u16 prevUCBS2;
 };
@@ -401,45 +381,6 @@ static int ds3000_tuner_readreg(struct ds3000_state *state, u8 reg)
 	return b1[0];
 }
 
-static int ds3000_set_inversion(struct ds3000_state *state,
-					fe_spectral_inversion_t inversion)
-{
-	dprintk("%s(%d)\n", __func__, inversion);
-
-	switch (inversion) {
-	case INVERSION_OFF:
-	case INVERSION_ON:
-	case INVERSION_AUTO:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	state->dnxt.inversion = inversion;
-
-	return 0;
-}
-
-static int ds3000_set_symbolrate(struct ds3000_state *state, u32 rate)
-{
-	int ret = 0;
-
-	dprintk("%s()\n", __func__);
-
-	dprintk("%s() symbol_rate = %d\n", __func__, state->dnxt.symbol_rate);
-
-	/*  check if symbol rate is within limits */
-	if ((state->dnxt.symbol_rate >
-				state->frontend.ops.info.symbol_rate_max) ||
-	    (state->dnxt.symbol_rate <
-				state->frontend.ops.info.symbol_rate_min))
-		ret = -EOPNOTSUPP;
-
-	state->dnxt.symbol_rate = rate;
-
-	return ret;
-}
-
 static int ds3000_load_firmware(struct dvb_frontend *fe,
 					const struct firmware *fw);
 
@@ -790,13 +731,6 @@ static int ds3000_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-/* Overwrite the current tuning params, we are about to tune */
-static void ds3000_clone_params(struct dvb_frontend *fe)
-{
-	struct ds3000_state *state = fe->demodulator_priv;
-	memcpy(&state->dcur, &state->dnxt, sizeof(state->dcur));
-}
-
 static int ds3000_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
 {
 	struct ds3000_state *state = fe->demodulator_priv;
@@ -1027,22 +961,6 @@ static int ds3000_tune(struct dvb_frontend *fe,
 
 	dprintk("%s() ", __func__);
 
-	state->dnxt.delivery = c->modulation;
-	state->dnxt.frequency = c->frequency;
-	state->dnxt.rolloff = 2; /* fixme */
-	state->dnxt.fec = c->fec_inner;
-
-	ret = ds3000_set_inversion(state, p->inversion);
-	if (ret !=  0)
-		return ret;
-
-	ret = ds3000_set_symbolrate(state, c->symbol_rate);
-	if (ret !=  0)
-		return ret;
-
-	/* discard the 'current' tuning parameters and prepare to tune */
-	ds3000_clone_params(fe);
-
 	/* Reset status register */
 	status = 0;
 	/* Tune */
@@ -1053,14 +971,14 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	ds3000_tuner_writereg(state, 0x08, 0x01);
 	ds3000_tuner_writereg(state, 0x00, 0x01);
 	/* calculate and set freq divider */
-	if (state->dcur.frequency < 1146000) {
+	if (p->frequency < 1146000) {
 		ds3000_tuner_writereg(state, 0x10, 0x11);
-		ndiv = ((state->dcur.frequency * (6 + 8) * 4) +
+		ndiv = ((p->frequency * (6 + 8) * 4) +
 				(DS3000_XTAL_FREQ / 2)) /
 				DS3000_XTAL_FREQ - 1024;
 	} else {
 		ds3000_tuner_writereg(state, 0x10, 0x01);
-		ndiv = ((state->dcur.frequency * (6 + 8) * 2) +
+		ndiv = ((p->frequency * (6 + 8) * 2) +
 				(DS3000_XTAL_FREQ / 2)) /
 				DS3000_XTAL_FREQ - 1024;
 	}
@@ -1106,8 +1024,8 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	ds3000_tuner_writereg(state, 0x50, 0x00);
 	msleep(5);
 
-	f3db = ((state->dcur.symbol_rate / 1000) << 2) / 5 + 2000;
-	if ((state->dcur.symbol_rate / 1000) < 5000)
+	f3db = ((c->symbol_rate / 1000) << 2) / 5 + 2000;
+	if ((c->symbol_rate / 1000) < 5000)
 		f3db += 3000;
 	if (f3db < 7000)
 		f3db = 7000;
@@ -1196,30 +1114,30 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	ds3000_writereg(state, 0x25, 0x8a);
 
 	/* enhance symbol rate performance */
-	if ((state->dcur.symbol_rate / 1000) <= 5000) {
-		value = 29777 / (state->dcur.symbol_rate / 1000) + 1;
+	if ((c->symbol_rate / 1000) <= 5000) {
+		value = 29777 / (c->symbol_rate / 1000) + 1;
 		if (value % 2 != 0)
 			value++;
 		ds3000_writereg(state, 0xc3, 0x0d);
 		ds3000_writereg(state, 0xc8, value);
 		ds3000_writereg(state, 0xc4, 0x10);
 		ds3000_writereg(state, 0xc7, 0x0e);
-	} else if ((state->dcur.symbol_rate / 1000) <= 10000) {
-		value = 92166 / (state->dcur.symbol_rate / 1000) + 1;
+	} else if ((c->symbol_rate / 1000) <= 10000) {
+		value = 92166 / (c->symbol_rate / 1000) + 1;
 		if (value % 2 != 0)
 			value++;
 		ds3000_writereg(state, 0xc3, 0x07);
 		ds3000_writereg(state, 0xc8, value);
 		ds3000_writereg(state, 0xc4, 0x09);
 		ds3000_writereg(state, 0xc7, 0x12);
-	} else if ((state->dcur.symbol_rate / 1000) <= 20000) {
-		value = 64516 / (state->dcur.symbol_rate / 1000) + 1;
+	} else if ((c->symbol_rate / 1000) <= 20000) {
+		value = 64516 / (c->symbol_rate / 1000) + 1;
 		ds3000_writereg(state, 0xc3, value);
 		ds3000_writereg(state, 0xc8, 0x0e);
 		ds3000_writereg(state, 0xc4, 0x07);
 		ds3000_writereg(state, 0xc7, 0x18);
 	} else {
-		value = 129032 / (state->dcur.symbol_rate / 1000) + 1;
+		value = 129032 / (c->symbol_rate / 1000) + 1;
 		ds3000_writereg(state, 0xc3, value);
 		ds3000_writereg(state, 0xc8, 0x0a);
 		ds3000_writereg(state, 0xc4, 0x05);
@@ -1227,7 +1145,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	}
 
 	/* normalized symbol rate rounded to the closest integer */
-	value = (((state->dcur.symbol_rate / 1000) << 16) +
+	value = (((c->symbol_rate / 1000) << 16) +
 			(DS3000_SAMPLE_RATE / 2)) / DS3000_SAMPLE_RATE;
 	ds3000_writereg(state, 0x61, value & 0x00ff);
 	ds3000_writereg(state, 0x62, (value & 0xff00) >> 8);
-- 
1.7.1

