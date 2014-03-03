Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaCCKH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:57 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 13/79] [media] drx-j: Use checkpatch --fix to solve several issues
Date: Mon,  3 Mar 2014 07:06:07 -0300
Message-Id: <1393841233-24840-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of manually fixing the issues, use the --fix experimental
checkpatch. That solves a bunch of checkpatch issues.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h   |   4 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h    |   2 +-
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |   4 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  34 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.h    |  28 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  28 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  | 970 ++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 200 ++---
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |  28 +-
 9 files changed, 649 insertions(+), 649 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
index 2028506dbba7..3b9adf907033 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
@@ -70,10 +70,10 @@ DEFINES
 #define TUNER_MODE_8MHZ    0x4000	/* for 8MHz bandwidth channels        */
 
 #define TUNER_MODE_SUB_MAX 8
-#define TUNER_MODE_SUBALL  (  TUNER_MODE_SUB0 | TUNER_MODE_SUB1 | \
+#define TUNER_MODE_SUBALL  (TUNER_MODE_SUB0 | TUNER_MODE_SUB1 | \
 			      TUNER_MODE_SUB2 | TUNER_MODE_SUB3 | \
 			      TUNER_MODE_SUB4 | TUNER_MODE_SUB5 | \
-			      TUNER_MODE_SUB6 | TUNER_MODE_SUB7 )
+			      TUNER_MODE_SUB6 | TUNER_MODE_SUB7)
 
 /*------------------------------------------------------------------------------
 TYPEDEFS
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index 1f0b30bbd0c3..212aee8cdbf2 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -37,4 +37,4 @@ struct drx39xxj_state {
 
 extern struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c);
 
-#endif // DVB_DUMMY_FE_H
+#endif /* DVB_DUMMY_FE_H */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index ff6e33411bcd..7e3e00e27292 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -114,9 +114,9 @@ int DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
 
 	struct i2c_msg msg[2] = {
 		{.addr = wDevAddr->i2cAddr,
-		 .flags = 0,.buf = wData,.len = wCount},
+		 .flags = 0, .buf = wData, .len = wCount},
 		{.addr = rDevAddr->i2cAddr,
-		 .flags = I2C_M_RD,.buf = rData,.len = rCount},
+		 .flags = I2C_M_RD, .buf = rData, .len = rCount},
 	};
 
 	printk("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 479db94b1782..8ec9cc77449c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -252,29 +252,29 @@ static int DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 		addr &= ~DRXDAP_FASI_FLAGS;
 		addr |= flags;
 
-#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
-      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
+#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1) )
 		/* short format address preferred but long format otherwise */
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
-#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
+#if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
 			buf[bufx++] = (u8) (((addr << 1) & 0xFF) | 0x01);
 			buf[bufx++] = (u8) ((addr >> 16) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
-#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
-      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
+#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1) )
 		} else {
 #endif
-#if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
+#if (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1)
 			buf[bufx++] = (u8) ((addr << 1) & 0xFF);
 			buf[bufx++] =
 			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
-#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
-      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
+#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 1) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1) )
 		}
 #endif
 
@@ -332,7 +332,7 @@ static int DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 {
 	int rc = DRX_STS_ERROR;
 
-#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
+#if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
 	if (rdata == NULL) {
 		return DRX_STS_INVALID_ARG;
 	}
@@ -478,29 +478,29 @@ static int DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 		/* Buffer device address */
 		addr &= ~DRXDAP_FASI_FLAGS;
 		addr |= flags;
-#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
-      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
+#if (( (DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
+      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1) )
 		/* short format address preferred but long format otherwise */
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
-#if ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED) == 1)
 			buf[bufx++] = (u8) (((addr << 1) & 0xFF) | 0x01);
 			buf[bufx++] = (u8) ((addr >> 16) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
 			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
-#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
-      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
+#if (( (DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
+      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1) )
 		} else {
 #endif
-#if ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 )
+#if ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1)
 			buf[bufx++] = (u8) ((addr << 1) & 0xFF);
 			buf[bufx++] =
 			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
-#if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
-      ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
+#if (( (DRXDAPFASI_LONG_ADDR_ALLOWED) == 1) && \
+      ((DRXDAPFASI_SHORT_ADDR_ALLOWED) == 1) )
 		}
 #endif
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
index 756f08d8220e..5269657f3fc4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.h
@@ -83,18 +83,18 @@
 */
 
 /* set default */
-#if !defined( DRXDAPFASI_LONG_ADDR_ALLOWED )
+#if !defined(DRXDAPFASI_LONG_ADDR_ALLOWED)
 #define  DRXDAPFASI_LONG_ADDR_ALLOWED 1
 #endif
 
 /* set default */
-#if !defined( DRXDAPFASI_SHORT_ADDR_ALLOWED )
+#if !defined(DRXDAPFASI_SHORT_ADDR_ALLOWED)
 #define  DRXDAPFASI_SHORT_ADDR_ALLOWED 1
 #endif
 
 /* check */
-#if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==0 ) && \
-      ( DRXDAPFASI_SHORT_ADDR_ALLOWED==0 ) )
+#if (( DRXDAPFASI_LONG_ADDR_ALLOWED == 0) && \
+      (DRXDAPFASI_SHORT_ADDR_ALLOWED == 0) )
 #error  At least one of short- or long-addressing format must be allowed.
 *;				/* illegal statement to force compiler error */
 #endif
@@ -176,12 +176,12 @@
 */
 
 /* set default */
-#if !defined( DRXDAP_MAX_WCHUNKSIZE)
+#if !defined(DRXDAP_MAX_WCHUNKSIZE)
 #define  DRXDAP_MAX_WCHUNKSIZE 254
 #endif
 
 /* check */
-#if ( (DRXDAPFASI_LONG_ADDR_ALLOWED==0)&&(DRXDAPFASI_SHORT_ADDR_ALLOWED==1) )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 0) && (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 #if DRXDAP_SINGLE_MASTER
 #define  DRXDAP_MAX_WCHUNKSIZE_MIN 3
 #else
@@ -196,7 +196,7 @@
 #endif
 
 #if  DRXDAP_MAX_WCHUNKSIZE <  DRXDAP_MAX_WCHUNKSIZE_MIN
-#if ( (DRXDAPFASI_LONG_ADDR_ALLOWED==0)&&(DRXDAPFASI_SHORT_ADDR_ALLOWED==1) )
+#if ((DRXDAPFASI_LONG_ADDR_ALLOWED == 0) && (DRXDAPFASI_SHORT_ADDR_ALLOWED == 1))
 #if DRXDAP_SINGLE_MASTER
 #error  DRXDAP_MAX_WCHUNKSIZE must be at least 3 in single master mode
 *;				/* illegal statement to force compiler error */
@@ -216,7 +216,7 @@
 #endif
 
 /* set default */
-#if !defined( DRXDAP_MAX_RCHUNKSIZE)
+#if !defined(DRXDAP_MAX_RCHUNKSIZE)
 #define  DRXDAP_MAX_RCHUNKSIZE 254
 #endif
 
@@ -249,13 +249,13 @@ extern "C" {
 #define DRXDAP_FASI_MODEFLAGS     0xC0000000
 #define DRXDAP_FASI_FLAGS         0xF0000000
 
-#define DRXDAP_FASI_ADDR2BLOCK( addr )  (((addr)>>22)&0x3F)
-#define DRXDAP_FASI_ADDR2BANK( addr )   (((addr)>>16)&0x3F)
-#define DRXDAP_FASI_ADDR2OFFSET( addr ) ((addr)&0x7FFF)
+#define DRXDAP_FASI_ADDR2BLOCK(addr)  (((addr)>>22)&0x3F)
+#define DRXDAP_FASI_ADDR2BANK(addr)   (((addr)>>16)&0x3F)
+#define DRXDAP_FASI_ADDR2OFFSET(addr) ((addr)&0x7FFF)
 
-#define DRXDAP_FASI_SHORT_FORMAT( addr )     (((addr)& 0xFC30FF80)==0)
-#define DRXDAP_FASI_LONG_FORMAT( addr )      (((addr)& 0xFC30FF80)!=0)
-#define DRXDAP_FASI_OFFSET_TOO_LARGE( addr ) (((addr)& 0x00008000)!=0)
+#define DRXDAP_FASI_SHORT_FORMAT(addr)     (((addr) & 0xFC30FF80) == 0)
+#define DRXDAP_FASI_LONG_FORMAT(addr)      (((addr) & 0xFC30FF80) != 0)
+#define DRXDAP_FASI_OFFSET_TOO_LARGE(addr) (((addr) & 0x00008000) != 0)
 
 #ifdef __cplusplus
 }
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index d33f9cefe050..c94fd3541757 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -99,15 +99,15 @@ DEFINES
 /*=== MACROS =================================================================*/
 /*============================================================================*/
 
-#define DRX_ISPOWERDOWNMODE( mode ) (  ( mode == DRX_POWER_MODE_9  ) || \
-				       ( mode == DRX_POWER_MODE_10 ) || \
-				       ( mode == DRX_POWER_MODE_11 ) || \
-				       ( mode == DRX_POWER_MODE_12 ) || \
-				       ( mode == DRX_POWER_MODE_13 ) || \
-				       ( mode == DRX_POWER_MODE_14 ) || \
-				       ( mode == DRX_POWER_MODE_15 ) || \
-				       ( mode == DRX_POWER_MODE_16 ) || \
-				       ( mode == DRX_POWER_DOWN    ) )
+#define DRX_ISPOWERDOWNMODE(mode) (  ( mode == DRX_POWER_MODE_9  ) || \
+				       (mode == DRX_POWER_MODE_10) || \
+				       (mode == DRX_POWER_MODE_11) || \
+				       (mode == DRX_POWER_MODE_12) || \
+				       (mode == DRX_POWER_MODE_13) || \
+				       (mode == DRX_POWER_MODE_14) || \
+				       (mode == DRX_POWER_MODE_15) || \
+				       (mode == DRX_POWER_MODE_16) || \
+				       (mode == DRX_POWER_DOWN) )
 
 /*------------------------------------------------------------------------------
 GLOBAL VARIABLES
@@ -148,7 +148,7 @@ FUNCTIONS
 static int
 ScanFunctionDefault(void *scanContext,
 		    DRXScanCommand_t scanCommand,
-		    pDRXChannel_t scanChannel, bool * getNextChannel);
+		    pDRXChannel_t scanChannel, bool *getNextChannel);
 
 /**
 * \brief Get pointer to scanning function.
@@ -211,7 +211,7 @@ void *GetScanContext(pDRXDemodInstance_t demod, void *scanContext)
 * In case DRX_NEVER_LOCK is returned the poll-wait will be aborted.
 *
 */
-static int ScanWaitForLock(pDRXDemodInstance_t demod, bool * isLocked)
+static int ScanWaitForLock(pDRXDemodInstance_t demod, bool *isLocked)
 {
 	bool doneWaiting = false;
 	DRXLockStatus_t lockState = DRX_NOT_LOCKED;
@@ -356,7 +356,7 @@ ScanPrepareNextScan(pDRXDemodInstance_t demod, s32 skip)
 static int
 ScanFunctionDefault(void *scanContext,
 		    DRXScanCommand_t scanCommand,
-		    pDRXChannel_t scanChannel, bool * getNextChannel)
+		    pDRXChannel_t scanChannel, bool *getNextChannel)
 {
 	pDRXDemodInstance_t demod = NULL;
 	int status = DRX_STS_ERROR;
@@ -604,7 +604,7 @@ static int CtrlScanStop(pDRXDemodInstance_t demod)
 static int CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	bool * scanReady = (bool *) (NULL);
+	bool *scanReady = (bool *) (NULL);
 	u16 maxProgress = DRX_SCAN_MAX_PROGRESS;
 	u32 numTries = 0;
 	u32 i = 0;
@@ -1202,7 +1202,7 @@ CtrlUCode(pDRXDemodInstance_t demod,
 * \retval DRX_STS_INVALID_ARG: Invalid arguments.
 */
 static int
-CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
+CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t *versionList)
 {
 	static char drxDriverCoreModuleName[] = "Core driver";
 	static char drxDriverCoreVersionText[] =
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index fddf491d4816..0b0787f60f98 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -128,9 +128,9 @@ int DRXBSP_I2C_Term(void);
 */
 int DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
 					u16 wCount,
-					u8 * wData,
+					u8 *wData,
 					struct i2c_device_addr *rDevAddr,
-					u16 rCount, u8 * rData);
+					u16 rCount, u8 *rData);
 
 /**
 * \fn DRXBSP_I2C_ErrorText()
@@ -165,10 +165,10 @@ extern int DRX_I2C_Error_g;
 #define TUNER_MODE_8MHZ    0x4000	/* for 8MHz bandwidth channels        */
 
 #define TUNER_MODE_SUB_MAX 8
-#define TUNER_MODE_SUBALL  (  TUNER_MODE_SUB0 | TUNER_MODE_SUB1 | \
+#define TUNER_MODE_SUBALL  (TUNER_MODE_SUB0 | TUNER_MODE_SUB1 | \
 			      TUNER_MODE_SUB2 | TUNER_MODE_SUB3 | \
 			      TUNER_MODE_SUB4 | TUNER_MODE_SUB5 | \
-			      TUNER_MODE_SUB6 | TUNER_MODE_SUB7 )
+			      TUNER_MODE_SUB6 | TUNER_MODE_SUB7)
 
 
 enum tuner_lock_status {
@@ -182,7 +182,7 @@ struct tuner_common {
 	s32 maxFreqRF;	/* Highest RF input frequency, in kHz */
 
 	u8 subMode;	/* Index to sub-mode in use */
-	char *** subModeDescriptions;	/* Pointer to description of sub-modes */
+	char ***subModeDescriptions;	/* Pointer to description of sub-modes */
 	u8 subModes;	/* Number of available sub-modes      */
 
 	/* The following fields will be either 0, NULL or false and do not need
@@ -220,10 +220,10 @@ typedef int(*TUNERLockStatusFunc_t) (struct tuner_instance *tuner,
 typedef int(*TUNERi2cWriteReadFunc_t) (struct tuner_instance *tuner,
 						struct i2c_device_addr *
 						wDevAddr, u16 wCount,
-						u8 * wData,
+						u8 *wData,
 						struct i2c_device_addr *
 						rDevAddr, u16 rCount,
-						u8 * rData);
+						u8 *rData);
 
 struct tuner_ops {
 	TUNEROpenFunc_t openFunc;
@@ -253,8 +253,8 @@ int DRXBSP_TUNER_SetFrequency(struct tuner_instance *tuner,
 
 int DRXBSP_TUNER_GetFrequency(struct tuner_instance *tuner,
 					u32 mode,
-					s32 * RFfrequency,
-					s32 * IFfrequency);
+					s32 *RFfrequency,
+					s32 *IFfrequency);
 
 int DRXBSP_TUNER_LockStatus(struct tuner_instance *tuner,
 					enum tuner_lock_status *lockStat);
@@ -262,9 +262,9 @@ int DRXBSP_TUNER_LockStatus(struct tuner_instance *tuner,
 int DRXBSP_TUNER_DefaultI2CWriteRead(struct tuner_instance *tuner,
 						struct i2c_device_addr *wDevAddr,
 						u16 wCount,
-						u8 * wData,
+						u8 *wData,
 						struct i2c_device_addr *rDevAddr,
-						u16 rCount, u8 * rData);
+						u16 rCount, u8 *rData);
 
 int DRXBSP_HST_Init(void);
 
@@ -474,11 +474,11 @@ int DRXBSP_HST_Sleep(u32 n);
 MACROS
 -------------------------------------------------------------------------*/
 /* Macros to stringify the version number */
-#define DRX_VERSIONSTRING( MAJOR, MINOR, PATCH ) \
+#define DRX_VERSIONSTRING(MAJOR, MINOR, PATCH) \
 	 DRX_VERSIONSTRING_HELP(MAJOR)"." \
 	 DRX_VERSIONSTRING_HELP(MINOR)"." \
 	 DRX_VERSIONSTRING_HELP(PATCH)
-#define DRX_VERSIONSTRING_HELP( NUM ) #NUM
+#define DRX_VERSIONSTRING_HELP(NUM) #NUM
 
 /**
 * \brief Macro to create byte array elements from 16 bit integers.
@@ -487,29 +487,29 @@ MACROS
 * The macro takes care of the required byte order in a 16 bits word.
 * x->lowbyte(x), highbyte(x)
 */
-#define DRX_16TO8( x ) ((u8) (((u16)x)    &0xFF)), \
+#define DRX_16TO8(x) ((u8) (((u16)x) & 0xFF)), \
 			((u8)((((u16)x)>>8)&0xFF))
 
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S9TOS16(x) ((((u16)x)&0x100 )?((s16)((u16)(x)|0xFF00)):(x))
+#define DRX_S9TOS16(x) ((((u16)x)&0x100)?((s16)((u16)(x)|0xFF00)):(x))
 
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S24TODRXFREQ(x) ( ( ( (u32) x ) & 0x00800000UL ) ? \
-				 (  (s32) \
-				    ( ( (u32) x ) | 0xFF000000 ) ) : \
-				 ( (s32) x ) )
+#define DRX_S24TODRXFREQ(x) (( ( (u32) x) & 0x00800000UL ) ? \
+				 ((s32) \
+				    (( (u32) x) | 0xFF000000 ) ) : \
+				 ((s32) x) )
 
 /**
 * \brief Macro to convert 16 bit register value to a s32
 */
-#define DRX_U16TODRXFREQ(x)   (  ( x & 0x8000 ) ? \
-				 (  (s32) \
-				    ( ( (u32) x ) | 0xFFFF0000 ) ) : \
-				 ( (s32) x ) )
+#define DRX_U16TODRXFREQ(x)   (( x & 0x8000) ? \
+				 ((s32) \
+				    (( (u32) x) | 0xFFFF0000 ) ) : \
+				 ((s32) x) )
 
 /*-------------------------------------------------------------------------
 ENUM
@@ -580,7 +580,7 @@ enum drx_bandwidth {
 * \enum enum drx_mirror
 * \brief Indicate if channel spectrum is mirrored or not.
 */
