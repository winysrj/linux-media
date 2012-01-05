Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab2AEBBJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:09 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05119kv016374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 30/47] [media] mt2063: make checkpatch.pl happy
Date: Wed,  4 Jan 2012 23:00:41 -0200
Message-Id: <1325725258-27934-31-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix everything but 80 columns and two msleep warnings

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  129 +++++++++++++---------------------
 1 files changed, 48 insertions(+), 81 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index d13b78b..5154b9d 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -263,7 +263,7 @@ static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 	fe->ops.i2c_gate_ctrl(fe, 0);
 
 	if (ret < 0)
-		printk("mt2063_writeregs error ret=%d\n", ret);
+		printk(KERN_ERR "%s error ret=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -287,7 +287,6 @@ static u32 mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
 	return 0;
 }
 
-
 /*
  * mt2063_read - Read data from the I2C bus
  */
@@ -322,7 +321,7 @@ static u32 mt2063_read(struct mt2063_state *state,
 			break;
 	}
 	fe->ops.i2c_gate_ctrl(fe, 0);
-	return (status);
+	return status;
 }
 
 /*
@@ -600,10 +599,6 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 		    ((f_Desired - pAS_Info->f_if1_Center +
 		      f_Step / 2) / f_Step);
 
-	//assert;
-	//if (!abs((s32) f_Center - (s32) pAS_Info->f_if1_Center) <= (s32) (f_Step/2))
-	//          return 0;
-
 	/*  Take MT_ExclZones, center around f_Center and change the resolution to f_Step  */
 	while (pNode != NULL) {
 		/*  floor function  */
@@ -625,10 +620,6 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 			zones[j - 1].max_ = tmpMax;
 		else {
 			/*  Add new zone  */
-			//assert(j<MT2063_MAX_ZONES);
-			//if (j>=MT2063_MAX_ZONES)
-			//break;
-
 			zones[j].min_ = tmpMin;
 			zones[j].max_ = tmpMax;
 			j++;
@@ -903,15 +894,13 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 				delta_IF1 = zfIF1 - pAS_Info->f_if1_Center;
 			else
 				delta_IF1 = pAS_Info->f_if1_Center - zfIF1;
-		}
+
+			pAS_Info->bSpurPresent = IsSpurInBand(pAS_Info, &fm, &fp);
 		/*
 		 **  Continue while the new 1st IF is still within the 1st IF bandwidth
 		 **  and there is a spur in the band (again)
 		 */
-		while ((2 * delta_IF1 + pAS_Info->f_out_bw <=
-			pAS_Info->f_if1_bw)
-		       && (pAS_Info->bSpurPresent =
-			   IsSpurInBand(pAS_Info, &fm, &fp)));
+		} while ((2 * delta_IF1 + pAS_Info->f_out_bw <= pAS_Info->f_if1_bw) && pAS_Info->bSpurPresent);
 
 		/*
 		 ** Use the LO-spur free values found.  If the search went all the way to
@@ -930,19 +919,9 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 	    ((pAS_Info->
 	      nSpursFound << MT2063_SPUR_SHIFT) & MT2063_SPUR_CNT_MASK);
 
-	return (status);
+	return status;
 }
 
-/*
-**  The expected version of MT_AvoidSpursData_t
-**  If the version is different, an updated file is needed from Microtune
-*/
-
-typedef enum {
-	MT2063_SET_ATTEN,
-	MT2063_INCR_ATTEN,
-	MT2063_DECR_ATTEN
-} MT2063_ATTEN_CNTL_MODE;
 
 /*
  * Constants used by the tuning algorithm
@@ -1044,8 +1023,7 @@ unsigned int mt2063_lockStatus(struct mt2063_state *state)
 			return TUNER_STATUS_LOCKED | TUNER_STATUS_STEREO;
 		}
 		msleep(nPollRate);	/*  Wait between retries  */
