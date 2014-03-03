Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49391 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaCCKH6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:58 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 09/79] [media] drx-j: get rid of the other typedefs at bsp_types.h
Date: Mon,  3 Mar 2014 07:06:03 -0300
Message-Id: <1393841233-24840-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Most of the work were done by those small scripts:

for i in *; do sed s,pDRXFrequency_t,"s32 *",g <$i >a && mv a $i; done
for i in *; do sed s,DRXFrequency_t,"s32",g <$i >a && mv a $i; done
for i in *; do sed s,pDRXSymbolrate_t,"u32 *",g <$i >a && mv a $i; done
for i in *; do sed s,DRXSymbolrate_t,"u32",g <$i >a && mv a $i; done
for i in *; do sed s,FALSE,false,g <$i >a && mv a $i; done
for i in *; do sed s,TRUE,true,g <$i >a && mv a $i; done
for i in *; do sed s,Bool_t,bool,g <$i >a && mv a $i; done
for i in *; do sed s,pbool,"bool *",g <$i >a && mv a $i; done

The only remaining things there are the return values.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h   |   24 +-
 drivers/media/dvb-frontends/drx39xyj/bsp_types.h   |   87 --
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |   14 +-
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |    6 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  130 +--
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  146 +--
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 1002 ++++++++++----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   72 +-
 drivers/media/dvb-frontends/drx39xyj/drxj_map.h    |    8 +-
 9 files changed, 701 insertions(+), 788 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
index 12676de6aafa..2028506dbba7 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
@@ -94,19 +94,19 @@ TYPEDEFS
 	typedef struct {
 
 		char *name;	/* Tuner brand & type name */
-		DRXFrequency_t minFreqRF;	/* Lowest  RF input frequency, in kHz */
-		DRXFrequency_t maxFreqRF;	/* Highest RF input frequency, in kHz */
+		s32 minFreqRF;	/* Lowest  RF input frequency, in kHz */
+		s32 maxFreqRF;	/* Highest RF input frequency, in kHz */
 
 		u8 subMode;	/* Index to sub-mode in use */
 		pTUNERSubMode_t subModeDescriptions;	/* Pointer to description of sub-modes */
 		u8 subModes;	/* Number of available sub-modes      */
 
-		/* The following fields will be either 0, NULL or FALSE and do not need
+		/* The following fields will be either 0, NULL or false and do not need
 		   initialisation */
 		void *selfCheck;	/* gives proof of initialization  */
-		Bool_t programmed;	/* only valid if selfCheck is OK  */
-		DRXFrequency_t RFfrequency;	/* only valid if programmed       */
-		DRXFrequency_t IFfrequency;	/* only valid if programmed       */
+		bool programmed;	/* only valid if selfCheck is OK  */
+		s32 RFfrequency;	/* only valid if programmed       */
+		s32 IFfrequency;	/* only valid if programmed       */
 
 		void *myUserData;	/* pointer to associated demod instance */
 		u16 myCapabilities;	/* value for storing application flags  */
@@ -123,14 +123,14 @@ TYPEDEFS
 
 	typedef DRXStatus_t(*TUNERSetFrequencyFunc_t) (pTUNERInstance_t tuner,
 						       TUNERMode_t mode,
-						       DRXFrequency_t
+						       s32
 						       frequency);
 
 	typedef DRXStatus_t(*TUNERGetFrequencyFunc_t) (pTUNERInstance_t tuner,
 						       TUNERMode_t mode,
-						       pDRXFrequency_t
+						       s32 *
 						       RFfrequency,
-						       pDRXFrequency_t
+						       s32 *
 						       IFfrequency);
 
 	typedef DRXStatus_t(*TUNERLockStatusFunc_t) (pTUNERInstance_t tuner,
@@ -182,12 +182,12 @@ Exported FUNCTIONS
 
 	DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
 					      TUNERMode_t mode,
-					      DRXFrequency_t frequency);
+					      s32 frequency);
 
 	DRXStatus_t DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
 					      TUNERMode_t mode,
-					      pDRXFrequency_t RFfrequency,
-					      pDRXFrequency_t IFfrequency);
+					      s32 *RFfrequency,
+					      s32 *IFfrequency);
 
 	DRXStatus_t DRXBSP_TUNER_LockStatus(pTUNERInstance_t tuner,
 					    pTUNERLockStatus_t lockStat);
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
index 2f5a2ba9ba2f..c65a475997aa 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
@@ -28,88 +28,15 @@
   POSSIBILITY OF SUCH DAMAGE.
 */
 
-/**
-* \file $Id: bsp_types.h,v 1.5 2009/08/06 12:55:57 carlo Exp $
-*
-* \brief General type definitions for board support packages
-*
-* This file contains type definitions that are needed for almost any
-* board support package.
-* The definitions are host and project independent.
-*
-*/
-
 #include <linux/kernel.h>
 
 #ifndef __BSP_TYPES_H__
 #define __BSP_TYPES_H__
-/*-------------------------------------------------------------------------
-INCLUDES
--------------------------------------------------------------------------*/
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-/*-------------------------------------------------------------------------
-TYPEDEFS
--------------------------------------------------------------------------*/
-
-/**
-* \typedef s32 DRXFrequency_t
-* \brief type definition of frequency
-*/
-	typedef s32 DRXFrequency_t;
-
-/**
-* \typedef DRXFrequency_t *pDRXFrequency_t
-* \brief type definition of a pointer to a frequency
-*/
-	typedef DRXFrequency_t *pDRXFrequency_t;
-
-/**
-* \typedef u32 DRXSymbolrate_t
-* \brief type definition of symbol rate
-*/
-	typedef u32 DRXSymbolrate_t;
-
-/**
-* \typedef DRXSymbolrate_t *pDRXSymbolrate_t
-* \brief type definition of a pointer to a symbol rate
-*/
-	typedef DRXSymbolrate_t *pDRXSymbolrate_t;
-
-/*-------------------------------------------------------------------------
-DEFINES
--------------------------------------------------------------------------*/
-/**
-* \def NULL
-* \brief Define NULL for target.
-*/
-#ifndef NULL
-#define NULL            (0)
-#endif
 
 /*-------------------------------------------------------------------------
 ENUM
 -------------------------------------------------------------------------*/
 
-/*
-* Boolean datatype. Only define if not already defined TRUE or FALSE.
-*/
-#if defined (TRUE) || defined (FALSE)
-	typedef int Bool_t;
-#else
-/**
-* \enum Bool_t
-* \brief Boolean type
-*/
-	typedef enum {
-		FALSE = 0,
-		TRUE
-	} Bool_t;
-#endif
-	typedef Bool_t *pBool_t;
-
 /**
 * \enum DRXStatus_t
 * \brief Various return statusses
@@ -125,18 +52,4 @@ ENUM
 				    /**< unavailable functionality   */
 	} DRXStatus_t, *pDRXStatus_t;
 
-/*-------------------------------------------------------------------------
-STRUCTS
--------------------------------------------------------------------------*/
-
-/**
-Exported FUNCTIONS
--------------------------------------------------------------------------*/
-
-/*-------------------------------------------------------------------------
-THE END
--------------------------------------------------------------------------*/
-#ifdef __cplusplus
-}
-#endif
 #endif				/* __BSP_TYPES_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 1ccb9921e9fa..bce41f4b8015 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -242,7 +242,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	}
 	/* Just for giggles, let's shut off the LNA again.... */
 	uioData.uio = DRX_UIO1;
-	uioData.value = FALSE;
+	uioData.value = false;
 	result = DRX_Ctrl(demod, DRX_CTRL_UIO_WRITE, &uioData);
 	if (result != DRX_STS_OK) {
 		printk(KERN_ERR "Failed to disable LNA!\n");
@@ -271,7 +271,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
-	Bool_t i2c_gate_state;
+	bool i2c_gate_state;
 	DRXStatus_t result;
 
 #ifdef DJH_DEBUG
@@ -280,9 +280,9 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 #endif
 
 	if (enable)
-		i2c_gate_state = TRUE;
+		i2c_gate_state = true;
 	else
-		i2c_gate_state = FALSE;
+		i2c_gate_state = false;
 
 	if (state->i2c_gate_open == enable) {
 		/* We're already in the desired state */
@@ -371,9 +371,9 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	       sizeof(DRXCommonAttr_t));
 	demod->myCommonAttr->microcode = DRXJ_MC_MAIN;
 #if 0
-	demod->myCommonAttr->verifyMicrocode = FALSE;
+	demod->myCommonAttr->verifyMicrocode = false;
 #endif
-	demod->myCommonAttr->verifyMicrocode = TRUE;
+	demod->myCommonAttr->verifyMicrocode = true;
 	demod->myCommonAttr->intermediateFreq = 5000;
 
 	demod->myExtAttr = demodExtAttr;
@@ -401,7 +401,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	}
 
 	uioData.uio = DRX_UIO1;
-	uioData.value = FALSE;
+	uioData.value = false;
 	result = DRX_Ctrl(demod, DRX_CTRL_UIO_WRITE, &uioData);
 	if (result != DRX_STS_OK) {
 		printk(KERN_ERR "Failed to disable LNA!\n");
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 35cef0f46934..854823eac312 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -25,7 +25,7 @@ DRXStatus_t DRXBSP_TUNER_Close(pTUNERInstance_t tuner)
 
 DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
 				      TUNERMode_t mode,
-				      DRXFrequency_t centerFrequency)
+				      s32 centerFrequency)
 {
 	return DRX_STS_OK;
 }
@@ -33,8 +33,8 @@ DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
 DRXStatus_t
 DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
 			  TUNERMode_t mode,
-			  pDRXFrequency_t RFfrequency,
-			  pDRXFrequency_t IFfrequency)
+			  s32 *RFfrequency,
+			  s32 *IFfrequency)
 {
 	return DRX_STS_OK;
 }
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index ea43f14936b0..1d554f283de2 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -149,7 +149,7 @@ FUNCTIONS
 static DRXStatus_t
 ScanFunctionDefault(void *scanContext,
 		    DRXScanCommand_t scanCommand,
-		    pDRXChannel_t scanChannel, pBool_t getNextChannel);
+		    pDRXChannel_t scanChannel, bool * getNextChannel);
 
 /**
 * \brief Get pointer to scanning function.
@@ -212,9 +212,9 @@ void *GetScanContext(pDRXDemodInstance_t demod, void *scanContext)
 * In case DRX_NEVER_LOCK is returned the poll-wait will be aborted.
 *
 */
-static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, pBool_t isLocked)
+static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, bool * isLocked)
 {
-	Bool_t doneWaiting = FALSE;
+	bool doneWaiting = false;
 	DRXLockStatus_t lockState = DRX_NOT_LOCKED;
 	DRXLockStatus_t desiredLockState = DRX_NOT_LOCKED;
 	u32 timeoutValue = 0;
@@ -222,13 +222,13 @@ static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, pBool_t isLocked)
 	u32 currentTime = 0;
 	u32 timerValue = 0;
 
-	*isLocked = FALSE;
+	*isLocked = false;
 	timeoutValue = (u32) demod->myCommonAttr->scanDemodLockTimeout;
 	desiredLockState = demod->myCommonAttr->scanDesiredLock;
 	startTimeLockStage = DRXBSP_HST_Clock();
 
 	/* Start polling loop, checking for lock & timeout */
-	while (doneWaiting == FALSE) {
+	while (doneWaiting == false) {
 
 		if (DRX_Ctrl(demod, DRX_CTRL_LOCK_STATUS, &lockState) !=
 		    DRX_STS_OK) {
@@ -238,15 +238,15 @@ static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, pBool_t isLocked)
 
 		timerValue = currentTime - startTimeLockStage;
 		if (lockState >= desiredLockState) {
-			*isLocked = TRUE;
-			doneWaiting = TRUE;
+			*isLocked = true;
+			doneWaiting = true;
 		} /* if ( lockState >= desiredLockState ) .. */
 		else if (lockState == DRX_NEVER_LOCK) {
-			doneWaiting = TRUE;
+			doneWaiting = true;
 		} /* if ( lockState == DRX_NEVER_LOCK ) .. */
 		else if (timerValue > timeoutValue) {
 			/* lockState == DRX_NOT_LOCKED  and timeout */
-			doneWaiting = TRUE;
+			doneWaiting = true;
 		} else {
 			if (DRXBSP_HST_Sleep(10) != DRX_STS_OK) {
 				return DRX_STS_ERROR;
@@ -274,15 +274,15 @@ static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, pBool_t isLocked)
 *
 */
 static DRXStatus_t
-ScanPrepareNextScan(pDRXDemodInstance_t demod, DRXFrequency_t skip)
+ScanPrepareNextScan(pDRXDemodInstance_t demod, s32 skip)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	u16 tableIndex = 0;
 	u16 frequencyPlanSize = 0;
 	pDRXFrequencyPlan_t frequencyPlan = (pDRXFrequencyPlan_t) (NULL);
-	DRXFrequency_t nextFrequency = 0;
-	DRXFrequency_t tunerMinFrequency = 0;
-	DRXFrequency_t tunerMaxFrequency = 0;
+	s32 nextFrequency = 0;
+	s32 tunerMinFrequency = 0;
+	s32 tunerMaxFrequency = 0;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 	tableIndex = commonAttr->scanFreqPlanIndex;
@@ -317,17 +317,17 @@ ScanPrepareNextScan(pDRXDemodInstance_t demod, DRXFrequency_t skip)
 			    commonAttr->scanParam->frequencyPlanSize;
 			if (tableIndex >= frequencyPlanSize) {
 				/* reached end of frequency plan */
-				commonAttr->scanReady = TRUE;
+				commonAttr->scanReady = true;
 			} else {
 				nextFrequency = frequencyPlan[tableIndex].first;
 			}
 		}
 		if (nextFrequency > (tunerMaxFrequency)) {
 			/* reached end of tuner range */
-			commonAttr->scanReady = TRUE;
+			commonAttr->scanReady = true;
 		}
 	} while ((nextFrequency < tunerMinFrequency) &&
-		 (commonAttr->scanReady == FALSE));
+		 (commonAttr->scanReady == false));
 
 	/* Store new values */
 	commonAttr->scanFreqPlanIndex = tableIndex;
@@ -344,7 +344,7 @@ ScanPrepareNextScan(pDRXDemodInstance_t demod, DRXFrequency_t skip)
 * \param demod:          Pointer to demodulator instance.
 * \param scanCommand:    Scanning command: INIT, NEXT or STOP.
 * \param scanChannel:    Channel to check: frequency and bandwidth, others AUTO
-* \param getNextChannel: Return TRUE if next frequency is desired at next call
+* \param getNextChannel: Return true if next frequency is desired at next call
 *
 * \return DRXStatus_t.
 * \retval DRX_STS_OK:      Channel found, DRX_CTRL_GET_CHANNEL can be used