-enum drx_mirror{
+enum drx_mirror {
 	DRX_MIRROR_NO = 0,   /**< Spectrum is not mirrored.           */
 	DRX_MIRROR_YES,	     /**< Spectrum is mirrored.               */
 	DRX_MIRROR_UNKNOWN = DRX_UNKNOWN,
@@ -641,7 +641,7 @@ enum drx_priority {
 * \enum enum drx_coderate
 * \brief Channel priority in case of hierarchical transmission.
 */
-enum drx_coderate{
+enum drx_coderate {
 		DRX_CODERATE_1DIV2 = 0,	/**< Code rate 1/2nd.      */
 		DRX_CODERATE_2DIV3,	/**< Code rate 2/3nd.      */
 		DRX_CODERATE_3DIV4,	/**< Code rate 3/4nd.      */
@@ -736,7 +736,7 @@ enum drx_interleave_mode {
 * \enum enum drx_carrier_mode
 * \brief Channel Carrier Mode.
 */
-enum drx_carrier_mode{
+enum drx_carrier_mode {
 	DRX_CARRIER_MULTI = 0,		/**< Multi carrier mode       */
 	DRX_CARRIER_SINGLE,		/**< Single carrier mode      */
 	DRX_CARRIER_UNKNOWN = DRX_UNKNOWN,
@@ -748,7 +748,7 @@ enum drx_carrier_mode{
 * \enum enum drx_frame_mode
 * \brief Channel Frame Mode.
 */
-enum drx_frame_mode{
+enum drx_frame_mode {
 	DRX_FRAMEMODE_420 = 0,	 /**< 420 with variable PN  */
 	DRX_FRAMEMODE_595,	 /**< 595                   */
 	DRX_FRAMEMODE_945,	 /**< 945 with variable PN  */
@@ -766,7 +766,7 @@ enum drx_frame_mode{
 * \enum enum drx_tps_frame
 * \brief Frame number in current super-frame.
 */
-enum drx_tps_frame{
+enum drx_tps_frame {
 	DRX_TPS_FRAME1 = 0,	  /**< TPS frame 1.       */
 	DRX_TPS_FRAME2,		  /**< TPS frame 2.       */
 	DRX_TPS_FRAME3,		  /**< TPS frame 3.       */
@@ -779,7 +779,7 @@ enum drx_tps_frame{
 * \enum enum drx_ldpc
 * \brief TPS LDPC .
 */
-enum drx_ldpc{
+enum drx_ldpc {
 	DRX_LDPC_0_4 = 0,	  /**< LDPC 0.4           */
 	DRX_LDPC_0_6,		  /**< LDPC 0.6           */
 	DRX_LDPC_0_8,		  /**< LDPC 0.8           */
@@ -792,7 +792,7 @@ enum drx_ldpc{
 * \enum enum drx_pilot_mode
 * \brief Pilot modes in DTMB.
 */
-enum drx_pilot_mode{
+enum drx_pilot_mode {
 	DRX_PILOT_ON = 0,	  /**< Pilot On             */
 	DRX_PILOT_OFF,		  /**< Pilot Off            */
 	DRX_PILOT_UNKNOWN = DRX_UNKNOWN,
@@ -802,58 +802,58 @@ enum drx_pilot_mode{
 
 #define DRX_CTRL_BASE          ((u32)0)
 
-#define DRX_CTRL_NOP             ( DRX_CTRL_BASE +  0)/**< No Operation       */
-#define DRX_CTRL_PROBE_DEVICE    ( DRX_CTRL_BASE +  1)/**< Probe device       */
-
-#define DRX_CTRL_LOAD_UCODE      ( DRX_CTRL_BASE +  2)/**< Load microcode     */
-#define DRX_CTRL_VERIFY_UCODE    ( DRX_CTRL_BASE +  3)/**< Verify microcode   */
-#define DRX_CTRL_SET_CHANNEL     ( DRX_CTRL_BASE +  4)/**< Set channel        */
-#define DRX_CTRL_GET_CHANNEL     ( DRX_CTRL_BASE +  5)/**< Get channel        */
-#define DRX_CTRL_LOCK_STATUS     ( DRX_CTRL_BASE +  6)/**< Get lock status    */
-#define DRX_CTRL_SIG_QUALITY     ( DRX_CTRL_BASE +  7)/**< Get signal quality */
-#define DRX_CTRL_SIG_STRENGTH    ( DRX_CTRL_BASE +  8)/**< Get signal strength*/
-#define DRX_CTRL_RF_POWER        ( DRX_CTRL_BASE +  9)/**< Get RF power       */
-#define DRX_CTRL_CONSTEL         ( DRX_CTRL_BASE + 10)/**< Get constel point  */
-#define DRX_CTRL_SCAN_INIT       ( DRX_CTRL_BASE + 11)/**< Initialize scan    */
-#define DRX_CTRL_SCAN_NEXT       ( DRX_CTRL_BASE + 12)/**< Scan for next      */
-#define DRX_CTRL_SCAN_STOP       ( DRX_CTRL_BASE + 13)/**< Stop scan          */
-#define DRX_CTRL_TPS_INFO        ( DRX_CTRL_BASE + 14)/**< Get TPS info       */
-#define DRX_CTRL_SET_CFG         ( DRX_CTRL_BASE + 15)/**< Set configuration  */
-#define DRX_CTRL_GET_CFG         ( DRX_CTRL_BASE + 16)/**< Get configuration  */
-#define DRX_CTRL_VERSION         ( DRX_CTRL_BASE + 17)/**< Get version info   */
-#define DRX_CTRL_I2C_BRIDGE      ( DRX_CTRL_BASE + 18)/**< Open/close  bridge */
-#define DRX_CTRL_SET_STANDARD    ( DRX_CTRL_BASE + 19)/**< Set demod std      */
-#define DRX_CTRL_GET_STANDARD    ( DRX_CTRL_BASE + 20)/**< Get demod std      */
-#define DRX_CTRL_SET_OOB         ( DRX_CTRL_BASE + 21)/**< Set OOB param      */
-#define DRX_CTRL_GET_OOB         ( DRX_CTRL_BASE + 22)/**< Get OOB param      */
+#define DRX_CTRL_NOP             (DRX_CTRL_BASE +  0)/**< No Operation       */
+#define DRX_CTRL_PROBE_DEVICE    (DRX_CTRL_BASE +  1)/**< Probe device       */
+
+#define DRX_CTRL_LOAD_UCODE      (DRX_CTRL_BASE +  2)/**< Load microcode     */
+#define DRX_CTRL_VERIFY_UCODE    (DRX_CTRL_BASE +  3)/**< Verify microcode   */
+#define DRX_CTRL_SET_CHANNEL     (DRX_CTRL_BASE +  4)/**< Set channel        */
+#define DRX_CTRL_GET_CHANNEL     (DRX_CTRL_BASE +  5)/**< Get channel        */
+#define DRX_CTRL_LOCK_STATUS     (DRX_CTRL_BASE +  6)/**< Get lock status    */
+#define DRX_CTRL_SIG_QUALITY     (DRX_CTRL_BASE +  7)/**< Get signal quality */
+#define DRX_CTRL_SIG_STRENGTH    (DRX_CTRL_BASE +  8)/**< Get signal strength*/
+#define DRX_CTRL_RF_POWER        (DRX_CTRL_BASE +  9)/**< Get RF power       */
+#define DRX_CTRL_CONSTEL         (DRX_CTRL_BASE + 10)/**< Get constel point  */
+#define DRX_CTRL_SCAN_INIT       (DRX_CTRL_BASE + 11)/**< Initialize scan    */
+#define DRX_CTRL_SCAN_NEXT       (DRX_CTRL_BASE + 12)/**< Scan for next      */
+#define DRX_CTRL_SCAN_STOP       (DRX_CTRL_BASE + 13)/**< Stop scan          */
+#define DRX_CTRL_TPS_INFO        (DRX_CTRL_BASE + 14)/**< Get TPS info       */
+#define DRX_CTRL_SET_CFG         (DRX_CTRL_BASE + 15)/**< Set configuration  */
+#define DRX_CTRL_GET_CFG         (DRX_CTRL_BASE + 16)/**< Get configuration  */
+#define DRX_CTRL_VERSION         (DRX_CTRL_BASE + 17)/**< Get version info   */
+#define DRX_CTRL_I2C_BRIDGE      (DRX_CTRL_BASE + 18)/**< Open/close  bridge */
+#define DRX_CTRL_SET_STANDARD    (DRX_CTRL_BASE + 19)/**< Set demod std      */
+#define DRX_CTRL_GET_STANDARD    (DRX_CTRL_BASE + 20)/**< Get demod std      */
+#define DRX_CTRL_SET_OOB         (DRX_CTRL_BASE + 21)/**< Set OOB param      */
+#define DRX_CTRL_GET_OOB         (DRX_CTRL_BASE + 22)/**< Get OOB param      */
 #define DRX_CTRL_AUD_SET_STANDARD (DRX_CTRL_BASE + 23)/**< Set audio param    */
 #define DRX_CTRL_AUD_GET_STANDARD (DRX_CTRL_BASE + 24)/**< Get audio param    */
-#define DRX_CTRL_AUD_GET_STATUS  ( DRX_CTRL_BASE + 25)/**< Read RDS           */
-#define DRX_CTRL_AUD_BEEP        ( DRX_CTRL_BASE + 26)/**< Read RDS           */
-#define DRX_CTRL_I2C_READWRITE   ( DRX_CTRL_BASE + 27)/**< Read/write I2C     */
-#define DRX_CTRL_PROGRAM_TUNER   ( DRX_CTRL_BASE + 28)/**< Program tuner      */
+#define DRX_CTRL_AUD_GET_STATUS  (DRX_CTRL_BASE + 25)/**< Read RDS           */
+#define DRX_CTRL_AUD_BEEP        (DRX_CTRL_BASE + 26)/**< Read RDS           */
+#define DRX_CTRL_I2C_READWRITE   (DRX_CTRL_BASE + 27)/**< Read/write I2C     */
+#define DRX_CTRL_PROGRAM_TUNER   (DRX_CTRL_BASE + 28)/**< Program tuner      */
 
 	/* Professional */
-#define DRX_CTRL_MB_CFG          ( DRX_CTRL_BASE + 29) /**<                   */
-#define DRX_CTRL_MB_READ         ( DRX_CTRL_BASE + 30) /**<                   */
-#define DRX_CTRL_MB_WRITE        ( DRX_CTRL_BASE + 31) /**<                   */
-#define DRX_CTRL_MB_CONSTEL      ( DRX_CTRL_BASE + 32) /**<                   */
-#define DRX_CTRL_MB_MER          ( DRX_CTRL_BASE + 33) /**<                   */
+#define DRX_CTRL_MB_CFG          (DRX_CTRL_BASE + 29) /**<                   */
+#define DRX_CTRL_MB_READ         (DRX_CTRL_BASE + 30) /**<                   */
+#define DRX_CTRL_MB_WRITE        (DRX_CTRL_BASE + 31) /**<                   */
+#define DRX_CTRL_MB_CONSTEL      (DRX_CTRL_BASE + 32) /**<                   */
+#define DRX_CTRL_MB_MER          (DRX_CTRL_BASE + 33) /**<                   */
 
 	/* Misc */
 #define DRX_CTRL_UIO_CFG         DRX_CTRL_SET_UIO_CFG  /**< Configure UIO     */
-#define DRX_CTRL_SET_UIO_CFG     ( DRX_CTRL_BASE + 34) /**< Configure UIO     */
-#define DRX_CTRL_GET_UIO_CFG     ( DRX_CTRL_BASE + 35) /**< Configure UIO     */
-#define DRX_CTRL_UIO_READ        ( DRX_CTRL_BASE + 36) /**< Read from UIO     */
-#define DRX_CTRL_UIO_WRITE       ( DRX_CTRL_BASE + 37) /**< Write to UIO      */
-#define DRX_CTRL_READ_EVENTS     ( DRX_CTRL_BASE + 38) /**< Read events       */
-#define DRX_CTRL_HDL_EVENTS      ( DRX_CTRL_BASE + 39) /**< Handle events     */
-#define DRX_CTRL_POWER_MODE      ( DRX_CTRL_BASE + 40) /**< Set power mode    */
-#define DRX_CTRL_LOAD_FILTER     ( DRX_CTRL_BASE + 41) /**< Load chan. filter */
-#define DRX_CTRL_VALIDATE_UCODE  ( DRX_CTRL_BASE + 42) /**< Validate ucode    */
-#define DRX_CTRL_DUMP_REGISTERS  ( DRX_CTRL_BASE + 43) /**< Dump registers    */
+#define DRX_CTRL_SET_UIO_CFG     (DRX_CTRL_BASE + 34) /**< Configure UIO     */
+#define DRX_CTRL_GET_UIO_CFG     (DRX_CTRL_BASE + 35) /**< Configure UIO     */
+#define DRX_CTRL_UIO_READ        (DRX_CTRL_BASE + 36) /**< Read from UIO     */
+#define DRX_CTRL_UIO_WRITE       (DRX_CTRL_BASE + 37) /**< Write to UIO      */
+#define DRX_CTRL_READ_EVENTS     (DRX_CTRL_BASE + 38) /**< Read events       */
+#define DRX_CTRL_HDL_EVENTS      (DRX_CTRL_BASE + 39) /**< Handle events     */
+#define DRX_CTRL_POWER_MODE      (DRX_CTRL_BASE + 40) /**< Set power mode    */
+#define DRX_CTRL_LOAD_FILTER     (DRX_CTRL_BASE + 41) /**< Load chan. filter */
+#define DRX_CTRL_VALIDATE_UCODE  (DRX_CTRL_BASE + 42) /**< Validate ucode    */
+#define DRX_CTRL_DUMP_REGISTERS  (DRX_CTRL_BASE + 43) /**< Dump registers    */
 
-#define DRX_CTRL_MAX             ( DRX_CTRL_BASE + 44)	/* never to be used    */
+#define DRX_CTRL_MAX             (DRX_CTRL_BASE + 44)	/* never to be used    */
 
 /**
 * \enum DRXUCodeAction_t
@@ -1004,25 +1004,25 @@ STRUCTS
 #define DRX_CFG_BASE          ((DRXCfgType_t)0)
 #endif
 
-#define DRX_CFG_MPEG_OUTPUT         ( DRX_CFG_BASE +  0)	/* MPEG TS output    */
-#define DRX_CFG_PKTERR              ( DRX_CFG_BASE +  1)	/* Packet Error      */
-#define DRX_CFG_SYMCLK_OFFS         ( DRX_CFG_BASE +  2)	/* Symbol Clk Offset */
-#define DRX_CFG_SMA                 ( DRX_CFG_BASE +  3)	/* Smart Antenna     */
-#define DRX_CFG_PINSAFE             ( DRX_CFG_BASE +  4)	/* Pin safe mode     */
-#define DRX_CFG_SUBSTANDARD         ( DRX_CFG_BASE +  5)	/* substandard       */
-#define DRX_CFG_AUD_VOLUME          ( DRX_CFG_BASE +  6)	/* volume            */
-#define DRX_CFG_AUD_RDS             ( DRX_CFG_BASE +  7)	/* rds               */
-#define DRX_CFG_AUD_AUTOSOUND       ( DRX_CFG_BASE +  8)	/* ASS & ASC         */
-#define DRX_CFG_AUD_ASS_THRES       ( DRX_CFG_BASE +  9)	/* ASS Thresholds    */
-#define DRX_CFG_AUD_DEVIATION       ( DRX_CFG_BASE + 10)	/* Deviation         */
-#define DRX_CFG_AUD_PRESCALE        ( DRX_CFG_BASE + 11)	/* Prescale          */
-#define DRX_CFG_AUD_MIXER           ( DRX_CFG_BASE + 12)	/* Mixer             */
-#define DRX_CFG_AUD_AVSYNC          ( DRX_CFG_BASE + 13)	/* AVSync            */
-#define DRX_CFG_AUD_CARRIER         ( DRX_CFG_BASE + 14)	/* Audio carriers    */
-#define DRX_CFG_I2S_OUTPUT          ( DRX_CFG_BASE + 15)	/* I2S output        */
-#define DRX_CFG_ATV_STANDARD        ( DRX_CFG_BASE + 16)	/* ATV standard      */
-#define DRX_CFG_SQI_SPEED           ( DRX_CFG_BASE + 17)	/* SQI speed         */
-#define DRX_CTRL_CFG_MAX            ( DRX_CFG_BASE + 18)	/* never to be used  */
+#define DRX_CFG_MPEG_OUTPUT         (DRX_CFG_BASE +  0)	/* MPEG TS output    */
+#define DRX_CFG_PKTERR              (DRX_CFG_BASE +  1)	/* Packet Error      */
+#define DRX_CFG_SYMCLK_OFFS         (DRX_CFG_BASE +  2)	/* Symbol Clk Offset */
+#define DRX_CFG_SMA                 (DRX_CFG_BASE +  3)	/* Smart Antenna     */
+#define DRX_CFG_PINSAFE             (DRX_CFG_BASE +  4)	/* Pin safe mode     */
+#define DRX_CFG_SUBSTANDARD         (DRX_CFG_BASE +  5)	/* substandard       */
+#define DRX_CFG_AUD_VOLUME          (DRX_CFG_BASE +  6)	/* volume            */
+#define DRX_CFG_AUD_RDS             (DRX_CFG_BASE +  7)	/* rds               */
+#define DRX_CFG_AUD_AUTOSOUND       (DRX_CFG_BASE +  8)	/* ASS & ASC         */
+#define DRX_CFG_AUD_ASS_THRES       (DRX_CFG_BASE +  9)	/* ASS Thresholds    */
+#define DRX_CFG_AUD_DEVIATION       (DRX_CFG_BASE + 10)	/* Deviation         */
+#define DRX_CFG_AUD_PRESCALE        (DRX_CFG_BASE + 11)	/* Prescale          */
+#define DRX_CFG_AUD_MIXER           (DRX_CFG_BASE + 12)	/* Mixer             */
+#define DRX_CFG_AUD_AVSYNC          (DRX_CFG_BASE + 13)	/* AVSync            */
+#define DRX_CFG_AUD_CARRIER         (DRX_CFG_BASE + 14)	/* Audio carriers    */
+#define DRX_CFG_I2S_OUTPUT          (DRX_CFG_BASE + 15)	/* I2S output        */
+#define DRX_CFG_ATV_STANDARD        (DRX_CFG_BASE + 16)	/* ATV standard      */
+#define DRX_CFG_SQI_SPEED           (DRX_CFG_BASE + 17)	/* SQI speed         */
+#define DRX_CTRL_CFG_MAX            (DRX_CFG_BASE + 18)	/* never to be used  */
 
 #define DRX_CFG_PINS_SAFE_MODE      DRX_CFG_PINSAFE
 /*============================================================================*/
@@ -1279,7 +1279,7 @@ STRUCTS
 	typedef int(*DRXScanFunc_t) (void *scanContext,
 					     DRXScanCommand_t scanCommand,
 					     pDRXChannel_t scanChannel,
-					     bool * getNextChannel);
+					     bool *getNextChannel);
 
 /*========================================*/
 
@@ -2181,275 +2181,275 @@ Conversion from enum values to human readable form.
 /* standard */
 
 #define DRX_STR_STANDARD(x) ( \
-   ( x == DRX_STANDARD_DVBT             )  ? "DVB-T"            : \
-   ( x == DRX_STANDARD_8VSB             )  ? "8VSB"             : \
-   ( x == DRX_STANDARD_NTSC             )  ? "NTSC"             : \
-   ( x == DRX_STANDARD_PAL_SECAM_BG     )  ? "PAL/SECAM B/G"    : \
-   ( x == DRX_STANDARD_PAL_SECAM_DK     )  ? "PAL/SECAM D/K"    : \
-   ( x == DRX_STANDARD_PAL_SECAM_I      )  ? "PAL/SECAM I"      : \
-   ( x == DRX_STANDARD_PAL_SECAM_L      )  ? "PAL/SECAM L"      : \
-   ( x == DRX_STANDARD_PAL_SECAM_LP     )  ? "PAL/SECAM LP"     : \
-   ( x == DRX_STANDARD_ITU_A            )  ? "ITU-A"            : \
-   ( x == DRX_STANDARD_ITU_B            )  ? "ITU-B"            : \
-   ( x == DRX_STANDARD_ITU_C            )  ? "ITU-C"            : \
-   ( x == DRX_STANDARD_ITU_D            )  ? "ITU-D"            : \
-   ( x == DRX_STANDARD_FM               )  ? "FM"               : \
-   ( x == DRX_STANDARD_DTMB             )  ? "DTMB"             : \
-   ( x == DRX_STANDARD_AUTO             )  ? "Auto"             : \
-   ( x == DRX_STANDARD_UNKNOWN          )  ? "Unknown"          : \
-					     "(Invalid)"  )
+   (x == DRX_STANDARD_DVBT)  ? "DVB-T"            : \
+   (x == DRX_STANDARD_8VSB)  ? "8VSB"             : \
+   (x == DRX_STANDARD_NTSC)  ? "NTSC"             : \
+   (x == DRX_STANDARD_PAL_SECAM_BG)  ? "PAL/SECAM B/G"    : \
+   (x == DRX_STANDARD_PAL_SECAM_DK)  ? "PAL/SECAM D/K"    : \
+   (x == DRX_STANDARD_PAL_SECAM_I)  ? "PAL/SECAM I"      : \
+   (x == DRX_STANDARD_PAL_SECAM_L)  ? "PAL/SECAM L"      : \
+   (x == DRX_STANDARD_PAL_SECAM_LP)  ? "PAL/SECAM LP"     : \
+   (x == DRX_STANDARD_ITU_A)  ? "ITU-A"            : \
+   (x == DRX_STANDARD_ITU_B)  ? "ITU-B"            : \
+   (x == DRX_STANDARD_ITU_C)  ? "ITU-C"            : \
+   (x == DRX_STANDARD_ITU_D)  ? "ITU-D"            : \
+   (x == DRX_STANDARD_FM)  ? "FM"               : \
+   (x == DRX_STANDARD_DTMB)  ? "DTMB"             : \
+   (x == DRX_STANDARD_AUTO)  ? "Auto"             : \
+   (x == DRX_STANDARD_UNKNOWN)  ? "Unknown"          : \
+					     "(Invalid)")
 
 /* channel */
 
 #define DRX_STR_BANDWIDTH(x) ( \
-   ( x == DRX_BANDWIDTH_8MHZ           )  ?  "8 MHz"            : \
-   ( x == DRX_BANDWIDTH_7MHZ           )  ?  "7 MHz"            : \
-   ( x == DRX_BANDWIDTH_6MHZ           )  ?  "6 MHz"            : \
-   ( x == DRX_BANDWIDTH_AUTO           )  ?  "Auto"             : \
-   ( x == DRX_BANDWIDTH_UNKNOWN        )  ?  "Unknown"          : \
-					     "(Invalid)"  )
+   (x == DRX_BANDWIDTH_8MHZ)  ?  "8 MHz"            : \
+   (x == DRX_BANDWIDTH_7MHZ)  ?  "7 MHz"            : \
+   (x == DRX_BANDWIDTH_6MHZ)  ?  "6 MHz"            : \
+   (x == DRX_BANDWIDTH_AUTO)  ?  "Auto"             : \
+   (x == DRX_BANDWIDTH_UNKNOWN)  ?  "Unknown"          : \
+					     "(Invalid)")
 #define DRX_STR_FFTMODE(x) ( \
-   ( x == DRX_FFTMODE_2K               )  ?  "2k"               : \
-   ( x == DRX_FFTMODE_4K               )  ?  "4k"               : \
-   ( x == DRX_FFTMODE_8K               )  ?  "8k"               : \
-   ( x == DRX_FFTMODE_AUTO             )  ?  "Auto"             : \
-   ( x == DRX_FFTMODE_UNKNOWN          )  ?  "Unknown"          : \
-					     "(Invalid)"  )
+   (x == DRX_FFTMODE_2K)  ?  "2k"               : \
+   (x == DRX_FFTMODE_4K)  ?  "4k"               : \
+   (x == DRX_FFTMODE_8K)  ?  "8k"               : \
+   (x == DRX_FFTMODE_AUTO)  ?  "Auto"             : \
+   (x == DRX_FFTMODE_UNKNOWN)  ?  "Unknown"          : \
+					     "(Invalid)")
 #define DRX_STR_GUARD(x) ( \
-   ( x == DRX_GUARD_1DIV32             )  ?  "1/32nd"           : \
-   ( x == DRX_GUARD_1DIV16             )  ?  "1/16th"           : \
-   ( x == DRX_GUARD_1DIV8              )  ?  "1/8th"            : \
-   ( x == DRX_GUARD_1DIV4              )  ?  "1/4th"            : \
-   ( x == DRX_GUARD_AUTO               )  ?  "Auto"             : \
-   ( x == DRX_GUARD_UNKNOWN            )  ?  "Unknown"          : \
-					     "(Invalid)"  )
+   (x == DRX_GUARD_1DIV32)  ?  "1/32nd"           : \
+   (x == DRX_GUARD_1DIV16)  ?  "1/16th"           : \
+   (x == DRX_GUARD_1DIV8)  ?  "1/8th"            : \
+   (x == DRX_GUARD_1DIV4)  ?  "1/4th"            : \
+   (x == DRX_GUARD_AUTO)  ?  "Auto"             : \
+   (x == DRX_GUARD_UNKNOWN)  ?  "Unknown"          : \
+					     "(Invalid)")
 #define DRX_STR_CONSTELLATION(x) ( \
-   ( x == DRX_CONSTELLATION_BPSK       )  ?  "BPSK"            : \
-   ( x == DRX_CONSTELLATION_QPSK       )  ?  "QPSK"            : \
-   ( x == DRX_CONSTELLATION_PSK8       )  ?  "PSK8"            : \
-   ( x == DRX_CONSTELLATION_QAM16      )  ?  "QAM16"           : \
-   ( x == DRX_CONSTELLATION_QAM32      )  ?  "QAM32"           : \
-   ( x == DRX_CONSTELLATION_QAM64      )  ?  "QAM64"           : \
-   ( x == DRX_CONSTELLATION_QAM128     )  ?  "QAM128"          : \
-   ( x == DRX_CONSTELLATION_QAM256     )  ?  "QAM256"          : \
-   ( x == DRX_CONSTELLATION_QAM512     )  ?  "QAM512"          : \
-   ( x == DRX_CONSTELLATION_QAM1024    )  ?  "QAM1024"         : \
-   ( x == DRX_CONSTELLATION_QPSK_NR    )  ?  "QPSK_NR"            : \
-   ( x == DRX_CONSTELLATION_AUTO       )  ?  "Auto"            : \
-   ( x == DRX_CONSTELLATION_UNKNOWN    )  ?  "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_CONSTELLATION_BPSK)  ?  "BPSK"            : \
+   (x == DRX_CONSTELLATION_QPSK)  ?  "QPSK"            : \
+   (x == DRX_CONSTELLATION_PSK8)  ?  "PSK8"            : \
+   (x == DRX_CONSTELLATION_QAM16)  ?  "QAM16"           : \
+   (x == DRX_CONSTELLATION_QAM32)  ?  "QAM32"           : \
+   (x == DRX_CONSTELLATION_QAM64)  ?  "QAM64"           : \
+   (x == DRX_CONSTELLATION_QAM128)  ?  "QAM128"          : \
+   (x == DRX_CONSTELLATION_QAM256)  ?  "QAM256"          : \
+   (x == DRX_CONSTELLATION_QAM512)  ?  "QAM512"          : \
+   (x == DRX_CONSTELLATION_QAM1024)  ?  "QAM1024"         : \
+   (x == DRX_CONSTELLATION_QPSK_NR)  ?  "QPSK_NR"            : \
+   (x == DRX_CONSTELLATION_AUTO)  ?  "Auto"            : \
+   (x == DRX_CONSTELLATION_UNKNOWN)  ?  "Unknown"         : \
+					     "(Invalid)")
 #define DRX_STR_CODERATE(x) ( \
-   ( x == DRX_CODERATE_1DIV2           )  ?  "1/2nd"           : \
-   ( x == DRX_CODERATE_2DIV3           )  ?  "2/3rd"           : \
-   ( x == DRX_CODERATE_3DIV4           )  ?  "3/4th"           : \
-   ( x == DRX_CODERATE_5DIV6           )  ?  "5/6th"           : \
-   ( x == DRX_CODERATE_7DIV8           )  ?  "7/8th"           : \
-   ( x == DRX_CODERATE_AUTO            )  ?  "Auto"            : \
-   ( x == DRX_CODERATE_UNKNOWN         )  ?  "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_CODERATE_1DIV2)  ?  "1/2nd"           : \
+   (x == DRX_CODERATE_2DIV3)  ?  "2/3rd"           : \
+   (x == DRX_CODERATE_3DIV4)  ?  "3/4th"           : \
+   (x == DRX_CODERATE_5DIV6)  ?  "5/6th"           : \
+   (x == DRX_CODERATE_7DIV8)  ?  "7/8th"           : \
+   (x == DRX_CODERATE_AUTO)  ?  "Auto"            : \
+   (x == DRX_CODERATE_UNKNOWN)  ?  "Unknown"         : \
+					     "(Invalid)")
 #define DRX_STR_HIERARCHY(x) ( \
-   ( x == DRX_HIERARCHY_NONE           )  ?  "None"            : \
-   ( x == DRX_HIERARCHY_ALPHA1         )  ?  "Alpha=1"         : \
-   ( x == DRX_HIERARCHY_ALPHA2         )  ?  "Alpha=2"         : \
-   ( x == DRX_HIERARCHY_ALPHA4         )  ?  "Alpha=4"         : \
-   ( x == DRX_HIERARCHY_AUTO           )  ?  "Auto"            : \
-   ( x == DRX_HIERARCHY_UNKNOWN        )  ?  "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_HIERARCHY_NONE)  ?  "None"            : \
+   (x == DRX_HIERARCHY_ALPHA1)  ?  "Alpha=1"         : \
+   (x == DRX_HIERARCHY_ALPHA2)  ?  "Alpha=2"         : \
+   (x == DRX_HIERARCHY_ALPHA4)  ?  "Alpha=4"         : \
+   (x == DRX_HIERARCHY_AUTO)  ?  "Auto"            : \
+   (x == DRX_HIERARCHY_UNKNOWN)  ?  "Unknown"         : \
+					     "(Invalid)")
 #define DRX_STR_PRIORITY(x) ( \
-   ( x == DRX_PRIORITY_LOW             )  ?  "Low"             : \
-   ( x == DRX_PRIORITY_HIGH            )  ?  "High"            : \
-   ( x == DRX_PRIORITY_UNKNOWN         )  ?  "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_PRIORITY_LOW)  ?  "Low"             : \
+   (x == DRX_PRIORITY_HIGH)  ?  "High"            : \
+   (x == DRX_PRIORITY_UNKNOWN)  ?  "Unknown"         : \
+					     "(Invalid)")
 #define DRX_STR_MIRROR(x) ( \
-   ( x == DRX_MIRROR_NO                )  ?  "Normal"          : \
-   ( x == DRX_MIRROR_YES               )  ?  "Mirrored"        : \
-   ( x == DRX_MIRROR_AUTO              )  ?  "Auto"            : \
-   ( x == DRX_MIRROR_UNKNOWN           )  ?  "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_MIRROR_NO)  ?  "Normal"          : \
+   (x == DRX_MIRROR_YES)  ?  "Mirrored"        : \
+   (x == DRX_MIRROR_AUTO)  ?  "Auto"            : \
+   (x == DRX_MIRROR_UNKNOWN)  ?  "Unknown"         : \
+					     "(Invalid)")
 #define DRX_STR_CLASSIFICATION(x) ( \
-   ( x == DRX_CLASSIFICATION_GAUSS     )  ?  "Gaussion"        : \
-   ( x == DRX_CLASSIFICATION_HVY_GAUSS )  ?  "Heavy Gaussion"  : \
-   ( x == DRX_CLASSIFICATION_COCHANNEL )  ?  "Co-channel"      : \
-   ( x == DRX_CLASSIFICATION_STATIC    )  ?  "Static echo"     : \
-   ( x == DRX_CLASSIFICATION_MOVING    )  ?  "Moving echo"     : \
-   ( x == DRX_CLASSIFICATION_ZERODB    )  ?  "Zero dB echo"    : \
-   ( x == DRX_CLASSIFICATION_UNKNOWN   )  ?  "Unknown"         : \
-   ( x == DRX_CLASSIFICATION_AUTO      )  ?  "Auto"            : \
-					     "(Invalid)" )
+   (x == DRX_CLASSIFICATION_GAUSS)  ?  "Gaussion"        : \
+   (x == DRX_CLASSIFICATION_HVY_GAUSS)  ?  "Heavy Gaussion"  : \
+   (x == DRX_CLASSIFICATION_COCHANNEL)  ?  "Co-channel"      : \
+   (x == DRX_CLASSIFICATION_STATIC)  ?  "Static echo"     : \
+   (x == DRX_CLASSIFICATION_MOVING)  ?  "Moving echo"     : \
+   (x == DRX_CLASSIFICATION_ZERODB)  ?  "Zero dB echo"    : \
+   (x == DRX_CLASSIFICATION_UNKNOWN)  ?  "Unknown"         : \
+   (x == DRX_CLASSIFICATION_AUTO)  ?  "Auto"            : \
+					     "(Invalid)")
 
 #define DRX_STR_INTERLEAVEMODE(x) ( \
-   ( x == DRX_INTERLEAVEMODE_I128_J1     ) ? "I128_J1"         : \
-   ( x == DRX_INTERLEAVEMODE_I128_J1_V2  ) ? "I128_J1_V2"      : \
-   ( x == DRX_INTERLEAVEMODE_I128_J2     ) ? "I128_J2"         : \
-   ( x == DRX_INTERLEAVEMODE_I64_J2      ) ? "I64_J2"          : \
-   ( x == DRX_INTERLEAVEMODE_I128_J3     ) ? "I128_J3"         : \
-   ( x == DRX_INTERLEAVEMODE_I32_J4      ) ? "I32_J4"          : \
-   ( x == DRX_INTERLEAVEMODE_I128_J4     ) ? "I128_J4"         : \
-   ( x == DRX_INTERLEAVEMODE_I16_J8      ) ? "I16_J8"          : \
-   ( x == DRX_INTERLEAVEMODE_I128_J5     ) ? "I128_J5"         : \
-   ( x == DRX_INTERLEAVEMODE_I8_J16      ) ? "I8_J16"          : \
-   ( x == DRX_INTERLEAVEMODE_I128_J6     ) ? "I128_J6"         : \
-   ( x == DRX_INTERLEAVEMODE_RESERVED_11 ) ? "Reserved 11"     : \
-   ( x == DRX_INTERLEAVEMODE_I128_J7     ) ? "I128_J7"         : \
-   ( x == DRX_INTERLEAVEMODE_RESERVED_13 ) ? "Reserved 13"     : \
-   ( x == DRX_INTERLEAVEMODE_I128_J8     ) ? "I128_J8"         : \
-   ( x == DRX_INTERLEAVEMODE_RESERVED_15 ) ? "Reserved 15"     : \
-   ( x == DRX_INTERLEAVEMODE_I12_J17     ) ? "I12_J17"         : \
-   ( x == DRX_INTERLEAVEMODE_I5_J4       ) ? "I5_J4"           : \
-   ( x == DRX_INTERLEAVEMODE_B52_M240    ) ? "B52_M240"        : \
-   ( x == DRX_INTERLEAVEMODE_B52_M720    ) ? "B52_M720"        : \
-   ( x == DRX_INTERLEAVEMODE_B52_M48     ) ? "B52_M48"         : \
-   ( x == DRX_INTERLEAVEMODE_B52_M0      ) ? "B52_M0"          : \
-   ( x == DRX_INTERLEAVEMODE_UNKNOWN     ) ? "Unknown"         : \
-   ( x == DRX_INTERLEAVEMODE_AUTO        ) ? "Auto"            : \
-					     "(Invalid)" )
+   (x == DRX_INTERLEAVEMODE_I128_J1) ? "I128_J1"         : \
+   (x == DRX_INTERLEAVEMODE_I128_J1_V2) ? "I128_J1_V2"      : \
+   (x == DRX_INTERLEAVEMODE_I128_J2) ? "I128_J2"         : \
+   (x == DRX_INTERLEAVEMODE_I64_J2) ? "I64_J2"          : \
+   (x == DRX_INTERLEAVEMODE_I128_J3) ? "I128_J3"         : \
+   (x == DRX_INTERLEAVEMODE_I32_J4) ? "I32_J4"          : \
+   (x == DRX_INTERLEAVEMODE_I128_J4) ? "I128_J4"         : \
+   (x == DRX_INTERLEAVEMODE_I16_J8) ? "I16_J8"          : \
+   (x == DRX_INTERLEAVEMODE_I128_J5) ? "I128_J5"         : \
+   (x == DRX_INTERLEAVEMODE_I8_J16) ? "I8_J16"          : \
+   (x == DRX_INTERLEAVEMODE_I128_J6) ? "I128_J6"         : \
+   (x == DRX_INTERLEAVEMODE_RESERVED_11) ? "Reserved 11"     : \
+   (x == DRX_INTERLEAVEMODE_I128_J7) ? "I128_J7"         : \
+   (x == DRX_INTERLEAVEMODE_RESERVED_13) ? "Reserved 13"     : \
+   (x == DRX_INTERLEAVEMODE_I128_J8) ? "I128_J8"         : \
+   (x == DRX_INTERLEAVEMODE_RESERVED_15) ? "Reserved 15"     : \
+   (x == DRX_INTERLEAVEMODE_I12_J17) ? "I12_J17"         : \
+   (x == DRX_INTERLEAVEMODE_I5_J4) ? "I5_J4"           : \
+   (x == DRX_INTERLEAVEMODE_B52_M240) ? "B52_M240"        : \
+   (x == DRX_INTERLEAVEMODE_B52_M720) ? "B52_M720"        : \
+   (x == DRX_INTERLEAVEMODE_B52_M48) ? "B52_M48"         : \
+   (x == DRX_INTERLEAVEMODE_B52_M0) ? "B52_M0"          : \
+   (x == DRX_INTERLEAVEMODE_UNKNOWN) ? "Unknown"         : \
+   (x == DRX_INTERLEAVEMODE_AUTO) ? "Auto"            : \
+					     "(Invalid)")
 
 #define DRX_STR_LDPC(x) ( \
-   ( x == DRX_LDPC_0_4                   ) ? "0.4"             : \
-   ( x == DRX_LDPC_0_6                   ) ? "0.6"             : \
-   ( x == DRX_LDPC_0_8                   ) ? "0.8"             : \
-   ( x == DRX_LDPC_AUTO                  ) ? "Auto"            : \
-   ( x == DRX_LDPC_UNKNOWN               ) ? "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_LDPC_0_4) ? "0.4"             : \
+   (x == DRX_LDPC_0_6) ? "0.6"             : \
+   (x == DRX_LDPC_0_8) ? "0.8"             : \
+   (x == DRX_LDPC_AUTO) ? "Auto"            : \
+   (x == DRX_LDPC_UNKNOWN) ? "Unknown"         : \
+					     "(Invalid)")
 
 #define DRX_STR_CARRIER(x) ( \
-   ( x == DRX_CARRIER_MULTI              ) ? "Multi"           : \
-   ( x == DRX_CARRIER_SINGLE             ) ? "Single"          : \
-   ( x == DRX_CARRIER_AUTO               ) ? "Auto"            : \
-   ( x == DRX_CARRIER_UNKNOWN            ) ? "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_CARRIER_MULTI) ? "Multi"           : \
+   (x == DRX_CARRIER_SINGLE) ? "Single"          : \
+   (x == DRX_CARRIER_AUTO) ? "Auto"            : \
+   (x == DRX_CARRIER_UNKNOWN) ? "Unknown"         : \
+					     "(Invalid)")
 
 #define DRX_STR_FRAMEMODE(x) ( \
-   ( x == DRX_FRAMEMODE_420          )  ? "420"                : \
-   ( x == DRX_FRAMEMODE_595          )  ? "595"                : \
-   ( x == DRX_FRAMEMODE_945          )  ? "945"                : \
-   ( x == DRX_FRAMEMODE_420_FIXED_PN )  ? "420 with fixed PN"  : \
-   ( x == DRX_FRAMEMODE_945_FIXED_PN )  ? "945 with fixed PN"  : \
-   ( x == DRX_FRAMEMODE_AUTO         )  ? "Auto"               : \
-   ( x == DRX_FRAMEMODE_UNKNOWN      )  ? "Unknown"            : \
-					  "(Invalid)" )
+   (x == DRX_FRAMEMODE_420)  ? "420"                : \
+   (x == DRX_FRAMEMODE_595)  ? "595"                : \
+   (x == DRX_FRAMEMODE_945)  ? "945"                : \
+   (x == DRX_FRAMEMODE_420_FIXED_PN)  ? "420 with fixed PN"  : \
+   (x == DRX_FRAMEMODE_945_FIXED_PN)  ? "945 with fixed PN"  : \
+   (x == DRX_FRAMEMODE_AUTO)  ? "Auto"               : \
+   (x == DRX_FRAMEMODE_UNKNOWN)  ? "Unknown"            : \
+					  "(Invalid)")
 
 #define DRX_STR_PILOT(x) ( \
-   ( x == DRX_PILOT_ON                 ) ?   "On"              : \
-   ( x == DRX_PILOT_OFF                ) ?   "Off"             : \
-   ( x == DRX_PILOT_AUTO               ) ?   "Auto"            : \
-   ( x == DRX_PILOT_UNKNOWN            ) ?   "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_PILOT_ON) ?   "On"              : \
+   (x == DRX_PILOT_OFF) ?   "Off"             : \
+   (x == DRX_PILOT_AUTO) ?   "Auto"            : \
+   (x == DRX_PILOT_UNKNOWN) ?   "Unknown"         : \
+					     "(Invalid)")
 /* TPS */
 
 #define DRX_STR_TPS_FRAME(x)  ( \
-   ( x == DRX_TPS_FRAME1               )  ?  "Frame1"          : \
-   ( x == DRX_TPS_FRAME2               )  ?  "Frame2"          : \
-   ( x == DRX_TPS_FRAME3               )  ?  "Frame3"          : \
-   ( x == DRX_TPS_FRAME4               )  ?  "Frame4"          : \
-   ( x == DRX_TPS_FRAME_UNKNOWN        )  ?  "Unknown"         : \
-					     "(Invalid)" )
+   (x == DRX_TPS_FRAME1)  ?  "Frame1"          : \
+   (x == DRX_TPS_FRAME2)  ?  "Frame2"          : \
+   (x == DRX_TPS_FRAME3)  ?  "Frame3"          : \
+   (x == DRX_TPS_FRAME4)  ?  "Frame4"          : \
+   (x == DRX_TPS_FRAME_UNKNOWN)  ?  "Unknown"         : \
+					     "(Invalid)")
 
 /* lock status */
 
 #define DRX_STR_LOCKSTATUS(x) ( \
-   ( x == DRX_NEVER_LOCK               )  ?  "Never"           : \
-   ( x == DRX_NOT_LOCKED               )  ?  "No"              : \
-   ( x == DRX_LOCKED                   )  ?  "Locked"          : \
-   ( x == DRX_LOCK_STATE_1             )  ?  "Lock state 1"    : \
-   ( x == DRX_LOCK_STATE_2             )  ?  "Lock state 2"    : \
-   ( x == DRX_LOCK_STATE_3             )  ?  "Lock state 3"    : \
-   ( x == DRX_LOCK_STATE_4             )  ?  "Lock state 4"    : \
-   ( x == DRX_LOCK_STATE_5             )  ?  "Lock state 5"    : \
-   ( x == DRX_LOCK_STATE_6             )  ?  "Lock state 6"    : \
-   ( x == DRX_LOCK_STATE_7             )  ?  "Lock state 7"    : \
-   ( x == DRX_LOCK_STATE_8             )  ?  "Lock state 8"    : \
-   ( x == DRX_LOCK_STATE_9             )  ?  "Lock state 9"    : \
-					     "(Invalid)" )
+   (x == DRX_NEVER_LOCK)  ?  "Never"           : \
+   (x == DRX_NOT_LOCKED)  ?  "No"              : \
+   (x == DRX_LOCKED)  ?  "Locked"          : \
+   (x == DRX_LOCK_STATE_1)  ?  "Lock state 1"    : \
+   (x == DRX_LOCK_STATE_2)  ?  "Lock state 2"    : \
+   (x == DRX_LOCK_STATE_3)  ?  "Lock state 3"    : \
+   (x == DRX_LOCK_STATE_4)  ?  "Lock state 4"    : \
+   (x == DRX_LOCK_STATE_5)  ?  "Lock state 5"    : \
+   (x == DRX_LOCK_STATE_6)  ?  "Lock state 6"    : \
+   (x == DRX_LOCK_STATE_7)  ?  "Lock state 7"    : \
+   (x == DRX_LOCK_STATE_8)  ?  "Lock state 8"    : \
+   (x == DRX_LOCK_STATE_9)  ?  "Lock state 9"    : \
+					     "(Invalid)")
 
 /* version information , modules */
 #define DRX_STR_MODULE(x) ( \
-   ( x == DRX_MODULE_DEVICE            )  ?  "Device"                : \
-   ( x == DRX_MODULE_MICROCODE         )  ?  "Microcode"             : \
-   ( x == DRX_MODULE_DRIVERCORE        )  ?  "CoreDriver"            : \
-   ( x == DRX_MODULE_DEVICEDRIVER      )  ?  "DeviceDriver"          : \
-   ( x == DRX_MODULE_BSP_I2C           )  ?  "BSP I2C"               : \
-   ( x == DRX_MODULE_BSP_TUNER         )  ?  "BSP Tuner"             : \
-   ( x == DRX_MODULE_BSP_HOST          )  ?  "BSP Host"              : \
-   ( x == DRX_MODULE_DAP               )  ?  "Data Access Protocol"  : \
-   ( x == DRX_MODULE_UNKNOWN           )  ?  "Unknown"               : \
-					     "(Invalid)" )
+   (x == DRX_MODULE_DEVICE)  ?  "Device"                : \
+   (x == DRX_MODULE_MICROCODE)  ?  "Microcode"             : \
+   (x == DRX_MODULE_DRIVERCORE)  ?  "CoreDriver"            : \
+   (x == DRX_MODULE_DEVICEDRIVER)  ?  "DeviceDriver"          : \
+   (x == DRX_MODULE_BSP_I2C)  ?  "BSP I2C"               : \
+   (x == DRX_MODULE_BSP_TUNER)  ?  "BSP Tuner"             : \
+   (x == DRX_MODULE_BSP_HOST)  ?  "BSP Host"              : \
+   (x == DRX_MODULE_DAP)  ?  "Data Access Protocol"  : \
+   (x == DRX_MODULE_UNKNOWN)  ?  "Unknown"               : \
+					     "(Invalid)")
 
 #define DRX_STR_POWER_MODE(x) ( \
