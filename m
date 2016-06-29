Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbcF2Wng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH 03/10] au8522: add support for dvbv5 statistics API
Date: Wed, 29 Jun 2016 19:43:19 -0300
Message-Id: <b3917218660c6db1d8435decf19a00038a09c6eb.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is possible to provide both SNR and signal strength in
dB. Let's convert it to use the DVBv5 API and start showing
the SNR in dB.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_dig.c  | 142 ++++++++++++++++++++++--------
 drivers/media/dvb-frontends/au8522_priv.h |   5 ++
 2 files changed, 108 insertions(+), 39 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index ee14fd48c414..8a0764f605b0 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -641,9 +641,17 @@ static int au8522_set_frontend(struct dvb_frontend *fe)
 
 	state->current_frequency = c->frequency;
 
+	/* Reset DVBv5 stats */
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = 0;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return 0;
 }
 
+static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status);
+
 static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct au8522_state *state = fe->demodulator_priv;
@@ -699,6 +707,8 @@ static int au8522_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	dprintk("%s() status 0x%08x\n", __func__, *status);
 
+	au8522_get_stats(fe, *status);
+
 	return 0;
 }
 
@@ -764,70 +774,108 @@ static int au8522_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return ret;
 }
 
-static int au8522_read_signal_strength(struct dvb_frontend *fe,
-				       u16 *signal_strength)
+static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status)
 {
-	u16 snr;
-	u32 tmp;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct au8522_state *state = fe->demodulator_priv;
 	int ret;
 
-	/* If the tuner has RF strength, use it */
+	/* Get S/N ratio */
+	if (status & FE_HAS_LOCK) {
+		ret = au8522_read_snr(fe, &state->snr);
+		if (ret < 0) {
+			state->snr = 0;
+			c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		} else {
+			c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+			c->cnr.stat[0].svalue = state->snr * 100;
+		}
+	} else {
+		state->snr = 0;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* Get (or estimate) RF strength */
 	if (fe->ops.tuner_ops.get_rf_strength) {
+		/* If the tuner has RF strength, use it */
+
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		ret = fe->ops.tuner_ops.get_rf_strength(fe, signal_strength);
+		ret = fe->ops.tuner_ops.get_rf_strength(fe, &state->strength);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
-		return ret;
-	}
-
-	/*
-	 * If it doen't, estimate from SNR
-	 * (borrowed from lgdt330x.c)
-	 *
-	 * Calculate strength from SNR up to 35dB
-	 * Even though the SNR can go higher than 35dB,
-	 * there is some comfort factor in having a range of
-	 * strong signals that can show at 100%
-	 */
-	ret = au8522_read_snr(fe, &snr);
-
-	*signal_strength = 0;
-
-	if (0 == ret) {
-		/* The following calculation method was chosen
+		if (ret < 0)
+			state->strength = 0;
+	} else {
+		u32 tmp;
+		/*
+		 * If it doen't, estimate from SNR
+		 * (borrowed from lgdt330x.c)
+		 *
+		 * Calculate strength from SNR up to 35dB
+		 * Even though the SNR can go higher than 35dB,
+		 * there is some comfort factor in having a range of
+		 * strong signals that can show at 100%
+		 *
+		 * The following calculation method was chosen
 		 * purely for the sake of code re-use from the
-		 * other demod drivers that use this method */
+		 * other demod drivers that use this method
+		 */
 
 		/* Convert from SNR in dB * 10 to 8.24 fixed-point */
-		tmp = (snr * ((1 << 24) / 10));
+		tmp = (state->snr * ((1 << 24) / 10));
 
 		/* Convert from 8.24 fixed-point to
-		 * scale the range 0 - 35*2^24 into 0 - 65535*/
+		* scale the range 0 - 35*2^24 into 0 - 65535*/
 		if (tmp >= 8960 * 0x10000)
-			*signal_strength = 0xffff;
+			state->strength = 0xffff;
 		else
-			*signal_strength = tmp / 8960;
+			state->strength = tmp / 8960;
 	}
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = state->strength;
 
-	return ret;
-}
-
-static int au8522_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	struct au8522_state *state = fe->demodulator_priv;
+	/* Read UCB blocks */
+	if (!(status & FE_HAS_LOCK)) {
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return;
+	}
 
 	if (state->current_modulation == VSB_8)
-		*ucblocks = au8522_readreg(state, 0x4087);
+		state->ucblocks = au8522_readreg(state, 0x4087);
 	else
-		*ucblocks = au8522_readreg(state, 0x4543);
+		state->ucblocks = au8522_readreg(state, 0x4543);
+
+	c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+	c->block_error.stat[0].uvalue = state->ucblocks;
+}
+static int au8522_read_signal_strength(struct dvb_frontend *fe,
+				       u16 *signal_strength)
+{
+	struct au8522_state *state = fe->demodulator_priv;
+
+	*signal_strength = state->strength;
+
+	return 0;
+}
+
+static int au8522_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct au8522_state *state = fe->demodulator_priv;
+
+	*ucblocks = state->ucblocks;
 
 	return 0;
 }
 
 static int au8522_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
-	return au8522_read_ucblocks(fe, ber);
+	struct au8522_state *state = fe->demodulator_priv;
+
+	/* FIXME: This is so wrong! */
+	*ber = state->ucblocks;
+
+	return 0;
 }
 
 static int au8522_get_frontend(struct dvb_frontend *fe,
@@ -908,6 +956,22 @@ error:
 }
 EXPORT_SYMBOL(au8522_attach);
 
+static int au8522_dvb_init(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	/* Initialize DVBv5 statistics */
+	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
+	c->strength.stat[0].uvalue = 0;
+	c->strength.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->cnr.len = 1;
+	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->block_error.len = 1;
+
+	return au8522_init(fe);
+}
+
 static struct dvb_frontend_ops au8522_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
@@ -918,7 +982,7 @@ static struct dvb_frontend_ops au8522_ops = {
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 
-	.init                 = au8522_init,
+	.init                 = au8522_dvb_init,
 	.sleep                = au8522_sleep,
 	.i2c_gate_ctrl        = au8522_i2c_gate_ctrl,
 	.set_frontend         = au8522_set_frontend,
diff --git a/drivers/media/dvb-frontends/au8522_priv.h b/drivers/media/dvb-frontends/au8522_priv.h
index f5a9438f6ce5..7b4f74997128 100644
--- a/drivers/media/dvb-frontends/au8522_priv.h
+++ b/drivers/media/dvb-frontends/au8522_priv.h
@@ -70,6 +70,11 @@ struct au8522_state {
 	u32 rev;
 	struct v4l2_ctrl_handler hdl;
 
+	/* Statistics */
+	u16 strength;
+	u16 snr;
+	u32 ucblocks;
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pads[DEMOD_NUM_PADS];
 #endif
-- 
2.7.4

