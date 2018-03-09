Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52446 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbeCIPxr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/11] media: lgdt330x: provide DVBv5 Carrier S/N measurements
Date: Fri,  9 Mar 2018 12:53:34 -0300
Message-Id: <b4dd71c9067f1d24744ac981b3f5ec1d4cddb259.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change the logic at the driver to provide CNR stats via
DVBv5 API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 47 +++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index bb61b4fb1df1..75b9ae6583e8 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -64,7 +64,7 @@ struct lgdt330x_state {
 
 	/* Demodulator private data */
 	enum fe_modulation current_modulation;
-	u32 snr; /* Result of last SNR calculation */
+	u32 snr;	/* Result of last SNR calculation */
 
 	/* Tuner private data */
 	u32 current_frequency;
@@ -187,6 +187,7 @@ static int lgdt330x_sw_reset(struct lgdt330x_state *state)
 static int lgdt330x_init(struct dvb_frontend *fe)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	char  *chip_name;
 	int    err;
 	/*
@@ -292,6 +293,10 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 	dprintk(state, "Initialized the %s chip\n", chip_name);
 	if (err < 0)
 		return err;
+
+	p->cnr.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	return lgdt330x_sw_reset(state);
 }
 
@@ -513,7 +518,7 @@ static u32 calculate_snr(u32 mse, u32 c)
 	return 10 * (c - mse);
 }
 
-static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
+static int lgdt3302_read_snr(struct dvb_frontend *fe)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
 	u8 buf[5];	/* read data buffer */
@@ -546,11 +551,13 @@ static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
 		dev_err(&state->client->dev,
 			"%s: Modulation set to unsupported value\n",
 			__func__);
+
+		state->snr = 0;
+
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
-	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
 	dprintk(state, "noise = 0x%08x, snr = %d.%02d dB\n", noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
@@ -558,7 +565,7 @@ static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
-static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
+static int lgdt3303_read_snr(struct dvb_frontend *fe)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
 	u8 buf[5];	/* read data buffer */
@@ -591,11 +598,11 @@ static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
 		dev_err(&state->client->dev,
 			"%s: Modulation set to unsupported value\n",
 			__func__);
+		state->snr = 0;
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
-	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
 	dprintk(state, "noise = 0x%08x, snr = %d.%02d dB\n", noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
@@ -603,6 +610,15 @@ static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
+static int lgdt330x_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct lgdt330x_state *state = fe->demodulator_priv;
+
+	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
+
+	return 0;
+}
+
 static int lgdt330x_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	/* Calculate Strength from SNR up to 35dB */
@@ -632,6 +648,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 				enum fe_status *status)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u8 buf[3];
 
 	*status = 0; /* Reset status result */
@@ -687,6 +704,13 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 			 __func__);
 	}
 
+	if (*status & FE_HAS_LOCK && lgdt3302_read_snr(fe) >= 0) {
+		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		p->cnr.stat[0].svalue = (((u64)state->snr) * 1000) >> 24;
+	} else {
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 }
 
@@ -694,6 +718,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 				enum fe_status *status)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int err;
 	u8 buf[3];
 
@@ -752,6 +777,14 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 			 "%s: Modulation set to unsupported value\n",
 			 __func__);
 	}
+
+	if (*status & FE_HAS_LOCK && lgdt3303_read_snr(fe) >= 0) {
+		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		p->cnr.stat[0].svalue = (((u64)state->snr) * 1000) >> 24;
+	} else {
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 }
 
@@ -878,7 +911,7 @@ static const struct dvb_frontend_ops lgdt3302_ops = {
 	.read_status          = lgdt3302_read_status,
 	.read_ber             = lgdt330x_read_ber,
 	.read_signal_strength = lgdt330x_read_signal_strength,
-	.read_snr             = lgdt3302_read_snr,
+	.read_snr             = lgdt330x_read_snr,
 	.read_ucblocks        = lgdt330x_read_ucblocks,
 	.release              = lgdt330x_release,
 };
@@ -901,7 +934,7 @@ static const struct dvb_frontend_ops lgdt3303_ops = {
 	.read_status          = lgdt3303_read_status,
 	.read_ber             = lgdt330x_read_ber,
 	.read_signal_strength = lgdt330x_read_signal_strength,
-	.read_snr             = lgdt3303_read_snr,
+	.read_snr             = lgdt330x_read_snr,
 	.read_ucblocks        = lgdt330x_read_ucblocks,
 	.release              = lgdt330x_release,
 };
-- 
2.14.3
