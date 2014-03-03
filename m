Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaCCKHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:54 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 10/79] [media] drx-j: get rid of the bsp*.h headers
Date: Mon,  3 Mar 2014 07:06:04 -0300
Message-Id: <1393841233-24840-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Move them into drx_driver.h

That makes easier to cleanup further what's there at the
headers.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_host.h    |  78 -------
 drivers/media/dvb-frontends/drx39xyj/bsp_types.h   |  55 -----
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |   2 -
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |   2 -
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |   1 -
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 252 ++++++++++++++++++++-
 7 files changed, 249 insertions(+), 143 deletions(-)
 delete mode 100644 drivers/media/dvb-frontends/drx39xyj/bsp_host.h
 delete mode 100644 drivers/media/dvb-frontends/drx39xyj/bsp_types.h

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_host.h b/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
deleted file mode 100644
index 0ce94df98107..000000000000
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
-  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
-  All rights reserved.
-
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions are met:
-
-  * Redistributions of source code must retain the above copyright notice,
-    this list of conditions and the following disclaimer.
-  * Redistributions in binary form must reproduce the above copyright notice,
-    this list of conditions and the following disclaimer in the documentation
-	and/or other materials provided with the distribution.
-  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
-    nor the names of its contributors may be used to endorse or promote
-	products derived from this software without specific prior written
-	permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-  POSSIBILITY OF SUCH DAMAGE.
-*/
-
-/**
-* \file $Id: bsp_host.h,v 1.3 2009/07/07 14:20:30 justin Exp $
-*
-* \brief Host and OS dependent type definitions, macro's and functions
-*
-*/
-
-#ifndef __DRXBSP_HOST_H__
-#define __DRXBSP_HOST_H__
-/*-------------------------------------------------------------------------
-INCLUDES
--------------------------------------------------------------------------*/
-#include "bsp_types.h"
-
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/*-------------------------------------------------------------------------
-TYPEDEFS
--------------------------------------------------------------------------*/
-
-/*-------------------------------------------------------------------------
-DEFINES
--------------------------------------------------------------------------*/
-
-/*-------------------------------------------------------------------------
-Exported FUNCTIONS
--------------------------------------------------------------------------*/
-	DRXStatus_t DRXBSP_HST_Init(void);
-
-	DRXStatus_t DRXBSP_HST_Term(void);
-
-	void *DRXBSP_HST_Memcpy(void *to, void *from, u32 n);
-
-	int DRXBSP_HST_Memcmp(void *s1, void *s2, u32 n);
-
-	u32 DRXBSP_HST_Clock(void);
-
-	DRXStatus_t DRXBSP_HST_Sleep(u32 n);
-
-/*-------------------------------------------------------------------------
-THE END
--------------------------------------------------------------------------*/
-#ifdef __cplusplus
-}
-#endif
-#endif				/* __DRXBSP_HOST_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
deleted file mode 100644
index c65a475997aa..000000000000
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
-  Copyright (c), 2004-2005,2007-2010 Trident Microsystems, Inc.
-  All rights reserved.
-
-  Redistribution and use in source and binary forms, with or without
-  modification, are permitted provided that the following conditions are met:
-
-  * Redistributions of source code must retain the above copyright notice,
-    this list of conditions and the following disclaimer.
-  * Redistributions in binary form must reproduce the above copyright notice,
-    this list of conditions and the following disclaimer in the documentation
-	and/or other materials provided with the distribution.
-  * Neither the name of Trident Microsystems nor Hauppauge Computer Works
-    nor the names of its contributors may be used to endorse or promote
-	products derived from this software without specific prior written
-	permission.
-
-  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-  POSSIBILITY OF SUCH DAMAGE.
-*/
-
-#include <linux/kernel.h>
-
-#ifndef __BSP_TYPES_H__
-#define __BSP_TYPES_H__
-
-/*-------------------------------------------------------------------------
-ENUM
--------------------------------------------------------------------------*/
-
-/**
-* \enum DRXStatus_t
-* \brief Various return statusses
-*/
-	typedef enum {
-		DRX_STS_READY = 3,  /**< device/service is ready     */
-		DRX_STS_BUSY = 2,   /**< device/service is busy      */
-		DRX_STS_OK = 1,	    /**< everything is OK            */
-		DRX_STS_INVALID_ARG = -1,
-				    /**< invalid arguments           */
-		DRX_STS_ERROR = -2, /**< general error               */
-		DRX_STS_FUNC_NOT_AVAILABLE = -3
-				    /**< unavailable functionality   */
-	} DRXStatus_t, *pDRXStatus_t;
-
-#endif				/* __BSP_TYPES_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index bce41f4b8015..d68b34b1cc7a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -27,8 +27,6 @@
 #include "dvb_frontend.h"
 #include "drx39xxj.h"
 #include "drx_driver.h"
