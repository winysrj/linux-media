Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101AbaCCKIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:09 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 08/79] [media] drx-j: get rid of the integer typedefs
Date: Mon,  3 Mar 2014 07:06:02 -0300
Message-Id: <1393841233-24840-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Patch created using this small script:

for j in 8 16 32; do for i in *; do sed s,pu${j}_t,"u$j *",g <$i >a && mv a $i; done; done
for j in 8 16 32; do for i in *; do sed s,ps${j}_t,"s$j *",g <$i >a && mv a $i; done; done
for j in 8 16 32; do for i in *; do sed s,s${j}_t,"s$j",g <$i >a && mv a $i; done; done
for j in 8 16 32; do for i in *; do sed s,u${j}_t,"u$j",g <$i >a && mv a $i; done; done

and fixing the bsp_types.h header.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_host.h    |    8 +-
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     |   16 +-
 drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h   |   24 +-
 drivers/media/dvb-frontends/drx39xyj/bsp_types.h   |   98 +-
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |   14 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  164 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |  164 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  194 +--
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 1616 ++++++++++----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |  142 +-
 drivers/media/dvb-frontends/drx39xyj/drxj_mc.h     |    4 +-
 drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h |    4 +-
 .../media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h  |    4 +-
 13 files changed, 1182 insertions(+), 1270 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_host.h b/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
index 5a2dd5f969df..0ce94df98107 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_host.h
@@ -61,13 +61,13 @@ Exported FUNCTIONS
 
 	DRXStatus_t DRXBSP_HST_Term(void);
 
-	void *DRXBSP_HST_Memcpy(void *to, void *from, u32_t n);
+	void *DRXBSP_HST_Memcpy(void *to, void *from, u32 n);
 
-	int DRXBSP_HST_Memcmp(void *s1, void *s2, u32_t n);
+	int DRXBSP_HST_Memcmp(void *s1, void *s2, u32 n);
 
-	u32_t DRXBSP_HST_Clock(void);
+	u32 DRXBSP_HST_Clock(void);
 
-	DRXStatus_t DRXBSP_HST_Sleep(u32_t n);
+	DRXStatus_t DRXBSP_HST_Sleep(u32 n);
 
 /*-------------------------------------------------------------------------
 THE END
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
index ec2467b2c2a5..64ebef340a70 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
@@ -42,8 +42,6 @@
 *
 */
 
-#include <linux/kernel.h>
-
 #ifndef __BSPI2C_H__
 #define __BSPI2C_H__
 
@@ -95,11 +93,11 @@ Exported FUNCTIONS
 
 /**
 * \fn DRXStatus_t DRXBSP_I2C_WriteRead( struct i2c_device_addr *wDevAddr,
-*                                       u16_t wCount,
-*                                       pu8_t wData,
+*                                       u16 wCount,
+*                                       u8 *wData,
 *                                       struct i2c_device_addr *rDevAddr,
-*                                       u16_t rCount,
-*                                       pu8_t rData)
+*                                       u16 rCount,
+*                                       u8 *rData)
 * \brief Read and/or write count bytes from I2C bus, store them in data[].
 * \param wDevAddr The device i2c address and the device ID to write to
 * \param wCount   The number of bytes to write
@@ -124,10 +122,10 @@ Exported FUNCTIONS
 * It can be used to control a "switch" on the I2C bus to the correct device.
 */
 	DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
-					 u16_t wCount,
-					 pu8_t wData,
+					 u16 wCount,
+					 u8 *wData,
 					 struct i2c_device_addr *rDevAddr,
-					 u16_t rCount, pu8_t rData);
+					 u16 rCount, u8 *rData);
 
 /**
 * \fn DRXBSP_I2C_ErrorText()
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
index 1491358eba25..12676de6aafa 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
@@ -79,8 +79,8 @@ DEFINES
 TYPEDEFS
 ------------------------------------------------------------------------------*/
 
-	typedef u32_t TUNERMode_t;
-	typedef pu32_t pTUNERMode_t;
+	typedef u32 TUNERMode_t;
+	typedef u32 *pTUNERMode_t;
 
 	typedef char *TUNERSubMode_t;	/* description of submode */
 	typedef TUNERSubMode_t *pTUNERSubMode_t;
@@ -97,9 +97,9 @@ TYPEDEFS
 		DRXFrequency_t minFreqRF;	/* Lowest  RF input frequency, in kHz */
 		DRXFrequency_t maxFreqRF;	/* Highest RF input frequency, in kHz */
 
-		u8_t subMode;	/* Index to sub-mode in use */
+		u8 subMode;	/* Index to sub-mode in use */
 		pTUNERSubMode_t subModeDescriptions;	/* Pointer to description of sub-modes */
-		u8_t subModes;	/* Number of available sub-modes      */
+		u8 subModes;	/* Number of available sub-modes      */
 
 		/* The following fields will be either 0, NULL or FALSE and do not need
 		   initialisation */
@@ -109,7 +109,7 @@ TYPEDEFS
 		DRXFrequency_t IFfrequency;	/* only valid if programmed       */
 
 		void *myUserData;	/* pointer to associated demod instance */
-		u16_t myCapabilities;	/* value for storing application flags  */
+		u16 myCapabilities;	/* value for storing application flags  */
 
 	} TUNERCommonAttr_t, *pTUNERCommonAttr_t;
 
@@ -139,11 +139,11 @@ TYPEDEFS
 
 	typedef DRXStatus_t(*TUNERi2cWriteReadFunc_t) (pTUNERInstance_t tuner,
 						       struct i2c_device_addr *
-						       wDevAddr, u16_t wCount,
-						       pu8_t wData,
+						       wDevAddr, u16 wCount,
+						       u8 *wData,
 						       struct i2c_device_addr *
-						       rDevAddr, u16_t rCount,
-						       pu8_t rData);
+						       rDevAddr, u16 rCount,
+						       u8 *rData);
 
 	typedef struct {
 		TUNEROpenFunc_t openFunc;
@@ -194,10 +194,10 @@ Exported FUNCTIONS
 
 	DRXStatus_t DRXBSP_TUNER_DefaultI2CWriteRead(pTUNERInstance_t tuner,
 						     struct i2c_device_addr *wDevAddr,
-						     u16_t wCount,
-						     pu8_t wData,
+						     u16 wCount,
+						     u8 *wData,
 						     struct i2c_device_addr *rDevAddr,
-						     u16_t rCount, pu8_t rData);
+						     u16 rCount, u8 *rData);
 
 /*------------------------------------------------------------------------------
 THE END
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
index e10a79beda36..2f5a2ba9ba2f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_types.h
@@ -39,6 +39,8 @@
 *
 */
 
+#include <linux/kernel.h>
+
 #ifndef __BSP_TYPES_H__
 #define __BSP_TYPES_H__
 /*-------------------------------------------------------------------------
@@ -53,98 +55,10 @@ TYPEDEFS
 -------------------------------------------------------------------------*/
 
 /**
-* \typedef unsigned char u8_t
-* \brief type definition of an unsigned 8 bits integer
-*/
-	typedef unsigned char u8_t;
-/**
-* \typedef char s8_t
-* \brief type definition of a signed 8 bits integer
-*/
-	typedef char s8_t;
-/**
-* \typedef unsigned short u16_t *pu16_t
-* \brief type definition of an unsigned 16 bits integer
-*/
-	typedef unsigned short u16_t;
-/**
-* \typedef short s16_t
-* \brief type definition of a signed 16 bits integer
-*/
-	typedef short s16_t;
-/**
-* \typedef unsigned long u32_t
-* \brief type definition of an unsigned 32 bits integer
-*/
-	typedef unsigned long u32_t;
-/**
-* \typedef long s32_t
-* \brief type definition of a signed 32 bits integer
-*/
-	typedef long s32_t;
-/*
-* \typedef struct ... u64_t
-* \brief type definition of an usigned 64 bits integer
-*/
-	typedef struct {
-		u32_t MSLW;
-		u32_t LSLW;
-	} u64_t;
-/*
-* \typedef struct ... i64_t
-* \brief type definition of a signed 64 bits integer
-*/
-	typedef struct {
-		s32_t MSLW;
-		u32_t LSLW;
-	} s64_t;
-
-/**
-* \typedef u8_t *pu8_t
-* \brief type definition of pointer to an unsigned 8 bits integer
-*/
-	typedef u8_t *pu8_t;
-/**
-* \typedef s8_t *ps8_t
-* \brief type definition of pointer to a signed 8 bits integer
-*/
-	typedef s8_t *ps8_t;
-/**
-* \typedef u16_t *pu16_t
-* \brief type definition of pointer to an unsigned 16 bits integer
-*/
-	typedef u16_t *pu16_t;
-/**
-* \typedef s16_t *ps16_t
-* \brief type definition of pointer to a signed 16 bits integer
-*/
-	typedef s16_t *ps16_t;
-/**
-* \typedef u32_t *pu32_t
-* \brief type definition of pointer to an unsigned 32 bits integer
-*/
-	typedef u32_t *pu32_t;
-/**
-* \typedef s32_t *ps32_t
-* \brief type definition of pointer to a signed 32 bits integer
-*/
-	typedef s32_t *ps32_t;
-/**
-* \typedef u64_t *pu64_t
-* \brief type definition of pointer to an usigned 64 bits integer
-*/
-	typedef u64_t *pu64_t;
-/**
-* \typedef s64_t *ps64_t
-* \brief type definition of pointer to a signed 64 bits integer
-*/
-	typedef s64_t *ps64_t;
-
-/**
-* \typedef s32_t DRXFrequency_t
+* \typedef s32 DRXFrequency_t
 * \brief type definition of frequency
 */
-	typedef s32_t DRXFrequency_t;
+	typedef s32 DRXFrequency_t;
 
 /**
 * \typedef DRXFrequency_t *pDRXFrequency_t
@@ -153,10 +67,10 @@ TYPEDEFS
 	typedef DRXFrequency_t *pDRXFrequency_t;
 
 /**
-* \typedef u32_t DRXSymbolrate_t
+* \typedef u32 DRXSymbolrate_t
 * \brief type definition of symbol rate
 */
-	typedef u32_t DRXSymbolrate_t;
+	typedef u32 DRXSymbolrate_t;
 
 /**
 * \typedef DRXSymbolrate_t *pDRXSymbolrate_t
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 73fa63afc5f6..35cef0f46934 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -39,32 +39,32 @@ DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
 	return DRX_STS_OK;
 }
 
-DRXStatus_t DRXBSP_HST_Sleep(u32_t n)
+DRXStatus_t DRXBSP_HST_Sleep(u32 n)
 {
 	msleep(n);
 	return DRX_STS_OK;
 }
 
-u32_t DRXBSP_HST_Clock(void)
+u32 DRXBSP_HST_Clock(void)
 {
 	return jiffies_to_msecs(jiffies);
 }
 
-int DRXBSP_HST_Memcmp(void *s1, void *s2, u32_t n)
+int DRXBSP_HST_Memcmp(void *s1, void *s2, u32 n)
 {
 	return (memcmp(s1, s2, (size_t) n));
 }
 
-void *DRXBSP_HST_Memcpy(void *to, void *from, u32_t n)
+void *DRXBSP_HST_Memcpy(void *to, void *from, u32 n)
 {
 	return (memcpy(to, from, (size_t) n));
 }
 
 DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
-				 u16_t wCount,
-				 pu8_t wData,
+				 u16 wCount,
+				 u8 *wData,
 				 struct i2c_device_addr *rDevAddr,
-				 u16_t rCount, pu8_t rData)
+				 u16 rCount, u8 *rData)
 {
 	struct drx39xxj_state *state;
 	struct i2c_msg msg[2];
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index 472581e1c5dc..5bf4771a4c49 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -57,63 +57,63 @@
 /* Function prototypes */
 static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register/memory   */
-					  u16_t datasize,	/* size of data                 */
-					  pu8_t data,	/* data to send                 */
+					  u16 datasize,	/* size of data                 */
+					  u8 *data,	/* data to send                 */
 					  DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register/memory   */
-					 u16_t datasize,	/* size of data                 */
-					 pu8_t data,	/* data to send                 */
+					 u16 datasize,	/* size of data                 */
+					 u8 *data,	/* data to send                 */
 					 DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
-					 u8_t data,	/* data to write                */
+					 u8 data,	/* data to write                */
 					 DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					DRXaddr_t addr,	/* address of register          */
-					pu8_t data,	/* buffer to receive data       */
+					u8 *data,	/* buffer to receive data       */
 					DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t waddr,	/* address of register          */
 						   DRXaddr_t raddr,	/* address to read back from    */
-						   u8_t datain,	/* data to send                 */
-						   pu8_t dataout);	/* data to receive back         */
+						   u8 datain,	/* data to send                 */
+						   u8 *dataout);	/* data to receive back         */
 
 static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register          */
-					  u16_t data,	/* data to write                */
+					  u16 data,	/* data to write                */
 					  DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
-					 pu16_t data,	/* buffer to receive data       */
+					 u16 *data,	/* buffer to receive data       */
 					 DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
-						    u16_t datain,	/* data to send                 */
-						    pu16_t dataout);	/* data to receive back         */
+						    u16 datain,	/* data to send                 */
+						    u16 *dataout);	/* data to receive back         */
 
 static DRXStatus_t DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register          */
-					  u32_t data,	/* data to write                */
+					  u32 data,	/* data to write                */
 					  DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
-					 pu32_t data,	/* buffer to receive data       */
+					 u32 *data,	/* buffer to receive data       */
 					 DRXflags_t flags);	/* special device flags         */
 
 static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
-						    u32_t datain,	/* data to send                 */
-						    pu32_t dataout);	/* data to receive back         */
+						    u32 datain,	/* data to send                 */
+						    u32 *dataout);	/* data to receive back         */
 
 /* The version structure of this protocol implementation */
 char drxDapFASIModuleName[] = "FASI Data Access Protocol";
@@ -151,7 +151,7 @@ DRXAccessFunc_t drxDapFASIFunct_g = {
 
 static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
-					 u8_t data,	/* data to write                */
+					 u8 data,	/* data to write                */
 					 DRXflags_t flags)
 {				/* special device flags         */
 	return DRX_STS_ERROR;
@@ -159,7 +159,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* add
 
 static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					DRXaddr_t addr,	/* address of register          */
-					pu8_t data,	/* buffer to receive data       */
+					u8 *data,	/* buffer to receive data       */
 					DRXflags_t flags)
 {				/* special device flags         */
 	return DRX_STS_ERROR;
@@ -168,8 +168,8 @@ static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* addr
 static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t waddr,	/* address of register          */
 						   DRXaddr_t raddr,	/* address to read back from    */
-						   u8_t datain,	/* data to send                 */
-						   pu8_t dataout)
+						   u8 datain,	/* data to send                 */
+						   u8 *dataout)
 {				/* data to receive back         */
 	return DRX_STS_ERROR;
 }
@@ -177,8 +177,8 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAd
 static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
-						    u32_t datain,	/* data to send                 */
-						    pu32_t dataout)
+						    u32 datain,	/* data to send                 */
+						    u32 *dataout)
 {				/* data to receive back         */
 	return DRX_STS_ERROR;
 }
@@ -190,8 +190,8 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devA
 * DRXStatus_t DRXDAP_FASI_ReadBlock (
 *      struct i2c_device_addr *devAddr,      -- address of I2C device
 *      DRXaddr_t        addr,         -- address of chip register/memory
-*      u16_t            datasize,     -- number of bytes to read
-*      pu8_t            data,         -- data to receive
+*      u16            datasize,     -- number of bytes to read
+*      u8 *data,         -- data to receive
 *      DRXflags_t       flags)        -- special device flags
 *
 * Read block data from chip address. Because the chip is word oriented,
@@ -212,13 +212,13 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devA
 
 static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
-					 u16_t datasize,
-					 pu8_t data, DRXflags_t flags)
+					 u16 datasize,
+					 u8 *data, DRXflags_t flags)
 {
-	u8_t buf[4];
-	u16_t bufx;
+	u8 buf[4];
+	u16 bufx;
 	DRXStatus_t rc;
-	u16_t overheadSize = 0;
+	u16 overheadSize = 0;
 
 	/* Check parameters ******************************************************* */
 	if (devAddr == NULL) {
@@ -244,7 +244,7 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 
 	/* Read block from I2C **************************************************** */
 	do {
-		u16_t todo = (datasize < DRXDAP_MAX_RCHUNKSIZE ?
+		u16 todo = (datasize < DRXDAP_MAX_RCHUNKSIZE ?
 			      datasize : DRXDAP_MAX_RCHUNKSIZE);
 
 		bufx = 0;
@@ -258,19 +258,19 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
 #if ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 )
-			buf[bufx++] = (u8_t) (((addr << 1) & 0xFF) | 0x01);
-			buf[bufx++] = (u8_t) ((addr >> 16) & 0xFF);
-			buf[bufx++] = (u8_t) ((addr >> 24) & 0xFF);
-			buf[bufx++] = (u8_t) ((addr >> 7) & 0xFF);
+			buf[bufx++] = (u8) (((addr << 1) & 0xFF) | 0x01);
+			buf[bufx++] = (u8) ((addr >> 16) & 0xFF);
+			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
+			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
 #if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
       ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 ) )
 		} else {
 #endif
 #if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
-			buf[bufx++] = (u8_t) ((addr << 1) & 0xFF);
+			buf[bufx++] = (u8) ((addr << 1) & 0xFF);
 			buf[bufx++] =
-			    (u8_t) (((addr >> 16) & 0x0F) |
+			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
 #if ( ( DRXDAPFASI_LONG_ADDR_ALLOWED==1 ) && \
@@ -306,8 +306,8 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 *      struct i2c_device_addr *devAddr,   -- address of I2C device
 *      DRXaddr_t        waddr,     -- address of chip register/memory
 *      DRXaddr_t        raddr,     -- chip address to read back from
-*      u16_t            wdata,     -- data to send
-*      pu16_t           rdata)     -- data to receive back
+*      u16            wdata,     -- data to send
+*      u16 *rdata)     -- data to receive back
 *
 * Write 16-bit data, then read back the original contents of that location.
 * Requires long addressing format to be allowed.
@@ -328,7 +328,7 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						    DRXaddr_t waddr,
 						    DRXaddr_t raddr,
-						    u16_t wdata, pu16_t rdata)
+						    u16 wdata, u16 *rdata)
 {
 	DRXStatus_t rc = DRX_STS_ERROR;
 
@@ -351,7 +351,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devA
 * DRXStatus_t DRXDAP_FASI_ReadReg16 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
-*     pu16_t           data,    -- data to receive
+*     u16 *data,    -- data to receive
 *     DRXflags_t       flags)   -- special device flags
 *
 * Read one 16-bit register or memory location. The data received back is
@@ -366,16 +366,16 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devA
 
 static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
-					 pu16_t data, DRXflags_t flags)
+					 u16 *data, DRXflags_t flags)
 {
-	u8_t buf[sizeof(*data)];
+	u8 buf[sizeof(*data)];
 	DRXStatus_t rc;
 
 	if (!data) {
 		return DRX_STS_INVALID_ARG;
 	}
 	rc = DRXDAP_FASI_ReadBlock(devAddr, addr, sizeof(*data), buf, flags);
-	*data = buf[0] + (((u16_t) buf[1]) << 8);
+	*data = buf[0] + (((u16) buf[1]) << 8);
 	return rc;
 }
 
@@ -384,7 +384,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 * DRXStatus_t DRXDAP_FASI_ReadReg32 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
-*     pu32_t           data,    -- data to receive
+*     u32 *data,    -- data to receive
 *     DRXflags_t       flags)   -- special device flags
 *
 * Read one 32-bit register or memory location. The data received back is
@@ -399,18 +399,18 @@ static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
-					 pu32_t data, DRXflags_t flags)
+					 u32 *data, DRXflags_t flags)
 {
-	u8_t buf[sizeof(*data)];
+	u8 buf[sizeof(*data)];
 	DRXStatus_t rc;
 
 	if (!data) {
 		return DRX_STS_INVALID_ARG;
 	}
 	rc = DRXDAP_FASI_ReadBlock(devAddr, addr, sizeof(*data), buf, flags);
-	*data = (((u32_t) buf[0]) << 0) +
-	    (((u32_t) buf[1]) << 8) +
-	    (((u32_t) buf[2]) << 16) + (((u32_t) buf[3]) << 24);
+	*data = (((u32) buf[0]) << 0) +
+	    (((u32) buf[1]) << 8) +
+	    (((u32) buf[2]) << 16) + (((u32) buf[3]) << 24);
 	return rc;
 }
 
@@ -419,8 +419,8 @@ static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 * DRXStatus_t DRXDAP_FASI_WriteBlock (
 *      struct i2c_device_addr *devAddr,    -- address of I2C device
 *      DRXaddr_t        addr,       -- address of chip register/memory
-*      u16_t            datasize,   -- number of bytes to read
-*      pu8_t            data,       -- data to receive
+*      u16            datasize,   -- number of bytes to read
+*      u8 *data,       -- data to receive
 *      DRXflags_t       flags)      -- special device flags
 *
 * Write block data to chip address. Because the chip is word oriented,
@@ -438,14 +438,14 @@ static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
-					  u16_t datasize,
-					  pu8_t data, DRXflags_t flags)
+					  u16 datasize,
+					  u8 *data, DRXflags_t flags)
 {
-	u8_t buf[DRXDAP_MAX_WCHUNKSIZE];
+	u8 buf[DRXDAP_MAX_WCHUNKSIZE];
 	DRXStatus_t st = DRX_STS_ERROR;
 	DRXStatus_t firstErr = DRX_STS_OK;
-	u16_t overheadSize = 0;
-	u16_t blockSize = 0;
+	u16 overheadSize = 0;
+	u16 blockSize = 0;
 
 	/* Check parameters ******************************************************* */
 	if (devAddr == NULL) {
@@ -472,8 +472,8 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 	/* Write block to I2C ***************************************************** */
 	blockSize = ((DRXDAP_MAX_WCHUNKSIZE) - overheadSize) & ~1;
 	do {
-		u16_t todo = 0;
-		u16_t bufx = 0;
+		u16 todo = 0;
+		u16 bufx = 0;
 
 		/* Buffer device address */
 		addr &= ~DRXDAP_FASI_FLAGS;
@@ -484,19 +484,19 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 		if (DRXDAP_FASI_LONG_FORMAT(addr)) {
 #endif
 #if ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 )
-			buf[bufx++] = (u8_t) (((addr << 1) & 0xFF) | 0x01);
-			buf[bufx++] = (u8_t) ((addr >> 16) & 0xFF);
-			buf[bufx++] = (u8_t) ((addr >> 24) & 0xFF);
-			buf[bufx++] = (u8_t) ((addr >> 7) & 0xFF);
+			buf[bufx++] = (u8) (((addr << 1) & 0xFF) | 0x01);
+			buf[bufx++] = (u8) ((addr >> 16) & 0xFF);
+			buf[bufx++] = (u8) ((addr >> 24) & 0xFF);
+			buf[bufx++] = (u8) ((addr >> 7) & 0xFF);
 #endif
 #if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
       ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 ) )
 		} else {
 #endif
 #if ( (DRXDAPFASI_SHORT_ADDR_ALLOWED)==1 )
-			buf[bufx++] = (u8_t) ((addr << 1) & 0xFF);
+			buf[bufx++] = (u8) ((addr << 1) & 0xFF);
 			buf[bufx++] =
-			    (u8_t) (((addr >> 16) & 0x0F) |
+			    (u8) (((addr >> 16) & 0x0F) |
 				    ((addr >> 18) & 0xF0));
 #endif
 #if ( ( (DRXDAPFASI_LONG_ADDR_ALLOWED)==1 ) && \
@@ -514,8 +514,8 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 		 */
 		todo = (blockSize < datasize ? blockSize : datasize);
 		if (todo == 0) {
-			u16_t overheadSizeI2cAddr = 0;
-			u16_t dataBlockSize = 0;
+			u16 overheadSizeI2cAddr = 0;
+			u16 dataBlockSize = 0;
 
 			overheadSizeI2cAddr =
 			    (IS_I2C_10BIT(devAddr->i2cAddr) ? 2 : 1);
@@ -524,10 +524,10 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 
 			/* write device address */
 			st = DRXBSP_I2C_WriteRead(devAddr,
-						  (u16_t) (bufx),
+						  (u16) (bufx),
 						  buf,
 						  (struct i2c_device_addr *) (NULL),
-						  0, (pu8_t) (NULL));
+						  0, (u8 *) (NULL));
 
 			if ((st != DRX_STS_OK) && (firstErr == DRX_STS_OK)) {
 				/* at the end, return the first error encountered */
@@ -541,10 +541,10 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 		DRXBSP_HST_Memcpy(&buf[bufx], data, todo);
 		/* write (address if can do and) data */
 		st = DRXBSP_I2C_WriteRead(devAddr,
-					  (u16_t) (bufx + todo),
+					  (u16) (bufx + todo),
 					  buf,
 					  (struct i2c_device_addr *) (NULL),
-					  0, (pu8_t) (NULL));
+					  0, (u8 *) (NULL));
 
 		if ((st != DRX_STS_OK) && (firstErr == DRX_STS_OK)) {
 			/* at the end, return the first error encountered */
@@ -563,7 +563,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 * DRXStatus_t DRXDAP_FASI_WriteReg16 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
-*     u16_t            data,    -- data to send
+*     u16            data,    -- data to send
 *     DRXflags_t       flags)   -- special device flags
 *
 * Write one 16-bit register or memory location. The data being written is
@@ -577,12 +577,12 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
-					  u16_t data, DRXflags_t flags)
+					  u16 data, DRXflags_t flags)
 {
-	u8_t buf[sizeof(data)];
+	u8 buf[sizeof(data)];
 
-	buf[0] = (u8_t) ((data >> 0) & 0xFF);
-	buf[1] = (u8_t) ((data >> 8) & 0xFF);
+	buf[0] = (u8) ((data >> 0) & 0xFF);
+	buf[1] = (u8) ((data >> 8) & 0xFF);
 
 	return DRXDAP_FASI_WriteBlock(devAddr, addr, sizeof(data), buf, flags);
 }
@@ -592,7 +592,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 * DRXStatus_t DRXDAP_FASI_WriteReg32 (
 *     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
-*     u32_t            data,    -- data to send
+*     u32            data,    -- data to send
 *     DRXflags_t       flags)   -- special device flags
 *
 * Write one 32-bit register or memory location. The data being written is
@@ -606,14 +606,14 @@ static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
-					  u32_t data, DRXflags_t flags)
+					  u32 data, DRXflags_t flags)
 {
-	u8_t buf[sizeof(data)];
+	u8 buf[sizeof(data)];
 
-	buf[0] = (u8_t) ((data >> 0) & 0xFF);
-	buf[1] = (u8_t) ((data >> 8) & 0xFF);
-	buf[2] = (u8_t) ((data >> 16) & 0xFF);
-	buf[3] = (u8_t) ((data >> 24) & 0xFF);
+	buf[0] = (u8) ((data >> 0) & 0xFF);
+	buf[1] = (u8) ((data >> 8) & 0xFF);
+	buf[2] = (u8) ((data >> 16) & 0xFF);
+	buf[3] = (u8) ((data >> 24) & 0xFF);
 
 	return DRXDAP_FASI_WriteBlock(devAddr, addr, sizeof(data), buf, flags);
 }
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 3a782d6f0bb5..ea43f14936b0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -60,7 +60,7 @@ DEFINES
 
 /** \brief Magic word for checking correct Endianess of microcode data. */
 #ifndef DRX_UCODE_MAGIC_WORD
-#define DRX_UCODE_MAGIC_WORD         ((((u16_t)'H')<<8)+((u16_t)'L'))
+#define DRX_UCODE_MAGIC_WORD         ((((u16)'H')<<8)+((u16)'L'))
 #endif
 
 /** \brief CRC flag in ucode header, flags field. */
@@ -119,17 +119,17 @@ STRUCTURES
 ------------------------------------------------------------------------------*/
 /** \brief  Structure of the microcode block headers */
 typedef struct {
-	u32_t addr;
+	u32 addr;
 		  /**<  Destination address of the data in this block */
-	u16_t size;
+	u16 size;
 		  /**<  Size of the block data following this header counted in
 			16 bits words */
-	u16_t flags;
+	u16 flags;
 		  /**<  Flags for this data block:
 			- bit[0]= CRC on/off
 			- bit[1]= compression on/off
 			- bit[15..2]=reserved */
-	u16_t CRC;/**<  CRC value of the data block, only valid if CRC flag is
+	u16 CRC;/**<  CRC value of the data block, only valid if CRC flag is
 			set. */
 } DRXUCodeBlockHdr_t, *pDRXUCodeBlockHdr_t;
 
@@ -217,13 +217,13 @@ static DRXStatus_t ScanWaitForLock(pDRXDemodInstance_t demod, pBool_t isLocked)
 	Bool_t doneWaiting = FALSE;
 	DRXLockStatus_t lockState = DRX_NOT_LOCKED;
 	DRXLockStatus_t desiredLockState = DRX_NOT_LOCKED;
-	u32_t timeoutValue = 0;
-	u32_t startTimeLockStage = 0;
-	u32_t currentTime = 0;
-	u32_t timerValue = 0;
+	u32 timeoutValue = 0;
+	u32 startTimeLockStage = 0;
+	u32 currentTime = 0;
+	u32 timerValue = 0;
 
 	*isLocked = FALSE;
-	timeoutValue = (u32_t) demod->myCommonAttr->scanDemodLockTimeout;
+	timeoutValue = (u32) demod->myCommonAttr->scanDemodLockTimeout;
 	desiredLockState = demod->myCommonAttr->scanDesiredLock;
 	startTimeLockStage = DRXBSP_HST_Clock();
 
@@ -277,8 +277,8 @@ static DRXStatus_t
 ScanPrepareNextScan(pDRXDemodInstance_t demod, DRXFrequency_t skip)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	u16_t tableIndex = 0;
-	u16_t frequencyPlanSize = 0;
+	u16 tableIndex = 0;
+	u16 frequencyPlanSize = 0;
 	pDRXFrequencyPlan_t frequencyPlan = (pDRXFrequencyPlan_t) (NULL);
 	DRXFrequency_t nextFrequency = 0;
 	DRXFrequency_t tunerMinFrequency = 0;
@@ -419,8 +419,8 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	DRXFrequency_t maxTunerFreq = 0;
 	DRXFrequency_t minTunerFreq = 0;
-	u16_t nrChannelsInPlan = 0;
-	u16_t i = 0;
+	u16 nrChannelsInPlan = 0;
+	u16 i = 0;
 	void *scanContext = NULL;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
@@ -509,7 +509,7 @@ CtrlScanInit(pDRXDemodInstance_t demod, pDRXScanParam_t scanParam)
 		   in this frequency plan. */
 		if ((minFreq != 0) && (maxFreq != 0)) {
 			nrChannelsInPlan +=
-			    (u16_t) (((maxFreq - minFreq) / step) + 1);
+			    (u16) (((maxFreq - minFreq) / step) + 1);
 
 			/* Determine first frequency (within tuner range) to scan */
 			if (commonAttr->scanNextFrequency == 0) {
@@ -602,13 +602,13 @@ static DRXStatus_t CtrlScanStop(pDRXDemodInstance_t demod)
 * Progress indication will run from 0 upto DRX_SCAN_MAX_PROGRESS during scan.
 *
 */
-static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, pu16_t scanProgress)
+static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, u16 *scanProgress)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	pBool_t scanReady = (pBool_t) (NULL);
-	u16_t maxProgress = DRX_SCAN_MAX_PROGRESS;
-	u32_t numTries = 0;
-	u32_t i = 0;
+	u16 maxProgress = DRX_SCAN_MAX_PROGRESS;
+	u32 numTries = 0;
+	u32 i = 0;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 
@@ -627,8 +627,8 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, pu16_t scanProgress)
 		return DRX_STS_ERROR;
 	}
 
