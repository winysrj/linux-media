Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05116H6029434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/47] [media] mt2063: Re-define functions as static
Date: Wed,  4 Jan 2012 23:00:19 -0200
Message-Id: <1325725258-27934-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   84 ++++++++++++++++++----------------
 drivers/media/common/tuners/mt2063.h |   74 ------------------------------
 2 files changed, 44 insertions(+), 114 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 63d964a..85980cc 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -13,6 +13,16 @@ static unsigned int verbose;
 module_param(verbose, int, 0644);
 
 
+/* Prototypes */
+static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
+                        u32 f_min, u32 f_max);
+static u32 MT2063_ReInit(void *h);
+static u32 MT2063_Close(void *hMT2063);
+static u32 MT2063_GetReg(void *h, u8 reg, u8 * val);
+static u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue);
+static u32 MT2063_SetReg(void *h, u8 reg, u8 val);
+static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue);
+
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
 
@@ -233,7 +243,7 @@ static int mt2063_read_regs(struct mt2063_state *state, u8 reg1, u8 * b, u8 len)
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-u32 MT2063_WriteSub(void *hUserData,
+static u32 MT2063_WriteSub(void *hUserData,
 			u32 addr,
 			u8 subAddress, u8 * pData, u32 cnt)
 {
@@ -296,7 +306,7 @@ u32 MT2063_WriteSub(void *hUserData,
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-u32 MT2063_ReadSub(void *hUserData,
+static u32 MT2063_ReadSub(void *hUserData,
 		       u32 addr,
 		       u8 subAddress, u8 * pData, u32 cnt)
 {
@@ -347,7 +357,7 @@ u32 MT2063_ReadSub(void *hUserData,
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
+static void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
 {
 	/*
 	 **  ToDo:  Add code here to implement a OS blocking
@@ -386,7 +396,7 @@ void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
 **                              better describes what this function does.
 **
 *****************************************************************************/
-u32 MT2060_TunerGain(void *hUserData, s32 * pMeas)
+static u32 MT2060_TunerGain(void *hUserData, s32 * pMeas)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 
@@ -465,7 +475,7 @@ static struct MT2063_AvoidSpursData_t *TunerList[MT2063_TUNER_CNT];
 static u32 TunerCount = 0;
 #endif
 
-u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
+static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 #if MT2063_TUNER_CNT == 1
 	pAS_Info->nAS_Algorithm = 1;
@@ -496,7 +506,7 @@ u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 #endif
 }
 
-void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
+static void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 #if MT2063_TUNER_CNT == 1
 	pAS_Info;
@@ -519,7 +529,7 @@ void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 **   N/A I 06-17-2008    RSK    Ver 1.19: Refactoring avoidance of DECT
 **                              frequencies into MT_ResetExclZones().
 */
-void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
+static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	u32 center;
 #if MT2063_TUNER_CNT > 1
@@ -685,7 +695,7 @@ static struct MT2063_ExclZone_t *RemoveNode(struct MT2063_AvoidSpursData_t
 **                              (f_min, f_max) < 0, ignore the entry.
 **
 *****************************************************************************/
-void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
+static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 			u32 f_min, u32 f_max)
 {
 	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
@@ -751,7 +761,7 @@ void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
 **                              Added logic to force f_Center within 1/2 f_Step.
 **
 *****************************************************************************/
-u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
+static u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
 	/*
 	 ** Update "f_Desired" to be the nearest "combinational-multiple" of "f_LO1_Step".
@@ -1318,7 +1328,7 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
 **   096   04-06-2005    DAD    Ver 1.11: Fix divide by 0 error if maxH==0.
 **
 *****************************************************************************/
-u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
+static u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
 {
 	u32 status = MT2063_OK;
 	u32 fm, fp;		/*  restricted range on LO's        */
@@ -1402,7 +1412,7 @@ u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t * pAS_Info)
 	return (status);
 }
 
-u32 MT2063_AvoidSpursVersion(void)
+static u32 MT2063_AvoidSpursVersion(void)
 {
 	return (MT2063_SPUR_VERSION);
 }
@@ -1545,7 +1555,7 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-u32 MT2063_Open(u32 MT2063_Addr, void ** hMT2063, void *hUserData)
+static u32 MT2063_Open(u32 MT2063_Addr, void ** hMT2063, void *hUserData)
 {
 	u32 status = MT2063_OK;	/*  Status to be returned.  */
 	s32 i;
@@ -1624,7 +1634,7 @@ static u32 MT2063_IsValidHandle(struct MT2063_Info_t *handle)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-u32 MT2063_Close(void *hMT2063)
+static u32 MT2063_Close(void *hMT2063)
 {
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)hMT2063;
 
@@ -1672,7 +1682,7 @@ u32 MT2063_Close(void *hMT2063)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
+static u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
 		       enum MT2063_GPIO_Attr attr, u32 * value)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
@@ -1726,7 +1736,7 @@ u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_GetLocked(void *h)
+static u32 MT2063_GetLocked(void *h)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
@@ -1757,7 +1767,7 @@ u32 MT2063_GetLocked(void *h)
 		    (LO1LK | LO2LK)) {
 			return (status);
 		}
-		MT2063_Sleep(pInfo->hUserData, nPollRate);	/*  Wait between retries  */
+		msleep(nPollRate);	/*  Wait between retries  */
 	}
 	while (++nDelays < nMaxLoops);
 
@@ -1861,7 +1871,7 @@ u32 MT2063_GetLocked(void *h)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue)
+static u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -2265,7 +2275,7 @@ u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
+static u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -2337,7 +2347,7 @@ u32 MT2063_GetReg(void *h, u8 reg, u8 * val)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-u32 MT2063_GetTemp(void *h, enum MT2063_Temperature * value)
+static u32 MT2063_GetTemp(void *h, enum MT2063_Temperature * value)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -2408,7 +2418,7 @@ u32 MT2063_GetTemp(void *h, enum MT2063_Temperature * value)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_GetUserData(void *h, void ** hUserData)
+static u32 MT2063_GetUserData(void *h, void ** hUserData)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -2658,7 +2668,7 @@ static u32 MT2063_SetReceiverMode(struct MT2063_Info_t *pInfo,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ******************************************************************************/
-u32 MT2063_ReInit(void *h)
+static u32 MT2063_ReInit(void *h)
 {
 	u8 all_resets = 0xF0;	/* reset/load bits */
 	u32 status = MT2063_OK;	/* Status to be returned */
@@ -2793,7 +2803,7 @@ u32 MT2063_ReInit(void *h)
 		s32 maxReads = 10;
 		while (MT2063_NO_ERROR(status) && (FCRUN != 0)
 		       && (maxReads-- > 0)) {
-			MT2063_Sleep(pInfo->hUserData, 2);
+			msleep(2);
 			status |= MT2063_ReadSub(pInfo->hUserData,
 						 pInfo->address,
 						 MT2063_REG_XO_STATUS,
@@ -2947,7 +2957,7 @@ u32 MT2063_ReInit(void *h)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
+static u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
 		       enum MT2063_GPIO_Attr attr, u32 value)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
@@ -3057,7 +3067,7 @@ u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
+static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	u8 val = 0;
@@ -3677,7 +3687,7 @@ u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
+static u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -3734,7 +3744,7 @@ u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
+static u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -3790,7 +3800,7 @@ u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits * Bits)
+static u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits * Bits)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -3845,7 +3855,7 @@ u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits * Bits)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled)
+static u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -3896,7 +3906,7 @@ u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled)
 **                              correct wakeup of the LNA
 **
 ****************************************************************************/
-u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown)
+static u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -3968,7 +3978,7 @@ u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown)
 **   189 S 05-13-2008    RSK    Ver 1.16: Correct location for ExtSRO control.
 **
 ****************************************************************************/
