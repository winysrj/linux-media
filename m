Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511BZK016667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 36/47] [media] mt2063: Add some debug printk's
Date: Wed,  4 Jan 2012 23:00:47 -0200
Message-Id: <1325725258-27934-37-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   76 ++++++++++++++++++++++++++++++----
 1 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 75cb1d2..cd67417 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -27,8 +27,15 @@
 
 #include "mt2063.h"
 
-static unsigned int verbose;
-module_param(verbose, int, 0644);
+static unsigned int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Set Verbosity level");
+
+#define dprintk(level, fmt, arg...) do {				\
+if (debug >= level)							\
+	printk(KERN_DEBUG "mt2063 %s: " fmt, __func__, ## arg);	\
+} while (0)
+
 
 /* positive error codes used internally */
 
@@ -248,6 +255,8 @@ static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 		.len = len + 1
 	};
 
+	dprintk(2, "\n");
+
 	msg.buf[0] = reg;
 	memcpy(msg.buf + 1, data, len);
 
@@ -270,6 +279,8 @@ static u32 mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
 {
 	u32 status;
 
+	dprintk(2, "\n");
+
 	if (reg >= MT2063_REG_END_REGS)
 		return -ERANGE;
 
@@ -292,6 +303,8 @@ static u32 mt2063_read(struct mt2063_state *state,
 	struct dvb_frontend *fe = state->frontend;
 	u32 i = 0;
 
+	dprintk(2, "\n");
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -353,6 +366,9 @@ static struct MT2063_ExclZone_t *InsertNode(struct MT2063_AvoidSpursData_t
 					    struct MT2063_ExclZone_t *pPrevNode)
 {
 	struct MT2063_ExclZone_t *pNode;
+
+	dprintk(2, "\n");
+
 	/*  Check for a node in the free list  */
 	if (pAS_Info->freeZones != NULL) {
 		/*  Use one from the free list  */
@@ -384,6 +400,8 @@ static struct MT2063_ExclZone_t *RemoveNode(struct MT2063_AvoidSpursData_t
 {
 	struct MT2063_ExclZone_t *pNext = pNodeToRemove->next_;
 
+	dprintk(2, "\n");
+
 	/*  Make previous node point to the subsequent node  */
 	if (pPrevNode != NULL)
 		pPrevNode->next_ = pNext;
@@ -413,6 +431,8 @@ static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 	struct MT2063_ExclZone_t *pPrev = NULL;
 	struct MT2063_ExclZone_t *pNext = NULL;
 
+	dprintk(2, "\n");
+
 	/*  Check to see if this overlaps the 1st IF filter  */
 	if ((f_max > (pAS_Info->f_if1_Center - (pAS_Info->f_if1_bw / 2)))
 	    && (f_min < (pAS_Info->f_if1_Center + (pAS_Info->f_if1_bw / 2)))
@@ -462,6 +482,8 @@ static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	u32 center;
 
+	dprintk(2, "\n");
+
 	pAS_Info->nZones = 0;	/*  this clears the used list  */
 	pAS_Info->usedZones = NULL;	/*  reset ptr                  */
 	pAS_Info->freeZones = NULL;	/*  reset ptr                  */
@@ -547,7 +569,6 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	     pAS_Info->f_LO2_Step) ? pAS_Info->f_LO1_Step : pAS_Info->
 	    f_LO2_Step;
 	u32 f_Center;
-
 	s32 i;
 	s32 j = 0;
 	u32 bDesiredExcluded = 0;
@@ -557,6 +578,8 @@ static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
 	struct MT2063_FIFZone_t zones[MT2063_MAX_ZONES];
 
+	dprintk(2, "\n");
+
 	if (pAS_Info->nZones == 0)
 		return f_Desired;
 
@@ -692,6 +715,9 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 	s32 f_Spur;
 	u32 ma, mb, mc, md, me, mf;
 	u32 lo_gcd, gd_Scale, gc_Scale, gf_Scale, hgds, hgfs, hgcs;
+
+	dprintk(2, "\n");
+
 	*fm = 0;
 
 	/*
@@ -788,6 +814,8 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 	pAS_Info->bSpurAvoided = 0;
 	pAS_Info->nSpursFound = 0;
 
+	dprintk(2, "\n");
+
 	if (pAS_Info->maxH1 == 0)
 		return 0;
 
@@ -910,6 +938,8 @@ static unsigned int mt2063_lockStatus(struct mt2063_state *state)
 	u32 status;
 	u32 nDelays = 0;
 
+	dprintk(2, "\n");
+
 	/*  LO2 Lock bit was in a different place for B0 version  */
 	if (state->tuner_id == MT2063_B0)
 		LO2LK = 0x40;
@@ -1001,6 +1031,8 @@ static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
 static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
 					enum MT2063_DNC_Output_Enable *pValue)
 {
+	dprintk(2, "\n");
+
 	if ((state->reg[MT2063_REG_DNC_GAIN] & 0x03) == 0x03) {	/* if DNC1 is off */
 		if ((state->reg[MT2063_REG_VGA_GAIN] & 0x03) == 0x03)	/* if DNC2 is off */
 			*pValue = MT2063_DNC_NONE;
@@ -1024,6 +1056,8 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 	u32 status = 0;	/* Status to be returned        */
 	u8 val = 0;
 
+	dprintk(2, "\n");
+
 	/* selects, which DNC output is used */
 	switch (nValue) {
 	case MT2063_DNC_NONE:
@@ -1157,6 +1191,8 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 	u8 val;
 	u32 longval;
 
+	dprintk(2, "\n");
+
 	if (Mode >= MT2063_NUM_RCVR_MODES)
 		status = -ERANGE;
 
@@ -1292,6 +1328,7 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
 {
 	u32 status = 0;
 
+	dprintk(2, "\n");
 	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
 	if ((Bits & 0xFF00) != 0) {
 		state->reg[MT2063_REG_PWR_2] &= ~(u8) (Bits >> 8);
@@ -1320,6 +1357,7 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 {
 	u32 status;
 
+	dprintk(2, "\n");
 	if (Shutdown == 1)
 		state->reg[MT2063_REG_PWR_1] |= 0x04;
 	else
@@ -1498,6 +1536,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	u8 val;
 	u32 RFBand;
 
+	dprintk(2, "\n");
 	/*  Check the input and output frequency ranges                   */
 	if ((f_in < MT2063_MIN_FIN_FREQ) || (f_in > MT2063_MAX_FIN_FREQ))
 		return -EINVAL;
@@ -1757,12 +1796,16 @@ static int mt2063_init(struct dvb_frontend *fe)
 	u32 fcu_osc;
 	u32 i;
 
+	dprintk(2, "\n");
+
 	state->rcvr_mode = MT2063_CABLE_QAM;
 
 	/*  Read the Part/Rev code from the tuner */
 	status = mt2063_read(state, MT2063_REG_PART_REV, state->reg, 1);
-	if (status < 0)
+	if (status < 0) {
+		printk(KERN_ERR "Can't read mt2063 part ID\n");
 		return status;
+	}
 
 	/* Check the part/rev code */
 	if (((state->reg[MT2063_REG_PART_REV] != MT2063_B0)	/*  MT2063 B0  */
@@ -1775,8 +1818,10 @@ static int mt2063_init(struct dvb_frontend *fe)
 			     &state->reg[MT2063_REG_RSVD_3B], 1);
 
 	/* b7 != 0 ==> NOT MT2063 */
-	if (status < 0 || ((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00))
+	if (status < 0 || ((state->reg[MT2063_REG_RSVD_3B] & 0x80) != 0x00)) {
+		printk(KERN_ERR "Can't read mt2063 2nd part ID\n");
 		return -ENODEV;	/*  Wrong tuner Part/Rev code */
+	}
 
 	/*  Reset the tuner  */
 	status = mt2063_write(state, MT2063_REG_LO2CQ_3, &all_resets, 1);
@@ -1940,6 +1985,8 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 	struct mt2063_state *state = fe->tuner_priv;
 	int status;
 
+	dprintk(2, "\n");
+
 	*tuner_status = 0;
 	status = mt2063_lockStatus(state);
 	if (status < 0)
@@ -1954,6 +2001,8 @@ static int mt2063_release(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
+	dprintk(2, "\n");
+
 	fe->tuner_priv = NULL;
 	kfree(state);
 
@@ -1974,6 +2023,8 @@ static int mt2063_set_analog_params(struct dvb_frontend *fe,
 	s32 rcvr_mode = 0;
 	int status;
 
+	dprintk(2, "\n");
+
 	switch (params->mode) {
 	case V4L2_TUNER_RADIO:
 		pict_car = 38900000;
@@ -2065,6 +2116,8 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 	s32 if_mid = 0;
 	s32 rcvr_mode = 0;
 
+	dprintk(2, "\n");
+
 	if (c->bandwidth_hz == 0)
 		return -EINVAL;
 	if (c->bandwidth_hz <= 6000000)
@@ -2116,6 +2169,8 @@ static int mt2063_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
+	dprintk(2, "\n");
+
 	*freq = state->frequency;
 	return 0;
 }
@@ -2124,6 +2179,8 @@ static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
+	dprintk(2, "\n");
+
 	*bw = state->AS_Data.f_out_bw - 750000;
 	return 0;
 }
@@ -2152,6 +2209,8 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 {
 	struct mt2063_state *state = NULL;
 
+	dprintk(2, "\n");
+
 	state = kzalloc(sizeof(struct mt2063_state), GFP_KERNEL);
 	if (state == NULL)
 		goto error;
@@ -2181,6 +2240,8 @@ unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 	struct mt2063_state *state = fe->tuner_priv;
 	int err = 0;
 
+	dprintk(2, "\n");
+
 	err = MT2063_SoftwareShutdown(state, 1);
 	if (err < 0)
 		printk(KERN_ERR "%s: Couldn't shutdown\n", __func__);
@@ -2194,6 +2255,8 @@ unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 	struct mt2063_state *state = fe->tuner_priv;
 	int err = 0;
 
+	dprintk(2, "\n");
+
 	err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
 	if (err < 0)
 		printk(KERN_ERR "%s: Invalid parameter\n", __func__);
@@ -2202,9 +2265,6 @@ unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
 
-
-MODULE_PARM_DESC(verbose, "Set Verbosity level");
-
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("MT2063 Silicon tuner");
 MODULE_LICENSE("GPL");
-- 
1.7.7.5