-   ( x == DRX_POWER_UP                 )  ?  "DRX_POWER_UP    "  : \
-   ( x == DRX_POWER_MODE_1             )  ?  "DRX_POWER_MODE_1"  : \
-   ( x == DRX_POWER_MODE_2             )  ?  "DRX_POWER_MODE_2"  : \
-   ( x == DRX_POWER_MODE_3             )  ?  "DRX_POWER_MODE_3"  : \
-   ( x == DRX_POWER_MODE_4             )  ?  "DRX_POWER_MODE_4"  : \
-   ( x == DRX_POWER_MODE_5             )  ?  "DRX_POWER_MODE_5"  : \
-   ( x == DRX_POWER_MODE_6             )  ?  "DRX_POWER_MODE_6"  : \
-   ( x == DRX_POWER_MODE_7             )  ?  "DRX_POWER_MODE_7"  : \
-   ( x == DRX_POWER_MODE_8             )  ?  "DRX_POWER_MODE_8"  : \
-   ( x == DRX_POWER_MODE_9             )  ?  "DRX_POWER_MODE_9"  : \
-   ( x == DRX_POWER_MODE_10            )  ?  "DRX_POWER_MODE_10" : \
-   ( x == DRX_POWER_MODE_11            )  ?  "DRX_POWER_MODE_11" : \
-   ( x == DRX_POWER_MODE_12            )  ?  "DRX_POWER_MODE_12" : \
-   ( x == DRX_POWER_MODE_13            )  ?  "DRX_POWER_MODE_13" : \
-   ( x == DRX_POWER_MODE_14            )  ?  "DRX_POWER_MODE_14" : \
-   ( x == DRX_POWER_MODE_15            )  ?  "DRX_POWER_MODE_15" : \
-   ( x == DRX_POWER_MODE_16            )  ?  "DRX_POWER_MODE_16" : \
-   ( x == DRX_POWER_DOWN               )  ?  "DRX_POWER_DOWN  " : \
-					     "(Invalid)" )
+   (x == DRX_POWER_UP)  ?  "DRX_POWER_UP    "  : \
+   (x == DRX_POWER_MODE_1)  ?  "DRX_POWER_MODE_1"  : \
+   (x == DRX_POWER_MODE_2)  ?  "DRX_POWER_MODE_2"  : \
+   (x == DRX_POWER_MODE_3)  ?  "DRX_POWER_MODE_3"  : \
+   (x == DRX_POWER_MODE_4)  ?  "DRX_POWER_MODE_4"  : \
+   (x == DRX_POWER_MODE_5)  ?  "DRX_POWER_MODE_5"  : \
+   (x == DRX_POWER_MODE_6)  ?  "DRX_POWER_MODE_6"  : \
+   (x == DRX_POWER_MODE_7)  ?  "DRX_POWER_MODE_7"  : \
+   (x == DRX_POWER_MODE_8)  ?  "DRX_POWER_MODE_8"  : \
+   (x == DRX_POWER_MODE_9)  ?  "DRX_POWER_MODE_9"  : \
+   (x == DRX_POWER_MODE_10)  ?  "DRX_POWER_MODE_10" : \
+   (x == DRX_POWER_MODE_11)  ?  "DRX_POWER_MODE_11" : \
+   (x == DRX_POWER_MODE_12)  ?  "DRX_POWER_MODE_12" : \
+   (x == DRX_POWER_MODE_13)  ?  "DRX_POWER_MODE_13" : \
+   (x == DRX_POWER_MODE_14)  ?  "DRX_POWER_MODE_14" : \
+   (x == DRX_POWER_MODE_15)  ?  "DRX_POWER_MODE_15" : \
+   (x == DRX_POWER_MODE_16)  ?  "DRX_POWER_MODE_16" : \
+   (x == DRX_POWER_DOWN)  ?  "DRX_POWER_DOWN  " : \
+					     "(Invalid)")
 
 #define DRX_STR_OOB_STANDARD(x) ( \