@@ -357,11 +357,11 @@ ScanPrepareNextScan(pDRXDemodInstance_t demod, DRXFrequency_t skip)
 static DRXStatus_t
 ScanFunctionDefault(void *scanContext,
 		    DRXScanCommand_t scanCommand,
-		    pDRXChannel_t scanChannel, pBool_t getNextChannel)
+		    pDRXChannel_t scanChannel, bool * getNextChannel)
 {
 	pDRXDemodInstance_t demod = NULL;
 	DRXStatus_t status = DRX_STS_ERROR;
-	Bool_t isLocked = FALSE;
+	bool isLocked = false;
 
 	demod = (pDRXDemodInstance_t) scanContext;
 
@@ -370,7 +370,7 @@ ScanFunctionDefault(void *scanContext,
 		return DRX_STS_OK;
 	}
 
-	*getNextChannel = FALSE;
+	*getNextChannel = false;
 
 	status = DRX_Ctrl(demod, DRX_CTRL_SET_CHANNEL, scanChannel);
 	if (status != DRX_STS_OK) {
@@ -383,9 +383,9 @@ ScanFunctionDefault(void *scanContext,
 	}
 
 	/* done with this channel, move to next one */
-	*getNextChannel = TRUE;
+	*getNextChannel = true;
 
-	if (isLocked == FALSE) {
+	if (isLocked == false) {
 		/* no channel found */
 		return DRX_STS_BUSY;
 	}
@@ -417,14 +417,14 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 {
 	DRXStatus_t status = DRX_STS_ERROR;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	DRXFrequency_t maxTunerFreq = 0;
-	DRXFrequency_t minTunerFreq = 0;
+	s32 maxTunerFreq = 0;
+	s32 minTunerFreq = 0;
 	u16 nrChannelsInPlan = 0;
 	u16 i = 0;
 	void *scanContext = NULL;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
-	commonAttr->scanActive = TRUE;
+	commonAttr->scanActive = true;
 
 	/* invalidate a previous SCAN_INIT */
 	commonAttr->scanParam = (pDRXScanParam_t) (NULL);
@@ -438,7 +438,7 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 	    (scanParam->frequencyPlan == NULL) ||
 	    (scanParam->frequencyPlanSize == 0)
 	    ) {
-		commonAttr->scanActive = FALSE;
+		commonAttr->scanActive = false;
 		return DRX_STS_INVALID_ARG;
 	}
 
@@ -446,22 +446,22 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 	maxTunerFreq = commonAttr->tunerMaxFreqRF;
 	minTunerFreq = commonAttr->tunerMinFreqRF;
 	for (i = 0; i < (scanParam->frequencyPlanSize); i++) {
-		DRXFrequency_t width = 0;
-		DRXFrequency_t step = scanParam->frequencyPlan[i].step;
-		DRXFrequency_t firstFreq = scanParam->frequencyPlan[i].first;
-		DRXFrequency_t lastFreq = scanParam->frequencyPlan[i].last;
-		DRXFrequency_t minFreq = 0;
-		DRXFrequency_t maxFreq = 0;
+		s32 width = 0;
+		s32 step = scanParam->frequencyPlan[i].step;
+		s32 firstFreq = scanParam->frequencyPlan[i].first;
+		s32 lastFreq = scanParam->frequencyPlan[i].last;
+		s32 minFreq = 0;
+		s32 maxFreq = 0;
 
 		if (step <= 0) {
 			/* Step must be positive and non-zero */
-			commonAttr->scanActive = FALSE;
+			commonAttr->scanActive = false;
 			return DRX_STS_INVALID_ARG;
 		}
 
 		if (firstFreq > lastFreq) {
 			/* First center frequency is higher than last center frequency */
-			commonAttr->scanActive = FALSE;
+			commonAttr->scanActive = false;
 			return DRX_STS_INVALID_ARG;
 		}
 
@@ -470,7 +470,7 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 		if ((width % step) != 0) {
 			/* Difference between last and first center frequency is not
 			   an integer number of steps */
-			commonAttr->scanActive = FALSE;
+			commonAttr->scanActive = false;
 			return DRX_STS_INVALID_ARG;
 		}
 
@@ -480,7 +480,7 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 				if (firstFreq >= minTunerFreq) {
 					minFreq = firstFreq;
 				} else {
-					DRXFrequency_t n = 0;
+					s32 n = 0;
 
 					n = (minTunerFreq - firstFreq) / step;
 					if (((minTunerFreq -
@@ -493,7 +493,7 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 				if (lastFreq <= maxTunerFreq) {
 					maxFreq = lastFreq;
 				} else {
-					DRXFrequency_t n = 0;
+					s32 n = 0;
 
 					n = (lastFreq - maxTunerFreq) / step;
 					if (((lastFreq -
@@ -522,12 +522,12 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 
 	if (nrChannelsInPlan == 0) {
 		/* Tuner range and frequency plan ranges do not overlap */
-		commonAttr->scanActive = FALSE;
+		commonAttr->scanActive = false;
 		return DRX_STS_ERROR;
 	}
 
 	/* Store parameters */
-	commonAttr->scanReady = FALSE;
+	commonAttr->scanReady = false;
 	commonAttr->scanMaxChannels = nrChannelsInPlan;
 	commonAttr->scanChannelsScanned = 0;
 	commonAttr->scanParam = scanParam;	/* SCAN_NEXT is now allowed */
@@ -537,7 +537,7 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 	status = (*(GetScanFunction(demod)))
 	    (scanContext, DRX_SCAN_COMMAND_INIT, NULL, NULL);
 
-	commonAttr->scanActive = FALSE;
+	commonAttr->scanActive = false;
 
 	return DRX_STS_OK;
 }
@@ -559,12 +559,12 @@ static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
 	void *scanContext = NULL;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
-	commonAttr->scanActive = TRUE;
+	commonAttr->scanActive = true;
 
 	if ((commonAttr->scanParam == NULL) ||
 	    (commonAttr->scanMaxChannels == 0)) {
 		/* Scan was not running, just return OK */
-		commonAttr->scanActive = FALSE;
+		commonAttr->scanActive = false;
 		return DRX_STS_OK;
 	}
 
@@ -577,7 +577,7 @@ static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
 	/* All done, invalidate scan-init */
 	commonAttr->scanParam = NULL;
 	commonAttr->scanMaxChannels = 0;
-	commonAttr->scanActive = FALSE;
+	commonAttr->scanActive = false;
 
 	return status;
 }
@@ -605,7 +605,7 @@ static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
 static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	pBool_t scanReady = (pBool_t) (NULL);
+	bool * scanReady = (bool *) (NULL);
 	u16 maxProgress = DRX_SCAN_MAX_PROGRESS;
 	u32 numTries = 0;
 	u32 i = 0;
@@ -614,16 +614,16 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 
 	/* Check scan parameters */
 	if (scanProgress == NULL) {
-		commonAttr->scanActive = FALSE;
+		commonAttr->scanActive = false;
 		return DRX_STS_INVALID_ARG;
 	}
 
 	*scanProgress = 0;
-	commonAttr->scanActive = TRUE;
+	commonAttr->scanActive = true;
 	if ((commonAttr->scanParam == NULL) ||
 	    (commonAttr->scanMaxChannels == 0)) {
 		/* CtrlScanInit() was not called succesfully before CtrlScanNext() */
-		commonAttr->scanActive = FALSE;
+		commonAttr->scanActive = false;
 		return DRX_STS_ERROR;
 	}
 
@@ -635,11 +635,11 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 	numTries = commonAttr->scanParam->numTries;
 	scanReady = &(commonAttr->scanReady);
 
-	for (i = 0; ((i < numTries) && ((*scanReady) == FALSE)); i++) {
+	for (i = 0; ((i < numTries) && ((*scanReady) == false)); i++) {
 		DRXChannel_t scanChannel = { 0 };
 		DRXStatus_t status = DRX_STS_ERROR;
 		pDRXFrequencyPlan_t freqPlan = (pDRXFrequencyPlan_t) (NULL);
-		Bool_t nextChannel = FALSE;
+		bool nextChannel = false;
 		void *scanContext = NULL;
 
 		/* Next channel to scan */
@@ -671,9 +671,9 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 		     &nextChannel);
 
 		/* Proceed to next channel if requested */
-		if (nextChannel == TRUE) {
+		if (nextChannel == true) {
 			DRXStatus_t nextStatus = DRX_STS_ERROR;
-			DRXFrequency_t skip = 0;
+			s32 skip = 0;
 
 			if (status == DRX_STS_OK) {
 				/* a channel was found, so skip some frequency steps */
@@ -688,25 +688,25 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 				     (commonAttr->scanMaxChannels));
 
 			if (nextStatus != DRX_STS_OK) {
-				commonAttr->scanActive = FALSE;
+				commonAttr->scanActive = false;
 				return (nextStatus);
 			}
 		}
 		if (status != DRX_STS_BUSY) {
 			/* channel found or error */
-			commonAttr->scanActive = FALSE;
+			commonAttr->scanActive = false;
 			return status;
 		}
 	}			/* for ( i = 0; i < ( ... numTries); i++) */
 
-	if ((*scanReady) == TRUE) {
+	if ((*scanReady) == true) {
 		/* End of scan reached: call stop-scan, ignore any error */
 		CtrlScanStop(demod);
-		commonAttr->scanActive = FALSE;
+		commonAttr->scanActive = false;
 		return (DRX_STS_READY);
 	}
 
-	commonAttr->scanActive = FALSE;
+	commonAttr->scanActive = false;
 
 	return DRX_STS_BUSY;
 }
@@ -735,8 +735,8 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	TUNERMode_t tunerMode = 0;
 	DRXStatus_t status = DRX_STS_ERROR;
-	DRXFrequency_t ifFrequency = 0;
-	Bool_t tunerSlowMode = FALSE;
+	s32 ifFrequency = 0;
+	bool tunerSlowMode = false;
 
 	/* can't tune without a tuner */
 	if (demod->myTuner == NULL) {
@@ -782,7 +782,7 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	}
 
 	if (commonAttr->tunerPortNr == 1) {
-		Bool_t bridgeClosed = TRUE;
+		bool bridgeClosed = true;
 		DRXStatus_t statusBridge = DRX_STS_ERROR;
 
 		statusBridge =
@@ -797,7 +797,7 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 
 	/* attempt restoring bridge before checking status of SetFrequency */
 	if (commonAttr->tunerPortNr == 1) {
-		Bool_t bridgeClosed = FALSE;
+		bool bridgeClosed = false;
 		DRXStatus_t statusBridge = DRX_STS_ERROR;
 
 		statusBridge =
@@ -1315,14 +1315,14 @@ DRXStatus_t DRX_Open(pDRXDemodInstance_t demod)
 	    (demod->myCommonAttr == NULL) ||
 	    (demod->myExtAttr == NULL) ||
 	    (demod->myI2CDevAddr == NULL) ||
-	    (demod->myCommonAttr->isOpened == TRUE)) {
+	    (demod->myCommonAttr->isOpened == true)) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
 	status = (*(demod->myDemodFunct->openFunc)) (demod);
 
 	if (status == DRX_STS_OK) {
-		demod->myCommonAttr->isOpened = TRUE;
+		demod->myCommonAttr->isOpened = true;
 	}
 
 	return status;
@@ -1352,13 +1352,13 @@ DRXStatus_t DRX_Close(pDRXDemodInstance_t demod)
 	    (demod->myCommonAttr == NULL) ||
 	    (demod->myExtAttr == NULL) ||
 	    (demod->myI2CDevAddr == NULL) ||
-	    (demod->myCommonAttr->isOpened == FALSE)) {
+	    (demod->myCommonAttr->isOpened == false)) {
 		return DRX_STS_INVALID_ARG;
 	}
 
 	status = (*(demod->myDemodFunct->closeFunc)) (demod);
 
-	DRX_SET_ISOPENED(demod, FALSE);
+	DRX_SET_ISOPENED(demod, false);
 
 	return status;
 }
@@ -1396,7 +1396,7 @@ DRX_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	if (((demod->myCommonAttr->isOpened == FALSE) &&
+	if (((demod->myCommonAttr->isOpened == false) &&
 	     (ctrl != DRX_CTRL_PROBE_DEVICE) && (ctrl != DRX_CTRL_VERSION))
 	    ) {
 		return (DRX_STS_INVALID_ARG);
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 8f0f2edbb733..12e7770448cb 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -274,17 +274,17 @@ MACROS
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
 #define DRX_S24TODRXFREQ(x) ( ( ( (u32) x ) & 0x00800000UL ) ? \
-				 (  (DRXFrequency_t) \
+				 (  (s32) \
 				    ( ( (u32) x ) | 0xFF000000 ) ) : \
-				 ( (DRXFrequency_t) x ) )
+				 ( (s32) x ) )
 
 /**
-* \brief Macro to convert 16 bit register value to a DRXFrequency_t
+* \brief Macro to convert 16 bit register value to a s32
 */
 #define DRX_U16TODRXFREQ(x)   (  ( x & 0x8000 ) ? \
-				 (  (DRXFrequency_t) \
+				 (  (s32) \
 				    ( ( (u32) x ) | 0xFFFF0000 ) ) : \
-				 ( (DRXFrequency_t) x ) )
+				 ( (s32) x ) )
 
 /*-------------------------------------------------------------------------
 ENUM
@@ -883,7 +883,7 @@ STRUCTS
 *
 */
 	typedef struct {
-		DRXFrequency_t frequency;
+		s32 frequency;
 					/**< frequency in kHz                 */
 		DRXBandwidth_t bandwidth;
 					/**< bandwidth                        */
@@ -898,7 +898,7 @@ STRUCTS
 		DRXFftmode_t fftmode;	/**< fftmode                          */
 		DRXClassification_t classification;
 					/**< classification                   */
-		DRXSymbolrate_t symbolrate;
+		u32 symbolrate;
 					/**< symbolrate in symbols/sec        */
 		DRXInterleaveModes_t interleavemode;
 					/**< interleaveMode QAM               */
@@ -967,11 +967,11 @@ STRUCTS
 * Used by DRX_CTRL_SCAN_INIT.
 */
 	typedef struct {
-		DRXFrequency_t first;
+		s32 first;
 			     /**< First centre frequency in this band        */
-		DRXFrequency_t last;
+		s32 last;
 			     /**< Last centre frequency in this band         */
-		DRXFrequency_t step;
+		s32 step;
 			     /**< Stepping frequency in this band            */
 		DRXBandwidth_t bandwidth;
 			     /**< Bandwidth within this frequency band       */
@@ -1037,7 +1037,7 @@ STRUCTS
 					  /**< Frequency plan (array)*/
 		u16 frequencyPlanSize;  /**< Number of bands       */
 		u32 numTries;		  /**< Max channels tried    */
-		DRXFrequency_t skip;	  /**< Minimum frequency step to take
+		s32 skip;	  /**< Minimum frequency step to take
 						after a channel is found */
 		void *extParams;	  /**< Standard specific params */
 	} DRXScanParam_t, *pDRXScanParam_t;
@@ -1062,7 +1062,7 @@ STRUCTS
 	typedef DRXStatus_t(*DRXScanFunc_t) (void *scanContext,
 					     DRXScanCommand_t scanCommand,
 					     pDRXChannel_t scanChannel,
-					     pBool_t getNextChannel);
+					     bool * getNextChannel);
 
 /*========================================*/
 
@@ -1208,8 +1208,8 @@ STRUCTS
 	typedef struct {
 		DRXUIO_t uio;
 		   /**< UIO identifier              */
-		Bool_t value;
-		   /**< UIO value (TRUE=1, FALSE=0) */
+		bool value;
+		   /**< UIO value (true=1, false=0) */
 	} DRXUIOData_t, *pDRXUIOData_t;
 
 /*========================================*/
@@ -1220,10 +1220,10 @@ STRUCTS
 * Used by DRX_CTRL_SET_OOB.
 */
 	typedef struct {
-		DRXFrequency_t frequency;	   /**< Frequency in kHz      */
+		s32 frequency;	   /**< Frequency in kHz      */
 		DRXOOBDownstreamStandard_t standard;
 						   /**< OOB standard          */
-		Bool_t spectrumInverted;	   /**< If TRUE, then spectrum
+		bool spectrumInverted;	   /**< If true, then spectrum
 							 is inverted          */
 	} DRXOOB_t, *pDRXOOB_t;
 
@@ -1235,7 +1235,7 @@ STRUCTS
 * Used by DRX_CTRL_GET_OOB.
 */
 	typedef struct {
-		DRXFrequency_t frequency; /**< Frequency in Khz         */
+		s32 frequency; /**< Frequency in Khz         */
 		DRXLockStatus_t lock;	  /**< Lock status              */
 		u32 mer;		  /**< MER                      */
 		s32 symbolRateOffset;	  /**< Symbolrate offset in ppm */
@@ -1278,16 +1278,16 @@ STRUCTS
 */
 
 	typedef struct {
-		Bool_t enableMPEGOutput;/**< If TRUE, enable MPEG output      */
-		Bool_t insertRSByte;	/**< If TRUE, insert RS byte          */
-		Bool_t enableParallel;	/**< If TRUE, parallel out otherwise
+		bool enableMPEGOutput;/**< If true, enable MPEG output      */
+		bool insertRSByte;	/**< If true, insert RS byte          */
+		bool enableParallel;	/**< If true, parallel out otherwise
 								     serial   */
-		Bool_t invertDATA;	/**< If TRUE, invert DATA signals     */
-		Bool_t invertERR;	/**< If TRUE, invert ERR signal       */
-		Bool_t invertSTR;	/**< If TRUE, invert STR signals      */
-		Bool_t invertVAL;	/**< If TRUE, invert VAL signals      */
-		Bool_t invertCLK;	/**< If TRUE, invert CLK signals      */
-		Bool_t staticCLK;	/**< If TRUE, static MPEG clockrate
+		bool invertDATA;	/**< If true, invert DATA signals     */
+		bool invertERR;	/**< If true, invert ERR signal       */
+		bool invertSTR;	/**< If true, invert STR signals      */
+		bool invertVAL;	/**< If true, invert VAL signals      */
+		bool invertCLK;	/**< If true, invert CLK signals      */
+		bool staticCLK;	/**< If true, static MPEG clockrate
 					     will be used, otherwise clockrate
 					     will adapt to the bitrate of the
 					     TS                               */
@@ -1314,7 +1314,7 @@ STRUCTS
 	typedef struct {
 		DRXCfgSMAIO_t io;
 		u16 ctrlData;
-		Bool_t smartAntInverted;
+		bool smartAntInverted;
 	} DRXCfgSMA_t, *pDRXCfgSMA_t;
 
 /*========================================*/
@@ -1391,11 +1391,11 @@ STRUCTS
 * \brief Audio status characteristics.
 */
 	typedef struct {
-		Bool_t stereo;		  /**< stereo detection               */
-		Bool_t carrierA;	  /**< carrier A detected             */
-		Bool_t carrierB;	  /**< carrier B detected             */
-		Bool_t sap;		  /**< sap / bilingual detection      */
-		Bool_t rds;		  /**< RDS data array present         */
+		bool stereo;		  /**< stereo detection               */
+		bool carrierA;	  /**< carrier A detected             */
+		bool carrierB;	  /**< carrier B detected             */
+		bool sap;		  /**< sap / bilingual detection      */
+		bool rds;		  /**< RDS data array present         */
 		DRXAudNICAMStatus_t nicamStatus;
 					  /**< status of NICAM carrier        */
 		s8 fmIdent;		  /**< FM Identification value        */
@@ -1408,7 +1408,7 @@ STRUCTS
 * \brief Raw RDS data array.
 */
 	typedef struct {
-		Bool_t valid;		  /**< RDS data validation            */
+		bool valid;		  /**< RDS data validation            */
 		u16 data[18];		  /**< data from one RDS data array   */
 	} DRXCfgAudRDS_t, *pDRXCfgAudRDS_t;
 
@@ -1451,7 +1451,7 @@ STRUCTS
 * \brief Audio volume configuration.
 */
 	typedef struct {
-		Bool_t mute;		  /**< mute overrides volume setting  */
+		bool mute;		  /**< mute overrides volume setting  */
 		s16 volume;		  /**< volume, range -114 to 12 dB    */
 		DRXAudAVCMode_t avcMode;  /**< AVC auto volume control mode   */
 		u16 avcRefLevel;	  /**< AVC reference level            */
@@ -1507,7 +1507,7 @@ STRUCTS
 * \brief I2S output configuration.
 */
 	typedef struct {
-		Bool_t outputEnable;	  /**< I2S output enable              */
+		bool outputEnable;	  /**< I2S output enable              */
 		u32 frequency;	  /**< range from 8000-48000 Hz       */
 		DRXI2SMode_t mode;	  /**< I2S mode, master or slave      */
 		DRXI2SWordLength_t wordLength;
@@ -1575,8 +1575,8 @@ STRUCTS
 	typedef struct {
 		u16 thres;	/* carrier detetcion threshold for primary carrier (A) */
 		DRXNoCarrierOption_t opt;	/* Mute or noise at no carrier detection (A) */
-		DRXFrequency_t shift;	/* DC level of incoming signal (A) */
-		DRXFrequency_t dco;	/* frequency adjustment (A) */
+		s32 shift;	/* DC level of incoming signal (A) */
+		s32 dco;	/* frequency adjustment (A) */
 	} DRXAudCarrier_t, *pDRXCfgAudCarrier_t;
 
 /**
@@ -1668,7 +1668,7 @@ STRUCTS
 	typedef struct {
 		s16 volume;	/* dB */
 		u16 frequency;	/* Hz */
-		Bool_t mute;
+		bool mute;
 	} DRXAudBeep_t, *pDRXAudBeep_t;
 
 /**
@@ -1686,7 +1686,7 @@ STRUCTS
 */
 	typedef struct {
 		/* audio storage */
-		Bool_t audioIsActive;
+		bool audioIsActive;
 		DRXAudStandard_t audioStandard;
 		DRXCfgI2SOutput_t i2sdata;
 		DRXCfgAudVolume_t volume;
@@ -1701,7 +1701,7 @@ STRUCTS
 		DRXAudBtscDetect_t btscDetect;
 		/* rds */
 		u16 rdsDataCounter;
-		Bool_t rdsDataPresent;
+		bool rdsDataPresent;
 	} DRXAudData_t, *pDRXAudData_t;
 
 /**
@@ -1838,37 +1838,37 @@ STRUCTS
 		u8 *microcode;   /**< Pointer to microcode image.           */
 		u16 microcodeSize;
 				   /**< Size of microcode image in bytes.     */
-		Bool_t verifyMicrocode;
+		bool verifyMicrocode;
 				   /**< Use microcode verify or not.          */
 		DRXMcVersionRec_t mcversion;
 				   /**< Version record of microcode from file */
 
 		/* Clocks and tuner attributes */
-		DRXFrequency_t intermediateFreq;
+		s32 intermediateFreq;
 				     /**< IF,if tuner instance not used. (kHz)*/
-		DRXFrequency_t sysClockFreq;
+		s32 sysClockFreq;
 				     /**< Systemclock frequency.  (kHz)       */
-		DRXFrequency_t oscClockFreq;
+		s32 oscClockFreq;
 				     /**< Oscillator clock frequency.  (kHz)  */
 		s16 oscClockDeviation;
 				     /**< Oscillator clock deviation.  (ppm)  */
-		Bool_t mirrorFreqSpect;
+		bool mirrorFreqSpect;
 				     /**< Mirror IF frequency spectrum or not.*/
 
 		/* Initial MPEG output attributes */
 		DRXCfgMPEGOutput_t mpegCfg;
 				     /**< MPEG configuration                  */
 
-		Bool_t isOpened;     /**< if TRUE instance is already opened. */
+		bool isOpened;     /**< if true instance is already opened. */
 
 		/* Channel scan */
 		pDRXScanParam_t scanParam;
 				      /**< scan parameters                    */
 		u16 scanFreqPlanIndex;
 				      /**< next index in freq plan            */
-		DRXFrequency_t scanNextFrequency;
+		s32 scanNextFrequency;
 				      /**< next freq to scan                  */
-		Bool_t scanReady;     /**< scan ready flag                    */
+		bool scanReady;     /**< scan ready flag                    */
 		u32 scanMaxChannels;/**< number of channels in freqplan     */
 		u32 scanChannelsScanned;
 					/**< number of channels scanned       */
@@ -1884,7 +1884,7 @@ STRUCTS
 				      /**< lock requirement for channel found */
 		/* scanActive can be used by SetChannel to decide how to program the tuner,
 		   fast or slow (but stable). Usually fast during scan. */
-		Bool_t scanActive;    /**< TRUE when scan routines are active */
+		bool scanActive;    /**< true when scan routines are active */
 
 		/* Power management */
 		DRXPowerMode_t currentPowerMode;
@@ -1892,13 +1892,13 @@ STRUCTS
 
 		/* Tuner */
 		u8 tunerPortNr;     /**< nr of I2C port to wich tuner is    */
-		DRXFrequency_t tunerMinFreqRF;
+		s32 tunerMinFreqRF;
 				      /**< minimum RF input frequency, in kHz */
-		DRXFrequency_t tunerMaxFreqRF;
+		s32 tunerMaxFreqRF;
 				      /**< maximum RF input frequency, in kHz */
-		Bool_t tunerRfAgcPol; /**< if TRUE invert RF AGC polarity     */
-		Bool_t tunerIfAgcPol; /**< if TRUE invert IF AGC polarity     */
-		Bool_t tunerSlowMode; /**< if TRUE invert IF AGC polarity     */
+		bool tunerRfAgcPol; /**< if true invert RF AGC polarity     */
+		bool tunerIfAgcPol; /**< if true invert IF AGC polarity     */
+		bool tunerSlowMode; /**< if true invert IF AGC polarity     */
 
 		DRXChannel_t currentChannel;
 				      /**< current channel parameters         */
@@ -1908,7 +1908,7 @@ STRUCTS
 				      /**< previous standard selection        */
 		DRXStandard_t diCacheStandard;
 				      /**< standard in DI cache if available  */
-		Bool_t useBootloader; /**< use bootloader in open             */
+		bool useBootloader; /**< use bootloader in open             */
 		u32 capabilities;   /**< capabilities flags                 */
 		u32 productId;      /**< product ID inc. metal fix number   */
 
@@ -2204,23 +2204,23 @@ Conversion from enum values to human readable form.
    ( x == DRX_AUD_STANDARD_UNKNOWN      )  ? "Unknown"                  : \
 					     "(Invalid)"  )
 #define DRX_STR_AUD_STEREO(x) ( \
-   ( x == TRUE                          )  ? "Stereo"           : \
-   ( x == FALSE                         )  ? "Mono"             : \
+   ( x == true                          )  ? "Stereo"           : \
+   ( x == false                         )  ? "Mono"             : \
 					     "(Invalid)"  )
 
 #define DRX_STR_AUD_SAP(x) ( \
-   ( x == TRUE                          )  ? "Present"          : \
-   ( x == FALSE                         )  ? "Not present"      : \
+   ( x == true                          )  ? "Present"          : \
+   ( x == false                         )  ? "Not present"      : \
 					     "(Invalid)"  )
 
 #define DRX_STR_AUD_CARRIER(x) ( \
-   ( x == TRUE                          )  ? "Present"          : \
-   ( x == FALSE                         )  ? "Not present"      : \
+   ( x == true                          )  ? "Present"          : \
+   ( x == false                         )  ? "Not present"      : \
 					     "(Invalid)"  )
 
 #define DRX_STR_AUD_RDS(x) ( \
-   ( x == TRUE                          )  ? "Available"        : \
-   ( x == FALSE                         )  ? "Not Available"    : \
+   ( x == true                          )  ? "Available"        : \
+   ( x == false                         )  ? "Not Available"    : \
 					     "(Invalid)"  )
 
 #define DRX_STR_AUD_NICAM_STATUS(x) ( \
@@ -2230,8 +2230,8 @@ Conversion from enum values to human readable form.
 					     "(Invalid)"  )
 
 #define DRX_STR_RDS_VALID(x) ( \
-   ( x == TRUE                          )  ? "Valid"            : \
-   ( x == FALSE                         )  ? "Not Valid"        : \
+   ( x == true                          )  ? "Valid"            : \
+   ( x == false                         )  ? "Not Valid"        : \
 					     "(Invalid)"  )
 
 /*-------------------------------------------------------------------------
@@ -2663,8 +2663,8 @@ Access macros
 
 /**
 * \brief Macro to check if std is an ATV standard
-* \retval TRUE std is an ATV standard
-* \retval FALSE std is an ATV standard
+* \retval true std is an ATV standard
+* \retval false std is an ATV standard
 */
 #define DRX_ISATVSTD( std ) ( ( (std) == DRX_STANDARD_PAL_SECAM_BG ) || \
 			      ( (std) == DRX_STANDARD_PAL_SECAM_DK ) || \
@@ -2676,8 +2676,8 @@ Access macros
 
 /**
 * \brief Macro to check if std is an QAM standard
-* \retval TRUE std is an QAM standards
-* \retval FALSE std is an QAM standards
+* \retval true std is an QAM standards
+* \retval false std is an QAM standards
 */
 #define DRX_ISQAMSTD( std ) ( ( (std) == DRX_STANDARD_ITU_A ) || \
 			      ( (std) == DRX_STANDARD_ITU_B ) || \
@@ -2686,15 +2686,15 @@ Access macros
 
 /**
 * \brief Macro to check if std is VSB standard
-* \retval TRUE std is VSB standard
-* \retval FALSE std is not VSB standard
+* \retval true std is VSB standard
+* \retval false std is not VSB standard
 */
 #define DRX_ISVSBSTD( std ) ( (std) == DRX_STANDARD_8VSB )
 
 /**
 * \brief Macro to check if std is DVBT standard
-* \retval TRUE std is DVBT standard
-* \retval FALSE std is not DVBT standard
+* \retval true std is DVBT standard
+* \retval false std is not DVBT standard
 */
 #define DRX_ISDVBTSTD( std ) ( (std) == DRX_STANDARD_DVBT )
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index b79154fb79c0..384b86951353 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -689,18 +689,18 @@ DRXDemodFunc_t DRXJFunctions_g = {
 };
 
 DRXJData_t DRXJData_g = {
-	FALSE,			/* hasLNA : TRUE if LNA (aka PGA) present      */
-	FALSE,			/* hasOOB : TRUE if OOB supported              */
-	FALSE,			/* hasNTSC: TRUE if NTSC supported             */
-	FALSE,			/* hasBTSC: TRUE if BTSC supported             */
-	FALSE,			/* hasSMATX: TRUE if SMA_TX pin is available   */
-	FALSE,			/* hasSMARX: TRUE if SMA_RX pin is available   */
-	FALSE,			/* hasGPIO : TRUE if GPIO pin is available     */
-	FALSE,			/* hasIRQN : TRUE if IRQN pin is available     */
+	false,			/* hasLNA : true if LNA (aka PGA) present      */
+	false,			/* hasOOB : true if OOB supported              */
+	false,			/* hasNTSC: true if NTSC supported             */
+	false,			/* hasBTSC: true if BTSC supported             */
+	false,			/* hasSMATX: true if SMA_TX pin is available   */
+	false,			/* hasSMARX: true if SMA_RX pin is available   */
+	false,			/* hasGPIO : true if GPIO pin is available     */
+	false,			/* hasIRQN : true if IRQN pin is available     */
 	0,			/* mfx A1/A2/A... */
 
 	/* tuner settings */
-	FALSE,			/* tuner mirrors RF signal    */
+	false,			/* tuner mirrors RF signal    */
 	/* standard/channel settings */
 	DRX_STANDARD_UNKNOWN,	/* current standard           */
 	DRX_CONSTELLATION_AUTO,	/* constellation              */
@@ -718,7 +718,7 @@ DRXJData_t DRXJData_g = {
 	204 * 8,		/* fecRsPlen annex A */
 	1,			/* fecRsPrescale     */
 	FEC_RS_MEASUREMENT_PERIOD,	/* fecRsPeriod     */
-	TRUE,			/* resetPktErrAcc    */
+	true,			/* resetPktErrAcc    */
 	0,			/* pktErrAccStart    */
 
 	/* HI configuration */
@@ -734,19 +734,19 @@ DRXJData_t DRXJData_g = {
 	DRX_UIO_MODE_DISABLE,	/* uioIRQNMode       */
 	/* FS setting */
 	0UL,			/* iqmFsRateOfs      */
-	FALSE,			/* posImage          */
+	false,			/* posImage          */
 	/* RC setting */
 	0UL,			/* iqmRcRateOfs      */
 	/* AUD information */
-/*   FALSE,                  * flagSetAUDdone    */
-/*   FALSE,                  * detectedRDS       */
-/*   TRUE,                   * flagASDRequest    */
-/*   FALSE,                  * flagHDevClear     */
-/*   FALSE,                  * flagHDevSet       */
+/*   false,                  * flagSetAUDdone    */
+/*   false,                  * detectedRDS       */
+/*   true,                   * flagASDRequest    */
+/*   false,                  * flagHDevClear     */
+/*   false,                  * flagHDevSet       */
 /*   (u16) 0xFFF,          * rdsLastCount      */
 
 /*#ifdef DRXJ_SPLIT_UCODE_UPLOAD
-   FALSE,                  * flagAudMcUploaded */
+   false,                  * flagAudMcUploaded */
 /*#endif * DRXJ_SPLIT_UCODE_UPLOAD */
 	/* ATV configuartion */
 	0UL,			/* flags cfg changes */
@@ -782,11 +782,11 @@ DRXJData_t DRXJData_g = {
 	 ATV_TOP_EQU3_EQU_C3_BG,
 	 ATV_TOP_EQU3_EQU_C3_DK,
 	 ATV_TOP_EQU3_EQU_C3_I},
-	FALSE,			/* flag: TRUE=bypass             */
+	false,			/* flag: true=bypass             */
 	ATV_TOP_VID_PEAK__PRE,	/* shadow of ATV_TOP_VID_PEAK__A */
 	ATV_TOP_NOISE_TH__PRE,	/* shadow of ATV_TOP_NOISE_TH__A */
-	TRUE,			/* flag CVBS ouput enable        */
-	FALSE,			/* flag SIF ouput enable         */
+	true,			/* flag CVBS ouput enable        */
+	false,			/* flag SIF ouput enable         */
 	DRXJ_SIF_ATTENUATION_0DB,	/* current SIF att setting       */
 	{			/* qamRfAgcCfg */
 	 DRX_STANDARD_ITU_B,	/* standard            */
@@ -833,12 +833,12 @@ DRXJData_t DRXJData_g = {
 	{			/* qamPreSawCfg */
 	 DRX_STANDARD_ITU_B,	/* standard  */
 	 0,			/* reference */
-	 FALSE			/* usePreSaw */
+	 false			/* usePreSaw */
 	 },
 	{			/* vsbPreSawCfg */
 	 DRX_STANDARD_8VSB,	/* standard  */
 	 0,			/* reference */
-	 FALSE			/* usePreSaw */
+	 false			/* usePreSaw */
 	 },
 
 	/* Version information */
@@ -876,7 +876,7 @@ DRXJData_t DRXJData_g = {
 	  }
 	 },
 #endif
-	FALSE,			/* smartAntInverted */
+	false,			/* smartAntInverted */
 	/* Tracking filter setting for OOB  */
 	{
 	 12000,
@@ -887,10 +887,10 @@ DRXJData_t DRXJData_g = {
 	 3000,
 	 2000,
 	 0},
-	FALSE,			/* oobPowerOn           */
+	false,			/* oobPowerOn           */
 	0,			/* mpegTsStaticBitrate  */
-	FALSE,			/* disableTEIhandling   */
-	FALSE,			/* bitReverseMpegOutout */
+	false,			/* disableTEIhandling   */
+	false,			/* bitReverseMpegOutout */
 	DRXJ_MPEGOUTPUT_CLOCK_RATE_AUTO,	/* mpegOutputClockRate */
 	DRXJ_MPEG_START_WIDTH_1CLKCYC,	/* mpegStartWidth */
 
@@ -898,7 +898,7 @@ DRXJData_t DRXJData_g = {
 	{
 	 DRX_STANDARD_NTSC,	/* standard     */
 	 7,			/* reference    */
-	 TRUE			/* usePreSaw    */
+	 true			/* usePreSaw    */
 	 },
 	{			/* ATV RF-AGC */
 	 DRX_STANDARD_NTSC,	/* standard              */
@@ -923,7 +923,7 @@ DRXJData_t DRXJData_g = {
 	140,			/* ATV PGA config */
 	0,			/* currSymbolRate */
 
-	FALSE,			/* pdrSafeMode     */
+	false,			/* pdrSafeMode     */
 	SIO_PDR_GPIO_CFG__PRE,	/* pdrSafeRestoreValGpio  */
 	SIO_PDR_VSYNC_CFG__PRE,	/* pdrSafeRestoreValVSync */
 	SIO_PDR_SMA_RX_CFG__PRE,	/* pdrSafeRestoreValSmaRx */
@@ -932,7 +932,7 @@ DRXJData_t DRXJData_g = {
 	4,			/* oobPreSaw            */
 	DRXJ_OOB_LO_POW_MINUS10DB,	/* oobLoPow             */
 	{
-	 FALSE			/* audData, only first member */
+	 false			/* audData, only first member */
 	 },
 };
 
@@ -952,25 +952,25 @@ struct i2c_device_addr DRXJDefaultAddr_g = {
 DRXCommonAttr_t DRXJDefaultCommAttr_g = {
 	(u8 *) NULL,		/* ucode ptr            */
 	0,			/* ucode size           */
-	TRUE,			/* ucode verify switch  */
+	true,			/* ucode verify switch  */
 	{0},			/* version record       */
 
 	44000,			/* IF in kHz in case no tuner instance is used  */
 	(151875 - 0),		/* system clock frequency in kHz                */
 	0,			/* oscillator frequency kHz                     */
 	0,			/* oscillator deviation in ppm, signed          */
-	FALSE,			/* If TRUE mirror frequency spectrum            */
+	false,			/* If true mirror frequency spectrum            */
 	{
 	 /* MPEG output configuration */
-	 TRUE,			/* If TRUE, enable MPEG ouput    */
-	 FALSE,			/* If TRUE, insert RS byte       */
-	 TRUE,			/* If TRUE, parallel out otherwise serial */
-	 FALSE,			/* If TRUE, invert DATA signals  */
-	 FALSE,			/* If TRUE, invert ERR signal    */
-	 FALSE,			/* If TRUE, invert STR signals   */
-	 FALSE,			/* If TRUE, invert VAL signals   */
-	 FALSE,			/* If TRUE, invert CLK signals   */
-	 TRUE,			/* If TRUE, static MPEG clockrate will
+	 true,			/* If true, enable MPEG ouput    */
+	 false,			/* If true, insert RS byte       */
+	 true,			/* If true, parallel out otherwise serial */
+	 false,			/* If true, invert DATA signals  */
+	 false,			/* If true, invert ERR signal    */
+	 false,			/* If true, invert STR signals   */
+	 false,			/* If true, invert VAL signals   */
+	 false,			/* If true, invert CLK signals   */
+	 true,			/* If true, static MPEG clockrate will
 				   be used, otherwise clockrate will
 				   adapt to the bitrate of the TS */
 	 19392658UL,		/* Maximum bitrate in b/s in case
@@ -978,22 +978,22 @@ DRXCommonAttr_t DRXJDefaultCommAttr_g = {
 	 DRX_MPEG_STR_WIDTH_1	/* MPEG Start width in clock cycles */
 	 },
 	/* Initilisations below can be ommited, they require no user input and
-	   are initialy 0, NULL or FALSE. The compiler will initialize them to these
+	   are initialy 0, NULL or false. The compiler will initialize them to these
 	   values when ommited.  */
-	FALSE,			/* isOpened */
+	false,			/* isOpened */
 
 	/* SCAN */
 	NULL,			/* no scan params yet               */
 	0,			/* current scan index               */
 	0,			/* next scan frequency              */
-	FALSE,			/* scan ready flag                  */
+	false,			/* scan ready flag                  */
 	0,			/* max channels to scan             */
 	0,			/* nr of channels scanned           */
 	NULL,			/* default scan function            */
 	NULL,			/* default context pointer          */
 	0,			/* millisec to wait for demod lock  */
 	DRXJ_DEMOD_LOCK,	/* desired lock               */
-	FALSE,
+	false,
 
 	/* Power management */
 	DRX_POWER_UP,
@@ -1002,9 +1002,9 @@ DRXCommonAttr_t DRXJDefaultCommAttr_g = {
 	1,			/* nr of I2C port to wich tuner is     */
 	0L,			/* minimum RF input frequency, in kHz  */
 	0L,			/* maximum RF input frequency, in kHz  */
-	FALSE,			/* Rf Agc Polarity                     */
-	FALSE,			/* If Agc Polarity                     */
-	FALSE,			/* tuner slow mode                     */
+	false,			/* Rf Agc Polarity                     */
+	false,			/* If Agc Polarity                     */
+	false,			/* tuner slow mode                     */
 
 	{			/* current channel (all 0)             */
 	 0UL			/* channel.frequency */
@@ -1012,7 +1012,7 @@ DRXCommonAttr_t DRXJDefaultCommAttr_g = {
 	DRX_STANDARD_UNKNOWN,	/* current standard */
 	DRX_STANDARD_UNKNOWN,	/* previous standard */
 	DRX_STANDARD_UNKNOWN,	/* diCacheStandard   */
-	FALSE,			/* useBootloader */
+	false,			/* useBootloader */
 	0UL,			/* capabilities */
 	0			/* mfx */
 };
@@ -1037,12 +1037,12 @@ DRXDemodInstance_t DRXJDefaultDemod_g = {
 *
 */
 DRXAudData_t DRXJDefaultAudData_g = {
-	FALSE,			/* audioIsActive */
+	false,			/* audioIsActive */
 	DRX_AUD_STANDARD_AUTO,	/* audioStandard  */
 
 	/* i2sdata */
 	{
-	 FALSE,			/* outputEnable   */
+	 false,			/* outputEnable   */
 	 48000,			/* frequency      */
 	 DRX_I2S_MODE_MASTER,	/* mode           */
 	 DRX_I2S_WORDLENGTH_32,	/* wordLength     */
@@ -1051,7 +1051,7 @@ DRXAudData_t DRXJDefaultAudData_g = {
 	 },
 	/* volume            */
 	{
-	 TRUE,			/* mute;          */
+	 true,			/* mute;          */
 	 0,			/* volume         */
 	 DRX_AUD_AVC_OFF,	/* avcMode        */
 	 0,			/* avcRefLevel    */
@@ -1102,7 +1102,7 @@ DRXAudData_t DRXJDefaultAudData_g = {
 	DRX_AUD_FM_DEEMPH_75US,	/* deemph */
 	DRX_BTSC_STEREO,	/* btscDetect */
 	0,			/* rdsDataCounter */
-	FALSE			/* rdsDataPresent */
+	false			/* rdsDataPresent */
 };
 
 /*-----------------------------------------------------------------------------
@@ -1158,7 +1158,7 @@ CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode);
 static DRXStatus_t PowerDownAud(pDRXDemodInstance_t demod);
 
 #ifndef DRXJ_DIGITAL_ONLY
-static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, Bool_t setStandard);
+static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, bool setStandard);
 #endif
 
 static DRXStatus_t
@@ -1174,7 +1174,7 @@ CtrlSetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain);
 static DRXStatus_t
 CtrlUCodeUpload(pDRXDemodInstance_t demod,
 		pDRXUCodeInfo_t mcInfo,
-		DRXUCodeAction_t action, Bool_t audioMCUpload);
+		DRXUCodeAction_t action, bool audioMCUpload);
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
 /*============================================================================*/
@@ -1683,28 +1683,28 @@ static const u16 NicamPrescTableVal[43] =
    TODO: check ignoring single/multimaster is ok for AUD access ?
 */
 
-#define DRXJ_ISAUDWRITE( addr ) (((((addr)>>16)&1)==1)?TRUE:FALSE)
+#define DRXJ_ISAUDWRITE( addr ) (((((addr)>>16)&1)==1)?true:false)
 #define DRXJ_DAP_AUDTRIF_TIMEOUT 80	/* millisec */
 /*============================================================================*/
 
 /**
-* \fn Bool_t IsHandledByAudTrIf( DRXaddr_t addr )
+* \fn bool IsHandledByAudTrIf( DRXaddr_t addr )
 * \brief Check if this address is handled by the audio token ring interface.
 * \param addr
-* \return Bool_t
-* \retval TRUE  Yes, handled by audio token ring interface
-* \retval FALSE No, not handled by audio token ring interface
+* \return bool
+* \retval true  Yes, handled by audio token ring interface
+* \retval false No, not handled by audio token ring interface
 *
 */
 static
-Bool_t IsHandledByAudTrIf(DRXaddr_t addr)
+bool IsHandledByAudTrIf(DRXaddr_t addr)
 {
-	Bool_t retval = FALSE;
+	bool retval = false;
 
 	if ((DRXDAP_FASI_ADDR2BLOCK(addr) == 4) &&
 	    (DRXDAP_FASI_ADDR2BANK(addr) > 1) &&
 	    (DRXDAP_FASI_ADDR2BANK(addr) < 6)) {
-		retval = TRUE;
+		retval = true;
 	}
 
 	return (retval);
@@ -2097,7 +2097,7 @@ static
 DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16 datasize,
-					  u8 *data, Bool_t readFlag)
+					  u8 *data, bool readFlag)
 {
 	DRXJHiCmd_t hiCmd;
 
@@ -2120,7 +2120,7 @@ DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 	hiCmd.param2 =
 	    (u16) DRXDAP_FASI_ADDR2OFFSET(DRXJ_HI_ATOMIC_BUF_START);
 	hiCmd.param3 = (u16) ((datasize / 2) - 1);
-	if (readFlag == FALSE) {
+	if (readFlag == false) {
 		hiCmd.param3 |= DRXJ_HI_ATOMIC_WRITE;
 	} else {
 		hiCmd.param3 |= DRXJ_HI_ATOMIC_READ;
@@ -2129,7 +2129,7 @@ DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 				DRXDAP_FASI_ADDR2BANK(addr));
 	hiCmd.param5 = (u16) DRXDAP_FASI_ADDR2OFFSET(addr);
 
-	if (readFlag == FALSE) {
+	if (readFlag == false) {
 		/* write data to buffer */
 		for (i = 0; i < (datasize / 2); i++) {
 
@@ -2143,7 +2143,7 @@ DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 
 	CHK_ERROR(HICommand(devAddr, &hiCmd, &dummy));
 
-	if (readFlag == TRUE) {
+	if (readFlag == true) {
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
 			DRXJ_DAP_ReadReg16(devAddr,
@@ -2181,7 +2181,7 @@ DRXStatus_t DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
 	}
 
 	rc = DRXJ_DAP_AtomicReadWriteBlock(devAddr, addr,
-					   sizeof(*data), buf, TRUE);
+					   sizeof(*data), buf, true);
 
 	word = (u32) buf[3];
 	word <<= 8;
@@ -2262,7 +2262,7 @@ HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, u16 *result)
 {
 	u16 waitCmd = 0;
 	u16 nrRetries = 0;
-	Bool_t powerdown_cmd = FALSE;
+	bool powerdown_cmd = false;
 
 	/* Write parameters */
 	switch (cmd->cmd) {
@@ -2296,11 +2296,11 @@ HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, u16 *result)
 	}
 
 	/* Detect power down to ommit reading result */
-	powerdown_cmd = (Bool_t) ((cmd->cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
+	powerdown_cmd = (bool) ((cmd->cmd == SIO_HI_RA_RAM_CMD_CONFIG) &&
 				  (((cmd->
 				     param5) & SIO_HI_RA_RAM_PAR_5_CFG_SLEEP__M)
 				   == SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ));
-	if (powerdown_cmd == FALSE) {
+	if (powerdown_cmd == false) {
 		/* Wait until command rdy */
 		do {
 			nrRetries++;
@@ -2315,7 +2315,7 @@ HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, u16 *result)
 		RR16(devAddr, SIO_HI_RA_RAM_RES__A, result);
 
 	}
-	/* if ( powerdown_cmd == TRUE ) */
+	/* if ( powerdown_cmd == true ) */
 	return (DRX_STS_OK);
 rw_error:
 	return (DRX_STS_ERROR);
@@ -2462,104 +2462,104 @@ static DRXStatus_t GetDeviceCapabilities(pDRXDemodInstance_t demod)
 		bid = (bid >> 10) & 0xf;
 		WR16(devAddr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY__PRE);
 
-		extAttr->hasLNA = TRUE;
-		extAttr->hasNTSC = FALSE;
-		extAttr->hasBTSC = FALSE;
-		extAttr->hasOOB = FALSE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = FALSE;
-		extAttr->hasGPIO = FALSE;
-		extAttr->hasIRQN = FALSE;
+		extAttr->hasLNA = true;
+		extAttr->hasNTSC = false;
+		extAttr->hasBTSC = false;
+		extAttr->hasOOB = false;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = false;
+		extAttr->hasGPIO = false;
+		extAttr->hasIRQN = false;
 		break;
 	case 0x33:
-		extAttr->hasLNA = FALSE;
-		extAttr->hasNTSC = FALSE;
-		extAttr->hasBTSC = FALSE;
-		extAttr->hasOOB = FALSE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = FALSE;
-		extAttr->hasGPIO = FALSE;
-		extAttr->hasIRQN = FALSE;
+		extAttr->hasLNA = false;
+		extAttr->hasNTSC = false;
+		extAttr->hasBTSC = false;
+		extAttr->hasOOB = false;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = false;
+		extAttr->hasGPIO = false;
+		extAttr->hasIRQN = false;
 		break;
 	case 0x45:
-		extAttr->hasLNA = TRUE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = FALSE;
-		extAttr->hasOOB = FALSE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = FALSE;
+		extAttr->hasLNA = true;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = false;
+		extAttr->hasOOB = false;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = false;
 		break;
 	case 0x46:
-		extAttr->hasLNA = FALSE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = FALSE;
-		extAttr->hasOOB = FALSE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = FALSE;
+		extAttr->hasLNA = false;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = false;
+		extAttr->hasOOB = false;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = false;
 		break;
 	case 0x41:
-		extAttr->hasLNA = TRUE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = TRUE;
-		extAttr->hasOOB = FALSE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = FALSE;
+		extAttr->hasLNA = true;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = true;
+		extAttr->hasOOB = false;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = false;
 		break;
 	case 0x43:
-		extAttr->hasLNA = FALSE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = TRUE;
-		extAttr->hasOOB = FALSE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = FALSE;
+		extAttr->hasLNA = false;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = true;
+		extAttr->hasOOB = false;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = false;
 		break;
 	case 0x32:
-		extAttr->hasLNA = TRUE;
-		extAttr->hasNTSC = FALSE;
-		extAttr->hasBTSC = FALSE;
-		extAttr->hasOOB = TRUE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = TRUE;
+		extAttr->hasLNA = true;
+		extAttr->hasNTSC = false;
+		extAttr->hasBTSC = false;
+		extAttr->hasOOB = true;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = true;
 		break;
 	case 0x34:
-		extAttr->hasLNA = FALSE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = TRUE;
-		extAttr->hasOOB = TRUE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = TRUE;
+		extAttr->hasLNA = false;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = true;
+		extAttr->hasOOB = true;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = true;
 		break;
 	case 0x42:
-		extAttr->hasLNA = TRUE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = TRUE;
-		extAttr->hasOOB = TRUE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = TRUE;
+		extAttr->hasLNA = true;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = true;
+		extAttr->hasOOB = true;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = true;
 		break;
 	case 0x44:
-		extAttr->hasLNA = FALSE;
-		extAttr->hasNTSC = TRUE;
-		extAttr->hasBTSC = TRUE;
-		extAttr->hasOOB = TRUE;
-		extAttr->hasSMATX = TRUE;
-		extAttr->hasSMARX = TRUE;
-		extAttr->hasGPIO = TRUE;
-		extAttr->hasIRQN = TRUE;
+		extAttr->hasLNA = false;
+		extAttr->hasNTSC = true;
+		extAttr->hasBTSC = true;
+		extAttr->hasOOB = true;
+		extAttr->hasSMATX = true;
+		extAttr->hasSMARX = true;
+		extAttr->hasGPIO = true;
+		extAttr->hasIRQN = true;
 		break;
 	default:
 		/* Unknown device variant */
@@ -2663,7 +2663,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 
-	if (cfgData->enableMPEGOutput == TRUE) {
+	if (cfgData->enableMPEGOutput == true) {
 		/* quick and dirty patch to set MPEG incase current std is not
 		   producing MPEG */
 		switch (extAttr->standard) {
@@ -2740,7 +2740,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 			     FEC_OC_AVR_PARM_A__PRE);
 			WR16(devAddr, FEC_OC_AVR_PARM_B__A,
 			     FEC_OC_AVR_PARM_B__PRE);
-			if (cfgData->staticCLK == TRUE) {
+			if (cfgData->staticCLK == true) {
 				WR16(devAddr, FEC_OC_RCN_GAIN__A, 0xD);
 			} else {
 				WR16(devAddr, FEC_OC_RCN_GAIN__A,
@@ -2756,7 +2756,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 		/* Check insertion of the Reed-Solomon parity bytes */
 		RR16(devAddr, FEC_OC_MODE__A, &fecOcRegMode);
 		RR16(devAddr, FEC_OC_IPR_MODE__A, &fecOcRegIprMode);
-		if (cfgData->insertRSByte == TRUE) {
+		if (cfgData->insertRSByte == true) {
 			/* enable parity symbol forward */
 			fecOcRegMode |= FEC_OC_MODE_PARITY__M;
 			/* MVAL disable during parity bytes */
@@ -2780,7 +2780,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 				break;
 			case DRX_STANDARD_ITU_A:
 			case DRX_STANDARD_ITU_C:
-				/* insertRSByte = TRUE -> coef = 188/188 -> 1, RS bits are in MPEG output */
+				/* insertRSByte = true -> coef = 188/188 -> 1, RS bits are in MPEG output */
 				rcnRate =
 				    (Frac28
 				     (maxBitRate,
@@ -2790,7 +2790,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 			default:
 				return (DRX_STS_ERROR);
 			}	/* extAttr->standard */
-		} else {	/* insertRSByte == FALSE */
+		} else {	/* insertRSByte == false */
 
 			/* disable parity symbol forward */
 			fecOcRegMode &= (~FEC_OC_MODE_PARITY__M);
@@ -2815,7 +2815,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 				break;
 			case DRX_STANDARD_ITU_A:
 			case DRX_STANDARD_ITU_C:
-				/* insertRSByte = FALSE -> coef = 188/204, RS bits not in MPEG output */
+				/* insertRSByte = false -> coef = 188/204, RS bits not in MPEG output */
 				rcnRate =
 				    (Frac28
 				     (maxBitRate,
@@ -2827,44 +2827,44 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 			}	/* extAttr->standard */
 		}
 
-		if (cfgData->enableParallel == TRUE) {	/* MPEG data output is paralel -> clear ipr_mode[0] */
+		if (cfgData->enableParallel == true) {	/* MPEG data output is paralel -> clear ipr_mode[0] */
 			fecOcRegIprMode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
 		} else {	/* MPEG data output is serial -> set ipr_mode[0] */
 			fecOcRegIprMode |= FEC_OC_IPR_MODE_SERIAL__M;
 		}
 
 		/* Control slective inversion of output bits */
-		if (cfgData->invertDATA == TRUE) {
+		if (cfgData->invertDATA == true) {
 			fecOcRegIprInvert |= InvertDataMask;
 		} else {
 			fecOcRegIprInvert &= (~(InvertDataMask));
 		}
 
-		if (cfgData->invertERR == TRUE) {
+		if (cfgData->invertERR == true) {
 			fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MERR__M;
 		} else {
 			fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MERR__M));
 		}
 
-		if (cfgData->invertSTR == TRUE) {
+		if (cfgData->invertSTR == true) {
 			fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MSTRT__M;
 		} else {
 			fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MSTRT__M));
 		}
 
-		if (cfgData->invertVAL == TRUE) {
+		if (cfgData->invertVAL == true) {
 			fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MVAL__M;
 		} else {
 			fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MVAL__M));
 		}
 
-		if (cfgData->invertCLK == TRUE) {
+		if (cfgData->invertCLK == true) {
 			fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MCLK__M;
 		} else {
 			fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
 		}
 
-		if (cfgData->staticCLK == TRUE) {	/* Static mode */
+		if (cfgData->staticCLK == true) {	/* Static mode */
 			u32 dtoRate = 0;
 			u32 bitRate = 0;
 			u16 fecOcDtoBurstLen = 0;
@@ -2875,14 +2875,14 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 			switch (extAttr->standard) {
 			case DRX_STANDARD_8VSB:
 				fecOcDtoPeriod = 4;
-				if (cfgData->insertRSByte == TRUE) {
+				if (cfgData->insertRSByte == true) {
 					fecOcDtoBurstLen = 208;
 				}
 				break;
 			case DRX_STANDARD_ITU_A:
 				{
 					u32 symbolRateTh = 6400000;
-					if (cfgData->insertRSByte == TRUE) {
+					if (cfgData->insertRSByte == true) {
 						fecOcDtoBurstLen = 204;
 						symbolRateTh = 5900000;
 					}
@@ -2896,13 +2896,13 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 				break;
 			case DRX_STANDARD_ITU_B:
 				fecOcDtoPeriod = 1;
-				if (cfgData->insertRSByte == TRUE) {
+				if (cfgData->insertRSByte == true) {
 					fecOcDtoBurstLen = 128;
 				}
 				break;
 			case DRX_STANDARD_ITU_C:
 				fecOcDtoPeriod = 1;
-				if (cfgData->insertRSByte == TRUE) {
+				if (cfgData->insertRSByte == true) {
 					fecOcDtoBurstLen = 204;
 				}
 				break;
@@ -2960,7 +2960,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 		    MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH <<
 		    SIO_PDR_MD0_CFG_DRIVE__B | 0x03 << SIO_PDR_MD0_CFG_MODE__B;
 		WR16(devAddr, SIO_PDR_MD0_CFG__A, sioPdrMdCfg);
-		if (cfgData->enableParallel == TRUE) {	/* MPEG data output is paralel -> set MD1 to MD7 to output mode */
+		if (cfgData->enableParallel == true) {	/* MPEG data output is paralel -> set MD1 to MD7 to output mode */
 			sioPdrMdCfg =
 			    MPEG_PARALLEL_OUTPUT_PIN_DRIVE_STRENGTH <<
 			    SIO_PDR_MD0_CFG_DRIVE__B | 0x03 <<
@@ -3116,7 +3116,7 @@ static DRXStatus_t SetMPEGTEIHandling(pDRXDemodInstance_t demod)
 			   FEC_OC_SNC_MODE_CORR_DISABLE__M));
 	fecOcEmsMode &= (~FEC_OC_EMS_MODE_MODE__M);
 
-	if (extAttr->disableTEIhandling == TRUE) {
+	if (extAttr->disableTEIhandling == true) {
 		/* do not change TEI bit */
 		fecOcDprMode |= FEC_OC_DPR_MODE_ERR_DISABLE__M;
 		fecOcSncMode |= FEC_OC_SNC_MODE_CORR_DISABLE__M |
@@ -3157,7 +3157,7 @@ static DRXStatus_t BitReverseMPEGOutput(pDRXDemodInstance_t demod)
 	/* reset to default (normal bit order) */
 	fecOcIprMode &= (~FEC_OC_IPR_MODE_REVERSE_ORDER__M);
 
-	if (extAttr->bitReverseMpegOutout == TRUE) {
+	if (extAttr->bitReverseMpegOutout == true) {
 		/* reverse bit order */
 		fecOcIprMode |= FEC_OC_IPR_MODE_REVERSE_ORDER__M;
 	}
@@ -3218,8 +3218,8 @@ static DRXStatus_t SetMPEGStartWidth(pDRXDemodInstance_t demod)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	commonAttr = demod->myCommonAttr;
 
-	if ((commonAttr->mpegCfg.staticCLK == TRUE)
-	    && (commonAttr->mpegCfg.enableParallel == FALSE)) {
+	if ((commonAttr->mpegCfg.staticCLK == true)
+	    && (commonAttr->mpegCfg.enableParallel == false)) {
 		RR16(devAddr, FEC_OC_COMM_MB__A, &fecOcCommMb);
 		fecOcCommMb &= ~FEC_OC_COMM_MB_CTL_ON;
 		if (extAttr->mpegStartWidth == DRXJ_MPEG_START_WIDTH_8CLKCYC) {
@@ -3261,8 +3261,8 @@ CtrlSetCfgMpegOutputMisc(pDRXDemodInstance_t demod,
 	   Set disable TEI bit handling flag.
 	   TEI must be left untouched by device in case of BER measurements using
 	   external equipment that is unable to ignore the TEI bit in the TS.
-	   Default will FALSE (enable TEI bit handling).
-	   Reverse output bit order. Default is FALSE (msb on MD7 (parallel) or out first (serial)).
+	   Default will false (enable TEI bit handling).
+	   Reverse output bit order. Default is false (msb on MD7 (parallel) or out first (serial)).
 	   Set clock rate. Default is auto that is derived from symbol rate.
 	   The flags and values will also be used to set registers during a set channel.
 	 */
@@ -3389,7 +3389,7 @@ static DRXStatus_t CtrlSetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
       /*====================================================================*/
 	case DRX_UIO1:
 		/* DRX_UIO1: SMA_TX UIO-1 */
-		if (extAttr->hasSMATX != TRUE)
+		if (extAttr->hasSMATX != true)
 			return DRX_STS_ERROR;
 		switch (UIOCfg->mode) {
 		case DRX_UIO_MODE_FIRMWARE_SMA:	/* falltrough */
@@ -3409,7 +3409,7 @@ static DRXStatus_t CtrlSetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
       /*====================================================================*/
 	case DRX_UIO2:
 		/* DRX_UIO2: SMA_RX UIO-2 */
-		if (extAttr->hasSMARX != TRUE)
+		if (extAttr->hasSMARX != true)
 			return DRX_STS_ERROR;
 		switch (UIOCfg->mode) {
 		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
@@ -3429,7 +3429,7 @@ static DRXStatus_t CtrlSetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
       /*====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: GPIO UIO-3 */
-		if (extAttr->hasGPIO != TRUE)
+		if (extAttr->hasGPIO != true)
 			return DRX_STS_ERROR;
 		switch (UIOCfg->mode) {
 		case DRX_UIO_MODE_FIRMWARE0:	/* falltrough */
@@ -3449,7 +3449,7 @@ static DRXStatus_t CtrlSetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
       /*====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
-		if (extAttr->hasIRQN != TRUE)
+		if (extAttr->hasIRQN != true)
 			return DRX_STS_ERROR;
 		switch (UIOCfg->mode) {
 		case DRX_UIO_MODE_READWRITE:
@@ -3492,7 +3492,7 @@ static DRXStatus_t CtrlGetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
 
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 	pDRXUIOMode_t UIOMode[4] = { NULL };
-	pBool_t UIOAvailable[4] = { NULL };
+	bool * UIOAvailable[4] = { NULL };
 
 	extAttr = demod->myExtAttr;
 
@@ -3514,7 +3514,7 @@ static DRXStatus_t CtrlGetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	if (*UIOAvailable[UIOCfg->uio] == FALSE) {
+	if (*UIOAvailable[UIOCfg->uio] == false) {
 		return DRX_STS_ERROR;
 	}
 
@@ -3549,7 +3549,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
       /*====================================================================*/
 	case DRX_UIO1:
 		/* DRX_UIO1: SMA_TX UIO-1 */
-		if (extAttr->hasSMATX != TRUE)
+		if (extAttr->hasSMATX != true)
 			return DRX_STS_ERROR;
 		if ((extAttr->uioSmaTxMode != DRX_UIO_MODE_READWRITE)
 		    && (extAttr->uioSmaTxMode != DRX_UIO_MODE_FIRMWARE_SAW)) {
@@ -3566,7 +3566,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 
 		/* use corresponding bit in io data output registar */
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_OUT_LO__A, &value);
-		if (UIOData->value == FALSE) {
+		if (UIOData->value == false) {
 			value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
 		} else {
 			value |= 0x8000;	/* write one to 15th bit - 1st UIO */
@@ -3577,7 +3577,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
    /*======================================================================*/
 	case DRX_UIO2:
 		/* DRX_UIO2: SMA_RX UIO-2 */
-		if (extAttr->hasSMARX != TRUE)
+		if (extAttr->hasSMARX != true)
 			return DRX_STS_ERROR;
 		if (extAttr->uioSmaRxMode != DRX_UIO_MODE_READWRITE) {
 			return DRX_STS_ERROR;
@@ -3593,7 +3593,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 
 		/* use corresponding bit in io data output registar */
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_OUT_LO__A, &value);
-		if (UIOData->value == FALSE) {
+		if (UIOData->value == false) {
 			value &= 0xBFFF;	/* write zero to 14th bit - 2nd UIO */
 		} else {
 			value |= 0x4000;	/* write one to 14th bit - 2nd UIO */
@@ -3604,7 +3604,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
    /*====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: ASEL UIO-3 */
-		if (extAttr->hasGPIO != TRUE)
+		if (extAttr->hasGPIO != true)
 			return DRX_STS_ERROR;
 		if (extAttr->uioGPIOMode != DRX_UIO_MODE_READWRITE) {
 			return DRX_STS_ERROR;
@@ -3620,7 +3620,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 
 		/* use corresponding bit in io data output registar */
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_OUT_HI__A, &value);
-		if (UIOData->value == FALSE) {
+		if (UIOData->value == false) {
 			value &= 0xFFFB;	/* write zero to 2nd bit - 3rd UIO */
 		} else {
 			value |= 0x0004;	/* write one to 2nd bit - 3rd UIO */
@@ -3631,7 +3631,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
    /*=====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
-		if (extAttr->hasIRQN != TRUE)
+		if (extAttr->hasIRQN != true)
 			return DRX_STS_ERROR;
 
 		if (extAttr->uioIRQNMode != DRX_UIO_MODE_READWRITE) {
@@ -3648,7 +3648,7 @@ CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 
 		/* use corresponding bit in io data output registar */
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_OUT_LO__A, &value);
-		if (UIOData->value == FALSE) {
+		if (UIOData->value == false) {
 			value &= 0xEFFF;	/* write zero to 12th bit - 4th UIO */
 		} else {
 			value |= 0x1000;	/* write one to 12th bit - 4th UIO */
@@ -3694,7 +3694,7 @@ static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
       /*====================================================================*/
 	case DRX_UIO1:
 		/* DRX_UIO1: SMA_TX UIO-1 */
-		if (extAttr->hasSMATX != TRUE)
+		if (extAttr->hasSMATX != true)
 			return DRX_STS_ERROR;
 
 		if (extAttr->uioSmaTxMode != DRX_UIO_MODE_READWRITE) {
@@ -3711,15 +3711,15 @@ static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_IN_LO__A, &value);
 		if ((value & 0x8000) != 0) {	/* check 15th bit - 1st UIO */
-			UIOData->value = TRUE;
+			UIOData->value = true;
 		} else {
-			UIOData->value = FALSE;
+			UIOData->value = false;
 		}
 		break;
    /*======================================================================*/
 	case DRX_UIO2:
 		/* DRX_UIO2: SMA_RX UIO-2 */
-		if (extAttr->hasSMARX != TRUE)
+		if (extAttr->hasSMARX != true)
 			return DRX_STS_ERROR;
 
 		if (extAttr->uioSmaRxMode != DRX_UIO_MODE_READWRITE) {
@@ -3737,15 +3737,15 @@ static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_IN_LO__A, &value);
 
 		if ((value & 0x4000) != 0) {	/* check 14th bit - 2nd UIO */
-			UIOData->value = TRUE;
+			UIOData->value = true;
 		} else {
-			UIOData->value = FALSE;
+			UIOData->value = false;
 		}
 		break;
    /*=====================================================================*/
 	case DRX_UIO3:
 		/* DRX_UIO3: GPIO UIO-3 */
-		if (extAttr->hasGPIO != TRUE)
+		if (extAttr->hasGPIO != true)
 			return DRX_STS_ERROR;
 
 		if (extAttr->uioGPIOMode != DRX_UIO_MODE_READWRITE) {
@@ -3763,15 +3763,15 @@ static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 		/* read io input data registar */
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_IN_HI__A, &value);
 		if ((value & 0x0004) != 0) {	/* check 2nd bit - 3rd UIO */
-			UIOData->value = TRUE;
+			UIOData->value = true;
 		} else {
-			UIOData->value = FALSE;
+			UIOData->value = false;
 		}
 		break;
    /*=====================================================================*/
 	case DRX_UIO4:
 		/* DRX_UIO4: IRQN UIO-4 */
-		if (extAttr->hasIRQN != TRUE)
+		if (extAttr->hasIRQN != true)
 			return DRX_STS_ERROR;
 
 		if (extAttr->uioIRQNMode != DRX_UIO_MODE_READWRITE) {
@@ -3789,9 +3789,9 @@ static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 		/* read io input data registar */
 		RR16(demod->myI2CDevAddr, SIO_PDR_UIO_IN_LO__A, &value);
 		if ((value & 0x1000) != 0) {	/* check 12th bit - 4th UIO */
-			UIOData->value = TRUE;
+			UIOData->value = true;
 		} else {
-			UIOData->value = FALSE;
+			UIOData->value = false;
 		}
 		break;
       /*====================================================================*/
@@ -3823,7 +3823,7 @@ rw_error:
 
 */
 static DRXStatus_t
-CtrlI2CBridge(pDRXDemodInstance_t demod, pBool_t bridgeClosed)
+CtrlI2CBridge(pDRXDemodInstance_t demod, bool * bridgeClosed)
 {
 	DRXJHiCmd_t hiCmd;
 	u16 result = 0;
@@ -3835,7 +3835,7 @@ CtrlI2CBridge(pDRXDemodInstance_t demod, pBool_t bridgeClosed)
 
 	hiCmd.cmd = SIO_HI_RA_RAM_CMD_BRDCTRL;
 	hiCmd.param1 = SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY;
-	if (*bridgeClosed == TRUE) {
+	if (*bridgeClosed == true) {
 		hiCmd.param2 = SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED;
 	} else {
 		hiCmd.param2 = SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN;
@@ -3908,7 +3908,7 @@ CtrlSetCfgSmartAnt(pDRXDemodInstance_t demod, pDRXJCfgSmartAnt_t smartAnt)
 	struct i2c_device_addr *devAddr = NULL;
 	u16 data = 0;
 	u32 startTime = 0;
-	static Bool_t bitInverted = FALSE;
+	static bool bitInverted = false;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -4096,7 +4096,7 @@ rw_error:
 #define ADDR_AT_SCU_SPACE(x) ((x - 0x82E000) * 2)
 static
 DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, DRXaddr_t addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
-					      u8 *data, Bool_t readFlag)
+					      u8 *data, bool readFlag)
 {
 	DRXJSCUCmd_t scuCmd;
 	u16 setParamParameters[15];
@@ -4133,7 +4133,7 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, D
 	scuCmd.parameter = setParamParameters;
 	CHK_ERROR(SCUCommand(devAddr, &scuCmd));
 
-	if (readFlag == TRUE) {
+	if (readFlag == true) {
 		int i = 0;
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
@@ -4168,7 +4168,7 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 		return DRX_STS_INVALID_ARG;
 	}
 
-	rc = DRXJ_DAP_SCU_AtomicReadWriteBlock(devAddr, addr, 2, buf, TRUE);
+	rc = DRXJ_DAP_SCU_AtomicReadWriteBlock(devAddr, addr, 2, buf, true);
 
 	word = (u16) (buf[0] + (buf[1] << 8));
 
@@ -4193,7 +4193,7 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16(struct i2c_device_addr *devAddr,
 	buf[0] = (u8) (data & 0xff);
 	buf[1] = (u8) ((data >> 8) & 0xff);
 
-	rc = DRXJ_DAP_SCU_AtomicReadWriteBlock(devAddr, addr, 2, buf, FALSE);
+	rc = DRXJ_DAP_SCU_AtomicReadWriteBlock(devAddr, addr, 2, buf, false);
 
 	return rc;
 }
@@ -4312,7 +4312,7 @@ rw_error:
 * \param active
 * \return DRXStatus_t.
 */
-static DRXStatus_t IQMSetAf(pDRXDemodInstance_t demod, Bool_t active)
+static DRXStatus_t IQMSetAf(pDRXDemodInstance_t demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -4352,11 +4352,11 @@ CtrlSetCfgATVOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg);
 /**
 * \brief set configuration of pin-safe mode
 * \param demod instance of demodulator.
-* \param enable boolean; TRUE: activate pin-safe mode, FALSE: de-activate p.s.m.
+* \param enable boolean; true: activate pin-safe mode, false: de-activate p.s.m.
 * \return DRXStatus_t.
 */
 static DRXStatus_t
-CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, pBool_t enable)
+CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enable)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -4373,8 +4373,8 @@ CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, pBool_t enable)
 	/*  Write magic word to enable pdr reg write  */
 	WR16(devAddr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
 
-	if (*enable == TRUE) {
-		Bool_t bridgeEnabled = FALSE;
+	if (*enable == true) {
+		bool bridgeEnabled = false;
 
 		/* MPEG pins to input */
 		WR16(devAddr, SIO_PDR_MSTRT_CFG__A, DRXJ_PIN_SAFE_MODE);
@@ -4415,7 +4415,7 @@ CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, pBool_t enable)
 
 		/*  PD_RF_AGC   Analog DAC outputs, cannot be set to input or tristate!
 		   PD_IF_AGC   Analog DAC outputs, cannot be set to input or tristate! */
-		CHK_ERROR(IQMSetAf(demod, FALSE));
+		CHK_ERROR(IQMSetAf(demod, false));
 
 		/*  PD_CVBS     Analog DAC output, standby mode
 		   PD_SIF      Analog DAC output, standby mode */
@@ -4482,7 +4482,7 @@ rw_error:
 * \return DRXStatus_t.
 */
 static DRXStatus_t
-CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, pBool_t enabled)
+CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enabled)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
@@ -4725,12 +4725,12 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	WR16(devAddr, SCU_RAM_AGC_CLP_CTRL_MODE__A, clpCtrlMode);
 
 	agcRf = 0x800 + pAgcRfSettings->cutOffCurrent;
-	if (commonAttr->tunerRfAgcPol == TRUE) {
+	if (commonAttr->tunerRfAgcPol == true) {
 		agcRf = 0x87ff - agcRf;
 	}
 
 	agcIf = 0x800;
-	if (commonAttr->tunerIfAgcPol == TRUE) {
+	if (commonAttr->tunerIfAgcPol == true) {
 		agcRf = 0x87ff - agcRf;
 	}
 
@@ -4758,31 +4758,31 @@ rw_error:
 */
 static DRXStatus_t
 SetFrequency(pDRXDemodInstance_t demod,
-	     pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset)
+	     pDRXChannel_t channel, s32 tunerFreqOffset)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
-	DRXFrequency_t samplingFrequency = 0;
-	DRXFrequency_t frequencyShift = 0;
-	DRXFrequency_t ifFreqActual = 0;
-	DRXFrequency_t rfFreqResidual = 0;
-	DRXFrequency_t adcFreq = 0;
-	DRXFrequency_t intermediateFreq = 0;
+	s32 samplingFrequency = 0;
+	s32 frequencyShift = 0;
+	s32 ifFreqActual = 0;
+	s32 rfFreqResidual = 0;
+	s32 adcFreq = 0;
+	s32 intermediateFreq = 0;
 	u32 iqmFsRateOfs = 0;
 	pDRXJData_t extAttr = NULL;
-	Bool_t adcFlip = TRUE;
-	Bool_t selectPosImage = FALSE;
-	Bool_t rfMirror = FALSE;
-	Bool_t tunerMirror = TRUE;
-	Bool_t imageToSelect = TRUE;
-	DRXFrequency_t fmFrequencyShift = 0;
+	bool adcFlip = true;
+	bool selectPosImage = false;
+	bool rfMirror = false;
+	bool tunerMirror = true;
+	bool imageToSelect = true;
+	s32 fmFrequencyShift = 0;
 
 	devAddr = demod->myI2CDevAddr;
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	rfFreqResidual = -1 * tunerFreqOffset;
-	rfMirror = (extAttr->mirror == DRX_MIRROR_YES) ? TRUE : FALSE;
-	tunerMirror = demod->myCommonAttr->mirrorFreqSpect ? FALSE : TRUE;
+	rfMirror = (extAttr->mirror == DRX_MIRROR_YES) ? true : false;
+	tunerMirror = demod->myCommonAttr->mirrorFreqSpect ? false : true;
 	/*
 	   Program frequency shifter
 	   No need to account for mirroring on RF
@@ -4792,7 +4792,7 @@ SetFrequency(pDRXDemodInstance_t demod,
 	case DRX_STANDARD_ITU_C:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
 	case DRX_STANDARD_8VSB:
-		selectPosImage = TRUE;
+		selectPosImage = true;
 		break;
 	case DRX_STANDARD_FM:
 		/* After IQM FS sound carrier must appear at 4 Mhz in spect.
@@ -4805,14 +4805,14 @@ SetFrequency(pDRXDemodInstance_t demod,
 	case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_L:
-		selectPosImage = FALSE;
+		selectPosImage = false;
 		break;
 	default:
 		return (DRX_STS_INVALID_ARG);
 	}
 	intermediateFreq = demod->myCommonAttr->intermediateFreq;
 	samplingFrequency = demod->myCommonAttr->sysClockFreq / 3;
-	if (tunerMirror == TRUE) {
+	if (tunerMirror == true) {
 		/* tuner doesn't mirror */
 		ifFreqActual =
 		    intermediateFreq + rfFreqResidual + fmFrequencyShift;
@@ -4824,16 +4824,16 @@ SetFrequency(pDRXDemodInstance_t demod,
 	if (ifFreqActual > samplingFrequency / 2) {
 		/* adc mirrors */
 		adcFreq = samplingFrequency - ifFreqActual;
-		adcFlip = TRUE;
+		adcFlip = true;
 	} else {
 		/* adc doesn't mirror */
 		adcFreq = ifFreqActual;
-		adcFlip = FALSE;
+		adcFlip = false;
 	}
 
 	frequencyShift = adcFreq;
 	imageToSelect =
-	    (Bool_t) (rfMirror ^ tunerMirror ^ adcFlip ^ selectPosImage);
+	    (bool) (rfMirror ^ tunerMirror ^ adcFlip ^ selectPosImage);
 	iqmFsRateOfs = Frac28(frequencyShift, samplingFrequency);
 
 	if (imageToSelect)
@@ -4843,7 +4843,7 @@ SetFrequency(pDRXDemodInstance_t demod,
 	/* frequencyShift += tunerFreqOffset; TODO */
 	WR32(devAddr, IQM_FS_RATE_OFS_LO__A, iqmFsRateOfs);
 	extAttr->iqmFsRateOfs = iqmFsRateOfs;
-	extAttr->posImage = (Bool_t) (rfMirror ^ tunerMirror ^ selectPosImage);
+	extAttr->posImage = (bool) (rfMirror ^ tunerMirror ^ selectPosImage);
 
 	return (DRX_STS_OK);
 rw_error:
@@ -4936,10 +4936,10 @@ static DRXStatus_t GetAccPktErr(pDRXDemodInstance_t demod, u16 *packetErr)
 	devAddr = demod->myI2CDevAddr;
 
 	RR16(devAddr, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, &data);
-	if (extAttr->resetPktErrAcc == TRUE) {
+	if (extAttr->resetPktErrAcc == true) {
 		lastPktErr = data;
 		pktErr = 0;
-		extAttr->resetPktErrAcc = FALSE;
+		extAttr->resetPktErrAcc = false;
 	}
 
 	if (data < lastPktErr) {
@@ -4972,7 +4972,7 @@ static DRXStatus_t CtrlSetCfgResetPktErr(pDRXDemodInstance_t demod)
 	u16 packetError = 0;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
-	extAttr->resetPktErrAcc = TRUE;
+	extAttr->resetPktErrAcc = true;
 	/* call to reset counter */
 	CHK_ERROR(GetAccPktErr(demod, &packetError));
 
@@ -5027,7 +5027,7 @@ rw_error:
 */
 static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32 *CTLFreq)
 {
-	DRXFrequency_t samplingFrequency = 0;
+	s32 samplingFrequency = 0;
 	s32 currentFrequency = 0;
 	s32 nominalFrequency = 0;
 	s32 carrierFrequencyShift = 0;
@@ -5048,7 +5048,7 @@ static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32 *CTLFreq)
 	nominalFrequency = extAttr->iqmFsRateOfs;
 	ARR32(devAddr, IQM_FS_RATE_LO__A, (u32 *) & currentFrequency);
 
-	if (extAttr->posImage == TRUE) {
+	if (extAttr->posImage == true) {
 		/* negative image */
 		carrierFrequencyShift = nominalFrequency - currentFrequency;
 	} else {
@@ -5082,7 +5082,7 @@ rw_error:
 * \return DRXStatus_t.
 */
 static DRXStatus_t
-SetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, Bool_t atomic)
+SetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, bool atomic)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -5321,7 +5321,7 @@ rw_error:
 * \return DRXStatus_t.
 */
 static DRXStatus_t
-SetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, Bool_t atomic)
+SetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, bool atomic)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -5573,7 +5573,7 @@ rw_error:
 * \param active
 * \return DRXStatus_t.
 */
-static DRXStatus_t SetIqmAf(pDRXDemodInstance_t demod, Bool_t active)
+static DRXStatus_t SetIqmAf(pDRXDemodInstance_t demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -5621,7 +5621,7 @@ rw_error:
 * \param channel pointer to channel data.
 * \return DRXStatus_t.
 */
-static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, Bool_t primary)
+static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, bool primary)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command     */ 0,
@@ -5651,9 +5651,9 @@ static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, Bool_t primary)
 	/* stop all comm_exec */
 	WR16(devAddr, FEC_COMM_EXEC__A, FEC_COMM_EXEC_STOP);
 	WR16(devAddr, VSB_COMM_EXEC__A, VSB_COMM_EXEC_STOP);
-	if (primary == TRUE) {
+	if (primary == true) {
 		WR16(devAddr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_STOP);
-		CHK_ERROR(SetIqmAf(demod, FALSE));
+		CHK_ERROR(SetIqmAf(demod, false));
 	} else {
 		WR16(devAddr, IQM_FS_COMM_EXEC__A, IQM_FS_COMM_EXEC_STOP);
 		WR16(devAddr, IQM_FD_COMM_EXEC__A, IQM_FD_COMM_EXEC_STOP);
@@ -5662,7 +5662,7 @@ static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, Bool_t primary)
 		WR16(devAddr, IQM_CF_COMM_EXEC__A, IQM_CF_COMM_EXEC_STOP);
 	}
 
-	cfgMPEGOutput.enableMPEGOutput = FALSE;
+	cfgMPEGOutput.enableMPEGOutput = false;
 	CHK_ERROR(CtrlSetCfgMPEGOutput(demod, &cfgMPEGOutput));
 
 	return (DRX_STS_OK);
@@ -6019,17 +6019,17 @@ static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 
 	WR16(devAddr, VSB_TOP_CKGN1TRK__A, 128);
 	/* B-Input to ADC, PGA+filter in standby */
-	if (extAttr->hasLNA == FALSE) {
+	if (extAttr->hasLNA == false) {
 		WR16(devAddr, IQM_AF_AMUX__A, 0x02);
 	};
 
 	/* turn on IQMAF. It has to be in front of setAgc**() */
-	CHK_ERROR(SetIqmAf(demod, TRUE));
+	CHK_ERROR(SetIqmAf(demod, true));
 	CHK_ERROR(ADCSynchronization(demod));
 
 	CHK_ERROR(InitAGC(demod));
-	CHK_ERROR(SetAgcIf(demod, &(extAttr->vsbIfAgcCfg), FALSE));
-	CHK_ERROR(SetAgcRf(demod, &(extAttr->vsbRfAgcCfg), FALSE));
+	CHK_ERROR(SetAgcIf(demod, &(extAttr->vsbIfAgcCfg), false));
+	CHK_ERROR(SetAgcRf(demod, &(extAttr->vsbRfAgcCfg), false));
 	{
 		/* TODO fix this, store a DRXJCfgAfeGain_t structure in DRXJData_t instead
 		   of only the gain */
@@ -6048,7 +6048,7 @@ static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 		/* TODO: move to setStandard after hardware reset value problem is solved */
 		/* Configure initial MPEG output */
 		DRXCfgMPEGOutput_t cfgMPEGOutput;
-		cfgMPEGOutput.enableMPEGOutput = TRUE;
+		cfgMPEGOutput.enableMPEGOutput = true;
 		cfgMPEGOutput.insertRSByte = commonAttr->mpegCfg.insertRSByte;
 		cfgMPEGOutput.enableParallel =
 		    commonAttr->mpegCfg.enableParallel;
@@ -6310,7 +6310,7 @@ rw_error:
 * \param channel pointer to channel data.
 * \return DRXStatus_t.
 */
-static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, Bool_t primary)
+static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, bool primary)
 {
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
@@ -6342,9 +6342,9 @@ static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, Bool_t primary)
 	cmdSCU.result = &cmdResult;
 	CHK_ERROR(SCUCommand(devAddr, &cmdSCU));
 
-	if (primary == TRUE) {
+	if (primary == true) {
 		WR16(devAddr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_STOP);
-		CHK_ERROR(SetIqmAf(demod, FALSE));
+		CHK_ERROR(SetIqmAf(demod, false));
 	} else {
 		WR16(devAddr, IQM_FS_COMM_EXEC__A, IQM_FS_COMM_EXEC_STOP);
 		WR16(devAddr, IQM_FD_COMM_EXEC__A, IQM_FD_COMM_EXEC_STOP);
@@ -6353,7 +6353,7 @@ static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, Bool_t primary)
 		WR16(devAddr, IQM_CF_COMM_EXEC__A, IQM_CF_COMM_EXEC_STOP);
 	}
 
-	cfgMPEGOutput.enableMPEGOutput = FALSE;
+	cfgMPEGOutput.enableMPEGOutput = false;
 	CHK_ERROR(CtrlSetCfgMPEGOutput(demod, &cfgMPEGOutput));
 
 	return (DRX_STS_OK);
@@ -6949,7 +6949,7 @@ rw_error:
 */
 static DRXStatus_t
 SetQAM(pDRXDemodInstance_t demod,
-       pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset, u32 op)
+       pDRXChannel_t channel, s32 tunerFreqOffset, u32 op)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -7213,7 +7213,7 @@ SetQAM(pDRXDemodInstance_t demod,
 	}
 
 	if (op & QAM_SET_OP_ALL) {
-		if (extAttr->hasLNA == FALSE) {
+		if (extAttr->hasLNA == false) {
 			WR16(devAddr, IQM_AF_AMUX__A, 0x02);
 		}
 		WR16(devAddr, IQM_CF_SYMMETRIC__A, 0);
@@ -7288,12 +7288,12 @@ SetQAM(pDRXDemodInstance_t demod,
 		/* No more resets of the IQM, current standard correctly set =>
 		   now AGCs can be configured. */
 		/* turn on IQMAF. It has to be in front of setAgc**() */
-		CHK_ERROR(SetIqmAf(demod, TRUE));
+		CHK_ERROR(SetIqmAf(demod, true));
 		CHK_ERROR(ADCSynchronization(demod));
 
 		CHK_ERROR(InitAGC(demod));
-		CHK_ERROR(SetAgcIf(demod, &(extAttr->qamIfAgcCfg), FALSE));
-		CHK_ERROR(SetAgcRf(demod, &(extAttr->qamRfAgcCfg), FALSE));
+		CHK_ERROR(SetAgcIf(demod, &(extAttr->qamIfAgcCfg), false));
+		CHK_ERROR(SetAgcRf(demod, &(extAttr->qamRfAgcCfg), false));
 		{
 			/* TODO fix this, store a DRXJCfgAfeGain_t structure in DRXJData_t instead
 			   of only the gain */
@@ -7371,7 +7371,7 @@ SetQAM(pDRXDemodInstance_t demod,
 			/* Configure initial MPEG output */
 			DRXCfgMPEGOutput_t cfgMPEGOutput;
 
-			cfgMPEGOutput.enableMPEGOutput = TRUE;
+			cfgMPEGOutput.enableMPEGOutput = true;
 			cfgMPEGOutput.insertRSByte =
 			    commonAttr->mpegCfg.insertRSByte;
 			cfgMPEGOutput.enableParallel =
@@ -7458,7 +7458,7 @@ static DRXStatus_t qamFlipSpec(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	/* flip the spec */
 	WR32(devAddr, IQM_FS_RATE_OFS_LO__A, iqmFsRateOfs);
 	extAttr->iqmFsRateOfs = iqmFsRateOfs;
-	extAttr->posImage = (extAttr->posImage) ? FALSE : TRUE;
+	extAttr->posImage = (extAttr->posImage) ? false : true;
 
 	/* freeze dq/fq updating */
 	RR16(devAddr, QAM_DQ_MODE__A, &data);
@@ -7511,7 +7511,7 @@ rw_error:
 static DRXStatus_t
 QAM64Auto(pDRXDemodInstance_t demod,
 	  pDRXChannel_t channel,
-	  DRXFrequency_t tunerFreqOffset, pDRXLockStatus_t lockStatus)
+	  s32 tunerFreqOffset, pDRXLockStatus_t lockStatus)
 {
 	DRXSigQuality_t sigQuality;
 	u16 data = 0;
@@ -7625,7 +7625,7 @@ rw_error:
 static DRXStatus_t
 QAM256Auto(pDRXDemodInstance_t demod,
 	   pDRXChannel_t channel,
-	   DRXFrequency_t tunerFreqOffset, pDRXLockStatus_t lockStatus)
+	   s32 tunerFreqOffset, pDRXLockStatus_t lockStatus)
 {
 	DRXSigQuality_t sigQuality;
 	u32 state = NO_LOCK;
@@ -7693,11 +7693,11 @@ rw_error:
 */
 static DRXStatus_t
 SetQAMChannel(pDRXDemodInstance_t demod,
-	      pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset)
+	      pDRXChannel_t channel, s32 tunerFreqOffset)
 {
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	pDRXJData_t extAttr = NULL;
-	Bool_t autoFlag = FALSE;
+	bool autoFlag = false;
 
 	/* external attributes for storing aquired channel constellation */
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -7735,7 +7735,7 @@ SetQAMChannel(pDRXDemodInstance_t demod,
 		break;
 	case DRX_CONSTELLATION_AUTO:	/* for channel scan */
 		if (extAttr->standard == DRX_STANDARD_ITU_B) {
-			autoFlag = TRUE;
+			autoFlag = true;
 			/* try to lock default QAM constellation: QAM64 */
 			channel->constellation = DRX_CONSTELLATION_QAM256;
 			extAttr->constellation = DRX_CONSTELLATION_QAM256;
@@ -7788,7 +7788,7 @@ SetQAMChannel(pDRXDemodInstance_t demod,
 		} else if (extAttr->standard == DRX_STANDARD_ITU_C) {
 			channel->constellation = DRX_CONSTELLATION_QAM64;
 			extAttr->constellation = DRX_CONSTELLATION_QAM64;
-			autoFlag = TRUE;
+			autoFlag = true;
 
 			if (channel->mirror == DRX_MIRROR_AUTO) {
 				extAttr->mirror = DRX_MIRROR_NO;
@@ -8268,7 +8268,7 @@ static DRXStatus_t AtvEquCoefIndex(DRXStandard_t standard, int *index)
 *
 */
 static DRXStatus_t
-AtvUpdateConfig(pDRXDemodInstance_t demod, Bool_t forceUpdate)
+AtvUpdateConfig(pDRXDemodInstance_t demod, bool forceUpdate)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -8415,7 +8415,7 @@ CtrlSetCfgATVOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg)
 		extAttr->atvCfgChangedFlags |= DRXJ_ATV_CHANGED_OUTPUT;
 	}
 
-	CHK_ERROR(AtvUpdateConfig(demod, FALSE));
+	CHK_ERROR(AtvUpdateConfig(demod, false));
 
 	return (DRX_STS_OK);
 rw_error:
@@ -8465,7 +8465,7 @@ CtrlSetCfgAtvEquCoef(pDRXDemodInstance_t demod, pDRXJCfgAtvEquCoef_t coef)
 	extAttr->atvTopEqu3[index] = coef->coef3;
 	extAttr->atvCfgChangedFlags |= DRXJ_ATV_CHANGED_COEF;
 
-	CHK_ERROR(AtvUpdateConfig(demod, FALSE));
+	CHK_ERROR(AtvUpdateConfig(demod, false));
 
 	return (DRX_STS_OK);
 rw_error:
@@ -8549,7 +8549,7 @@ CtrlSetCfgAtvMisc(pDRXDemodInstance_t demod, pDRXJCfgAtvMisc_t settings)
 		extAttr->atvCfgChangedFlags |= DRXJ_ATV_CHANGED_NOISE_FLT;
 	}
 
-	CHK_ERROR(AtvUpdateConfig(demod, FALSE));
+	CHK_ERROR(AtvUpdateConfig(demod, false));
 
 	return (DRX_STS_OK);
 rw_error:
@@ -8610,15 +8610,15 @@ CtrlGetCfgAtvOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg)
 
 	RR16(demod->myI2CDevAddr, ATV_TOP_STDBY__A, &data);
 	if (data & ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE) {
-		outputCfg->enableCVBSOutput = TRUE;
+		outputCfg->enableCVBSOutput = true;
 	} else {
-		outputCfg->enableCVBSOutput = FALSE;
+		outputCfg->enableCVBSOutput = false;
 	}
 
 	if (data & ATV_TOP_STDBY_SIF_STDBY_STANDBY) {
-		outputCfg->enableSIFOutput = FALSE;
+		outputCfg->enableSIFOutput = false;
 	} else {
-		outputCfg->enableSIFOutput = TRUE;
+		outputCfg->enableSIFOutput = true;
 		RR16(demod->myI2CDevAddr, ATV_TOP_AF_SIF_ATT__A, &data);
 		outputCfg->sifAttenuation = (DRXJSIFAttenuation_t) data;
 	}
@@ -8753,7 +8753,7 @@ static DRXStatus_t PowerUpATV(pDRXDemodInstance_t demod, DRXStandard_t standard)
 	/* ATV NTSC */
 	WR16(devAddr, ATV_COMM_EXEC__A, ATV_COMM_EXEC_ACTIVE);
 	/* turn on IQM_AF */
-	CHK_ERROR(SetIqmAf(demod, TRUE));
+	CHK_ERROR(SetIqmAf(demod, true));
 	CHK_ERROR(ADCSynchronization(demod));
 
 	WR16(devAddr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_ACTIVE);
@@ -8780,7 +8780,7 @@ rw_error:
 *  Calls audio power down
 */
 static DRXStatus_t
-PowerDownATV(pDRXDemodInstance_t demod, DRXStandard_t standard, Bool_t primary)
+PowerDownATV(pDRXDemodInstance_t demod, DRXStandard_t standard, bool primary)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
@@ -8809,9 +8809,9 @@ PowerDownATV(pDRXDemodInstance_t demod, DRXStandard_t standard, Bool_t primary)
 					 (~ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE)));
 
 	WR16(devAddr, ATV_COMM_EXEC__A, ATV_COMM_EXEC_STOP);
-	if (primary == TRUE) {
+	if (primary == true) {
 		WR16(devAddr, IQM_COMM_EXEC__A, IQM_COMM_EXEC_STOP);
-		CHK_ERROR(SetIqmAf(demod, FALSE));
+		CHK_ERROR(SetIqmAf(demod, false));
 	} else {
 		WR16(devAddr, IQM_FS_COMM_EXEC__A, IQM_FS_COMM_EXEC_STOP);
 		WR16(devAddr, IQM_FD_COMM_EXEC__A, IQM_FD_COMM_EXEC_STOP);
@@ -9128,15 +9128,15 @@ trouble ?
 
 		/* Upload only audio microcode */
 		CHK_ERROR(CtrlUCodeUpload
-			  (demod, &ucodeInfo, UCODE_UPLOAD, TRUE));
+			  (demod, &ucodeInfo, UCODE_UPLOAD, true));
 
-		if (commonAttr->verifyMicrocode == TRUE) {
+		if (commonAttr->verifyMicrocode == true) {
 			CHK_ERROR(CtrlUCodeUpload
-				  (demod, &ucodeInfo, UCODE_VERIFY, TRUE));
+				  (demod, &ucodeInfo, UCODE_VERIFY, true));
 		}
 
 		/* Prevent uploading audio microcode again */
-		extAttr->flagAudMcUploaded = TRUE;
+		extAttr->flagAudMcUploaded = true;
 	}
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
@@ -9186,8 +9186,8 @@ trouble ?
 		WR16(devAddr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000);
 		WR16(devAddr, SCU_RAM_ATV_AMS_MAX_REF__A,
 		     SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_BG_MN);
-		extAttr->phaseCorrectionBypass = FALSE;
-		extAttr->enableCVBSOutput = TRUE;
+		extAttr->phaseCorrectionBypass = false;
+		extAttr->enableCVBSOutput = true;
 		break;
 	case DRX_STANDARD_FM:
 		/* FM */
@@ -9208,8 +9208,8 @@ trouble ?
 		     (SCU_RAM_ATV_AGC_MODE_VAGC_VEL_AGC_SLOW |
 		      SCU_RAM_ATV_AGC_MODE_SIF_STD_SIF_AGC_FM));
 		WR16(devAddr, IQM_RT_ROT_BP__A, IQM_RT_ROT_BP_ROT_OFF_OFF);
-		extAttr->phaseCorrectionBypass = TRUE;
-		extAttr->enableCVBSOutput = FALSE;
+		extAttr->phaseCorrectionBypass = true;
+		extAttr->enableCVBSOutput = false;
 		break;
 	case DRX_STANDARD_PAL_SECAM_BG:
 		/* PAL/SECAM B/G */
@@ -9236,9 +9236,9 @@ trouble ?
 		WR16(devAddr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000);
 		WR16(devAddr, SCU_RAM_ATV_AMS_MAX_REF__A,
 		     SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_BG_MN);
-		extAttr->phaseCorrectionBypass = FALSE;
+		extAttr->phaseCorrectionBypass = false;
 		extAttr->atvIfAgcCfg.ctrlMode = DRX_AGC_CTRL_AUTO;
-		extAttr->enableCVBSOutput = TRUE;
+		extAttr->enableCVBSOutput = true;
 		break;
 	case DRX_STANDARD_PAL_SECAM_DK:
 		/* PAL/SECAM D/K */
@@ -9265,9 +9265,9 @@ trouble ?
 		WR16(devAddr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000);
 		WR16(devAddr, SCU_RAM_ATV_AMS_MAX_REF__A,
 		     SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_DK);
-		extAttr->phaseCorrectionBypass = FALSE;
+		extAttr->phaseCorrectionBypass = false;
 		extAttr->atvIfAgcCfg.ctrlMode = DRX_AGC_CTRL_AUTO;
-		extAttr->enableCVBSOutput = TRUE;
+		extAttr->enableCVBSOutput = true;
 		break;
 	case DRX_STANDARD_PAL_SECAM_I:
 		/* PAL/SECAM I   */
@@ -9294,9 +9294,9 @@ trouble ?
 		WR16(devAddr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000);
 		WR16(devAddr, SCU_RAM_ATV_AMS_MAX_REF__A,
 		     SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_I);
-		extAttr->phaseCorrectionBypass = FALSE;
+		extAttr->phaseCorrectionBypass = false;
 		extAttr->atvIfAgcCfg.ctrlMode = DRX_AGC_CTRL_AUTO;
-		extAttr->enableCVBSOutput = TRUE;
+		extAttr->enableCVBSOutput = true;
 		break;
 	case DRX_STANDARD_PAL_SECAM_L:
 		/* PAL/SECAM L with negative modulation */
@@ -9324,10 +9324,10 @@ trouble ?
 		WR16(devAddr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000);
 		WR16(devAddr, SCU_RAM_ATV_AMS_MAX_REF__A,
 		     SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_LLP);
-		extAttr->phaseCorrectionBypass = FALSE;
+		extAttr->phaseCorrectionBypass = false;
 		extAttr->atvIfAgcCfg.ctrlMode = DRX_AGC_CTRL_USER;
 		extAttr->atvIfAgcCfg.outputLevel = extAttr->atvRfAgcCfg.top;
-		extAttr->enableCVBSOutput = TRUE;
+		extAttr->enableCVBSOutput = true;
 		break;
 	case DRX_STANDARD_PAL_SECAM_LP:
 		/* PAL/SECAM L with positive modulation */
@@ -9355,17 +9355,17 @@ trouble ?
 		WR16(devAddr, SCU_RAM_ATV_VID_GAIN_LO__A, 0x0000);
 		WR16(devAddr, SCU_RAM_ATV_AMS_MAX_REF__A,
 		     SCU_RAM_ATV_AMS_MAX_REF_AMS_MAX_REF_LLP);
-		extAttr->phaseCorrectionBypass = FALSE;
+		extAttr->phaseCorrectionBypass = false;
 		extAttr->atvIfAgcCfg.ctrlMode = DRX_AGC_CTRL_USER;
 		extAttr->atvIfAgcCfg.outputLevel = extAttr->atvRfAgcCfg.top;
-		extAttr->enableCVBSOutput = TRUE;
+		extAttr->enableCVBSOutput = true;
 		break;
 	default:
 		return (DRX_STS_ERROR);
 	}
 
 	/* Common initializations FM & NTSC & B/G & D/K & I & L & LP */
-	if (extAttr->hasLNA == FALSE) {
+	if (extAttr->hasLNA == false) {
 		WR16(devAddr, IQM_AF_AMUX__A, 0x01);
 	}
 
@@ -9409,12 +9409,12 @@ trouble ?
 	WR16(devAddr, SCU_RAM_GPIO__A, 0);
 
 	/* Override reset values with current shadow settings */
-	CHK_ERROR(AtvUpdateConfig(demod, TRUE));
+	CHK_ERROR(AtvUpdateConfig(demod, true));
 
 	/* Configure/restore AGC settings */
 	CHK_ERROR(InitAGC(demod));
-	CHK_ERROR(SetAgcIf(demod, &(extAttr->atvIfAgcCfg), FALSE));
-	CHK_ERROR(SetAgcRf(demod, &(extAttr->atvRfAgcCfg), FALSE));
+	CHK_ERROR(SetAgcIf(demod, &(extAttr->atvIfAgcCfg), false));
+	CHK_ERROR(SetAgcRf(demod, &(extAttr->atvRfAgcCfg), false));
 	CHK_ERROR(CtrlSetCfgPreSaw(demod, &(extAttr->atvPreSawCfg)));
 
 	/* Set SCU ATV substandard,assuming this doesn't require running ATV block */
@@ -9457,7 +9457,7 @@ rw_error:
 */
 static DRXStatus_t
 SetATVChannel(pDRXDemodInstance_t demod,
-	      DRXFrequency_t tunerFreqOffset,
+	      s32 tunerFreqOffset,
 	      pDRXChannel_t channel, DRXStandard_t standard)
 {
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
@@ -9495,9 +9495,9 @@ SetATVChannel(pDRXDemodInstance_t demod,
 	cmdSCU.result = &cmdResult;
 	CHK_ERROR(SCUCommand(devAddr, &cmdSCU));
 
-/*   if ( (extAttr->standard == DRX_STANDARD_FM) && (extAttr->flagSetAUDdone == TRUE) )
+/*   if ( (extAttr->standard == DRX_STANDARD_FM) && (extAttr->flagSetAUDdone == true) )
    {
-      extAttr->detectedRDS = (Bool_t)FALSE;
+      extAttr->detectedRDS = (bool)false;
    }*/
 
 	return (DRX_STS_OK);
@@ -9526,7 +9526,7 @@ static DRXStatus_t
 GetATVChannel(pDRXDemodInstance_t demod,
 	      pDRXChannel_t channel, DRXStandard_t standard)
 {
-	DRXFrequency_t offset = 0;
+	s32 offset = 0;
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
@@ -9553,7 +9553,7 @@ GetATVChannel(pDRXDemodInstance_t demod,
 				measuredOffset |= 0xFF80;
 			}
 			offset +=
-			    (DRXFrequency_t) (((s16) measuredOffset) * 10);
+			    (s32) (((s16) measuredOffset) * 10);
 			break;
 		}
 	case DRX_STANDARD_PAL_SECAM_LP:
@@ -9568,7 +9568,7 @@ GetATVChannel(pDRXDemodInstance_t demod,
 				measuredOffset |= 0xFF80;
 			}
 			offset -=
-			    (DRXFrequency_t) (((s16) measuredOffset) * 10);
+			    (s32) (((s16) measuredOffset) * 10);
 		}
 		break;
 	case DRX_STANDARD_FM:
@@ -9777,7 +9777,7 @@ rw_error:
 * \return DRXStatus_t.
 *
 */
-static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, Bool_t setStandard)
+static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, bool setStandard)
 {
 	DRXAudStandard_t audStandard = DRX_AUD_STANDARD_AUTO;
 	struct i2c_device_addr *devAddr = NULL;
@@ -9789,7 +9789,7 @@ static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, Bool_t setStandard)
 	WR16(devAddr, AUD_TOP_TR_MDE__A, 8);
 	WR16(devAddr, AUD_COMM_EXEC__A, AUD_COMM_EXEC_ACTIVE);
 
-	if (setStandard == TRUE) {
+	if (setStandard == true) {
 		CHK_ERROR(AUDCtrlSetStandard(demod, &audStandard));
 	}
 
@@ -9816,7 +9816,7 @@ static DRXStatus_t PowerDownAud(pDRXDemodInstance_t demod)
 
 	WR16(devAddr, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
 
-	extAttr->audData.audioIsActive = FALSE;
+	extAttr->audData.audioIsActive = false;
 
 	return DRX_STS_OK;
 rw_error:
@@ -9848,9 +9848,9 @@ static DRXStatus_t AUDGetModus(pDRXDemodInstance_t demod, u16 *modus)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* Modus register is combined in to RAM location */
@@ -9895,12 +9895,12 @@ AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 	}
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
-	status->valid = FALSE;
+	status->valid = false;
 
 	RR16(addr, AUD_DEM_RD_RDS_ARRAY_CNT__A, &rRDSArrayCntInit);
 
@@ -9917,7 +9917,7 @@ AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 
 	/* RDS is detected, as long as FM radio is selected assume
 	   RDS will be available                                    */
-	extAttr->audData.rdsDataPresent = TRUE;
+	extAttr->audData.rdsDataPresent = true;
 
 	/* new data */
 	/* read the data */
@@ -9929,7 +9929,7 @@ AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 	RR16(addr, AUD_DEM_RD_RDS_ARRAY_CNT__A, &rRDSArrayCntCheck);
 
 	if (rRDSArrayCntCheck == rRDSArrayCntInit) {
-		status->valid = TRUE;
+		status->valid = true;
 		extAttr->audData.rdsDataCounter = rRDSArrayCntCheck;
 	}
 
@@ -9962,17 +9962,17 @@ AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* initialize the variables */
-	status->carrierA = FALSE;
-	status->carrierB = FALSE;
+	status->carrierA = false;
+	status->carrierB = false;
 	status->nicamStatus = DRX_AUD_NICAM_NOT_DETECTED;
-	status->sap = FALSE;
-	status->stereo = FALSE;
+	status->sap = false;
+	status->stereo = false;
 
 	/* read stereo sound mode indication */
 	RR16(devAddr, AUD_DEM_RD_STATUS__A, &rData);
@@ -9980,13 +9980,13 @@ AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	/* carrier a detected */
 	if ((rData & AUD_DEM_RD_STATUS_STAT_CARR_A__M) ==
 	    AUD_DEM_RD_STATUS_STAT_CARR_A_DETECTED) {
-		status->carrierA = TRUE;
+		status->carrierA = true;
 	}
 
 	/* carrier b detected */
 	if ((rData & AUD_DEM_RD_STATUS_STAT_CARR_B__M) ==
 	    AUD_DEM_RD_STATUS_STAT_CARR_B_DETECTED) {
-		status->carrierB = TRUE;
+		status->carrierB = true;
 	}
 	/* nicam detected */
 	if ((rData & AUD_DEM_RD_STATUS_STAT_NICAM__M) ==
@@ -10002,13 +10002,13 @@ AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	/* audio mode bilingual or SAP detected */
 	if ((rData & AUD_DEM_RD_STATUS_STAT_BIL_OR_SAP__M) ==
 	    AUD_DEM_RD_STATUS_STAT_BIL_OR_SAP_SAP) {
-		status->sap = TRUE;
+		status->sap = true;
 	}
 
 	/* stereo detected */
 	if ((rData & AUD_DEM_RD_STATUS_STAT_STEREO__M) ==
 	    AUD_DEM_RD_STATUS_STAT_STEREO_STEREO) {
-		status->stereo = TRUE;
+		status->stereo = true;
 	}
 
 	return DRX_STS_OK;
@@ -10029,7 +10029,7 @@ AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 {
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
-	DRXCfgAudRDS_t rds = { FALSE, {0} };
+	DRXCfgAudRDS_t rds = { false, {0} };
 	u16 rData = 0;
 
 	if (status == NULL) {
@@ -10043,7 +10043,7 @@ AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	CHK_ERROR(AUDCtrlGetCarrierDetectStatus(demod, status));
 
 	/* rds data */
-	status->rds = FALSE;
+	status->rds = false;
 	CHK_ERROR(AUDCtrlGetCfgRDS(demod, &rds));
 	status->rds = extAttr->audData.rdsDataPresent;
 
@@ -10084,19 +10084,19 @@ AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* volume */
 	volume->mute = extAttr->audData.volume.mute;
 	RR16(devAddr, AUD_DSP_WR_VOLUME__A, &rVolume);
 	if (rVolume == 0) {
-		volume->mute = TRUE;
+		volume->mute = true;
 		volume->volume = extAttr->audData.volume.volume;
 	} else {
-		volume->mute = FALSE;
+		volume->mute = false;
 		volume->volume = ((rVolume & AUD_DSP_WR_VOLUME_VOL_MAIN__M) >>
 				  AUD_DSP_WR_VOLUME_VOL_MAIN__B) -
 		    AUD_VOLUME_ZERO_DB;
@@ -10216,9 +10216,9 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* volume */
@@ -10232,7 +10232,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 
 	/* clear the volume mask */
 	wVolume &= (u16) ~ AUD_DSP_WR_VOLUME_VOL_MAIN__M;
-	if (volume->mute == TRUE) {
+	if (volume->mute == true) {
 		/* mute */
 		/* mute overrules volume */
 		wVolume |= (u16) (0);
@@ -10351,9 +10351,9 @@ AUDCtrlGetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	RR16(devAddr, AUD_DEM_RAM_I2S_CONFIG2__A, &wI2SConfig);
@@ -10410,9 +10410,9 @@ AUDCtrlGetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	/* I2S output enabled */
 	if ((wI2SConfig & AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M)
 	    == AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE) {
-		output->outputEnable = TRUE;
+		output->outputEnable = true;
 	} else {
-		output->outputEnable = FALSE;
+		output->outputEnable = false;
 	}
 
 	if (rI2SFreq > 0) {
@@ -10457,9 +10457,9 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	RR16(devAddr, AUD_DEM_RAM_I2S_CONFIG2__A, &wI2SConfig);
@@ -10521,7 +10521,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 
 	/* I2S output enabled */
 	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
-	if (output->outputEnable == TRUE) {
+	if (output->outputEnable == true) {
 		wI2SConfig |= AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE;
 	} else {
 		wI2SConfig |= AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_DISABLE;
@@ -10609,9 +10609,9 @@ AUDCtrlGetCfgAutoSound(pDRXDemodInstance_t demod,
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	CHK_ERROR(AUDGetModus(demod, &rModus));
@@ -10667,9 +10667,9 @@ AUDCtrSetlCfgAutoSound(pDRXDemodInstance_t demod,
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	CHK_ERROR(AUDGetModus(demod, &rModus));
@@ -10733,9 +10733,9 @@ AUDCtrlGetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	RR16(devAddr, AUD_DEM_RAM_A2_THRSHLD__A, &thresA2);
@@ -10773,9 +10773,9 @@ AUDCtrlSetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	WR16(devAddr, AUD_DEM_WR_A2_THRSHLD__A, thres->a2);
@@ -10828,9 +10828,9 @@ AUDCtrlGetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	CHK_ERROR(AUDGetModus(demod, &wModus));
@@ -10928,9 +10928,9 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	CHK_ERROR(AUDGetModus(demod, &rModus));
@@ -11020,9 +11020,9 @@ AUDCtrlGetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* Source Selctor */
@@ -11115,9 +11115,9 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* Source Selctor */
@@ -11222,9 +11222,9 @@ AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* audio/video synchronisation */
@@ -11287,9 +11287,9 @@ AUDCtrlGetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* audio/video synchronisation */
@@ -11439,9 +11439,9 @@ AUDCtrlGetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* read register data */
@@ -11514,9 +11514,9 @@ AUDCtrlSetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* setting of max FM deviation */
@@ -11597,9 +11597,9 @@ static DRXStatus_t AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	if ((beep->volume > 0) || (beep->volume < -127)) {
@@ -11619,7 +11619,7 @@ static DRXStatus_t AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
 	}
 	theBeep |= (u16) frequency;
 
-	if (beep->mute == TRUE) {
+	if (beep->mute == true) {
 		theBeep = 0;
 	}
 
@@ -11649,7 +11649,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	u16 wModus = 0;
 	u16 rModus = 0;
 
-	Bool_t muteBuffer = FALSE;
+	bool muteBuffer = false;
 	s16 volumeBuffer = 0;
 	u16 wVolume = 0;
 
@@ -11661,19 +11661,19 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, FALSE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, false));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	/* reset RDS data availability flag */
-	extAttr->audData.rdsDataPresent = FALSE;
+	extAttr->audData.rdsDataPresent = false;
 
 	/* we need to mute from here to avoid noise during standard switching */
 	muteBuffer = extAttr->audData.volume.mute;
 	volumeBuffer = extAttr->audData.volume.volume;
 
-	extAttr->audData.volume.mute = TRUE;
+	extAttr->audData.volume.mute = true;
 	/* restore data structure from DRX ExtAttr, call volume first to mute */
 	CHK_ERROR(AUDCtrlSetCfgVolume(demod, &extAttr->audData.volume));
 	CHK_ERROR(AUDCtrlSetCfgCarrier(demod, &extAttr->audData.carriers));
@@ -11794,7 +11794,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	/* buffers intact                                                         */
    /**************************************************************************/
 	extAttr->audData.volume.mute = muteBuffer;
-	if (extAttr->audData.volume.mute == FALSE) {
+	if (extAttr->audData.volume.mute == false) {
 		wVolume |= (u16) ((volumeBuffer + AUD_VOLUME_ZERO_DB) <<
 				    AUD_DSP_WR_VOLUME_VOL_MAIN__B);
 		WR16(devAddr, AUD_DSP_WR_VOLUME__A, wVolume);
@@ -11832,9 +11832,9 @@ AUDCtrlGetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 
 	/* power up */
-	if (extAttr->audData.audioIsActive == FALSE) {
-		CHK_ERROR(PowerUpAud(demod, TRUE));
-		extAttr->audData.audioIsActive = TRUE;
+	if (extAttr->audData.audioIsActive == false) {
+		CHK_ERROR(PowerUpAud(demod, true));
+		extAttr->audData.audioIsActive = true;
 	}
 
 	*standard = DRX_AUD_STANDARD_UNKNOWN;
@@ -11932,7 +11932,7 @@ FmLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat)
 	CHK_ERROR(AUDCtrlGetCarrierDetectStatus(demod, &status));
 
 	/* locked if either primary or secondary carrier is detected */
-	if ((status.carrierA == TRUE) || (status.carrierB == TRUE)) {
+	if ((status.carrierA == true) || (status.carrierB == true)) {
 		*lockStat = DRX_LOCKED;
 	} else {
 		*lockStat = DRX_NOT_LOCKED;
@@ -12069,7 +12069,7 @@ GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, s32 *SymbolRateOffset)
 	s32 divisionFactor = 810;
 	u16 data = 0;
 	u32 symbolRate = 0;
-	Bool_t negative = FALSE;
+	bool negative = false;
 
 	*SymbolRateOffset = 0;
 	/* read data rate */
@@ -12100,7 +12100,7 @@ GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, s32 *SymbolRateOffset)
 			unsignedTimingOffset = 32768;
 		else
 			unsignedTimingOffset = 0x00007FFF & (u32) (-data);
-		negative = TRUE;
+		negative = true;
 	} else
 		unsignedTimingOffset = (u32) data;
 
@@ -12132,7 +12132,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-GetOOBFreqOffset(pDRXDemodInstance_t demod, pDRXFrequency_t freqOffset)
+GetOOBFreqOffset(pDRXDemodInstance_t demod, s32 *freqOffset)
 {
 	u16 data = 0;
 	u16 rot = 0;
@@ -12233,11 +12233,11 @@ rw_error:
 *
 */
 static DRXStatus_t
-GetOOBFrequency(pDRXDemodInstance_t demod, pDRXFrequency_t frequency)
+GetOOBFrequency(pDRXDemodInstance_t demod, s32 *frequency)
 {
 	u16 data = 0;
-	DRXFrequency_t freqOffset = 0;
-	DRXFrequency_t freq = 0;
+	s32 freqOffset = 0;
+	s32 freq = 0;
 	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -12246,7 +12246,7 @@ GetOOBFrequency(pDRXDemodInstance_t demod, pDRXFrequency_t frequency)
 
 	SARR16(devAddr, SCU_RAM_ORX_RF_RX_FREQUENCY_VALUE__A, &data);
 
-	freq = (DRXFrequency_t) ((DRXFrequency_t) data * 50 + 50000L);
+	freq = (s32) ((s32) data * 50 + 50000L);
 
 	CHK_ERROR(GetOOBFreqOffset(demod, &freqOffset));
 
@@ -12408,7 +12408,7 @@ rw_error:
 * \param active
 * \return DRXStatus_t.
 */
-static DRXStatus_t SetOrxNsuAox(pDRXDemodInstance_t demod, Bool_t active)
+static DRXStatus_t SetOrxNsuAox(pDRXDemodInstance_t demod, bool active)
 {
 	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -12475,11 +12475,11 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 {
 #ifndef DRXJ_DIGITAL_ONLY
 	DRXOOBDownstreamStandard_t standard = DRX_OOB_MODE_A;
-	DRXFrequency_t freq = 0;	/* KHz */
+	s32 freq = 0;	/* KHz */
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	u16 i = 0;
-	Bool_t mirrorFreqSpectOOB = FALSE;
+	bool mirrorFreqSpectOOB = false;
 	u16 trkFilterValue = 0;
 	DRXJSCUCmd_t scuCmd;
 	u16 setParamParameters[3];
@@ -12512,10 +12512,10 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 		scuCmd.resultLen = 1;
 		scuCmd.result = cmdResult;
 		CHK_ERROR(SCUCommand(devAddr, &scuCmd));
-		CHK_ERROR(SetOrxNsuAox(demod, FALSE));
+		CHK_ERROR(SetOrxNsuAox(demod, false));
 		WR16(devAddr, ORX_COMM_EXEC__A, ORX_COMM_EXEC_STOP);
 
-		extAttr->oobPowerOn = FALSE;
+		extAttr->oobPowerOn = false;
 		return (DRX_STS_OK);
 	}
 
@@ -12571,14 +12571,14 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 	case DRX_OOB_MODE_A:
 		if (
 			   /* signal is transmitted inverted */
-			   ((oobParam->spectrumInverted == TRUE) &
+			   ((oobParam->spectrumInverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (mirrorFreqSpectOOB == FALSE)) |
+			    (mirrorFreqSpectOOB == false)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
-			   ((oobParam->spectrumInverted == FALSE) &
+			   ((oobParam->spectrumInverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirrorFreqSpectOOB == TRUE))
+			    (mirrorFreqSpectOOB == true))
 		    )
 			setParamParameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_2048KBPS_INVSPEC;
@@ -12589,14 +12589,14 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 	case DRX_OOB_MODE_B_GRADE_A:
 		if (
 			   /* signal is transmitted inverted */
-			   ((oobParam->spectrumInverted == TRUE) &
+			   ((oobParam->spectrumInverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (mirrorFreqSpectOOB == FALSE)) |
+			    (mirrorFreqSpectOOB == false)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
-			   ((oobParam->spectrumInverted == FALSE) &
+			   ((oobParam->spectrumInverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirrorFreqSpectOOB == TRUE))
+			    (mirrorFreqSpectOOB == true))
 		    )
 			setParamParameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_1544KBPS_INVSPEC;
@@ -12608,14 +12608,14 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 	default:
 		if (
 			   /* signal is transmitted inverted */
-			   ((oobParam->spectrumInverted == TRUE) &
+			   ((oobParam->spectrumInverted == true) &
 			    /* and tuner is not mirroring the signal */
-			    (mirrorFreqSpectOOB == FALSE)) |
+			    (mirrorFreqSpectOOB == false)) |
 			   /* or */
 			   /* signal is transmitted noninverted */
-			   ((oobParam->spectrumInverted == FALSE) &
+			   ((oobParam->spectrumInverted == false) &
 			    /* and tuner is mirroring the signal */
-			    (mirrorFreqSpectOOB == TRUE))
+			    (mirrorFreqSpectOOB == true))
 		    )
 			setParamParameters[0] =
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_3088KBPS_INVSPEC;
@@ -12728,10 +12728,10 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 	scuCmd.result = cmdResult;
 	CHK_ERROR(SCUCommand(devAddr, &scuCmd));
 
-	CHK_ERROR(SetOrxNsuAox(demod, TRUE));
+	CHK_ERROR(SetOrxNsuAox(demod, true));
 	WR16(devAddr, ORX_NSU_AOX_STHR_W__A, extAttr->oobPreSaw);
 
-	extAttr->oobPowerOn = TRUE;
+	extAttr->oobPowerOn = true;
 
 	return (DRX_STS_OK);
 rw_error:
@@ -12762,7 +12762,7 @@ CtrlGetOOB(pDRXDemodInstance_t demod, pDRXOOBStatus_t oobStatus)
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	if (extAttr->oobPowerOn == FALSE)
+	if (extAttr->oobPowerOn == false)
 		return (DRX_STS_ERROR);
 
 	RR16(devAddr, ORX_DDC_OFO_SET_W__A, &data);
@@ -12908,16 +12908,16 @@ static DRXStatus_t
 CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
 
-	DRXFrequency_t tunerSetFreq = 0;
-	DRXFrequency_t tunerGetFreq = 0;
-	DRXFrequency_t tunerFreqOffset = 0;
-	DRXFrequency_t intermediateFreq = 0;
+	s32 tunerSetFreq = 0;
+	s32 tunerGetFreq = 0;
+	s32 tunerFreqOffset = 0;
+	s32 intermediateFreq = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	TUNERMode_t tunerMode = 0;
 	pDRXCommonAttr_t commonAttr = NULL;
-	Bool_t bridgeClosed = FALSE;
+	bool bridgeClosed = false;
 #ifndef DRXJ_VSB_ONLY
 	u32 minSymbolRate = 0;
 	u32 maxSymbolRate = 0;
@@ -13093,17 +13093,17 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 
 	if ((extAttr->uioSmaTxMode) == DRX_UIO_MODE_FIRMWARE_SAW) {
 		/* SAW SW, user UIO is used for switchable SAW */
-		DRXUIOData_t uio1 = { DRX_UIO1, FALSE };
+		DRXUIOData_t uio1 = { DRX_UIO1, false };
 
 		switch (channel->bandwidth) {
 		case DRX_BANDWIDTH_8MHZ:
-			uio1.value = TRUE;
+			uio1.value = true;
 			break;
 		case DRX_BANDWIDTH_7MHZ:
-			uio1.value = FALSE;
+			uio1.value = false;
 			break;
 		case DRX_BANDWIDTH_6MHZ:
-			uio1.value = FALSE;
+			uio1.value = false;
 			break;
 		case DRX_BANDWIDTH_UNKNOWN:
 		default:
@@ -13179,7 +13179,7 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 		extAttr->frequency = tunerSetFreq;
 		if (commonAttr->tunerPortNr == 1) {
 			/* close tuner bridge */
-			bridgeClosed = TRUE;
+			bridgeClosed = true;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 			/* set tuner frequency */
 		}
@@ -13188,7 +13188,7 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 						    tunerMode, tunerSetFreq));
 		if (commonAttr->tunerPortNr == 1) {
 			/* open tuner bridge */
-			bridgeClosed = FALSE;
+			bridgeClosed = false;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 
@@ -13253,7 +13253,7 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 
 		if (commonAttr->tunerPortNr == 1) {
 			/* close tuner bridge */
-			bridgeClosed = TRUE;
+			bridgeClosed = true;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 
@@ -13262,14 +13262,14 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 						    tunerMode, tunerSetFreq));
 		if (commonAttr->tunerPortNr == 1) {
 			/* open tuner bridge */
-			bridgeClosed = FALSE;
+			bridgeClosed = false;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 	}
 
 	/* if ( demod->myTuner !=NULL ) */
 	/* flag the packet error counter reset */
-	extAttr->resetPktErrAcc = TRUE;
+	extAttr->resetPktErrAcc = true;
 
 	return (DRX_STS_OK);
 rw_error:
@@ -13294,7 +13294,7 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	pDRXCommonAttr_t commonAttr = NULL;
-	DRXFrequency_t intermediateFreq = 0;
+	s32 intermediateFreq = 0;
 	s32 CTLFreqOffset = 0;
 	u32 iqmRcRateLo = 0;
 	u32 adcFrequency = 0;
@@ -13331,8 +13331,8 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	channel->ldpc = DRX_LDPC_UNKNOWN;
 
 	if (demod->myTuner != NULL) {
-		DRXFrequency_t tunerFreqOffset = 0;
-		Bool_t tunerMirror = commonAttr->mirrorFreqSpect ? FALSE : TRUE;
+		s32 tunerFreqOffset = 0;
+		bool tunerMirror = commonAttr->mirrorFreqSpect ? false : true;
 
 		/* Get frequency from tuner */
 		CHK_ERROR(DRXBSP_TUNER_GetFrequency(demod->myTuner,
@@ -13340,7 +13340,7 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 						    &(channel->frequency),
 						    &intermediateFreq));
 		tunerFreqOffset = channel->frequency - extAttr->frequency;
-		if (tunerMirror == TRUE) {
+		if (tunerMirror == true) {
 			/* positive image */
 			channel->frequency += tunerFreqOffset;
 		} else {
@@ -13838,11 +13838,11 @@ CtrlSetStandard(pDRXDemodInstance_t demod, pDRXStandard_t standard)
 	case DRX_STANDARD_ITU_A:	/* fallthrough */
 	case DRX_STANDARD_ITU_B:	/* fallthrough */
 	case DRX_STANDARD_ITU_C:
-		CHK_ERROR(PowerDownQAM(demod, FALSE));
+		CHK_ERROR(PowerDownQAM(demod, false));
 		break;
 #endif
 	case DRX_STANDARD_8VSB:
-		CHK_ERROR(PowerDownVSB(demod, FALSE));
+		CHK_ERROR(PowerDownVSB(demod, false));
 		break;
 #ifndef DRXJ_DIGITAL_ONLY
 	case DRX_STANDARD_NTSC:	/* fallthrough */
@@ -13852,7 +13852,7 @@ CtrlSetStandard(pDRXDemodInstance_t demod, pDRXStandard_t standard)
 	case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
 	case DRX_STANDARD_PAL_SECAM_LP:
-		CHK_ERROR(PowerDownATV(demod, prevStandard, FALSE));
+		CHK_ERROR(PowerDownATV(demod, prevStandard, false));
 		break;
 #endif
 	case DRX_STANDARD_UNKNOWN:
@@ -14058,10 +14058,10 @@ CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode)
 		case DRX_STANDARD_ITU_A:
 		case DRX_STANDARD_ITU_B:
 		case DRX_STANDARD_ITU_C:
-			CHK_ERROR(PowerDownQAM(demod, TRUE));
+			CHK_ERROR(PowerDownQAM(demod, true));
 			break;
 		case DRX_STANDARD_8VSB:
-			CHK_ERROR(PowerDownVSB(demod, TRUE));
+			CHK_ERROR(PowerDownVSB(demod, true));
 			break;
 		case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
 		case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
@@ -14070,7 +14070,7 @@ CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode)
 		case DRX_STANDARD_PAL_SECAM_LP:	/* fallthrough */
 		case DRX_STANDARD_NTSC:	/* fallthrough */
 		case DRX_STANDARD_FM:
-			CHK_ERROR(PowerDownATV(demod, extAttr->standard, TRUE));
+			CHK_ERROR(PowerDownATV(demod, extAttr->standard, true));
 			break;
 		case DRX_STANDARD_UNKNOWN:
 			/* Do nothing */
@@ -14152,7 +14152,7 @@ CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 	extAttr->vVersion[0].moduleName = ucodeName;
 	extAttr->vVersion[0].vString = extAttr->vText[0];
 
-	if (commonAttr->isOpened == TRUE) {
+	if (commonAttr->isOpened == true) {
 		SARR16(devAddr, SCU_RAM_VERSION_HI__A, &ucodeMajorMinor);
 		SARR16(devAddr, SCU_RAM_VERSION_LO__A, &ucodePatch);
 
@@ -14280,7 +14280,7 @@ static DRXStatus_t CtrlProbeDevice(pDRXDemodInstance_t demod)
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 
-	if (commonAttr->isOpened == FALSE
+	if (commonAttr->isOpened == false
 	    || commonAttr->currentPowerMode != DRX_POWER_UP) {
 		struct i2c_device_addr *devAddr = NULL;
 		DRXPowerMode_t powerMode = DRX_POWER_UP;
@@ -14291,7 +14291,7 @@ static DRXStatus_t CtrlProbeDevice(pDRXDemodInstance_t demod)
 		/* Remeber original power mode */
 		orgPowerMode = commonAttr->currentPowerMode;
 
-		if (demod->myCommonAttr->isOpened == FALSE) {
+		if (demod->myCommonAttr->isOpened == false) {
 			CHK_ERROR(PowerUpDevice(demod));
 			commonAttr->currentPowerMode = DRX_POWER_UP;
 		} else {
@@ -14345,16 +14345,16 @@ rw_error:
 * \fn DRXStatus_t IsMCBlockAudio()
 * \brief Check if MC block is Audio or not Audio.
 * \param addr        Pointer to demodulator instance.
-* \param audioUpload TRUE  if MC block is Audio
-		     FALSE if MC block not Audio
-* \return Bool_t.
+* \param audioUpload true  if MC block is Audio
+		     false if MC block not Audio
+* \return bool.
 */
-Bool_t IsMCBlockAudio(u32 addr)
+bool IsMCBlockAudio(u32 addr)
 {
 	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A)) {
-		return (TRUE);
+		return (true);
 	}
-	return (FALSE);
+	return (false);
 }
 
 /*============================================================================*/
@@ -14365,14 +14365,14 @@ Bool_t IsMCBlockAudio(u32 addr)
 * \param demod          Pointer to demodulator instance.
 * \param mcInfo         Pointer to information about microcode data.
 * \param action         Either UCODE_UPLOAD or UCODE_VERIFY.
-* \param uploadAudioMC  TRUE  if Audio MC need to be uploaded.
-			FALSE if !Audio MC need to be uploaded.
+* \param uploadAudioMC  true  if Audio MC need to be uploaded.
+			false if !Audio MC need to be uploaded.
 * \return DRXStatus_t.
 */
 static DRXStatus_t
 CtrlUCodeUpload(pDRXDemodInstance_t demod,
 		pDRXUCodeInfo_t mcInfo,
-		DRXUCodeAction_t action, Bool_t uploadAudioMC)
+		DRXUCodeAction_t action, bool uploadAudioMC)
 {
 	u16 i = 0;
 	u16 mcNrOfBlks = 0;
@@ -14526,8 +14526,8 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 		mcData += mcBlockNrBytes;
 	}			/* for( i = 0 ; i<mcNrOfBlks ; i++ ) */
 
-	if (uploadAudioMC == FALSE) {
-		extAttr->flagAudMcUploaded = FALSE;
+	if (uploadAudioMC == false) {
+		extAttr->flagAudMcUploaded = false;
 	}
 
 	return (DRX_STS_OK);
@@ -14636,12 +14636,12 @@ CtrlGetCfgOOBMisc(pDRXDemodInstance_t demod, pDRXJCfgOOBMisc_t misc)
 
 	SARR16(devAddr, SCU_RAM_ORX_SCU_LOCK__A, &lock);
 
-	misc->anaGainLock = ((lock & 0x0001) ? TRUE : FALSE);
-	misc->digGainLock = ((lock & 0x0002) ? TRUE : FALSE);
-	misc->freqLock = ((lock & 0x0004) ? TRUE : FALSE);
-	misc->phaseLock = ((lock & 0x0008) ? TRUE : FALSE);
-	misc->symTimingLock = ((lock & 0x0010) ? TRUE : FALSE);
-	misc->eqLock = ((lock & 0x0020) ? TRUE : FALSE);
+	misc->anaGainLock = ((lock & 0x0001) ? true : false);
+	misc->digGainLock = ((lock & 0x0002) ? true : false);
+	misc->freqLock = ((lock & 0x0004) ? true : false);
+	misc->phaseLock = ((lock & 0x0008) ? true : false);
+	misc->symTimingLock = ((lock & 0x0010) ? true : false);
+	misc->eqLock = ((lock & 0x0020) ? true : false);
 
 	SARR16(devAddr, SCU_RAM_ORX_SCU_STATE__A, &state);
 	misc->state = (state >> 8) & 0xff;
@@ -14724,7 +14724,7 @@ CtrlSetCfgAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:
 #endif
-		return SetAgcIf(demod, agcSettings, TRUE);
+		return SetAgcIf(demod, agcSettings, true);
 	case DRX_STANDARD_UNKNOWN:
 	default:
 		return (DRX_STS_INVALID_ARG);
@@ -14827,7 +14827,7 @@ CtrlSetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 	case DRX_STANDARD_NTSC:	/* fallthrough */
 	case DRX_STANDARD_FM:
 #endif
-		return SetAgcRf(demod, agcSettings, TRUE);
+		return SetAgcRf(demod, agcSettings, true);
 	case DRX_STANDARD_UNKNOWN:
 	default:
 		return (DRX_STS_INVALID_ARG);
@@ -15293,7 +15293,7 @@ static DRXStatus_t CtrlSetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 					    (pDRXCfgMPEGOutput_t) config->
 					    cfgData);
 	case DRX_CFG_PINS_SAFE_MODE:
-		return CtrlSetCfgPdrSafeMode(demod, (pBool_t) config->cfgData);
+		return CtrlSetCfgPdrSafeMode(demod, (bool *) config->cfgData);
 	case DRXJ_CFG_AGC_RF:
 		return CtrlSetCfgAgcRf(demod, (pDRXJCfgAgc_t) config->cfgData);
 	case DRXJ_CFG_AGC_IF:
@@ -15402,7 +15402,7 @@ static DRXStatus_t CtrlGetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 					    (pDRXCfgMPEGOutput_t) config->
 					    cfgData);
 	case DRX_CFG_PINS_SAFE_MODE:
-		return CtrlGetCfgPdrSafeMode(demod, (pBool_t) config->cfgData);
+		return CtrlGetCfgPdrSafeMode(demod, (bool *) config->cfgData);
 	case DRXJ_CFG_AGC_RF:
 		return CtrlGetCfgAgcRf(demod, (pDRXJCfgAgc_t) config->cfgData);
 	case DRXJ_CFG_AGC_IF:
@@ -15556,13 +15556,13 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	WR16(devAddr, ATV_TOP_STDBY__A, (~ATV_TOP_STDBY_CVBS_STDBY_A2_ACTIVE)
 	     | ATV_TOP_STDBY_SIF_STDBY_STANDBY);
 
-	CHK_ERROR(SetIqmAf(demod, FALSE));
-	CHK_ERROR(SetOrxNsuAox(demod, FALSE));
+	CHK_ERROR(SetIqmAf(demod, false));
+	CHK_ERROR(SetOrxNsuAox(demod, false));
 
 	CHK_ERROR(InitHI(demod));
 
 	/* disable mpegoutput pins */
-	cfgMPEGOutput.enableMPEGOutput = FALSE;
+	cfgMPEGOutput.enableMPEGOutput = false;
 	CHK_ERROR(CtrlSetCfgMPEGOutput(demod, &cfgMPEGOutput));
 	/* Stop AUD Inform SetAudio it will need to do all setting */
 	CHK_ERROR(PowerDownAud(demod));
@@ -15573,27 +15573,27 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	if (commonAttr->microcode != NULL) {
 		/* Dirty trick to use common ucode upload & verify,
 		   pretend device is already open */
-		commonAttr->isOpened = TRUE;
+		commonAttr->isOpened = true;
 		ucodeInfo.mcData = commonAttr->microcode;
 		ucodeInfo.mcSize = commonAttr->microcodeSize;
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 		/* Upload microcode without audio part */
 		CHK_ERROR(CtrlUCodeUpload
-			  (demod, &ucodeInfo, UCODE_UPLOAD, FALSE));
+			  (demod, &ucodeInfo, UCODE_UPLOAD, false));
 #else
 		CHK_ERROR(DRX_Ctrl(demod, DRX_CTRL_LOAD_UCODE, &ucodeInfo));
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
-		if (commonAttr->verifyMicrocode == TRUE) {
+		if (commonAttr->verifyMicrocode == true) {
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 			CHK_ERROR(CtrlUCodeUpload
-				  (demod, &ucodeInfo, UCODE_VERIFY, FALSE));
+				  (demod, &ucodeInfo, UCODE_VERIFY, false));
 #else
 			CHK_ERROR(DRX_Ctrl
 				  (demod, DRX_CTRL_VERIFY_UCODE, &ucodeInfo));
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 		}
-		commonAttr->isOpened = FALSE;
+		commonAttr->isOpened = false;
 	}
 
 	/* Run SCU for a little while to initialize microcode version numbers */
@@ -15604,14 +15604,14 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 		demod->myTuner->myCommonAttr->myUserData = (void *)demod;
 
 		if (commonAttr->tunerPortNr == 1) {
-			Bool_t bridgeClosed = TRUE;
+			bool bridgeClosed = true;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 
 		CHK_ERROR(DRXBSP_TUNER_Open(demod->myTuner));
 
 		if (commonAttr->tunerPortNr == 1) {
-			Bool_t bridgeClosed = FALSE;
+			bool bridgeClosed = false;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 		commonAttr->tunerMinFreqRF =
@@ -15666,7 +15666,7 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	extAttr->qamRfAgcCfg.cutOffCurrent = 4000;
 	extAttr->qamPreSawCfg.standard = DRX_STANDARD_ITU_B;
 	extAttr->qamPreSawCfg.reference = 0x07;
-	extAttr->qamPreSawCfg.usePreSaw = TRUE;
+	extAttr->qamPreSawCfg.usePreSaw = true;
 #endif
 	/* Initialize default AFE configuartion for VSB */
 	extAttr->vsbRfAgcCfg.standard = DRX_STANDARD_8VSB;
@@ -15678,7 +15678,7 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	extAttr->vsbRfAgcCfg.cutOffCurrent = 4000;
 	extAttr->vsbPreSawCfg.standard = DRX_STANDARD_8VSB;
 	extAttr->vsbPreSawCfg.reference = 0x07;
-	extAttr->vsbPreSawCfg.usePreSaw = TRUE;
+	extAttr->vsbPreSawCfg.usePreSaw = true;
 
 #ifndef DRXJ_DIGITAL_ONLY
 	/* Initialize default AFE configuartion for ATV */
@@ -15692,7 +15692,7 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	extAttr->atvIfAgcCfg.speed = 3;
 	extAttr->atvIfAgcCfg.top = 2400;
 	extAttr->atvPreSawCfg.reference = 0x0007;
-	extAttr->atvPreSawCfg.usePreSaw = TRUE;
+	extAttr->atvPreSawCfg.usePreSaw = true;
 	extAttr->atvPreSawCfg.standard = DRX_STANDARD_NTSC;
 #endif
 	extAttr->standard = DRX_STANDARD_UNKNOWN;
@@ -15727,7 +15727,7 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 
 	return (DRX_STS_OK);
 rw_error:
-	commonAttr->isOpened = FALSE;
+	commonAttr->isOpened = false;
 	return (DRX_STS_ERROR);
 }
 
@@ -15755,12 +15755,12 @@ DRXStatus_t DRXJ_Close(pDRXDemodInstance_t demod)
 	if (demod->myTuner != NULL) {
 		/* Check if bridge is used */
 		if (commonAttr->tunerPortNr == 1) {
-			Bool_t bridgeClosed = TRUE;
+			bool bridgeClosed = true;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 		CHK_ERROR(DRXBSP_TUNER_Close(demod->myTuner));
 		if (commonAttr->tunerPortNr == 1) {
-			Bool_t bridgeClosed = FALSE;
+			bool bridgeClosed = false;
 			CHK_ERROR(CtrlI2CBridge(demod, &bridgeClosed));
 		}
 	};
@@ -15830,7 +15830,7 @@ DRXJ_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
       /*======================================================================*/
 	case DRX_CTRL_I2C_BRIDGE:
 		{
-			return CtrlI2CBridge(demod, (pBool_t) ctrlData);
+			return CtrlI2CBridge(demod, (bool *) ctrlData);
 		}
 		break;
       /*======================================================================*/
@@ -15949,14 +15949,14 @@ DRXJ_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
 		{
 			return CtrlUCodeUpload(demod,
 					       (pDRXUCodeInfo_t) ctrlData,
-					       UCODE_UPLOAD, FALSE);
+					       UCODE_UPLOAD, false);
 		}
 		break;
 	case DRX_CTRL_VERIFY_UCODE:
 		{
 			return CtrlUCodeUpload(demod,
 					       (pDRXUCodeInfo_t) ctrlData,
-					       UCODE_VERIFY, FALSE);
+					       UCODE_VERIFY, false);
 		}
 		break;
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 29b6450fb3c4..87a8f2c188d4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -204,7 +204,7 @@ TYPEDEFS
 	typedef struct {
 		DRXStandard_t standard;	/* standard to which these settings apply */
 		u16 reference;	/* pre SAW reference value, range 0 .. 31 */
-		Bool_t usePreSaw;	/* TRUE algorithms must use pre SAW sense */
+		bool usePreSaw;	/* true algorithms must use pre SAW sense */
 	} DRXJCfgPreSaw_t, *pDRXJCfgPreSaw_t;
 
 /* DRXJ_CFG_AFE_GAIN */
@@ -279,8 +279,8 @@ TYPEDEFS
 * set MPEG output clock rate
 */
 	typedef struct {
-		Bool_t disableTEIHandling;	      /**< if TRUE pass (not change) TEI bit */
-		Bool_t bitReverseMpegOutout;	      /**< if TRUE, parallel: msb on MD0; serial: lsb out first */
+		bool disableTEIHandling;	      /**< if true pass (not change) TEI bit */
+		bool bitReverseMpegOutout;	      /**< if true, parallel: msb on MD0; serial: lsb out first */
 		DRXJMpegOutputClockRate_t mpegOutputClockRate;
 						      /**< set MPEG output clock rate that overwirtes the derived one from symbol rate */
 		DRXJMpegStartWidth_t mpegStartWidth;  /**< set MPEG output start width */
@@ -341,12 +341,12 @@ TYPEDEFS
 
 	typedef struct {
 		DRXJAgcStatus_t agc;
-		Bool_t eqLock;
-		Bool_t symTimingLock;
-		Bool_t phaseLock;
-		Bool_t freqLock;
-		Bool_t digGainLock;
-		Bool_t anaGainLock;
+		bool eqLock;
+		bool symTimingLock;
+		bool phaseLock;
+		bool freqLock;
+		bool digGainLock;
+		bool anaGainLock;
 		u8 state;
 	} DRXJCfgOOBMisc_t, *pDRXJCfgOOBMisc_t;
 
@@ -407,8 +407,8 @@ TYPEDEFS
 *
 */
 	typedef struct {
-		Bool_t enableCVBSOutput;	/* TRUE= enabled */
-		Bool_t enableSIFOutput;	/* TRUE= enabled */
+		bool enableCVBSOutput;	/* true= enabled */
+		bool enableSIFOutput;	/* true= enabled */
 		DRXJSIFAttenuation_t sifAttenuation;
 	} DRXJCfgAtvOutput_t, *pDRXJCfgAtvOutput_t;
 
@@ -447,25 +447,25 @@ TYPEDEFS
 */
 	typedef struct {
 		/* device capabilties (determined during DRX_Open()) */
-		Bool_t hasLNA;		  /**< TRUE if LNA (aka PGA) present */
-		Bool_t hasOOB;		  /**< TRUE if OOB supported */
-		Bool_t hasNTSC;		  /**< TRUE if NTSC supported */
-		Bool_t hasBTSC;		  /**< TRUE if BTSC supported */
-		Bool_t hasSMATX;	  /**< TRUE if mat_tx is available */
-		Bool_t hasSMARX;	  /**< TRUE if mat_rx is available */
-		Bool_t hasGPIO;		  /**< TRUE if GPIO is available */
-		Bool_t hasIRQN;		  /**< TRUE if IRQN is available */
+		bool hasLNA;		  /**< true if LNA (aka PGA) present */
+		bool hasOOB;		  /**< true if OOB supported */
+		bool hasNTSC;		  /**< true if NTSC supported */
+		bool hasBTSC;		  /**< true if BTSC supported */
+		bool hasSMATX;	  /**< true if mat_tx is available */
+		bool hasSMARX;	  /**< true if mat_rx is available */
+		bool hasGPIO;		  /**< true if GPIO is available */
+		bool hasIRQN;		  /**< true if IRQN is available */
 		/* A1/A2/A... */
 		u8 mfx;		  /**< metal fix */
 
 		/* tuner settings */
-		Bool_t mirrorFreqSpectOOB;/**< tuner inversion (TRUE = tuner mirrors the signal */
+		bool mirrorFreqSpectOOB;/**< tuner inversion (true = tuner mirrors the signal */
 
 		/* standard/channel settings */
 		DRXStandard_t standard;	  /**< current standard information                     */
 		DRXConstellation_t constellation;
 					  /**< current constellation                            */
-		DRXFrequency_t frequency; /**< center signal frequency in KHz                   */
+		s32 frequency; /**< center signal frequency in KHz                   */
 		DRXBandwidth_t currBandwidth;
 					  /**< current channel bandwidth                        */
 		DRXMirror_t mirror;	  /**< current channel mirror                           */
@@ -478,7 +478,7 @@ TYPEDEFS
 		u16 fecRsPlen;	  /**< defines RS BER measurement period                */
 		u16 fecRsPrescale;	  /**< ReedSolomon Measurement Prescale                 */
 		u16 fecRsPeriod;	  /**< ReedSolomon Measurement period                   */
-		Bool_t resetPktErrAcc;	  /**< Set a flag to reset accumulated packet error     */
+		bool resetPktErrAcc;	  /**< Set a flag to reset accumulated packet error     */
 		u16 pktErrAccStart;	  /**< Set a flag to reset accumulated packet error     */
 
 		/* HI configuration */
@@ -496,7 +496,7 @@ TYPEDEFS
 
 		/* IQM fs frequecy shift and inversion */
 		u32 iqmFsRateOfs;	   /**< frequency shifter setting after setchannel      */
-		Bool_t posImage;	   /**< Ture: positive image                            */
+		bool posImage;	   /**< Ture: positive image                            */
 		/* IQM RC frequecy shift */
 		u32 iqmRcRateOfs;	   /**< frequency shifter setting after setchannel      */
 
@@ -506,11 +506,11 @@ TYPEDEFS
 		s16 atvTopEqu1[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU1__A */
 		s16 atvTopEqu2[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU2__A */
 		s16 atvTopEqu3[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU3__A */
-		Bool_t phaseCorrectionBypass;/**< flag: TRUE=bypass */
+		bool phaseCorrectionBypass;/**< flag: true=bypass */
 		s16 atvTopVidPeak;	  /**< shadow of ATV_TOP_VID_PEAK__A */
 		u16 atvTopNoiseTh;	  /**< shadow of ATV_TOP_NOISE_TH__A */
-		Bool_t enableCVBSOutput;  /**< flag CVBS ouput enable */
-		Bool_t enableSIFOutput;	  /**< flag SIF ouput enable */
+		bool enableCVBSOutput;  /**< flag CVBS ouput enable */
+		bool enableSIFOutput;	  /**< flag SIF ouput enable */
 		 DRXJSIFAttenuation_t sifAttenuation;
 					  /**< current SIF att setting */
 		/* Agc configuration for QAM and VSB */
@@ -536,16 +536,16 @@ TYPEDEFS
 					  /**< allocated version list */
 
 		/* smart antenna configuration */
-		Bool_t smartAntInverted;
+		bool smartAntInverted;
 
 		/* Tracking filter setting for OOB */
 		u16 oobTrkFilterCfg[8];
-		Bool_t oobPowerOn;
+		bool oobPowerOn;
 
 		/* MPEG static bitrate setting */
 		u32 mpegTsStaticBitrate;  /**< bitrate static MPEG output */
-		Bool_t disableTEIhandling;  /**< MPEG TS TEI handling */
-		Bool_t bitReverseMpegOutout;/**< MPEG output bit order */
+		bool disableTEIhandling;  /**< MPEG TS TEI handling */
+		bool bitReverseMpegOutout;/**< MPEG output bit order */
 		 DRXJMpegOutputClockRate_t mpegOutputClockRate;
 					    /**< MPEG output clock rate */
 		 DRXJMpegStartWidth_t mpegStartWidth;
@@ -561,7 +561,7 @@ TYPEDEFS
 		u32 currSymbolRate;
 
 		/* pin-safe mode */
-		Bool_t pdrSafeMode;	    /**< PDR safe mode activated      */
+		bool pdrSafeMode;	    /**< PDR safe mode activated      */
 		u16 pdrSafeRestoreValGpio;
 		u16 pdrSafeRestoreValVSync;
 		u16 pdrSafeRestoreValSmaRx;
@@ -631,7 +631,7 @@ DEFINES
 * Fcentre = Fpc + DRXJ_NTSC_CARRIER_FREQ_OFFSET
 *
 */
-#define DRXJ_NTSC_CARRIER_FREQ_OFFSET           ((DRXFrequency_t)(1750))
+#define DRXJ_NTSC_CARRIER_FREQ_OFFSET           ((s32)(1750))
 
 /**
 * \def DRXJ_PAL_SECAM_BG_CARRIER_FREQ_OFFSET
@@ -647,7 +647,7 @@ DEFINES
 * care of this.
 *
 */
-#define DRXJ_PAL_SECAM_BG_CARRIER_FREQ_OFFSET   ((DRXFrequency_t)(2375))
+#define DRXJ_PAL_SECAM_BG_CARRIER_FREQ_OFFSET   ((s32)(2375))
 
 /**
 * \def DRXJ_PAL_SECAM_DKIL_CARRIER_FREQ_OFFSET
@@ -663,7 +663,7 @@ DEFINES
 * care of this.
 *
 */
-#define DRXJ_PAL_SECAM_DKIL_CARRIER_FREQ_OFFSET ((DRXFrequency_t)(2775))
+#define DRXJ_PAL_SECAM_DKIL_CARRIER_FREQ_OFFSET ((s32)(2775))
 
 /**
 * \def DRXJ_PAL_SECAM_LP_CARRIER_FREQ_OFFSET
@@ -678,7 +678,7 @@ DEFINES
 * In case the tuner module is NOT used the application programmer must take
 * care of this.
 */
-#define DRXJ_PAL_SECAM_LP_CARRIER_FREQ_OFFSET   ((DRXFrequency_t)(-3255))
+#define DRXJ_PAL_SECAM_LP_CARRIER_FREQ_OFFSET   ((s32)(-3255))
 
 /**
 * \def DRXJ_FM_CARRIER_FREQ_OFFSET
@@ -694,7 +694,7 @@ DEFINES
 * Ffm = Fsc + DRXJ_FM_CARRIER_FREQ_OFFSET
 *
 */
-#define DRXJ_FM_CARRIER_FREQ_OFFSET             ((DRXFrequency_t)(-3000))
+#define DRXJ_FM_CARRIER_FREQ_OFFSET             ((s32)(-3000))
 
 /* Revision types -------------------------------------------------------*/
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_map.h b/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
index 8fad1e519efb..3ffc7b085506 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_map.h
@@ -7331,8 +7331,8 @@ extern "C" {
 #define   SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW__W                           1
 #define   SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW__M                           0x1
 #define   SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW__PRE                         0x0
-#define     SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW_FALSE                      0x0
-#define     SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW_TRUE                       0x1
+#define     SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW_false                      0x0
+#define     SCU_RAM_AGC_CLP_CTRL_MODE_NARROW_POW_true                       0x1
 
 #define   SCU_RAM_AGC_CLP_CTRL_MODE_FAST_CLP_BP__B                          1
 #define   SCU_RAM_AGC_CLP_CTRL_MODE_FAST_CLP_BP__W                          1
@@ -8130,8 +8130,8 @@ extern "C" {
 #define   SCU_RAM_ATV_DETECT_DETECT__W                                      1
 #define   SCU_RAM_ATV_DETECT_DETECT__M                                      0x1
 #define   SCU_RAM_ATV_DETECT_DETECT__PRE                                    0x0
-#define     SCU_RAM_ATV_DETECT_DETECT_FALSE                                 0x0
-#define     SCU_RAM_ATV_DETECT_DETECT_TRUE                                  0x1
+#define     SCU_RAM_ATV_DETECT_DETECT_false                                 0x0
+#define     SCU_RAM_ATV_DETECT_DETECT_true                                  0x1
 
 #define SCU_RAM_ATV_DETECT_TH__A                                            0x831F4A
 #define SCU_RAM_ATV_DETECT_TH__W                                            8
-- 
1.8.5.3

