Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511AM0029470
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:10 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 28/47] [media] mt2063: Reorder the code to avoid function prototypes
Date: Wed,  4 Jan 2012 23:00:39 -0200
Message-Id: <1325725258-27934-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  331 +++++++++++++++-------------------
 1 files changed, 150 insertions(+), 181 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index f9ebe24..0f4bf96 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -240,48 +240,10 @@ struct mt2063_state {
 	u8 reg[MT2063_REG_END_REGS];
 };
 
-/* Prototypes */
-static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
-                        u32 f_min, u32 f_max);
-static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val);
-static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown);
-static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mask_Bits Bits);
-
-
-/*
- * Ancillary routines visible outside mt2063
- */
-unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-	int err = 0;
-
-	err = MT2063_SoftwareShutdown(state, 1);
-	if (err < 0)
-		printk(KERN_ERR "%s: Couldn't shutdown\n", __func__);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(tuner_MT2063_SoftwareShutdown);
-
-unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-	int err = 0;
-
-	err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
-	if (err < 0)
-		printk(KERN_ERR "%s: Invalid parameter\n", __func__);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
-
 /*
  * mt2063_write - Write data into the I2C bus
  */
-static u32 mt2063_write(struct mt2063_state *state,
-			   u8 reg, u8 *data, u32 len)
+static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 {
 	struct dvb_frontend *fe = state->frontend;
 	int ret;
@@ -307,6 +269,26 @@ static u32 mt2063_write(struct mt2063_state *state,
 }
 
 /*
+ * mt2063_write - Write register data into the I2C bus, caching the value
+ */
+static u32 mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
+{
+	u32 status;
+
+	if (reg >= MT2063_REG_END_REGS)
+		return -ERANGE;
+
+	status = mt2063_write(state, reg, &val, 1);
+	if (status < 0)
+		return status;
+
+	state->reg[reg] = val;
+
+	return 0;
+}
+
+
+/*
  * mt2063_read - Read data from the I2C bus
  */
 static u32 mt2063_read(struct mt2063_state *state,
@@ -370,76 +352,6 @@ struct MT2063_FIFZone_t {
 	s32 max_;
 };
 
-/*
-**  Reset all exclusion zones.
-**  Add zones to protect the PLL FracN regions near zero
-**
-**   N/A I 06-17-2008    RSK    Ver 1.19: Refactoring avoidance of DECT
-**                              frequencies into MT_ResetExclZones().
-*/
-static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
-{
-	u32 center;
-
-	pAS_Info->nZones = 0;	/*  this clears the used list  */
-	pAS_Info->usedZones = NULL;	/*  reset ptr                  */
-	pAS_Info->freeZones = NULL;	/*  reset ptr                  */
-
-	center =
-	    pAS_Info->f_ref *
-	    ((pAS_Info->f_if1_Center - pAS_Info->f_if1_bw / 2 +
-	      pAS_Info->f_in) / pAS_Info->f_ref) - pAS_Info->f_in;
-	while (center <
-	       pAS_Info->f_if1_Center + pAS_Info->f_if1_bw / 2 +
-	       pAS_Info->f_LO1_FracN_Avoid) {
-		/*  Exclude LO1 FracN  */
-		MT2063_AddExclZone(pAS_Info,
-				   center - pAS_Info->f_LO1_FracN_Avoid,
-				   center - 1);
-		MT2063_AddExclZone(pAS_Info, center + 1,
-				   center + pAS_Info->f_LO1_FracN_Avoid);
-		center += pAS_Info->f_ref;
-	}
-
-	center =
-	    pAS_Info->f_ref *
-	    ((pAS_Info->f_if1_Center - pAS_Info->f_if1_bw / 2 -
-	      pAS_Info->f_out) / pAS_Info->f_ref) + pAS_Info->f_out;
-	while (center <
-	       pAS_Info->f_if1_Center + pAS_Info->f_if1_bw / 2 +
-	       pAS_Info->f_LO2_FracN_Avoid) {
-		/*  Exclude LO2 FracN  */
-		MT2063_AddExclZone(pAS_Info,
-				   center - pAS_Info->f_LO2_FracN_Avoid,
-				   center - 1);
-		MT2063_AddExclZone(pAS_Info, center + 1,
-				   center + pAS_Info->f_LO2_FracN_Avoid);
-		center += pAS_Info->f_ref;
-	}
-
-	if (MT2063_EXCLUDE_US_DECT_FREQUENCIES(pAS_Info->avoidDECT)) {
-		/*  Exclude LO1 values that conflict with DECT channels */
-		MT2063_AddExclZone(pAS_Info, 1920836000 - pAS_Info->f_in, 1922236000 - pAS_Info->f_in);	/* Ctr = 1921.536 */
-		MT2063_AddExclZone(pAS_Info, 1922564000 - pAS_Info->f_in, 1923964000 - pAS_Info->f_in);	/* Ctr = 1923.264 */
-		MT2063_AddExclZone(pAS_Info, 1924292000 - pAS_Info->f_in, 1925692000 - pAS_Info->f_in);	/* Ctr = 1924.992 */
-		MT2063_AddExclZone(pAS_Info, 1926020000 - pAS_Info->f_in, 1927420000 - pAS_Info->f_in);	/* Ctr = 1926.720 */
-		MT2063_AddExclZone(pAS_Info, 1927748000 - pAS_Info->f_in, 1929148000 - pAS_Info->f_in);	/* Ctr = 1928.448 */
-	}
-
-	if (MT2063_EXCLUDE_EURO_DECT_FREQUENCIES(pAS_Info->avoidDECT)) {
-		MT2063_AddExclZone(pAS_Info, 1896644000 - pAS_Info->f_in, 1898044000 - pAS_Info->f_in);	/* Ctr = 1897.344 */
-		MT2063_AddExclZone(pAS_Info, 1894916000 - pAS_Info->f_in, 1896316000 - pAS_Info->f_in);	/* Ctr = 1895.616 */
-		MT2063_AddExclZone(pAS_Info, 1893188000 - pAS_Info->f_in, 1894588000 - pAS_Info->f_in);	/* Ctr = 1893.888 */
-		MT2063_AddExclZone(pAS_Info, 1891460000 - pAS_Info->f_in, 1892860000 - pAS_Info->f_in);	/* Ctr = 1892.16  */
-		MT2063_AddExclZone(pAS_Info, 1889732000 - pAS_Info->f_in, 1891132000 - pAS_Info->f_in);	/* Ctr = 1890.432 */
-		MT2063_AddExclZone(pAS_Info, 1888004000 - pAS_Info->f_in, 1889404000 - pAS_Info->f_in);	/* Ctr = 1888.704 */
-		MT2063_AddExclZone(pAS_Info, 1886276000 - pAS_Info->f_in, 1887676000 - pAS_Info->f_in);	/* Ctr = 1886.976 */
-		MT2063_AddExclZone(pAS_Info, 1884548000 - pAS_Info->f_in, 1885948000 - pAS_Info->f_in);	/* Ctr = 1885.248 */
-		MT2063_AddExclZone(pAS_Info, 1882820000 - pAS_Info->f_in, 1884220000 - pAS_Info->f_in);	/* Ctr = 1883.52  */
-		MT2063_AddExclZone(pAS_Info, 1881092000 - pAS_Info->f_in, 1882492000 - pAS_Info->f_in);	/* Ctr = 1881.792 */
-	}
-}
-
 static struct MT2063_ExclZone_t *InsertNode(struct MT2063_AvoidSpursData_t
 					    *pAS_Info,
 					    struct MT2063_ExclZone_t *pPrevNode)
@@ -554,6 +466,76 @@ static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 	}
 }
 