-   ( x == DRX_OOB_MODE_A            )  ?  "ANSI 55-1  " : \
-   ( x == DRX_OOB_MODE_B_GRADE_A    )  ?  "ANSI 55-2 A" : \
-   ( x == DRX_OOB_MODE_B_GRADE_B    )  ?  "ANSI 55-2 B" : \
-					     "(Invalid)" )
+   (x == DRX_OOB_MODE_A)  ?  "ANSI 55-1  " : \
+   (x == DRX_OOB_MODE_B_GRADE_A)  ?  "ANSI 55-2 A" : \
+   (x == DRX_OOB_MODE_B_GRADE_B)  ?  "ANSI 55-2 B" : \
+					     "(Invalid)")
 
 #define DRX_STR_AUD_STANDARD(x) ( \
-   ( x == DRX_AUD_STANDARD_BTSC         )  ? "BTSC"                     : \
-   ( x == DRX_AUD_STANDARD_A2           )  ? "A2"                       : \
-   ( x == DRX_AUD_STANDARD_EIAJ         )  ? "EIAJ"                     : \
-   ( x == DRX_AUD_STANDARD_FM_STEREO    )  ? "FM Stereo"                : \
-   ( x == DRX_AUD_STANDARD_AUTO         )  ? "Auto"                     : \
-   ( x == DRX_AUD_STANDARD_M_MONO       )  ? "M-Standard Mono"          : \
-   ( x == DRX_AUD_STANDARD_D_K_MONO     )  ? "D/K Mono FM"              : \
-   ( x == DRX_AUD_STANDARD_BG_FM        )  ? "B/G-Dual Carrier FM (A2)" : \
-   ( x == DRX_AUD_STANDARD_D_K1         )  ? "D/K1-Dual Carrier FM"     : \
-   ( x == DRX_AUD_STANDARD_D_K2         )  ? "D/K2-Dual Carrier FM"     : \
-   ( x == DRX_AUD_STANDARD_D_K3         )  ? "D/K3-Dual Carrier FM"     : \
-   ( x == DRX_AUD_STANDARD_BG_NICAM_FM  )  ? "B/G-NICAM-FM"             : \
-   ( x == DRX_AUD_STANDARD_L_NICAM_AM   )  ? "L-NICAM-AM"               : \
-   ( x == DRX_AUD_STANDARD_I_NICAM_FM   )  ? "I-NICAM-FM"               : \
-   ( x == DRX_AUD_STANDARD_D_K_NICAM_FM )  ? "D/K-NICAM-FM"             : \
-   ( x == DRX_AUD_STANDARD_UNKNOWN      )  ? "Unknown"                  : \
-					     "(Invalid)"  )
+   (x == DRX_AUD_STANDARD_BTSC)  ? "BTSC"                     : \
+   (x == DRX_AUD_STANDARD_A2)  ? "A2"                       : \
+   (x == DRX_AUD_STANDARD_EIAJ)  ? "EIAJ"                     : \
+   (x == DRX_AUD_STANDARD_FM_STEREO)  ? "FM Stereo"                : \
+   (x == DRX_AUD_STANDARD_AUTO)  ? "Auto"                     : \
+   (x == DRX_AUD_STANDARD_M_MONO)  ? "M-Standard Mono"          : \
+   (x == DRX_AUD_STANDARD_D_K_MONO)  ? "D/K Mono FM"              : \
+   (x == DRX_AUD_STANDARD_BG_FM)  ? "B/G-Dual Carrier FM (A2)" : \
+   (x == DRX_AUD_STANDARD_D_K1)  ? "D/K1-Dual Carrier FM"     : \
+   (x == DRX_AUD_STANDARD_D_K2)  ? "D/K2-Dual Carrier FM"     : \
+   (x == DRX_AUD_STANDARD_D_K3)  ? "D/K3-Dual Carrier FM"     : \
+   (x == DRX_AUD_STANDARD_BG_NICAM_FM)  ? "B/G-NICAM-FM"             : \
+   (x == DRX_AUD_STANDARD_L_NICAM_AM)  ? "L-NICAM-AM"               : \
+   (x == DRX_AUD_STANDARD_I_NICAM_FM)  ? "I-NICAM-FM"               : \
+   (x == DRX_AUD_STANDARD_D_K_NICAM_FM)  ? "D/K-NICAM-FM"             : \
+   (x == DRX_AUD_STANDARD_UNKNOWN)  ? "Unknown"                  : \
+					     "(Invalid)")
 #define DRX_STR_AUD_STEREO(x) ( \
