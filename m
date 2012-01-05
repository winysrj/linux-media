Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05116Qg029430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/47] [media] mt2063: Remove most of the #if's
Date: Wed,  4 Jan 2012 23:00:18 -0200
Message-Id: <1325725258-27934-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   89 ++--------------------------------
 drivers/media/common/tuners/mt2063.h |    8 ---
 2 files changed, 4 insertions(+), 93 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index c8f0bfa..63d964a 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -247,16 +247,12 @@ u32 MT2063_WriteSub(void *hUserData,
 	 */
 /*  return status;  */
 
-//#if !TUNER_CONTROL_BY_DRXK_DRIVER
 	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
-//#endif
 
 	if (mt2063_writeregs(state, subAddress, pData, cnt) < 0) {
 		status = MT2063_ERROR;
 	}
-//#if !TUNER_CONTROL_BY_DRXK_DRIVER
 	fe->ops.i2c_gate_ctrl(fe, 0);	//I2C bypass drxk3926 close i2c bridge
-//#endif
 
 	return (status);
 }
@@ -314,9 +310,7 @@ u32 MT2063_ReadSub(void *hUserData,
 	struct dvb_frontend *fe = hUserData;
 	struct mt2063_state *state = fe->tuner_priv;
 	u32 i = 0;
-//#if !TUNER_CONTROL_BY_DRXK_DRIVER
 	fe->ops.i2c_gate_ctrl(fe, 1);	//I2C bypass drxk3926 close i2c bridge
-//#endif
 
 	for (i = 0; i < cnt; i++) {
 		if (mt2063_read_regs(state, subAddress + i, pData + i, 1) < 0) {
@@ -325,9 +319,7 @@ u32 MT2063_ReadSub(void *hUserData,
 		}
 	}
 
-//#if !TUNER_CONTROL_BY_DRXK_DRIVER
 	fe->ops.i2c_gate_ctrl(fe, 0);	//I2C bypass drxk3926 close i2c bridge
-//#endif
 
 	return (status);
 }
@@ -364,8 +356,6 @@ void MT2063_Sleep(void *hUserData, u32 nMinDelayTime)
 	msleep(nMinDelayTime);
 }
 
-#if defined(MT2060_CNT)
-#if MT2060_CNT > 0
 /*****************************************************************************
 **
 **  Name: MT_TunerGain  (MT2060 only)
@@ -407,8 +397,6 @@ u32 MT2060_TunerGain(void *hUserData, s32 * pMeas)
 
 	return (status);
 }
-#endif
-#endif
 //end of mt2063_userdef.c
 //=================================================================
 //#################################################################
@@ -458,14 +446,6 @@ u32 MT2060_TunerGain(void *hUserData, s32 * pMeas)
 **
 *****************************************************************************/
 
-#if !defined(MT2063_TUNER_CNT)
-#error MT2063_TUNER_CNT is not defined (see mt_userdef.h)
-#endif
-
-#if MT2063_TUNER_CNT == 0
-#error MT2063_TUNER_CNT must be updated in mt_userdef.h
-#endif
-
 /*  Version of this module                         */
 #define MT2063_SPUR_VERSION 10201	/*  Version 01.21 */
 
@@ -1437,17 +1417,6 @@ u32 MT2063_AvoidSpursVersion(void)
 **  If the version is different, an updated file is needed from Microtune
 */
 /* Expecting version 1.21 of the Spur Avoidance API */
