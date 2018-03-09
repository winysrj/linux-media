Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:43329 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751151AbeCIQPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 11:15:47 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2] media: lgdt330x: add block error counts via DVBv5
Date: Fri,  9 Mar 2018 13:15:41 -0300
Message-Id: <64ea9b5c825696f60a703a7bb93831f072db4051.1520612137.git.mchehab@s-opensource.com>
In-Reply-To: <9068a8d6825d63594ea8f680ef53756d55463531.1520610788.git.mchehab@s-opensource.com>
References: <9068a8d6825d63594ea8f680ef53756d55463531.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Show the UCB error counts via DVBv5.

Please notice that there's no scale indication at the driver.
As we don't have the datasheet, let's assume that it is receiving
data at a rate of 10.000 packets per second. Ideally, this should
be read or estimated.

In order to avoid flooding I2C bus with data, the maximum
polling rate for those stats was set to 1 second.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 100 +++++++++++++++++++++++++--------
 1 file changed, 76 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index b430b0500f12..927fd68e05ec 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -65,6 +65,8 @@ struct lgdt330x_state {
 	/* Demodulator private data */
 	enum fe_modulation current_modulation;
 	u32 snr;	/* Result of last SNR calculation */
+	u16 ucblocks;
+	unsigned long last_stats_time;
 
 	/* Tuner private data */
 	u32 current_frequency;
@@ -296,6 +298,11 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 
 	p->cnr.len = 1;
 	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_error.len = 1;
+	p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->block_count.len = 1;
+	p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	state->last_stats_time = 0;
 
 	return lgdt330x_sw_reset(state);
 }
@@ -303,29 +310,9 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 static int lgdt330x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
-	int err;
-	u8 buf[2];
 
-	*ucblocks = 0;
+	*ucblocks = state->ucblocks;
 
-	switch (state->config.demod_chip) {
-	case LGDT3302:
-		err = i2c_read_demod_bytes(state, LGDT3302_PACKET_ERR_COUNTER1,
-					   buf, sizeof(buf));
-		break;
-	case LGDT3303:
-		err = i2c_read_demod_bytes(state, LGDT3303_PACKET_ERR_COUNTER1,
-					   buf, sizeof(buf));
-		break;
-	default:
-		dev_warn(&state->client->dev,
-			 "Only LGDT3302 and LGDT3303 are supported chips.\n");
-		err = -ENODEV;
-	}
-	if (err < 0)
-		return err;
-
-	*ucblocks = (buf[0] << 8) | buf[1];
 	return 0;
 }
 
@@ -644,6 +631,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 	struct lgdt330x_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u8 buf[3];
+	int err;
 
 	*status = 0; /* Reset status result */
 
@@ -698,13 +686,45 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 			 __func__);
 	}
 
-	if (*status & FE_HAS_LOCK && lgdt3302_read_snr(fe) >= 0) {
+	if (!(*status & FE_HAS_LOCK)) {
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return 0;
+	}
+
+	if (state->last_stats_time &&
+	    time_is_after_jiffies(state->last_stats_time))
+		return 0;
+
+	state->last_stats_time = jiffies + msecs_to_jiffies(1000);
+
+	err = lgdt3302_read_snr(fe);
+	if (!err) {
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 		p->cnr.stat[0].svalue = (((u64)state->snr) * 1000) >> 24;
 	} else {
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	err = i2c_read_demod_bytes(state, LGDT3302_PACKET_ERR_COUNTER1,
+					   buf, sizeof(buf));
+	if (!err) {
+		state->ucblocks = (buf[0] << 8) | buf[1];
+
+		dprintk(state, "UCB = 0x%02x\n", state->ucblocks);
+
+		p->block_error.stat[0].uvalue += state->ucblocks;
+		/* FIXME: what's the basis for block count */
+		p->block_count.stat[0].uvalue += 10000;
+
+		p->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		p->block_count.stat[0].scale = FE_SCALE_COUNTER;
+	} else {
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 }
 
@@ -713,8 +733,8 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int err;
 	u8 buf[3];
+	int err;
 
 	*status = 0; /* Reset status result */
 
@@ -772,13 +792,45 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 			 __func__);
 	}
 
-	if (*status & FE_HAS_LOCK && lgdt3303_read_snr(fe) >= 0) {
+	if (!(*status & FE_HAS_LOCK)) {
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		return 0;
+	}
+
+	if (state->last_stats_time &&
+	    time_is_after_jiffies(state->last_stats_time))
+		return 0;
+
+	state->last_stats_time = jiffies + msecs_to_jiffies(1000);
+
+	err = lgdt3303_read_snr(fe);
+	if (!err) {
 		p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 		p->cnr.stat[0].svalue = (((u64)state->snr) * 1000) >> 24;
 	} else {
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	err = i2c_read_demod_bytes(state, LGDT3303_PACKET_ERR_COUNTER1,
+					   buf, sizeof(buf));
+	if (!err) {
+		state->ucblocks = (buf[0] << 8) | buf[1];
+
+		dprintk(state, "UCB = 0x%02x\n", state->ucblocks);
+
+		p->block_error.stat[0].uvalue += state->ucblocks;
+		/* FIXME: what's the basis for block count */
+		p->block_count.stat[0].uvalue += 10000;
+
+		p->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		p->block_count.stat[0].scale = FE_SCALE_COUNTER;
+	} else {
+		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 }
 
-- 
2.14.3
