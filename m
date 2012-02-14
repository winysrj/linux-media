Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:28298 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761253Ab2BNVs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:29 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 21/22] mt2063: change mt2063_init
Date: Tue, 14 Feb 2012 22:47:45 +0100
Message-Id: <1329256066-8844-21-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |  186 ++++++++++++----------------------
 1 files changed, 63 insertions(+), 123 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0c5d472..7dd1d7c 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -384,165 +384,105 @@ err:
 
 static int mt2063_init(struct dvb_frontend *fe)
 {
-	u32 status;
 	struct mt2063_state *state = fe->tuner_priv;
-	u8 all_resets = 0xF0;	/* reset/load bits */
 	const u8 *def = NULL;
-	char *step;
-	u32 FCRUN;
-	s32 maxReads;
-	u32 fcu_osc;
-	u32 i;
-
-	dprintk(2, "\n");
-
-	state->rcvr_mode = MT2063_CABLE_QAM;
-
-	/*  Read the Part/Rev code from the tuner */
-	status = mt2063_read(state, MT2063_REG_PART_REV,
-			     &state->reg[MT2063_REG_PART_REV], 1);
-	if (status < 0) {
-		printk(KERN_ERR "Can't read mt2063 part ID\n");
-		return status;
-	}
+	u8 xo_lock = 1, i;
 
-	/* Check the part/rev code */
-	switch (state->reg[MT2063_REG_PART_REV]) {
-	case MT2063_B0:
-		step = "B0";
-		break;
-	case MT2063_B1:
-		step = "B1";
-		break;
-	case MT2063_B2:
-		step = "B2";
-		break;
-	case MT2063_B3:
-		step = "B3";
-		break;
-	default:
-		printk(KERN_ERR "mt2063: Unknown mt2063 device ID (0x%02x)\n",
-		       state->reg[MT2063_REG_PART_REV]);
-		return -ENODEV;	/*  Wrong tuner Part/Rev code */
-	}
+	dprintk(1, "\n");
 
-	/*  Check the 2nd byte of the Part/Rev code from the tuner */
-	status = mt2063_read(state, MT2063_REG_RSVD_3B,
-			     &state->reg[MT2063_REG_RSVD_3B], 1);
+	mutex_lock(&state->lock);
 
-	/* b7 != 0 ==> NOT MT2063 */
-	if (status < 0 || ((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00)) {
-		printk(KERN_ERR "mt2063: Unknown part ID (0x%02x%02x)\n",
-		       state->reg[MT2063_REG_PART_REV],
-		       state->reg[MT2063_REG_RSVD_3B]);
-		return -ENODEV;	/*  Wrong tuner Part/Rev code */
-	}
+	/* open gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* power on */
+	mt2063_shutdown(state, MT2063_NONE_SD);
 
-	printk(KERN_INFO "mt2063: detected a mt2063 %s\n", step);
+	/* reset */
+	mt2063_write(state, MT2063_REG_LO2CQ_3, 0xf0);
 
-	/*  Reset the tuner  */
-	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
-	if (status < 0)
-		return status;
+	/* debug dump */
+	if (debug >= 3) {
+		/* print all register after reset */
+		u8 reg[64];
+		/* fill all reg */
+		for (i = 0; i < 64; i++) {
+			mt2063_read(state, i, &reg[i]);
+		}
+		print_hex_dump(KERN_DEBUG, "mt2063: ",
+			DUMP_PREFIX_OFFSET, 16, 1, reg, 64, false);
+	}
 
-	/* change all of the default values that vary from the HW reset values */
-	/*  def = (state->reg[PART_REV] == MT2063_B0) ? MT2063B0_defaults : MT2063B1_defaults; */
-	switch (state->reg[MT2063_REG_PART_REV]) {
+	/* load defaults */
+	switch (state->tuner_id) {
 	case MT2063_B3:
 		def = MT2063B3_defaults;
 		break;
-
 	case MT2063_B1:
 		def = MT2063B1_defaults;
 		break;
-
 	case MT2063_B0:
 		def = MT2063B0_defaults;
 		break;
-
 	default:
-		return -ENODEV;
+		def = MT2063B1_defaults;
 		break;
 	}
 
-	while (status >= 0 && *def) {
+	while (*def) {
 		u8 reg = *def++;
 		u8 val = *def++;
-		status = mt2063_write(state, reg, &val, 1);
+		mt2063_write(state, reg, val);
 	}
-	if (status < 0)
-		return status;
 
-	/*  Wait for FIFF location to complete.  */
-	FCRUN = 1;
-	maxReads = 10;
-	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
+	/* wait to lock */
+	while (!xo_lock) {
 		msleep(2);
-		status = mt2063_read(state,
-					 MT2063_REG_XO_STATUS,
-					 &state->
-					 reg[MT2063_REG_XO_STATUS], 1);
-		FCRUN = (state->reg[MT2063_REG_XO_STATUS] & 0x40) >> 6;
+		mt2063_read(state, MT2063_REG_XO_STATUS, &xo_lock);
+		xo_lock = (xo_lock & 0x40) >> 6;
 	}
 
-	if (FCRUN != 0 || status < 0)
-		return -ENODEV;
-
-	status = mt2063_read(state,
-			   MT2063_REG_FIFFC,
-			   &state->reg[MT2063_REG_FIFFC], 1);
-	if (status < 0)
-		return status;
+	/* set RF AGC on */
+	mt2063_set_reg_mask(state, MT2063_REG_PD1_TGT, 0x40, 0x40);
 
-	/* Read back all the registers from the tuner */
-	status = mt2063_read(state,
-				MT2063_REG_PART_REV,
-				state->reg, MT2063_REG_END_REGS);
-	if (status < 0)
-		return status;
+	/* first IF Filter Queue enable and first IF Filter queue */
+	mt2063_set_reg_mask(state, MT2063_REG_FIFF_CTRL2,
+		(1 << 7) | (0 << 4), 0xf0);
+	/* trigger FIFF calibration, needed after changing FIFFQ */
+	mt2063_set_reg_mask(state, MT2063_REG_FIFF_CTRL, 0x01, 0x01);
+	mt2063_set_reg_mask(state, MT2063_REG_FIFF_CTRL, 0x00, 0x01);
 
 	/* set DNC1 GC on */
 	mt2063_set_reg_mask(state, MT2063_REG_DNC_GAIN, 0x00, 0x03);
 	/* set DNC2 GC on */
 	mt2063_set_reg_mask(state, MT2063_REG_VGA_GAIN, 0x00, 0x03);
+	/* set PD2MUX = 0 */
+	mt2063_set_reg_mask(state, MT2063_REG_RSVD_20, 0x00, 0x40);
 
-	/*
-	 **   Fetch the FCU osc value and use it and the fRef value to
-	 **   scale all of the Band Max values
-	 */
+	/* ac LNA max */
+	mt2063_set_reg_mask(state, MT2063_REG_LNA_OV, 0x1f, 0x1f);
+
+	/* ac RF max */
+	mt2063_set_reg_mask(state, MT2063_REG_RF_OV, 0x1f, 0x1f);
 
-	state->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
-	status = mt2063_write(state, MT2063_REG_CTUNE_CTRL,
-			      &state->reg[MT2063_REG_CTUNE_CTRL], 1);
-	if (status < 0)
-		return status;
-
-	/*  Read the ClearTune filter calibration value  */
-	status = mt2063_read(state, MT2063_REG_FIFFC,
-			     &state->reg[MT2063_REG_FIFFC], 1);
-	if (status < 0)
-		return status;
-
-	fcu_osc = state->reg[MT2063_REG_FIFFC];
-
-	state->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
-	status = mt2063_write(state, MT2063_REG_CTUNE_CTRL,
-			      &state->reg[MT2063_REG_CTUNE_CTRL], 1);
-	if (status < 0)
-		return status;
-
-	/*  Adjust each of the values in the ClearTune filter cross-over table  */
-	for (i = 0; i < 31; i++)
-		state->CTFiltMax[i] = (state->CTFiltMax[i] / 768) * (fcu_osc + 640);
-
-	status = MT2063_SoftwareShutdown(state, 1);
-	if (status < 0)
-		return status;
-	status = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
-	if (status < 0)
-		return status;
-
-	state->init = true;
+	/* first IF ATN */
+	if (state->tuner_id == MT2063_B0)
+		mt2063_set_reg_mask(state, MT2063_REG_FIF_OV, 5, 0x1f);
+	else
+		mt2063_set_reg_mask(state, MT2063_REG_FIF_OV, 29, 0x1f);
+
+	/* set ClearTune in auto mode */
+	mt2063_set_reg_mask(state, MT2063_REG_CTUNE_CTRL, 0x00, 0x08);
+
+	/* set Bypass in auto mode */
+	mt2063_set_reg_mask(state, MT2063_REG_BYP_CTRL, 0x00, 0x80);
+
+	/* close gate */
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	mutex_unlock(&state->lock);
 
 	return 0;
 }
-- 
1.7.7.6