-	*scanProgress = (u16_t) (((commonAttr->scanChannelsScanned) *
-				  ((u32_t) (maxProgress))) /
+	*scanProgress = (u16) (((commonAttr->scanChannelsScanned) *
+				  ((u32) (maxProgress))) /
 				 (commonAttr->scanMaxChannels));
 
 	/* Scan */
@@ -683,8 +683,8 @@ static DRXStatus_t CtrlScanNext(pDRXDemodInstance_t demod, pu16_t scanProgress)
 
 			/* keep track of progress */
 			*scanProgress =
-			    (u16_t) (((commonAttr->scanChannelsScanned) *
-				      ((u32_t) (maxProgress))) /
+			    (u16) (((commonAttr->scanChannelsScanned) *
+				      ((u32) (maxProgress))) /
 				     (commonAttr->scanMaxChannels));
 
 			if (nextStatus != DRX_STS_OK) {
@@ -843,7 +843,7 @@ CtrlProgramTuner(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 DRXStatus_t CtrlDumpRegisters(pDRXDemodInstance_t demod,
 			      pDRXRegDump_t registers)
 {
-	u16_t i = 0;
+	u16 i = 0;
 
 	if (registers == NULL) {
 		/* registers not supplied */
@@ -853,20 +853,20 @@ DRXStatus_t CtrlDumpRegisters(pDRXDemodInstance_t demod,
 	/* start dumping registers */
 	while (registers[i].address != 0) {
 		DRXStatus_t status = DRX_STS_ERROR;
-		u16_t value = 0;
-		u32_t data = 0;
+		u16 value = 0;
+		u32 data = 0;
 
 		status =
 		    demod->myAccessFunct->readReg16Func(demod->myI2CDevAddr,
 							registers[i].address,
 							&value, 0);
 
-		data = (u32_t) value;
+		data = (u32) value;
 
 		if (status != DRX_STS_OK) {
 			/* no breakouts;
 			   depending on device ID, some HW blocks might not be available */
-			data |= ((u32_t) status) << 16;
+			data |= ((u32) status) << 16;
 		}
 		registers[i].data = data;
 		i++;
@@ -885,21 +885,21 @@ DRXStatus_t CtrlDumpRegisters(pDRXDemodInstance_t demod,
 /**
 * \brief Read a 16 bits word, expects big endian data.
 * \param addr: Pointer to memory from which to read the 16 bits word.
-* \return u16_t The data read.
+* \return u16 The data read.
 *
 * This function takes care of the possible difference in endianness between the
 * host and the data contained in the microcode image file.
 *
 */
-static u16_t UCodeRead16(pu8_t addr)
+static u16 UCodeRead16(u8 *addr)
 {
 	/* Works fo any host processor */
 
-	u16_t word = 0;
+	u16 word = 0;
 
-	word = ((u16_t) addr[0]);
+	word = ((u16) addr[0]);
 	word <<= 8;
-	word |= ((u16_t) addr[1]);
+	word |= ((u16) addr[1]);
 
 	return word;
 }
@@ -909,25 +909,25 @@ static u16_t UCodeRead16(pu8_t addr)
 /**
 * \brief Read a 32 bits word, expects big endian data.
 * \param addr: Pointer to memory from which to read the 32 bits word.
-* \return u32_t The data read.
+* \return u32 The data read.
 *
 * This function takes care of the possible difference in endianness between the
 * host and the data contained in the microcode image file.
 *
 */
-static u32_t UCodeRead32(pu8_t addr)
+static u32 UCodeRead32(u8 *addr)
 {
 	/* Works fo any host processor */
 
-	u32_t word = 0;
+	u32 word = 0;
 
-	word = ((u16_t) addr[0]);
+	word = ((u16) addr[0]);
 	word <<= 8;
-	word |= ((u16_t) addr[1]);
+	word |= ((u16) addr[1]);
 	word <<= 8;
-	word |= ((u16_t) addr[2]);
+	word |= ((u16) addr[2]);
 	word <<= 8;
-	word |= ((u16_t) addr[3]);
+	word |= ((u16) addr[3]);
 
 	return word;
 }
@@ -938,17 +938,17 @@ static u32_t UCodeRead32(pu8_t addr)
 * \brief Compute CRC of block of microcode data.
 * \param blockData: Pointer to microcode data.
 * \param nrWords:   Size of microcode block (number of 16 bits words).
-* \return u16_t The computed CRC residu.
+* \return u16 The computed CRC residu.
 */
-static u16_t UCodeComputeCRC(pu8_t blockData, u16_t nrWords)
+static u16 UCodeComputeCRC(u8 *blockData, u16 nrWords)
 {
-	u16_t i = 0;
-	u16_t j = 0;
-	u32_t CRCWord = 0;
-	u32_t carry = 0;
+	u16 i = 0;
+	u16 j = 0;
+	u32 CRCWord = 0;
+	u32 carry = 0;
 
 	while (i < nrWords) {
-		CRCWord |= (u32_t) UCodeRead16(blockData);
+		CRCWord |= (u32) UCodeRead16(blockData);
 		for (j = 0; j < 16; j++) {
 			CRCWord <<= 1;
 			if (carry != 0) {
@@ -957,9 +957,9 @@ static u16_t UCodeComputeCRC(pu8_t blockData, u16_t nrWords)
 			carry = CRCWord & 0x80000000UL;
 		}
 		i++;
-		blockData += (sizeof(u16_t));
+		blockData += (sizeof(u16));
 	}
-	return ((u16_t) (CRCWord >> 16));
+	return ((u16) (CRCWord >> 16));
 }
 
 /*============================================================================*/
@@ -987,10 +987,10 @@ CtrlUCode(pDRXDemodInstance_t demod,
 	  pDRXUCodeInfo_t mcInfo, DRXUCodeAction_t action)
 {
 	DRXStatus_t rc;
-	u16_t i = 0;
-	u16_t mcNrOfBlks = 0;
-	u16_t mcMagicWord = 0;
-	pu8_t mcData = (pu8_t) (NULL);
+	u16 i = 0;
+	u16 mcNrOfBlks = 0;
+	u16 mcMagicWord = 0;
+	u8 *mcData = (u8 *) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 
 	devAddr = demod->myI2CDevAddr;
@@ -1004,9 +1004,9 @@ CtrlUCode(pDRXDemodInstance_t demod,
 
 	/* Check data */
 	mcMagicWord = UCodeRead16(mcData);
-	mcData += sizeof(u16_t);
+	mcData += sizeof(u16);
 	mcNrOfBlks = UCodeRead16(mcData);
-	mcData += sizeof(u16_t);
+	mcData += sizeof(u16);
 
 	if ((mcMagicWord != DRX_UCODE_MAGIC_WORD) || (mcNrOfBlks == 0)) {
 		/* wrong endianess or wrong data ? */
@@ -1025,35 +1025,35 @@ CtrlUCode(pDRXDemodInstance_t demod,
 
 			/* Process block header */
 			blockHdr.addr = UCodeRead32(mcData);
-			mcData += sizeof(u32_t);
+			mcData += sizeof(u32);
 			blockHdr.size = UCodeRead16(mcData);
-			mcData += sizeof(u16_t);
+			mcData += sizeof(u16);
 			blockHdr.flags = UCodeRead16(mcData);
-			mcData += sizeof(u16_t);
+			mcData += sizeof(u16);
 			blockHdr.CRC = UCodeRead16(mcData);
-			mcData += sizeof(u16_t);
+			mcData += sizeof(u16);
 
 			if (blockHdr.flags & 0x8) {
 				/* Aux block. Check type */
-				pu8_t auxblk = mcInfo->mcData + blockHdr.addr;
-				u16_t auxtype = UCodeRead16(auxblk);
+				u8 *auxblk = mcInfo->mcData + blockHdr.addr;
+				u16 auxtype = UCodeRead16(auxblk);
 				if (DRX_ISMCVERTYPE(auxtype)) {
 					DRX_SET_MCVERTYPE(demod,
 							  UCodeRead16(auxblk));
-					auxblk += sizeof(u16_t);
+					auxblk += sizeof(u16);
 					DRX_SET_MCDEV(demod,
 						      UCodeRead32(auxblk));
-					auxblk += sizeof(u32_t);
+					auxblk += sizeof(u32);
 					DRX_SET_MCVERSION(demod,
 							  UCodeRead32(auxblk));
-					auxblk += sizeof(u32_t);
+					auxblk += sizeof(u32);
 					DRX_SET_MCPATCH(demod,
 							UCodeRead32(auxblk));
 				}
 			}
 
 			/* Next block */
-			mcData += blockHdr.size * sizeof(u16_t);
+			mcData += blockHdr.size * sizeof(u16);
 		}
 
 		/* After scanning, validate the microcode.
@@ -1065,23 +1065,23 @@ CtrlUCode(pDRXDemodInstance_t demod,
 		}
 
 		/* Restore data pointer */
-		mcData = mcInfo->mcData + 2 * sizeof(u16_t);
+		mcData = mcInfo->mcData + 2 * sizeof(u16);
 	}
 
 	/* Process microcode blocks */
 	for (i = 0; i < mcNrOfBlks; i++) {
 		DRXUCodeBlockHdr_t blockHdr;
-		u16_t mcBlockNrBytes = 0;
+		u16 mcBlockNrBytes = 0;
 
 		/* Process block header */
 		blockHdr.addr = UCodeRead32(mcData);
-		mcData += sizeof(u32_t);
+		mcData += sizeof(u32);
 		blockHdr.size = UCodeRead16(mcData);
-		mcData += sizeof(u16_t);
+		mcData += sizeof(u16);
 		blockHdr.flags = UCodeRead16(mcData);
-		mcData += sizeof(u16_t);
+		mcData += sizeof(u16);
 		blockHdr.CRC = UCodeRead16(mcData);
-		mcData += sizeof(u16_t);
+		mcData += sizeof(u16);
 
 		/* Check block header on:
 		   - data larger than 64Kb
@@ -1095,7 +1095,7 @@ CtrlUCode(pDRXDemodInstance_t demod,
 			return DRX_STS_INVALID_ARG;
 		}
 
-		mcBlockNrBytes = blockHdr.size * ((u16_t) sizeof(u16_t));
+		mcBlockNrBytes = blockHdr.size * ((u16) sizeof(u16));
 
 		if (blockHdr.size != 0) {
 			/* Perform the desired action */
@@ -1120,12 +1120,12 @@ CtrlUCode(pDRXDemodInstance_t demod,
 			case UCODE_VERIFY:
 				{
 					int result = 0;
-					u8_t mcDataBuffer
+					u8 mcDataBuffer
 					    [DRX_UCODE_MAX_BUF_SIZE];
-					u32_t bytesToCompare = 0;
-					u32_t bytesLeftToCompare = 0;
+					u32 bytesToCompare = 0;
+					u32 bytesLeftToCompare = 0;
 					DRXaddr_t currAddr = (DRXaddr_t) 0;
-					pu8_t currPtr = NULL;
+					u8 *currPtr = NULL;
 
 					bytesLeftToCompare = mcBlockNrBytes;
 					currAddr = blockHdr.addr;
@@ -1133,10 +1133,10 @@ CtrlUCode(pDRXDemodInstance_t demod,
 
 					while (bytesLeftToCompare != 0) {
 						if (bytesLeftToCompare >
-						    ((u32_t)
+						    ((u32)
 						     DRX_UCODE_MAX_BUF_SIZE)) {
 							bytesToCompare =
-							    ((u32_t)
+							    ((u32)
 							     DRX_UCODE_MAX_BUF_SIZE);
 						} else {
 							bytesToCompare =
@@ -1146,9 +1146,9 @@ CtrlUCode(pDRXDemodInstance_t demod,
 						if (demod->myAccessFunct->
 						    readBlockFunc(devAddr,
 								  currAddr,
-								  (u16_t)
+								  (u16)
 								  bytesToCompare,
-								  (pu8_t)
+								  (u8 *)
 								  mcDataBuffer,
 								  0x0000) !=
 						    DRX_STS_OK) {
@@ -1170,7 +1170,7 @@ CtrlUCode(pDRXDemodInstance_t demod,
 						currPtr =
 						    &(currPtr[bytesToCompare]);
 						bytesLeftToCompare -=
-						    ((u32_t) bytesToCompare);
+						    ((u32) bytesToCompare);
 					}	/* while( bytesToCompare > DRX_UCODE_MAX_BUF_SIZE ) */
 				};
 				break;
@@ -1464,7 +1464,7 @@ DRX_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
 	 /*===================================================================*/
 		case DRX_CTRL_SCAN_NEXT:
 			{
-				return CtrlScanNext(demod, (pu16_t) ctrlData);
+				return CtrlScanNext(demod, (u16 *) ctrlData);
 			}
 			break;
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index c88c064c3ab8..8f0f2edbb733 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -262,20 +262,20 @@ MACROS
 * The macro takes care of the required byte order in a 16 bits word.
 * x->lowbyte(x), highbyte(x)
 */
-#define DRX_16TO8( x ) ((u8_t) (((u16_t)x)    &0xFF)), \
-			((u8_t)((((u16_t)x)>>8)&0xFF))
+#define DRX_16TO8( x ) ((u8) (((u16)x)    &0xFF)), \
+			((u8)((((u16)x)>>8)&0xFF))
 
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S9TOS16(x) ((((u16_t)x)&0x100 )?((s16_t)((u16_t)(x)|0xFF00)):(x))
+#define DRX_S9TOS16(x) ((((u16)x)&0x100 )?((s16)((u16)(x)|0xFF00)):(x))
 
 /**
 * \brief Macro to sign extend signed 9 bit value to signed  16 bit value
 */
-#define DRX_S24TODRXFREQ(x) ( ( ( (u32_t) x ) & 0x00800000UL ) ? \
+#define DRX_S24TODRXFREQ(x) ( ( ( (u32) x ) & 0x00800000UL ) ? \
 				 (  (DRXFrequency_t) \
-				    ( ( (u32_t) x ) | 0xFF000000 ) ) : \
+				    ( ( (u32) x ) | 0xFF000000 ) ) : \
 				 ( (DRXFrequency_t) x ) )
 
 /**
@@ -283,7 +283,7 @@ MACROS
 */
 #define DRX_U16TODRXFREQ(x)   (  ( x & 0x8000 ) ? \
 				 (  (DRXFrequency_t) \
-				    ( ( (u32_t) x ) | 0xFFFF0000 ) ) : \
+				    ( ( (u32) x ) | 0xFFFF0000 ) ) : \
 				 ( (DRXFrequency_t) x ) )
 
 /*-------------------------------------------------------------------------
@@ -579,7 +579,7 @@ ENUM
 * \enum DRXCtrlIndex_t
 * \brief Indices of the control functions.
 */
-	typedef u32_t DRXCtrlIndex_t, *pDRXCtrlIndex_t;
+	typedef u32 DRXCtrlIndex_t, *pDRXCtrlIndex_t;
 
 #ifndef DRX_CTRL_BASE
 #define DRX_CTRL_BASE          ((DRXCtrlIndex_t)0)
@@ -781,7 +781,7 @@ STRUCTS
 * \enum DRXCfgType_t
 * \brief Generic configuration function identifiers.
 */
-	typedef u32_t DRXCfgType_t, *pDRXCfgType_t;
+	typedef u32 DRXCfgType_t, *pDRXCfgType_t;
 
 #ifndef DRX_CFG_BASE
 #define DRX_CFG_BASE          ((DRXCfgType_t)0)
@@ -821,9 +821,9 @@ STRUCTS
 * Used by DRX_CTRL_LOAD_UCODE and DRX_CTRL_VERIFY_UCODE
 */
 	typedef struct {
-		pu8_t mcData;
+		u8 *mcData;
 		     /**< Pointer to microcode image. */
-		u16_t mcSize;
+		u16 mcSize;
 		     /**< Microcode image size.       */
 	} DRXUCodeInfo_t, *pDRXUCodeInfo_t;
 
@@ -847,10 +847,10 @@ STRUCTS
 #define AUX_VER_RECORD 0x8000
 
 	typedef struct {
-		u16_t auxType;	/* type of aux data - 0x8000 for version record     */
-		u32_t mcDevType;	/* device type, based on JTAG ID                    */
-		u32_t mcVersion;	/* version of microcode                             */
-		u32_t mcBaseVersion;	/* in case of patch: the original microcode version */
+		u16 auxType;	/* type of aux data - 0x8000 for version record     */
+		u32 mcDevType;	/* device type, based on JTAG ID                    */
+		u32 mcVersion;	/* version of microcode                             */
+		u32 mcBaseVersion;	/* in case of patch: the original microcode version */
 	} DRXMcVersionRec_t, *pDRXMcVersionRec_t;
 
 /*========================================*/
@@ -862,13 +862,13 @@ STRUCTS
 * Used by DRX_CTRL_LOAD_FILTER
 */
 	typedef struct {
-		pu8_t dataRe;
+		u8 *dataRe;
 		      /**< pointer to coefficients for RE */
-		pu8_t dataIm;
+		u8 *dataIm;
 		      /**< pointer to coefficients for IM */
-		u16_t sizeRe;
+		u16 sizeRe;
 		      /**< size of coefficients for RE    */
-		u16_t sizeIm;
+		u16 sizeIm;
 		      /**< size of coefficients for IM    */
 	} DRXFilterInfo_t, *pDRXFilterInfo_t;
 
@@ -918,21 +918,21 @@ STRUCTS
 * Used by DRX_CTRL_SIG_QUALITY.
 */
 	typedef struct {
-		u16_t MER;     /**< in steps of 0.1 dB                        */
-		u32_t preViterbiBER;
+		u16 MER;     /**< in steps of 0.1 dB                        */
+		u32 preViterbiBER;
 			       /**< in steps of 1/scaleFactorBER              */
-		u32_t postViterbiBER;
+		u32 postViterbiBER;
 			       /**< in steps of 1/scaleFactorBER              */
-		u32_t scaleFactorBER;
+		u32 scaleFactorBER;
 			       /**< scale factor for BER                      */
-		u16_t packetError;
+		u16 packetError;
 			       /**< number of packet errors                   */
-		u32_t postReedSolomonBER;
+		u32 postReedSolomonBER;
 			       /**< in steps of 1/scaleFactorBER              */
-		u32_t preLdpcBER;
+		u32 preLdpcBER;
 			       /**< in steps of 1/scaleFactorBER              */
-		u32_t averIter;/**< in steps of 0.01                          */
-		u16_t indicator;
+		u32 averIter;/**< in steps of 0.01                          */
+		u16 indicator;
 			       /**< indicative signal quality low=0..100=high */
 	} DRXSigQuality_t, *pDRXSigQuality_t;
 
@@ -952,9 +952,9 @@ STRUCTS
 * Used by DRX_CTRL_CONSTEL.
 */
 	typedef struct {
-		s16_t im;
+		s16 im;
 	     /**< Imaginary part. */
-		s16_t re;
+		s16 re;
 	     /**< Real part.      */
 	} DRXComplex_t, *pDRXComplex_t;
 
@@ -975,7 +975,7 @@ STRUCTS
 			     /**< Stepping frequency in this band            */
 		DRXBandwidth_t bandwidth;
 			     /**< Bandwidth within this frequency band       */
-		u16_t chNumber;
+		u16 chNumber;
 			     /**< First channel number in this band, or first
 				    index in chNames                         */
 		char **chNames;
@@ -1004,12 +1004,12 @@ STRUCTS
 * QAM specific scanning variables
 */
 	typedef struct {
-		pu32_t symbolrate;	  /**<  list of symbolrates to scan   */
-		u16_t symbolrateSize;	  /**<  size of symbolrate array      */
+		u32 *symbolrate;	  /**<  list of symbolrates to scan   */
+		u16 symbolrateSize;	  /**<  size of symbolrate array      */
 		pDRXConstellation_t constellation;
 					  /**<  list of constellations        */
-		u16_t constellationSize;    /**<  size of constellation array */
-		u16_t ifAgcThreshold;	  /**<  thresholf for IF-AGC based
+		u16 constellationSize;    /**<  size of constellation array */
+		u16 ifAgcThreshold;	  /**<  thresholf for IF-AGC based
 						scanning filter               */
 	} DRXScanDataQam_t, *pDRXScanDataQam_t;
 
@@ -1020,7 +1020,7 @@ STRUCTS
 * ATV specific scanning variables
 */
 	typedef struct {
-		s16_t svrThreshold;
+		s16 svrThreshold;
 			/**< threshold of Sound/Video ratio in 0.1dB steps */
 	} DRXScanDataAtv_t, *pDRXScanDataAtv_t;
 
@@ -1035,8 +1035,8 @@ STRUCTS
 	typedef struct {
 		pDRXFrequencyPlan_t frequencyPlan;
 					  /**< Frequency plan (array)*/
-		u16_t frequencyPlanSize;  /**< Number of bands       */
-		u32_t numTries;		  /**< Max channels tried    */
+		u16 frequencyPlanSize;  /**< Number of bands       */
+		u32 numTries;		  /**< Max channels tried    */
 		DRXFrequency_t skip;	  /**< Minimum frequency step to take
 						after a channel is found */
 		void *extParams;	  /**< Standard specific params */
@@ -1084,8 +1084,8 @@ STRUCTS
 		DRXCoderate_t lowCoderate;
 					/**< Low cod rate   */
 		DRXTPSFrame_t frame;	/**< Tps frame      */
-		u8_t length;		/**< Length         */
-		u16_t cellId;		/**< Cell id        */
+		u8 length;		/**< Length         */
+		u16 cellId;		/**< Cell id        */
 	} DRXTPSInfo_t, *pDRXTPSInfo_t;
 
 /*========================================*/
@@ -1166,9 +1166,9 @@ STRUCTS
 			       /**< Type identifier of the module */
 		char *moduleName;
 			       /**< Name or description of module */
-		u16_t vMajor;  /**< Major version number          */
-		u16_t vMinor;  /**< Minor version number          */
-		u16_t vPatch;  /**< Patch version number          */
+		u16 vMajor;  /**< Major version number          */
+		u16 vMinor;  /**< Minor version number          */
+		u16 vPatch;  /**< Patch version number          */
 		char *vString; /**< Version as text string        */
 	} DRXVersion_t, *pDRXVersion_t;
 
@@ -1237,8 +1237,8 @@ STRUCTS
 	typedef struct {
 		DRXFrequency_t frequency; /**< Frequency in Khz         */
 		DRXLockStatus_t lock;	  /**< Lock status              */
-		u32_t mer;		  /**< MER                      */
-		s32_t symbolRateOffset;	  /**< Symbolrate offset in ppm */
+		u32 mer;		  /**< MER                      */
+		s32 symbolRateOffset;	  /**< Symbolrate offset in ppm */
 	} DRXOOBStatus_t, *pDRXOOBStatus_t;
 
 /*========================================*/
@@ -1291,7 +1291,7 @@ STRUCTS
 					     will be used, otherwise clockrate
 					     will adapt to the bitrate of the
 					     TS                               */
-		u32_t bitrate;		/**< Maximum bitrate in b/s in case
+		u32 bitrate;		/**< Maximum bitrate in b/s in case
 					     static clockrate is selected     */
 		DRXMPEGStrWidth_t widthSTR;
 					/**< MPEG start width                 */
@@ -1313,7 +1313,7 @@ STRUCTS
 */
 	typedef struct {
 		DRXCfgSMAIO_t io;
-		u16_t ctrlData;
+		u16 ctrlData;
 		Bool_t smartAntInverted;
 	} DRXCfgSMA_t, *pDRXCfgSMA_t;
 
@@ -1328,15 +1328,15 @@ STRUCTS
 *
 */
 	typedef struct {
-		u16_t portNr;	/**< I2C port number               */
+		u16 portNr;	/**< I2C port number               */
 		struct i2c_device_addr *wDevAddr;
 				/**< Write device address          */
-		u16_t wCount;	/**< Size of write data in bytes   */
-		pu8_t wData;	/**< Pointer to write data         */
+		u16 wCount;	/**< Size of write data in bytes   */
+		u8 *wData;	/**< Pointer to write data         */
 		struct i2c_device_addr *rDevAddr;
 				/**< Read device address           */
-		u16_t rCount;	/**< Size of data to read in bytes */
-		pu8_t rData;	/**< Pointer to read buffer        */
+		u16 rCount;	/**< Size of data to read in bytes */
+		u8 *rData;	/**< Pointer to read buffer        */
 	} DRXI2CData_t, *pDRXI2CData_t;
 
 /*========================================*/
@@ -1398,7 +1398,7 @@ STRUCTS
 		Bool_t rds;		  /**< RDS data array present         */
 		DRXAudNICAMStatus_t nicamStatus;
 					  /**< status of NICAM carrier        */
-		s8_t fmIdent;		  /**< FM Identification value        */
+		s8 fmIdent;		  /**< FM Identification value        */
 	} DRXAudStatus_t, *pDRXAudStatus_t;
 
 /* CTRL_AUD_READ_RDS       - DRXRDSdata_t */
@@ -1409,7 +1409,7 @@ STRUCTS
 */
 	typedef struct {
 		Bool_t valid;		  /**< RDS data validation            */
-		u16_t data[18];		  /**< data from one RDS data array   */
+		u16 data[18];		  /**< data from one RDS data array   */
 	} DRXCfgAudRDS_t, *pDRXCfgAudRDS_t;
 
 /* DRX_CFG_AUD_VOLUME      - DRXCfgAudVolume_t - set/get */
@@ -1452,15 +1452,15 @@ STRUCTS
 */
 	typedef struct {
 		Bool_t mute;		  /**< mute overrides volume setting  */
-		s16_t volume;		  /**< volume, range -114 to 12 dB    */
+		s16 volume;		  /**< volume, range -114 to 12 dB    */
 		DRXAudAVCMode_t avcMode;  /**< AVC auto volume control mode   */
-		u16_t avcRefLevel;	  /**< AVC reference level            */
+		u16 avcRefLevel;	  /**< AVC reference level            */
 		DRXAudAVCMaxGain_t avcMaxGain;
 					  /**< AVC max gain selection         */
 		DRXAudAVCMaxAtten_t avcMaxAtten;
 					  /**< AVC max attenuation selection  */
-		s16_t strengthLeft;	  /**< quasi-peak, left speaker       */
-		s16_t strengthRight;	  /**< quasi-peak, right speaker      */
+		s16 strengthLeft;	  /**< quasi-peak, left speaker       */
+		s16 strengthRight;	  /**< quasi-peak, right speaker      */
 	} DRXCfgAudVolume_t, *pDRXCfgAudVolume_t;
 
 /* DRX_CFG_I2S_OUTPUT      - DRXCfgI2SOutput_t - set/get */
@@ -1508,7 +1508,7 @@ STRUCTS
 */
 	typedef struct {
 		Bool_t outputEnable;	  /**< I2S output enable              */
-		u32_t frequency;	  /**< range from 8000-48000 Hz       */
+		u32 frequency;	  /**< range from 8000-48000 Hz       */
 		DRXI2SMode_t mode;	  /**< I2S mode, master or slave      */
 		DRXI2SWordLength_t wordLength;
 					  /**< I2S wordlength, 16 or 32 bits  */
@@ -1563,9 +1563,9 @@ STRUCTS
 * \brief Automatic Sound Select Thresholds
 */
 	typedef struct {
-		u16_t a2;	/* A2 Threshold for ASS configuration */
-		u16_t btsc;	/* BTSC Threshold for ASS configuration */
-		u16_t nicam;	/* Nicam Threshold for ASS configuration */
+		u16 a2;	/* A2 Threshold for ASS configuration */
+		u16 btsc;	/* BTSC Threshold for ASS configuration */
+		u16 nicam;	/* Nicam Threshold for ASS configuration */
 	} DRXCfgAudASSThres_t, *pDRXCfgAudASSThres_t;
 
 /**
@@ -1573,7 +1573,7 @@ STRUCTS
 * \brief Carrier detection related parameters
 */
 	typedef struct {
-		u16_t thres;	/* carrier detetcion threshold for primary carrier (A) */
+		u16 thres;	/* carrier detetcion threshold for primary carrier (A) */
 		DRXNoCarrierOption_t opt;	/* Mute or noise at no carrier detection (A) */
 		DRXFrequency_t shift;	/* DC level of incoming signal (A) */
 		DRXFrequency_t dco;	/* frequency adjustment (A) */
@@ -1657,8 +1657,8 @@ STRUCTS
 * \brief Prescalers
 */
 	typedef struct {
-		u16_t fmDeviation;
-		s16_t nicamGain;
+		u16 fmDeviation;
+		s16 nicamGain;
 	} DRXCfgAudPrescale_t, *pDRXCfgAudPrescale_t;
 
 /**
@@ -1666,8 +1666,8 @@ STRUCTS
 * \brief Beep
 */
 	typedef struct {
-		s16_t volume;	/* dB */
-		u16_t frequency;	/* Hz */
+		s16 volume;	/* dB */
+		u16 frequency;	/* Hz */
 		Bool_t mute;
 	} DRXAudBeep_t, *pDRXAudBeep_t;
 
@@ -1700,7 +1700,7 @@ STRUCTS
 		DRXAudFMDeemphasis_t deemph;
 		DRXAudBtscDetect_t btscDetect;
 		/* rds */
-		u16_t rdsDataCounter;
+		u16 rdsDataCounter;
 		Bool_t rdsDataPresent;
 	} DRXAudData_t, *pDRXAudData_t;
 
@@ -1720,81 +1720,81 @@ STRUCTS
 /*============================================================================*/
 
 /* Address on device */
-	typedef u32_t DRXaddr_t, *pDRXaddr_t;
+	typedef u32 DRXaddr_t, *pDRXaddr_t;
 
 /* Protocol specific flags */
-	typedef u32_t DRXflags_t, *pDRXflags_t;
+	typedef u32 DRXflags_t, *pDRXflags_t;
 
 /* Write block of data to device */
 	typedef DRXStatus_t(*DRXWriteBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
-						   u16_t datasize,	/* size of data in bytes        */
-						   pu8_t data,	/* data to send                 */
+						   u16 datasize,	/* size of data in bytes        */
+						   u8 *data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read block of data from device */
 	typedef DRXStatus_t(*DRXReadBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
-						  u16_t datasize,	/* size of data in bytes        */
-						  pu8_t data,	/* receive buffer               */
+						  u16 datasize,	/* size of data in bytes        */
+						  u8 *data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Write 8-bits value to device */
 	typedef DRXStatus_t(*DRXWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
-						  u8_t data,	/* data to send                 */
+						  u8 data,	/* data to send                 */
 						  DRXflags_t flags);
 
 /* Read 8-bits value to device */
 	typedef DRXStatus_t(*DRXReadReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						 DRXaddr_t addr,	/* address of register/memory   */
-						 pu8_t data,	/* receive buffer               */
+						 u8 *data,	/* receive buffer               */
 						 DRXflags_t flags);
 
 /* Read modify write 8-bits value to device */
 	typedef DRXStatus_t(*DRXReadModifyWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							    DRXaddr_t waddr,	/* write address of register   */
 							    DRXaddr_t raddr,	/* read  address of register   */
-							    u8_t wdata,	/* data to write               */
-							    pu8_t rdata);	/* data to read                */
+							    u8 wdata,	/* data to write               */
+							    u8 *rdata);	/* data to read                */
 
 /* Write 16-bits value to device */
 	typedef DRXStatus_t(*DRXWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
-						   u16_t data,	/* data to send                 */
+						   u16 data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read 16-bits value to device */
 	typedef DRXStatus_t(*DRXReadReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
-						  pu16_t data,	/* receive buffer               */
+						  u16 *data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Read modify write 16-bits value to device */
 	typedef DRXStatus_t(*DRXReadModifyWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							     DRXaddr_t waddr,	/* write address of register   */
 							     DRXaddr_t raddr,	/* read  address of register   */
-							     u16_t wdata,	/* data to write               */
-							     pu16_t rdata);	/* data to read                */
+							     u16 wdata,	/* data to write               */
+							     u16 *rdata);	/* data to read                */
 
 /* Write 32-bits value to device */
 	typedef DRXStatus_t(*DRXWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
-						   u32_t data,	/* data to send                 */
+						   u32 data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read 32-bits value to device */
 	typedef DRXStatus_t(*DRXReadReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
-						  pu32_t data,	/* receive buffer               */
+						  u32 *data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Read modify write 32-bits value to device */
 	typedef DRXStatus_t(*DRXReadModifyWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							     DRXaddr_t waddr,	/* write address of register   */
 							     DRXaddr_t raddr,	/* read  address of register   */
-							     u32_t wdata,	/* data to write               */
-							     pu32_t rdata);	/* data to read                */
+							     u32 wdata,	/* data to write               */
+							     u32 *rdata);	/* data to read                */
 
 /**
 * \struct DRXAccessFunc_t
@@ -1819,7 +1819,7 @@ STRUCTS
 	typedef struct {
 
 		DRXaddr_t address;
-		u32_t data;
+		u32 data;
 
 	} DRXRegDump_t, *pDRXRegDump_t;
 
@@ -1835,8 +1835,8 @@ STRUCTS
 */
 	typedef struct {
 		/* Microcode (firmware) attributes */
-		pu8_t microcode;   /**< Pointer to microcode image.           */
-		u16_t microcodeSize;
+		u8 *microcode;   /**< Pointer to microcode image.           */
+		u16 microcodeSize;
 				   /**< Size of microcode image in bytes.     */
 		Bool_t verifyMicrocode;
 				   /**< Use microcode verify or not.          */
@@ -1850,7 +1850,7 @@ STRUCTS
 				     /**< Systemclock frequency.  (kHz)       */
 		DRXFrequency_t oscClockFreq;
 				     /**< Oscillator clock frequency.  (kHz)  */
-		s16_t oscClockDeviation;
+		s16 oscClockDeviation;
 				     /**< Oscillator clock deviation.  (ppm)  */
 		Bool_t mirrorFreqSpect;
 				     /**< Mirror IF frequency spectrum or not.*/
@@ -1864,13 +1864,13 @@ STRUCTS
 		/* Channel scan */
 		pDRXScanParam_t scanParam;
 				      /**< scan parameters                    */
-		u16_t scanFreqPlanIndex;
+		u16 scanFreqPlanIndex;
 				      /**< next index in freq plan            */
 		DRXFrequency_t scanNextFrequency;
 				      /**< next freq to scan                  */
 		Bool_t scanReady;     /**< scan ready flag                    */
-		u32_t scanMaxChannels;/**< number of channels in freqplan     */
-		u32_t scanChannelsScanned;
+		u32 scanMaxChannels;/**< number of channels in freqplan     */
+		u32 scanChannelsScanned;
 					/**< number of channels scanned       */
 		/* Channel scan - inner loop: demod related */
 		DRXScanFunc_t scanFunction;
@@ -1878,7 +1878,7 @@ STRUCTS
 		/* Channel scan - inner loop: SYSObj related */
 		void *scanContext;    /**< Context Pointer of SYSObj          */
 		/* Channel scan - parameters for default DTV scan function in core driver  */
-		u16_t scanDemodLockTimeout;
+		u16 scanDemodLockTimeout;
 					 /**< millisecs to wait for lock      */
 		DRXLockStatus_t scanDesiredLock;
 				      /**< lock requirement for channel found */
@@ -1891,7 +1891,7 @@ STRUCTS
 				      /**< current power management mode      */
 
 		/* Tuner */
-		u8_t tunerPortNr;     /**< nr of I2C port to wich tuner is    */
+		u8 tunerPortNr;     /**< nr of I2C port to wich tuner is    */
 		DRXFrequency_t tunerMinFreqRF;
 				      /**< minimum RF input frequency, in kHz */
 		DRXFrequency_t tunerMaxFreqRF;
@@ -1909,8 +1909,8 @@ STRUCTS
 		DRXStandard_t diCacheStandard;
 				      /**< standard in DI cache if available  */
 		Bool_t useBootloader; /**< use bootloader in open             */
-		u32_t capabilities;   /**< capabilities flags                 */
-		u32_t productId;      /**< product ID inc. metal fix number   */
+		u32 capabilities;   /**< capabilities flags                 */
+		u32 productId;      /**< product ID inc. metal fix number   */
 
 	} DRXCommonAttr_t, *pDRXCommonAttr_t;
 
@@ -1930,7 +1930,7 @@ STRUCTS
 * \brief A stucture containing all functions of a demodulator.
 */
 	typedef struct {
-		u32_t typeId;		 /**< Device type identifier.      */
+		u32 typeId;		 /**< Device type identifier.      */
 		DRXOpenFunc_t openFunc;	 /**< Pointer to Open() function.  */
 		DRXCloseFunc_t closeFunc;/**< Pointer to Close() function. */
 		DRXCtrlFunc_t ctrlFunc;	 /**< Pointer to Ctrl() function.  */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index a41b2a9fe9b4..b79154fb79c0 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -52,10 +52,10 @@ INCLUDE FILES
 /*============================================================================*/
 
 /**
-* \brief Maximum u32_t value.
+* \brief Maximum u32 value.
 */
 #ifndef MAX_U32
-#define MAX_U32  ((u32_t) (0xFFFFFFFFL))
+#define MAX_U32  ((u32) (0xFFFFFFFFL))
 #endif
 
 /* Customer configurable hardware settings, etc */
@@ -328,7 +328,7 @@ DEFINES
 */
 
 #ifndef DRXJ_UCODE_MAGIC_WORD
-#define DRXJ_UCODE_MAGIC_WORD         ((((u16_t)'H')<<8)+((u16_t)'L'))
+#define DRXJ_UCODE_MAGIC_WORD         ((((u16)'H')<<8)+((u16)'L'))
 #endif
 
 /**
@@ -504,7 +504,7 @@ DEFINES
 
 #define DUMMY_READ() \
    do{ \
-      u16_t dummy; \
+      u16 dummy; \
       RR16( demod->myI2CDevAddr, SCU_RAM_VERSION_HI__A, &dummy ); \
    } while (0)
 
@@ -544,14 +544,14 @@ DEFINES
 * The macro takes care of the required byte order in a 16 bits word.
 * x -> lowbyte(x), highbyte(x)
 */
-#define DRXJ_16TO8( x ) ((u8_t) (((u16_t)x)    &0xFF)), \
-			((u8_t)((((u16_t)x)>>8)&0xFF))
+#define DRXJ_16TO8( x ) ((u8) (((u16)x)    &0xFF)), \
+			((u8)((((u16)x)>>8)&0xFF))
 /**
 * This macro is used to convert byte array to 16 bit register value for block read.
 * Block read speed up I2C traffic between host and demod.
 * The macro takes care of the required byte order in a 16 bits word.
 */
-#define DRXJ_8TO16( x ) ((u16_t) (x[0] | (x[1] << 8)))
+#define DRXJ_8TO16( x ) ((u16) (x[0] | (x[1] << 8)))
 
 /*============================================================================*/
 /*=== MISC DEFINES ===========================================================*/
@@ -600,52 +600,52 @@ GLOBAL VARIABLES
 
 static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      u16_t datasize,
-				      pu8_t data, DRXflags_t flags);
+				      u16 datasize,
+				      u8 *data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 						DRXaddr_t waddr,
 						DRXaddr_t raddr,
-						u8_t wdata, pu8_t rdata);
+						u8 wdata, u8 *rdata);
 
 static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
-						 u16_t wdata, pu16_t rdata);
+						 u16 wdata, u16 *rdata);
 
 static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
-						 u32_t wdata, pu32_t rdata);
+						 u32 wdata, u32 *rdata);
 
 static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
-				     pu8_t data, DRXflags_t flags);
+				     u8 *data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      pu16_t data, DRXflags_t flags);
+				      u16 *data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      pu32_t data, DRXflags_t flags);
+				      u32 *data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
-				       u16_t datasize,
-				       pu8_t data, DRXflags_t flags);
+				       u16 datasize,
+				       u8 *data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      u8_t data, DRXflags_t flags);
+				      u8 data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
-				       u16_t data, DRXflags_t flags);
+				       u16 data, DRXflags_t flags);
 
 static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
-				       u32_t data, DRXflags_t flags);
+				       u32 data, DRXflags_t flags);
 
 /* The version structure of this protocol implementation */
 char drxDapDRXJModuleName[] = "DRXJ Data Access Protocol";
@@ -743,7 +743,7 @@ DRXJData_t DRXJData_g = {
 /*   TRUE,                   * flagASDRequest    */
 /*   FALSE,                  * flagHDevClear     */
 /*   FALSE,                  * flagHDevSet       */
-/*   (u16_t) 0xFFF,          * rdsLastCount      */
+/*   (u16) 0xFFF,          * rdsLastCount      */
 
 /*#ifdef DRXJ_SPLIT_UCODE_UPLOAD
    FALSE,                  * flagAudMcUploaded */
@@ -950,7 +950,7 @@ struct i2c_device_addr DRXJDefaultAddr_g = {
 * \brief Default common attributes of a drxj demodulator instance.
 */
 DRXCommonAttr_t DRXJDefaultCommAttr_g = {
-	(pu8_t) NULL,		/* ucode ptr            */
+	(u8 *) NULL,		/* ucode ptr            */
 	0,			/* ucode size           */
 	TRUE,			/* ucode verify switch  */
 	{0},			/* version record       */
@@ -1109,21 +1109,21 @@ DRXAudData_t DRXJDefaultAudData_g = {
 STRUCTURES
 ----------------------------------------------------------------------------*/
 typedef struct {
-	u16_t eqMSE;
-	u8_t eqMode;
-	u8_t eqCtrl;
-	u8_t eqStat;
+	u16 eqMSE;
+	u8 eqMode;
+	u8 eqCtrl;
+	u8 eqStat;
 } DRXJEQStat_t, *pDRXJEQStat_t;
 
 /* HI command */
 typedef struct {
-	u16_t cmd;
-	u16_t param1;
-	u16_t param2;
-	u16_t param3;
-	u16_t param4;
-	u16_t param5;
-	u16_t param6;
+	u16 cmd;
+	u16 param1;
+	u16 param2;
+	u16 param3;
+	u16 param4;
+	u16 param5;
+	u16 param6;
 } DRXJHiCmd_t, *pDRXJHiCmd_t;
 
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
@@ -1132,12 +1132,12 @@ typedef struct {
 /*============================================================================*/
 
 typedef struct {
-	u32_t addr;
-	u16_t size;
-	u16_t flags;		/* bit[15..2]=reserved,
+	u32 addr;
+	u16 size;
+	u16 flags;		/* bit[15..2]=reserved,
 				   bit[1]= compression on/off
 				   bit[0]= CRC on/off */
-	u16_t CRC;
+	u16 CRC;
 } DRXUCodeBlockHdr_t, *pDRXUCodeBlockHdr_t;
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
@@ -1147,7 +1147,7 @@ FUNCTIONS
 /* Some prototypes */
 static DRXStatus_t
 HICommand(struct i2c_device_addr *devAddr,
-	  const pDRXJHiCmd_t cmd, pu16_t result);
+	  const pDRXJHiCmd_t cmd, u16 *result);
 
 static DRXStatus_t
 CtrlLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat);
@@ -1184,7 +1184,7 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 /*============================================================================*/
 
 /**
-* \fn void Mult32(u32_t a, u32_t b, pu32_t h, pu32_t l)
+* \fn void Mult32(u32 a, u32 b, u32 *h, u32 *l)
 * \brief 32bitsx32bits signed multiplication
 * \param a 32 bits multiplicant, typecast from signed to unisgned
 * \param b 32 bits multiplier, typecast from signed to unisgned
@@ -1224,9 +1224,9 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 *
 */
 
-#define DRX_IS_BOOTH_NEGATIVE(__a)  (((__a) & (1 << (sizeof (u32_t) * 8 - 1))) != 0)
+#define DRX_IS_BOOTH_NEGATIVE(__a)  (((__a) & (1 << (sizeof (u32) * 8 - 1))) != 0)
 
-static void Mult32(u32_t a, u32_t b, pu32_t h, pu32_t l)
+static void Mult32(u32 a, u32 b, u32 *h, u32 *l)
 {
 	unsigned int i;
 	*h = *l = 0;
@@ -1256,17 +1256,17 @@ static void Mult32(u32_t a, u32_t b, pu32_t h, pu32_t l)
 		case 4:
 			*l -= b;
 			*h = *h - !DRX_IS_BOOTH_NEGATIVE(b) + !b + (*l <
-								    ((u32_t)
+								    ((u32)
 								     (-
-								      ((s32_t)
+								      ((s32)
 								       b))));
 		case 5:
 		case 6:
 			*l -= b;
 			*h = *h - !DRX_IS_BOOTH_NEGATIVE(b) + !b + (*l <
-								    ((u32_t)
+								    ((u32)
 								     (-
-								      ((s32_t)
+								      ((s32)
 								       b))));
 			break;
 		}
@@ -1276,7 +1276,7 @@ static void Mult32(u32_t a, u32_t b, pu32_t h, pu32_t l)
 /*============================================================================*/
 
 /*
-* \fn u32_t Frac28(u32_t N, u32_t D)
+* \fn u32 Frac28(u32 N, u32 D)
 * \brief Compute: (1<<28)*N/D
 * \param N 32 bits
 * \param D 32 bits
@@ -1295,11 +1295,11 @@ static void Mult32(u32_t a, u32_t b, pu32_t h, pu32_t l)
 * D: 0...(1<<28)-1
 * Q: 0...(1<<32)-1
 */
-static u32_t Frac28(u32_t N, u32_t D)
+static u32 Frac28(u32 N, u32 D)
 {
 	int i = 0;
-	u32_t Q1 = 0;
-	u32_t R0 = 0;
+	u32 Q1 = 0;
+	u32 R0 = 0;
 
 	R0 = (N % D) << 4;	/* 32-28 == 4 shifts possible at max */
 	Q1 = N / D;		/* integer part, only the 4 least significant bits
@@ -1318,7 +1318,7 @@ static u32_t Frac28(u32_t N, u32_t D)
 }
 
 /**
-* \fn u32_t Log10Times100( u32_t x)
+* \fn u32 Log10Times100( u32 x)
 * \brief Compute: 100*log10(x)
 * \param x 32 bits
 * \return 100*log10(x)
@@ -1333,16 +1333,16 @@ static u32_t Frac28(u32_t N, u32_t D)
 * where y = 2^k and 1<= (x/y) < 2
 */
 
-static u32_t Log10Times100(u32_t x)
+static u32 Log10Times100(u32 x)
 {
-	static const u8_t scale = 15;
-	static const u8_t indexWidth = 5;
+	static const u8 scale = 15;
+	static const u8 indexWidth = 5;
 	/*
 	   log2lut[n] = (1<<scale) * 200 * log2( 1.0 + ( (1.0/(1<<INDEXWIDTH)) * n ))
 	   0 <= n < ((1<<INDEXWIDTH)+1)
 	 */
 
-	static const u32_t log2lut[] = {
+	static const u32 log2lut[] = {
 		0,		/* 0.000000 */
 		290941,		/* 290941.300628 */
 		573196,		/* 573196.476418 */
@@ -1378,26 +1378,26 @@ static u32_t Log10Times100(u32_t x)
 		6553600,	/* 6553600.000000 */
 	};
 
-	u8_t i = 0;
-	u32_t y = 0;
-	u32_t d = 0;
-	u32_t k = 0;
-	u32_t r = 0;
+	u8 i = 0;
+	u32 y = 0;
+	u32 d = 0;
+	u32 k = 0;
+	u32 r = 0;
 
 	if (x == 0)
 		return (0);
 
 	/* Scale x (normalize) */
 	/* computing y in log(x/y) = log(x) - log(y) */
-	if ((x & (((u32_t) (-1)) << (scale + 1))) == 0) {
+	if ((x & (((u32) (-1)) << (scale + 1))) == 0) {
 		for (k = scale; k > 0; k--) {
-			if (x & (((u32_t) 1) << scale))
+			if (x & (((u32) 1) << scale))
 				break;
 			x <<= 1;
 		}
 	} else {
 		for (k = scale; k < 31; k++) {
-			if ((x & (((u32_t) (-1)) << (scale + 1))) == 0)
+			if ((x & (((u32) (-1)) << (scale + 1))) == 0)
 				break;
 			x >>= 1;
 		}
@@ -1407,14 +1407,14 @@ static u32_t Log10Times100(u32_t x)
 	   and 1.0 <= x < 2.0 */
 
 	/* correction for divison: log(x) = log(x/y)+log(y) */
-	y = k * ((((u32_t) 1) << scale) * 200);
+	y = k * ((((u32) 1) << scale) * 200);
 
 	/* remove integer part */
-	x &= ((((u32_t) 1) << scale) - 1);
+	x &= ((((u32) 1) << scale) - 1);
 	/* get index */
-	i = (u8_t) (x >> (scale - indexWidth));
+	i = (u8) (x >> (scale - indexWidth));
 	/* compute delta (x-a) */
-	d = x & ((((u32_t) 1) << (scale - indexWidth)) - 1);
+	d = x & ((((u32) 1) << (scale - indexWidth)) - 1);
 	/* compute log, multiplication ( d* (.. )) must be within range ! */
 	y += log2lut[i] +
 	    ((d * (log2lut[i + 1] - log2lut[i])) >> (scale - indexWidth));
@@ -1422,7 +1422,7 @@ static u32_t Log10Times100(u32_t x)
 	y /= 108853;		/* (log2(10) << scale) */
 	r = (y >> 1);
 	/* rounding */
-	if (y & ((u32_t) 1))
+	if (y & ((u32) 1))
 		r++;
 
 	return (r);
@@ -1430,19 +1430,19 @@ static u32_t Log10Times100(u32_t x)
 }
 
 /**
-* \fn u32_t FracTimes1e6( u16_t N, u32_t D)
+* \fn u32 FracTimes1e6( u16 N, u32 D)
 * \brief Compute: (N/D) * 1000000.
 * \param N nominator 16-bits.
 * \param D denominator 32-bits.
-* \return u32_t
+* \return u32
 * \retval ((N/D) * 1000000), 32 bits
 *
 * No check on D=0!
 */
-static u32_t FracTimes1e6(u32_t N, u32_t D)
+static u32 FracTimes1e6(u32 N, u32 D)
 {
-	u32_t remainder = 0;
-	u32_t frac = 0;
+	u32 remainder = 0;
+	u32 frac = 0;
 
 	/*
 	   frac = (N * 1000000) / D
@@ -1451,9 +1451,9 @@ static u32_t FracTimes1e6(u32_t N, u32_t D)
 	   This would result in a problem in case D < 16 (div by 0).
 	   So we do it more elaborate as shown below.
 	 */
-	frac = (((u32_t) N) * (1000000 >> 4)) / D;
+	frac = (((u32) N) * (1000000 >> 4)) / D;
 	frac <<= 4;
-	remainder = (((u32_t) N) * (1000000 >> 4)) % D;
+	remainder = (((u32) N) * (1000000 >> 4)) % D;
 	remainder <<= 4;
 	frac += remainder / D;
 	remainder = remainder % D;
@@ -1468,16 +1468,16 @@ static u32_t FracTimes1e6(u32_t N, u32_t D)
 
 /**
 * \brief Compute: 100 * 10^( GdB / 200 ).
-* \param  u32_t   GdB      Gain in 0.1dB
-* \return u32_t            Gainfactor in 0.01 resolution
+* \param  u32   GdB      Gain in 0.1dB
+* \return u32            Gainfactor in 0.01 resolution
 *
 */
-static u32_t dB2LinTimes100(u32_t GdB)
+static u32 dB2LinTimes100(u32 GdB)
 {
-	u32_t result = 0;
-	u32_t nr6dBSteps = 0;
-	u32_t remainder = 0;
-	u32_t remainderFac = 0;
+	u32 result = 0;
+	u32 nr6dBSteps = 0;
+	u32 remainder = 0;
+	u32 remainderFac = 0;
 
 	/* start with factors 2 (6.02dB) */
 	nr6dBSteps = GdB * 1000UL / 60206UL;
@@ -1512,21 +1512,21 @@ static u32_t dB2LinTimes100(u32_t GdB)
 #define FRAC_CEIL     1
 #define FRAC_ROUND    2
 /**
-* \fn u32_t Frac( u32_t N, u32_t D, u16_t RC )
+* \fn u32 Frac( u32 N, u32 D, u16 RC )
 * \brief Compute: N/D.
 * \param N nominator 32-bits.
 * \param D denominator 32-bits.
 * \param RC-result correction: 0-floor; 1-ceil; 2-round
-* \return u32_t
+* \return u32
 * \retval N/D, 32 bits
 *
 * If D=0 returns 0
 */
-static u32_t Frac(u32_t N, u32_t D, u16_t RC)
+static u32 Frac(u32 N, u32 D, u16 RC)
 {
-	u32_t remainder = 0;
-	u32_t frac = 0;
-	u16_t bitCnt = 32;
+	u32 remainder = 0;
+	u32 frac = 0;
+	u16 bitCnt = 32;
 
 	if (D == 0) {
 		frac = 0;
@@ -1573,19 +1573,19 @@ static u32_t Frac(u32_t N, u32_t D, u16_t RC)
 /*============================================================================*/
 
 /**
-* \fn u16_t UCodeRead16( pu8_t addr)
+* \fn u16 UCodeRead16( u8 *addr)
 * \brief Read a 16 bits word, expect big endian data.
-* \return u16_t The data read.
+* \return u16 The data read.
 */
-static u16_t UCodeRead16(pu8_t addr)
+static u16 UCodeRead16(u8 *addr)
 {
 	/* Works fo any host processor */
 
-	u16_t word = 0;
+	u16 word = 0;
 
-	word = ((u16_t) addr[0]);
+	word = ((u16) addr[0]);
 	word <<= 8;
-	word |= ((u16_t) addr[1]);
+	word |= ((u16) addr[1]);
 
 	return (word);
 }
@@ -1593,23 +1593,23 @@ static u16_t UCodeRead16(pu8_t addr)
 /*============================================================================*/
 
 /**
-* \fn u32_t UCodeRead32( pu8_t addr)
+* \fn u32 UCodeRead32( u8 *addr)
 * \brief Read a 32 bits word, expect big endian data.
-* \return u32_t The data read.
+* \return u32 The data read.
 */
-static u32_t UCodeRead32(pu8_t addr)
+static u32 UCodeRead32(u8 *addr)
 {
 	/* Works fo any host processor */
 
-	u32_t word = 0;
+	u32 word = 0;
 
-	word = ((u16_t) addr[0]);
+	word = ((u16) addr[0]);
 	word <<= 8;
-	word |= ((u16_t) addr[1]);
+	word |= ((u16) addr[1]);
 	word <<= 8;
-	word |= ((u16_t) addr[2]);
+	word |= ((u16) addr[2]);
 	word <<= 8;
-	word |= ((u16_t) addr[3]);
+	word |= ((u16) addr[3]);
 
 	return (word);
 }
@@ -1617,21 +1617,21 @@ static u32_t UCodeRead32(pu8_t addr)
 /*============================================================================*/
 
 /**
-* \fn u16_t UCodeComputeCRC (pu8_t blockData, u16_t nrWords)
+* \fn u16 UCodeComputeCRC (u8 *blockData, u16 nrWords)
 * \brief Compute CRC of block of microcode data.
 * \param blockData Pointer to microcode data.
 * \param nrWords Size of microcode block (number of 16 bits words).
-* \return u16_t The computed CRC residu.
+* \return u16 The computed CRC residu.
 */
-static u16_t UCodeComputeCRC(pu8_t blockData, u16_t nrWords)
+static u16 UCodeComputeCRC(u8 *blockData, u16 nrWords)
 {
-	u16_t i = 0;
-	u16_t j = 0;
-	u32_t CRCWord = 0;
-	u32_t carry = 0;
+	u16 i = 0;
+	u16 j = 0;
+	u32 CRCWord = 0;
+	u32 carry = 0;
 
 	while (i < nrWords) {
-		CRCWord |= (u32_t) UCodeRead16(blockData);
+		CRCWord |= (u32) UCodeRead16(blockData);
 		for (j = 0; j < 16; j++) {
 			CRCWord <<= 1;
 			if (carry != 0)
@@ -1639,9 +1639,9 @@ static u16_t UCodeComputeCRC(pu8_t blockData, u16_t nrWords)
 			carry = CRCWord & 0x80000000UL;
 		}
 		i++;
-		blockData += (sizeof(u16_t));
+		blockData += (sizeof(u16));
 	}
-	return ((u16_t) (CRCWord >> 16));
+	return ((u16) (CRCWord >> 16));
 }
 #endif /* DRXJ_SPLIT_UCODE_UPLOAD */
 
@@ -1650,7 +1650,7 @@ static u16_t UCodeComputeCRC(pu8_t blockData, u16_t nrWords)
 *        and rounded. For calc used formula: 16*10^(prescaleGain[dB]/20).
 *
 */
-static const u16_t NicamPrescTableVal[43] =
+static const u16 NicamPrescTableVal[43] =
     { 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4,
 	5, 5, 6, 6, 7, 8, 9, 10, 11, 13, 14, 16,
 	18, 20, 23, 25, 28, 32, 36, 40, 45,
@@ -1714,8 +1714,8 @@ Bool_t IsHandledByAudTrIf(DRXaddr_t addr)
 
 static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      u16_t datasize,
-				      pu8_t data, DRXflags_t flags)
+				      u16 datasize,
+				      u8 *data, DRXflags_t flags)
 {
 	return drxDapFASIFunct_g.readBlockFunc(devAddr,
 					       addr, datasize, data, flags);
@@ -1726,7 +1726,7 @@ static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 						DRXaddr_t waddr,
 						DRXaddr_t raddr,
-						u8_t wdata, pu8_t rdata)
+						u8 wdata, u8 *rdata)
 {
 	return drxDapFASIFunct_g.readModifyWriteReg8Func(devAddr,
 							 waddr,
@@ -1759,7 +1759,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
 					      DRXaddr_t waddr,
 					      DRXaddr_t raddr,
-					      u16_t wdata, pu16_t rdata)
+					      u16 wdata, u16 *rdata)
 {
 	DRXStatus_t rc;
 
@@ -1798,7 +1798,7 @@ static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
 static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
-						 u16_t wdata, pu16_t rdata)
+						 u16 wdata, u16 *rdata)
 {
 	/* TODO: correct short/long addressing format decision,
 	   now long format has higher prio then short because short also
@@ -1817,7 +1817,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr
 static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
-						 u32_t wdata, pu32_t rdata)
+						 u32 wdata, u32 *rdata)
 {
 	return drxDapFASIFunct_g.readModifyWriteReg32Func(devAddr,
 							  waddr,
@@ -1828,7 +1828,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr
 
 static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
-				     pu8_t data, DRXflags_t flags)
+				     u8 *data, DRXflags_t flags)
 {
 	return drxDapFASIFunct_g.readReg8Func(devAddr, addr, data, flags);
 }
@@ -1849,12 +1849,12 @@ static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 *
 */
 static DRXStatus_t DRXJ_DAP_ReadAudReg16(struct i2c_device_addr *devAddr,
-					 DRXaddr_t addr, pu16_t data)
+					 DRXaddr_t addr, u16 *data)
 {
-	u32_t startTimer = 0;
-	u32_t currentTimer = 0;
-	u32_t deltaTimer = 0;
-	u16_t trStatus = 0;
+	u32 startTimer = 0;
+	u32 currentTimer = 0;
+	u32 deltaTimer = 0;
+	u16 trStatus = 0;
 	DRXStatus_t stat = DRX_STS_ERROR;
 
 	/* No read possible for bank 3, return with error */
@@ -1930,7 +1930,7 @@ static DRXStatus_t DRXJ_DAP_ReadAudReg16(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      pu16_t data, DRXflags_t flags)
+				      u16 *data, DRXflags_t flags)
 {
 	DRXStatus_t stat = DRX_STS_ERROR;
 
@@ -1953,7 +1953,7 @@ static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      pu32_t data, DRXflags_t flags)
+				      u32 *data, DRXflags_t flags)
 {
 	return drxDapFASIFunct_g.readReg32Func(devAddr, addr, data, flags);
 }
@@ -1962,8 +1962,8 @@ static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
-				       u16_t datasize,
-				       pu8_t data, DRXflags_t flags)
+				       u16 datasize,
+				       u8 *data, DRXflags_t flags)
 {
 	return drxDapFASIFunct_g.writeBlockFunc(devAddr,
 						addr, datasize, data, flags);
@@ -1973,7 +1973,7 @@ static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
-				      u8_t data, DRXflags_t flags)
+				      u8 data, DRXflags_t flags)
 {
 	return drxDapFASIFunct_g.writeReg8Func(devAddr, addr, data, flags);
 }
@@ -1994,7 +1994,7 @@ static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 *
 */
 static DRXStatus_t DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
-					  DRXaddr_t addr, u16_t data)
+					  DRXaddr_t addr, u16 data)
 {
 	DRXStatus_t stat = DRX_STS_ERROR;
 
@@ -2002,10 +2002,10 @@ static DRXStatus_t DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
 	if (DRXDAP_FASI_ADDR2BANK(addr) == 2) {
 		stat = DRX_STS_INVALID_ARG;
 	} else {
-		u32_t startTimer = 0;
-		u32_t currentTimer = 0;
-		u32_t deltaTimer = 0;
-		u16_t trStatus = 0;
+		u32 startTimer = 0;
+		u32 currentTimer = 0;
+		u32 deltaTimer = 0;
+		u16 trStatus = 0;
 		const DRXaddr_t writeBit = ((DRXaddr_t) 1) << 16;
 
 		/* Force write bit */
@@ -2042,7 +2042,7 @@ static DRXStatus_t DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
-				       u16_t data, DRXflags_t flags)
+				       u16 data, DRXflags_t flags)
 {
 	DRXStatus_t stat = DRX_STS_ERROR;
 
@@ -2065,7 +2065,7 @@ static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 
 static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
-				       u32_t data, DRXflags_t flags)
+				       u32 data, DRXflags_t flags)
 {
 	return drxDapFASIFunct_g.writeReg32Func(devAddr, addr, data, flags);
 }
@@ -2096,14 +2096,14 @@ static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 static
 DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
-					  u16_t datasize,
-					  pu8_t data, Bool_t readFlag)
+					  u16 datasize,
+					  u8 *data, Bool_t readFlag)
 {
 	DRXJHiCmd_t hiCmd;
 
-	u16_t word;
-	u16_t dummy = 0;
-	u16_t i = 0;
+	u16 word;
+	u16 dummy = 0;
+	u16 i = 0;
 
 	/* Parameter check */
 	if ((data == NULL) ||
@@ -2115,26 +2115,26 @@ DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 	/* Set up HI parameters to read or write n bytes */
 	hiCmd.cmd = SIO_HI_RA_RAM_CMD_ATOMIC_COPY;
 	hiCmd.param1 =
-	    (u16_t) ((DRXDAP_FASI_ADDR2BLOCK(DRXJ_HI_ATOMIC_BUF_START) << 6) +
+	    (u16) ((DRXDAP_FASI_ADDR2BLOCK(DRXJ_HI_ATOMIC_BUF_START) << 6) +
 		     DRXDAP_FASI_ADDR2BANK(DRXJ_HI_ATOMIC_BUF_START));
 	hiCmd.param2 =
-	    (u16_t) DRXDAP_FASI_ADDR2OFFSET(DRXJ_HI_ATOMIC_BUF_START);
-	hiCmd.param3 = (u16_t) ((datasize / 2) - 1);
+	    (u16) DRXDAP_FASI_ADDR2OFFSET(DRXJ_HI_ATOMIC_BUF_START);
+	hiCmd.param3 = (u16) ((datasize / 2) - 1);
 	if (readFlag == FALSE) {
 		hiCmd.param3 |= DRXJ_HI_ATOMIC_WRITE;
 	} else {
 		hiCmd.param3 |= DRXJ_HI_ATOMIC_READ;
 	}
-	hiCmd.param4 = (u16_t) ((DRXDAP_FASI_ADDR2BLOCK(addr) << 6) +
+	hiCmd.param4 = (u16) ((DRXDAP_FASI_ADDR2BLOCK(addr) << 6) +
 				DRXDAP_FASI_ADDR2BANK(addr));
-	hiCmd.param5 = (u16_t) DRXDAP_FASI_ADDR2OFFSET(addr);
+	hiCmd.param5 = (u16) DRXDAP_FASI_ADDR2OFFSET(addr);
 
 	if (readFlag == FALSE) {
 		/* write data to buffer */
 		for (i = 0; i < (datasize / 2); i++) {
 
-			word = ((u16_t) data[2 * i]);
-			word += (((u16_t) data[(2 * i) + 1]) << 8);
+			word = ((u16) data[2 * i]);
+			word += (((u16) data[(2 * i) + 1]) << 8);
 			DRXJ_DAP_WriteReg16(devAddr,
 					    (DRXJ_HI_ATOMIC_BUF_START + i),
 					    word, 0);
@@ -2149,8 +2149,8 @@ DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 			DRXJ_DAP_ReadReg16(devAddr,
 					   (DRXJ_HI_ATOMIC_BUF_START + i),
 					   &word, 0);
-			data[2 * i] = (u8_t) (word & 0xFF);
-			data[(2 * i) + 1] = (u8_t) (word >> 8);
+			data[2 * i] = (u8) (word & 0xFF);
+			data[(2 * i) + 1] = (u8) (word >> 8);
 		}
 	}
 
@@ -2170,11 +2170,11 @@ rw_error:
 static
 DRXStatus_t DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
-				     pu32_t data, DRXflags_t flags)
+				     u32 *data, DRXflags_t flags)
 {
-	u8_t buf[sizeof(*data)];
+	u8 buf[sizeof(*data)];
 	DRXStatus_t rc = DRX_STS_ERROR;
-	u32_t word = 0;
+	u32 word = 0;
 
 	if (!data) {
 		return DRX_STS_INVALID_ARG;
@@ -2183,13 +2183,13 @@ DRXStatus_t DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
 	rc = DRXJ_DAP_AtomicReadWriteBlock(devAddr, addr,
 					   sizeof(*data), buf, TRUE);
 
-	word = (u32_t) buf[3];
+	word = (u32) buf[3];
 	word <<= 8;
-	word |= (u32_t) buf[2];
+	word |= (u32) buf[2];
 	word <<= 8;
-	word |= (u32_t) buf[1];
+	word |= (u32) buf[1];
 	word <<= 8;
-	word |= (u32_t) buf[0];
+	word |= (u32) buf[0];
 
 	*data = word;
 
@@ -2223,7 +2223,7 @@ static DRXStatus_t HICfgCommand(const pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	DRXJHiCmd_t hiCmd;
-	u16_t result = 0;
+	u16 result = 0;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
@@ -2258,10 +2258,10 @@ rw_error:
 *
 */
 static DRXStatus_t
-HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, pu16_t result)
+HICommand(struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, u16 *result)
 {
-	u16_t waitCmd = 0;
-	u16_t nrRetries = 0;
+	u16 waitCmd = 0;
+	u16 nrRetries = 0;
 	Bool_t powerdown_cmd = FALSE;
 
 	/* Write parameters */
@@ -2350,7 +2350,7 @@ static DRXStatus_t InitHI(const pDRXDemodInstance_t demod)
 	/* Timing div, 250ns/Psys */
 	/* Timing div, = ( delay (nano seconds) * sysclk (kHz) )/ 1000 */
 	extAttr->HICfgTimingDiv =
-	    (u16_t) ((commonAttr->sysClockFreq / 1000) * HI_I2C_DELAY) / 1000;
+	    (u16) ((commonAttr->sysClockFreq / 1000) * HI_I2C_DELAY) / 1000;
 	/* Clipping */
 	if ((extAttr->HICfgTimingDiv) > SIO_HI_RA_RAM_PAR_2_CFG_DIV__M) {
 		extAttr->HICfgTimingDiv = SIO_HI_RA_RAM_PAR_2_CFG_DIV__M;
@@ -2359,7 +2359,7 @@ static DRXStatus_t InitHI(const pDRXDemodInstance_t demod)
 	/* Delay = ( delay (nano seconds) * oscclk (kHz) )/ 1000 */
 	/* SDA brdige delay */
 	extAttr->HICfgBridgeDelay =
-	    (u16_t) ((commonAttr->oscClockFreq / 1000) * HI_I2C_BRIDGE_DELAY) /
+	    (u16) ((commonAttr->oscClockFreq / 1000) * HI_I2C_BRIDGE_DELAY) /
 	    1000;
 	/* Clipping */
 	if ((extAttr->HICfgBridgeDelay) > SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M) {
@@ -2416,9 +2416,9 @@ static DRXStatus_t GetDeviceCapabilities(pDRXDemodInstance_t demod)
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
-	u16_t sioPdrOhwCfg = 0;
-	u32_t sioTopJtagidLo = 0;
-	u16_t bid = 0;
+	u16 sioPdrOhwCfg = 0;
+	u32 sioTopJtagidLo = 0;
+	u16 bid = 0;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -2453,7 +2453,7 @@ static DRXStatus_t GetDeviceCapabilities(pDRXDemodInstance_t demod)
 	   Based on pinning v47
 	 */
 	RR32(devAddr, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo);
-	extAttr->mfx = (u8_t) ((sioTopJtagidLo >> 29) & 0xF);
+	extAttr->mfx = (u8) ((sioTopJtagidLo >> 29) & 0xF);
 
 	switch ((sioTopJtagidLo >> 12) & 0xFF) {
 	case 0x31:
@@ -2589,8 +2589,8 @@ rw_error:
 static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
-	u8_t data = 0;
-	u16_t retryCount = 0;
+	u8 data = 0;
+	u16 retryCount = 0;
 	struct i2c_device_addr wakeUpAddr;
 
 	devAddr = demod->myI2CDevAddr;
@@ -2604,11 +2604,11 @@ static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
 		data = 0;
 		DRXBSP_I2C_WriteRead(&wakeUpAddr, 1, &data,
 				     (struct i2c_device_addr *) (NULL), 0,
-				     (pu8_t) (NULL));
+				     (u8 *) (NULL));
 		DRXBSP_HST_Sleep(10);
 		retryCount++;
 	} while ((DRXBSP_I2C_WriteRead
-		  ((struct i2c_device_addr *) (NULL), 0, (pu8_t) (NULL), devAddr, 1,
+		  ((struct i2c_device_addr *) (NULL), 0, (u8 *) (NULL), devAddr, 1,
 		   &data)
 		  != DRX_STS_OK) && (retryCount < DRXJ_MAX_RETRIES_POWERUP));
 
@@ -2641,15 +2641,15 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	u16_t fecOcRegMode = 0;
-	u16_t fecOcRegIprMode = 0;
-	u16_t fecOcRegIprInvert = 0;
-	u32_t maxBitRate = 0;
-	u32_t rcnRate = 0;
-	u32_t nrBits = 0;
-	u16_t sioPdrMdCfg = 0;
+	u16 fecOcRegMode = 0;
+	u16 fecOcRegIprMode = 0;
+	u16 fecOcRegIprInvert = 0;
+	u32 maxBitRate = 0;
+	u32 rcnRate = 0;
+	u32 nrBits = 0;
+	u16 sioPdrMdCfg = 0;
 	/* data mask for the output data byte */
-	u16_t InvertDataMask =
+	u16 InvertDataMask =
 	    FEC_OC_IPR_INVERT_MD7__M | FEC_OC_IPR_INVERT_MD6__M |
 	    FEC_OC_IPR_INVERT_MD5__M | FEC_OC_IPR_INVERT_MD4__M |
 	    FEC_OC_IPR_INVERT_MD3__M | FEC_OC_IPR_INVERT_MD2__M |
@@ -2784,7 +2784,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 				rcnRate =
 				    (Frac28
 				     (maxBitRate,
-				      (u32_t) (commonAttr->sysClockFreq / 8))) /
+				      (u32) (commonAttr->sysClockFreq / 8))) /
 				    188;
 				break;
 			default:
@@ -2819,7 +2819,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 				rcnRate =
 				    (Frac28
 				     (maxBitRate,
-				      (u32_t) (commonAttr->sysClockFreq / 8))) /
+				      (u32) (commonAttr->sysClockFreq / 8))) /
 				    204;
 				break;
 			default:
@@ -2865,10 +2865,10 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 		}
 
 		if (cfgData->staticCLK == TRUE) {	/* Static mode */
-			u32_t dtoRate = 0;
-			u32_t bitRate = 0;
-			u16_t fecOcDtoBurstLen = 0;
-			u16_t fecOcDtoPeriod = 0;
+			u32 dtoRate = 0;
+			u32 bitRate = 0;
+			u16 fecOcDtoBurstLen = 0;
+			u16 fecOcDtoPeriod = 0;
 
 			fecOcDtoBurstLen = FEC_OC_DTO_BURST_LEN__PRE;
 
@@ -2881,7 +2881,7 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 				break;
 			case DRX_STANDARD_ITU_A:
 				{
-					u32_t symbolRateTh = 6400000;
+					u32 symbolRateTh = 6400000;
 					if (cfgData->insertRSByte == TRUE) {
 						fecOcDtoBurstLen = 204;
 						symbolRateTh = 5900000;
@@ -2916,9 +2916,9 @@ CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 			    Frac28(bitRate, commonAttr->sysClockFreq * 1000);
 			dtoRate >>= 3;
 			WR16(devAddr, FEC_OC_DTO_RATE_HI__A,
-			     (u16_t) ((dtoRate >> 16) & FEC_OC_DTO_RATE_HI__M));
+			     (u16) ((dtoRate >> 16) & FEC_OC_DTO_RATE_HI__M));
 			WR16(devAddr, FEC_OC_DTO_RATE_LO__A,
-			     (u16_t) (dtoRate & FEC_OC_DTO_RATE_LO_RATE_LO__M));
+			     (u16) (dtoRate & FEC_OC_DTO_RATE_LO_RATE_LO__M));
 			WR16(devAddr, FEC_OC_DTO_MODE__A,
 			     FEC_OC_DTO_MODE_DYNAMIC__M |
 			     FEC_OC_DTO_MODE_OFFSET_ENABLE__M);
@@ -3043,9 +3043,9 @@ CtrlGetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
-	u32_t rateReg = 0;
-	u32_t data64Hi = 0;
-	u32_t data64Lo = 0;
+	u32 rateReg = 0;
+	u32 data64Hi = 0;
+	u32 data64Lo = 0;
 
 	if (cfgData == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -3099,9 +3099,9 @@ static DRXStatus_t SetMPEGTEIHandling(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
-	u16_t fecOcDprMode = 0;
-	u16_t fecOcSncMode = 0;
-	u16_t fecOcEmsMode = 0;
+	u16 fecOcDprMode = 0;
+	u16 fecOcSncMode = 0;
+	u16 fecOcEmsMode = 0;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -3147,7 +3147,7 @@ static DRXStatus_t BitReverseMPEGOutput(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
-	u16_t fecOcIprMode = 0;
+	u16 fecOcIprMode = 0;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -3211,7 +3211,7 @@ static DRXStatus_t SetMPEGStartWidth(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
-	u16_t fecOcCommMb = 0;
+	u16 fecOcCommMb = 0;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -3300,7 +3300,7 @@ CtrlGetCfgMpegOutputMisc(pDRXDemodInstance_t demod,
 			 pDRXJCfgMpegOutputMisc_t cfgData)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	u16_t data = 0;
+	u16 data = 0;
 
 	if (cfgData == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -3340,7 +3340,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetCfgHwCfg(pDRXDemodInstance_t demod, pDRXJCfgHwCfg_t cfgData)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 
 	if (cfgData == NULL) {
@@ -3534,8 +3534,8 @@ static DRXStatus_t
 CtrlUIOWrite(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	u16_t pinCfgValue = 0;
-	u16_t value = 0;
+	u16 pinCfgValue = 0;
+	u16 value = 0;
 
 	if ((UIOData == NULL) || (demod == NULL)) {
 		return DRX_STS_INVALID_ARG;
@@ -3679,8 +3679,8 @@ rw_error:
 static DRXStatus_t CtrlUIORead(pDRXDemodInstance_t demod, pDRXUIOData_t UIOData)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	u16_t pinCfgValue = 0;
-	u16_t value = 0;
+	u16 pinCfgValue = 0;
+	u16 value = 0;
 
 	if ((UIOData == NULL) || (demod == NULL)) {
 		return DRX_STS_INVALID_ARG;
@@ -3826,7 +3826,7 @@ static DRXStatus_t
 CtrlI2CBridge(pDRXDemodInstance_t demod, pBool_t bridgeClosed)
 {
 	DRXJHiCmd_t hiCmd;
-	u16_t result = 0;
+	u16 result = 0;
 
 	/* check arguments */
 	if (bridgeClosed == NULL) {
@@ -3860,7 +3860,7 @@ CtrlI2CBridge(pDRXDemodInstance_t demod, pBool_t bridgeClosed)
 */
 static DRXStatus_t SmartAntInit(pDRXDemodInstance_t demod)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 	DRXUIOCfg_t UIOCfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SMA };
@@ -3906,8 +3906,8 @@ CtrlSetCfgSmartAnt(pDRXDemodInstance_t demod, pDRXJCfgSmartAnt_t smartAnt)
 {
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
-	u16_t data = 0;
-	u32_t startTime = 0;
+	u16 data = 0;
+	u32 startTime = 0;
 	static Bool_t bitInverted = FALSE;
 
 	devAddr = demod->myI2CDevAddr;
@@ -3991,8 +3991,8 @@ rw_error:
 
 static DRXStatus_t SCUCommand(struct i2c_device_addr *devAddr, pDRXJSCUCmd_t cmd)
 {
-	u16_t curCmd = 0;
-	u32_t startTime = 0;
+	u16 curCmd = 0;
+	u32 startTime = 0;
 
 	/* Check param */
 	if (cmd == NULL)
@@ -4037,7 +4037,7 @@ static DRXStatus_t SCUCommand(struct i2c_device_addr *devAddr, pDRXJSCUCmd_t cmd
 
 	/* read results */
 	if ((cmd->resultLen > 0) && (cmd->result != NULL)) {
-		s16_t err;
+		s16 err;
 
 		switch (cmd->resultLen) {
 		case 4:
@@ -4060,10 +4060,10 @@ static DRXStatus_t SCUCommand(struct i2c_device_addr *devAddr, pDRXJSCUCmd_t cmd
 		err = cmd->result[0];
 
 		/* check a few fixed error codes */
-		if ((err == (s16_t) SCU_RAM_PARAM_0_RESULT_UNKSTD)
-		    || (err == (s16_t) SCU_RAM_PARAM_0_RESULT_UNKCMD)
-		    || (err == (s16_t) SCU_RAM_PARAM_0_RESULT_INVPAR)
-		    || (err == (s16_t) SCU_RAM_PARAM_0_RESULT_SIZE)
+		if ((err == (s16) SCU_RAM_PARAM_0_RESULT_UNKSTD)
+		    || (err == (s16) SCU_RAM_PARAM_0_RESULT_UNKCMD)
+		    || (err == (s16) SCU_RAM_PARAM_0_RESULT_INVPAR)
+		    || (err == (s16) SCU_RAM_PARAM_0_RESULT_SIZE)
 		    ) {
 			return DRX_STS_INVALID_ARG;
 		}
@@ -4095,12 +4095,12 @@ rw_error:
 */
 #define ADDR_AT_SCU_SPACE(x) ((x - 0x82E000) * 2)
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, DRXaddr_t addr, u16_t datasize,	/* max 30 bytes because the limit of SCU parameter */
-					      pu8_t data, Bool_t readFlag)
+DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, DRXaddr_t addr, u16 datasize,	/* max 30 bytes because the limit of SCU parameter */
+					      u8 *data, Bool_t readFlag)
 {
 	DRXJSCUCmd_t scuCmd;
-	u16_t setParamParameters[15];
-	u16_t cmdResult[15];
+	u16 setParamParameters[15];
+	u16 cmdResult[15];
 
 	/* Parameter check */
 	if ((data == NULL) ||
@@ -4109,7 +4109,7 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, D
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	setParamParameters[1] = (u16_t) ADDR_AT_SCU_SPACE(addr);
+	setParamParameters[1] = (u16) ADDR_AT_SCU_SPACE(addr);
 	if (readFlag) {		/* read */
 		setParamParameters[0] = ((~(0x0080)) & datasize);
 		scuCmd.parameterLen = 2;
@@ -4137,8 +4137,8 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, D
 		int i = 0;
 		/* read data from buffer */
 		for (i = 0; i < (datasize / 2); i++) {
-			data[2 * i] = (u8_t) (scuCmd.result[i + 2] & 0xFF);
-			data[(2 * i) + 1] = (u8_t) (scuCmd.result[i + 2] >> 8);
+			data[2 * i] = (u8) (scuCmd.result[i + 2] & 0xFF);
+			data[(2 * i) + 1] = (u8) (scuCmd.result[i + 2] >> 8);
 		}
 	}
 
@@ -4158,11 +4158,11 @@ rw_error:
 static
 DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
-					 pu16_t data, DRXflags_t flags)
+					 u16 *data, DRXflags_t flags)
 {
-	u8_t buf[2];
+	u8 buf[2];
 	DRXStatus_t rc = DRX_STS_ERROR;
-	u16_t word = 0;
+	u16 word = 0;
 
 	if (!data) {
 		return DRX_STS_INVALID_ARG;
@@ -4170,7 +4170,7 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 
 	rc = DRXJ_DAP_SCU_AtomicReadWriteBlock(devAddr, addr, 2, buf, TRUE);
 
-	word = (u16_t) (buf[0] + (buf[1] << 8));
+	word = (u16) (buf[0] + (buf[1] << 8));
 
 	*data = word;
 
@@ -4185,13 +4185,13 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 static
 DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
-					  u16_t data, DRXflags_t flags)
+					  u16 data, DRXflags_t flags)
 {
-	u8_t buf[2];
+	u8 buf[2];
 	DRXStatus_t rc = DRX_STS_ERROR;
 
-	buf[0] = (u8_t) (data & 0xff);
-	buf[1] = (u8_t) ((data >> 8) & 0xff);
+	buf[0] = (u8) (data & 0xff);
+	buf[1] = (u8) ((data >> 8) & 0xff);
 
 	rc = DRXJ_DAP_SCU_AtomicReadWriteBlock(devAddr, addr, 2, buf, FALSE);
 
@@ -4207,9 +4207,9 @@ CtrlI2CWriteRead(pDRXDemodInstance_t demod, pDRXI2CData_t i2cData)
 DRXStatus_t
 TunerI2CWriteRead(pTUNERInstance_t tuner,
 		  struct i2c_device_addr *wDevAddr,
-		  u16_t wCount,
-		  pu8_t wData,
-		  struct i2c_device_addr *rDevAddr, u16_t rCount, pu8_t rData)
+		  u16 wCount,
+		  u8 *wData,
+		  struct i2c_device_addr *rDevAddr, u16 rCount, u8 *rData)
 {
 	pDRXDemodInstance_t demod;
 	DRXI2CData_t i2cData =
@@ -4230,9 +4230,9 @@ TunerI2CWriteRead(pTUNERInstance_t tuner,
 * \retval DRX_STS_ERROR Failure: I2C error
 *
 */
-static DRXStatus_t ADCSyncMeasurement(pDRXDemodInstance_t demod, pu16_t count)
+static DRXStatus_t ADCSyncMeasurement(pDRXDemodInstance_t demod, u16 *count)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -4277,7 +4277,7 @@ rw_error:
 
 static DRXStatus_t ADCSynchronization(pDRXDemodInstance_t demod)
 {
-	u16_t count = 0;
+	u16 count = 0;
 	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -4286,7 +4286,7 @@ static DRXStatus_t ADCSynchronization(pDRXDemodInstance_t demod)
 
 	if (count == 1) {
 		/* Try sampling on a diffrent edge */
-		u16_t clkNeg = 0;
+		u16 clkNeg = 0;
 
 		RR16(devAddr, IQM_AF_CLKNEG__A, &clkNeg);
 
@@ -4314,7 +4314,7 @@ rw_error:
 */
 static DRXStatus_t IQMSetAf(pDRXDemodInstance_t demod, Bool_t active)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
@@ -4503,8 +4503,8 @@ CtrlGetCfgPdrSafeMode(pDRXDemodInstance_t demod, pBool_t enabled)
 */
 static DRXStatus_t CtrlValidateUCode(pDRXDemodInstance_t demod)
 {
-	u32_t mcDev, mcPatch;
-	u16_t verType;
+	u32 mcDev, mcPatch;
+	u16 verType;
 
 	/* Check device.
 	 *  Disallow microcode if:
@@ -4556,21 +4556,21 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	pDRXJData_t extAttr = NULL;
 	pDRXJCfgAgc_t pAgcRfSettings = NULL;
 	pDRXJCfgAgc_t pAgcIfSettings = NULL;
-	u16_t IngainTgtMax = 0;
-	u16_t clpDirTo = 0;
-	u16_t snsSumMax = 0;
-	u16_t clpSumMax = 0;
-	u16_t snsDirTo = 0;
-	u16_t kiInnergainMin = 0;
-	u16_t agcKi = 0;
-	u16_t kiMax = 0;
-	u16_t ifIaccuHiTgtMin = 0;
-	u16_t data = 0;
-	u16_t agcKiDgain = 0;
-	u16_t kiMin = 0;
-	u16_t clpCtrlMode = 0;
-	u16_t agcRf = 0;
-	u16_t agcIf = 0;
+	u16 IngainTgtMax = 0;
+	u16 clpDirTo = 0;
+	u16 snsSumMax = 0;
+	u16 clpSumMax = 0;
+	u16 snsDirTo = 0;
+	u16 kiInnergainMin = 0;
+	u16 agcKi = 0;
+	u16 kiMax = 0;
+	u16 ifIaccuHiTgtMin = 0;
+	u16 data = 0;
+	u16 agcKiDgain = 0;
+	u16 kiMin = 0;
+	u16 clpCtrlMode = 0;
+	u16 agcRf = 0;
+	u16 agcIf = 0;
 	devAddr = demod->myI2CDevAddr;
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -4578,10 +4578,10 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	switch (extAttr->standard) {
 	case DRX_STANDARD_8VSB:
 		clpSumMax = 1023;
-		clpDirTo = (u16_t) (-9);
+		clpDirTo = (u16) (-9);
 		snsSumMax = 1023;
-		snsDirTo = (u16_t) (-9);
-		kiInnergainMin = (u16_t) (-32768);
+		snsDirTo = (u16) (-9);
+		kiInnergainMin = (u16) (-32768);
 		kiMax = 0x032C;
 		agcKiDgain = 0xC;
 		ifIaccuHiTgtMin = 2047;
@@ -4610,9 +4610,9 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	case DRX_STANDARD_ITU_B:
 		IngainTgtMax = 5119;
 		clpSumMax = 1023;
-		clpDirTo = (u16_t) (-5);
+		clpDirTo = (u16) (-5);
 		snsSumMax = 127;
-		snsDirTo = (u16_t) (-3);
+		snsDirTo = (u16) (-3);
 		kiInnergainMin = 0;
 		kiMax = 0x0657;
 		ifIaccuHiTgtMin = 2047;
@@ -4642,13 +4642,13 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	case DRX_STANDARD_FM:
 		clpSumMax = 1023;
 		snsSumMax = 1023;
-		kiInnergainMin = (u16_t) (-32768);
+		kiInnergainMin = (u16) (-32768);
 		ifIaccuHiTgtMin = 2047;
 		agcKiDgain = 0x7;
 		kiMin = 0x0225;
 		kiMax = 0x0547;
-		clpDirTo = (u16_t) (-9);
-		snsDirTo = (u16_t) (-9);
+		clpDirTo = (u16) (-9);
+		snsDirTo = (u16) (-9);
 		IngainTgtMax = 9000;
 		clpCtrlMode = 1;
 		pAgcIfSettings = &(extAttr->atvIfAgcCfg);
@@ -4661,16 +4661,16 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	case DRX_STANDARD_PAL_SECAM_I:
 		clpSumMax = 1023;
 		snsSumMax = 1023;
-		kiInnergainMin = (u16_t) (-32768);
+		kiInnergainMin = (u16) (-32768);
 		ifIaccuHiTgtMin = 2047;
 		agcKiDgain = 0x7;
 		kiMin = 0x0225;
 		kiMax = 0x0547;
-		clpDirTo = (u16_t) (-9);
+		clpDirTo = (u16) (-9);
 		IngainTgtMax = 9000;
 		pAgcIfSettings = &(extAttr->atvIfAgcCfg);
 		pAgcRfSettings = &(extAttr->atvRfAgcCfg);
-		snsDirTo = (u16_t) (-9);
+		snsDirTo = (u16) (-9);
 		clpCtrlMode = 1;
 		WR16(devAddr, SCU_RAM_AGC_INGAIN_TGT__A, pAgcIfSettings->top);
 		break;
@@ -4678,13 +4678,13 @@ static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 	case DRX_STANDARD_PAL_SECAM_LP:
 		clpSumMax = 1023;
 		snsSumMax = 1023;
-		kiInnergainMin = (u16_t) (-32768);
+		kiInnergainMin = (u16) (-32768);
 		ifIaccuHiTgtMin = 2047;
 		agcKiDgain = 0x7;
 		kiMin = 0x0225;
 		kiMax = 0x0547;
-		clpDirTo = (u16_t) (-9);
-		snsDirTo = (u16_t) (-9);
+		clpDirTo = (u16) (-9);
+		snsDirTo = (u16) (-9);
 		IngainTgtMax = 9000;
 		clpCtrlMode = 1;
 		pAgcIfSettings = &(extAttr->atvIfAgcCfg);
@@ -4768,7 +4768,7 @@ SetFrequency(pDRXDemodInstance_t demod,
 	DRXFrequency_t rfFreqResidual = 0;
 	DRXFrequency_t adcFreq = 0;
 	DRXFrequency_t intermediateFreq = 0;
-	u32_t iqmFsRateOfs = 0;
+	u32 iqmFsRateOfs = 0;
 	pDRXJData_t extAttr = NULL;
 	Bool_t adcFlip = TRUE;
 	Bool_t selectPosImage = FALSE;
@@ -4865,14 +4865,14 @@ rw_error:
 #define DRXJ_RFAGC_MAX  0x3fff
 #define DRXJ_RFAGC_MIN  0x800
 
-static DRXStatus_t GetSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
+static DRXStatus_t GetSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
 {
-	u16_t rfGain = 0;
-	u16_t ifGain = 0;
-	u16_t ifAgcSns = 0;
-	u16_t ifAgcTop = 0;
-	u16_t rfAgcMax = 0;
-	u16_t rfAgcMin = 0;
+	u16 rfGain = 0;
+	u16 ifGain = 0;
+	u16 ifAgcSns = 0;
+	u16 ifAgcTop = 0;
+	u16 rfAgcMax = 0;
+	u16 rfAgcMin = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 
@@ -4924,11 +4924,11 @@ rw_error:
 * \retval DRX_STS_ERROR Erroneous data, sigStrength contains invalid data.
 */
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
-static DRXStatus_t GetAccPktErr(pDRXDemodInstance_t demod, pu16_t packetErr)
+static DRXStatus_t GetAccPktErr(pDRXDemodInstance_t demod, u16 *packetErr)
 {
-	static u16_t pktErr = 0;
-	static u16_t lastPktErr = 0;
-	u16_t data = 0;
+	static u16 pktErr = 0;
+	static u16 lastPktErr = 0;
+	u16 data = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 
@@ -4969,7 +4969,7 @@ static DRXStatus_t CtrlSetCfgResetPktErr(pDRXDemodInstance_t demod)
 {
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
 	pDRXJData_t extAttr = NULL;
-	u16_t packetError = 0;
+	u16 packetError = 0;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	extAttr->resetPktErrAcc = TRUE;
@@ -4987,10 +4987,10 @@ rw_error:
 * \brief Get symbol rate offset in QAM & 8VSB mode
 * \return Error code
 */
-static DRXStatus_t GetSTRFreqOffset(pDRXDemodInstance_t demod, s32_t * STRFreq)
+static DRXStatus_t GetSTRFreqOffset(pDRXDemodInstance_t demod, s32 *STRFreq)
 {
-	u32_t symbolFrequencyRatio = 0;
-	u32_t symbolNomFrequencyRatio = 0;
+	u32 symbolFrequencyRatio = 0;
+	u32 symbolNomFrequencyRatio = 0;
 
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	struct i2c_device_addr *devAddr = NULL;
@@ -5025,15 +5025,15 @@ rw_error:
 * \brief Get the value of CTLFreq in QAM & ATSC mode
 * \return Error code
 */
-static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32_t * CTLFreq)
+static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32 *CTLFreq)
 {
 	DRXFrequency_t samplingFrequency = 0;
-	s32_t currentFrequency = 0;
-	s32_t nominalFrequency = 0;
-	s32_t carrierFrequencyShift = 0;
-	s32_t sign = 1;
-	u32_t data64Hi = 0;
-	u32_t data64Lo = 0;
+	s32 currentFrequency = 0;
+	s32 nominalFrequency = 0;
+	s32 carrierFrequencyShift = 0;
+	s32 sign = 1;
+	u32 data64Hi = 0;
+	u32 data64Lo = 0;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
@@ -5046,7 +5046,7 @@ static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32_t * CTLFreq)
 
 	/* both registers are sign extended */
 	nominalFrequency = extAttr->iqmFsRateOfs;
-	ARR32(devAddr, IQM_FS_RATE_LO__A, (pu32_t) & currentFrequency);
+	ARR32(devAddr, IQM_FS_RATE_LO__A, (u32 *) & currentFrequency);
 
 	if (extAttr->posImage == TRUE) {
 		/* negative image */
@@ -5065,7 +5065,7 @@ static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32_t * CTLFreq)
 	/* *CTLFreq = carrierFrequencyShift * 50.625e6 / (1 << 28); */
 	Mult32(carrierFrequencyShift, samplingFrequency, &data64Hi, &data64Lo);
 	*CTLFreq =
-	    (s32_t) ((((data64Lo >> 28) & 0xf) | (data64Hi << 4)) * sign);
+	    (s32) ((((data64Lo >> 28) & 0xf) | (data64Hi << 4)) * sign);
 
 	return (DRX_STS_OK);
 rw_error:
@@ -5109,7 +5109,7 @@ SetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, Bool_t atomic)
 	     DRXJ_ISQAMSTD(agcSettings->standard)) ||
 	    (DRXJ_ISATVSTD(extAttr->standard) &&
 	     DRXJ_ISATVSTD(agcSettings->standard))) {
-		u16_t data = 0;
+		u16 data = 0;
 
 		switch (agcSettings->ctrlMode) {
 		case DRX_AGC_CTRL_AUTO:
@@ -5348,7 +5348,7 @@ SetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, Bool_t atomic)
 	     DRXJ_ISQAMSTD(agcSettings->standard)) ||
 	    (DRXJ_ISATVSTD(extAttr->standard) &&
 	     DRXJ_ISATVSTD(agcSettings->standard))) {
-		u16_t data = 0;
+		u16 data = 0;
 
 		switch (agcSettings->ctrlMode) {
 		case DRX_AGC_CTRL_AUTO:
@@ -5575,7 +5575,7 @@ rw_error:
 */
 static DRXStatus_t SetIqmAf(pDRXDemodInstance_t demod, Bool_t active)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -5630,7 +5630,7 @@ static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, Bool_t primary)
 		/* *parameter   */ NULL,
 		/* *result      */ NULL
 	};
-	u16_t cmdResult = 0;
+	u16 cmdResult = 0;
 	pDRXJData_t extAttr = NULL;
 	DRXCfgMPEGOutput_t cfgMPEGOutput;
 
@@ -5680,7 +5680,7 @@ static DRXStatus_t SetVSBLeakNGain(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
 
-	const u8_t vsb_ffe_leak_gain_ram0[] = {
+	const u8 vsb_ffe_leak_gain_ram0[] = {
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO1  */
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO2  */
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO3  */
@@ -5811,7 +5811,7 @@ static DRXStatus_t SetVSBLeakNGain(pDRXDemodInstance_t demod)
 		DRXJ_16TO8(0x1010)	/* FIRRCA1GAIN8 */
 	};
 
-	const u8_t vsb_ffe_leak_gain_ram1[] = {
+	const u8 vsb_ffe_leak_gain_ram1[] = {
 		DRXJ_16TO8(0x1010),	/* FIRRCA1GAIN9 */
 		DRXJ_16TO8(0x0808),	/* FIRRCA1GAIN10 */
 		DRXJ_16TO8(0x0808),	/* FIRRCA1GAIN11 */
@@ -5870,9 +5870,9 @@ static DRXStatus_t SetVSBLeakNGain(pDRXDemodInstance_t demod)
 
 	devAddr = demod->myI2CDevAddr;
 	WRB(devAddr, VSB_SYSCTRL_RAM0_FFETRAINLKRATIO1__A,
-	    sizeof(vsb_ffe_leak_gain_ram0), ((pu8_t) vsb_ffe_leak_gain_ram0));
+	    sizeof(vsb_ffe_leak_gain_ram0), ((u8 *) vsb_ffe_leak_gain_ram0));
 	WRB(devAddr, VSB_SYSCTRL_RAM1_FIRRCA1GAIN9__A,
-	    sizeof(vsb_ffe_leak_gain_ram1), ((pu8_t) vsb_ffe_leak_gain_ram1));
+	    sizeof(vsb_ffe_leak_gain_ram1), ((u8 *) vsb_ffe_leak_gain_ram1));
 
 	return (DRX_STS_OK);
 rw_error:
@@ -5889,12 +5889,12 @@ rw_error:
 static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = NULL;
-	u16_t cmdResult = 0;
-	u16_t cmdParam = 0;
+	u16 cmdResult = 0;
+	u16 cmdParam = 0;
 	pDRXCommonAttr_t commonAttr = NULL;
 	DRXJSCUCmd_t cmdSCU;
 	pDRXJData_t extAttr = NULL;
-	const u8_t vsb_taps_re[] = {
+	const u8 vsb_taps_re[] = {
 		DRXJ_16TO8(-2),	/* re0  */
 		DRXJ_16TO8(4),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -5966,9 +5966,9 @@ static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 	WR16(devAddr, IQM_CF_POW_MEAS_LEN__A, 1);
 
 	WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(vsb_taps_re),
-	    ((pu8_t) vsb_taps_re));
+	    ((u8 *) vsb_taps_re));
 	WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(vsb_taps_re),
-	    ((pu8_t) vsb_taps_re));
+	    ((u8 *) vsb_taps_re));
 
 	WR16(devAddr, VSB_TOP_BNTHRESH__A, 330);	/* set higher threshold */
 	WR16(devAddr, VSB_TOP_CLPLASTNUM__A, 90);	/* burst detection on   */
@@ -5980,7 +5980,7 @@ static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 	/* Initialize the FEC Subsystem */
 	WR16(devAddr, FEC_TOP_ANNEX__A, FEC_TOP_ANNEX_D);
 	{
-		u16_t fecOcSncMode = 0;
+		u16 fecOcSncMode = 0;
 		RR16(devAddr, FEC_OC_SNC_MODE__A, &fecOcSncMode);
 		/* output data even when not locked */
 		WR16(devAddr, FEC_OC_SNC_MODE__A,
@@ -5994,7 +5994,7 @@ static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 	WR16(devAddr, VSB_TOP_SNRTH_PT__A, 0xD4);
 	/* no transparent, no A&C framing; parity is set in mpegoutput */
 	{
-		u16_t fecOcRegMode = 0;
+		u16 fecOcRegMode = 0;
 		RR16(devAddr, FEC_OC_MODE__A, &fecOcRegMode);
 		WR16(devAddr, FEC_OC_MODE__A, fecOcRegMode &
 		     (~(FEC_OC_MODE_TRANSPARENT__M
@@ -6101,17 +6101,17 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBPostRSPckErr(struct i2c_device_addr * devAddr, pu16_t PckErrs)
+* \fn static short GetVSBPostRSPckErr(struct i2c_device_addr * devAddr, u16 *PckErrs)
 * \brief Get the values of packet error in 8VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, pu16_t pckErrs)
+static DRXStatus_t GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, u16 *pckErrs)
 {
-	u16_t data = 0;
-	u16_t period = 0;
-	u16_t prescale = 0;
-	u16_t packetErrorsMant = 0;
-	u16_t packetErrorsExp = 0;
+	u16 data = 0;
+	u16 period = 0;
+	u16 prescale = 0;
+	u16 packetErrorsMant = 0;
+	u16 packetErrorsExp = 0;
 
 	RR16(devAddr, FEC_RS_NR_FAILURES__A, &data);
 	packetErrorsMant = data & FEC_RS_NR_FAILURES_FIXED_MANT__M;
@@ -6123,7 +6123,7 @@ static DRXStatus_t GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, pu16_t pc
 	/* 77.3 us is time for per packet */
 	CHK_ZERO(period * prescale);
 	*pckErrs =
-	    (u16_t) FracTimes1e6(packetErrorsMant * (1 << packetErrorsExp),
+	    (u16) FracTimes1e6(packetErrorsMant * (1 << packetErrorsExp),
 				 (period * prescale * 77));
 
 	return (DRX_STS_OK);
@@ -6132,17 +6132,17 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBBer(struct i2c_device_addr * devAddr, pu32_t ber)
+* \fn static short GetVSBBer(struct i2c_device_addr * devAddr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBpostViterbiBer(struct i2c_device_addr *devAddr, pu32_t ber)
+static DRXStatus_t GetVSBpostViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
 {
-	u16_t data = 0;
-	u16_t period = 0;
-	u16_t prescale = 0;
-	u16_t bitErrorsMant = 0;
-	u16_t bitErrorsExp = 0;
+	u16 data = 0;
+	u16 period = 0;
+	u16 prescale = 0;
+	u16 bitErrorsMant = 0;
+	u16 bitErrorsExp = 0;
 
 	RR16(devAddr, FEC_RS_NR_BIT_ERRORS__A, &data);
 	period = FEC_RS_MEASUREMENT_PERIOD;
@@ -6170,13 +6170,13 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBpreViterbiBer(struct i2c_device_addr * devAddr, pu32_t ber)
+* \fn static short GetVSBpreViterbiBer(struct i2c_device_addr * devAddr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, pu32_t ber)
+static DRXStatus_t GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
 {
-	u16_t data = 0;
+	u16 data = 0;
 
 	RR16(devAddr, VSB_TOP_NR_SYM_ERRS__A, &data);
 	*ber =
@@ -6189,17 +6189,17 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBSymbErr(struct i2c_device_addr * devAddr, pu32_t ber)
+* \fn static short GetVSBSymbErr(struct i2c_device_addr * devAddr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBSymbErr(struct i2c_device_addr *devAddr, pu32_t ser)
+static DRXStatus_t GetVSBSymbErr(struct i2c_device_addr *devAddr, u32 *ser)
 {
-	u16_t data = 0;
-	u16_t period = 0;
-	u16_t prescale = 0;
-	u16_t symbErrorsMant = 0;
-	u16_t symbErrorsExp = 0;
+	u16 data = 0;
+	u16 period = 0;
+	u16 prescale = 0;
+	u16 symbErrorsMant = 0;
+	u16 symbErrorsExp = 0;
 
 	RR16(devAddr, FEC_RS_NR_SYMBOL_ERRORS__A, &data);
 	period = FEC_RS_MEASUREMENT_PERIOD;
@@ -6210,7 +6210,7 @@ static DRXStatus_t GetVSBSymbErr(struct i2c_device_addr *devAddr, pu32_t ser)
 	    >> FEC_RS_NR_SYMBOL_ERRORS_EXP__B;
 
 	CHK_ZERO(period * prescale);
-	*ser = (u32_t) FracTimes1e6((symbErrorsMant << symbErrorsExp) * 1000,
+	*ser = (u32) FracTimes1e6((symbErrorsMant << symbErrorsExp) * 1000,
 				    (period * prescale * 77318));
 
 	return (DRX_STS_OK);
@@ -6219,17 +6219,17 @@ rw_error:
 }
 
 /**
-* \fn static DRXStatus_t GetVSBMER(struct i2c_device_addr * devAddr, pu16_t mer)
+* \fn static DRXStatus_t GetVSBMER(struct i2c_device_addr * devAddr, u16 *mer)
 * \brief Get the values of MER
 * \return Error code
 */
-static DRXStatus_t GetVSBMER(struct i2c_device_addr *devAddr, pu16_t mer)
+static DRXStatus_t GetVSBMER(struct i2c_device_addr *devAddr, u16 *mer)
 {
-	u16_t dataHi = 0;
+	u16 dataHi = 0;
 
 	RR16(devAddr, VSB_TOP_ERR_ENERGY_H__A, &dataHi);
 	*mer =
-	    (u16_t) (Log10Times100(21504) - Log10Times100((dataHi << 6) / 52));
+	    (u16) (Log10Times100(21504) - Log10Times100((dataHi << 6) / 52));
 
 	return (DRX_STS_OK);
 rw_error:
@@ -6250,10 +6250,10 @@ CtrlGetVSBConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 {
 	struct i2c_device_addr *devAddr = NULL;
 				       /**< device address                    */
-	u16_t vsbTopCommMb = 0;	       /**< VSB SL MB configuration           */
-	u16_t vsbTopCommMbInit = 0;    /**< VSB SL MB intial configuration    */
-	u16_t re = 0;		       /**< constellation Re part             */
-	u32_t data = 0;
+	u16 vsbTopCommMb = 0;	       /**< VSB SL MB configuration           */
+	u16 vsbTopCommMbInit = 0;    /**< VSB SL MB intial configuration    */
+	u16 re = 0;		       /**< constellation Re part             */
+	u32 data = 0;
 
 	/* read device info */
 	devAddr = demod->myI2CDevAddr;
@@ -6278,7 +6278,7 @@ CtrlGetVSBConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 
 	/* read data */
 	RR32(devAddr, FEC_OC_OCR_GRAB_RD1__A, &data);
-	re = (u16_t) (((data >> 10) & 0x300) | ((data >> 2) & 0xff));
+	re = (u16) (((data >> 10) & 0x300) | ((data >> 2) & 0xff));
 	if (re & 0x0200) {
 		re |= 0xfc00;
 	}
@@ -6318,7 +6318,7 @@ static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, Bool_t primary)
 		/* *parameter   */ NULL,
 		/* *result      */ NULL
 	};
-	u16_t cmdResult = 0;
+	u16 cmdResult = 0;
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXCfgMPEGOutput_t cfgMPEGOutput;
@@ -6382,20 +6382,20 @@ rw_error:
 #ifndef DRXJ_VSB_ONLY
 static DRXStatus_t
 SetQAMMeasurement(pDRXDemodInstance_t demod,
-		  DRXConstellation_t constellation, u32_t symbolRate)
+		  DRXConstellation_t constellation, u32 symbolRate)
 {
 	struct i2c_device_addr *devAddr = NULL;	/* device address for I2C writes */
 	pDRXJData_t extAttr = NULL;	/* Global data container for DRXJ specif data */
-	u32_t fecBitsDesired = 0;	/* BER accounting period */
-	u16_t fecRsPlen = 0;	/* defines RS BER measurement period */
-	u16_t fecRsPrescale = 0;	/* ReedSolomon Measurement Prescale */
-	u32_t fecRsPeriod = 0;	/* Value for corresponding I2C register */
-	u32_t fecRsBitCnt = 0;	/* Actual precise amount of bits */
-	u32_t fecOcSncFailPeriod = 0;	/* Value for corresponding I2C register */
-	u32_t qamVdPeriod = 0;	/* Value for corresponding I2C register */
-	u32_t qamVdBitCnt = 0;	/* Actual precise amount of bits */
-	u16_t fecVdPlen = 0;	/* no of trellis symbols: VD SER measur period */
-	u16_t qamVdPrescale = 0;	/* Viterbi Measurement Prescale */
+	u32 fecBitsDesired = 0;	/* BER accounting period */
+	u16 fecRsPlen = 0;	/* defines RS BER measurement period */
+	u16 fecRsPrescale = 0;	/* ReedSolomon Measurement Prescale */
+	u32 fecRsPeriod = 0;	/* Value for corresponding I2C register */
+	u32 fecRsBitCnt = 0;	/* Actual precise amount of bits */
+	u32 fecOcSncFailPeriod = 0;	/* Value for corresponding I2C register */
+	u32 qamVdPeriod = 0;	/* Value for corresponding I2C register */
+	u32 qamVdBitCnt = 0;	/* Actual precise amount of bits */
+	u16 fecVdPlen = 0;	/* no of trellis symbols: VD SER measur period */
+	u16 qamVdPrescale = 0;	/* Viterbi Measurement Prescale */
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -6476,10 +6476,10 @@ SetQAMMeasurement(pDRXDemodInstance_t demod,
 		return (DRX_STS_INVALID_ARG);
 	}
 
-	WR16(devAddr, FEC_OC_SNC_FAIL_PERIOD__A, (u16_t) fecOcSncFailPeriod);
-	WR16(devAddr, FEC_RS_MEASUREMENT_PERIOD__A, (u16_t) fecRsPeriod);
+	WR16(devAddr, FEC_OC_SNC_FAIL_PERIOD__A, (u16) fecOcSncFailPeriod);
+	WR16(devAddr, FEC_RS_MEASUREMENT_PERIOD__A, (u16) fecRsPeriod);
 	WR16(devAddr, FEC_RS_MEASUREMENT_PRESCALE__A, fecRsPrescale);
-	extAttr->fecRsPeriod = (u16_t) fecRsPeriod;
+	extAttr->fecRsPeriod = (u16) fecRsPeriod;
 	extAttr->fecRsPrescale = fecRsPrescale;
 	WR32(devAddr, SCU_RAM_FEC_ACCUM_CW_CORRECTED_LO__A, 0);
 	WR16(devAddr, SCU_RAM_FEC_MEAS_COUNT__A, 0);
@@ -6524,9 +6524,9 @@ SetQAMMeasurement(pDRXDemodInstance_t demod,
 		qamVdBitCnt *= qamVdPeriod;
 
 		WR16(devAddr, QAM_VD_MEASUREMENT_PERIOD__A,
-		     (u16_t) qamVdPeriod);
+		     (u16) qamVdPeriod);
 		WR16(devAddr, QAM_VD_MEASUREMENT_PRESCALE__A, qamVdPrescale);
-		extAttr->qamVdPeriod = (u16_t) qamVdPeriod;
+		extAttr->qamVdPeriod = (u16) qamVdPeriod;
 		extAttr->qamVdPrescale = qamVdPrescale;
 	}
 
@@ -6546,7 +6546,7 @@ rw_error:
 static DRXStatus_t SetQAM16(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
-	const u8_t qamDqQualFun[] = {
+	const u8 qamDqQualFun[] = {
 		DRXJ_16TO8(2),	/* fun0  */
 		DRXJ_16TO8(2),	/* fun1  */
 		DRXJ_16TO8(2),	/* fun2  */
@@ -6554,7 +6554,7 @@ static DRXStatus_t SetQAM16(pDRXDemodInstance_t demod)
 		DRXJ_16TO8(3),	/* fun4  */
 		DRXJ_16TO8(3),	/* fun5  */
 	};
-	const u8_t qamEqCmaRad[] = {
+	const u8 qamEqCmaRad[] = {
 		DRXJ_16TO8(13517),	/* RAD0  */
 		DRXJ_16TO8(13517),	/* RAD1  */
 		DRXJ_16TO8(13517),	/* RAD2  */
@@ -6564,9 +6564,9 @@ static DRXStatus_t SetQAM16(pDRXDemodInstance_t demod)
 	};
 
 	WRB(devAddr, QAM_DQ_QUAL_FUN0__A, sizeof(qamDqQualFun),
-	    ((pu8_t) qamDqQualFun));
+	    ((u8 *) qamDqQualFun));
 	WRB(devAddr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qamEqCmaRad),
-	    ((pu8_t) qamEqCmaRad));
+	    ((u8 *) qamEqCmaRad));
 
 	WR16(devAddr, SCU_RAM_QAM_FSM_RTH__A, 140);
 	WR16(devAddr, SCU_RAM_QAM_FSM_FTH__A, 50);
@@ -6583,9 +6583,9 @@ static DRXStatus_t SetQAM16(pDRXDemodInstance_t demod)
 	WR16(devAddr, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, 220);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, 25);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, 6);
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16_t) (-24));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16_t) (-65));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16_t) (-127));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) (-24));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) (-65));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) (-127));
 
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
@@ -6626,7 +6626,7 @@ rw_error:
 static DRXStatus_t SetQAM32(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
-	const u8_t qamDqQualFun[] = {
+	const u8 qamDqQualFun[] = {
 		DRXJ_16TO8(3),	/* fun0  */
 		DRXJ_16TO8(3),	/* fun1  */
 		DRXJ_16TO8(3),	/* fun2  */
@@ -6634,7 +6634,7 @@ static DRXStatus_t SetQAM32(pDRXDemodInstance_t demod)
 		DRXJ_16TO8(4),	/* fun4  */
 		DRXJ_16TO8(4),	/* fun5  */
 	};
-	const u8_t qamEqCmaRad[] = {
+	const u8 qamEqCmaRad[] = {
 		DRXJ_16TO8(6707),	/* RAD0  */
 		DRXJ_16TO8(6707),	/* RAD1  */
 		DRXJ_16TO8(6707),	/* RAD2  */
@@ -6644,9 +6644,9 @@ static DRXStatus_t SetQAM32(pDRXDemodInstance_t demod)
 	};
 
 	WRB(devAddr, QAM_DQ_QUAL_FUN0__A, sizeof(qamDqQualFun),
-	    ((pu8_t) qamDqQualFun));
+	    ((u8 *) qamDqQualFun));
 	WRB(devAddr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qamEqCmaRad),
-	    ((pu8_t) qamEqCmaRad));
+	    ((u8 *) qamEqCmaRad));
 
 	WR16(devAddr, SCU_RAM_QAM_FSM_RTH__A, 90);
 	WR16(devAddr, SCU_RAM_QAM_FSM_FTH__A, 50);
@@ -6661,11 +6661,11 @@ static DRXStatus_t SetQAM32(pDRXDemodInstance_t demod)
 
 	WR16(devAddr, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, 12);
 	WR16(devAddr, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, 140);
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16_t) (-8));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16_t) (-16));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16_t) (-26));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16_t) (-56));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16_t) (-86));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) (-8));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) (-16));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) (-26));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) (-56));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) (-86));
 
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
@@ -6706,7 +6706,7 @@ rw_error:
 static DRXStatus_t SetQAM64(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
-	const u8_t qamDqQualFun[] = {	/* this is hw reset value. no necessary to re-write */
+	const u8 qamDqQualFun[] = {	/* this is hw reset value. no necessary to re-write */
 		DRXJ_16TO8(4),	/* fun0  */
 		DRXJ_16TO8(4),	/* fun1  */
 		DRXJ_16TO8(4),	/* fun2  */
@@ -6714,7 +6714,7 @@ static DRXStatus_t SetQAM64(pDRXDemodInstance_t demod)
 		DRXJ_16TO8(6),	/* fun4  */
 		DRXJ_16TO8(6),	/* fun5  */
 	};
-	const u8_t qamEqCmaRad[] = {
+	const u8 qamEqCmaRad[] = {
 		DRXJ_16TO8(13336),	/* RAD0  */
 		DRXJ_16TO8(12618),	/* RAD1  */
 		DRXJ_16TO8(11988),	/* RAD2  */
@@ -6724,9 +6724,9 @@ static DRXStatus_t SetQAM64(pDRXDemodInstance_t demod)
 	};
 
 	WRB(devAddr, QAM_DQ_QUAL_FUN0__A, sizeof(qamDqQualFun),
-	    ((pu8_t) qamDqQualFun));
+	    ((u8 *) qamDqQualFun));
 	WRB(devAddr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qamEqCmaRad),
-	    ((pu8_t) qamEqCmaRad));
+	    ((u8 *) qamEqCmaRad));
 
 	WR16(devAddr, SCU_RAM_QAM_FSM_RTH__A, 105);
 	WR16(devAddr, SCU_RAM_QAM_FSM_FTH__A, 60);
@@ -6743,9 +6743,9 @@ static DRXStatus_t SetQAM64(pDRXDemodInstance_t demod)
 	WR16(devAddr, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, 141);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, 7);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, 0);
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16_t) (-15));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16_t) (-45));
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16_t) (-80));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) (-15));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) (-45));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) (-80));
 
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
@@ -6786,7 +6786,7 @@ rw_error:
 static DRXStatus_t SetQAM128(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
-	const u8_t qamDqQualFun[] = {
+	const u8 qamDqQualFun[] = {
 		DRXJ_16TO8(6),	/* fun0  */
 		DRXJ_16TO8(6),	/* fun1  */
 		DRXJ_16TO8(6),	/* fun2  */
@@ -6794,7 +6794,7 @@ static DRXStatus_t SetQAM128(pDRXDemodInstance_t demod)
 		DRXJ_16TO8(9),	/* fun4  */
 		DRXJ_16TO8(9),	/* fun5  */
 	};
-	const u8_t qamEqCmaRad[] = {
+	const u8 qamEqCmaRad[] = {
 		DRXJ_16TO8(6164),	/* RAD0  */
 		DRXJ_16TO8(6598),	/* RAD1  */
 		DRXJ_16TO8(6394),	/* RAD2  */
@@ -6804,9 +6804,9 @@ static DRXStatus_t SetQAM128(pDRXDemodInstance_t demod)
 	};
 
 	WRB(devAddr, QAM_DQ_QUAL_FUN0__A, sizeof(qamDqQualFun),
-	    ((pu8_t) qamDqQualFun));
+	    ((u8 *) qamDqQualFun));
 	WRB(devAddr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qamEqCmaRad),
-	    ((pu8_t) qamEqCmaRad));
+	    ((u8 *) qamEqCmaRad));
 
 	WR16(devAddr, SCU_RAM_QAM_FSM_RTH__A, 50);
 	WR16(devAddr, SCU_RAM_QAM_FSM_FTH__A, 60);