+/*
+**  Reset all exclusion zones.
+**  Add zones to protect the PLL FracN regions near zero
+**
+**   N/A I 06-17-2008    RSK    Ver 1.19: Refactoring avoidance of DECT
+**                              frequencies into MT_ResetExclZones().
+*/
+static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
+{
+	u32 center;
+
+	pAS_Info->nZones = 0;	/*  this clears the used list  */
+	pAS_Info->usedZones = NULL;	/*  reset ptr                  */
+	pAS_Info->freeZones = NULL;	/*  reset ptr                  */
+
+	center =
+	    pAS_Info->f_ref *
+	    ((pAS_Info->f_if1_Center - pAS_Info->f_if1_bw / 2 +
+	      pAS_Info->f_in) / pAS_Info->f_ref) - pAS_Info->f_in;
+	while (center <
+	       pAS_Info->f_if1_Center + pAS_Info->f_if1_bw / 2 +
+	       pAS_Info->f_LO1_FracN_Avoid) {
+		/*  Exclude LO1 FracN  */
+		MT2063_AddExclZone(pAS_Info,
+				   center - pAS_Info->f_LO1_FracN_Avoid,
+				   center - 1);
+		MT2063_AddExclZone(pAS_Info, center + 1,
+				   center + pAS_Info->f_LO1_FracN_Avoid);
+		center += pAS_Info->f_ref;
+	}
+
+	center =
+	    pAS_Info->f_ref *
+	    ((pAS_Info->f_if1_Center - pAS_Info->f_if1_bw / 2 -
+	      pAS_Info->f_out) / pAS_Info->f_ref) + pAS_Info->f_out;
+	while (center <
+	       pAS_Info->f_if1_Center + pAS_Info->f_if1_bw / 2 +
+	       pAS_Info->f_LO2_FracN_Avoid) {
+		/*  Exclude LO2 FracN  */
+		MT2063_AddExclZone(pAS_Info,
+				   center - pAS_Info->f_LO2_FracN_Avoid,
+				   center - 1);
+		MT2063_AddExclZone(pAS_Info, center + 1,
+				   center + pAS_Info->f_LO2_FracN_Avoid);
+		center += pAS_Info->f_ref;
+	}
+
+	if (MT2063_EXCLUDE_US_DECT_FREQUENCIES(pAS_Info->avoidDECT)) {
+		/*  Exclude LO1 values that conflict with DECT channels */
+		MT2063_AddExclZone(pAS_Info, 1920836000 - pAS_Info->f_in, 1922236000 - pAS_Info->f_in);	/* Ctr = 1921.536 */
+		MT2063_AddExclZone(pAS_Info, 1922564000 - pAS_Info->f_in, 1923964000 - pAS_Info->f_in);	/* Ctr = 1923.264 */
+		MT2063_AddExclZone(pAS_Info, 1924292000 - pAS_Info->f_in, 1925692000 - pAS_Info->f_in);	/* Ctr = 1924.992 */
+		MT2063_AddExclZone(pAS_Info, 1926020000 - pAS_Info->f_in, 1927420000 - pAS_Info->f_in);	/* Ctr = 1926.720 */
+		MT2063_AddExclZone(pAS_Info, 1927748000 - pAS_Info->f_in, 1929148000 - pAS_Info->f_in);	/* Ctr = 1928.448 */
+	}
+
+	if (MT2063_EXCLUDE_EURO_DECT_FREQUENCIES(pAS_Info->avoidDECT)) {
+		MT2063_AddExclZone(pAS_Info, 1896644000 - pAS_Info->f_in, 1898044000 - pAS_Info->f_in);	/* Ctr = 1897.344 */
+		MT2063_AddExclZone(pAS_Info, 1894916000 - pAS_Info->f_in, 1896316000 - pAS_Info->f_in);	/* Ctr = 1895.616 */
+		MT2063_AddExclZone(pAS_Info, 1893188000 - pAS_Info->f_in, 1894588000 - pAS_Info->f_in);	/* Ctr = 1893.888 */
+		MT2063_AddExclZone(pAS_Info, 1891460000 - pAS_Info->f_in, 1892860000 - pAS_Info->f_in);	/* Ctr = 1892.16  */
+		MT2063_AddExclZone(pAS_Info, 1889732000 - pAS_Info->f_in, 1891132000 - pAS_Info->f_in);	/* Ctr = 1890.432 */
+		MT2063_AddExclZone(pAS_Info, 1888004000 - pAS_Info->f_in, 1889404000 - pAS_Info->f_in);	/* Ctr = 1888.704 */
+		MT2063_AddExclZone(pAS_Info, 1886276000 - pAS_Info->f_in, 1887676000 - pAS_Info->f_in);	/* Ctr = 1886.976 */
+		MT2063_AddExclZone(pAS_Info, 1884548000 - pAS_Info->f_in, 1885948000 - pAS_Info->f_in);	/* Ctr = 1885.248 */
+		MT2063_AddExclZone(pAS_Info, 1882820000 - pAS_Info->f_in, 1884220000 - pAS_Info->f_in);	/* Ctr = 1883.52  */
+		MT2063_AddExclZone(pAS_Info, 1881092000 - pAS_Info->f_in, 1882492000 - pAS_Info->f_in);	/* Ctr = 1881.792 */
+	}
+}
+
 /*****************************************************************************
 **
 **  Name: MT_ChooseFirstIF
@@ -1121,7 +1103,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_DNC_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_DNC_GAIN,
 						  val);
 
@@ -1129,7 +1111,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_VGA_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_VGA_GAIN,
 						  val);
 
@@ -1137,7 +1119,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_RSVD_20] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_RSVD_20,
 						  val);
 
@@ -1149,7 +1131,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_DNC_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_DNC_GAIN,
 						  val);
 
@@ -1157,7 +1139,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_VGA_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_VGA_GAIN,
 						  val);
 
@@ -1165,7 +1147,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_RSVD_20] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_RSVD_20,
 						  val);
 
@@ -1177,7 +1159,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_DNC_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_DNC_GAIN,
 						  val);
 
@@ -1185,7 +1167,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_VGA_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_VGA_GAIN,
 						  val);
 
@@ -1193,7 +1175,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_RSVD_20] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_RSVD_20,
 						  val);
 
@@ -1205,7 +1187,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_DNC_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_DNC_GAIN,
 						  val);
 
@@ -1213,7 +1195,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_VGA_GAIN] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_VGA_GAIN,
 						  val);
 
@@ -1221,7 +1203,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 			if (state->reg[MT2063_REG_RSVD_20] !=
 			    val)
 				status |=
-				    MT2063_SetReg(state,
+				    mt2063_setreg(state,
 						  MT2063_REG_RSVD_20,
 						  val);
 
@@ -1280,7 +1262,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 **                      MT_OK             - No errors
 **                      MT_COMM_ERR       - Serial bus communications error
 **
-**  Dependencies:   MT2063_SetReg - Write a byte of data to a HW register.
+**  Dependencies:   mt2063_setreg - Write a byte of data to a HW register.
 **                  Assumes that the tuner cache is valid.
 **
 **  Revision History:
@@ -1335,7 +1317,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 								   ? 0x40 :
 								   0x00);
 		if (state->reg[MT2063_REG_PD1_TGT] != val) {
-			status |= MT2063_SetReg(state, MT2063_REG_PD1_TGT, val);
+			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
 		}
 	}
 
@@ -1344,7 +1326,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = (state-> reg[MT2063_REG_CTRL_2C] & (u8) ~ 0x03) |
 			 (LNARIN[Mode] & 0x03);
 		if (state->reg[MT2063_REG_CTRL_2C] != val)
-			status |= MT2063_SetReg(state, MT2063_REG_CTRL_2C,
+			status |= mt2063_setreg(state, MT2063_REG_CTRL_2C,
 					  val);
 	}
 
@@ -1356,17 +1338,17 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		    (FIFFQEN[Mode] << 7) | (FIFFQ[Mode] << 4);
 		if (state->reg[MT2063_REG_FIFF_CTRL2] != val) {
 			status |=
-			    MT2063_SetReg(state, MT2063_REG_FIFF_CTRL2, val);
+			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL2, val);
 			/* trigger FIFF calibration, needed after changing FIFFQ */
 			val =
 			    (state->reg[MT2063_REG_FIFF_CTRL] | (u8) 0x01);
 			status |=
