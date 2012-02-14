Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28301 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761254Ab2BNVs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:29 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 13/22] mt2063: new tune function
Date: Tue, 14 Feb 2012 22:47:37 +0100
Message-Id: <1329256066-8844-13-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  225 ++++++++++++----------------------
 1 files changed, 76 insertions(+), 149 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 8cc58a1..452c517 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -172,16 +172,91 @@ static int mt2063_set_mode(struct mt2063_state *state, enum mt2063_delsys Mode)
 	return 0;
 }
 
+#define MT2063_IF1	1510000
+#define MT2063_OSC	16000
 
+static int mt2063_tune(struct mt2063_state *state)
+{
+	u32 f_lo1, f_lo2;
+	u32 div1, num1, div2;
+	u32 num2;
+	bool lock = false;
 
+	dprintk(1, "\n");
 
 	/*
+	 * it use ClearTune in auto mode, so it doesn't set ClearTune RF Band.
+	 *
+	 * first IF Filter Center frequency (f_if1) is static setted to 1510 MHz
+	 * the reference osc is always 16 MHz
+	 *
+	 * f_if1 = (f_ref / 8) * (FIFFC + 640)
+	 *
+	 * f_if2_of = (f_if1 (f_ref / 64)) - ( 8 * FIFFC) - 4992
 	 *
+	 * f_lo1 = f_in + f_if1
+	 *
+	 * f_lo2 = f_lo1 - f_in - f_if2
 	 *
 	 */
-
+	f_lo1 = state->frequency + MT2063_IF1;
+	/* rounding it to a multiple of 250 kHz */
+	f_lo1 = (f_lo1 / 250) * 250;
+
+	f_lo2 = f_lo1 - state->frequency - state->if2;
+	/* rounding it to a multiple of 50 kHz */
+	f_lo2 = ((f_lo2 + 25) / 50) * 50;
+
+	/* TODO: spuck check */
+
+	/* f_lo1 = 16MHz * (div1 + num1/64) */
+	num1 = f_lo1 / (MT2063_OSC / 64);
+	div1 = num1 / 64;
+	num1 &= 0x3f;
+
+	/* f_lo2 = 16MHz * (div2 + num2/8192) */
+	num2 = f_lo2 * 64 / (MT2063_OSC / 128);
+	div2 = num2 / 8192;
+	num2 &= 0x1fff;
+
+	state->frequency = f_lo1 - f_lo2 - state->if2;
+
+	dprintk(2, "Input frequency: %d kHz\n", state->frequency);
+	dprintk(2, "first IF Filter central frequency: %d kHz\n", 1510000);
+	dprintk(2, "IF Output frequency: %d kHz\n", state->if2);
+	dprintk(2, "LO1 frequency: %d kHz\n", f_lo1);
+	dprintk(2, "LO1 div: %d, 0x%02x\n", div1, div1);
+	dprintk(2, "LO1 num: %d/64, 0x%02x\n", num1, num1);
+	dprintk(2, "LO2 frequency: %d kHz\n", f_lo2);
+	dprintk(2, "LO2 div: %d, 0x%02x\n", div2, div2);
+	dprintk(2, "LO2 num: %d/8192, 0x%04x\n", num2, num2);
+
+	/* set first IF filter center frequency */
+	mt2063_write(state, MT2063_REG_FIFFC, 115);
+
+	/* set LO1 */
+	mt2063_write(state, MT2063_REG_LO1CQ_1, (div1 & 0xff));
+	mt2063_write(state, MT2063_REG_LO1CQ_2, (num1 & 0x3f));
+	/* set LO2, the lastest value with reset */
+	mt2063_write(state, MT2063_REG_LO2CQ_1, (((div2 & 0x7f) << 1) |
+						((num2 & 0x1000) >> 12)));
+	mt2063_write(state, MT2063_REG_LO2CQ_2, ((num2 & 0x0ff0) >> 4));
+	mt2063_write(state, MT2063_REG_LO2CQ_3, ( 0xe0 | (num2 & 0x000f)));
+
+	/* wait util it's lock */
 	do {
+		u8 status;
+		/* read LO status bit */
+		mt2063_read(state, MT2063_REG_LO_STATUS, &status);
+
+		if (state->tuner_id == MT2063_B0) {
+			if ((status & 0xc0) == 0xc0)
+				lock = true;
+		} else {
+			if ((status & 0x88) == 0x88)
+				lock = true;
 		}
+	} while (!lock);
 
 	return 0;
 }