-#include "bsp_types.h"
-#include "bsp_tuner.h"
 #include "drxj_mc.h"
 #include "drxj.h"
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 854823eac312..5471263b490b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -8,8 +8,6 @@
 #include <linux/types.h>
 
 #include "drx_driver.h"
-#include "bsp_types.h"
-#include "bsp_tuner.h"
 #include "drx39xxj.h"
 
 /* Dummy function to satisfy drxj.c */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 5bf4771a4c49..9bea12ee4ed5 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -50,7 +50,7 @@
 *******************************************************************************/
 
 #include "drx_dap_fasi.h"
-#include "bsp_host.h"		/* for DRXBSP_HST_Memcpy() */
+#include "drx_driver.h"		/* for DRXBSP_HST_Memcpy() */
 
 /*============================================================================*/
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 1d554f283de2..19aa5465100d 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -39,7 +39,6 @@
 INCLUDE FILES
 ------------------------------------------------------------------------------*/
 #include "drx_driver.h"
-#include "bsp_host.h"
 
 #define VERSION_FIXED 0
 #if     VERSION_FIXED
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 12e7770448cb..752b2b3a50ac 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -36,13 +36,257 @@
 */
 #ifndef __DRXDRIVER_H__
 #define __DRXDRIVER_H__
+
+#include <linux/kernel.h>
 /*-------------------------------------------------------------------------
 INCLUDES
 -------------------------------------------------------------------------*/