-			    MT2063_SetReg(state, MT2063_REG_FIFF_CTRL, val);
+			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
 			val =
 			    (state->
 			     reg[MT2063_REG_FIFF_CTRL] & (u8) ~ 0x01);
 			status |=
-			    MT2063_SetReg(state, MT2063_REG_FIFF_CTRL, val);
+			    mt2063_setreg(state, MT2063_REG_FIFF_CTRL, val);
 		}
 	}
 
@@ -1379,7 +1361,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = (state-> reg[MT2063_REG_LNA_OV] & (u8) ~ 0x1F) |
 			 (ACLNAMAX[Mode] & 0x1F);
 		if (state->reg[MT2063_REG_LNA_OV] != val)
-			status |= MT2063_SetReg(state, MT2063_REG_LNA_OV, val);
+			status |= mt2063_setreg(state, MT2063_REG_LNA_OV, val);
 	}
 
 	/* LNATGT */
@@ -1387,7 +1369,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = (state-> reg[MT2063_REG_LNA_TGT] & (u8) ~ 0x3F) |
 			 (LNATGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_LNA_TGT] != val)
-			status |= MT2063_SetReg(state, MT2063_REG_LNA_TGT, val);
+			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
 	}
 
 	/* ACRF */
@@ -1395,7 +1377,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = (state-> reg[MT2063_REG_RF_OV] & (u8) ~ 0x1F) |
 		         (ACRFMAX[Mode] & 0x1F);
 		if (state->reg[MT2063_REG_RF_OV] != val)