-	}
-	while (++nDelays < nMaxLoops);
+	} while (++nDelays < nMaxLoops);
 
 	/*
 	 * Got no lock or partial lock
@@ -1058,7 +1036,7 @@ EXPORT_SYMBOL_GPL(mt2063_lockStatus);
  * mt2063_set_dnc_output_enable()
  */
 static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
-				        enum MT2063_DNC_Output_Enable *pValue)
+					enum MT2063_DNC_Output_Enable *pValue)
 {
 	if ((state->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
 		if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
@@ -1078,7 +1056,7 @@ static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
  * mt2063_set_dnc_output_enable()
  */
 static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
-				        enum MT2063_DNC_Output_Enable nValue)
+					enum MT2063_DNC_Output_Enable nValue)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u8 val = 0;
@@ -1201,7 +1179,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 		break;
 	}
 
-	return (status);
+	return status;
 }
 
 /******************************************************************************
@@ -1301,28 +1279,26 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	if (status >= 0) {
 		val =
 		    (state->
-		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x40) | (RFAGCEN[Mode]
+		     reg[MT2063_REG_PD1_TGT] & (u8) ~0x40) | (RFAGCEN[Mode]
 								   ? 0x40 :
 								   0x00);
-		if (state->reg[MT2063_REG_PD1_TGT] != val) {
+		if (state->reg[MT2063_REG_PD1_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
-		}
 	}
 
 	/* LNARin */
 	if (status >= 0) {
-		u8 val = (state-> reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
+		u8 val = (state->reg[MT2063_REG_CTRL_2C] & (u8) ~0x03) |
 			 (LNARIN[Mode] & 0x03);
 		if (state->reg[MT2063_REG_CTRL_2C] != val)
-			status |= mt2063_setreg(state, MT2063_REG_CTRL_2C,
-					  val);
+			status |= mt2063_setreg(state, MT2063_REG_CTRL_2C, val);
 	}
 
 	/* FIFFQEN and FIFFQ */
 	if (status >= 0) {
 		val =
 		    (state->
-		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~ 0xF0) |
+		     reg[MT2063_REG_FIFF_CTRL2] & (u8) ~0xF0) |
 		    (FIFFQEN[Mode] << 7) | (FIFFQ[Mode] << 4);
 		if (state->reg[MT2063_REG_FIFF_CTRL2] != val) {
 			status |=
@@ -1334,7 +1310,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
 			val =
 			    (state->
-			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~ 0x01);
+			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~0x01);
 			status |=
 			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
 		}
