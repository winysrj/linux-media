Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117aF002472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 18/47] [media] mt2063: Rewrite read/write logic at the driver
Date: Wed,  4 Jan 2012 23:00:29 -0200
Message-Id: <1325725258-27934-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  262 ++++++++++------------------------
 1 files changed, 73 insertions(+), 189 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 534e970..0ae6c15 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -1,4 +1,3 @@
-
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -541,15 +540,15 @@ unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 	return err;
 }
 
-/*****************/
-
-//i2c operation
-static int mt2063_writeregs(struct mt2063_state *state, u8 reg1,
-			    u8 *data, int len)
+/*
+ * mt2063_write - Write data into the I2C bus
+ */
+static u32 mt2063_write(struct mt2063_state *state,
+			   u8 reg, u8 *data, u32 len)
 {
+	struct dvb_frontend *fe = state->frontend;
 	int ret;
-	u8 buf[60];		/* = { reg1, data }; */
-
+	u8 buf[60];
 	struct i2c_msg msg = {
 		.addr = state->config->tuner_address,
 		.flags = 0,
@@ -557,11 +556,12 @@ static int mt2063_writeregs(struct mt2063_state *state, u8 reg1,
 		.len = len + 1
 	};
 
-	msg.buf[0] = reg1;
+	msg.buf[0] = reg;
 	memcpy(msg.buf + 1, data, len);
 
-	//printk("mt2063_writeregs state->i2c=%p\n", state->i2c);
+	fe->ops.i2c_gate_ctrl(fe, 1);
 	ret = i2c_transfer(state->i2c, &msg, 1);
+	fe->ops.i2c_gate_ctrl(fe, 0);
 
 	if (ret < 0)
 		printk("mt2063_writeregs error ret=%d\n", ret);
@@ -569,156 +569,40 @@ static int mt2063_writeregs(struct mt2063_state *state, u8 reg1,
 	return ret;
 }
 
-static int mt2063_read_regs(struct mt2063_state *state, u8 reg1, u8 * b, u8 len)
-{
-	int ret;
-	u8 b0[] = { reg1 };
-	struct i2c_msg msg[] = {
-		{
-		 .addr = state->config->tuner_address,
-		 .flags = I2C_M_RD,
-		 .buf = b0,
-		 .len = 1}, {
-			     .addr = state->config->tuner_address,
-			     .flags = I2C_M_RD,
-			     .buf = b,
-			     .len = len}
-	};
-
-	//printk("mt2063_read_regs state->i2c=%p\n", state->i2c);
-	ret = i2c_transfer(state->i2c, msg, 2);
-	if (ret < 0)
-		printk("mt2063_readregs error ret=%d\n", ret);
-
-	return ret;
-}
-
-//context of mt2063_userdef.c   <Henry> ======================================
-//#################################################################
-//=================================================================
-/*****************************************************************************
-**
-**  Name: MT_WriteSub
-**
-**  Description:    Write values to device using a two-wire serial bus.
-**
-**  Parameters:     hUserData  - User-specific I/O parameter that was
-**                               passed to tuner's Open function.
-**                  addr       - device serial bus address  (value passed
-**                               as parameter to MTxxxx_Open)
-**                  subAddress - serial bus sub-address (Register Address)
-**                  pData      - pointer to the Data to be written to the
-**                               device
-**                  cnt        - number of bytes/registers to be written
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      user-defined
-**
-**  Notes:          This is a callback function that is called from the
-**                  the tuning algorithm.  You MUST provide code for this
-**                  function to write data using the tuner's 2-wire serial
-**                  bus.
-**
-**                  The hUserData parameter is a user-specific argument.
-**                  If additional arguments are needed for the user's
-**                  serial bus read/write functions, this argument can be
-**                  used to supply the necessary information.
-**                  The hUserData parameter is initialized in the tuner's Open
-**                  function.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   03-25-2004    DAD    Original
-**
-*****************************************************************************/
-static u32 MT2063_WriteSub(struct mt2063_state *state,
-			   u8 subAddress, u8 *pData, u32 cnt)
-{
-	u32 status = 0;	/* Status to be returned        */
-	struct dvb_frontend *fe = state->frontend;
-
-	/*
-	 **  ToDo:  Add code here to implement a serial-bus write
-	 **         operation to the MTxxxx tuner.  If successful,
-	 **         return MT_OK.
-	 */
-
-	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
-
-	if (mt2063_writeregs(state, subAddress, pData, cnt) < 0) {
-		status = -EINVAL;
-	}
-	fe->ops.i2c_gate_ctrl(fe, 0);	//I2C bypass drxk3926 close i2c bridge
-
-	return (status);
-}
-
-/*****************************************************************************
-**
-**  Name: MT_ReadSub
-**
-**  Description:    Read values from device using a two-wire serial bus.
-**
-**  Parameters:     hUserData  - User-specific I/O parameter that was
-**                               passed to tuner's Open function.
-**                  addr       - device serial bus address  (value passed
-**                               as parameter to MTxxxx_Open)
-**                  subAddress - serial bus sub-address (Register Address)
-**                  pData      - pointer to the Data to be written to the
-**                               device
-**                  cnt        - number of bytes/registers to be written
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      user-defined
-**
-**  Notes:          This is a callback function that is called from the
-**                  the tuning algorithm.  You MUST provide code for this
-**                  function to read data using the tuner's 2-wire serial
-**                  bus.
-**
-**                  The hUserData parameter is a user-specific argument.
-**                  If additional arguments are needed for the user's
-**                  serial bus read/write functions, this argument can be
-**                  used to supply the necessary information.
-**                  The hUserData parameter is initialized in the tuner's Open
-**                  function.
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   N/A   03-25-2004    DAD    Original
-**
-*****************************************************************************/
-static u32 MT2063_ReadSub(struct mt2063_state *state,
+/*
+ * mt2063_read - Read data from the I2C bus
+ */
+static u32 mt2063_read(struct mt2063_state *state,
 			   u8 subAddress, u8 *pData, u32 cnt)
 {
 	u32 status = 0;	/* Status to be returned        */
 	struct dvb_frontend *fe = state->frontend;
 	u32 i = 0;
 
-	/*
-	 **  ToDo:  Add code here to implement a serial-bus read
-	 **         operation to the MTxxxx tuner.  If successful,
-	 **         return MT_OK.
-	 */
-	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
+	fe->ops.i2c_gate_ctrl(fe, 1);
 
 	for (i = 0; i < cnt; i++) {
-		if (mt2063_read_regs(state, subAddress + i, pData + i, 1) < 0) {
-			status = -EINVAL;
+		int ret;
+		u8 b0[] = { subAddress + i };
+		struct i2c_msg msg[] = {
+			{
+				.addr = state->config->tuner_address,
+				.flags = I2C_M_RD,
+				.buf = b0,
+				.len = 1
+			}, {
+				.addr = state->config->tuner_address,
+				.flags = I2C_M_RD,
+				.buf = pData + 1,
+				.len = 1
+			}
+		};
+
+		ret = i2c_transfer(state->i2c, msg, 2);
+		if (ret < 0)
 			break;
-		}
 	}
-
-	fe->ops.i2c_gate_ctrl(fe, 0);	//I2C bypass drxk3926 close i2c bridge
-
+	fe->ops.i2c_gate_ctrl(fe, 0);
 	return (status);
 }
 
@@ -1670,7 +1554,7 @@ static u32 MT2063_GetLocked(struct mt2063_state *state)
 
 	do {
 		status |=
-		    MT2063_ReadSub(state,
+		    mt2063_read(state,
 				   MT2063_REG_LO_STATUS,
 				   &state->reg[MT2063_REG_LO_STATUS], 1);
 
@@ -1830,7 +1714,7 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		{
 			/* read the actual tuner register values for LO1C_1 and LO1C_2 */
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_LO1C_1,
 					   &state->
 					   reg[MT2063_REG_LO1C_1], 2);
@@ -1884,7 +1768,7 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		{
 			/* Read the actual tuner register values for LO2C_1, LO2C_2 and LO2C_3 */
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_LO2C_1,
 					   &state->
 					   reg[MT2063_REG_LO2C_1], 3);
@@ -1983,7 +1867,7 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		/* Initiate ADC output to reg 0x0A */
 		if (reg != orig)
 			status |=
-			    MT2063_WriteSub(state,
+			    mt2063_write(state,
 					    MT2063_REG_BYP_CTRL,
 					    &reg, 1);
 
@@ -1992,7 +1876,7 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 
 		for (i = 0; i < 8; i++) {
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_ADC_OUT,
 					   &state->
 					   reg
@@ -2015,7 +1899,7 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 		/* Restore value of Register BYP_CTRL */
 		if (reg != orig)
 			status |=
-			    MT2063_WriteSub(state,
+			    mt2063_write(state,
 					    MT2063_REG_BYP_CTRL,
 						&orig, 1);
 		}
@@ -2185,7 +2069,7 @@ static u32 MT2063_GetReg(struct mt2063_state *state, u8 reg, u8 * val)
 	if (reg >= MT2063_REG_END_REGS)
 		return -ERANGE;
 
-	status = MT2063_ReadSub(state, reg, &state->reg[reg], 1);
+	status = mt2063_read(state, reg, &state->reg[reg], 1);
 
 	return (status);
 }
@@ -2490,7 +2374,7 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 	};
 
 	/*  Read the Part/Rev code from the tuner */
-	status = MT2063_ReadSub(state, MT2063_REG_PART_REV, state->reg, 1);
+	status = mt2063_read(state, MT2063_REG_PART_REV, state->reg, 1);
 	if (status < 0)
 		return status;
 
@@ -2501,7 +2385,7 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Check the 2nd byte of the Part/Rev code from the tuner */
-	status = MT2063_ReadSub(state,
+	status = mt2063_read(state,
 			        MT2063_REG_RSVD_3B,
 			        &state->reg[MT2063_REG_RSVD_3B], 1);
 
@@ -2510,7 +2394,7 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Reset the tuner  */
-	status = MT2063_WriteSub(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
+	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
 	if (status < 0)
 		return status;
 
@@ -2537,7 +2421,7 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 	while (status >= 0 && *def) {
 		u8 reg = *def++;
 		u8 val = *def++;
-		status = MT2063_WriteSub(state, reg, &val, 1);
+		status = mt2063_write(state, reg, &val, 1);
 	}
 	if (status < 0)
 		return status;
@@ -2547,7 +2431,7 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 	maxReads = 10;
 	while (status >= 0 && (FCRUN != 0) && (maxReads-- > 0)) {
 		msleep(2);
-		status = MT2063_ReadSub(state,
+		status = mt2063_read(state,
 					 MT2063_REG_XO_STATUS,
 					 &state->
 					 reg[MT2063_REG_XO_STATUS], 1);
@@ -2557,14 +2441,14 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 	if (FCRUN != 0)
 		return -ENODEV;
 
-	status = MT2063_ReadSub(state,
+	status = mt2063_read(state,
 			   MT2063_REG_FIFFC,
 			   &state->reg[MT2063_REG_FIFFC], 1);
 	if (status < 0)
 		return status;
 
 	/* Read back all the registers from the tuner */
-	status = MT2063_ReadSub(state,
+	status = mt2063_read(state,
 				MT2063_REG_PART_REV,
 				state->reg, MT2063_REG_END_REGS);
 	if (status < 0)
@@ -2633,13 +2517,13 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 	 */
 
 	state->reg[MT2063_REG_CTUNE_CTRL] = 0x0A;
-	status = MT2063_WriteSub(state,
+	status = mt2063_write(state,
 				 MT2063_REG_CTUNE_CTRL,
 				 &state->reg[MT2063_REG_CTUNE_CTRL], 1);
 	if (status < 0)
 		return status;
 	/*  Read the ClearTune filter calibration value  */
-	status = MT2063_ReadSub(state,
+	status = mt2063_read(state,
 			        MT2063_REG_FIFFC,
 			        &state->reg[MT2063_REG_FIFFC], 1);
 	if (status < 0)
@@ -2648,7 +2532,7 @@ static u32 MT2063_ReInit(struct mt2063_state *state)
 	fcu_osc = state->reg[MT2063_REG_FIFFC];
 
 	state->reg[MT2063_REG_CTUNE_CTRL] = 0x00;
-	status = MT2063_WriteSub(state,
+	status = mt2063_write(state,
 				 MT2063_REG_CTUNE_CTRL,
 				 &state->reg[MT2063_REG_CTUNE_CTRL], 1);
 	if (status < 0)
@@ -2781,11 +2665,11 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 
 			/* Buffer the queue for restoration later and get actual LO2 values. */
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_LO2CQ_1,
 					   &(tempLO2CQ[0]), 3);
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_LO2C_1,
 					   &(tempLO2C[0]), 3);
 
@@ -2799,7 +2683,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			    (tempLO2CQ[2] != tempLO2C[2])) {
 				/* put actual LO2 value into queue (with 0 in one-shot bits) */
 				status |=
-				    MT2063_WriteSub(state,
+				    mt2063_write(state,
 						    MT2063_REG_LO2CQ_1,
 						    &(tempLO2C[0]), 3);
 
@@ -2826,7 +2710,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			state->reg[MT2063_REG_LO1CQ_2] =
 			    (u8) (FracN);
 			status |=
-			    MT2063_WriteSub(state,
+			    mt2063_write(state,
 					    MT2063_REG_LO1CQ_1,
 					    &state->
 					    reg[MT2063_REG_LO1CQ_1], 2);
@@ -2834,7 +2718,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			/* set the one-shot bit to load the pair of LO values */
 			tmpOneShot = tempLO2CQ[2] | 0xE0;
 			status |=
-			    MT2063_WriteSub(state,
+			    mt2063_write(state,
 					    MT2063_REG_LO2CQ_3,
 					    &tmpOneShot, 1);
 
@@ -2842,7 +2726,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			if (restore) {
 				/* put actual LO2 value into queue (0 in one-shot bits) */
 				status |=
-				    MT2063_WriteSub(state,
+				    mt2063_write(state,
 						    MT2063_REG_LO2CQ_1,
 						    &(tempLO2CQ[0]), 3);
 
@@ -2895,11 +2779,11 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 
 			/* Buffer the queue for restoration later and get actual LO2 values. */
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_LO1CQ_1,
 					   &(tempLO1CQ[0]), 2);
 			status |=
-			    MT2063_ReadSub(state,
+			    mt2063_read(state,
 					   MT2063_REG_LO1C_1,
 					   &(tempLO1C[0]), 2);
 
@@ -2908,7 +2792,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			    || (tempLO1CQ[1] != tempLO1C[1])) {
 				/* put actual LO1 value into queue */
 				status |=
-				    MT2063_WriteSub(state,
+				    mt2063_write(state,
 						    MT2063_REG_LO1CQ_1,
 						    &(tempLO1C[0]), 2);
 
@@ -2934,7 +2818,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			state->reg[MT2063_REG_LO2CQ_3] =
 			    (u8) ((FracN2 & 0x0F));
 			status |=
-			    MT2063_WriteSub(state,
+			    mt2063_write(state,
 					    MT2063_REG_LO1CQ_1,
 					    &state->
 					    reg[MT2063_REG_LO1CQ_1], 3);
@@ -2943,7 +2827,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			tmpOneShot =
 			    state->reg[MT2063_REG_LO2CQ_3] | 0xE0;
 			status |=
-			    MT2063_WriteSub(state,
+			    mt2063_write(state,
 					    MT2063_REG_LO2CQ_3,
 					    &tmpOneShot, 1);
 
@@ -2951,7 +2835,7 @@ static u32 MT2063_SetParam(struct mt2063_state *state,
 			if (restore) {
 				/* put previous LO1 queue value back into queue */
 				status |=
-				    MT2063_WriteSub(state,
+				    mt2063_write(state,
 						    MT2063_REG_LO1CQ_1,
 						    &(tempLO1CQ[0]), 2);
 
@@ -3355,14 +3239,14 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mas
 	if ((Bits & 0xFF00) != 0) {
 		state->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
 		status |=
-		    MT2063_WriteSub(state,
+		    mt2063_write(state,
 				    MT2063_REG_PWR_2,
 				    &state->reg[MT2063_REG_PWR_2], 1);
 	}
 	if ((Bits & 0xFF) != 0) {
 		state->reg[MT2063_REG_PWR_1] &= ~(u8) (Bits & 0xFF);
 		status |=
-		    MT2063_WriteSub(state,
+		    mt2063_write(state,
 				    MT2063_REG_PWR_1,
 				    &state->reg[MT2063_REG_PWR_1], 1);
 	}
@@ -3408,7 +3292,7 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 		state->reg[MT2063_REG_PWR_1] &= ~0x04;	/* Turn off the bit */
 
 	status |=
-	    MT2063_WriteSub(state,
+	    mt2063_write(state,
 			    MT2063_REG_PWR_1,
 			    &state->reg[MT2063_REG_PWR_1], 1);
 
@@ -3416,14 +3300,14 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 		state->reg[MT2063_REG_BYP_CTRL] =
 		    (state->reg[MT2063_REG_BYP_CTRL] & 0x9F) | 0x40;
 		status |=
-		    MT2063_WriteSub(state,
+		    mt2063_write(state,
 				    MT2063_REG_BYP_CTRL,
 				    &state->reg[MT2063_REG_BYP_CTRL],
 				    1);
 		state->reg[MT2063_REG_BYP_CTRL] =
 		    (state->reg[MT2063_REG_BYP_CTRL] & 0x9F);
 		status |=
-		    MT2063_WriteSub(state,
+		    mt2063_write(state,
 				    MT2063_REG_BYP_CTRL,
 				    &state->reg[MT2063_REG_BYP_CTRL],
 				    1);
@@ -3467,7 +3351,7 @@ static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val)
 	if (reg >= MT2063_REG_END_REGS)
 		status |= -ERANGE;
 
-	status = MT2063_WriteSub(state, reg, &val,
+	status = mt2063_write(state, reg, &val,
 			         1);
 	if (status >= 0)
 		state->reg[reg] = val;
@@ -3749,7 +3633,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	 */
 	if (status >= 0) {
 		status |=
-		    MT2063_ReadSub(state,
+		    mt2063_read(state,
 				   MT2063_REG_FIFFC,
 				   &state->reg[MT2063_REG_FIFFC], 1);
 		fiffc = state->reg[MT2063_REG_FIFFC];
@@ -3852,10 +3736,10 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			 ** IMPORTANT: There is a required order for writing
 			 **            (0x05 must follow all the others).
 			 */
-			status |= MT2063_WriteSub(state, MT2063_REG_LO1CQ_1, &state->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
+			status |= mt2063_write(state, MT2063_REG_LO1CQ_1, &state->reg[MT2063_REG_LO1CQ_1], 5);	/* 0x01 - 0x05 */
 			if (state->tuner_id == MT2063_B0) {
 				/* Re-write the one-shot bits to trigger the tune operation */
-				status |= MT2063_WriteSub(state, MT2063_REG_LO2CQ_3, &state->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
+				status |= mt2063_write(state, MT2063_REG_LO2CQ_3, &state->reg[MT2063_REG_LO2CQ_3], 1);	/* 0x05 */
 			}
 			/* Write out the FIFF offset only if it's changing */
 			if (state->reg[MT2063_REG_FIFF_OFFSET] !=
@@ -3863,7 +3747,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 				state->reg[MT2063_REG_FIFF_OFFSET] =
 				    (u8) fiffof;
 				status |=
-				    MT2063_WriteSub(state,
+				    mt2063_write(state,
 						    MT2063_REG_FIFF_OFFSET,
 						    &state->
 						    reg[MT2063_REG_FIFF_OFFSET],
-- 
1.7.7.5