-			status |= MT2063_SetReg(state, MT2063_REG_RF_OV, val);
+			status |= mt2063_setreg(state, MT2063_REG_RF_OV, val);
 	}
 
 	/* PD1TGT */
@@ -1403,7 +1385,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = (state-> reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x3F) |
 			 (PD1TGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_PD1_TGT] != val)
-			status |= MT2063_SetReg(state, MT2063_REG_PD1_TGT, val);
+			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
 	}
 
 	/* FIFATN */
@@ -1414,7 +1396,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		val = (state-> reg[MT2063_REG_FIF_OV] & (u8) ~ 0x1F) |
 		      (val & 0x1F);
 		if (state->reg[MT2063_REG_FIF_OV] != val) {
-			status |= MT2063_SetReg(state, MT2063_REG_FIF_OV, val);
+			status |= mt2063_setreg(state, MT2063_REG_FIF_OV, val);
 		}
 	}
 
@@ -1423,7 +1405,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		u8 val = (state-> reg[MT2063_REG_PD2_TGT] & (u8) ~ 0x3F) |
 		    (PD2TGT[Mode] & 0x3F);
 		if (state->reg[MT2063_REG_PD2_TGT] != val)
-			status |= MT2063_SetReg(state, MT2063_REG_PD2_TGT, val);
+			status |= mt2063_setreg(state, MT2063_REG_PD2_TGT, val);
 	}
 
 	/* Ignore ATN Overload */