-#include "bsp_types.h"
-#include "bsp_i2c.h"
-#include "bsp_tuner.h"
-#include "bsp_host.h"
+
+typedef enum {
+	DRX_STS_READY = 3,  /**< device/service is ready     */
+	DRX_STS_BUSY = 2,   /**< device/service is busy      */
+	DRX_STS_OK = 1,	    /**< everything is OK            */
+	DRX_STS_INVALID_ARG = -1,
+				/**< invalid arguments           */
+	DRX_STS_ERROR = -2, /**< general error               */
+	DRX_STS_FUNC_NOT_AVAILABLE = -3
+				/**< unavailable functionality   */
+} DRXStatus_t, *pDRXStatus_t;
+
+/*
+ * This structure contains the I2C address, the device ID and a userData pointer.
+ * The userData pointer can be used for application specific purposes.
+ */
+struct i2c_device_addr {
+	u16 i2cAddr;		/* The I2C address of the device. */
+	u16 i2cDevId;		/* The device identifier. */
+	void *userData;		/* User data pointer */
+};
+
+/**
+* \def IS_I2C_10BIT( addr )
+* \brief Determine if I2C address 'addr' is a 10 bits address or not.
+* \param addr The I2C address.
+* \return int.
+* \retval 0 if address is not a 10 bits I2C address.
+* \retval 1 if address is a 10 bits I2C address.
+*/
+#define IS_I2C_10BIT(addr) \
+	 (((addr) & 0xF8) == 0xF0)
+
+/*------------------------------------------------------------------------------
+Exported FUNCTIONS
+------------------------------------------------------------------------------*/
+
+/**
+* \fn DRXBSP_I2C_Init()
+* \brief Initialize I2C communication module.
+* \return DRXStatus_t Return status.
+* \retval DRX_STS_OK Initialization successful.
+* \retval DRX_STS_ERROR Initialization failed.
+*/
+DRXStatus_t DRXBSP_I2C_Init(void);
+
+/**
+* \fn DRXBSP_I2C_Term()
+* \brief Terminate I2C communication module.
+* \return DRXStatus_t Return status.
+* \retval DRX_STS_OK Termination successful.
+* \retval DRX_STS_ERROR Termination failed.
+*/
+DRXStatus_t DRXBSP_I2C_Term(void);
+
+/**
+* \fn DRXStatus_t DRXBSP_I2C_WriteRead( struct i2c_device_addr *wDevAddr,
+*                                       u16 wCount,
+*                                       u8 * wData,
+*                                       struct i2c_device_addr *rDevAddr,
+*                                       u16 rCount,
+*                                       u8 * rData)
+* \brief Read and/or write count bytes from I2C bus, store them in data[].
+* \param wDevAddr The device i2c address and the device ID to write to
+* \param wCount   The number of bytes to write
+* \param wData    The array to write the data to
+* \param rDevAddr The device i2c address and the device ID to read from
+* \param rCount   The number of bytes to read
+* \param rData    The array to read the data from
+* \return DRXStatus_t Return status.
+* \retval DRX_STS_OK Succes.
+* \retval DRX_STS_ERROR Failure.
+* \retval DRX_STS_INVALID_ARG Parameter 'wcount' is not zero but parameter
+*                                       'wdata' contains NULL.
+*                                       Idem for 'rcount' and 'rdata'.
+*                                       Both wDevAddr and rDevAddr are NULL.
+*
+* This function must implement an atomic write and/or read action on the I2C bus
+* No other process may use the I2C bus when this function is executing.
+* The critical section of this function runs from and including the I2C
+* write, up to and including the I2C read action.
+*
+* The device ID can be useful if several devices share an I2C address.
+* It can be used to control a "switch" on the I2C bus to the correct device.
+*/
+DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
+					u16 wCount,
+					u8 * wData,
+					struct i2c_device_addr *rDevAddr,
+					u16 rCount, u8 * rData);
+
+/**
+* \fn DRXBSP_I2C_ErrorText()
+* \brief Returns a human readable error.
+* Counter part of numerical DRX_I2C_Error_g.
+*
+* \return char* Pointer to human readable error text.
+*/
+char *DRXBSP_I2C_ErrorText(void);
+
+/**
+* \var DRX_I2C_Error_g;
+* \brief I2C specific error codes, platform dependent.
+*/
+extern int DRX_I2C_Error_g;
+
+#define TUNER_MODE_SUB0    0x0001	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB1    0x0002	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB2    0x0004	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB3    0x0008	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB4    0x0010	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB5    0x0020	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB6    0x0040	/* for sub-mode (e.g. RF-AGC setting) */
+#define TUNER_MODE_SUB7    0x0080	/* for sub-mode (e.g. RF-AGC setting) */
+
+#define TUNER_MODE_DIGITAL 0x0100	/* for digital channel (e.g. DVB-T)   */
+#define TUNER_MODE_ANALOG  0x0200	/* for analog channel  (e.g. PAL)     */
+#define TUNER_MODE_SWITCH  0x0400	/* during channel switch & scanning   */
+#define TUNER_MODE_LOCK    0x0800	/* after tuner has locked             */
+#define TUNER_MODE_6MHZ    0x1000	/* for 6MHz bandwidth channels        */
+#define TUNER_MODE_7MHZ    0x2000	/* for 7MHz bandwidth channels        */
+#define TUNER_MODE_8MHZ    0x4000	/* for 8MHz bandwidth channels        */
+
+#define TUNER_MODE_SUB_MAX 8
+#define TUNER_MODE_SUBALL  (  TUNER_MODE_SUB0 | TUNER_MODE_SUB1 | \
+			      TUNER_MODE_SUB2 | TUNER_MODE_SUB3 | \
+			      TUNER_MODE_SUB4 | TUNER_MODE_SUB5 | \
+			      TUNER_MODE_SUB6 | TUNER_MODE_SUB7 )
+
+typedef u32 TUNERMode_t;
+typedef u32 * pTUNERMode_t;
+
+typedef char *TUNERSubMode_t;	/* description of submode */
+typedef TUNERSubMode_t *pTUNERSubMode_t;
+
+typedef enum {
+
+	TUNER_LOCKED,
+	TUNER_NOT_LOCKED
+} TUNERLockStatus_t, *pTUNERLockStatus_t;
+
+typedef struct {
+
+	char *name;	/* Tuner brand & type name */
+	s32 minFreqRF;	/* Lowest  RF input frequency, in kHz */
+	s32 maxFreqRF;	/* Highest RF input frequency, in kHz */
+
+	u8 subMode;	/* Index to sub-mode in use */
+	pTUNERSubMode_t subModeDescriptions;	/* Pointer to description of sub-modes */
+	u8 subModes;	/* Number of available sub-modes      */
+
+	/* The following fields will be either 0, NULL or false and do not need
+		initialisation */
+	void *selfCheck;	/* gives proof of initialization  */
+	bool programmed;	/* only valid if selfCheck is OK  */
+	s32 RFfrequency;	/* only valid if programmed       */
+	s32 IFfrequency;	/* only valid if programmed       */
+
+	void *myUserData;	/* pointer to associated demod instance */
+	u16 myCapabilities;	/* value for storing application flags  */
+
+} TUNERCommonAttr_t, *pTUNERCommonAttr_t;
+
+typedef struct TUNERInstance_s *pTUNERInstance_t;
+
+typedef DRXStatus_t(*TUNEROpenFunc_t) (pTUNERInstance_t tuner);
+typedef DRXStatus_t(*TUNERCloseFunc_t) (pTUNERInstance_t tuner);
+
+typedef DRXStatus_t(*TUNERSetFrequencyFunc_t) (pTUNERInstance_t tuner,
+						TUNERMode_t mode,
+						s32
+						frequency);
+
+typedef DRXStatus_t(*TUNERGetFrequencyFunc_t) (pTUNERInstance_t tuner,
+						TUNERMode_t mode,
+						s32 *
+						RFfrequency,
+						s32 *
+						IFfrequency);
+
+typedef DRXStatus_t(*TUNERLockStatusFunc_t) (pTUNERInstance_t tuner,
+						pTUNERLockStatus_t
+						lockStat);
+
+typedef DRXStatus_t(*TUNERi2cWriteReadFunc_t) (pTUNERInstance_t tuner,
+						struct i2c_device_addr *
+						wDevAddr, u16 wCount,
+						u8 * wData,
+						struct i2c_device_addr *
+						rDevAddr, u16 rCount,
+						u8 * rData);
+
+typedef struct {
+	TUNEROpenFunc_t openFunc;
+	TUNERCloseFunc_t closeFunc;
+	TUNERSetFrequencyFunc_t setFrequencyFunc;
+	TUNERGetFrequencyFunc_t getFrequencyFunc;
+	TUNERLockStatusFunc_t lockStatusFunc;
+	TUNERi2cWriteReadFunc_t i2cWriteReadFunc;
+
+} TUNERFunc_t, *pTUNERFunc_t;
+
+typedef struct TUNERInstance_s {
+
+	struct i2c_device_addr myI2CDevAddr;
+	pTUNERCommonAttr_t myCommonAttr;
+	void *myExtAttr;
+	pTUNERFunc_t myFunct;
+
+} TUNERInstance_t;
+
+DRXStatus_t DRXBSP_TUNER_Open(pTUNERInstance_t tuner);
+
+DRXStatus_t DRXBSP_TUNER_Close(pTUNERInstance_t tuner);
+
+DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
+					TUNERMode_t mode,
+					s32 frequency);
+
+DRXStatus_t DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
+					TUNERMode_t mode,
+					s32 * RFfrequency,
+					s32 * IFfrequency);
+
+DRXStatus_t DRXBSP_TUNER_LockStatus(pTUNERInstance_t tuner,
+					pTUNERLockStatus_t lockStat);
+
+DRXStatus_t DRXBSP_TUNER_DefaultI2CWriteRead(pTUNERInstance_t tuner,
+						struct i2c_device_addr *wDevAddr,
+						u16 wCount,
+						u8 * wData,
+						struct i2c_device_addr *rDevAddr,
+						u16 rCount, u8 * rData);
+
+DRXStatus_t DRXBSP_HST_Init(void);
+
+DRXStatus_t DRXBSP_HST_Term(void);
+
+void *DRXBSP_HST_Memcpy(void *to, void *from, u32 n);
+
+int DRXBSP_HST_Memcmp(void *s1, void *s2, u32 n);
+
+u32 DRXBSP_HST_Clock(void);
+
+DRXStatus_t DRXBSP_HST_Sleep(u32 n);
+
 
 #ifdef __cplusplus
 extern "C" {
-- 
1.8.5.3