-   ( x == true                          )  ? "Stereo"           : \
-   ( x == false                         )  ? "Mono"             : \
-					     "(Invalid)"  )
+   (x == true)  ? "Stereo"           : \
+   (x == false)  ? "Mono"             : \
+					     "(Invalid)")
 
 #define DRX_STR_AUD_SAP(x) ( \
-   ( x == true                          )  ? "Present"          : \
-   ( x == false                         )  ? "Not present"      : \
-					     "(Invalid)"  )
+   (x == true)  ? "Present"          : \
+   (x == false)  ? "Not present"      : \
+					     "(Invalid)")
 
 #define DRX_STR_AUD_CARRIER(x) ( \
-   ( x == true                          )  ? "Present"          : \
-   ( x == false                         )  ? "Not present"      : \
-					     "(Invalid)"  )
+   (x == true)  ? "Present"          : \
+   (x == false)  ? "Not present"      : \
+					     "(Invalid)")
 
 #define DRX_STR_AUD_RDS(x) ( \
-   ( x == true                          )  ? "Available"        : \
-   ( x == false                         )  ? "Not Available"    : \
-					     "(Invalid)"  )
+   (x == true)  ? "Available"        : \
+   (x == false)  ? "Not Available"    : \
+					     "(Invalid)")
 
 #define DRX_STR_AUD_NICAM_STATUS(x) ( \
-   ( x == DRX_AUD_NICAM_DETECTED        )  ? "Detected"         : \
-   ( x == DRX_AUD_NICAM_NOT_DETECTED    )  ? "Not detected"     : \
-   ( x == DRX_AUD_NICAM_BAD             )  ? "Bad"              : \
-					     "(Invalid)"  )
+   (x == DRX_AUD_NICAM_DETECTED)  ? "Detected"         : \
+   (x == DRX_AUD_NICAM_NOT_DETECTED)  ? "Not detected"     : \
+   (x == DRX_AUD_NICAM_BAD)  ? "Bad"              : \
+					     "(Invalid)")
 
 #define DRX_STR_RDS_VALID(x) ( \
-   ( x == true                          )  ? "Valid"            : \
-   ( x == false                         )  ? "Not Valid"        : \
-					     "(Invalid)"  )
+   (x == true)  ? "Valid"            : \
+   (x == false)  ? "Not Valid"        : \
+					     "(Invalid)")
 
 /*-------------------------------------------------------------------------
 Access macros
@@ -2466,29 +2466,29 @@ Access macros
 *
 */
 
-#define DRX_ATTR_MCRECORD( d )        ((d)->myCommonAttr->mcversion)
-#define DRX_ATTR_MIRRORFREQSPECT( d ) ((d)->myCommonAttr->mirrorFreqSpect)
-#define DRX_ATTR_CURRENTPOWERMODE( d )((d)->myCommonAttr->currentPowerMode)
-#define DRX_ATTR_ISOPENED( d )        ((d)->myCommonAttr->isOpened)
-#define DRX_ATTR_USEBOOTLOADER( d )   ((d)->myCommonAttr->useBootloader)
-#define DRX_ATTR_CURRENTSTANDARD( d ) ((d)->myCommonAttr->currentStandard)
-#define DRX_ATTR_PREVSTANDARD( d )    ((d)->myCommonAttr->prevStandard)
-#define DRX_ATTR_CACHESTANDARD( d )   ((d)->myCommonAttr->diCacheStandard)
-#define DRX_ATTR_CURRENTCHANNEL( d )  ((d)->myCommonAttr->currentChannel)
-#define DRX_ATTR_MICROCODE( d )       ((d)->myCommonAttr->microcode)
-#define DRX_ATTR_MICROCODESIZE( d )   ((d)->myCommonAttr->microcodeSize)
-#define DRX_ATTR_VERIFYMICROCODE( d ) ((d)->myCommonAttr->verifyMicrocode)
-#define DRX_ATTR_CAPABILITIES( d )    ((d)->myCommonAttr->capabilities)
-#define DRX_ATTR_PRODUCTID( d )       ((d)->myCommonAttr->productId)
-#define DRX_ATTR_INTERMEDIATEFREQ( d) ((d)->myCommonAttr->intermediateFreq)
-#define DRX_ATTR_SYSCLOCKFREQ( d)     ((d)->myCommonAttr->sysClockFreq)
-#define DRX_ATTR_TUNERRFAGCPOL( d )   ((d)->myCommonAttr->tunerRfAgcPol)
-#define DRX_ATTR_TUNERIFAGCPOL( d)    ((d)->myCommonAttr->tunerIfAgcPol)
-#define DRX_ATTR_TUNERSLOWMODE( d)    ((d)->myCommonAttr->tunerSlowMode)
-#define DRX_ATTR_TUNERSPORTNR( d)     ((d)->myCommonAttr->tunerPortNr)
-#define DRX_ATTR_TUNER( d )           ((d)->myTuner)
-#define DRX_ATTR_I2CADDR( d )         ((d)->myI2CDevAddr->i2cAddr)
-#define DRX_ATTR_I2CDEVID( d )        ((d)->myI2CDevAddr->i2cDevId)
+#define DRX_ATTR_MCRECORD(d)        ((d)->myCommonAttr->mcversion)
+#define DRX_ATTR_MIRRORFREQSPECT(d) ((d)->myCommonAttr->mirrorFreqSpect)
+#define DRX_ATTR_CURRENTPOWERMODE(d)((d)->myCommonAttr->currentPowerMode)
+#define DRX_ATTR_ISOPENED(d)        ((d)->myCommonAttr->isOpened)
+#define DRX_ATTR_USEBOOTLOADER(d)   ((d)->myCommonAttr->useBootloader)
+#define DRX_ATTR_CURRENTSTANDARD(d) ((d)->myCommonAttr->currentStandard)
+#define DRX_ATTR_PREVSTANDARD(d)    ((d)->myCommonAttr->prevStandard)
+#define DRX_ATTR_CACHESTANDARD(d)   ((d)->myCommonAttr->diCacheStandard)
+#define DRX_ATTR_CURRENTCHANNEL(d)  ((d)->myCommonAttr->currentChannel)
+#define DRX_ATTR_MICROCODE(d)       ((d)->myCommonAttr->microcode)
+#define DRX_ATTR_MICROCODESIZE(d)   ((d)->myCommonAttr->microcodeSize)
+#define DRX_ATTR_VERIFYMICROCODE(d) ((d)->myCommonAttr->verifyMicrocode)
+#define DRX_ATTR_CAPABILITIES(d)    ((d)->myCommonAttr->capabilities)
+#define DRX_ATTR_PRODUCTID(d)       ((d)->myCommonAttr->productId)
+#define DRX_ATTR_INTERMEDIATEFREQ(d) ((d)->myCommonAttr->intermediateFreq)
+#define DRX_ATTR_SYSCLOCKFREQ(d)     ((d)->myCommonAttr->sysClockFreq)
+#define DRX_ATTR_TUNERRFAGCPOL(d)   ((d)->myCommonAttr->tunerRfAgcPol)
+#define DRX_ATTR_TUNERIFAGCPOL(d)    ((d)->myCommonAttr->tunerIfAgcPol)
+#define DRX_ATTR_TUNERSLOWMODE(d)    ((d)->myCommonAttr->tunerSlowMode)
+#define DRX_ATTR_TUNERSPORTNR(d)     ((d)->myCommonAttr->tunerPortNr)
+#define DRX_ATTR_TUNER(d)           ((d)->myTuner)
+#define DRX_ATTR_I2CADDR(d)         ((d)->myI2CDevAddr->i2cAddr)
+#define DRX_ATTR_I2CDEVID(d)        ((d)->myI2CDevAddr->i2cDevId)
 
 /**
 * \brief Actual access macro's
@@ -2502,72 +2502,72 @@ Access macros
 
 /**************************/
 
-#define DRX_SET_MIRRORFREQSPECT( d, x )                     \
+#define DRX_SET_MIRRORFREQSPECT(d, x)                     \
    do {                                                     \
-      DRX_ATTR_MIRRORFREQSPECT( d ) = (x);                  \
-   } while(0)
+      DRX_ATTR_MIRRORFREQSPECT(d) = (x);                  \
+   } while (0)
 
-#define DRX_GET_MIRRORFREQSPECT( d, x )                     \
+#define DRX_GET_MIRRORFREQSPECT(d, x)                     \
    do {                                                     \
-      (x)=DRX_ATTR_MIRRORFREQSPECT( d );                    \
-   } while(0)
+      (x) = DRX_ATTR_MIRRORFREQSPECT(d);                    \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_CURRENTPOWERMODE( d, x )                    \
+#define DRX_SET_CURRENTPOWERMODE(d, x)                    \
    do {                                                     \
-      DRX_ATTR_CURRENTPOWERMODE( d ) = (x);                 \
-   } while(0)
+      DRX_ATTR_CURRENTPOWERMODE(d) = (x);                 \
+   } while (0)
 
