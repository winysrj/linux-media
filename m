Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42532 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbeCIPxp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:45 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/11] media: lgdt330x: move *read_status functions
Date: Fri,  9 Mar 2018 12:53:33 -0300
Message-Id: <c94545241a34fae69c8b9cad1295aba84069a551.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation to implement DVBv5 stats on this driver, move
the *read_status functions to happen after SNR and signal
strength routines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 255 +++++++++++++++++----------------
 1 file changed, 128 insertions(+), 127 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index c7355282bb3e..bb61b4fb1df1 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -472,133 +472,6 @@ static int lgdt330x_get_frontend(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int lgdt3302_read_status(struct dvb_frontend *fe,
-				enum fe_status *status)
-{
-	struct lgdt330x_state *state = fe->demodulator_priv;
-	u8 buf[3];
-
-	*status = 0; /* Reset status result */
-
-	/* AGC status register */
-	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
-	dprintk(state, "AGC_STATUS = 0x%02x\n", buf[0]);
-	if ((buf[0] & 0x0c) == 0x8) {
-		/*
-		 * Test signal does not exist flag
-		 * as well as the AGC lock flag.
-		 */
-		*status |= FE_HAS_SIGNAL;
-	}
-
-	/*
-	 * You must set the Mask bits to 1 in the IRQ_MASK in order
-	 * to see that status bit in the IRQ_STATUS register.
-	 * This is done in SwReset();
-	 */
-
-	/* signal status */
-	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
-	dprintk(state,
-		"TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
-		buf[0], buf[1], buf[2]);
-
-	/* sync status */
-	if ((buf[2] & 0x03) == 0x01)
-		*status |= FE_HAS_SYNC;
-
-	/* FEC error status */
-	if ((buf[2] & 0x0c) == 0x08)
-		*status |= FE_HAS_LOCK | FE_HAS_VITERBI;
-
-	/* Carrier Recovery Lock Status Register */
-	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk(state, "CARRIER_LOCK = 0x%02x\n", buf[0]);
-	switch (state->current_modulation) {
-	case QAM_256:
-	case QAM_64:
-		/* Need to understand why there are 3 lock levels here */
-		if ((buf[0] & 0x07) == 0x07)
-			*status |= FE_HAS_CARRIER;
-		break;
-	case VSB_8:
-		if ((buf[0] & 0x80) == 0x80)
-			*status |= FE_HAS_CARRIER;
-		break;
-	default:
-		dev_warn(&state->client->dev,
-			 "%s: Modulation set to unsupported value\n",
-			 __func__);
-	}
-
-	return 0;
-}
-
-static int lgdt3303_read_status(struct dvb_frontend *fe,
-				enum fe_status *status)
-{
-	struct lgdt330x_state *state = fe->demodulator_priv;
-	int err;
-	u8 buf[3];
-
-	*status = 0; /* Reset status result */
-
-	/* lgdt3303 AGC status register */
-	err = i2c_read_demod_bytes(state, 0x58, buf, 1);
-	if (err < 0)
-		return err;
-
-	dprintk(state, "AGC_STATUS = 0x%02x\n", buf[0]);
-	if ((buf[0] & 0x21) == 0x01) {
-		/*
-		 * Test input signal does not exist flag
-		 * as well as the AGC lock flag.
-		 */
-		*status |= FE_HAS_SIGNAL;
-	}
-
-	/* Carrier Recovery Lock Status Register */
-	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk(state, "CARRIER_LOCK = 0x%02x\n", buf[0]);
-	switch (state->current_modulation) {
-	case QAM_256:
-	case QAM_64:
-		/* Need to understand why there are 3 lock levels here */
-		if ((buf[0] & 0x07) == 0x07)
-			*status |= FE_HAS_CARRIER;
-		else
-			break;
-		i2c_read_demod_bytes(state, 0x8a, buf, 1);
-		dprintk(state, "QAM LOCK = 0x%02x\n", buf[0]);
-
-		if ((buf[0] & 0x04) == 0x04)
-			*status |= FE_HAS_SYNC;
-		if ((buf[0] & 0x01) == 0x01)
-			*status |= FE_HAS_LOCK;
-		if ((buf[0] & 0x08) == 0x08)
-			*status |= FE_HAS_VITERBI;
-		break;
-	case VSB_8:
-		if ((buf[0] & 0x80) == 0x80)
-			*status |= FE_HAS_CARRIER;
-		else
-			break;
-		i2c_read_demod_bytes(state, 0x38, buf, 1);
-		dprintk(state, "8-VSB LOCK = 0x%02x\n", buf[0]);
-
-		if ((buf[0] & 0x02) == 0x00)
-			*status |= FE_HAS_SYNC;
-		if ((buf[0] & 0xfd) == 0x01)
-			*status |= FE_HAS_VITERBI | FE_HAS_LOCK;
-		break;
-	default:
-		dev_warn(&state->client->dev,
-			 "%s: Modulation set to unsupported value\n",
-			 __func__);
-	}
-	return 0;
-}
-
 /*
  * Calculate SNR estimation (scaled by 2^24)
  *
@@ -754,6 +627,134 @@ static int lgdt330x_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 	return 0;
 }
 
+
+static int lgdt3302_read_status(struct dvb_frontend *fe,
+				enum fe_status *status)
+{
+	struct lgdt330x_state *state = fe->demodulator_priv;
+	u8 buf[3];
+
+	*status = 0; /* Reset status result */
+
+	/* AGC status register */
+	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
+	dprintk(state, "AGC_STATUS = 0x%02x\n", buf[0]);
+	if ((buf[0] & 0x0c) == 0x8) {
+		/*
+		 * Test signal does not exist flag
+		 * as well as the AGC lock flag.
+		 */
+		*status |= FE_HAS_SIGNAL;
+	}
+
+	/*
+	 * You must set the Mask bits to 1 in the IRQ_MASK in order
+	 * to see that status bit in the IRQ_STATUS register.
+	 * This is done in SwReset();
+	 */
+
+	/* signal status */
+	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
+	dprintk(state,
+		"TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
+		buf[0], buf[1], buf[2]);
+
+	/* sync status */
+	if ((buf[2] & 0x03) == 0x01)
+		*status |= FE_HAS_SYNC;
+
+	/* FEC error status */
+	if ((buf[2] & 0x0c) == 0x08)
+		*status |= FE_HAS_LOCK | FE_HAS_VITERBI;
+
+	/* Carrier Recovery Lock Status Register */
+	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
+	dprintk(state, "CARRIER_LOCK = 0x%02x\n", buf[0]);
+	switch (state->current_modulation) {
+	case QAM_256:
+	case QAM_64:
+		/* Need to understand why there are 3 lock levels here */
+		if ((buf[0] & 0x07) == 0x07)
+			*status |= FE_HAS_CARRIER;
+		break;
+	case VSB_8:
+		if ((buf[0] & 0x80) == 0x80)
+			*status |= FE_HAS_CARRIER;
+		break;
+	default:
+		dev_warn(&state->client->dev,
+			 "%s: Modulation set to unsupported value\n",
+			 __func__);
+	}
+
+	return 0;
+}
+
+static int lgdt3303_read_status(struct dvb_frontend *fe,
+				enum fe_status *status)
+{
+	struct lgdt330x_state *state = fe->demodulator_priv;
+	int err;
+	u8 buf[3];
+
+	*status = 0; /* Reset status result */
+
+	/* lgdt3303 AGC status register */
+	err = i2c_read_demod_bytes(state, 0x58, buf, 1);
+	if (err < 0)
+		return err;
+
+	dprintk(state, "AGC_STATUS = 0x%02x\n", buf[0]);
+	if ((buf[0] & 0x21) == 0x01) {
+		/*
+		 * Test input signal does not exist flag
+		 * as well as the AGC lock flag.
+		 */
+		*status |= FE_HAS_SIGNAL;
+	}
+
+	/* Carrier Recovery Lock Status Register */
+	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
+	dprintk(state, "CARRIER_LOCK = 0x%02x\n", buf[0]);
+	switch (state->current_modulation) {
+	case QAM_256:
+	case QAM_64:
+		/* Need to understand why there are 3 lock levels here */
+		if ((buf[0] & 0x07) == 0x07)
+			*status |= FE_HAS_CARRIER;
+		else
+			break;
+		i2c_read_demod_bytes(state, 0x8a, buf, 1);
+		dprintk(state, "QAM LOCK = 0x%02x\n", buf[0]);
+
+		if ((buf[0] & 0x04) == 0x04)
+			*status |= FE_HAS_SYNC;
+		if ((buf[0] & 0x01) == 0x01)
+			*status |= FE_HAS_LOCK;
+		if ((buf[0] & 0x08) == 0x08)
+			*status |= FE_HAS_VITERBI;
+		break;
+	case VSB_8:
+		if ((buf[0] & 0x80) == 0x80)
+			*status |= FE_HAS_CARRIER;
+		else
+			break;
+		i2c_read_demod_bytes(state, 0x38, buf, 1);
+		dprintk(state, "8-VSB LOCK = 0x%02x\n", buf[0]);
+
+		if ((buf[0] & 0x02) == 0x00)
+			*status |= FE_HAS_SYNC;
+		if ((buf[0] & 0xfd) == 0x01)
+			*status |= FE_HAS_VITERBI | FE_HAS_LOCK;
+		break;
+	default:
+		dev_warn(&state->client->dev,
+			 "%s: Modulation set to unsupported value\n",
+			 __func__);
+	}
+	return 0;
+}
+
 static int
 lgdt330x_get_tune_settings(struct dvb_frontend *fe,
 			   struct dvb_frontend_tune_settings *fe_tune_settings)
-- 
2.14.3