@@ -6823,9 +6823,9 @@ static DRXStatus_t SetQAM128(pDRXDemodInstance_t demod)
 	WR16(devAddr, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, 65);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, 5);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, 3);
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16_t) (-1));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) (-1));
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, 12);
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16_t) (-23));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) (-23));
 
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
@@ -6866,7 +6866,7 @@ rw_error:
 static DRXStatus_t SetQAM256(pDRXDemodInstance_t demod)
 {
 	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
-	const u8_t qamDqQualFun[] = {
+	const u8 qamDqQualFun[] = {
 		DRXJ_16TO8(8),	/* fun0  */
 		DRXJ_16TO8(8),	/* fun1  */
 		DRXJ_16TO8(8),	/* fun2  */
@@ -6874,7 +6874,7 @@ static DRXStatus_t SetQAM256(pDRXDemodInstance_t demod)
 		DRXJ_16TO8(12),	/* fun4  */
 		DRXJ_16TO8(12),	/* fun5  */
 	};
-	const u8_t qamEqCmaRad[] = {
+	const u8 qamEqCmaRad[] = {
 		DRXJ_16TO8(12345),	/* RAD0  */
 		DRXJ_16TO8(12345),	/* RAD1  */
 		DRXJ_16TO8(13626),	/* RAD2  */
@@ -6884,9 +6884,9 @@ static DRXStatus_t SetQAM256(pDRXDemodInstance_t demod)
 	};
 
 	WRB(devAddr, QAM_DQ_QUAL_FUN0__A, sizeof(qamDqQualFun),
-	    ((pu8_t) qamDqQualFun));
+	    ((u8 *) qamDqQualFun));
 	WRB(devAddr, SCU_RAM_QAM_EQ_CMA_RAD0__A, sizeof(qamEqCmaRad),
-	    ((pu8_t) qamEqCmaRad));
+	    ((u8 *) qamEqCmaRad));
 
 	WR16(devAddr, SCU_RAM_QAM_FSM_RTH__A, 50);
 	WR16(devAddr, SCU_RAM_QAM_FSM_FTH__A, 60);
@@ -6905,7 +6905,7 @@ static DRXStatus_t SetQAM256(pDRXDemodInstance_t demod)
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, 13);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, 7);
 	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, 0);