-#define DRX_GET_CURRENTPOWERMODE( d, x )                    \
+#define DRX_GET_CURRENTPOWERMODE(d, x)                    \
    do {                                                     \
-      (x)=DRX_ATTR_CURRENTPOWERMODE( d );                   \
-   } while(0)
+      (x) = DRX_ATTR_CURRENTPOWERMODE(d);                   \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_MICROCODE( d, x )                           \
+#define DRX_SET_MICROCODE(d, x)                           \
    do {                                                     \
-      DRX_ATTR_MICROCODE( d ) = (x);                        \
-   } while(0)
+      DRX_ATTR_MICROCODE(d) = (x);                        \
+   } while (0)
 
-#define DRX_GET_MICROCODE( d, x )                           \
+#define DRX_GET_MICROCODE(d, x)                           \
    do {                                                     \
-      (x)=DRX_ATTR_MICROCODE( d );                          \
-   } while(0)
+      (x) = DRX_ATTR_MICROCODE(d);                          \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_MICROCODESIZE( d, x )                       \
+#define DRX_SET_MICROCODESIZE(d, x)                       \
    do {                                                     \
       DRX_ATTR_MICROCODESIZE(d) = (x);                      \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_MICROCODESIZE( d, x )                       \
+#define DRX_GET_MICROCODESIZE(d, x)                       \
    do {                                                     \
-      (x)=DRX_ATTR_MICROCODESIZE(d);                        \
-   } while(0)
+      (x) = DRX_ATTR_MICROCODESIZE(d);                        \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_VERIFYMICROCODE( d, x )                     \
+#define DRX_SET_VERIFYMICROCODE(d, x)                     \
    do {                                                     \
       DRX_ATTR_VERIFYMICROCODE(d) = (x);                    \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_VERIFYMICROCODE( d, x )                     \
+#define DRX_GET_VERIFYMICROCODE(d, x)                     \
    do {                                                     \
-      (x)=DRX_ATTR_VERIFYMICROCODE(d);                      \
-   } while(0)
+      (x) = DRX_ATTR_VERIFYMICROCODE(d);                      \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_MCVERTYPE( d, x )                           \
+#define DRX_SET_MCVERTYPE(d, x)                           \
    do {                                                     \
       DRX_ATTR_MCRECORD(d).auxType = (x);                   \
    } while (0)
 
-#define DRX_GET_MCVERTYPE( d, x )                           \
+#define DRX_GET_MCVERTYPE(d, x)                           \
    do {                                                     \
       (x) = DRX_ATTR_MCRECORD(d).auxType;                   \
    } while (0)
@@ -2578,278 +2578,278 @@ Access macros
 
 /**************************/
 
-#define DRX_SET_MCDEV( d, x )                               \
+#define DRX_SET_MCDEV(d, x)                               \
    do {                                                     \
       DRX_ATTR_MCRECORD(d).mcDevType = (x);                 \
    } while (0)
 
-#define DRX_GET_MCDEV( d, x )                               \
+#define DRX_GET_MCDEV(d, x)                               \
    do {                                                     \
       (x) = DRX_ATTR_MCRECORD(d).mcDevType;                 \
    } while (0)
 
 /**************************/
 
-#define DRX_SET_MCVERSION( d, x )                           \
+#define DRX_SET_MCVERSION(d, x)                           \
    do {                                                     \
       DRX_ATTR_MCRECORD(d).mcVersion = (x);                 \
    } while (0)
 
-#define DRX_GET_MCVERSION( d, x )                           \
+#define DRX_GET_MCVERSION(d, x)                           \
    do {                                                     \
       (x) = DRX_ATTR_MCRECORD(d).mcVersion;                 \
    } while (0)
 
 /**************************/
-#define DRX_SET_MCPATCH( d, x )                             \
+#define DRX_SET_MCPATCH(d, x)                             \
    do {                                                     \
       DRX_ATTR_MCRECORD(d).mcBaseVersion = (x);             \
    } while (0)
 
-#define DRX_GET_MCPATCH( d, x )                             \
+#define DRX_GET_MCPATCH(d, x)                             \
    do {                                                     \
       (x) = DRX_ATTR_MCRECORD(d).mcBaseVersion;             \
    } while (0)
 
 /**************************/
 
-#define DRX_SET_I2CADDR( d, x )                             \
+#define DRX_SET_I2CADDR(d, x)                             \
    do {                                                     \
       DRX_ATTR_I2CADDR(d) = (x);                            \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_I2CADDR( d, x )                             \
+#define DRX_GET_I2CADDR(d, x)                             \
    do {                                                     \
-      (x)=DRX_ATTR_I2CADDR(d);                              \
-   } while(0)
+      (x) = DRX_ATTR_I2CADDR(d);                              \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_I2CDEVID( d, x )                            \
+#define DRX_SET_I2CDEVID(d, x)                            \
    do {                                                     \
       DRX_ATTR_I2CDEVID(d) = (x);                           \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_I2CDEVID( d, x )                            \
+#define DRX_GET_I2CDEVID(d, x)                            \
    do {                                                     \
-      (x)=DRX_ATTR_I2CDEVID(d);                             \
-   } while(0)
+      (x) = DRX_ATTR_I2CDEVID(d);                             \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_USEBOOTLOADER( d, x )                       \
+#define DRX_SET_USEBOOTLOADER(d, x)                       \
    do {                                                     \
       DRX_ATTR_USEBOOTLOADER(d) = (x);                      \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_USEBOOTLOADER( d, x)                        \
+#define DRX_GET_USEBOOTLOADER(d, x)                        \
    do {                                                     \
-      (x)=DRX_ATTR_USEBOOTLOADER(d);                        \
-   } while(0)
+      (x) = DRX_ATTR_USEBOOTLOADER(d);                        \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_CURRENTSTANDARD( d, x )                     \
+#define DRX_SET_CURRENTSTANDARD(d, x)                     \
    do {                                                     \
       DRX_ATTR_CURRENTSTANDARD(d) = (x);                    \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_CURRENTSTANDARD( d, x)                      \
+#define DRX_GET_CURRENTSTANDARD(d, x)                      \
    do {                                                     \
-      (x)=DRX_ATTR_CURRENTSTANDARD(d);                      \
-   } while(0)
+      (x) = DRX_ATTR_CURRENTSTANDARD(d);                      \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_PREVSTANDARD( d, x )                        \
+#define DRX_SET_PREVSTANDARD(d, x)                        \
    do {                                                     \
       DRX_ATTR_PREVSTANDARD(d) = (x);                       \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_PREVSTANDARD( d, x)                         \
+#define DRX_GET_PREVSTANDARD(d, x)                         \
    do {                                                     \
-      (x)=DRX_ATTR_PREVSTANDARD(d);                         \
-   } while(0)
+      (x) = DRX_ATTR_PREVSTANDARD(d);                         \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_CACHESTANDARD( d, x )                       \
+#define DRX_SET_CACHESTANDARD(d, x)                       \
    do {                                                     \
       DRX_ATTR_CACHESTANDARD(d) = (x);                      \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_CACHESTANDARD( d, x)                        \
+#define DRX_GET_CACHESTANDARD(d, x)                        \
    do {                                                     \
-      (x)=DRX_ATTR_CACHESTANDARD(d);                        \
-   } while(0)
+      (x) = DRX_ATTR_CACHESTANDARD(d);                        \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_CURRENTCHANNEL( d, x )                      \
+#define DRX_SET_CURRENTCHANNEL(d, x)                      \
    do {                                                     \
       DRX_ATTR_CURRENTCHANNEL(d) = (x);                     \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_CURRENTCHANNEL( d, x)                       \
+#define DRX_GET_CURRENTCHANNEL(d, x)                       \
    do {                                                     \
-      (x)=DRX_ATTR_CURRENTCHANNEL(d);                       \
-   } while(0)
+      (x) = DRX_ATTR_CURRENTCHANNEL(d);                       \
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_ISOPENED( d, x )                            \
+#define DRX_SET_ISOPENED(d, x)                            \
    do {                                                     \
       DRX_ATTR_ISOPENED(d) = (x);                           \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_ISOPENED( d, x)                             \
+#define DRX_GET_ISOPENED(d, x)                             \
    do {                                                     \
       (x) = DRX_ATTR_ISOPENED(d);                           \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_TUNER( d, x )                               \
+#define DRX_SET_TUNER(d, x)                               \
    do {                                                     \
       DRX_ATTR_TUNER(d) = (x);                              \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_TUNER( d, x)                                \
+#define DRX_GET_TUNER(d, x)                                \
    do {                                                     \
       (x) = DRX_ATTR_TUNER(d);                              \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_CAPABILITIES( d, x )                        \
+#define DRX_SET_CAPABILITIES(d, x)                        \
    do {                                                     \
       DRX_ATTR_CAPABILITIES(d) = (x);                       \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_CAPABILITIES( d, x)                         \
+#define DRX_GET_CAPABILITIES(d, x)                         \
    do {                                                     \
       (x) = DRX_ATTR_CAPABILITIES(d);                       \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_PRODUCTID( d, x )                           \
+#define DRX_SET_PRODUCTID(d, x)                           \
    do {                                                     \
       DRX_ATTR_PRODUCTID(d) |= (x << 4);                    \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_PRODUCTID( d, x)                            \
+#define DRX_GET_PRODUCTID(d, x)                            \
    do {                                                     \
       (x) = (DRX_ATTR_PRODUCTID(d) >> 4);                   \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_MFX( d, x )                                 \
+#define DRX_SET_MFX(d, x)                                 \
    do {                                                     \
       DRX_ATTR_PRODUCTID(d) |= (x);                         \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_MFX( d, x)                                  \
+#define DRX_GET_MFX(d, x)                                  \
    do {                                                     \
       (x) = (DRX_ATTR_PRODUCTID(d) & 0xF);                  \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_INTERMEDIATEFREQ( d, x )                    \
+#define DRX_SET_INTERMEDIATEFREQ(d, x)                    \
    do {                                                     \
       DRX_ATTR_INTERMEDIATEFREQ(d) = (x);                   \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_INTERMEDIATEFREQ( d, x)                     \
+#define DRX_GET_INTERMEDIATEFREQ(d, x)                     \
    do {                                                     \
       (x) = DRX_ATTR_INTERMEDIATEFREQ(d);                   \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_SYSCLOCKFREQ( d, x )                        \
+#define DRX_SET_SYSCLOCKFREQ(d, x)                        \
    do {                                                     \
       DRX_ATTR_SYSCLOCKFREQ(d) = (x);                       \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_SYSCLOCKFREQ( d, x)                         \
+#define DRX_GET_SYSCLOCKFREQ(d, x)                         \
    do {                                                     \
       (x) = DRX_ATTR_SYSCLOCKFREQ(d);                       \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_TUNERRFAGCPOL( d, x )                       \
+#define DRX_SET_TUNERRFAGCPOL(d, x)                       \
    do {                                                     \
       DRX_ATTR_TUNERRFAGCPOL(d) = (x);                      \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_TUNERRFAGCPOL( d, x)                        \
+#define DRX_GET_TUNERRFAGCPOL(d, x)                        \
    do {                                                     \
       (x) = DRX_ATTR_TUNERRFAGCPOL(d);                      \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_TUNERIFAGCPOL( d, x )                       \
+#define DRX_SET_TUNERIFAGCPOL(d, x)                       \
    do {                                                     \
       DRX_ATTR_TUNERIFAGCPOL(d) = (x);                      \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_TUNERIFAGCPOL( d, x)                        \
+#define DRX_GET_TUNERIFAGCPOL(d, x)                        \
    do {                                                     \
       (x) = DRX_ATTR_TUNERIFAGCPOL(d);                      \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_TUNERSLOWMODE( d, x )                       \
+#define DRX_SET_TUNERSLOWMODE(d, x)                       \
    do {                                                     \
       DRX_ATTR_TUNERSLOWMODE(d) = (x);                      \
-   } while(0)
+   } while (0)
 
-#define DRX_GET_TUNERSLOWMODE( d, x)                        \
+#define DRX_GET_TUNERSLOWMODE(d, x)                        \
    do {                                                     \
       (x) = DRX_ATTR_TUNERSLOWMODE(d);                      \
-   } while(0)
+   } while (0)
 
 /**************************/
 
-#define DRX_SET_TUNERPORTNR( d, x )                         \
+#define DRX_SET_TUNERPORTNR(d, x)                         \
    do {                                                     \
       DRX_ATTR_TUNERSPORTNR(d) = (x);                       \
-   } while(0)
+   } while (0)
 
 /**************************/
 
 /* Macros with device-specific handling are converted to CFG functions */
 
-#define DRX_ACCESSMACRO_SET( demod, value, cfgName, dataType )             \
+#define DRX_ACCESSMACRO_SET(demod, value, cfgName, dataType)             \
    do {                                                                    \
       DRXCfg_t config;                                                     \
       dataType cfgData;                                                    \
       config.cfgType = cfgName;                                            \
       config.cfgData = &cfgData;                                           \
       cfgData = value;                                                     \
-      DRX_Ctrl( demod, DRX_CTRL_SET_CFG, &config );                        \
-   } while ( 0 )
+      DRX_Ctrl(demod, DRX_CTRL_SET_CFG, &config);                        \
+   } while (0)
 
-#define DRX_ACCESSMACRO_GET( demod, value, cfgName, dataType, errorValue ) \
+#define DRX_ACCESSMACRO_GET(demod, value, cfgName, dataType, errorValue) \
    do {                                                                    \
       int cfgStatus;                                               \
       DRXCfg_t    config;                                                  \
       dataType    cfgData;                                                 \
       config.cfgType = cfgName;                                            \
       config.cfgData = &cfgData;                                           \
-      cfgStatus = DRX_Ctrl( demod, DRX_CTRL_GET_CFG, &config );            \
-      if ( cfgStatus == DRX_STS_OK ) {                                     \
+      cfgStatus = DRX_Ctrl(demod, DRX_CTRL_GET_CFG, &config);            \
+      if (cfgStatus == DRX_STS_OK) {                                     \
 	 value = cfgData;                                                  \
       } else {                                                             \
 	 value = (dataType)errorValue;                                     \
       }                                                                    \
-   } while ( 0 )
+   } while (0)
 
 /* Configuration functions for usage by Access (XS) Macros */
 
@@ -2857,63 +2857,63 @@ Access macros
 #define DRX_XS_CFG_BASE (500)
 #endif
 
-#define DRX_XS_CFG_PRESET          ( DRX_XS_CFG_BASE + 0 )
-#define DRX_XS_CFG_AUD_BTSC_DETECT ( DRX_XS_CFG_BASE + 1 )
-#define DRX_XS_CFG_QAM_LOCKRANGE   ( DRX_XS_CFG_BASE + 2 )
+#define DRX_XS_CFG_PRESET          (DRX_XS_CFG_BASE + 0)
+#define DRX_XS_CFG_AUD_BTSC_DETECT (DRX_XS_CFG_BASE + 1)
+#define DRX_XS_CFG_QAM_LOCKRANGE   (DRX_XS_CFG_BASE + 2)
 
 /* Access Macros with device-specific handling */
 
-#define DRX_SET_PRESET( d, x ) \
-   DRX_ACCESSMACRO_SET( (d), (x), DRX_XS_CFG_PRESET, char* )
-#define DRX_GET_PRESET( d, x ) \
-   DRX_ACCESSMACRO_GET( (d), (x), DRX_XS_CFG_PRESET, char*, "ERROR" )
+#define DRX_SET_PRESET(d, x) \
+   DRX_ACCESSMACRO_SET((d), (x), DRX_XS_CFG_PRESET, char*)
+#define DRX_GET_PRESET(d, x) \
+   DRX_ACCESSMACRO_GET((d), (x), DRX_XS_CFG_PRESET, char*, "ERROR")
 
-#define DRX_SET_AUD_BTSC_DETECT( d, x ) DRX_ACCESSMACRO_SET( (d), (x), \
-	 DRX_XS_CFG_AUD_BTSC_DETECT, DRXAudBtscDetect_t )
-#define DRX_GET_AUD_BTSC_DETECT( d, x ) DRX_ACCESSMACRO_GET( (d), (x), \
-	 DRX_XS_CFG_AUD_BTSC_DETECT, DRXAudBtscDetect_t, DRX_UNKNOWN )
+#define DRX_SET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_SET( (d), (x), \
+	 DRX_XS_CFG_AUD_BTSC_DETECT, DRXAudBtscDetect_t)
+#define DRX_GET_AUD_BTSC_DETECT(d, x) DRX_ACCESSMACRO_GET( (d), (x), \
+	 DRX_XS_CFG_AUD_BTSC_DETECT, DRXAudBtscDetect_t, DRX_UNKNOWN)
 
-#define DRX_SET_QAM_LOCKRANGE( d, x ) DRX_ACCESSMACRO_SET( (d), (x), \
-	 DRX_XS_CFG_QAM_LOCKRANGE, DRXQamLockRange_t )
-#define DRX_GET_QAM_LOCKRANGE( d, x ) DRX_ACCESSMACRO_GET( (d), (x), \
-	 DRX_XS_CFG_QAM_LOCKRANGE, DRXQamLockRange_t, DRX_UNKNOWN )
+#define DRX_SET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_SET( (d), (x), \
+	 DRX_XS_CFG_QAM_LOCKRANGE, DRXQamLockRange_t)
+#define DRX_GET_QAM_LOCKRANGE(d, x) DRX_ACCESSMACRO_GET( (d), (x), \
+	 DRX_XS_CFG_QAM_LOCKRANGE, DRXQamLockRange_t, DRX_UNKNOWN)
 
 /**
 * \brief Macro to check if std is an ATV standard
 * \retval true std is an ATV standard
 * \retval false std is an ATV standard
 */
-#define DRX_ISATVSTD( std ) ( ( (std) == DRX_STANDARD_PAL_SECAM_BG ) || \
-			      ( (std) == DRX_STANDARD_PAL_SECAM_DK ) || \
-			      ( (std) == DRX_STANDARD_PAL_SECAM_I  ) || \
-			      ( (std) == DRX_STANDARD_PAL_SECAM_L  ) || \
-			      ( (std) == DRX_STANDARD_PAL_SECAM_LP ) || \
-			      ( (std) == DRX_STANDARD_NTSC ) || \
-			      ( (std) == DRX_STANDARD_FM ) )
+#define DRX_ISATVSTD(std) ( ( (std) == DRX_STANDARD_PAL_SECAM_BG ) || \
+			      ((std) == DRX_STANDARD_PAL_SECAM_DK) || \
+			      ((std) == DRX_STANDARD_PAL_SECAM_I) || \
+			      ((std) == DRX_STANDARD_PAL_SECAM_L) || \
+			      ((std) == DRX_STANDARD_PAL_SECAM_LP) || \
+			      ((std) == DRX_STANDARD_NTSC) || \
+			      ((std) == DRX_STANDARD_FM) )
 
 /**
 * \brief Macro to check if std is an QAM standard
 * \retval true std is an QAM standards
 * \retval false std is an QAM standards
 */
-#define DRX_ISQAMSTD( std ) ( ( (std) == DRX_STANDARD_ITU_A ) || \
-			      ( (std) == DRX_STANDARD_ITU_B ) || \
-			      ( (std) == DRX_STANDARD_ITU_C ) || \
-			      ( (std) == DRX_STANDARD_ITU_D ))
+#define DRX_ISQAMSTD(std) ( ( (std) == DRX_STANDARD_ITU_A ) || \
+			      ((std) == DRX_STANDARD_ITU_B) || \
+			      ((std) == DRX_STANDARD_ITU_C) || \
+			      ((std) == DRX_STANDARD_ITU_D))
 
 /**
 * \brief Macro to check if std is VSB standard
 * \retval true std is VSB standard
 * \retval false std is not VSB standard
 */
-#define DRX_ISVSBSTD( std ) ( (std) == DRX_STANDARD_8VSB )
+#define DRX_ISVSBSTD(std) ( (std) == DRX_STANDARD_8VSB )
 
 /**
 * \brief Macro to check if std is DVBT standard
 * \retval true std is DVBT standard
 * \retval false std is not DVBT standard
 */
-#define DRX_ISDVBTSTD( std ) ( (std) == DRX_STANDARD_DVBT )
+#define DRX_ISDVBTSTD(std) ( (std) == DRX_STANDARD_DVBT )
 
 /*-------------------------------------------------------------------------
 Exported FUNCTIONS
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c13622652bd6..ff99a03efa39 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -170,7 +170,7 @@ INCLUDE FILES
 
 #include "drx_driver_version.h"
 
-//#define DRX_DEBUG
+/* #define DRX_DEBUG */
 #ifdef DRX_DEBUG
 #include <stdio.h>
 #endif
@@ -183,7 +183,7 @@ ENUMS
 DEFINES
 ----------------------------------------------------------------------------*/
 #ifndef DRXJ_WAKE_UP_KEY
-#define DRXJ_WAKE_UP_KEY (demod -> myI2CDevAddr -> i2cAddr)
+#define DRXJ_WAKE_UP_KEY (demod->myI2CDevAddr->i2cAddr)
 #endif
 
 /**
@@ -306,11 +306,11 @@ DEFINES
 #endif
 
 /* ATV config changed flags */
-#define DRXJ_ATV_CHANGED_COEF          ( 0x00000001UL )
-#define DRXJ_ATV_CHANGED_PEAK_FLT      ( 0x00000008UL )
-#define DRXJ_ATV_CHANGED_NOISE_FLT     ( 0x00000010UL )
-#define DRXJ_ATV_CHANGED_OUTPUT        ( 0x00000020UL )
-#define DRXJ_ATV_CHANGED_SIF_ATT       ( 0x00000040UL )
+#define DRXJ_ATV_CHANGED_COEF          (0x00000001UL)
+#define DRXJ_ATV_CHANGED_PEAK_FLT      (0x00000008UL)
+#define DRXJ_ATV_CHANGED_NOISE_FLT     (0x00000010UL)
+#define DRXJ_ATV_CHANGED_OUTPUT        (0x00000020UL)
+#define DRXJ_ATV_CHANGED_SIF_ATT       (0x00000040UL)
 
 /* UIO define */
 #define DRX_UIO_MODE_FIRMWARE_SMA DRX_UIO_MODE_FIRMWARE0
@@ -424,7 +424,7 @@ DEFINES
 /**
 * \brief FM Matrix register fix
 */
-#ifdef  AUD_DEM_WR_FM_MATRIX__A
+#ifdef AUD_DEM_WR_FM_MATRIX__A
 #undef  AUD_DEM_WR_FM_MATRIX__A
 #endif
 #define AUD_DEM_WR_FM_MATRIX__A              0x105006F
@@ -480,63 +480,63 @@ DEFINES
 
 #ifdef DRXJDRIVER_DEBUG
 #include <stdio.h>
-#define CHK_ERROR( s ) \
-	do{ \
-	    if ( (s) != DRX_STS_OK ) \
+#define CHK_ERROR(s) \
+	do { \
+	    if ((s) != DRX_STS_OK) \
 	    { \
 	       fprintf(stderr, \
 		       "ERROR[\n file    : %s\n line    : %d\n]\n", \
-		       __FILE__,__LINE__); \
+		       __FILE__, __LINE__); \
 	       goto rw_error; }; \
 	    } \
 	while (0 != 0)
 #else
-#define CHK_ERROR( s ) \
-   do{ \
-      if ( (s) != DRX_STS_OK ) { goto rw_error; } \
+#define CHK_ERROR(s) \
+   do { \
+      if ((s) != DRX_STS_OK) { goto rw_error; } \
    } while (0 != 0)
 #endif
 
-#define CHK_ZERO( s ) \
-   do{ \
-      if ( (s) == 0 ) return DRX_STS_ERROR; \
+#define CHK_ZERO(s) \
+   do { \
+      if ((s) == 0) return DRX_STS_ERROR; \
    } while (0)
 
 #define DUMMY_READ() \
-   do{ \
+   do { \
       u16 dummy; \
-      RR16( demod->myI2CDevAddr, SCU_RAM_VERSION_HI__A, &dummy ); \
+      RR16(demod->myI2CDevAddr, SCU_RAM_VERSION_HI__A, &dummy); \
    } while (0)
 
-#define WR16( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), 0 ) )
+#define WR16(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP.writeReg16Func( (dev), (addr), (val), 0) )
 
-#define RR16( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP.readReg16Func( (dev), (addr), (val), 0 ) )
+#define RR16(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP.readReg16Func( (dev), (addr), (val), 0) )
 
-#define WR32( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP.writeReg32Func( (dev), (addr), (val), 0 ) )
+#define WR32(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP.writeReg32Func( (dev), (addr), (val), 0) )
 
-#define RR32( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP.readReg32Func( (dev), (addr), (val), 0 ) )
+#define RR32(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP.readReg32Func( (dev), (addr), (val), 0) )
 
-#define WRB( dev, addr, len, block ) \
-   CHK_ERROR( DRXJ_DAP.writeBlockFunc( (dev), (addr), (len), (block), 0 ) )
+#define WRB(dev, addr, len, block) \
+   CHK_ERROR(DRXJ_DAP.writeBlockFunc( (dev), (addr), (len), (block), 0) )
 
-#define RRB( dev, addr, len, block ) \
-   CHK_ERROR( DRXJ_DAP.readBlockFunc( (dev), (addr), (len), (block), 0 ) )
+#define RRB(dev, addr, len, block) \
+   CHK_ERROR(DRXJ_DAP.readBlockFunc( (dev), (addr), (len), (block), 0) )
 
-#define BCWR16( dev, addr, val ) \
-   CHK_ERROR( DRXJ_DAP.writeReg16Func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST ) )
+#define BCWR16(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP.writeReg16Func( (dev), (addr), (val), DRXDAP_FASI_BROADCAST) )
 
-#define ARR32( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP_AtomicReadReg32( (dev), (addr), (val), 0 ) )
+#define ARR32(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP_AtomicReadReg32( (dev), (addr), (val), 0) )
 
-#define SARR16( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP_SCU_AtomicReadReg16( (dev), (addr), (val), 0 ) )
+#define SARR16(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP_SCU_AtomicReadReg16( (dev), (addr), (val), 0) )
 
-#define SAWR16( dev, addr, val) \
-   CHK_ERROR( DRXJ_DAP_SCU_AtomicWriteReg16( (dev), (addr), (val), 0 ) )
+#define SAWR16(dev, addr, val) \
+   CHK_ERROR(DRXJ_DAP_SCU_AtomicWriteReg16( (dev), (addr), (val), 0) )
 
 /**
 * This macro is used to create byte arrays for block writes.
@@ -544,14 +544,14 @@ DEFINES
 * The macro takes care of the required byte order in a 16 bits word.
 * x -> lowbyte(x), highbyte(x)
 */
-#define DRXJ_16TO8( x ) ((u8) (((u16)x)    &0xFF)), \
+#define DRXJ_16TO8(x) ((u8) (((u16)x) & 0xFF)), \
 			((u8)((((u16)x)>>8)&0xFF))
 /**
 * This macro is used to convert byte array to 16 bit register value for block read.
 * Block read speed up I2C traffic between host and demod.
 * The macro takes care of the required byte order in a 16 bits word.
 */
-#define DRXJ_8TO16( x ) ((u16) (x[0] | (x[1] << 8)))
+#define DRXJ_8TO16(x) ((u16) (x[0] | (x[1] << 8)))
 
 /*============================================================================*/
 /*=== MISC DEFINES ===========================================================*/
@@ -570,18 +570,18 @@ DEFINES
 /*=== STANDARD RELATED MACROS ================================================*/
 /*============================================================================*/
 
-#define DRXJ_ISATVSTD( std ) ( ( std == DRX_STANDARD_PAL_SECAM_BG ) || \
-			       ( std == DRX_STANDARD_PAL_SECAM_DK ) || \
-			       ( std == DRX_STANDARD_PAL_SECAM_I  ) || \
-			       ( std == DRX_STANDARD_PAL_SECAM_L  ) || \
-			       ( std == DRX_STANDARD_PAL_SECAM_LP ) || \
-			       ( std == DRX_STANDARD_NTSC ) || \
-			       ( std == DRX_STANDARD_FM ) )
+#define DRXJ_ISATVSTD(std) ( ( std == DRX_STANDARD_PAL_SECAM_BG ) || \
+			       (std == DRX_STANDARD_PAL_SECAM_DK) || \
+			       (std == DRX_STANDARD_PAL_SECAM_I) || \
+			       (std == DRX_STANDARD_PAL_SECAM_L) || \
+			       (std == DRX_STANDARD_PAL_SECAM_LP) || \
+			       (std == DRX_STANDARD_NTSC) || \
+			       (std == DRX_STANDARD_FM) )
 
-#define DRXJ_ISQAMSTD( std ) ( ( std == DRX_STANDARD_ITU_A ) || \
-			       ( std == DRX_STANDARD_ITU_B ) || \
-			       ( std == DRX_STANDARD_ITU_C ) || \
-			       ( std == DRX_STANDARD_ITU_D ))
+#define DRXJ_ISQAMSTD(std) ( ( std == DRX_STANDARD_ITU_A ) || \
+			       (std == DRX_STANDARD_ITU_B) || \
+			       (std == DRX_STANDARD_ITU_C) || \
+			       (std == DRX_STANDARD_ITU_D))
 
 /*-----------------------------------------------------------------------------
 STATIC VARIABLES
@@ -1224,7 +1224,7 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 *
 */
 
-#define DRX_IS_BOOTH_NEGATIVE(__a)  (((__a) & (1 << (sizeof (u32) * 8 - 1))) != 0)
+#define DRX_IS_BOOTH_NEGATIVE(__a)  (((__a) & (1 << (sizeof(u32) * 8 - 1))) != 0)
 
 static void Mult32(u32 a, u32 b, u32 *h, u32 *l)
 {
@@ -1683,7 +1683,7 @@ static const u16 NicamPrescTableVal[43] =
    TODO: check ignoring single/multimaster is ok for AUD access ?
 */
 
-#define DRXJ_ISAUDWRITE( addr ) (((((addr)>>16)&1)==1)?true:false)
+#define DRXJ_ISAUDWRITE(addr) (((((addr)>>16)&1) == 1)?true:false)
 #define DRXJ_DAP_AUDTRIF_TIMEOUT 80	/* millisec */
 /*============================================================================*/
 
@@ -1755,7 +1755,7 @@ static int DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 
 /* TODO correct define should be #if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
    See comments DRXJ_DAP_ReadModifyWriteReg16 */
-#if ( DRXDAPFASI_LONG_ADDR_ALLOWED == 0 )
+#if (DRXDAPFASI_LONG_ADDR_ALLOWED == 0)
 static int DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
 					      DRXaddr_t waddr,
 					      DRXaddr_t raddr,
@@ -1803,7 +1803,7 @@ static int DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 	/* TODO: correct short/long addressing format decision,
 	   now long format has higher prio then short because short also
 	   needs virt bnks (not impl yet) for certain audio registers */
-#if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
+#if (DRXDAPFASI_LONG_ADDR_ALLOWED == 1)
 	return drxDapFASIFunct_g.readModifyWriteReg16Func(devAddr,
 							  waddr,
 							  raddr, wdata, rdata);
@@ -3492,7 +3492,7 @@ static int CtrlGetUIOCfg(pDRXDemodInstance_t demod, pDRXUIOCfg_t UIOCfg)
 
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 	pDRXUIOMode_t UIOMode[4] = { NULL };
-	bool * UIOAvailable[4] = { NULL };
+	bool *UIOAvailable[4] = { NULL };
 
 	extAttr = demod->myExtAttr;
 
@@ -3823,7 +3823,7 @@ rw_error:
 
 */
 static int
-CtrlI2CBridge(pDRXDemodInstance_t demod, bool * bridgeClosed)
+CtrlI2CBridge(pDRXDemodInstance_t demod, bool *bridgeClosed)
 {
 	DRXJHiCmd_t hiCmd;
 	u16 result = 0;
@@ -3908,7 +3908,7 @@ CtrlSetCfgSmartAnt(pDRXDemodInstance_t demod, pDRXJCfgSmartAnt_t smartAnt)
 	struct i2c_device_addr *devAddr = NULL;
 	u16 data = 0;
 	u32 startTime = 0;
-	static bool bitInverted = false;
+	static bool bitInverted;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -4356,7 +4356,7 @@ CtrlSetCfgATVOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg);
 * \return int.
 */
 static int
-CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enable)
+CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool *enable)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
@@ -4482,7 +4482,7 @@ rw_error:
 * \return int.
 */
 static int
-CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool * enabled)
+CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, bool *enabled)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
@@ -4926,8 +4926,8 @@ rw_error:
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
 static int GetAccPktErr(pDRXDemodInstance_t demod, u16 *packetErr)
 {
-	static u16 pktErr = 0;
-	static u16 lastPktErr = 0;
+	static u16 pktErr;
+	static u16 lastPktErr;
 	u16 data = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
@@ -5046,7 +5046,7 @@ static int GetCTLFreqOffset(pDRXDemodInstance_t demod, s32 *CTLFreq)
 
 	/* both registers are sign extended */
 	nominalFrequency = extAttr->iqmFsRateOfs;
-	ARR32(devAddr, IQM_FS_RATE_LO__A, (u32 *) & currentFrequency);
+	ARR32(devAddr, IQM_FS_RATE_LO__A, (u32 *) &currentFrequency);
 
 	if (extAttr->posImage == true) {
 		/* negative image */
@@ -6174,7 +6174,7 @@ rw_error:
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static int GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, u32 * ber)
+static int GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
 {
 	u16 data = 0;
 
@@ -8108,7 +8108,7 @@ CtrlGetQAMConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 	WR16(devAddr, QAM_SL_COMM_MB__A, qamSlCommMb);
 
 	/* Enable MB grabber in the FEC OC */
-	fecOcOcrMode = (	/* output select:  observe bus */
+	fecOcOcrMode = (/* output select:  observe bus */
 			       (FEC_OC_OCR_MODE_MB_SELECT__M &
 				(0x0 << FEC_OC_OCR_MODE_MB_SELECT__B)) |
 			       /* grabber enable: on          */
@@ -8451,10 +8451,10 @@ CtrlSetCfgAtvEquCoef(pDRXDemodInstance_t demod, pDRXJCfgAtvEquCoef_t coef)
 	    (coef->coef1 > (ATV_TOP_EQU1_EQU_C1__M / 2)) ||
 	    (coef->coef2 > (ATV_TOP_EQU2_EQU_C2__M / 2)) ||
 	    (coef->coef3 > (ATV_TOP_EQU3_EQU_C3__M / 2)) ||
-	    (coef->coef0 < ((s16) ~ (ATV_TOP_EQU0_EQU_C0__M >> 1))) ||
-	    (coef->coef1 < ((s16) ~ (ATV_TOP_EQU1_EQU_C1__M >> 1))) ||
-	    (coef->coef2 < ((s16) ~ (ATV_TOP_EQU2_EQU_C2__M >> 1))) ||
-	    (coef->coef3 < ((s16) ~ (ATV_TOP_EQU3_EQU_C3__M >> 1)))) {
+	    (coef->coef0 < ((s16) ~(ATV_TOP_EQU0_EQU_C0__M >> 1))) ||
+	    (coef->coef1 < ((s16) ~(ATV_TOP_EQU1_EQU_C1__M >> 1))) ||
+	    (coef->coef2 < ((s16) ~(ATV_TOP_EQU2_EQU_C2__M >> 1))) ||
+	    (coef->coef3 < ((s16) ~(ATV_TOP_EQU3_EQU_C3__M >> 1)))) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
@@ -10231,7 +10231,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	RR16(devAddr, AUD_DSP_WR_VOLUME__A, &wVolume);
 
 	/* clear the volume mask */
-	wVolume &= (u16) ~ AUD_DSP_WR_VOLUME_VOL_MAIN__M;
+	wVolume &= (u16) ~AUD_DSP_WR_VOLUME_VOL_MAIN__M;
 	if (volume->mute == true) {
 		/* mute */
 		/* mute overrules volume */
@@ -10248,8 +10248,8 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	RR16(devAddr, AUD_DSP_WR_AVC__A, &wAVC);
 
 	/* clear masks that require writing */
-	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_ON__M;
-	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_DECAY__M;
+	wAVC &= (u16) ~AUD_DSP_WR_AVC_AVC_ON__M;
+	wAVC &= (u16) ~AUD_DSP_WR_AVC_AVC_DECAY__M;
 
 	if (volume->avcMode == DRX_AUD_AVC_OFF) {
 		wAVC |= (AUD_DSP_WR_AVC_AVC_ON_OFF);
@@ -10277,7 +10277,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	}
 
 	/* max attenuation */
-	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_MAX_ATT__M;
+	wAVC &= (u16) ~AUD_DSP_WR_AVC_AVC_MAX_ATT__M;
 	switch (volume->avcMaxAtten) {
 	case DRX_AUD_AVC_MAX_ATTEN_12DB:
 		wAVC |= AUD_DSP_WR_AVC_AVC_MAX_ATT_12DB;
@@ -10293,7 +10293,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	}
 
 	/* max gain */
-	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_MAX_GAIN__M;
+	wAVC &= (u16) ~AUD_DSP_WR_AVC_AVC_MAX_GAIN__M;
 	switch (volume->avcMaxGain) {
 	case DRX_AUD_AVC_MAX_GAIN_0DB:
 		wAVC |= AUD_DSP_WR_AVC_AVC_MAX_GAIN_0DB;
@@ -10313,7 +10313,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_REF_LEV__M;
+	wAVC &= (u16) ~AUD_DSP_WR_AVC_AVC_REF_LEV__M;
 	wAVC |= (u16) (volume->avcRefLevel << AUD_DSP_WR_AVC_AVC_REF_LEV__B);
 
 	WR16(devAddr, AUD_DSP_WR_AVC__A, wAVC);
@@ -10465,7 +10465,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	RR16(devAddr, AUD_DEM_RAM_I2S_CONFIG2__A, &wI2SConfig);
 
 	/* I2S mode */
-	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_SLV_MST__M;
+	wI2SConfig &= (u16) ~AUD_DEM_WR_I2S_CONFIG2_I2S_SLV_MST__M;
 
 	switch (output->mode) {
 	case DRX_I2S_MODE_MASTER:
@@ -10479,7 +10479,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S format */
-	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_MODE__M;
+	wI2SConfig &= (u16) ~AUD_DEM_WR_I2S_CONFIG2_I2S_WS_MODE__M;
 
 	switch (output->format) {
 	case DRX_I2S_FORMAT_WS_ADVANCED:
@@ -10493,7 +10493,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S word length */
-	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WORD_LEN__M;
+	wI2SConfig &= (u16) ~AUD_DEM_WR_I2S_CONFIG2_I2S_WORD_LEN__M;
 
 	switch (output->wordLength) {
 	case DRX_I2S_WORDLENGTH_16:
@@ -10507,7 +10507,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S polarity */
-	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL__M;
+	wI2SConfig &= (u16) ~AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL__M;
 	switch (output->polarity) {
 	case DRX_I2S_POLARITY_LEFT:
 		wI2SConfig |= AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL_LEFT_HIGH;
@@ -10520,7 +10520,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S output enabled */
-	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
+	wI2SConfig &= (u16) ~AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
 	if (output->outputEnable == true) {
 		wI2SConfig |= AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE;
 	} else {
@@ -10676,8 +10676,8 @@ AUDCtrSetlCfgAutoSound(pDRXDemodInstance_t demod,
 
 	wModus = rModus;
 	/* clear ASS & ASC bits */
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_ASS__M;
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_ASS__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG__M;
 
 	switch (*autoSound) {
 	case DRX_AUD_AUTO_SOUND_OFF:
@@ -10936,7 +10936,7 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	CHK_ERROR(AUDGetModus(demod, &rModus));
 
 	wModus = rModus;
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_CM_A__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_CM_A__M;
 	/* Behaviour of primary audio channel */
 	switch (carriers->a.opt) {
 	case DRX_NO_CARRIER_MUTE:
@@ -10951,7 +10951,7 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	}
 
 	/* Behaviour of secondary audio channel */
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_CM_B__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_CM_B__M;
 	switch (carriers->b.opt) {
 	case DRX_NO_CARRIER_MUTE:
 		wModus |= AUD_DEM_WR_MODUS_MOD_CM_B_MUTE;
@@ -11122,7 +11122,7 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 
 	/* Source Selctor */
 	RR16(devAddr, AUD_DSP_WR_SRC_I2S_MATR__A, &srcI2SMatr);
-	srcI2SMatr &= (u16) ~ AUD_DSP_WR_SRC_I2S_MATR_SRC_I2S__M;
+	srcI2SMatr &= (u16) ~AUD_DSP_WR_SRC_I2S_MATR_SRC_I2S__M;
 
 	switch (mixer->sourceI2S) {
 	case DRX_AUD_SRC_MONO:
@@ -11142,7 +11142,7 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 	}
 
 	/* Matrix */
-	srcI2SMatr &= (u16) ~ AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S__M;
+	srcI2SMatr &= (u16) ~AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S__M;
 	switch (mixer->matrixI2S) {
 	case DRX_AUD_I2S_MATRIX_MONO:
 		srcI2SMatr |= AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S_MONO;
@@ -11164,7 +11164,7 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 
 	/* FM Matrix */
 	RR16(devAddr, AUD_DEM_WR_FM_MATRIX__A, &fmMatr);
-	fmMatr &= (u16) ~ AUD_DEM_WR_FM_MATRIX__M;
+	fmMatr &= (u16) ~AUD_DEM_WR_FM_MATRIX__M;
 	switch (mixer->matrixFm) {
 	case DRX_AUD_FM_MATRIX_NO_MATRIX:
 		fmMatr |= AUD_DEM_WR_FM_MATRIX_NO_MATRIX;
@@ -11230,7 +11230,7 @@ AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 	/* audio/video synchronisation */
 	RR16(devAddr, AUD_DSP_WR_AV_SYNC__A, &wAudVidSync);
 
-	wAudVidSync &= (u16) ~ AUD_DSP_WR_AV_SYNC_AV_ON__M;
+	wAudVidSync &= (u16) ~AUD_DSP_WR_AV_SYNC_AV_ON__M;
 
 	if (*avSync == DRX_AUD_AVSYNC_OFF) {
 		wAudVidSync |= AUD_DSP_WR_AV_SYNC_AV_ON_DISABLE;
@@ -11238,7 +11238,7 @@ AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 		wAudVidSync |= AUD_DSP_WR_AV_SYNC_AV_ON_ENABLE;
 	}
 
-	wAudVidSync &= (u16) ~ AUD_DSP_WR_AV_SYNC_AV_STD_SEL__M;
+	wAudVidSync &= (u16) ~AUD_DSP_WR_AV_SYNC_AV_STD_SEL__M;
 
 	switch (*avSync) {
 	case DRX_AUD_AVSYNC_NTSC:
@@ -11389,7 +11389,7 @@ AUDCtrlSetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 
 	wModus = rModus;
 
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_HDEV_A__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_HDEV_A__M;
 
 	switch (*dev) {
 	case DRX_AUD_DEVIATION_NORMAL:
@@ -11745,7 +11745,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 		/* we need the current standard here */
 		currentStandard = extAttr->standard;
 
-		wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_6_5MHZ__M;
+		wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_6_5MHZ__M;
 
 		if ((currentStandard == DRX_STANDARD_PAL_SECAM_L) ||
 		    (currentStandard == DRX_STANDARD_PAL_SECAM_LP)) {
@@ -11754,7 +11754,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 			wModus |= (AUD_DEM_WR_MODUS_MOD_6_5MHZ_D_K);
 		}
 
-		wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_4_5MHZ__M;
+		wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_4_5MHZ__M;
 		if (currentStandard == DRX_STANDARD_NTSC) {
 			wModus |= (AUD_DEM_WR_MODUS_MOD_4_5MHZ_M_BTSC);
 
@@ -11765,7 +11765,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 
 	}
 
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_FMRADIO__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_FMRADIO__M;
 
 	/* just get hardcoded deemphasis and activate here */
 	if (extAttr->audData.deemph == DRX_AUD_FM_DEEMPH_50US) {
@@ -11774,7 +11774,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 		wModus |= (AUD_DEM_WR_MODUS_MOD_FMRADIO_US_75U);
 	}
 
-	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_BTSC__M;
+	wModus &= (u16) ~AUD_DEM_WR_MODUS_MOD_BTSC__M;
 	if (extAttr->audData.btscDetect == DRX_BTSC_STEREO) {
 		wModus |= (AUD_DEM_WR_MODUS_MOD_BTSC_BTSC_STEREO);
 	} else {		/* DRX_BTSC_MONO_AND_SAP */
@@ -12464,9 +12464,9 @@ rw_error:
 */
 
 /* Nyquist filter impulse response */
-#define IMPULSE_COSINE_ALPHA_0_3    {-3,-4,-1, 6,10, 7,-5,-20,-25,-10,29,79,123,140}	/*sqrt raised-cosine filter with alpha=0.3 */
-#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0,-2,-2, 2, 5, 2,-10,-20,-14,20,74,125,145}	/*sqrt raised-cosine filter with alpha=0.5 */
-#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0,-7,-15,-16,  0,34,77,114,128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
+#define IMPULSE_COSINE_ALPHA_0_3    {-3, -4, -1, 6, 10, 7, -5, -20, -25, -10, 29, 79, 123, 140}	/*sqrt raised-cosine filter with alpha=0.3 */
+#define IMPULSE_COSINE_ALPHA_0_5    { 2, 0, -2, -2, 2, 5, 2, -10, -20, -14, 20, 74, 125, 145}	/*sqrt raised-cosine filter with alpha=0.5 */
+#define IMPULSE_COSINE_ALPHA_RO_0_5 { 0, 0, 1, 2, 3, 0, -7, -15, -16,  0, 34, 77, 114, 128}	/*full raised-cosine filter with alpha=0.5 (receiver only) */
 
 /* Coefficients for the nyquist fitler (total: 27 taps) */
 #define NYQFILTERLEN 27
@@ -14122,7 +14122,7 @@ rw_error:
 *
 */
 static int
-CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
+CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t *versionList)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index 47a0e3cc5b4b..15b2bb065468 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -53,7 +53,7 @@ extern "C" {
 /* Multi master mode and short addr format only will not work.
    RMW, CRC reset, broadcast and switching back to single master mode
    cannot be done with short addr only in multi master mode. */
-#if ((DRXDAP_SINGLE_MASTER==0)&&(DRXDAPFASI_LONG_ADDR_ALLOWED==0))
+#if ((DRXDAP_SINGLE_MASTER == 0) && (DRXDAPFASI_LONG_ADDR_ALLOWED == 0))
 #error "Multi master mode and short addressing only is an illegal combination"
 	*;			/* Generate a fatal compiler error to make sure it stops here,
 				   this is necesarry because not all compilers stop after a #error. */
@@ -590,7 +590,7 @@ Access MACROS
 *
 */
 
-#define DRXJ_ATTR_BTSC_DETECT( d )                       \
+#define DRXJ_ATTR_BTSC_DETECT(d)                       \
 			(((pDRXJData_t)(d)->myExtAttr)->audData.btscDetect)
 
 /**
@@ -604,15 +604,15 @@ Access MACROS
 * substituted by "direct-access-inline-code" or a function call.
 *
 */
-#define DRXJ_GET_BTSC_DETECT( d, x )                     \
+#define DRXJ_GET_BTSC_DETECT(d, x)                     \
    do {                                                  \
-      (x) = DRXJ_ATTR_BTSC_DETECT(( d );                 \
-   } while(0)
+      (x) = DRXJ_ATTR_BTSC_DETECT((d);                 \
+   } while (0)
 
-#define DRXJ_SET_BTSC_DETECT( d, x )                     \
+#define DRXJ_SET_BTSC_DETECT(d, x)                     \
    do {                                                  \
-      DRXJ_ATTR_BTSC_DETECT( d ) = (x);                  \
-   } while(0)
+      DRXJ_ATTR_BTSC_DETECT(d) = (x);                  \
+   } while (0)
 
 /*-------------------------------------------------------------------------
 DEFINES
@@ -704,12 +704,12 @@ DEFINES
 
 /* Convert OOB lock status to string */
 #define DRXJ_STR_OOB_LOCKSTATUS(x) ( \
-   ( x == DRX_NEVER_LOCK               )  ?  "Never"           : \
-   ( x == DRX_NOT_LOCKED               )  ?  "No"              : \
-   ( x == DRX_LOCKED                   )  ?  "Locked"          : \
-   ( x == DRX_LOCK_STATE_1             )  ?  "AGC lock"        : \
-   ( x == DRX_LOCK_STATE_2             )  ?  "sync lock"       : \
-					     "(Invalid)" )
+   (x == DRX_NEVER_LOCK)  ?  "Never"           : \
+   (x == DRX_NOT_LOCKED)  ?  "No"              : \
+   (x == DRX_LOCKED)  ?  "Locked"          : \
+   (x == DRX_LOCK_STATE_1)  ?  "AGC lock"        : \
+   (x == DRX_LOCK_STATE_2)  ?  "sync lock"       : \
+					     "(Invalid)")
 
 /*-------------------------------------------------------------------------
 ENUM
-- 
1.8.5.3