@@ -207,165 +282,17 @@ static int mt2063_set_mode(struct mt2063_state *state, enum mt2063_delsys Mode)
 {
 
 
-/*
- * MT2063_Tune() - Change the tuner's tuned frequency to RFin.
- */
-static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
-{				/* RF input center frequency   */
-
-	u32 status = 0;
-	u32 LO1;		/*  1st LO register value           */
-	u32 Num1;		/*  Numerator for LO1 reg. value    */
-	u32 f_IF1;		/*  1st IF requested                */
-	u32 LO2;		/*  2nd LO register value           */
-	u32 Num2;		/*  Numerator for LO2 reg. value    */
-	u32 ofLO1, ofLO2;	/*  last time's LO frequencies      */
-	u8 fiffc = 0x80;	/*  FIFF center freq from tuner     */
-	u32 fiffof;		/*  Offset from FIFF center freq    */
-	const u8 LO1LK = 0x80;	/*  Mask for LO1 Lock bit           */
-	u8 LO2LK = 0x08;	/*  Mask for LO2 Lock bit           */
-	u8 val;
-	u32 RFBand;
 
-	dprintk(2, "\n");
-	/*  Check the input and output frequency ranges                   */
-	if ((f_in < MT2063_MIN_FIN_FREQ) || (f_in > MT2063_MAX_FIN_FREQ))
-		return -EINVAL;
-
-	if ((state->AS_Data.f_out < MT2063_MIN_FOUT_FREQ)
-	    || (state->AS_Data.f_out > MT2063_MAX_FOUT_FREQ))
-		return -EINVAL;
 
-	/*
-	 * Save original LO1 and LO2 register values
-	 */
-	ofLO1 = state->AS_Data.f_LO1;
-	ofLO2 = state->AS_Data.f_LO2; 
 
-	/*
-	 * Find and set RF Band setting
-	 */
-	if (state->ctfilt_sw == 1) {
-		val = (state->reg[MT2063_REG_CTUNE_CTRL] | 0x08);
-		if (state->reg[MT2063_REG_CTUNE_CTRL] != val) {
-			status |=
-			    mt2063_setreg(state, MT2063_REG_CTUNE_CTRL, val);
-		}
-		val = state->reg[MT2063_REG_CTUNE_OV];
-		state->reg[MT2063_REG_CTUNE_OV] =
-		    (u8) ((state->reg[MT2063_REG_CTUNE_OV] & ~0x1F)
-			      | RFBand);
-		if (state->reg[MT2063_REG_CTUNE_OV] != val) {
-			status |=
-			    mt2063_setreg(state, MT2063_REG_CTUNE_OV, val);
 		}
 	}
 
-	/*
-	 * Read the FIFF Center Frequency from the tuner
-	 */
-	if (status >= 0) {
-		status |=
-		    mt2063_read(state,
-				   MT2063_REG_FIFFC,
-				   &state->reg[MT2063_REG_FIFFC], 1);
-		fiffc = state->reg[MT2063_REG_FIFFC];
-	}
-	/*
-	 * Assign in the requested values
-	 */
-	state->AS_Data.f_in = f_in;
-	/*
-	 *  Check the upconverter and downconverter frequency ranges
-	 */
-	if ((state->AS_Data.f_LO1 < MT2063_MIN_UPC_FREQ)
-	    || (state->AS_Data.f_LO1 > MT2063_MAX_UPC_FREQ))
-		status |= MT2063_UPC_RANGE;
-	if ((state->AS_Data.f_LO2 < MT2063_MIN_DNC_FREQ)
-	    || (state->AS_Data.f_LO2 > MT2063_MAX_DNC_FREQ))
-		status |= MT2063_DNC_RANGE;
-	/*  LO2 Lock bit was in a different place for B0 version  */
-	if (state->tuner_id == MT2063_B0)
-		LO2LK = 0x40;
 
-	/*
-	 *  If we have the same LO frequencies and we're already locked,
-	 *  then skip re-programming the LO registers.
-	 */
-	if ((ofLO1 != state->AS_Data.f_LO1)
-	    || (ofLO2 != state->AS_Data.f_LO2)
-	    || ((state->reg[MT2063_REG_LO_STATUS] & (LO1LK | LO2LK)) !=
-		(LO1LK | LO2LK))) {
-		/*
-		 * Calculate the FIFFOF register value
-		 *
-		 *           IF1_Actual
-		 * FIFFOF = ------------ - 8 * FIFFC - 4992
-		 *            f_ref/64
-		 */
-		fiffof =
-		    (state->AS_Data.f_LO1 -
-		     f_in) / (state->AS_Data.f_ref / 64) - 8 * (u32) fiffc -
-		    4992;
-		if (fiffof > 0xFF)
-			fiffof = 0xFF;
-
-		/*
-		 * Place all of the calculated values into the local tuner
-		 * register fields.
-		 */
-		if (status >= 0) {
-			state->reg[MT2063_REG_LO1CQ_1] = (u8) (LO1 & 0xFF);	/* DIV1q */
-			state->reg[MT2063_REG_LO1CQ_2] = (u8) (Num1 & 0x3F);	/* NUM1q */
-			state->reg[MT2063_REG_LO2CQ_1] = (u8) (((LO2 & 0x7F) << 1)	/* DIV2q */
-								   |(Num2 >> 12));	/* NUM2q (hi) */
-			state->reg[MT2063_REG_LO2CQ_2] = (u8) ((Num2 & 0x0FF0) >> 4);	/* NUM2q (mid) */
-			state->reg[MT2063_REG_LO2CQ_3] = (u8) (0xE0 | (Num2 & 0x000F));	/* NUM2q (lo) */
-
-			/*
-			 * Now write out the computed register values
-			 * IMPORTANT: There is a required order for writing
-			 *            (0x05 must follow all the others).
-			 */
-			status |= mt2063_write(state, MT2063_REG_LO1CQ_1, &state->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
-			if (state->tuner_id == MT2063_B0) {
-				/* Re-write the one-shot bits to trigger the tune operation */
-				status |= mt2063_write(state, MT2063_REG_LO2CQ_3, &state->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
-			}
-			/* Write out the FIFF offset only if it's changing */
-			if (state->reg[MT2063_REG_FIFF_OFFSET] !=
-			    (u8) fiffof) {
-				state->reg[MT2063_REG_FIFF_OFFSET] =
-				    (u8) fiffof;
-				status |=
-				    mt2063_write(state,
-						    MT2063_REG_FIFF_OFFSET,
-						    &state->
-						    reg[MT2063_REG_FIFF_OFFSET],
-						    1);
-			}
-		}
 
-		/*
-		 * Check for LO's locking
-		 */
-
-		if (status < 0)
-			return status;
 
-		status = mt2063_lockStatus(state);
-		if (status < 0)
-			return status;
-		if (!status)
-			return -EINVAL;		/* Couldn't lock */
 
-		/*
-		 * If we locked OK, assign calculated data to mt2063_state structure
-		 */
-		state->f_IF1_actual = state->AS_Data.f_LO1 - f_in;
-	}
 
-	return status;
 }
 
 static int mt2063_init(struct dvb_frontend *fe)
-- 
1.7.7.6