@@ -1346,7 +1322,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* acLNAmax */
 	if (status >= 0) {
-		u8 val = (state-> reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) |
+		u8 val = (state->reg[MT2063_REG_LNA_OV] & (u8) ~0x1F) |
 			 (ACLNAMAX[Mode] & 0x1F);
 		if (state->reg[MT2063_REG_LNA_OV] != val)
 			status |= mt2063_setreg(state, MT2063_REG_LNA_OV, val);
@@ -1354,7 +1330,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* LNATGT */
 	if (status >= 0) {
-		u8 val = (state-> reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
+		u8 val = (state->reg[MT2063_REG_LNA_TGT] & (u8) ~0x3F) |
 			 (LNATGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_LNA_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
@@ -1362,15 +1338,15 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* ACRF */
 	if (status >= 0) {
-		u8 val = (state-> reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) |
-		         (ACRFMAX[Mode] & 0x1F);
+		u8 val = (state->reg[MT2063_REG_RF_OV] & (u8) ~0x1F) |
+			 (ACRFMAX[Mode] & 0x1F);
 		if (state->reg[MT2063_REG_RF_OV] != val)
 			status |= mt2063_setreg(state, MT2063_REG_RF_OV, val);
 	}
 
 	/* PD1TGT */
 	if (status >= 0) {
-		u8 val = (state-> reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
+		u8 val = (state->reg[MT2063_REG_PD1_TGT] & (u8) ~0x3F) |
 			 (PD1TGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_PD1_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
@@ -1381,16 +1357,15 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = ACFIFMAX[Mode];
 		if (state->reg[MT2063_REG_PART_REV] != MT2063_B3 && val > 5)
 			val = 5;
-		val = (state-> reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) |
+		val = (state->reg[MT2063_REG_FIF_OV] & (u8) ~0x1F) |
 		      (val & 0x1F);
-		if (state->reg[MT2063_REG_FIF_OV] != val) {
+		if (state->reg[MT2063_REG_FIF_OV] != val)
 			status |= mt2063_setreg(state, MT2063_REG_FIF_OV, val);
-		}
 	}
 
 	/* PD2TGT */
 	if (status >= 0) {
-		u8 val = (state-> reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
+		u8 val = (state->reg[MT2063_REG_PD2_TGT] & (u8) ~0x3F) |
 		    (PD2TGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_PD2_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD2_TGT, val);
@@ -1398,31 +1373,24 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 
 	/* Ignore ATN Overload */
 	if (status >= 0) {
-		val =
-		    (state->
-		     reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x80) | (RFOVDIS[Mode]
-								   ? 0x80 :
-								   0x00);
-		if (state->reg[MT2063_REG_LNA_TGT] != val) {
+		val = (state->reg[MT2063_REG_LNA_TGT] & (u8) ~0x80) |
+		      (RFOVDIS[Mode] ? 0x80 : 0x00);
+		if (state->reg[MT2063_REG_LNA_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
-		}
 	}
 
 	/* Ignore FIF Overload */
 	if (status >= 0) {
-		val =
-		    (state->
-		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x80) |
-		    (FIFOVDIS[Mode] ? 0x80 : 0x00);
-		if (state->reg[MT2063_REG_PD1_TGT] != val) {
+		val = (state->reg[MT2063_REG_PD1_TGT] & (u8) ~0x80) |
+		      (FIFOVDIS[Mode] ? 0x80 : 0x00);
+		if (state->reg[MT2063_REG_PD1_TGT] != val)
 			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
-		}
 	}
 
 	if (status >= 0)
 		state->rcvr_mode = Mode;
 
-	return (status);
+	return status;
 }
 
 /****************************************************************************
@@ -1473,7 +1441,7 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
 				    &state->reg[MT2063_REG_PWR_1], 1);
 	}
 
-	return (status);
+	return status;
 }
 
 /****************************************************************************
@@ -1580,7 +1548,7 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num, u32 denom)
 	u32 loss = t1 % denom;
 	u32 term2 =
 	    (((f_ref & 0x00003FFF) * num + (loss << 14)) + (denom / 2)) / denom;
-	return ((term1 << 14) + term2);
+	return (term1 << 14) + term2;
 }
 
 /****************************************************************************
@@ -1610,8 +1578,8 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num, u32 denom)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_CalcLO1Mult(u32 * Div,
-			      u32 * FracN,
+static u32 MT2063_CalcLO1Mult(u32 *Div,
+			      u32 *FracN,
 			      u32 f_LO,
 			      u32 f_LO_Step, u32 f_Ref)
 {
@@ -1653,8 +1621,8 @@ static u32 MT2063_CalcLO1Mult(u32 * Div,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_CalcLO2Mult(u32 * Div,
-			      u32 * FracN,
+static u32 MT2063_CalcLO2Mult(u32 *Div,
+			      u32 *FracN,
 			      u32 f_LO,
 			      u32 f_LO_Step, u32 f_Ref)
 {
@@ -2039,7 +2007,6 @@ int mt2063_setTune(struct dvb_frontend *fe, u32 f_in, u32 bw_in,
 			pict2snd1 = 0;
 			pict2snd2 = 0;
 			rcvr_mode = 4;
-			//f_in -= 2900000;
 			break;
 		}
 	case MTTUNEA_DVBC:{
@@ -2053,7 +2020,7 @@ int mt2063_setTune(struct dvb_frontend *fe, u32 f_in, u32 bw_in,
 		}
 	case MTTUNEA_DVBT:{
 			pict_car = 36125000;
-			ch_bw = bw_in;	//8000000
+			ch_bw = bw_in;
 			pict2chanb_vsb = -(ch_bw / 2);
 			pict2snd1 = 0;
 			pict2snd2 = 0;
@@ -2074,7 +2041,7 @@ int mt2063_setTune(struct dvb_frontend *fe, u32 f_in, u32 bw_in,
 	state->AS_Data.f_out_bw = ch_bw + 750000;
 	status = MT2063_SetReceiverMode(state, rcvr_mode);
 	if (status < 0)
-	    return status;
+		return status;
 
 	status = MT2063_Tune(state, (f_in + (pict2chanb_vsb + (ch_bw / 2))));
 
@@ -2164,8 +2131,8 @@ static int mt2063_init(struct dvb_frontend *fe)
 
 	/* Check the part/rev code */
 	if (((state->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
-	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
-	    &&(state->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
+	    && (state->reg[MT2063_REG_PART_REV] != MT2063_B1)	/*  MT2063 B1  */
+	    && (state->reg[MT2063_REG_PART_REV] != MT2063_B3)))	/*  MT2063 B3  */
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Check the 2nd byte of the Part/Rev code from the tuner */
@@ -2173,7 +2140,7 @@ static int mt2063_init(struct dvb_frontend *fe)
 			     &state->reg[MT2063_REG_RSVD_3B], 1);
 
 	/* b7 != 0 ==> NOT MT2063 */
-	if (status < 0 ||((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))
+	if (status < 0 || ((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
 
 	/*  Reset the tuner  */
@@ -2321,7 +2288,7 @@ static int mt2063_init(struct dvb_frontend *fe)
 
 	/*  Adjust each of the values in the ClearTune filter cross-over table  */
 	for (i = 0; i < 31; i++)
-		state->CTFiltMax[i] =(state->CTFiltMax[i] / 768) * (fcu_osc + 640);
+		state->CTFiltMax[i] = (state->CTFiltMax[i] / 768) * (fcu_osc + 640);
 
 	status = MT2063_SoftwareShutdown(state, 1);
 	if (status < 0)
@@ -2349,14 +2316,14 @@ static int mt2063_get_state(struct dvb_frontend *fe,
 
 	switch (param) {
 	case DVBFE_TUNER_FREQUENCY:
-		//get frequency
+		/* get frequency */
 		break;
 	case DVBFE_TUNER_TUNERSTEP:
 		break;
 	case DVBFE_TUNER_IFFREQ:
 		break;
 	case DVBFE_TUNER_BANDWIDTH:
-		//get bandwidth
+		/* get bandwidth */
 		break;
 	case DVBFE_TUNER_REFCLOCK:
 		tunstate->refclock = mt2063_lockStatus(state);
@@ -2376,7 +2343,7 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 
 	switch (param) {
 	case DVBFE_TUNER_FREQUENCY:
-		//set frequency
+		/* set frequency */
 
 		status =
 		    mt2063_setTune(fe,
@@ -2390,7 +2357,7 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 	case DVBFE_TUNER_IFFREQ:
 		break;
 	case DVBFE_TUNER_BANDWIDTH:
-		//set bandwidth
+		/* set bandwidth */
 		state->bandwidth = tunstate->bandwidth;
 		break;
 	case DVBFE_TUNER_REFCLOCK:
@@ -2446,7 +2413,7 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	fe->tuner_priv = state;
 	fe->ops.tuner_ops = mt2063_ops;
 
-	printk("%s: Attaching MT2063 \n", __func__);
+	printk(KERN_INFO "%s: Attaching MT2063\n", __func__);
 	return fe;
 
 error:
-- 
1.7.7.5

