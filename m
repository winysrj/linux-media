Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117l0016627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/47] [media] mt2063: get rid of compilation warnings
Date: Wed,  4 Jan 2012 23:00:21 -0200
Message-Id: <1325725258-27934-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   35 +++++++++++++--------------------
 drivers/media/common/tuners/mt2063.h |   11 +++++++++-
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index c181332..43e543e 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -26,7 +26,7 @@ static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue);
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
 
-static unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
+unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
 				   u32 bw_in,
 				   enum MTTune_atv_standard tv_type)
 {
@@ -57,7 +57,7 @@ static unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
 	return err;
 }
 
-static unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
+unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_ops *frontend_ops = &fe->ops;
 	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
@@ -79,7 +79,7 @@ static unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
 	return err;
 }
 
-static unsigned int tuner_MT2063_Open(struct dvb_frontend *fe)
+unsigned int tuner_MT2063_Open(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_ops *frontend_ops = &fe->ops;
 	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
@@ -102,7 +102,7 @@ static unsigned int tuner_MT2063_Open(struct dvb_frontend *fe)
 	return err;
 }
 
-static unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
+unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_ops *frontend_ops = &fe->ops;
 	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
@@ -125,7 +125,7 @@ static unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 	return err;
 }
 
-static unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
+unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_ops *frontend_ops = &fe->ops;
 	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
@@ -357,13 +357,15 @@ static u32 MT2063_ReadSub(void *hUserData,
 **   N/A   03-25-2004    DAD    Original
 **
 *****************************************************************************/
-static void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
+static int MT2063_Sleep(struct dvb_frontend *fe)
 {
 	/*
 	 **  ToDo:  Add code here to implement a OS blocking
 	 **         for a period of "nMinDelayTime" milliseconds.
 	 */
-	msleep(nMinDelayTime);
+	msleep(10);
+
+	return 0;
 }
 
 //end of mt2063_userdef.c
@@ -467,10 +469,7 @@ static u32 MT2063_RegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 
 static void MT2063_UnRegisterTuner(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
-#if MT2063_TUNER_CNT == 1
-	pAS_Info;
-#else
-
+#if MT2063_TUNER_CNT > 1
 	u32 index;
 
 	for (index = 0; index < TunerCount; index++) {
@@ -1507,10 +1506,9 @@ static u32 MT2063_fLO_FractionalTerm(u32 f_ref, u32 num,
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ******************************************************************************/
-static u32 MT2063_Open(u32 MT2063_Addr, void ** hMT2063, void *hUserData)
+static u32 MT2063_Open(u32 MT2063_Addr, struct MT2063_Info_t **hMT2063, void *hUserData)
 {
 	u32 status = MT2063_OK;	/*  Status to be returned.  */
-	s32 i;
 	struct MT2063_Info_t *pInfo = NULL;
 	struct dvb_frontend *fe = (struct dvb_frontend *)hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
@@ -2432,7 +2430,7 @@ static u32 MT2063_ReInit(void *h)
 	u8 all_resets = 0xF0;	/* reset/load bits */
 	u32 status = MT2063_OK;	/* Status to be returned */
 	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-	u8 *def;
+	u8 *def = NULL;
 
 	u8 MT2063B0_defaults[] = {	/* Reg,  Value */
 		0x19, 0x05,
@@ -3391,10 +3389,9 @@ static u32 MT2063_SetParam(void *h, enum MT2063_Param param, u32 nValue)
 **   138   06-19-2007    DAD    Ver 1.00: Initial, derived from mt2067_b.
 **
 ****************************************************************************/
-static u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
+static u32 MT2063_ClearPowerMaskBits(struct MT2063_Info_t *pInfo, enum MT2063_Mask_Bits Bits)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0)
@@ -3448,10 +3445,9 @@ static u32 MT2063_ClearPowerMaskBits(void *h, enum MT2063_Mask_Bits Bits)
 **                              correct wakeup of the LNA
 **
 ****************************************************************************/
-static u32 MT2063_SoftwareShutdown(void *h, u8 Shutdown)
+static u32 MT2063_SoftwareShutdown(struct MT2063_Info_t *pInfo, u8 Shutdown)
 {
 	u32 status = MT2063_OK;	/* Status to be returned        */
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
 
 	/*  Verify that the handle passed points to a valid tuner         */
 	if (MT2063_IsValidHandle(pInfo) == 0) {
@@ -3964,9 +3960,6 @@ static u32 MT_Tune_atv(void *h, u32 f_in, u32 bw_in,
 {
 
 	u32 status = MT2063_OK;
-	struct MT2063_Info_t *pInfo = (struct MT2063_Info_t *)h;
-	struct dvb_frontend *fe = (struct dvb_frontend *)pInfo->hUserData;
-	struct mt2063_state *state = fe->tuner_priv;
 
 	s32 pict_car = 0;
 	s32 pict2chanb_vsb = 0;
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index abc1efc..5dece2c 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -524,7 +524,7 @@ struct mt2063_state {
 	struct dvb_tuner_ops ops;
 	struct dvb_frontend *frontend;
 	struct tuner_state status;
-	const struct MT2063_Info_t *MT2063_ht;
+	struct MT2063_Info_t *MT2063_ht;
 	bool MT2063_init;
 
 	enum MTTune_atv_standard tv_type;
@@ -549,6 +549,15 @@ static inline struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	return NULL;
 }
 
+unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
+				   u32 bw_in,
+				   enum MTTune_atv_standard tv_type);
+
+unsigned int mt2063_lockStatus(struct dvb_frontend *fe);
+unsigned int tuner_MT2063_Open(struct dvb_frontend *fe);
+unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe);
+unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe);
+
 #endif /* CONFIG_DVB_MT2063 */
 
 #endif /* __MT2063_H__ */
-- 
1.7.7.5