-#define EXPECTED_MT2063_AVOID_SPURS_INFO_VERSION  010201
-
-#if MT2063_AVOID_SPURS_INFO_VERSION < EXPECTED_MT2063_AVOID_SPURS_INFO_VERSION
-#error Contact Microtune for a newer version of MT_SpurAvoid.c
-#elif MT2063_AVOID_SPURS_INFO_VERSION > EXPECTED_MT2063_AVOID_SPURS_INFO_VERSION
-#error Contact Microtune for a newer version of mt2063.c
-#endif
-
-#ifndef MT2063_CNT
-#error You must define MT2063_CNT in the "mt_userdef.h" file
-#endif
 
 typedef enum {
 	MT2063_SET_ATTEN,
@@ -1493,9 +1462,9 @@ static const u32 MT2063_Num_Registers = MT2063_REG_END_REGS;
 
 #define USE_GLOBAL_TUNER			0
 
-static u32 nMT2063MaxTuners = MT2063_CNT;
-static struct MT2063_Info_t MT2063_Info[MT2063_CNT];
-static struct MT2063_Info_t *MT2063_Avail[MT2063_CNT];
+static u32 nMT2063MaxTuners = 1;
+static struct MT2063_Info_t MT2063_Info[1];
+static struct MT2063_Info_t *MT2063_Avail[1];
 static u32 nMT2063OpenTuners = 0;
 
 /*
@@ -1591,51 +1560,6 @@ u32 MT2063_Open(u32 MT2063_Addr, void ** hMT2063, void *hUserData)
 
 	/*  Default tuner handle to NULL.  If successful, it will be reassigned  */
 
-#if USE_GLOBAL_TUNER
-	*hMT2063 = NULL;
-
-	/*
-	 **  If this is our first tuner, initialize the address fields and
-	 **  the list of available control blocks.
-	 */
-	if (nMT2063OpenTuners == 0) {
-		for (i = MT2063_CNT - 1; i >= 0; i--) {
-			MT2063_Info[i].handle = NULL;
-			MT2063_Info[i].address = MAX_UDATA;
-			MT2063_Info[i].rcvr_mode = MT2063_CABLE_QAM;
-			MT2063_Info[i].hUserData = NULL;
-			MT2063_Avail[i] = &MT2063_Info[i];
-		}
-	}
-
-	/*
-	 **  Look for an existing MT2063_State_t entry with this address.
-	 */
-	for (i = MT2063_CNT - 1; i >= 0; i--) {
-		/*
-		 **  If an open'ed handle provided, we'll re-initialize that structure.
-		 **
-		 **  We recognize an open tuner because the address and hUserData are
-		 **  the same as one that has already been opened
-		 */
-		if ((MT2063_Info[i].address == MT2063_Addr) &&
-		    (MT2063_Info[i].hUserData == hUserData)) {
-			pInfo = &MT2063_Info[i];
-			break;
-		}
-	}
-
-	/*  If not found, choose an empty spot.  */
-	if (pInfo == NULL) {
-		/*  Check to see that we're not over-allocating  */
-		if (nMT2063OpenTuners == MT2063_CNT) {
-			return MT2063_TUNER_CNT_ERR;
-		}
-		/* Use the next available block from the list */
-		pInfo = MT2063_Avail[nMT2063OpenTuners];
-		nMT2063OpenTuners++;
-	}
-#else
 	if (state->MT2063_init == false) {
 		pInfo = kzalloc(sizeof(struct MT2063_Info_t), GFP_KERNEL);
 		if (pInfo == NULL) {
@@ -1648,7 +1572,6 @@ u32 MT2063_Open(u32 MT2063_Addr, void ** hMT2063, void *hUserData)
 	} else {
 		pInfo = *hMT2063;
 	}
-#endif
 
 	if (MT2063_NO_ERROR(status)) {
 		status |= MT2063_RegisterTuner(&pInfo->AS_Data);
@@ -1714,13 +1637,9 @@ u32 MT2063_Close(void *hMT2063)
 	pInfo->handle = NULL;
 	pInfo->address = MAX_UDATA;
 	pInfo->hUserData = NULL;
-#if USE_GLOBAL_TUNER
-	nMT2063OpenTuners--;
-	MT2063_Avail[nMT2063OpenTuners] = pInfo;	/* Return control block to available list */
-#else
 	//kfree(pInfo);
 	//pInfo = NULL;
-#endif
+
 	return MT2063_OK;
 }
 
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index 7fb5b74..e2faff0 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -81,7 +81,6 @@
 /*
  *  Data Types
  */
-#define MT2060_CNT 10
 
 #define MAX_UDATA         (4294967295)	/*  max value storable in u32   */
 
@@ -96,11 +95,8 @@
  * #define MT2121_CNT  (3)
  */
 
-#define MT2063_CNT (1)
 
-#if !defined( MT2063_TUNER_CNT )
 #define MT2063_TUNER_CNT               (1)	/*  total num of MicroTuner tuners  */
-#endif
 #define MT2063_I2C (0xC0)
 
 u32 MT2063_WriteSub(void *hUserData,
@@ -113,11 +109,7 @@ u32 MT2063_ReadSub(void *hUserData,
 
 void MT2063_Sleep(void *hUserData, u32 nMinDelayTime);
 
-#if defined(MT2060_CNT)
-#if MT2060_CNT > 0
 u32 MT2060_TunerGain(void *hUserData, s32 * pMeas);
-#endif
-#endif
 
 /*
  *  Constant defining the version of the following structure
-- 
1.7.7.5