-u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting)
+static u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -4018,7 +4028,7 @@ u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-u32 MT2063_SetReg(void *h, u8 reg, u8 val)
+static u32 MT2063_SetReg(void *h, u8 reg, u8 val)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
@@ -4256,7 +4266,7 @@ static u32 FindClearTuneFilter(struct MT2063_Info_t *pInfo, u32 f_in)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-u32 MT2063_Tune(void *h, u32 f_in)
+static u32 MT2063_Tune(void *h, u32 f_in)
 {				/* RF input center frequency   */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
@@ -4461,7 +4471,7 @@ u32 MT2063_Tune(void *h, u32 f_in)
 	return (status);
 }
 
-u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
+static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 		    enum MTTune_atv_standard tv_type)
 {
 
@@ -4612,12 +4622,6 @@ static int mt2063_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2063_sleep(struct dvb_frontend *fe)
-{
-	/* TODO: power down     */
-	return 0;
-}
-
 static int mt2063_get_status(struct dvb_frontend *fe, u32 * status)
 {
 	int rc = 0;
@@ -4720,7 +4724,7 @@ static struct dvb_tuner_ops mt2063_ops = {
 		 },
 
 	.init = mt2063_init,
-	.sleep = mt2063_sleep,
+	.sleep = MT2063_Sleep,
 	.get_status = mt2063_get_status,
 	.get_state = mt2063_get_state,
 	.set_state = mt2063_set_state,
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index e2faff0..abc1efc 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -99,18 +99,6 @@
 #define MT2063_TUNER_CNT               (1)	/*  total num of MicroTuner tuners  */
 #define MT2063_I2C (0xC0)
 
-u32 MT2063_WriteSub(void *hUserData,
-			u32 addr,
-			u8 subAddress, u8 * pData, u32 cnt);
-
-u32 MT2063_ReadSub(void *hUserData,
-		       u32 addr,
-		       u8 subAddress, u8 * pData, u32 cnt);
-
-void MT2063_Sleep(void *hUserData, u32 nMinDelayTime);
-
-u32 MT2060_TunerGain(void *hUserData, s32 * pMeas);
-
 /*
  *  Constant defining the version of the following structure
  *  and therefore the API for this code.
@@ -180,22 +168,6 @@ struct MT2063_AvoidSpursData_t {
 	struct MT2063_ExclZone_t MT2063_ExclZones[MT2063_MAX_ZONES];
 };
 
-u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info);
-
-void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info);
-
-void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info);
-
-void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
-			u32 f_min, u32 f_max);
-
-u32 MT2063_ChooseFirstIF(struct MT2063_AvoidSpursData_t *pAS_Info);
-
-u32 MT2063_AvoidSpurs(void *h, struct MT2063_AvoidSpursData_t *pAS_Info);
-
-u32 MT2063_AvoidSpursVersion(void);
-
-
 /*
  *  Values returned by the MT2063's on-chip temperature sensor
  *  to be read/written.
@@ -540,52 +512,6 @@ enum MTTune_atv_standard {
 	MTTUNEA_DVBT
 };
 
-/* ====== Functions which are declared in MT2063.c File ======= */
-
-u32 MT2063_Open(u32 MT2063_Addr,
-		    void ** hMT2063, void *hUserData);
-
-u32 MT2063_Close(void *hMT2063);
-
-u32 MT2063_Tune(void *h, u32 f_in);	/* RF input center frequency   */
-
-u32 MT2063_GetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, u32 * value);
-
-u32 MT2063_GetLocked(void *h);
-
-u32 MT2063_GetParam(void *h, enum MT2063_Param param, u32 * pValue);
-
-u32 MT2063_GetReg(void *h, u8 reg, u8 * val);
-
-u32 MT2063_GetTemp(void *h, enum MT2063_Temperature *value);
-
-u32 MT2063_GetUserData(void *h, void ** hUserData);
-
-u32 MT2063_ReInit(void *h);
-
-u32 MT2063_SetGPIO(void *h, enum MT2063_GPIO_ID gpio_id,
-		       enum MT2063_GPIO_Attr attr, u32 value);
-
-u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue);
-
-u32 MT2063_SetPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits);
-
-u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits);
-
-u32 MT2063_GetPowerMaskBits(void *h, enum MT2063_Mask_Bits *Bits);
-
-u32 MT2063_EnableExternalShutdown(void *h, u8 Enabled);
-
-u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown);
-
-u32 MT2063_SetExtSRO(void *h, enum MT2063_Ext_SRO Ext_SRO_Setting);
-
-u32 MT2063_SetReg(void *h, u8 reg, u8 val);
-
-u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
-		    enum MTTune_atv_standard tv_type);
-
 struct mt2063_config {
 	u8 tuner_address;
 	u32 refclock;
-- 
1.7.7.5