-	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16_t) (-8));
+	WR16(devAddr, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) (-8));
 
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_FINE__A, 15);
 	WR16(devAddr, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
@@ -6949,25 +6949,25 @@ rw_error:
 */
 static DRXStatus_t
 SetQAM(pDRXDemodInstance_t demod,
-       pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset, u32_t op)
+       pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset, u32 op)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
-	u16_t cmdResult = 0;
-	u32_t adcFrequency = 0;
-	u32_t iqmRcRate = 0;
-	u16_t lcSymbolFreq = 0;
-	u16_t iqmRcStretch = 0;
-	u16_t setEnvParameters = 0;
-	u16_t setParamParameters[2] = { 0 };
+	u16 cmdResult = 0;
+	u32 adcFrequency = 0;
+	u32 iqmRcRate = 0;
+	u16 lcSymbolFreq = 0;
+	u16 iqmRcStretch = 0;
+	u16 setEnvParameters = 0;
+	u16 setParamParameters[2] = { 0 };
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
 		/* resultLen    */ 0,
 		/* parameter    */ NULL,
 		/* result       */ NULL
 	};
-	const u8_t qamA_taps[] = {
+	const u8 qamA_taps[] = {
 		DRXJ_16TO8(-1),	/* re0  */
 		DRXJ_16TO8(1),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -6997,7 +6997,7 @@ SetQAM(pDRXDemodInstance_t demod,
 		DRXJ_16TO8(-40),	/* re26 */
 		DRXJ_16TO8(619)	/* re27 */
 	};
-	const u8_t qamB64_taps[] = {
+	const u8 qamB64_taps[] = {
 		DRXJ_16TO8(0),	/* re0  */
 		DRXJ_16TO8(-2),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -7027,7 +7027,7 @@ SetQAM(pDRXDemodInstance_t demod,
 		DRXJ_16TO8(-46),	/* re26 */
 		DRXJ_16TO8(614)	/* re27 */
 	};
-	const u8_t qamB256_taps[] = {
+	const u8 qamB256_taps[] = {
 		DRXJ_16TO8(-2),	/* re0  */
 		DRXJ_16TO8(4),	/* re1  */
 		DRXJ_16TO8(1),	/* re2  */
@@ -7057,7 +7057,7 @@ SetQAM(pDRXDemodInstance_t demod,
 		DRXJ_16TO8(-32),	/* re26 */
 		DRXJ_16TO8(628)	/* re27 */
 	};
-	const u8_t qamC_taps[] = {
+	const u8 qamC_taps[] = {
 		DRXJ_16TO8(-3),	/* re0  */
 		DRXJ_16TO8(3),	/* re1  */
 		DRXJ_16TO8(2),	/* re2  */
@@ -7120,7 +7120,7 @@ SetQAM(pDRXDemodInstance_t demod,
 			     ((adcFrequency % channel->symbolrate),
 			      channel->symbolrate) >> 7) - (1 << 23);
 			lcSymbolFreq =
-			    (u16_t) (Frac28
+			    (u16) (Frac28
 				     (channel->symbolrate +
 				      (adcFrequency >> 13),
 				      adcFrequency) >> 16);
@@ -7308,33 +7308,33 @@ SetQAM(pDRXDemodInstance_t demod,
 	if ((op & QAM_SET_OP_ALL) || (op & QAM_SET_OP_CONSTELLATION)) {
 		if (extAttr->standard == DRX_STANDARD_ITU_A) {
 			WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(qamA_taps),
-			    ((pu8_t) qamA_taps));
+			    ((u8 *) qamA_taps));
 			WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(qamA_taps),
-			    ((pu8_t) qamA_taps));
+			    ((u8 *) qamA_taps));
 		} else if (extAttr->standard == DRX_STANDARD_ITU_B) {
 			switch (channel->constellation) {
 			case DRX_CONSTELLATION_QAM64:
 				WRB(devAddr, IQM_CF_TAP_RE0__A,
-				    sizeof(qamB64_taps), ((pu8_t) qamB64_taps));
+				    sizeof(qamB64_taps), ((u8 *) qamB64_taps));
 				WRB(devAddr, IQM_CF_TAP_IM0__A,
-				    sizeof(qamB64_taps), ((pu8_t) qamB64_taps));
+				    sizeof(qamB64_taps), ((u8 *) qamB64_taps));
 				break;
 			case DRX_CONSTELLATION_QAM256:
 				WRB(devAddr, IQM_CF_TAP_RE0__A,
 				    sizeof(qamB256_taps),
-				    ((pu8_t) qamB256_taps));
+				    ((u8 *) qamB256_taps));
 				WRB(devAddr, IQM_CF_TAP_IM0__A,
 				    sizeof(qamB256_taps),
-				    ((pu8_t) qamB256_taps));
+				    ((u8 *) qamB256_taps));
 				break;
 			default:
 				return (DRX_STS_ERROR);
 			}
 		} else if (extAttr->standard == DRX_STANDARD_ITU_C) {
 			WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(qamC_taps),
-			    ((pu8_t) qamC_taps));
+			    ((u8 *) qamC_taps));
 			WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(qamC_taps),
-			    ((pu8_t) qamC_taps));
+			    ((u8 *) qamC_taps));
 		}
 
 		/* SETP 4: constellation specific setup */
