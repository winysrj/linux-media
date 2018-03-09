Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34884 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbeCIPxs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:48 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/11] media: lgdt330x: fix coding style issues
Date: Fri,  9 Mar 2018 12:53:27 -0300
Message-Id: <637dcb8aa5a5749e679750f436ea9885fb2522a4.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're about to convert this driver to use the new i2c
binding way, let's first solve most coding style issues,
in order to avoid mixing coding style changes with code
changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 358 +++++++++++++++++++--------------
 1 file changed, 204 insertions(+), 154 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 8ad03bd81af5..ad0842fcdba5 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -47,18 +47,17 @@
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug,"Turn on/off lgdt330x frontend debugging (default:off).");
-#define dprintk(args...) \
-do { \
-if (debug) printk(KERN_DEBUG "lgdt330x: " args); \
+MODULE_PARM_DESC(debug, "Turn on/off lgdt330x frontend debugging (default:off).");
+#define dprintk(args...) do {				\
+	if (debug)					\
+		printk(KERN_DEBUG "lgdt330x: " args);	\
 } while (0)
 
-struct lgdt330x_state
-{
-	struct i2c_adapter* i2c;
+struct lgdt330x_state {
+	struct i2c_adapter *i2c;
 
 	/* Configuration settings */
-	const struct lgdt330x_config* config;
+	const struct lgdt330x_config *config;
 
 	struct dvb_frontend frontend;
 
@@ -70,21 +69,24 @@ struct lgdt330x_state
 	u32 current_frequency;
 };
 
-static int i2c_write_demod_bytes (struct lgdt330x_state* state,
-				  u8 *buf, /* data bytes to send */
-				  int len  /* number of bytes to send */ )
+static int i2c_write_demod_bytes(struct lgdt330x_state *state,
+				 u8 *buf, /* data bytes to send */
+				 int len  /* number of bytes to send */)
 {
-	struct i2c_msg msg =
-		{ .addr = state->config->demod_address,
-		  .flags = 0,
-		  .buf = buf,
-		  .len = 2 };
+	struct i2c_msg msg = {
+		.addr = state->config->demod_address,
+		.flags = 0,
+		.buf = buf,
+		.len = 2
+	};
 	int i;
 	int err;
 
-	for (i=0; i<len-1; i+=2){
-		if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
-			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n", __func__, msg.buf[0], msg.buf[1], err);
+	for (i = 0; i < len - 1; i += 2) {
+		err = i2c_transfer(state->i2c, &msg, 1);
+		if (err != 1) {
+			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n",
+			       __func__, msg.buf[0], msg.buf[1], err);
 			if (err < 0)
 				return err;
 			else
@@ -99,21 +101,29 @@ static int i2c_write_demod_bytes (struct lgdt330x_state* state,
  * This routine writes the register (reg) to the demod bus
  * then reads the data returned for (len) bytes.
  */
-
 static int i2c_read_demod_bytes(struct lgdt330x_state *state,
 				enum I2C_REG reg, u8 *buf, int len)
 {
-	u8 wr [] = { reg };
-	struct i2c_msg msg [] = {
-		{ .addr = state->config->demod_address,
-		  .flags = 0, .buf = wr,  .len = 1 },
-		{ .addr = state->config->demod_address,
-		  .flags = I2C_M_RD, .buf = buf, .len = len },
+	u8 wr[] = { reg };
+	struct i2c_msg msg[] = {
+		{
+			.addr = state->config->demod_address,
+			.flags = 0,
+			.buf = wr,
+			.len = 1
+		}, {
+			.addr = state->config->demod_address,
+			.flags = I2C_M_RD,
+			.buf = buf,
+			.len = len
+		},
 	};
 	int ret;
+
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
-		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __func__, state->config->demod_address, reg, ret);
+		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n",
+		       __func__, state->config->demod_address, reg, ret);
 		if (ret >= 0)
 			ret = -EIO;
 	} else {
@@ -123,19 +133,21 @@ static int i2c_read_demod_bytes(struct lgdt330x_state *state,
 }
 
 /* Software reset */
-static int lgdt3302_SwReset(struct lgdt330x_state* state)
+static int lgdt3302_sw_reset(struct lgdt330x_state *state)
 {
 	u8 ret;
 	u8 reset[] = {
 		IRQ_MASK,
-		0x00 /* bit 6 is active low software reset
-		      *	bits 5-0 are 1 to mask interrupts */
+		/*
+		 * bit 6 is active low software reset
+		 * bits 5-0 are 1 to mask interrupts
+		 */
+		0x00
 	};
 
 	ret = i2c_write_demod_bytes(state,
 				    reset, sizeof(reset));
 	if (ret == 0) {
-
 		/* force reset high (inactive) and unmask interrupts */
 		reset[1] = 0x7f;
 		ret = i2c_write_demod_bytes(state,
@@ -144,7 +156,7 @@ static int lgdt3302_SwReset(struct lgdt330x_state* state)
 	return ret;
 }
 
-static int lgdt3303_SwReset(struct lgdt330x_state* state)
+static int lgdt3303_sw_reset(struct lgdt330x_state *state)
 {
 	u8 ret;
 	u8 reset[] = {
@@ -155,7 +167,6 @@ static int lgdt3303_SwReset(struct lgdt330x_state* state)
 	ret = i2c_write_demod_bytes(state,
 				    reset, sizeof(reset));
 	if (ret == 0) {
-
 		/* force reset high (inactive) */
 		reset[1] = 0x01;
 		ret = i2c_write_demod_bytes(state,
@@ -164,58 +175,74 @@ static int lgdt3303_SwReset(struct lgdt330x_state* state)
 	return ret;
 }
 
-static int lgdt330x_SwReset(struct lgdt330x_state* state)
+static int lgdt330x_sw_reset(struct lgdt330x_state *state)
 {
 	switch (state->config->demod_chip) {
 	case LGDT3302:
-		return lgdt3302_SwReset(state);
+		return lgdt3302_sw_reset(state);
 	case LGDT3303:
-		return lgdt3303_SwReset(state);
+		return lgdt3303_sw_reset(state);
 	default:
 		return -ENODEV;
 	}
 }
 
-static int lgdt330x_init(struct dvb_frontend* fe)
+static int lgdt330x_init(struct dvb_frontend *fe)
 {
-	/* Hardware reset is done using gpio[0] of cx23880x chip.
+	/*
+	 * Hardware reset is done using gpio[0] of cx23880x chip.
 	 * I'd like to do it here, but don't know how to find chip address.
 	 * cx88-cards.c arranges for the reset bit to be inactive (high).
 	 * Maybe there needs to be a callable function in cx88-core or
-	 * the caller of this function needs to do it. */
+	 * the caller of this function needs to do it.
+	 */
 
 	/*
 	 * Array of byte pairs <address, value>
 	 * to initialize each different chip
 	 */
 	static u8 lgdt3302_init_data[] = {
-		/* Use 50MHz parameter values from spec sheet since xtal is 50 */
-		/* Change the value of NCOCTFV[25:0] of carrier
-		   recovery center frequency register */
+		/* Use 50MHz param values from spec sheet since xtal is 50 */
+		/*
+		 * Change the value of NCOCTFV[25:0] of carrier
+		 * recovery center frequency register
+		 */
 		VSB_CARRIER_FREQ0, 0x00,
 		VSB_CARRIER_FREQ1, 0x87,
 		VSB_CARRIER_FREQ2, 0x8e,
 		VSB_CARRIER_FREQ3, 0x01,
-		/* Change the TPCLK pin polarity
-		   data is valid on falling clock */
+		/*
+		 * Change the TPCLK pin polarity
+		 * data is valid on falling clock
+		 */
 		DEMUX_CONTROL, 0xfb,
-		/* Change the value of IFBW[11:0] of
-		   AGC IF/RF loop filter bandwidth register */
+		/*
+		 * Change the value of IFBW[11:0] of
+		 * AGC IF/RF loop filter bandwidth register
+		 */
 		AGC_RF_BANDWIDTH0, 0x40,
 		AGC_RF_BANDWIDTH1, 0x93,
 		AGC_RF_BANDWIDTH2, 0x00,
-		/* Change the value of bit 6, 'nINAGCBY' and
-		   'NSSEL[1:0] of ACG function control register 2 */
+		/*
+		 * Change the value of bit 6, 'nINAGCBY' and
+		 * 'NSSEL[1:0] of ACG function control register 2
+		 */
 		AGC_FUNC_CTRL2, 0xc6,
-		/* Change the value of bit 6 'RFFIX'
-		   of AGC function control register 3 */
+		/*
+		 * Change the value of bit 6 'RFFIX'
+		 * of AGC function control register 3
+		 */
 		AGC_FUNC_CTRL3, 0x40,
-		/* Set the value of 'INLVTHD' register 0x2a/0x2c
-		   to 0x7fe */
+		/*
+		 * Set the value of 'INLVTHD' register 0x2a/0x2c
+		 * to 0x7fe
+		 */
 		AGC_DELAY0, 0x07,
 		AGC_DELAY2, 0xfe,
-		/* Change the value of IAGCBW[15:8]
-		   of inner AGC loop filter bandwidth */
+		/*
+		 * Change the value of IAGCBW[15:8]
+		 * of inner AGC loop filter bandwidth
+		 */
 		AGC_LOOP_BANDWIDTH0, 0x08,
 		AGC_LOOP_BANDWIDTH1, 0x9a
 	};
@@ -234,7 +261,7 @@ static int lgdt330x_init(struct dvb_frontend* fe)
 		0x87, 0xda
 	};
 
-	struct lgdt330x_state* state = fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	char  *chip_name;
 	int    err;
 
@@ -249,13 +276,13 @@ static int lgdt330x_init(struct dvb_frontend* fe)
 		switch (state->config->clock_polarity_flip) {
 		case 2:
 			err = i2c_write_demod_bytes(state,
-					flip_2_lgdt3303_init_data,
-					sizeof(flip_2_lgdt3303_init_data));
+						    flip_2_lgdt3303_init_data,
+						    sizeof(flip_2_lgdt3303_init_data));
 			break;
 		case 1:
 			err = i2c_write_demod_bytes(state,
-					flip_1_lgdt3303_init_data,
-					sizeof(flip_1_lgdt3303_init_data));
+						    flip_1_lgdt3303_init_data,
+						    sizeof(flip_1_lgdt3303_init_data));
 			break;
 		case 0:
 		default:
@@ -265,24 +292,24 @@ static int lgdt330x_init(struct dvb_frontend* fe)
 		break;
 	default:
 		chip_name = "undefined";
-		printk (KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
+		printk(KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
 	dprintk("%s entered as %s\n", __func__, chip_name);
 	if (err < 0)
 		return err;
-	return lgdt330x_SwReset(state);
+	return lgdt330x_sw_reset(state);
 }
 
-static int lgdt330x_read_ber(struct dvb_frontend* fe, u32* ber)
+static int lgdt330x_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	*ber = 0; /* Not supplied by the demod chips */
 	return 0;
 }
 
-static int lgdt330x_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
+static int lgdt330x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
-	struct lgdt330x_state* state = fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	int err;
 	u8 buf[2];
 
@@ -298,8 +325,7 @@ static int lgdt330x_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 					   buf, sizeof(buf));
 		break;
 	default:
-		printk(KERN_WARNING
-		       "Only LGDT3302 and LGDT3303 are supported chips.\n");
+		printk(KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
 	if (err < 0)
@@ -322,7 +348,8 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 		0x0e, 0x87,
 		0x0f, 0x8e,
 		0x10, 0x01,
-		0x47, 0x8b };
+		0x47, 0x8b
+	};
 
 	/*
 	 * Array of byte pairs <address, value>
@@ -339,9 +366,10 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 		0x48, 0x66,
 		0x4d, 0x1a,
 		0x49, 0x08,
-		0x4a, 0x9b };
+		0x4a, 0x9b
+	};
 
-	struct lgdt330x_state* state = fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 
 	static u8 top_ctrl_cfg[]   = { TOP_CONTROL, 0x03 };
 
@@ -360,7 +388,8 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 				state->config->pll_rf_set(fe, 1);
 
 			if (state->config->demod_chip == LGDT3303) {
-				err = i2c_write_demod_bytes(state, lgdt3303_8vsb_44_data,
+				err = i2c_write_demod_bytes(state,
+							    lgdt3303_8vsb_44_data,
 							    sizeof(lgdt3303_8vsb_44_data));
 			}
 			break;
@@ -376,8 +405,9 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 				state->config->pll_rf_set(fe, 0);
 
 			if (state->config->demod_chip == LGDT3303) {
-				err = i2c_write_demod_bytes(state, lgdt3303_qam_data,
-											sizeof(lgdt3303_qam_data));
+				err = i2c_write_demod_bytes(state,
+							    lgdt3303_qam_data,
+							    sizeof(lgdt3303_qam_data));
 			}
 			break;
 
@@ -392,12 +422,14 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 				state->config->pll_rf_set(fe, 0);
 
 			if (state->config->demod_chip == LGDT3303) {
-				err = i2c_write_demod_bytes(state, lgdt3303_qam_data,
-											sizeof(lgdt3303_qam_data));
+				err = i2c_write_demod_bytes(state,
+							    lgdt3303_qam_data,
+							    sizeof(lgdt3303_qam_data));
 			}
 			break;
 		default:
-			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __func__, p->modulation);
+			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n",
+			       __func__, p->modulation);
 			return -1;
 		}
 		if (err < 0)
@@ -405,7 +437,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			       __func__, p->modulation);
 
 		/*
-		 * select serial or parallel MPEG harware interface
+		 * select serial or parallel MPEG hardware interface
 		 * Serial:   0x04 for LGDT3302 or 0x40 for LGDT3303
 		 * Parallel: 0x00
 		 */
@@ -422,15 +454,18 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 	/* Tune to the specified frequency */
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
-		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
 	/* Keep track of the new frequency */
-	/* FIXME this is the wrong way to do this...           */
-	/* The tuner is shared with the video4linux analog API */
+	/*
+	 * FIXME this is the wrong way to do this...
+	 * The tuner is shared with the video4linux analog API
+	 */
 	state->current_frequency = p->frequency;
 
-	lgdt330x_SwReset(state);
+	lgdt330x_sw_reset(state);
 	return 0;
 }
 
@@ -446,7 +481,7 @@ static int lgdt330x_get_frontend(struct dvb_frontend *fe,
 static int lgdt3302_read_status(struct dvb_frontend *fe,
 				enum fe_status *status)
 {
-	struct lgdt330x_state* state = fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	u8 buf[3];
 
 	*status = 0; /* Reset status result */
@@ -454,9 +489,11 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 	/* AGC status register */
 	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
 	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
-	if ((buf[0] & 0x0c) == 0x8){
-		/* Test signal does not exist flag */
-		/* as well as the AGC lock flag.   */
+	if ((buf[0] & 0x0c) == 0x8) {
+		/*
+		 * Test signal does not exist flag
+		 * as well as the AGC lock flag.
+		 */
 		*status |= FE_HAS_SIGNAL;
 	}
 
@@ -465,15 +502,15 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 	 * to see that status bit in the IRQ_STATUS register.
 	 * This is done in SwReset();
 	 */
+
 	/* signal status */
 	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
-	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n", __func__, buf[0], buf[1], buf[2]);
-
+	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
+		__func__, buf[0], buf[1], buf[2]);
 
 	/* sync status */
-	if ((buf[2] & 0x03) == 0x01) {
+	if ((buf[2] & 0x03) == 0x01)
 		*status |= FE_HAS_SYNC;
-	}
 
 	/* FEC error status */
 	if ((buf[2] & 0x0c) == 0x08) {
@@ -496,7 +533,8 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 			*status |= FE_HAS_CARRIER;
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __func__);
+		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n",
+		       __func__);
 	}
 
 	return 0;
@@ -505,7 +543,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 static int lgdt3303_read_status(struct dvb_frontend *fe,
 				enum fe_status *status)
 {
-	struct lgdt330x_state* state = fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	int err;
 	u8 buf[3];
 
@@ -517,9 +555,11 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 		return err;
 
 	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
-	if ((buf[0] & 0x21) == 0x01){
-		/* Test input signal does not exist flag */
-		/* as well as the AGC lock flag.   */
+	if ((buf[0] & 0x21) == 0x01) {
+		/*
+		 * Test input signal does not exist flag
+		 * as well as the AGC lock flag.
+		 */
 		*status |= FE_HAS_SIGNAL;
 	}
 
@@ -556,34 +596,36 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 		}
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __func__);
+		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n",
+		       __func__);
 	}
 	return 0;
 }
 
-/* Calculate SNR estimation (scaled by 2^24)
-
-   8-VSB SNR equations from LGDT3302 and LGDT3303 datasheets, QAM
-   equations from LGDT3303 datasheet.  VSB is the same between the '02
-   and '03, so maybe QAM is too?  Perhaps someone with a newer datasheet
-   that has QAM information could verify?
-
-   For 8-VSB: (two ways, take your pick)
-   LGDT3302:
-     SNR_EQ = 10 * log10(25 * 24^2 / EQ_MSE)
-   LGDT3303:
-     SNR_EQ = 10 * log10(25 * 32^2 / EQ_MSE)
-   LGDT3302 & LGDT3303:
-     SNR_PT = 10 * log10(25 * 32^2 / PT_MSE)  (we use this one)
-   For 64-QAM:
-     SNR    = 10 * log10( 688128   / MSEQAM)
-   For 256-QAM:
-     SNR    = 10 * log10( 696320   / MSEQAM)
-
-   We re-write the snr equation as:
-     SNR * 2^24 = 10*(c - intlog10(MSE))
-   Where for 256-QAM, c = log10(696320) * 2^24, and so on. */
-
+/*
+ * Calculate SNR estimation (scaled by 2^24)
+ *
+ * 8-VSB SNR equations from LGDT3302 and LGDT3303 datasheets, QAM
+ * equations from LGDT3303 datasheet.  VSB is the same between the '02
+ * and '03, so maybe QAM is too?  Perhaps someone with a newer datasheet
+ * that has QAM information could verify?
+ *
+ * For 8-VSB: (two ways, take your pick)
+ * LGDT3302:
+ *   SNR_EQ = 10 * log10(25 * 24^2 / EQ_MSE)
+ * LGDT3303:
+ *   SNR_EQ = 10 * log10(25 * 32^2 / EQ_MSE)
+ * LGDT3302 & LGDT3303:
+ *   SNR_PT = 10 * log10(25 * 32^2 / PT_MSE)  (we use this one)
+ * For 64-QAM:
+ *   SNR    = 10 * log10( 688128   / MSEQAM)
+ * For 256-QAM:
+ *   SNR    = 10 * log10( 696320   / MSEQAM)
+ *
+ * We re-write the snr equation as:
+ *   SNR * 2^24 = 10*(c - intlog10(MSE))
+ * Where for 256-QAM, c = log10(696320) * 2^24, and so on.
+ */
 static u32 calculate_snr(u32 mse, u32 c)
 {
 	if (mse == 0) /* No signal */
@@ -591,22 +633,24 @@ static u32 calculate_snr(u32 mse, u32 c)
 
 	mse = intlog10(mse);
 	if (mse > c) {
-		/* Negative SNR, which is possible, but realisticly the
-		demod will lose lock before the signal gets this bad.  The
-		API only allows for unsigned values, so just return 0 */
+		/*
+		 * Negative SNR, which is possible, but realisticly the
+		 * demod will lose lock before the signal gets this bad.
+		 * The API only allows for unsigned values, so just return 0
+		 */
 		return 0;
 	}
-	return 10*(c - mse);
+	return 10 * (c - mse);
 }
 
-static int lgdt3302_read_snr(struct dvb_frontend* fe, u16* snr)
+static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct lgdt330x_state* state = (struct lgdt330x_state*) fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	u8 buf[5];	/* read data buffer */
 	u32 noise;	/* noise value */
 	u32 c;		/* per-modulation SNR calculation constant */
 
-	switch(state->current_modulation) {
+	switch (state->current_modulation) {
 	case VSB_8:
 		i2c_read_demod_bytes(state, LGDT3302_EQPH_ERR0, buf, 5);
 #ifdef USE_EQMSE
@@ -617,7 +661,7 @@ static int lgdt3302_read_snr(struct dvb_frontend* fe, u16* snr)
 #else
 		/* Use Phase Tracker Mean-Square Error Register */
 		/* SNR for ranges from -13.11 to +44.08 */
-		noise = ((buf[0] & 7<<3) << 13) | (buf[3] << 8) | buf[4];
+		noise = ((buf[0] & 7 << 3) << 13) | (buf[3] << 8) | buf[4];
 		c = 73957994; /* log10(25*32^2)*2^24 */
 #endif
 		break;
@@ -638,19 +682,19 @@ static int lgdt3302_read_snr(struct dvb_frontend* fe, u16* snr)
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
 	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
-		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
+		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
 }
 
-static int lgdt3303_read_snr(struct dvb_frontend* fe, u16* snr)
+static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
-	struct lgdt330x_state* state = (struct lgdt330x_state*) fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	u8 buf[5];	/* read data buffer */
 	u32 noise;	/* noise value */
 	u32 c;		/* per-modulation SNR calculation constant */
 
-	switch(state->current_modulation) {
+	switch (state->current_modulation) {
 	case VSB_8:
 		i2c_read_demod_bytes(state, LGDT3303_EQPH_ERR0, buf, 5);
 #ifdef USE_EQMSE
@@ -687,12 +731,14 @@ static int lgdt3303_read_snr(struct dvb_frontend* fe, u16* snr)
 	return 0;
 }
 
-static int lgdt330x_read_signal_strength(struct dvb_frontend* fe, u16* strength)
+static int lgdt330x_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	/* Calculate Strength from SNR up to 35dB */
-	/* Even though the SNR can go higher than 35dB, there is some comfort */
-	/* factor in having a range of strong signals that can show at 100%   */
-	struct lgdt330x_state* state = (struct lgdt330x_state*) fe->demodulator_priv;
+	/*
+	 * Even though the SNR can go higher than 35dB, there is some comfort
+	 * factor in having a range of strong signals that can show at 100%
+	 */
+	struct lgdt330x_state *state = fe->demodulator_priv;
 	u16 snr;
 	int ret;
 
@@ -709,7 +755,9 @@ static int lgdt330x_read_signal_strength(struct dvb_frontend* fe, u16* strength)
 	return 0;
 }
 
-static int lgdt330x_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* fe_tune_settings)
+static int
+lgdt330x_get_tune_settings(struct dvb_frontend *fe,
+			   struct dvb_frontend_tune_settings *fe_tune_settings)
 {
 	/* I have no idea about this - it may not be needed */
 	fe_tune_settings->min_delay_ms = 500;
@@ -718,24 +766,25 @@ static int lgdt330x_get_tune_settings(struct dvb_frontend* fe, struct dvb_fronte
 	return 0;
 }
 
-static void lgdt330x_release(struct dvb_frontend* fe)
+static void lgdt330x_release(struct dvb_frontend *fe)
 {
-	struct lgdt330x_state* state = (struct lgdt330x_state*) fe->demodulator_priv;
+	struct lgdt330x_state *state = fe->demodulator_priv;
+
 	kfree(state);
 }
 
 static const struct dvb_frontend_ops lgdt3302_ops;
 static const struct dvb_frontend_ops lgdt3303_ops;
 
-struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
-				     struct i2c_adapter* i2c)
+struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
+				     struct i2c_adapter *i2c)
 {
-	struct lgdt330x_state* state = NULL;
+	struct lgdt330x_state *state = NULL;
 	u8 buf[1];
 
 	/* Allocate memory for the internal state */
-	state = kzalloc(sizeof(struct lgdt330x_state), GFP_KERNEL);
-	if (state == NULL)
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
 		goto error;
 
 	/* Setup the state */
@@ -745,10 +794,12 @@ struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 	/* Create dvb_frontend */
 	switch (config->demod_chip) {
 	case LGDT3302:
-		memcpy(&state->frontend.ops, &lgdt3302_ops, sizeof(struct dvb_frontend_ops));
+		memcpy(&state->frontend.ops, &lgdt3302_ops,
+		       sizeof(struct dvb_frontend_ops));
 		break;
 	case LGDT3303:
-		memcpy(&state->frontend.ops, &lgdt3303_ops, sizeof(struct dvb_frontend_ops));
+		memcpy(&state->frontend.ops, &lgdt3303_ops,
+		       sizeof(struct dvb_frontend_ops));
 		break;
 	default:
 		goto error;
@@ -766,17 +817,18 @@ struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 
 error:
 	kfree(state);
-	dprintk("%s: ERROR\n",__func__);
+	dprintk("%s: ERROR\n", __func__);
 	return NULL;
 }
+EXPORT_SYMBOL(lgdt330x_attach);
 
 static const struct dvb_frontend_ops lgdt3302_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
-		.name= "LG Electronics LGDT3302 VSB/QAM Frontend",
-		.frequency_min= 54000000,
-		.frequency_max= 858000000,
-		.frequency_stepsize= 62500,
+		.name = "LG Electronics LGDT3302 VSB/QAM Frontend",
+		.frequency_min = 54000000,
+		.frequency_max = 858000000,
+		.frequency_stepsize = 62500,
 		.symbol_rate_min    = 5056941,	/* QAM 64 */
 		.symbol_rate_max    = 10762000,	/* VSB 8  */
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
@@ -796,10 +848,10 @@ static const struct dvb_frontend_ops lgdt3302_ops = {
 static const struct dvb_frontend_ops lgdt3303_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
-		.name= "LG Electronics LGDT3303 VSB/QAM Frontend",
-		.frequency_min= 54000000,
-		.frequency_max= 858000000,
-		.frequency_stepsize= 62500,
+		.name = "LG Electronics LGDT3303 VSB/QAM Frontend",
+		.frequency_min = 54000000,
+		.frequency_max = 858000000,
+		.frequency_stepsize = 62500,
 		.symbol_rate_min    = 5056941,	/* QAM 64 */
 		.symbol_rate_max    = 10762000,	/* VSB 8  */
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
@@ -819,5 +871,3 @@ static const struct dvb_frontend_ops lgdt3303_ops = {
 MODULE_DESCRIPTION("LGDT330X (ATSC 8VSB & ITU-T J.83 AnnexB 64/256 QAM) Demodulator Driver");
 MODULE_AUTHOR("Wilson Michaels");
 MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL(lgdt330x_attach);
-- 
2.14.3