@@ -1434,7 +1416,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 								   ? 0x80 :
 								   0x00);
 		if (state->reg[MT2063_REG_LNA_TGT] != val) {
-			status |= MT2063_SetReg(state, MT2063_REG_LNA_TGT, val);
+			status |= mt2063_setreg(state, MT2063_REG_LNA_TGT, val);
 		}
 	}
 
@@ -1445,7 +1427,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 		     reg[MT2063_REG_PD1_TGT] & (u8) ~ 0x80) |
 		    (FIFOVDIS[Mode] ? 0x80 : 0x00);
 		if (state->reg[MT2063_REG_PD1_TGT] != val) {
-			status |= MT2063_SetReg(state, MT2063_REG_PD1_TGT, val);
+			status |= mt2063_setreg(state, MT2063_REG_PD1_TGT, val);
 		}
 	}
 
@@ -1566,50 +1548,6 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 	return status;
 }
 
-/****************************************************************************
-**
-**  Name: MT2063_SetReg
-**
-**  Description:    Sets an MT2063 register.
-**
-**  Parameters:     h           - Tuner handle (returned by MT2063_Open)
-**                  reg         - MT2063 register/subaddress location
-**                  val         - MT2063 register/subaddress value
-**
-**  Returns:        status:
-**                      MT_OK            - No errors
-**                      MT_COMM_ERR      - Serial bus communications error
-**                      MT_INV_HANDLE    - Invalid tuner handle
-**                      MT_ARG_RANGE     - Argument out of range
-**
-**  Dependencies:   USERS MUST CALL MT2063_Open() FIRST!
-**
-**                  Use this function if you need to override a default
-**                  register value
-**
-**  Revision History:
-**
-**   SCR      Date      Author  Description
-**  -------------------------------------------------------------------------
-**   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
-**
-****************************************************************************/
-static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val)
-{
-	u32 status;
-
-	if (reg >= MT2063_REG_END_REGS)
-		return -ERANGE;
-
-	status = mt2063_write(state, reg, &val, 1);
-	if (status < 0)
-		return status;
-
-	state->reg[reg] = val;
-
-	return 0;
-}
-
 static u32 MT2063_Round_fLO(u32 f_LO, u32 f_LO_Step, u32 f_ref)
 {
 	return f_ref * (f_LO / f_ref)
@@ -1866,7 +1804,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 		val = (state->reg[MT2063_REG_CTUNE_CTRL] | 0x08);
 		if (state->reg[MT2063_REG_CTUNE_CTRL] != val) {
 			status |=
-			    MT2063_SetReg(state, MT2063_REG_CTUNE_CTRL, val);
+			    mt2063_setreg(state, MT2063_REG_CTUNE_CTRL, val);
 		}
 		val = state->reg[MT2063_REG_CTUNE_OV];
 		RFBand = FindClearTuneFilter(state, f_in);
@@ -1875,7 +1813,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 			      | RFBand);
 		if (state->reg[MT2063_REG_CTUNE_OV] != val) {
 			status |=
-			    MT2063_SetReg(state, MT2063_REG_CTUNE_OV, val);
+			    mt2063_setreg(state, MT2063_REG_CTUNE_OV, val);
 		}
 	}
 
@@ -2529,6 +2467,37 @@ error:
 }
 EXPORT_SYMBOL_GPL(mt2063_attach);
 
+/*
+ * Ancillary routines visible outside mt2063
+ * FIXME: Remove them in favor of using standard tuner callbacks
+ */
+unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
+{
+	struct mt2063_state *state = fe->tuner_priv;
+	int err = 0;
+
+	err = MT2063_SoftwareShutdown(state, 1);
+	if (err < 0)
+		printk(KERN_ERR "%s: Couldn't shutdown\n", __func__);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(tuner_MT2063_SoftwareShutdown);
+
+unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
+{
+	struct mt2063_state *state = fe->tuner_priv;
+	int err = 0;
+
+	err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
+	if (err < 0)
+		printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
+
+
 MODULE_PARM_DESC(verbose, "Set Verbosity level");
 
 MODULE_AUTHOR("Henry");
-- 
1.7.7.5