@@ -7414,12 +7414,12 @@ static DRXStatus_t
 CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality);
 static DRXStatus_t qamFlipSpec(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
-	u32_t iqmFsRateOfs = 0;
-	u32_t iqmFsRateLo = 0;
-	u16_t qamCtlEna = 0;
-	u16_t data = 0;
-	u16_t equMode = 0;
-	u16_t fsmState = 0;
+	u32 iqmFsRateOfs = 0;
+	u32 iqmFsRateLo = 0;
+	u16 qamCtlEna = 0;
+	u16 data = 0;
+	u16 equMode = 0;
+	u16 fsmState = 0;
 	int i = 0;
 	int ofsofs = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -7514,12 +7514,12 @@ QAM64Auto(pDRXDemodInstance_t demod,
 	  DRXFrequency_t tunerFreqOffset, pDRXLockStatus_t lockStatus)
 {
 	DRXSigQuality_t sigQuality;
-	u16_t data = 0;
-	u32_t state = NO_LOCK;
-	u32_t startTime = 0;
-	u32_t dLockedTime = 0;
+	u16 data = 0;
+	u32 state = NO_LOCK;
+	u32 startTime = 0;
+	u32 dLockedTime = 0;
 	pDRXJData_t extAttr = NULL;
-	u32_t timeoutOfs = 0;
+	u32 timeoutOfs = 0;
 
 	/* external attributes for storing aquired channel constellation */
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -7628,11 +7628,11 @@ QAM256Auto(pDRXDemodInstance_t demod,
 	   DRXFrequency_t tunerFreqOffset, pDRXLockStatus_t lockStatus)
 {
 	DRXSigQuality_t sigQuality;
-	u32_t state = NO_LOCK;
-	u32_t startTime = 0;
-	u32_t dLockedTime = 0;
+	u32 state = NO_LOCK;
+	u32 startTime = 0;
+	u32 dLockedTime = 0;
 	pDRXJData_t extAttr = NULL;
-	u32_t timeoutOfs = DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;
+	u32 timeoutOfs = DRXJ_QAM_DEMOD_LOCK_EXT_WAITTIME;
 
 	/* external attributes for storing aquired channel constellation */
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -7763,7 +7763,7 @@ SetQAMChannel(pDRXDemodInstance_t demod,
 					extAttr->mirror = channel->mirror;
 				}
 				{
-					u16_t qamCtlEna = 0;
+					u16 qamCtlEna = 0;
 					RR16(demod->myI2CDevAddr,
 					     SCU_RAM_QAM_CTL_ENA__A,
 					     &qamCtlEna);
@@ -7796,7 +7796,7 @@ SetQAMChannel(pDRXDemodInstance_t demod,
 				extAttr->mirror = channel->mirror;
 			}
 			{
-				u16_t qamCtlEna = 0;
+				u16 qamCtlEna = 0;
 				RR16(demod->myI2CDevAddr,
 				     SCU_RAM_QAM_CTL_ENA__A, &qamCtlEna);
 				WR16(demod->myI2CDevAddr,
@@ -7844,7 +7844,7 @@ rw_error:
 static DRXStatus_t
 GetQAMRSErrCount(struct i2c_device_addr *devAddr, pDRXJRSErrors_t RSErrors)
 {
-	u16_t nrBitErrors = 0,
+	u16 nrBitErrors = 0,
 	    nrSymbolErrors = 0,
 	    nrPacketErrors = 0, nrFailures = 0, nrSncParFailCount = 0;
 
@@ -7903,29 +7903,29 @@ CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 	DRXConstellation_t constellation = DRX_CONSTELLATION_UNKNOWN;
 	DRXJRSErrors_t measuredRSErrors = { 0, 0, 0, 0, 0 };
 
-	u32_t preBitErrRS = 0;	/* pre RedSolomon Bit Error Rate */
-	u32_t postBitErrRS = 0;	/* post RedSolomon Bit Error Rate */
-	u32_t pktErrs = 0;	/* no of packet errors in RS */
-	u16_t qamSlErrPower = 0;	/* accumulated error between raw and sliced symbols */
-	u16_t qsymErrVD = 0;	/* quadrature symbol errors in QAM_VD */
-	u16_t fecOcPeriod = 0;	/* SNC sync failure measurement period */
-	u16_t fecRsPrescale = 0;	/* ReedSolomon Measurement Prescale */
-	u16_t fecRsPeriod = 0;	/* Value for corresponding I2C register */
+	u32 preBitErrRS = 0;	/* pre RedSolomon Bit Error Rate */
+	u32 postBitErrRS = 0;	/* post RedSolomon Bit Error Rate */
+	u32 pktErrs = 0;	/* no of packet errors in RS */
+	u16 qamSlErrPower = 0;	/* accumulated error between raw and sliced symbols */
+	u16 qsymErrVD = 0;	/* quadrature symbol errors in QAM_VD */
+	u16 fecOcPeriod = 0;	/* SNC sync failure measurement period */
+	u16 fecRsPrescale = 0;	/* ReedSolomon Measurement Prescale */
+	u16 fecRsPeriod = 0;	/* Value for corresponding I2C register */
 	/* calculation constants */
-	u32_t rsBitCnt = 0;	/* RedSolomon Bit Count */
-	u32_t qamSlSigPower = 0;	/* used for MER, depends of QAM constellation */
+	u32 rsBitCnt = 0;	/* RedSolomon Bit Count */
+	u32 qamSlSigPower = 0;	/* used for MER, depends of QAM constellation */
 	/* intermediate results */
-	u32_t e = 0;		/* exponent value used for QAM BER/SER */
-	u32_t m = 0;		/* mantisa value used for QAM BER/SER */
-	u32_t berCnt = 0;	/* BER count */
+	u32 e = 0;		/* exponent value used for QAM BER/SER */
+	u32 m = 0;		/* mantisa value used for QAM BER/SER */
+	u32 berCnt = 0;	/* BER count */
 	/* signal quality info */
-	u32_t qamSlMer = 0;	/* QAM MER */
-	u32_t qamPreRSBer = 0;	/* Pre RedSolomon BER */
-	u32_t qamPostRSBer = 0;	/* Post RedSolomon BER */
-	u32_t qamVDSer = 0;	/* ViterbiDecoder SER */
-	u16_t qamVdPrescale = 0;	/* Viterbi Measurement Prescale */
-	u16_t qamVdPeriod = 0;	/* Viterbi Measurement period */
-	u32_t vdBitCnt = 0;	/* ViterbiDecoder Bit Count */
+	u32 qamSlMer = 0;	/* QAM MER */
+	u32 qamPreRSBer = 0;	/* Pre RedSolomon BER */
+	u32 qamPostRSBer = 0;	/* Post RedSolomon BER */
+	u32 qamVDSer = 0;	/* ViterbiDecoder SER */
+	u16 qamVdPrescale = 0;	/* Viterbi Measurement Prescale */
+	u16 qamVdPeriod = 0;	/* Viterbi Measurement period */
+	u32 vdBitCnt = 0;	/* ViterbiDecoder Bit Count */
 
 	/* get device basic information */
 	devAddr = demod->myI2CDevAddr;
@@ -7980,7 +7980,7 @@ CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 	else
 		qamSlMer =
 		    Log10Times100(qamSlSigPower) -
-		    Log10Times100((u32_t) qamSlErrPower);
+		    Log10Times100((u32) qamSlErrPower);
 
 	/* ----------------------------------------- */
 	/* Pre Viterbi Symbol Error Rate Calculation */
@@ -8011,8 +8011,8 @@ CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 	/* pre RS BER is good if it is below 3.5e-4 */
 
 	/* get the register values */
-	preBitErrRS = (u32_t) measuredRSErrors.nrBitErrors;
-	pktErrs = postBitErrRS = (u32_t) measuredRSErrors.nrSncParFailCount;
+	preBitErrRS = (u32) measuredRSErrors.nrBitErrors;
+	pktErrs = postBitErrRS = (u32) measuredRSErrors.nrSncParFailCount;
 
 	/* Extract the Exponent and the Mantisa of the */
 	/* pre Reed-Solomon bit error count            */
@@ -8049,7 +8049,7 @@ CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 		qamPostRSBer = e / m;
 
 	/* fill signal quality data structure */
-	sigQuality->MER = ((u16_t) qamSlMer);
+	sigQuality->MER = ((u16) qamSlMer);
 	if (extAttr->standard == DRX_STANDARD_ITU_B) {
 		sigQuality->preViterbiBER = qamVDSer;
 	} else {
@@ -8057,11 +8057,11 @@ CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 	}
 	sigQuality->postViterbiBER = qamPreRSBer;
 	sigQuality->postReedSolomonBER = qamPostRSBer;
-	sigQuality->scaleFactorBER = ((u32_t) 1000000);
+	sigQuality->scaleFactorBER = ((u32) 1000000);
 #ifdef DRXJ_SIGNAL_ACCUM_ERR
 	CHK_ERROR(GetAccPktErr(demod, &sigQuality->packetError));
 #else
-	sigQuality->packetError = ((u16_t) pktErrs);
+	sigQuality->packetError = ((u16) pktErrs);
 #endif
 
 	return (DRX_STS_OK);
@@ -8080,14 +8080,14 @@ rw_error:
 static DRXStatus_t
 CtrlGetQAMConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 {
-	u16_t fecOcOcrMode = 0;
+	u16 fecOcOcrMode = 0;
 			      /**< FEC OCR grabber configuration        */
-	u16_t qamSlCommMb = 0;/**< QAM SL MB configuration              */
-	u16_t qamSlCommMbInit = 0;
+	u16 qamSlCommMb = 0;/**< QAM SL MB configuration              */
+	u16 qamSlCommMbInit = 0;
 			      /**< QAM SL MB intial configuration       */
-	u16_t im = 0;	      /**< constellation Im part                */
-	u16_t re = 0;	      /**< constellation Re part                */
-	u32_t data = 0;
+	u16 im = 0;	      /**< constellation Im part                */
+	u16 re = 0;	      /**< constellation Re part                */
+	u32 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
 				     /**< device address */
 
@@ -8127,8 +8127,8 @@ CtrlGetQAMConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 
 	/* read data */
 	RR32(devAddr, FEC_OC_OCR_GRAB_RD0__A, &data);
-	re = (u16_t) (data & FEC_OC_OCR_GRAB_RD0__M);
-	im = (u16_t) ((data >> 16) & FEC_OC_OCR_GRAB_RD1__M);
+	re = (u16) (data & FEC_OC_OCR_GRAB_RD0__M);
+	im = (u16) ((data >> 16) & FEC_OC_OCR_GRAB_RD1__M);
 
 	/* TODO: */
 	/* interpret data (re & im) according to the Monitor bus mapping ?? */
@@ -8140,8 +8140,8 @@ CtrlGetQAMConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 	if ((im & 0x0200) == 0x0200) {
 		im |= 0xFC00;
 	}
-	complexNr->re = ((s16_t) re);
-	complexNr->im = ((s16_t) im);
+	complexNr->re = ((s16) re);
+	complexNr->im = ((s16) im);
 
 	/* Restore MB (Monitor bus) */
 	WR16(devAddr, QAM_SL_COMM_MB__A, qamSlCommMbInit);
@@ -8290,10 +8290,10 @@ AtvUpdateConfig(pDRXDemodInstance_t demod, Bool_t forceUpdate)
 
 	/* bypass fast carrier recovery */
 	if (forceUpdate) {
-		u16_t data = 0;
+		u16 data = 0;
 
 		RR16(devAddr, IQM_RT_ROT_BP__A, &data);
-		data &= (~((u16_t) IQM_RT_ROT_BP_ROT_OFF__M));
+		data &= (~((u16) IQM_RT_ROT_BP_ROT_OFF__M));
 		if (extAttr->phaseCorrectionBypass) {
 			data |= IQM_RT_ROT_BP_ROT_OFF_OFF;
 		} else {
@@ -8317,7 +8317,7 @@ AtvUpdateConfig(pDRXDemodInstance_t demod, Bool_t forceUpdate)
 	/* SIF attenuation */
 	if (forceUpdate ||
 	    ((extAttr->atvCfgChangedFlags & DRXJ_ATV_CHANGED_SIF_ATT) != 0)) {
-		u16_t attenuation = 0;
+		u16 attenuation = 0;
 
 		switch (extAttr->sifAttenuation) {
 		case DRXJ_SIF_ATTENUATION_0DB:
@@ -8342,7 +8342,7 @@ AtvUpdateConfig(pDRXDemodInstance_t demod, Bool_t forceUpdate)
 	/* SIF & CVBS enable */
 	if (forceUpdate ||
 	    ((extAttr->atvCfgChangedFlags & DRXJ_ATV_CHANGED_OUTPUT) != 0)) {
-		u16_t data = 0;
+		u16 data = 0;
 
 		RR16(devAddr, ATV_TOP_STDBY__A, &data);
 		if (extAttr->enableCVBSOutput) {
@@ -8451,10 +8451,10 @@ CtrlSetCfgAtvEquCoef(pDRXDemodInstance_t demod, pDRXJCfgAtvEquCoef_t coef)
 	    (coef->coef1 > (ATV_TOP_EQU1_EQU_C1__M / 2)) ||
 	    (coef->coef2 > (ATV_TOP_EQU2_EQU_C2__M / 2)) ||
 	    (coef->coef3 > (ATV_TOP_EQU3_EQU_C3__M / 2)) ||
-	    (coef->coef0 < ((s16_t) ~ (ATV_TOP_EQU0_EQU_C0__M >> 1))) ||
-	    (coef->coef1 < ((s16_t) ~ (ATV_TOP_EQU1_EQU_C1__M >> 1))) ||
-	    (coef->coef2 < ((s16_t) ~ (ATV_TOP_EQU2_EQU_C2__M >> 1))) ||
-	    (coef->coef3 < ((s16_t) ~ (ATV_TOP_EQU3_EQU_C3__M >> 1)))) {
+	    (coef->coef0 < ((s16) ~ (ATV_TOP_EQU0_EQU_C0__M >> 1))) ||
+	    (coef->coef1 < ((s16) ~ (ATV_TOP_EQU1_EQU_C1__M >> 1))) ||
+	    (coef->coef2 < ((s16) ~ (ATV_TOP_EQU2_EQU_C2__M >> 1))) ||
+	    (coef->coef3 < ((s16) ~ (ATV_TOP_EQU3_EQU_C3__M >> 1)))) {
 		return (DRX_STS_INVALID_ARG);
 	}
 
@@ -8531,8 +8531,8 @@ CtrlSetCfgAtvMisc(pDRXDemodInstance_t demod, pDRXJCfgAtvMisc_t settings)
 
 	/* Check arguments */
 	if ((settings == NULL) ||
-	    ((settings->peakFilter) < (s16_t) (-8)) ||
-	    ((settings->peakFilter) > (s16_t) (15)) ||
+	    ((settings->peakFilter) < (s16) (-8)) ||
+	    ((settings->peakFilter) > (s16) (15)) ||
 	    ((settings->noiseFilter) > 15)) {
 		return (DRX_STS_INVALID_ARG);
 	}
@@ -8601,7 +8601,7 @@ CtrlGetCfgAtvMisc(pDRXDemodInstance_t demod, pDRXJCfgAtvMisc_t settings)
 static DRXStatus_t
 CtrlGetCfgAtvOutput(pDRXDemodInstance_t demod, pDRXJCfgAtvOutput_t outputCfg)
 {
-	u16_t data = 0;
+	u16 data = 0;
 
 	/* Check arguments */
 	if (outputCfg == NULL) {
@@ -8643,8 +8643,8 @@ CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	u16_t data = 0;
-	u32_t tmp = 0;
+	u16 data = 0;
+	u32 tmp = 0;
 
 	/* Check arguments */
 	if (agcStatus == NULL) {
@@ -8661,8 +8661,8 @@ CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 	   IQM_AF_AGC_RF__A * 27 is 20 bits worst case.
 	 */
 	RR16(devAddr, IQM_AF_AGC_RF__A, &data);
-	tmp = ((u32_t) data) * 27 - ((u32_t) (data >> 2));	/* nA */
-	agcStatus->rfAgcGain = (u16_t) (tmp / 1000);	/* uA */
+	tmp = ((u32) data) * 27 - ((u32) (data >> 2));	/* nA */
+	agcStatus->rfAgcGain = (u16) (tmp / 1000);	/* uA */
 	/* rounding */
 	if (tmp % 1000 >= 500) {
 		(agcStatus->rfAgcGain)++;
@@ -8675,8 +8675,8 @@ CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 	   IQM_AF_AGC_IF__A * 27 is 20 bits worst case.
 	 */
 	RR16(devAddr, IQM_AF_AGC_IF__A, &data);
-	tmp = ((u32_t) data) * 27 - ((u32_t) (data >> 2));	/* nA */
-	agcStatus->ifAgcGain = (u16_t) (tmp / 1000);	/* uA */
+	tmp = ((u32) data) * 27 - ((u32) (data >> 2));	/* nA */
+	agcStatus->ifAgcGain = (u16) (tmp / 1000);	/* uA */
 	/* rounding */
 	if (tmp % 1000 >= 500) {
 		(agcStatus->ifAgcGain)++;
@@ -8697,7 +8697,7 @@ CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 		data++;
 	}
 	data >>= 1;
-	agcStatus->videoAgcGain = ((s16_t) data) - 75;	/* 0.1 dB */
+	agcStatus->videoAgcGain = ((s16) data) - 75;	/* 0.1 dB */
 
 	/*
 	   audioGain = (SCU_RAM_ATV_SIF_GAIN__A -8)* 0.05 (dB)
@@ -8714,7 +8714,7 @@ CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 		data++;
 	}
 	data >>= 1;
-	agcStatus->audioAgcGain = ((s16_t) data) - 4;	/* 0.1 dB */
+	agcStatus->audioAgcGain = ((s16) data) - 4;	/* 0.1 dB */
 
 	/* Loop gain's */
 	SARR16(devAddr, SCU_RAM_AGC_KI__A, &data);
@@ -8789,7 +8789,7 @@ PowerDownATV(pDRXDemodInstance_t demod, DRXStandard_t standard, Bool_t primary)
 		/* *parameter   */ NULL,
 		/* *result      */ NULL
 	};
-	u16_t cmdResult = 0;
+	u16 cmdResult = 0;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -8859,7 +8859,7 @@ switch DRXJ_ATV_COEF_FILE="customer_coefs.c.inc".
 Still to check if this will work; DRXJ_16TO8 macro may cause
 trouble ?
 */
-	const u8_t ntsc_taps_re[] = {
+	const u8 ntsc_taps_re[] = {
 		DRXJ_16TO8(-12),	/* re0  */
 		DRXJ_16TO8(-9),	/* re1  */
 		DRXJ_16TO8(9),	/* re2  */
@@ -8889,7 +8889,7 @@ trouble ?
 		DRXJ_16TO8(50),	/* re26 */
 		DRXJ_16TO8(679)	/* re27 */
 	};
-	const u8_t ntsc_taps_im[] = {
+	const u8 ntsc_taps_im[] = {
 		DRXJ_16TO8(11),	/* im0  */
 		DRXJ_16TO8(1),	/* im1  */
 		DRXJ_16TO8(-10),	/* im2  */
@@ -8919,7 +8919,7 @@ trouble ?
 		DRXJ_16TO8(553),	/* im26 */
 		DRXJ_16TO8(302)	/* im27 */
 	};
-	const u8_t bg_taps_re[] = {
+	const u8 bg_taps_re[] = {
 		DRXJ_16TO8(-18),	/* re0  */
 		DRXJ_16TO8(18),	/* re1  */
 		DRXJ_16TO8(19),	/* re2  */
@@ -8949,7 +8949,7 @@ trouble ?
 		DRXJ_16TO8(172),	/* re26 */
 		DRXJ_16TO8(801)	/* re27 */
 	};
-	const u8_t bg_taps_im[] = {
+	const u8 bg_taps_im[] = {
 		DRXJ_16TO8(-24),	/* im0  */
 		DRXJ_16TO8(-10),	/* im1  */
 		DRXJ_16TO8(9),	/* im2  */
@@ -8979,7 +8979,7 @@ trouble ?
 		DRXJ_16TO8(687),	/* im26 */
 		DRXJ_16TO8(877)	/* im27 */
 	};
-	const u8_t dk_i_l_lp_taps_re[] = {
+	const u8 dk_i_l_lp_taps_re[] = {
 		DRXJ_16TO8(-23),	/* re0  */
 		DRXJ_16TO8(9),	/* re1  */
 		DRXJ_16TO8(16),	/* re2  */
@@ -9009,7 +9009,7 @@ trouble ?
 		DRXJ_16TO8(206),	/* re26 */
 		DRXJ_16TO8(894)	/* re27 */
 	};
-	const u8_t dk_i_l_lp_taps_im[] = {
+	const u8 dk_i_l_lp_taps_im[] = {
 		DRXJ_16TO8(-8),	/* im0  */
 		DRXJ_16TO8(-20),	/* im1  */
 		DRXJ_16TO8(17),	/* im2  */
@@ -9039,7 +9039,7 @@ trouble ?
 		DRXJ_16TO8(657),	/* im26 */
 		DRXJ_16TO8(1023)	/* im27 */
 	};
-	const u8_t fm_taps_re[] = {
+	const u8 fm_taps_re[] = {
 		DRXJ_16TO8(0),	/* re0  */
 		DRXJ_16TO8(0),	/* re1  */
 		DRXJ_16TO8(0),	/* re2  */
@@ -9069,7 +9069,7 @@ trouble ?
 		DRXJ_16TO8(0),	/* re26 */
 		DRXJ_16TO8(0)	/* re27 */
 	};
-	const u8_t fm_taps_im[] = {
+	const u8 fm_taps_im[] = {
 		DRXJ_16TO8(-6),	/* im0  */
 		DRXJ_16TO8(2),	/* im1  */
 		DRXJ_16TO8(14),	/* im2  */
@@ -9107,8 +9107,8 @@ trouble ?
 		/* *parameter   */ NULL,
 		/* *result      */ NULL
 	};
-	u16_t cmdResult = 0;
-	u16_t cmdParam = 0;
+	u16 cmdResult = 0;
+	u16 cmdParam = 0;
 #ifdef DRXJ_SPLIT_UCODE_UPLOAD
 	DRXUCodeInfo_t ucodeInfo;
 	pDRXCommonAttr_t commonAttr = NULL;
@@ -9166,9 +9166,9 @@ trouble ?
 		WR16(devAddr, IQM_RT_LO_INCR__A, IQM_RT_LO_INCR_MN);
 		WR16(devAddr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(ntsc_taps_re),
-		    ((pu8_t) ntsc_taps_re));
+		    ((u8 *) ntsc_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(ntsc_taps_im),
-		    ((pu8_t) ntsc_taps_im));
+		    ((u8 *) ntsc_taps_im));
 
 		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_MN);
 		WR16(devAddr, ATV_TOP_CR_CONT__A,
@@ -9196,9 +9196,9 @@ trouble ?
 		WR16(devAddr, IQM_RT_LO_INCR__A, 2994);
 		WR16(devAddr, IQM_CF_MIDTAP__A, 0);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(fm_taps_re),
-		    ((pu8_t) fm_taps_re));
+		    ((u8 *) fm_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(fm_taps_im),
-		    ((pu8_t) fm_taps_im));
+		    ((u8 *) fm_taps_im));
 		WR16(devAddr, ATV_TOP_STD__A, (ATV_TOP_STD_MODE_FM |
 					       ATV_TOP_STD_VID_POL_FM));
 		WR16(devAddr, ATV_TOP_MOD_CONTROL__A, 0);
@@ -9218,9 +9218,9 @@ trouble ?
 		WR16(devAddr, IQM_RT_LO_INCR__A, 1820);	/* TODO check with IS */
 		WR16(devAddr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(bg_taps_re),
-		    ((pu8_t) bg_taps_re));
+		    ((u8 *) bg_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(bg_taps_im),
-		    ((pu8_t) bg_taps_im));
+		    ((u8 *) bg_taps_im));
 		WR16(devAddr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_BG);
 		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_BG);
 		WR16(devAddr, ATV_TOP_CR_CONT__A,
@@ -9247,9 +9247,9 @@ trouble ?
 		WR16(devAddr, IQM_RT_LO_INCR__A, 2225);	/* TODO check with IS */
 		WR16(devAddr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((pu8_t) dk_i_l_lp_taps_re));
+		    ((u8 *) dk_i_l_lp_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((pu8_t) dk_i_l_lp_taps_im));
+		    ((u8 *) dk_i_l_lp_taps_im));
 		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_DK);
 		WR16(devAddr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_DK);
 		WR16(devAddr, ATV_TOP_CR_CONT__A,
@@ -9276,9 +9276,9 @@ trouble ?
 		WR16(devAddr, IQM_RT_LO_INCR__A, 2225);	/* TODO check with IS */
 		WR16(devAddr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((pu8_t) dk_i_l_lp_taps_re));
+		    ((u8 *) dk_i_l_lp_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((pu8_t) dk_i_l_lp_taps_im));
+		    ((u8 *) dk_i_l_lp_taps_im));
 		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, ATV_TOP_CR_AMP_TH_I);
 		WR16(devAddr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_I);
 		WR16(devAddr, ATV_TOP_CR_CONT__A,
@@ -9306,9 +9306,9 @@ trouble ?
 		WR16(devAddr, ATV_TOP_VID_AMP__A, ATV_TOP_VID_AMP_L);
 		WR16(devAddr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((pu8_t) dk_i_l_lp_taps_re));
+		    ((u8 *) dk_i_l_lp_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((pu8_t) dk_i_l_lp_taps_im));
+		    ((u8 *) dk_i_l_lp_taps_im));
 		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, 0x2);	/* TODO check with IS */
 		WR16(devAddr, ATV_TOP_CR_CONT__A,
 		     (ATV_TOP_CR_CONT_CR_P_L |
@@ -9337,9 +9337,9 @@ trouble ?
 		WR16(devAddr, IQM_RT_LO_INCR__A, 2225);	/* TODO check with IS */
 		WR16(devAddr, IQM_CF_MIDTAP__A, IQM_CF_MIDTAP_RE__M);
 		WRB(devAddr, IQM_CF_TAP_RE0__A, sizeof(dk_i_l_lp_taps_re),
-		    ((pu8_t) dk_i_l_lp_taps_re));
+		    ((u8 *) dk_i_l_lp_taps_re));
 		WRB(devAddr, IQM_CF_TAP_IM0__A, sizeof(dk_i_l_lp_taps_im),
-		    ((pu8_t) dk_i_l_lp_taps_im));
+		    ((u8 *) dk_i_l_lp_taps_im));
 		WR16(devAddr, ATV_TOP_CR_AMP_TH__A, 0x2);	/* TODO check with IS */
 		WR16(devAddr, ATV_TOP_CR_CONT__A,
 		     (ATV_TOP_CR_CONT_CR_P_LP |
@@ -9466,7 +9466,7 @@ SetATVChannel(pDRXDemodInstance_t demod,
 		/* parameter    */ NULL,
 		/* result       */ NULL
 	};
-	u16_t cmdResult = 0;
+	u16 cmdResult = 0;
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 
@@ -9543,7 +9543,7 @@ GetATVChannel(pDRXDemodInstance_t demod,
 	case DRX_STANDARD_PAL_SECAM_I:
 	case DRX_STANDARD_PAL_SECAM_L:
 		{
-			u16_t measuredOffset = 0;
+			u16 measuredOffset = 0;
 
 			/* get measured frequency offset */
 			RR16(devAddr, ATV_TOP_CR_FREQ__A, &measuredOffset);
@@ -9553,12 +9553,12 @@ GetATVChannel(pDRXDemodInstance_t demod,
 				measuredOffset |= 0xFF80;
 			}
 			offset +=
-			    (DRXFrequency_t) (((s16_t) measuredOffset) * 10);
+			    (DRXFrequency_t) (((s16) measuredOffset) * 10);
 			break;
 		}
 	case DRX_STANDARD_PAL_SECAM_LP:
 		{
-			u16_t measuredOffset = 0;
+			u16 measuredOffset = 0;
 
 			/* get measured frequency offset */
 			RR16(devAddr, ATV_TOP_CR_FREQ__A, &measuredOffset);
@@ -9568,7 +9568,7 @@ GetATVChannel(pDRXDemodInstance_t demod,
 				measuredOffset |= 0xFF80;
 			}
 			offset -=
-			    (DRXFrequency_t) (((s16_t) measuredOffset) * 10);
+			    (DRXFrequency_t) (((s16) measuredOffset) * 10);
 		}
 		break;
 	case DRX_STANDARD_FM:
@@ -9610,30 +9610,30 @@ rw_error:
 *         is not used ?
 */
 static DRXStatus_t
-GetAtvSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
+GetAtvSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	/* All weights must add up to 100 (%)
 	   TODO: change weights when IF ctrl is available */
-	u32_t digitalWeight = 50;	/* 0 .. 100 */
-	u32_t rfWeight = 50;	/* 0 .. 100 */
-	u32_t ifWeight = 0;	/* 0 .. 100 */
-
-	u16_t digitalCurrGain = 0;
-	u32_t digitalMaxGain = 0;
-	u32_t digitalMinGain = 0;
-	u16_t rfCurrGain = 0;
-	u32_t rfMaxGain = 0x800;	/* taken from ucode */
-	u32_t rfMinGain = 0x7fff;
-	u16_t ifCurrGain = 0;
-	u32_t ifMaxGain = 0x800;	/* taken from ucode */
-	u32_t ifMinGain = 0x7fff;
-
-	u32_t digitalStrength = 0;	/* 0.. 100 */
-	u32_t rfStrength = 0;	/* 0.. 100 */
-	u32_t ifStrength = 0;	/* 0.. 100 */
+	u32 digitalWeight = 50;	/* 0 .. 100 */
+	u32 rfWeight = 50;	/* 0 .. 100 */
+	u32 ifWeight = 0;	/* 0 .. 100 */
+
+	u16 digitalCurrGain = 0;
+	u32 digitalMaxGain = 0;
+	u32 digitalMinGain = 0;
+	u16 rfCurrGain = 0;
+	u32 rfMaxGain = 0x800;	/* taken from ucode */
+	u32 rfMinGain = 0x7fff;
+	u16 ifCurrGain = 0;
+	u32 ifMaxGain = 0x800;	/* taken from ucode */
+	u32 ifMinGain = 0x7fff;
+
+	u32 digitalStrength = 0;	/* 0.. 100 */
+	u32 rfStrength = 0;	/* 0.. 100 */
+	u32 ifStrength = 0;	/* 0.. 100 */
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -9665,17 +9665,17 @@ GetAtvSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
 
 	/* clipping */
 	if (digitalCurrGain >= digitalMaxGain)
-		digitalCurrGain = (u16_t) digitalMaxGain;
+		digitalCurrGain = (u16) digitalMaxGain;
 	if (digitalCurrGain <= digitalMinGain)
-		digitalCurrGain = (u16_t) digitalMinGain;
+		digitalCurrGain = (u16) digitalMinGain;
 	if (ifCurrGain <= ifMaxGain)
-		ifCurrGain = (u16_t) ifMaxGain;
+		ifCurrGain = (u16) ifMaxGain;
 	if (ifCurrGain >= ifMinGain)
-		ifCurrGain = (u16_t) ifMinGain;
+		ifCurrGain = (u16) ifMinGain;
 	if (rfCurrGain <= rfMaxGain)
-		rfCurrGain = (u16_t) rfMaxGain;
+		rfCurrGain = (u16) rfMaxGain;
 	if (rfCurrGain >= rfMinGain)
-		rfCurrGain = (u16_t) rfMinGain;
+		rfCurrGain = (u16) rfMinGain;
 
 	/* TODO: use SCU_RAM_ATV_RAGC_HR__A to shift max and min in case
 	   of clipping at ADC */
@@ -9684,20 +9684,20 @@ GetAtvSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
 
 	/* Digital gain  */
 	/* TODO: ADC clipping not handled */
-	digitalStrength = (100 * (digitalMaxGain - (u32_t) digitalCurrGain)) /
+	digitalStrength = (100 * (digitalMaxGain - (u32) digitalCurrGain)) /
 	    (digitalMaxGain - digitalMinGain);
 
 	/* TODO: IF gain not implemented yet in microcode, check after impl. */
-	ifStrength = (100 * ((u32_t) ifCurrGain - ifMaxGain)) /
+	ifStrength = (100 * ((u32) ifCurrGain - ifMaxGain)) /
 	    (ifMinGain - ifMaxGain);
 
 	/* Rf gain */
 	/* TODO: ADC clipping not handled */
-	rfStrength = (100 * ((u32_t) rfCurrGain - rfMaxGain)) /
+	rfStrength = (100 * ((u32) rfCurrGain - rfMaxGain)) /
 	    (rfMinGain - rfMaxGain);
 
 	/* Compute a weighted signal strength (in %) */
-	*sigStrength = (u16_t) (digitalWeight * digitalStrength +
+	*sigStrength = (u16) (digitalWeight * digitalStrength +
 				rfWeight * rfStrength + ifWeight * ifStrength);
 	*sigStrength /= 100;
 
@@ -9722,7 +9722,7 @@ static DRXStatus_t
 AtvSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
 	struct i2c_device_addr *devAddr = NULL;
-	u16_t qualityIndicator = 0;
+	u16 qualityIndicator = 0;
 
 	devAddr = demod->myI2CDevAddr;
 
@@ -9831,14 +9831,14 @@ rw_error:
 * \return DRXStatus_t.
 *
 */
-static DRXStatus_t AUDGetModus(pDRXDemodInstance_t demod, pu16_t modus)
+static DRXStatus_t AUDGetModus(pDRXDemodInstance_t demod, u16 *modus)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t rModus = 0;
-	u16_t rModusHi = 0;
-	u16_t rModusLo = 0;
+	u16 rModus = 0;
+	u16 rModusHi = 0;
+	u16 rModusLo = 0;
 
 	if (modus == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -9882,10 +9882,10 @@ AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 	struct i2c_device_addr *addr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t rRDSArrayCntInit = 0;
-	u16_t rRDSArrayCntCheck = 0;
-	u16_t rRDSData = 0;
-	u16_t RDSDataCnt = 0;
+	u16 rRDSArrayCntInit = 0;
+	u16 rRDSArrayCntCheck = 0;
+	u16 rRDSData = 0;
+	u16 RDSDataCnt = 0;
 
 	addr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -9952,7 +9952,7 @@ AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 
-	u16_t rData = 0;
+	u16 rData = 0;
 
 	if (status == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10030,7 +10030,7 @@ AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	pDRXJData_t extAttr = NULL;
 	struct i2c_device_addr *devAddr = NULL;
 	DRXCfgAudRDS_t rds = { FALSE, {0} };
-	u16_t rData = 0;
+	u16 rData = 0;
 
 	if (status == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10050,7 +10050,7 @@ AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 	/* fmIdent */
 	RR16(devAddr, AUD_DSP_RD_FM_IDENT_VALUE__A, &rData);
 	rData >>= AUD_DSP_RD_FM_IDENT_VALUE_FM_IDENT__B;
-	status->fmIdent = (s8_t) rData;
+	status->fmIdent = (s8) rData;
 
 	return DRX_STS_OK;
 rw_error:
@@ -10071,10 +10071,10 @@ AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t rVolume = 0;
-	u16_t rAVC = 0;
-	u16_t rStrengthLeft = 0;
-	u16_t rStrengthRight = 0;
+	u16 rVolume = 0;
+	u16 rAVC = 0;
+	u16 rStrengthLeft = 0;
+	u16 rStrengthRight = 0;
 
 	if (volume == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10167,7 +10167,7 @@ AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	}
 
 	/* reference level */
-	volume->avcRefLevel = (u16_t) ((rAVC & AUD_DSP_WR_AVC_AVC_REF_LEV__M) >>
+	volume->avcRefLevel = (u16) ((rAVC & AUD_DSP_WR_AVC_AVC_REF_LEV__M) >>
 				       AUD_DSP_WR_AVC_AVC_REF_LEV__B);
 
 	/* read qpeak registers and calculate strength of left and right carrier */
@@ -10178,12 +10178,12 @@ AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	/* QP vaues */
 	/* left carrier */
 	RR16(devAddr, AUD_DSP_RD_QPEAK_L__A, &rStrengthLeft);
-	volume->strengthLeft = (((s16_t) Log10Times100(rStrengthLeft)) -
+	volume->strengthLeft = (((s16) Log10Times100(rStrengthLeft)) -
 				AUD_CARRIER_STRENGTH_QP_0DB_LOG10T100) / 5;
 
 	/* right carrier */
 	RR16(devAddr, AUD_DSP_RD_QPEAK_R__A, &rStrengthRight);
-	volume->strengthRight = (((s16_t) Log10Times100(rStrengthRight)) -
+	volume->strengthRight = (((s16) Log10Times100(rStrengthRight)) -
 				 AUD_CARRIER_STRENGTH_QP_0DB_LOG10T100) / 5;
 
 	return DRX_STS_OK;
@@ -10205,8 +10205,8 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t wVolume = 0;
-	u16_t wAVC = 0;
+	u16 wVolume = 0;
+	u16 wAVC = 0;
 
 	if (volume == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10231,14 +10231,14 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	RR16(devAddr, AUD_DSP_WR_VOLUME__A, &wVolume);
 
 	/* clear the volume mask */
-	wVolume &= (u16_t) ~ AUD_DSP_WR_VOLUME_VOL_MAIN__M;
+	wVolume &= (u16) ~ AUD_DSP_WR_VOLUME_VOL_MAIN__M;
 	if (volume->mute == TRUE) {
 		/* mute */
 		/* mute overrules volume */
-		wVolume |= (u16_t) (0);
+		wVolume |= (u16) (0);
 
 	} else {
-		wVolume |= (u16_t) ((volume->volume + AUD_VOLUME_ZERO_DB) <<
+		wVolume |= (u16) ((volume->volume + AUD_VOLUME_ZERO_DB) <<
 				    AUD_DSP_WR_VOLUME_VOL_MAIN__B);
 	}
 
@@ -10248,8 +10248,8 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	RR16(devAddr, AUD_DSP_WR_AVC__A, &wAVC);
 
 	/* clear masks that require writing */
-	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_ON__M;
-	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_DECAY__M;
+	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_ON__M;
+	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_DECAY__M;
 
 	if (volume->avcMode == DRX_AUD_AVC_OFF) {
 		wAVC |= (AUD_DSP_WR_AVC_AVC_ON_OFF);
@@ -10277,7 +10277,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	}
 
 	/* max attenuation */
-	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_MAX_ATT__M;
+	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_MAX_ATT__M;
 	switch (volume->avcMaxAtten) {
 	case DRX_AUD_AVC_MAX_ATTEN_12DB:
 		wAVC |= AUD_DSP_WR_AVC_AVC_MAX_ATT_12DB;
@@ -10293,7 +10293,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 	}
 
 	/* max gain */
-	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_MAX_GAIN__M;
+	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_MAX_GAIN__M;
 	switch (volume->avcMaxGain) {
 	case DRX_AUD_AVC_MAX_GAIN_0DB:
 		wAVC |= AUD_DSP_WR_AVC_AVC_MAX_GAIN_0DB;
@@ -10313,8 +10313,8 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	wAVC &= (u16_t) ~ AUD_DSP_WR_AVC_AVC_REF_LEV__M;
-	wAVC |= (u16_t) (volume->avcRefLevel << AUD_DSP_WR_AVC_AVC_REF_LEV__B);
+	wAVC &= (u16) ~ AUD_DSP_WR_AVC_AVC_REF_LEV__M;
+	wAVC |= (u16) (volume->avcRefLevel << AUD_DSP_WR_AVC_AVC_REF_LEV__B);
 
 	WR16(devAddr, AUD_DSP_WR_AVC__A, wAVC);
 
@@ -10340,8 +10340,8 @@ AUDCtrlGetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t wI2SConfig = 0;
-	u16_t rI2SFreq = 0;
+	u16 wI2SConfig = 0;
+	u16 rI2SFreq = 0;
 
 	if (output == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10443,11 +10443,11 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t wI2SConfig = 0;
-	u16_t wI2SPadsDataDa = 0;
-	u16_t wI2SPadsDataCl = 0;
-	u16_t wI2SPadsDataWs = 0;
-	u32_t wI2SFreq = 0;
+	u16 wI2SConfig = 0;
+	u16 wI2SPadsDataDa = 0;
+	u16 wI2SPadsDataCl = 0;
+	u16 wI2SPadsDataWs = 0;
+	u32 wI2SFreq = 0;
 
 	if (output == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10465,7 +10465,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	RR16(devAddr, AUD_DEM_RAM_I2S_CONFIG2__A, &wI2SConfig);
 
 	/* I2S mode */
-	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_SLV_MST__M;
+	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_SLV_MST__M;
 
 	switch (output->mode) {
 	case DRX_I2S_MODE_MASTER:
@@ -10479,7 +10479,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S format */
-	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_MODE__M;
+	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_MODE__M;
 
 	switch (output->format) {
 	case DRX_I2S_FORMAT_WS_ADVANCED:
@@ -10493,7 +10493,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S word length */
-	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WORD_LEN__M;
+	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WORD_LEN__M;
 
 	switch (output->wordLength) {
 	case DRX_I2S_WORDLENGTH_16:
@@ -10507,7 +10507,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S polarity */
-	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL__M;
+	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL__M;
 	switch (output->polarity) {
 	case DRX_I2S_POLARITY_LEFT:
 		wI2SConfig |= AUD_DEM_WR_I2S_CONFIG2_I2S_WS_POL_LEFT_HIGH;
@@ -10520,7 +10520,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	/* I2S output enabled */
-	wI2SConfig &= (u16_t) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
+	wI2SConfig &= (u16) ~ AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE__M;
 	if (output->outputEnable == TRUE) {
 		wI2SConfig |= AUD_DEM_WR_I2S_CONFIG2_I2S_ENABLE_ENABLE;
 	} else {
@@ -10548,7 +10548,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 	}
 
 	WR16(devAddr, AUD_DEM_WR_I2S_CONFIG2__A, wI2SConfig);
-	WR16(devAddr, AUD_DSP_WR_I2S_OUT_FS__A, (u16_t) wI2SFreq);
+	WR16(devAddr, AUD_DSP_WR_I2S_OUT_FS__A, (u16) wI2SFreq);
 
 	/* configure I2S output pads for master or slave mode */
 	WR16(devAddr, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
@@ -10599,7 +10599,7 @@ AUDCtrlGetCfgAutoSound(pDRXDemodInstance_t demod,
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t rModus = 0;
+	u16 rModus = 0;
 
 	if (autoSound == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10656,8 +10656,8 @@ AUDCtrSetlCfgAutoSound(pDRXDemodInstance_t demod,
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t rModus = 0;
-	u16_t wModus = 0;
+	u16 rModus = 0;
+	u16 wModus = 0;
 
 	if (autoSound == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10676,8 +10676,8 @@ AUDCtrSetlCfgAutoSound(pDRXDemodInstance_t demod,
 
 	wModus = rModus;
 	/* clear ASS & ASC bits */
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_ASS__M;
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_ASS__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_DIS_STD_CHG__M;
 
 	switch (*autoSound) {
 	case DRX_AUD_AUTO_SOUND_OFF:
@@ -10721,9 +10721,9 @@ AUDCtrlGetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t thresA2 = 0;
-	u16_t thresBtsc = 0;
-	u16_t thresNicam = 0;
+	u16 thresA2 = 0;
+	u16 thresBtsc = 0;
+	u16 thresNicam = 0;
 
 	if (thres == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10804,21 +10804,21 @@ AUDCtrlGetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t wModus = 0;
+	u16 wModus = 0;
 
-	u16_t dcoAHi = 0;
-	u16_t dcoALo = 0;
-	u16_t dcoBHi = 0;
-	u16_t dcoBLo = 0;
+	u16 dcoAHi = 0;
+	u16 dcoALo = 0;
+	u16 dcoBHi = 0;
+	u16 dcoBLo = 0;
 
-	u32_t valA = 0;
-	u32_t valB = 0;
+	u32 valA = 0;
+	u32 valB = 0;
 
-	u16_t dcLvlA = 0;
-	u16_t dcLvlB = 0;
+	u16 dcLvlA = 0;
+	u16 dcLvlB = 0;
 
-	u16_t cmThesA = 0;
-	u16_t cmThesB = 0;
+	u16 cmThesA = 0;
+	u16 cmThesB = 0;
 
 	if (carriers == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10867,8 +10867,8 @@ AUDCtrlGetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	RR16(devAddr, AUD_DEM_RAM_DCO_B_HI__A, &dcoBHi);
 	RR16(devAddr, AUD_DEM_RAM_DCO_B_LO__A, &dcoBLo);
 
-	valA = (((u32_t) dcoAHi) << 12) | ((u32_t) dcoALo & 0xFFF);
-	valB = (((u32_t) dcoBHi) << 12) | ((u32_t) dcoBLo & 0xFFF);
+	valA = (((u32) dcoAHi) << 12) | ((u32) dcoALo & 0xFFF);
+	valB = (((u32) dcoBHi) << 12) | ((u32) dcoBLo & 0xFFF);
 
 	/* Multiply by 20250 * 1>>24  ~= 2 / 1657 */
 	carriers->a.dco = DRX_S24TODRXFREQ(valA) * 2L / 1657L;
@@ -10909,16 +10909,16 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t wModus = 0;
-	u16_t rModus = 0;
+	u16 wModus = 0;
+	u16 rModus = 0;
 
-	u16_t dcoAHi = 0;
-	u16_t dcoALo = 0;
-	u16_t dcoBHi = 0;
-	u16_t dcoBLo = 0;
+	u16 dcoAHi = 0;
+	u16 dcoALo = 0;
+	u16 dcoBHi = 0;
+	u16 dcoBLo = 0;
 
-	s32_t valA = 0;
-	s32_t valB = 0;
+	s32 valA = 0;
+	s32 valB = 0;
 
 	if (carriers == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -10936,7 +10936,7 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	CHK_ERROR(AUDGetModus(demod, &rModus));
 
 	wModus = rModus;
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_CM_A__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_CM_A__M;
 	/* Behaviour of primary audio channel */
 	switch (carriers->a.opt) {
 	case DRX_NO_CARRIER_MUTE:
@@ -10951,7 +10951,7 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	}
 
 	/* Behaviour of secondary audio channel */
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_CM_B__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_CM_B__M;
 	switch (carriers->b.opt) {
 	case DRX_NO_CARRIER_MUTE:
 		wModus |= AUD_DEM_WR_MODUS_MOD_CM_B_MUTE;
@@ -10970,13 +10970,13 @@ AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 	}
 
 	/* frequency adjustment for primary & secondary audio channel */
-	valA = (s32_t) ((carriers->a.dco) * 1657L / 2);
-	valB = (s32_t) ((carriers->b.dco) * 1657L / 2);
+	valA = (s32) ((carriers->a.dco) * 1657L / 2);
+	valB = (s32) ((carriers->b.dco) * 1657L / 2);
 
-	dcoAHi = (u16_t) ((valA >> 12) & 0xFFF);
-	dcoALo = (u16_t) (valA & 0xFFF);
-	dcoBHi = (u16_t) ((valB >> 12) & 0xFFF);
-	dcoBLo = (u16_t) (valB & 0xFFF);
+	dcoAHi = (u16) ((valA >> 12) & 0xFFF);
+	dcoALo = (u16) (valA & 0xFFF);
+	dcoBHi = (u16) ((valB >> 12) & 0xFFF);
+	dcoBLo = (u16) (valB & 0xFFF);
 
 	WR16(devAddr, AUD_DEM_WR_DCO_A_HI__A, dcoAHi);
 	WR16(devAddr, AUD_DEM_WR_DCO_A_LO__A, dcoALo);
@@ -11009,8 +11009,8 @@ AUDCtrlGetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t srcI2SMatr = 0;
-	u16_t fmMatr = 0;
+	u16 srcI2SMatr = 0;
+	u16 fmMatr = 0;
 
 	if (mixer == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11104,8 +11104,8 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t srcI2SMatr = 0;
-	u16_t fmMatr = 0;
+	u16 srcI2SMatr = 0;
+	u16 fmMatr = 0;
 
 	if (mixer == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11122,7 +11122,7 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 
 	/* Source Selctor */
 	RR16(devAddr, AUD_DSP_WR_SRC_I2S_MATR__A, &srcI2SMatr);
-	srcI2SMatr &= (u16_t) ~ AUD_DSP_WR_SRC_I2S_MATR_SRC_I2S__M;
+	srcI2SMatr &= (u16) ~ AUD_DSP_WR_SRC_I2S_MATR_SRC_I2S__M;
 
 	switch (mixer->sourceI2S) {
 	case DRX_AUD_SRC_MONO:
@@ -11142,7 +11142,7 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 	}
 
 	/* Matrix */
-	srcI2SMatr &= (u16_t) ~ AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S__M;
+	srcI2SMatr &= (u16) ~ AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S__M;
 	switch (mixer->matrixI2S) {
 	case DRX_AUD_I2S_MATRIX_MONO:
 		srcI2SMatr |= AUD_DSP_WR_SRC_I2S_MATR_MAT_I2S_MONO;
@@ -11164,7 +11164,7 @@ AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 
 	/* FM Matrix */
 	RR16(devAddr, AUD_DEM_WR_FM_MATRIX__A, &fmMatr);
-	fmMatr &= (u16_t) ~ AUD_DEM_WR_FM_MATRIX__M;
+	fmMatr &= (u16) ~ AUD_DEM_WR_FM_MATRIX__M;
 	switch (mixer->matrixFm) {
 	case DRX_AUD_FM_MATRIX_NO_MATRIX:
 		fmMatr |= AUD_DEM_WR_FM_MATRIX_NO_MATRIX;
@@ -11212,7 +11212,7 @@ AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t wAudVidSync = 0;
+	u16 wAudVidSync = 0;
 
 	if (avSync == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11230,7 +11230,7 @@ AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 	/* audio/video synchronisation */
 	RR16(devAddr, AUD_DSP_WR_AV_SYNC__A, &wAudVidSync);
 
-	wAudVidSync &= (u16_t) ~ AUD_DSP_WR_AV_SYNC_AV_ON__M;
+	wAudVidSync &= (u16) ~ AUD_DSP_WR_AV_SYNC_AV_ON__M;
 
 	if (*avSync == DRX_AUD_AVSYNC_OFF) {
 		wAudVidSync |= AUD_DSP_WR_AV_SYNC_AV_ON_DISABLE;
@@ -11238,7 +11238,7 @@ AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 		wAudVidSync |= AUD_DSP_WR_AV_SYNC_AV_ON_ENABLE;
 	}
 
-	wAudVidSync &= (u16_t) ~ AUD_DSP_WR_AV_SYNC_AV_STD_SEL__M;
+	wAudVidSync &= (u16) ~ AUD_DSP_WR_AV_SYNC_AV_STD_SEL__M;
 
 	switch (*avSync) {
 	case DRX_AUD_AVSYNC_NTSC:
@@ -11277,7 +11277,7 @@ AUDCtrlGetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t wAudVidSync = 0;
+	u16 wAudVidSync = 0;
 
 	if (avSync == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11334,7 +11334,7 @@ AUDCtrlGetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t rModus = 0;
+	u16 rModus = 0;
 
 	if (dev == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11375,8 +11375,8 @@ AUDCtrlSetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t wModus = 0;
-	u16_t rModus = 0;
+	u16 wModus = 0;
+	u16 rModus = 0;
 
 	if (dev == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11389,7 +11389,7 @@ AUDCtrlSetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 
 	wModus = rModus;
 
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_HDEV_A__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_HDEV_A__M;
 
 	switch (*dev) {
 	case DRX_AUD_DEVIATION_NORMAL:
@@ -11428,8 +11428,8 @@ AUDCtrlGetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t rMaxFMDeviation = 0;
-	u16_t rNicamPrescaler = 0;
+	u16 rMaxFMDeviation = 0;
+	u16 rNicamPrescaler = 0;
 
 	if (presc == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11477,10 +11477,10 @@ AUDCtrlGetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 		presc->nicamGain = -241;
 	} else {
 
-		presc->nicamGain = (s16_t) (((s32_t)
+		presc->nicamGain = (s16) (((s32)
 					     (Log10Times100
 					      (10 * rNicamPrescaler *
-					       rNicamPrescaler)) - (s32_t)
+					       rNicamPrescaler)) - (s32)
 					     (Log10Times100(10 * 16 * 16))));
 	}
 
@@ -11503,8 +11503,8 @@ AUDCtrlSetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t wMaxFMDeviation = 0;
-	u16_t nicamPrescaler;
+	u16 wMaxFMDeviation = 0;
+	u16 nicamPrescaler;
 
 	if (presc == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11520,7 +11520,7 @@ AUDCtrlSetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 	}
 
 	/* setting of max FM deviation */
-	wMaxFMDeviation = (u16_t) (Frac(3600UL, presc->fmDeviation, 0));
+	wMaxFMDeviation = (u16) (Frac(3600UL, presc->fmDeviation, 0));
 	wMaxFMDeviation <<= AUD_DSP_WR_FM_PRESC_FM_AM_PRESC__B;
 	if (wMaxFMDeviation >=
 	    AUD_DSP_WR_FM_PRESC_FM_AM_PRESC_28_KHZ_FM_DEVIATION) {
@@ -11547,7 +11547,7 @@ AUDCtrlSetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 		   = 10^( G0.1dB + 200log10(16)) / 200 )
 
 		 */
-		nicamPrescaler = (u16_t)
+		nicamPrescaler = (u16)
 		    ((dB2LinTimes100(presc->nicamGain + 241UL) + 50UL) / 100UL);
 
 		/* clip result */
@@ -11585,9 +11585,9 @@ static DRXStatus_t AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
-	u16_t theBeep = 0;
-	u16_t volume = 0;
-	u32_t frequency = 0;
+	u16 theBeep = 0;
+	u16 volume = 0;
+	u32 frequency = 0;
 
 	if (beep == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11610,14 +11610,14 @@ static DRXStatus_t AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	volume = (u16_t) beep->volume + 127;
+	volume = (u16) beep->volume + 127;
 	theBeep |= volume << AUD_DSP_WR_BEEPER_BEEP_VOLUME__B;
 
-	frequency = ((u32_t) beep->frequency) * 23 / 500;
+	frequency = ((u32) beep->frequency) * 23 / 500;
 	if (frequency > AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M) {
 		frequency = AUD_DSP_WR_BEEPER_BEEP_FREQUENCY__M;
 	}
-	theBeep |= (u16_t) frequency;
+	theBeep |= (u16) frequency;
 
 	if (beep->mute == TRUE) {
 		theBeep = 0;
@@ -11645,13 +11645,13 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t currentStandard = DRX_STANDARD_UNKNOWN;
 
-	u16_t wStandard = 0;
-	u16_t wModus = 0;
-	u16_t rModus = 0;
+	u16 wStandard = 0;
+	u16 wModus = 0;
+	u16 rModus = 0;
 
 	Bool_t muteBuffer = FALSE;
-	s16_t volumeBuffer = 0;
-	u16_t wVolume = 0;
+	s16 volumeBuffer = 0;
+	u16 wVolume = 0;
 
 	if (standard == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -11745,7 +11745,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 		/* we need the current standard here */
 		currentStandard = extAttr->standard;
 
-		wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_6_5MHZ__M;
+		wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_6_5MHZ__M;
 
 		if ((currentStandard == DRX_STANDARD_PAL_SECAM_L) ||
 		    (currentStandard == DRX_STANDARD_PAL_SECAM_LP)) {
@@ -11754,7 +11754,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 			wModus |= (AUD_DEM_WR_MODUS_MOD_6_5MHZ_D_K);
 		}
 
-		wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_4_5MHZ__M;
+		wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_4_5MHZ__M;
 		if (currentStandard == DRX_STANDARD_NTSC) {
 			wModus |= (AUD_DEM_WR_MODUS_MOD_4_5MHZ_M_BTSC);
 
@@ -11765,7 +11765,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 
 	}
 
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_FMRADIO__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_FMRADIO__M;
 
 	/* just get hardcoded deemphasis and activate here */
 	if (extAttr->audData.deemph == DRX_AUD_FM_DEEMPH_50US) {
@@ -11774,7 +11774,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 		wModus |= (AUD_DEM_WR_MODUS_MOD_FMRADIO_US_75U);
 	}
 
-	wModus &= (u16_t) ~ AUD_DEM_WR_MODUS_MOD_BTSC__M;
+	wModus &= (u16) ~ AUD_DEM_WR_MODUS_MOD_BTSC__M;
 	if (extAttr->audData.btscDetect == DRX_BTSC_STEREO) {
 		wModus |= (AUD_DEM_WR_MODUS_MOD_BTSC_BTSC_STEREO);
 	} else {		/* DRX_BTSC_MONO_AND_SAP */
@@ -11795,7 +11795,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
    /**************************************************************************/
 	extAttr->audData.volume.mute = muteBuffer;
 	if (extAttr->audData.volume.mute == FALSE) {
-		wVolume |= (u16_t) ((volumeBuffer + AUD_VOLUME_ZERO_DB) <<
+		wVolume |= (u16) ((volumeBuffer + AUD_VOLUME_ZERO_DB) <<
 				    AUD_DSP_WR_VOLUME_VOL_MAIN__B);
 		WR16(devAddr, AUD_DSP_WR_VOLUME__A, wVolume);
 	}
@@ -11822,7 +11822,7 @@ AUDCtrlGetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	u16_t rData = 0;
+	u16 rData = 0;
 
 	if (standard == NULL) {
 		return DRX_STS_INVALID_ARG;
@@ -12000,8 +12000,8 @@ GetOOBLockStatus(pDRXDemodInstance_t demod,
 		 struct i2c_device_addr *devAddr, pDRXLockStatus_t oobLock)
 {
 	DRXJSCUCmd_t scuCmd;
-	u16_t cmdResult[2];
-	u16_t OOBLockState;
+	u16 cmdResult[2];
+	u16 OOBLockState;
 
 	*oobLock = DRX_NOT_LOCKED;
 
@@ -12051,7 +12051,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, ps32_t SymbolRateOffset)
+GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, s32 *SymbolRateOffset)
 {
 /*  offset = -{(timingOffset/2^19)*(symbolRate/12,656250MHz)}*10^6 [ppm]  */
 /*  offset = -{(timingOffset/2^19)*(symbolRate/12656250)}*10^6 [ppm]  */
@@ -12064,11 +12064,11 @@ GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, ps32_t SymbolRateOffset)
 /*  trim 12656250/15625 = 810 */
 /*  offset = -{(timingOffset*(symbolRate * 2^-5))/(2^8*810)} [ppm]  */
 /*  offset = -[(symbolRate * 2^-5)*(timingOffset)/(2^8)]/810 [ppm]  */
-	s32_t timingOffset = 0;
-	u32_t unsignedTimingOffset = 0;
-	s32_t divisionFactor = 810;
-	u16_t data = 0;
-	u32_t symbolRate = 0;
+	s32 timingOffset = 0;
+	u32 unsignedTimingOffset = 0;
+	s32 divisionFactor = 810;
+	u16 data = 0;
+	u32 symbolRate = 0;
 	Bool_t negative = FALSE;
 
 	*SymbolRateOffset = 0;
@@ -12099,10 +12099,10 @@ GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, ps32_t SymbolRateOffset)
 		if (data == 0x8000)
 			unsignedTimingOffset = 32768;
 		else
-			unsignedTimingOffset = 0x00007FFF & (u32_t) (-data);
+			unsignedTimingOffset = 0x00007FFF & (u32) (-data);
 		negative = TRUE;
 	} else
-		unsignedTimingOffset = (u32_t) data;
+		unsignedTimingOffset = (u32) data;
 
 	symbolRate = symbolRate >> 5;
 	unsignedTimingOffset = (unsignedTimingOffset * symbolRate);
@@ -12110,9 +12110,9 @@ GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, ps32_t SymbolRateOffset)
 	unsignedTimingOffset = Frac(unsignedTimingOffset,
 				    divisionFactor, FRAC_ROUND);
 	if (negative)
-		timingOffset = (s32_t) unsignedTimingOffset;
+		timingOffset = (s32) unsignedTimingOffset;
 	else
-		timingOffset = -(s32_t) unsignedTimingOffset;
+		timingOffset = -(s32) unsignedTimingOffset;
 
 	*SymbolRateOffset = timingOffset;
 
@@ -12134,17 +12134,17 @@ rw_error:
 static DRXStatus_t
 GetOOBFreqOffset(pDRXDemodInstance_t demod, pDRXFrequency_t freqOffset)
 {
-	u16_t data = 0;
-	u16_t rot = 0;
-	u16_t symbolRateReg = 0;
-	u32_t symbolRate = 0;
-	s32_t coarseFreqOffset = 0;
-	s32_t fineFreqOffset = 0;
-	s32_t fineSign = 1;
-	s32_t coarseSign = 1;
-	u32_t data64Hi = 0;
-	u32_t data64Lo = 0;
-	u32_t tempFreqOffset = 0;
+	u16 data = 0;
+	u16 rot = 0;
+	u16 symbolRateReg = 0;
+	u32 symbolRate = 0;
+	s32 coarseFreqOffset = 0;
+	s32 fineFreqOffset = 0;
+	s32 fineSign = 1;
+	s32 coarseSign = 1;
+	u32 data64Hi = 0;
+	u32 data64Lo = 0;
+	u32 tempFreqOffset = 0;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	struct i2c_device_addr *devAddr = NULL;
 
@@ -12235,7 +12235,7 @@ rw_error:
 static DRXStatus_t
 GetOOBFrequency(pDRXDemodInstance_t demod, pDRXFrequency_t frequency)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	DRXFrequency_t freqOffset = 0;
 	DRXFrequency_t freq = 0;
 	struct i2c_device_addr *devAddr = NULL;
@@ -12267,9 +12267,9 @@ rw_error:
 * Gets OOB MER. Table for MER is in Programming guide.
 *
 */
-static DRXStatus_t GetOOBMER(struct i2c_device_addr *devAddr, pu32_t mer)
+static DRXStatus_t GetOOBMER(struct i2c_device_addr *devAddr, u32 *mer)
 {
-	u16_t data = 0;
+	u16 data = 0;
 
 	*mer = 0;
 	/* READ MER */
@@ -12410,7 +12410,7 @@ rw_error:
 */
 static DRXStatus_t SetOrxNsuAox(pDRXDemodInstance_t demod, Bool_t active)
 {
-	u16_t data = 0;
+	u16 data = 0;
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
@@ -12478,26 +12478,26 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 	DRXFrequency_t freq = 0;	/* KHz */
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	u16_t i = 0;
+	u16 i = 0;
 	Bool_t mirrorFreqSpectOOB = FALSE;
-	u16_t trkFilterValue = 0;
+	u16 trkFilterValue = 0;
 	DRXJSCUCmd_t scuCmd;
-	u16_t setParamParameters[3];
-	u16_t cmdResult[2] = { 0, 0 };
-	s16_t NyquistCoeffs[4][(NYQFILTERLEN + 1) / 2] = {
+	u16 setParamParameters[3];
+	u16 cmdResult[2] = { 0, 0 };
+	s16 NyquistCoeffs[4][(NYQFILTERLEN + 1) / 2] = {
 		IMPULSE_COSINE_ALPHA_0_3,	/* Target Mode 0 */
 		IMPULSE_COSINE_ALPHA_0_3,	/* Target Mode 1 */
 		IMPULSE_COSINE_ALPHA_0_5,	/* Target Mode 2 */
 		IMPULSE_COSINE_ALPHA_RO_0_5	/* Target Mode 3 */
 	};
-	u8_t mode_val[4] = { 2, 2, 0, 1 };
-	u8_t PFICoeffs[4][6] = {
+	u8 mode_val[4] = { 2, 2, 0, 1 };
+	u8 PFICoeffs[4][6] = {
 		{DRXJ_16TO8(-92), DRXJ_16TO8(-108), DRXJ_16TO8(100)},	/* TARGET_MODE = 0:     PFI_A = -23/32; PFI_B = -54/32;  PFI_C = 25/32; fg = 0.5 MHz (Att=26dB) */
 		{DRXJ_16TO8(-64), DRXJ_16TO8(-80), DRXJ_16TO8(80)},	/* TARGET_MODE = 1:     PFI_A = -16/32; PFI_B = -40/32;  PFI_C = 20/32; fg = 1.0 MHz (Att=28dB) */
 		{DRXJ_16TO8(-80), DRXJ_16TO8(-98), DRXJ_16TO8(92)},	/* TARGET_MODE = 2, 3:  PFI_A = -20/32; PFI_B = -49/32;  PFI_C = 23/32; fg = 0.8 MHz (Att=25dB) */
 		{DRXJ_16TO8(-80), DRXJ_16TO8(-98), DRXJ_16TO8(92)}	/* TARGET_MODE = 2, 3:  PFI_A = -20/32; PFI_B = -49/32;  PFI_C = 23/32; fg = 0.8 MHz (Att=25dB) */
 	};
-	u16_t mode_index;
+	u16 mode_index;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -12527,12 +12527,12 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 	freq = (freq - 50000) / 50;
 
 	{
-		u16_t index = 0;
-		u16_t remainder = 0;
-		pu16_t trkFiltercfg = extAttr->oobTrkFilterCfg;
+		u16 index = 0;
+		u16 remainder = 0;
+		u16 *trkFiltercfg = extAttr->oobTrkFilterCfg;
 
-		index = (u16_t) ((freq - 400) / 200);
-		remainder = (u16_t) ((freq - 400) % 200);
+		index = (u16) ((freq - 400) / 200);
+		remainder = (u16) ((freq - 400) % 200);
 		trkFilterValue =
 		    trkFiltercfg[index] - (trkFiltercfg[index] -
 					   trkFiltercfg[index +
@@ -12624,7 +12624,7 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 			    SCU_RAM_ORX_RF_RX_DATA_RATE_3088KBPS_REGSPEC;
 		break;
 	}
-	setParamParameters[1] = (u16_t) (freq & 0xFFFF);
+	setParamParameters[1] = (u16) (freq & 0xFFFF);
 	setParamParameters[2] = trkFilterValue;
 	scuCmd.parameter = setParamParameters;
 	scuCmd.resultLen = 1;
@@ -12665,49 +12665,49 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 
 	/* AGN_LOCK = {2048>>3, -2048, 8, -8, 0, 1}; */
 	WR16(devAddr, SCU_RAM_ORX_AGN_LOCK_TH__A, 2048 >> 3);
-	WR16(devAddr, SCU_RAM_ORX_AGN_LOCK_TOTH__A, (u16_t) (-2048));
+	WR16(devAddr, SCU_RAM_ORX_AGN_LOCK_TOTH__A, (u16) (-2048));
 	WR16(devAddr, SCU_RAM_ORX_AGN_ONLOCK_TTH__A, 8);
-	WR16(devAddr, SCU_RAM_ORX_AGN_UNLOCK_TTH__A, (u16_t) (-8));
+	WR16(devAddr, SCU_RAM_ORX_AGN_UNLOCK_TTH__A, (u16) (-8));
 	WR16(devAddr, SCU_RAM_ORX_AGN_LOCK_MASK__A, 1);
 
 	/* DGN_LOCK = {10, -2048, 8, -8, 0, 1<<1}; */
 	WR16(devAddr, SCU_RAM_ORX_DGN_LOCK_TH__A, 10);
-	WR16(devAddr, SCU_RAM_ORX_DGN_LOCK_TOTH__A, (u16_t) (-2048));
+	WR16(devAddr, SCU_RAM_ORX_DGN_LOCK_TOTH__A, (u16) (-2048));
 	WR16(devAddr, SCU_RAM_ORX_DGN_ONLOCK_TTH__A, 8);
-	WR16(devAddr, SCU_RAM_ORX_DGN_UNLOCK_TTH__A, (u16_t) (-8));
+	WR16(devAddr, SCU_RAM_ORX_DGN_UNLOCK_TTH__A, (u16) (-8));
 	WR16(devAddr, SCU_RAM_ORX_DGN_LOCK_MASK__A, 1 << 1);
 
 	/* FRQ_LOCK = {15,-2048, 8, -8, 0, 1<<2}; */
 	WR16(devAddr, SCU_RAM_ORX_FRQ_LOCK_TH__A, 17);
-	WR16(devAddr, SCU_RAM_ORX_FRQ_LOCK_TOTH__A, (u16_t) (-2048));
+	WR16(devAddr, SCU_RAM_ORX_FRQ_LOCK_TOTH__A, (u16) (-2048));
 	WR16(devAddr, SCU_RAM_ORX_FRQ_ONLOCK_TTH__A, 8);
-	WR16(devAddr, SCU_RAM_ORX_FRQ_UNLOCK_TTH__A, (u16_t) (-8));
+	WR16(devAddr, SCU_RAM_ORX_FRQ_UNLOCK_TTH__A, (u16) (-8));
 	WR16(devAddr, SCU_RAM_ORX_FRQ_LOCK_MASK__A, 1 << 2);
 
 	/* PHA_LOCK = {5000, -2048, 8, -8, 0, 1<<3}; */
 	WR16(devAddr, SCU_RAM_ORX_PHA_LOCK_TH__A, 3000);
-	WR16(devAddr, SCU_RAM_ORX_PHA_LOCK_TOTH__A, (u16_t) (-2048));
+	WR16(devAddr, SCU_RAM_ORX_PHA_LOCK_TOTH__A, (u16) (-2048));
 	WR16(devAddr, SCU_RAM_ORX_PHA_ONLOCK_TTH__A, 8);
-	WR16(devAddr, SCU_RAM_ORX_PHA_UNLOCK_TTH__A, (u16_t) (-8));
+	WR16(devAddr, SCU_RAM_ORX_PHA_UNLOCK_TTH__A, (u16) (-8));
 	WR16(devAddr, SCU_RAM_ORX_PHA_LOCK_MASK__A, 1 << 3);
 
 	/* TIM_LOCK = {300,      -2048, 8, -8, 0, 1<<4}; */
 	WR16(devAddr, SCU_RAM_ORX_TIM_LOCK_TH__A, 400);
-	WR16(devAddr, SCU_RAM_ORX_TIM_LOCK_TOTH__A, (u16_t) (-2048));
+	WR16(devAddr, SCU_RAM_ORX_TIM_LOCK_TOTH__A, (u16) (-2048));
 	WR16(devAddr, SCU_RAM_ORX_TIM_ONLOCK_TTH__A, 8);
-	WR16(devAddr, SCU_RAM_ORX_TIM_UNLOCK_TTH__A, (u16_t) (-8));
+	WR16(devAddr, SCU_RAM_ORX_TIM_UNLOCK_TTH__A, (u16) (-8));
 	WR16(devAddr, SCU_RAM_ORX_TIM_LOCK_MASK__A, 1 << 4);
 
 	/* EQU_LOCK = {20,      -2048, 8, -8, 0, 1<<5}; */
 	WR16(devAddr, SCU_RAM_ORX_EQU_LOCK_TH__A, 20);
-	WR16(devAddr, SCU_RAM_ORX_EQU_LOCK_TOTH__A, (u16_t) (-2048));
+	WR16(devAddr, SCU_RAM_ORX_EQU_LOCK_TOTH__A, (u16) (-2048));
 	WR16(devAddr, SCU_RAM_ORX_EQU_ONLOCK_TTH__A, 4);
-	WR16(devAddr, SCU_RAM_ORX_EQU_UNLOCK_TTH__A, (u16_t) (-4));
+	WR16(devAddr, SCU_RAM_ORX_EQU_UNLOCK_TTH__A, (u16) (-4));
 	WR16(devAddr, SCU_RAM_ORX_EQU_LOCK_MASK__A, 1 << 5);
 
 	/* PRE-Filter coefficients (PFI) */
 	WRB(devAddr, ORX_FWP_PFI_A_W__A, sizeof(PFICoeffs[mode_index]),
-	    ((pu8_t) PFICoeffs[mode_index]));
+	    ((u8 *) PFICoeffs[mode_index]));
 	WR16(devAddr, ORX_TOP_MDE_W__A, mode_index);
 
 	/* NYQUIST-Filter coefficients (NYQ) */
@@ -12752,7 +12752,7 @@ CtrlGetOOB(pDRXDemodInstance_t demod, pDRXOOBStatus_t oobStatus)
 #ifndef DRXJ_DIGITAL_ONLY
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	u16_t data = 0;
+	u16 data = 0;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -12791,7 +12791,7 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static DRXStatus_t
-CtrlSetCfgOOBPreSAW(pDRXDemodInstance_t demod, pu16_t cfgData)
+CtrlSetCfgOOBPreSAW(pDRXDemodInstance_t demod, u16 *cfgData)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
@@ -12818,7 +12818,7 @@ rw_error:
 */
 #ifndef DRXJ_DIGITAL_ONLY
 static DRXStatus_t
-CtrlGetCfgOOBPreSAW(pDRXDemodInstance_t demod, pu16_t cfgData)
+CtrlGetCfgOOBPreSAW(pDRXDemodInstance_t demod, u16 *cfgData)
 {
 	pDRXJData_t extAttr = NULL;
 
@@ -12919,8 +12919,8 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	pDRXCommonAttr_t commonAttr = NULL;
 	Bool_t bridgeClosed = FALSE;
 #ifndef DRXJ_VSB_ONLY
-	u32_t minSymbolRate = 0;
-	u32_t maxSymbolRate = 0;
+	u32 minSymbolRate = 0;
+	u32 maxSymbolRate = 0;
 	int bandwidthTemp = 0;
 	int bandwidth = 0;
 #endif
@@ -13295,9 +13295,9 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	pDRXCommonAttr_t commonAttr = NULL;
 	DRXFrequency_t intermediateFreq = 0;
-	s32_t CTLFreqOffset = 0;
-	u32_t iqmRcRateLo = 0;
-	u32_t adcFrequency = 0;
+	s32 CTLFreqOffset = 0;
+	u32 iqmRcRateLo = 0;
+	u32 adcFrequency = 0;
 #ifndef DRXJ_VSB_ONLY
 	int bandwidthTemp = 0;
 	int bandwidth = 0;
@@ -13389,7 +13389,7 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 				} else {
 					/* annex A & C */
 
-					u32_t rollOff = 113;	/* default annex C */
+					u32 rollOff = 113;	/* default annex C */
 
 					if (standard == DRX_STANDARD_ITU_A) {
 						rollOff = 115;
@@ -13424,7 +13424,7 @@ CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 						/* parameter    */ NULL,
 						/* result       */ NULL
 					};
-					u16_t cmdResult[3] = { 0, 0, 0 };
+					u16 cmdResult[3] = { 0, 0, 0 };
 
 					cmdSCU.command =
 					    SCU_RAM_COMMAND_STANDARD_QAM |
@@ -13499,10 +13499,10 @@ rw_error:
   ===== SigQuality() ==========================================================
   ===========================================================================*/
 
-static u16_t
-mer2indicator(u16_t mer, u16_t minMer, u16_t thresholdMer, u16_t maxMer)
+static u16
+mer2indicator(u16 mer, u16 minMer, u16 thresholdMer, u16 maxMer)
 {
-	u16_t indicator = 0;
+	u16 indicator = 0;
 
 	if (mer < minMer) {
 		indicator = 0;
@@ -13544,9 +13544,9 @@ CtrlSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
-	u16_t minMer = 0;
-	u16_t maxMer = 0;
-	u16_t thresholdMer = 0;
+	u16 minMer = 0;
+	u16 maxMer = 0;
+	u16 thresholdMer = 0;
 
 	/* Check arguments */
 	if ((sigQuality == NULL) || (demod == NULL)) {
@@ -13683,8 +13683,8 @@ CtrlLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat)
 		/* *parameter   */ NULL,
 		/* *result      */ NULL
 	};
-	u16_t cmdResult[2] = { 0, 0 };
-	u16_t demodLock = SCU_RAM_PARAM_1_RES_DEMOD_GET_LOCK_DEMOD_LOCKED;
+	u16 cmdResult[2] = { 0, 0 };
+	u16 demodLock = SCU_RAM_PARAM_1_RES_DEMOD_GET_LOCK_DEMOD_LOCKED;
 
 	/* check arguments */
 	if ((demod == NULL) || (lockStat == NULL)) {
@@ -13939,12 +13939,12 @@ rw_error:
 /**
 * \fn DRXStatus_t CtrlGetCfgSymbolClockOffset()
 * \brief Get frequency offsets of STR.
-* \param pointer to s32_t.
+* \param pointer to s32.
 * \return DRXStatus_t.
 *
 */
 static DRXStatus_t
-CtrlGetCfgSymbolClockOffset(pDRXDemodInstance_t demod, ps32_t rateOffset)
+CtrlGetCfgSymbolClockOffset(pDRXDemodInstance_t demod, s32 *rateOffset)
 {
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	struct i2c_device_addr *devAddr = NULL;
@@ -13999,7 +13999,7 @@ CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode)
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
-	u16_t sioCcPwdMode = 0;
+	u16 sioCcPwdMode = 0;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -14127,17 +14127,17 @@ CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	u16_t ucodeMajorMinor = 0;	/* BCD Ma:Ma:Ma:Mi */
-	u16_t ucodePatch = 0;	/* BCD Pa:Pa:Pa:Pa */
-	u16_t major = 0;
-	u16_t minor = 0;
-	u16_t patch = 0;
-	u16_t idx = 0;
-	u32_t jtag = 0;
-	u16_t subtype = 0;
-	u16_t mfx = 0;
-	u16_t bid = 0;
-	u16_t key = 0;
+	u16 ucodeMajorMinor = 0;	/* BCD Ma:Ma:Ma:Mi */
+	u16 ucodePatch = 0;	/* BCD Pa:Pa:Pa:Pa */
+	u16 major = 0;
+	u16 minor = 0;
+	u16 patch = 0;
+	u16 idx = 0;
+	u32 jtag = 0;
+	u16 subtype = 0;
+	u16 mfx = 0;
+	u16 bid = 0;
+	u16 key = 0;
 
 	static char ucodeName[] = "Microcode";
 	static char deviceName[] = "Device";
@@ -14225,8 +14225,8 @@ CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 
 	/* DRX39xxJ type Ax */
 	/* TODO semantics of mfx and spin are unclear */
-	subtype = (u16_t) ((jtag >> 12) & 0xFF);
-	mfx = (u16_t) (jtag >> 29);
+	subtype = (u16) ((jtag >> 12) & 0xFF);
+	mfx = (u16) (jtag >> 29);
 	extAttr->vVersion[1].vMinor = 1;
 	if (mfx == 0x03) {
 		extAttr->vVersion[1].vPatch = mfx + 2;
@@ -14284,7 +14284,7 @@ static DRXStatus_t CtrlProbeDevice(pDRXDemodInstance_t demod)
 	    || commonAttr->currentPowerMode != DRX_POWER_UP) {
 		struct i2c_device_addr *devAddr = NULL;
 		DRXPowerMode_t powerMode = DRX_POWER_UP;
-		u32_t jtag = 0;
+		u32 jtag = 0;
 
 		devAddr = demod->myI2CDevAddr;
 
@@ -14349,7 +14349,7 @@ rw_error:
 		     FALSE if MC block not Audio
 * \return Bool_t.
 */
-Bool_t IsMCBlockAudio(u32_t addr)
+Bool_t IsMCBlockAudio(u32 addr)
 {
 	if ((addr == AUD_XFP_PRAM_4K__A) || (addr == AUD_XDFP_PRAM_4K__A)) {
 		return (TRUE);
@@ -14374,10 +14374,10 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 		pDRXUCodeInfo_t mcInfo,
 		DRXUCodeAction_t action, Bool_t uploadAudioMC)
 {
-	u16_t i = 0;
-	u16_t mcNrOfBlks = 0;
-	u16_t mcMagicWord = 0;
-	pu8_t mcData = (pu8_t) (NULL);
+	u16 i = 0;
+	u16 mcNrOfBlks = 0;
+	u16 mcMagicWord = 0;
+	u8 *mcData = (u8 *) (NULL);
 	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 
@@ -14394,9 +14394,9 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 
 	/* Check data */
 	mcMagicWord = UCodeRead16(mcData);
-	mcData += sizeof(u16_t);
+	mcData += sizeof(u16);
 	mcNrOfBlks = UCodeRead16(mcData);
-	mcData += sizeof(u16_t);
+	mcData += sizeof(u16);
 
 	if ((mcMagicWord != DRXJ_UCODE_MAGIC_WORD) || (mcNrOfBlks == 0)) {
 		/* wrong endianess or wrong data ? */
@@ -14406,17 +14406,17 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 	/* Process microcode blocks */
 	for (i = 0; i < mcNrOfBlks; i++) {
 		DRXUCodeBlockHdr_t blockHdr;
-		u16_t mcBlockNrBytes = 0;
+		u16 mcBlockNrBytes = 0;
 
 		/* Process block header */
 		blockHdr.addr = UCodeRead32(mcData);
-		mcData += sizeof(u32_t);
+		mcData += sizeof(u32);
 		blockHdr.size = UCodeRead16(mcData);
-		mcData += sizeof(u16_t);
+		mcData += sizeof(u16);
 		blockHdr.flags = UCodeRead16(mcData);
-		mcData += sizeof(u16_t);
+		mcData += sizeof(u16);
 		blockHdr.CRC = UCodeRead16(mcData);
-		mcData += sizeof(u16_t);
+		mcData += sizeof(u16);
 
 		/* Check block header on:
 		   - no data
@@ -14432,7 +14432,7 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 			return DRX_STS_INVALID_ARG;
 		}
 
-		mcBlockNrBytes = blockHdr.size * sizeof(u16_t);
+		mcBlockNrBytes = blockHdr.size * sizeof(u16);
 
 		/* Perform the desired action */
 		/* Check which part of MC need to be uploaded - Audio or not Audio */
@@ -14458,12 +14458,12 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 			case UCODE_VERIFY:
 				{
 					int result = 0;
-					u8_t mcDataBuffer
+					u8 mcDataBuffer
 					    [DRXJ_UCODE_MAX_BUF_SIZE];
-					u32_t bytesToCompare = 0;
-					u32_t bytesLeftToCompare = 0;
+					u32 bytesToCompare = 0;
+					u32 bytesLeftToCompare = 0;
 					DRXaddr_t currAddr = (DRXaddr_t) 0;
-					pu8_t currPtr = NULL;
+					u8 *currPtr = NULL;
 
 					bytesLeftToCompare = mcBlockNrBytes;
 					currAddr = blockHdr.addr;
@@ -14471,10 +14471,10 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 
 					while (bytesLeftToCompare != 0) {
 						if (bytesLeftToCompare >
-						    ((u32_t)
+						    ((u32)
 						     DRXJ_UCODE_MAX_BUF_SIZE)) {
 							bytesToCompare =
-							    ((u32_t)
+							    ((u32)
 							     DRXJ_UCODE_MAX_BUF_SIZE);
 						} else {
 							bytesToCompare =
@@ -14484,9 +14484,9 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 						if (demod->myAccessFunct->
 						    readBlockFunc(devAddr,
 								  currAddr,
-								  (u16_t)
+								  (u16)
 								  bytesToCompare,
-								  (pu8_t)
+								  (u8 *)
 								  mcDataBuffer,
 								  0x0000) !=
 						    DRX_STS_OK) {
@@ -14508,7 +14508,7 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 						currPtr =
 						    &(currPtr[bytesToCompare]);
 						bytesLeftToCompare -=
-						    ((u32_t) bytesToCompare);
+						    ((u32) bytesToCompare);
 					}	/* while( bytesToCompare > DRXJ_UCODE_MAX_BUF_SIZE ) */
 				};
 				break;
@@ -14551,7 +14551,7 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 
 */
 static DRXStatus_t
-CtrlSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
+CtrlSigStrength(pDRXDemodInstance_t demod, u16 *sigStrength)
 {
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
@@ -14611,11 +14611,11 @@ static DRXStatus_t
 CtrlGetCfgOOBMisc(pDRXDemodInstance_t demod, pDRXJCfgOOBMisc_t misc)
 {
 	struct i2c_device_addr *devAddr = NULL;
-	u16_t lock = 0U;
-	u16_t state = 0U;
-	u16_t data = 0U;
-	u16_t digitalAGCMant = 0U;
-	u16_t digitalAGCExp = 0U;
+	u16 lock = 0U;
+	u16 state = 0U;
+	u16 data = 0U;
+	u16 digitalAGCMant = 0U;
+	u16 digitalAGCExp = 0U;
 
 	/* check arguments */
 	if (misc == NULL) {
@@ -14889,7 +14889,7 @@ CtrlGetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 * \fn DRXStatus_t CtrlGetCfgAgcInternal()
 * \brief Retrieve internal AGC value.
 * \param demod demod instance
-* \param u16_t
+* \param u16
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -14897,15 +14897,15 @@ CtrlGetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 *
 */
 static DRXStatus_t
-CtrlGetCfgAgcInternal(pDRXDemodInstance_t demod, pu16_t agcInternal)
+CtrlGetCfgAgcInternal(pDRXDemodInstance_t demod, u16 *agcInternal)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	pDRXJData_t extAttr = NULL;
-	u16_t iqmCfScaleSh = 0;
-	u16_t iqmCfPower = 0;
-	u16_t iqmCfAmp = 0;
-	u16_t iqmCfGain = 0;
+	u16 iqmCfScaleSh = 0;
+	u16 iqmCfPower = 0;
+	u16 iqmCfAmp = 0;
+	u16 iqmCfGain = 0;
 
 	/* check arguments */
 	if (agcInternal == NULL) {
@@ -14957,7 +14957,7 @@ CtrlGetCfgAgcInternal(pDRXDemodInstance_t demod, pu16_t agcInternal)
 	   -IQM_CF_Gain_dB-18+6*(27-IQM_CF_SCALE_SH*2-10)
 	   +6*7+10*log10(1+0.115/4); */
 	/* PadcdB = P4dB +3 -6 +60; dBmV */
-	*agcInternal = (u16_t) (Log10Times100(iqmCfPower)
+	*agcInternal = (u16) (Log10Times100(iqmCfPower)
 				- 2 * Log10Times100(iqmCfAmp)
 				- iqmCfGain - 120 * iqmCfScaleSh + 781);
 
@@ -14972,7 +14972,7 @@ rw_error:
 * \fn DRXStatus_t CtrlSetCfgPreSaw()
 * \brief Set Pre-saw reference.
 * \param demod demod instance
-* \param pu16_t
+* \param u16 *
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -15041,7 +15041,7 @@ rw_error:
 * \fn DRXStatus_t CtrlSetCfgAfeGain()
 * \brief Set AFE Gain.
 * \param demod demod instance
-* \param pu16_t
+* \param u16 *
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -15053,7 +15053,7 @@ CtrlSetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 {
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
-	u8_t gain = 0;
+	u8 gain = 0;
 
 	/* check arguments */
 	if (afeGain == NULL) {
@@ -15117,7 +15117,7 @@ rw_error:
 * \fn DRXStatus_t CtrlGetCfgPreSaw()
 * \brief Get Pre-saw reference setting.
 * \param demod demod instance
-* \param pu16_t
+* \param u16 *
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -15177,7 +15177,7 @@ CtrlGetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 * \fn DRXStatus_t CtrlGetCfgAfeGain()
 * \brief Get AFE Gain.
 * \param demod demod instance
-* \param pu16_t
+* \param u16 *
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -15222,7 +15222,7 @@ CtrlGetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 * \fn DRXStatus_t CtrlGetFecMeasSeqCount()
 * \brief Get FEC measurement sequnce number.
 * \param demod demod instance
-* \param pu16_t
+* \param u16 *
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -15230,7 +15230,7 @@ CtrlGetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 *
 */
 static DRXStatus_t
-CtrlGetFecMeasSeqCount(pDRXDemodInstance_t demod, pu16_t fecMeasSeqCount)
+CtrlGetFecMeasSeqCount(pDRXDemodInstance_t demod, u16 *fecMeasSeqCount)
 {
 	/* check arguments */
 	if (fecMeasSeqCount == NULL) {
@@ -15250,7 +15250,7 @@ rw_error:
 * \fn DRXStatus_t CtrlGetAccumCrRSCwErr()
 * \brief Get accumulative corrected RS codeword number.
 * \param demod demod instance
-* \param pu32_t
+* \param u32 *
 * \return DRXStatus_t.
 *
 * Check arguments
@@ -15258,7 +15258,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-CtrlGetAccumCrRSCwErr(pDRXDemodInstance_t demod, pu32_t accumCrRsCWErr)
+CtrlGetAccumCrRSCwErr(pDRXDemodInstance_t demod, u32 *accumCrRsCWErr)
 {
 	if (accumCrRsCWErr == NULL) {
 		return (DRX_STS_INVALID_ARG);
@@ -15312,7 +15312,7 @@ static DRXStatus_t CtrlSetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 		return CtrlSetCfgResetPktErr(demod);
 #ifndef DRXJ_DIGITAL_ONLY
 	case DRXJ_CFG_OOB_PRE_SAW:
-		return CtrlSetCfgOOBPreSAW(demod, (pu16_t) (config->cfgData));
+		return CtrlSetCfgOOBPreSAW(demod, (u16 *) (config->cfgData));
 	case DRXJ_CFG_OOB_LO_POW:
 		return CtrlSetCfgOOBLoPower(demod,
 					    (pDRXJCfgOobLoPower_t) (config->
@@ -15408,7 +15408,7 @@ static DRXStatus_t CtrlGetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 	case DRXJ_CFG_AGC_IF:
 		return CtrlGetCfgAgcIf(demod, (pDRXJCfgAgc_t) config->cfgData);
 	case DRXJ_CFG_AGC_INTERNAL:
-		return CtrlGetCfgAgcInternal(demod, (pu16_t) config->cfgData);
+		return CtrlGetCfgAgcInternal(demod, (u16 *) config->cfgData);
 	case DRXJ_CFG_PRE_SAW:
 		return CtrlGetCfgPreSaw(demod,
 					(pDRXJCfgPreSaw_t) config->cfgData);
@@ -15416,21 +15416,21 @@ static DRXStatus_t CtrlGetCfg(pDRXDemodInstance_t demod, pDRXCfg_t config)
 		return CtrlGetCfgAfeGain(demod,
 					 (pDRXJCfgAfeGain_t) config->cfgData);
 	case DRXJ_CFG_ACCUM_CR_RS_CW_ERR:
-		return CtrlGetAccumCrRSCwErr(demod, (pu32_t) config->cfgData);
+		return CtrlGetAccumCrRSCwErr(demod, (u32 *) config->cfgData);
 	case DRXJ_CFG_FEC_MERS_SEQ_COUNT:
-		return CtrlGetFecMeasSeqCount(demod, (pu16_t) config->cfgData);
+		return CtrlGetFecMeasSeqCount(demod, (u16 *) config->cfgData);
 	case DRXJ_CFG_VSB_MISC:
 		return CtrlGetCfgVSBMisc(demod,
 					 (pDRXJCfgVSBMisc_t) config->cfgData);
 	case DRXJ_CFG_SYMBOL_CLK_OFFSET:
 		return CtrlGetCfgSymbolClockOffset(demod,
-						   (ps32_t) config->cfgData);
+						   (s32 *) config->cfgData);
 #ifndef DRXJ_DIGITAL_ONLY
 	case DRXJ_CFG_OOB_MISC:
 		return CtrlGetCfgOOBMisc(demod,
 					 (pDRXJCfgOOBMisc_t) config->cfgData);
 	case DRXJ_CFG_OOB_PRE_SAW:
-		return CtrlGetCfgOOBPreSAW(demod, (pu16_t) (config->cfgData));
+		return CtrlGetCfgOOBPreSAW(demod, (u16 *) (config->cfgData));
 	case DRXJ_CFG_OOB_LO_POW:
 		return CtrlGetCfgOOBLoPower(demod,
 					    (pDRXJCfgOobLoPower_t) (config->
@@ -15526,7 +15526,7 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
-	u32_t driverVersion = 0;
+	u32 driverVersion = 0;
 	DRXUCodeInfo_t ucodeInfo;
 	DRXCfgMPEGOutput_t cfgMPEGOutput;
 
@@ -15718,9 +15718,9 @@ DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 	driverVersion += (VERSION_PATCH / 10) % 10;
 	driverVersion <<= 4;
 	driverVersion += (VERSION_PATCH % 10);
-	WR16(devAddr, SCU_RAM_DRIVER_VER_HI__A, (u16_t) (driverVersion >> 16));
+	WR16(devAddr, SCU_RAM_DRIVER_VER_HI__A, (u16) (driverVersion >> 16));
 	WR16(devAddr, SCU_RAM_DRIVER_VER_LO__A,
-	     (u16_t) (driverVersion & 0xFFFF));
+	     (u16) (driverVersion & 0xFFFF));
 
 	/* refresh the audio data structure with default */
 	extAttr->audData = DRXJDefaultAudData_g;
@@ -15806,7 +15806,7 @@ DRXJ_Ctrl(pDRXDemodInstance_t demod, DRXCtrlIndex_t ctrl, void *ctrlData)
       /*======================================================================*/
 	case DRX_CTRL_SIG_STRENGTH:
 		{
-			return CtrlSigStrength(demod, (pu16_t) ctrlData);
+			return CtrlSigStrength(demod, (u16 *) ctrlData);
 		}
 		break;
       /*======================================================================*/
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index dbd27da9de7f..29b6450fb3c4 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -75,15 +75,15 @@ TYPEDEFS
 /*============================================================================*/
 
 	typedef struct {
-		u16_t command;
+		u16 command;
 			/**< Command number */
-		u16_t parameterLen;
+		u16 parameterLen;
 			/**< Data length in byte */
-		u16_t resultLen;
+		u16 resultLen;
 			/**< result length in byte */
-		u16_t *parameter;
+		u16 *parameter;
 			/**< General purpous param */
-		u16_t *result;
+		u16 *result;
 			/**< General purpous param */
 	} DRXJSCUCmd_t, *pDRXJSCUCmd_t;
 
@@ -154,7 +154,7 @@ TYPEDEFS
 */
 	typedef struct {
 		DRXJCfgSmartAntIO_t io;
-		u16_t ctrlData;
+		u16 ctrlData;
 	} DRXJCfgSmartAnt_t, *pDRXJCfgSmartAnt_t;
 
 /**
@@ -162,9 +162,9 @@ TYPEDEFS
 * AGC status information from the DRXJ-IQM-AF.
 */
 	typedef struct {
-		u16_t IFAGC;
-		u16_t RFAGC;
-		u16_t DigitalAGC;
+		u16 IFAGC;
+		u16 RFAGC;
+		u16 DigitalAGC;
 	} DRXJAgcStatus_t, *pDRXJAgcStatus_t;
 
 /* DRXJ_CFG_AGC_RF, DRXJ_CFG_AGC_IF */
@@ -186,12 +186,12 @@ TYPEDEFS
 	typedef struct {
 		DRXStandard_t standard;	/* standard for which these settings apply */
 		DRXJAgcCtrlMode_t ctrlMode;	/* off, user, auto          */
-		u16_t outputLevel;	/* range dependent on AGC   */
-		u16_t minOutputLevel;	/* range dependent on AGC   */
-		u16_t maxOutputLevel;	/* range dependent on AGC   */
-		u16_t speed;	/* range dependent on AGC   */
-		u16_t top;	/* rf-agc take over point   */
-		u16_t cutOffCurrent;	/* rf-agc is accelerated if output current
+		u16 outputLevel;	/* range dependent on AGC   */
+		u16 minOutputLevel;	/* range dependent on AGC   */
+		u16 maxOutputLevel;	/* range dependent on AGC   */
+		u16 speed;	/* range dependent on AGC   */
+		u16 top;	/* rf-agc take over point   */
+		u16 cutOffCurrent;	/* rf-agc is accelerated if output current
 					   is below cut-off current                */
 	} DRXJCfgAgc_t, *pDRXJCfgAgc_t;
 
@@ -203,7 +203,7 @@ TYPEDEFS
 */
 	typedef struct {
 		DRXStandard_t standard;	/* standard to which these settings apply */
-		u16_t reference;	/* pre SAW reference value, range 0 .. 31 */
+		u16 reference;	/* pre SAW reference value, range 0 .. 31 */
 		Bool_t usePreSaw;	/* TRUE algorithms must use pre SAW sense */
 	} DRXJCfgPreSaw_t, *pDRXJCfgPreSaw_t;
 
@@ -215,7 +215,7 @@ TYPEDEFS
 */
 	typedef struct {
 		DRXStandard_t standard;	/* standard to which these settings apply */
-		u16_t gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */
+		u16 gain;	/* gain in 0.1 dB steps, DRXJ range 140 .. 335 */
 	} DRXJCfgAfeGain_t, *pDRXJCfgAfeGain_t;
 
 /**
@@ -226,15 +226,15 @@ TYPEDEFS
 *
 */
 	typedef struct {
-		u16_t nrBitErrors;
+		u16 nrBitErrors;
 				/**< no of pre RS bit errors          */
-		u16_t nrSymbolErrors;
+		u16 nrSymbolErrors;
 				/**< no of pre RS symbol errors       */
-		u16_t nrPacketErrors;
+		u16 nrPacketErrors;
 				/**< no of pre RS packet errors       */
-		u16_t nrFailures;
+		u16 nrFailures;
 				/**< no of post RS failures to decode */
-		u16_t nrSncParFailCount;
+		u16 nrSncParFailCount;
 				/**< no of post RS bit erros          */
 	} DRXJRSErrors_t, *pDRXJRSErrors_t;
 
@@ -243,7 +243,7 @@ TYPEDEFS
 * symbol error rate
 */
 	typedef struct {
-		u32_t symbError;
+		u32 symbError;
 			      /**< symbol error rate sps */
 	} DRXJCfgVSBMisc_t, *pDRXJCfgVSBMisc_t;
 
@@ -321,8 +321,8 @@ TYPEDEFS
  *  DRXJ_CFG_ATV_MISC
  */
 	typedef struct {
-		s16_t peakFilter;	/* -8 .. 15 */
-		u16_t noiseFilter;	/* 0 .. 15 */
+		s16 peakFilter;	/* -8 .. 15 */
+		u16 noiseFilter;	/* 0 .. 15 */
 	} DRXJCfgAtvMisc_t, *pDRXJCfgAtvMisc_t;
 
 /*
@@ -347,7 +347,7 @@ TYPEDEFS
 		Bool_t freqLock;
 		Bool_t digGainLock;
 		Bool_t anaGainLock;
-		u8_t state;
+		u8 state;
 	} DRXJCfgOOBMisc_t, *pDRXJCfgOOBMisc_t;
 
 /*
@@ -365,10 +365,10 @@ TYPEDEFS
  *  DRXJ_CFG_ATV_EQU_COEF
  */
 	typedef struct {
-		s16_t coef0;	/* -256 .. 255 */
-		s16_t coef1;	/* -256 .. 255 */
-		s16_t coef2;	/* -256 .. 255 */
-		s16_t coef3;	/* -256 .. 255 */
+		s16 coef0;	/* -256 .. 255 */
+		s16 coef1;	/* -256 .. 255 */
+		s16 coef2;	/* -256 .. 255 */
+		s16 coef3;	/* -256 .. 255 */
 	} DRXJCfgAtvEquCoef_t, *pDRXJCfgAtvEquCoef_t;
 
 /*
@@ -417,13 +417,13 @@ TYPEDEFS
 */
 /* TODO : AFE interface not yet finished, subject to change */
 	typedef struct {
-		u16_t rfAgcGain;	/* 0 .. 877 uA */
-		u16_t ifAgcGain;	/* 0 .. 877  uA */
-		s16_t videoAgcGain;	/* -75 .. 1972 in 0.1 dB steps */
-		s16_t audioAgcGain;	/* -4 .. 1020 in 0.1 dB steps */
-		u16_t rfAgcLoopGain;	/* 0 .. 7 */
-		u16_t ifAgcLoopGain;	/* 0 .. 7 */
-		u16_t videoAgcLoopGain;	/* 0 .. 7 */
+		u16 rfAgcGain;	/* 0 .. 877 uA */
+		u16 ifAgcGain;	/* 0 .. 877  uA */
+		s16 videoAgcGain;	/* -75 .. 1972 in 0.1 dB steps */
+		s16 audioAgcGain;	/* -4 .. 1020 in 0.1 dB steps */
+		u16 rfAgcLoopGain;	/* 0 .. 7 */
+		u16 ifAgcLoopGain;	/* 0 .. 7 */
+		u16 videoAgcLoopGain;	/* 0 .. 7 */
 	} DRXJCfgAtvAgcStatus_t, *pDRXJCfgAtvAgcStatus_t;
 
 /*============================================================================*/
@@ -456,7 +456,7 @@ TYPEDEFS
 		Bool_t hasGPIO;		  /**< TRUE if GPIO is available */
 		Bool_t hasIRQN;		  /**< TRUE if IRQN is available */
 		/* A1/A2/A... */
-		u8_t mfx;		  /**< metal fix */
+		u8 mfx;		  /**< metal fix */
 
 		/* tuner settings */
 		Bool_t mirrorFreqSpectOOB;/**< tuner inversion (TRUE = tuner mirrors the signal */
@@ -471,22 +471,22 @@ TYPEDEFS
 		DRXMirror_t mirror;	  /**< current channel mirror                           */
 
 		/* signal quality information */
-		u32_t fecBitsDesired;	  /**< BER accounting period                            */
-		u16_t fecVdPlen;	  /**< no of trellis symbols: VD SER measurement period */
-		u16_t qamVdPrescale;	  /**< Viterbi Measurement Prescale                     */
-		u16_t qamVdPeriod;	  /**< Viterbi Measurement period                       */
-		u16_t fecRsPlen;	  /**< defines RS BER measurement period                */
-		u16_t fecRsPrescale;	  /**< ReedSolomon Measurement Prescale                 */
-		u16_t fecRsPeriod;	  /**< ReedSolomon Measurement period                   */
+		u32 fecBitsDesired;	  /**< BER accounting period                            */
+		u16 fecVdPlen;	  /**< no of trellis symbols: VD SER measurement period */
+		u16 qamVdPrescale;	  /**< Viterbi Measurement Prescale                     */
+		u16 qamVdPeriod;	  /**< Viterbi Measurement period                       */
+		u16 fecRsPlen;	  /**< defines RS BER measurement period                */
+		u16 fecRsPrescale;	  /**< ReedSolomon Measurement Prescale                 */
+		u16 fecRsPeriod;	  /**< ReedSolomon Measurement period                   */
 		Bool_t resetPktErrAcc;	  /**< Set a flag to reset accumulated packet error     */
-		u16_t pktErrAccStart;	  /**< Set a flag to reset accumulated packet error     */
+		u16 pktErrAccStart;	  /**< Set a flag to reset accumulated packet error     */
 
 		/* HI configuration */
-		u16_t HICfgTimingDiv;	  /**< HI Configure() parameter 2                       */
-		u16_t HICfgBridgeDelay;	  /**< HI Configure() parameter 3                       */
-		u16_t HICfgWakeUpKey;	  /**< HI Configure() parameter 4                       */
-		u16_t HICfgCtrl;	  /**< HI Configure() parameter 5                       */
-		u16_t HICfgTransmit;	  /**< HI Configure() parameter 6                       */
+		u16 HICfgTimingDiv;	  /**< HI Configure() parameter 2                       */
+		u16 HICfgBridgeDelay;	  /**< HI Configure() parameter 3                       */
+		u16 HICfgWakeUpKey;	  /**< HI Configure() parameter 4                       */
+		u16 HICfgCtrl;	  /**< HI Configure() parameter 5                       */
+		u16 HICfgTransmit;	  /**< HI Configure() parameter 6                       */
 
 		/* UIO configuartion */
 		DRXUIOMode_t uioSmaRxMode;/**< current mode of SmaRx pin                        */
@@ -495,20 +495,20 @@ TYPEDEFS
 		DRXUIOMode_t uioIRQNMode; /**< current mode of IRQN pin                         */
 
 		/* IQM fs frequecy shift and inversion */
-		u32_t iqmFsRateOfs;	   /**< frequency shifter setting after setchannel      */
+		u32 iqmFsRateOfs;	   /**< frequency shifter setting after setchannel      */
 		Bool_t posImage;	   /**< Ture: positive image                            */
 		/* IQM RC frequecy shift */
-		u32_t iqmRcRateOfs;	   /**< frequency shifter setting after setchannel      */
+		u32 iqmRcRateOfs;	   /**< frequency shifter setting after setchannel      */
 
 		/* ATV configuartion */
-		u32_t atvCfgChangedFlags; /**< flag: flags cfg changes */
-		s16_t atvTopEqu0[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU0__A */
-		s16_t atvTopEqu1[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU1__A */
-		s16_t atvTopEqu2[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU2__A */
-		s16_t atvTopEqu3[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU3__A */
+		u32 atvCfgChangedFlags; /**< flag: flags cfg changes */
+		s16 atvTopEqu0[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU0__A */
+		s16 atvTopEqu1[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU1__A */
+		s16 atvTopEqu2[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU2__A */
+		s16 atvTopEqu3[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU3__A */
 		Bool_t phaseCorrectionBypass;/**< flag: TRUE=bypass */
-		s16_t atvTopVidPeak;	  /**< shadow of ATV_TOP_VID_PEAK__A */
-		u16_t atvTopNoiseTh;	  /**< shadow of ATV_TOP_NOISE_TH__A */
+		s16 atvTopVidPeak;	  /**< shadow of ATV_TOP_VID_PEAK__A */
+		u16 atvTopNoiseTh;	  /**< shadow of ATV_TOP_NOISE_TH__A */
 		Bool_t enableCVBSOutput;  /**< flag CVBS ouput enable */
 		Bool_t enableSIFOutput;	  /**< flag SIF ouput enable */
 		 DRXJSIFAttenuation_t sifAttenuation;
@@ -520,8 +520,8 @@ TYPEDEFS
 		DRXJCfgAgc_t vsbIfAgcCfg; /**< vsb IF AGC config */
 
 		/* PGA gain configuration for QAM and VSB */
-		u16_t qamPgaCfg;	  /**< qam PGA config */
-		u16_t vsbPgaCfg;	  /**< vsb PGA config */
+		u16 qamPgaCfg;	  /**< qam PGA config */
+		u16 vsbPgaCfg;	  /**< vsb PGA config */
 
 		/* Pre SAW configuration for QAM and VSB */
 		DRXJCfgPreSaw_t qamPreSawCfg;
@@ -539,11 +539,11 @@ TYPEDEFS
 		Bool_t smartAntInverted;
 
 		/* Tracking filter setting for OOB */
-		u16_t oobTrkFilterCfg[8];
+		u16 oobTrkFilterCfg[8];
 		Bool_t oobPowerOn;
 
 		/* MPEG static bitrate setting */
-		u32_t mpegTsStaticBitrate;  /**< bitrate static MPEG output */
+		u32 mpegTsStaticBitrate;  /**< bitrate static MPEG output */
 		Bool_t disableTEIhandling;  /**< MPEG TS TEI handling */
 		Bool_t bitReverseMpegOutout;/**< MPEG output bit order */
 		 DRXJMpegOutputClockRate_t mpegOutputClockRate;
@@ -556,19 +556,19 @@ TYPEDEFS
 					  /**< atv pre SAW config */
 		DRXJCfgAgc_t atvRfAgcCfg; /**< atv RF AGC config */
 		DRXJCfgAgc_t atvIfAgcCfg; /**< atv IF AGC config */
-		u16_t atvPgaCfg;	  /**< atv pga config    */
+		u16 atvPgaCfg;	  /**< atv pga config    */
 
-		u32_t currSymbolRate;
+		u32 currSymbolRate;
 
 		/* pin-safe mode */
 		Bool_t pdrSafeMode;	    /**< PDR safe mode activated      */
-		u16_t pdrSafeRestoreValGpio;
-		u16_t pdrSafeRestoreValVSync;
-		u16_t pdrSafeRestoreValSmaRx;
-		u16_t pdrSafeRestoreValSmaTx;
+		u16 pdrSafeRestoreValGpio;
+		u16 pdrSafeRestoreValVSync;
+		u16 pdrSafeRestoreValSmaRx;
+		u16 pdrSafeRestoreValSmaTx;
 
 		/* OOB pre-saw value */
-		u16_t oobPreSaw;
+		u16 oobPreSaw;
 		DRXJCfgOobLoPower_t oobLoPow;
 
 		DRXAudData_t audData;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
index 52a3cc3ff781..16f7a9f91fd8 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc.h
@@ -41,9 +41,9 @@
 #ifndef __DRXJ_MC_MAIN_H__
 #define __DRXJ_MC_MAIN_H__
 
-#define DRXJ_MC_MAIN ((pu8_t) drxj_mc_main_g)
+#define DRXJ_MC_MAIN ((u8 *) drxj_mc_main_g)
 
-const u8_t drxj_mc_main_g[] = {
+const u8 drxj_mc_main_g[] = {
 	0x48, 0x4c, 0x00, 0x06, 0x00, 0x00, 0xf3, 0x10, 0x00, 0x00, 0x00, 0x08,
 	    0x00, 0x00, 0x01, 0x07,
 	0x00, 0x00, 0x1f, 0xf0, 0x00, 0x01, 0xdd, 0x81, 0x00, 0x40, 0x0a, 0x00,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
index 20f3fe6a4102..211323591f77 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsb.h
@@ -41,9 +41,9 @@
 #ifndef __DRXJ_MC_VSB_H__
 #define __DRXJ_MC_VSB_H__
 
-#define DRXJ_MC_VSB ((pu8_t) drxj_mc_vsb_g)
+#define DRXJ_MC_VSB ((u8 *) drxj_mc_vsb_g)
 
-const u8_t drxj_mc_vsb_g[] = {
+const u8 drxj_mc_vsb_g[] = {
 	0x48, 0x4c, 0x00, 0x03, 0x00, 0x00, 0x2b, 0x62, 0x00, 0x00, 0x00, 0x08,
 	    0x00, 0x00, 0x00, 0x82,
 	0x00, 0x00, 0x15, 0x9e, 0x00, 0x01, 0x92, 0x3b, 0x2a, 0x02, 0xe4, 0xf8,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
index 480eb7e3f461..9996c693f9c8 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj_mc_vsbqam.h
@@ -42,9 +42,9 @@
 #ifndef __DRXJ_MC_VSBQAM_H__
 #define __DRXJ_MC_VSBQAM_H__
 
-#define DRXJ_MC_VSBQAM ((pu8_t) drxj_mc_vsbqam_g)
+#define DRXJ_MC_VSBQAM ((u8 *) drxj_mc_vsbqam_g)
 
-const u8_t drxj_mc_vsbqam_g[] = {
+const u8 drxj_mc_vsbqam_g[] = {
 	0x48, 0x4c, 0x00, 0x04, 0x00, 0x00, 0x56, 0xa0, 0x00, 0x00, 0x00, 0x08,
 	    0x00, 0x00, 0x00, 0x82,
 	0x00, 0x00, 0x20, 0x00, 0x00, 0x01, 0xc4, 0x4d, 0x55, 0x02, 0xe4, 0xee,
-- 
1.8.5.3

