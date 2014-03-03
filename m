Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49343 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaCCKHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:54 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 06/79] [media] drx-j: get rid of the typedefs on bsp_i2c.h
Date: Mon,  3 Mar 2014 07:06:00 -0300
Message-Id: <1393841233-24840-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Most of the hard work here were done by this small script:

for i in *; do sed s,pI2CDeviceAddr_t,"struct i2c_device_addr *",g <$i >a && mv a $i; done
for i in *; do sed s,I2CDeviceAddr_t,"struct i2c_device_addr",g <$i >a && mv a $i; done

Only bsp_i2c.h were added by hand.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h     |  71 +----
 drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h   |  10 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c    |   6 +-
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |   4 +-
 .../media/dvb-frontends/drx39xyj/drx_dap_fasi.c    |  62 ++--
 drivers/media/dvb-frontends/drx39xyj/drx_driver.c  |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |  28 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 334 ++++++++++-----------
 drivers/media/dvb-frontends/drx39xyj/drxj.h        |   2 +-
 9 files changed, 238 insertions(+), 281 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
index d71260240bda..ec2467b2c2a5 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
@@ -46,54 +46,19 @@
 
 #ifndef __BSPI2C_H__
 #define __BSPI2C_H__
-/*------------------------------------------------------------------------------
-INCLUDES
-------------------------------------------------------------------------------*/
-#include "bsp_types.h"
-
-/*------------------------------------------------------------------------------
-TYPEDEFS
-------------------------------------------------------------------------------*/
-
-/**
-* \struct _I2CDeviceAddr_t
-* \brief I2C device parameters.
-*
-* This structure contains the I2C address, the device ID and a userData pointer.
-* The userData pointer can be used for application specific purposes.
-*
-*/
-	struct I2CDeviceAddr_t {
-		u16 i2cAddr;
-			      /**< The I2C address of the device. */
-		u16 i2cDevId;
-			      /**< The device identifier. */
-		void *userData;
-			      /**< User data pointer */
-	};
-
-/**
-* \typedef I2CDeviceAddr_t
-* \brief I2C device parameters.
-*
-* This structure contains the I2C address and the device ID.
-*
-*/
-	typedef struct I2CDeviceAddr_t I2CDeviceAddr_t;
 
-/**
-* \typedef pI2CDeviceAddr_t
-* \brief Pointer to I2C device parameters.
-*/
-	typedef I2CDeviceAddr_t *pI2CDeviceAddr_t;
+#include "bsp_types.h"
 
-/*------------------------------------------------------------------------------
-DEFINES
-------------------------------------------------------------------------------*/
+/*
+ * This structure contains the I2C address, the device ID and a userData pointer.
+ * The userData pointer can be used for application specific purposes.
+ */
+struct i2c_device_addr {
+	u16 i2cAddr;		/* The I2C address of the device. */
+	u16 i2cDevId;		/* The device identifier. */
+	void *userData;		/* User data pointer */
+};
 
-/*------------------------------------------------------------------------------
-MACROS
-------------------------------------------------------------------------------*/
 
 /**
 * \def IS_I2C_10BIT( addr )
@@ -107,14 +72,6 @@ MACROS
 	 (((addr) & 0xF8) == 0xF0)
 
 /*------------------------------------------------------------------------------
-ENUM
-------------------------------------------------------------------------------*/
-
-/*------------------------------------------------------------------------------
-STRUCTS
-------------------------------------------------------------------------------*/
-
-/*------------------------------------------------------------------------------
 Exported FUNCTIONS
 ------------------------------------------------------------------------------*/
 
@@ -137,10 +94,10 @@ Exported FUNCTIONS
 	DRXStatus_t DRXBSP_I2C_Term(void);
 
 /**
-* \fn DRXStatus_t DRXBSP_I2C_WriteRead( pI2CDeviceAddr_t wDevAddr,
+* \fn DRXStatus_t DRXBSP_I2C_WriteRead( struct i2c_device_addr *wDevAddr,
 *                                       u16_t wCount,
 *                                       pu8_t wData,
-*                                       pI2CDeviceAddr_t rDevAddr,
+*                                       struct i2c_device_addr *rDevAddr,
 *                                       u16_t rCount,
 *                                       pu8_t rData)
 * \brief Read and/or write count bytes from I2C bus, store them in data[].
@@ -166,10 +123,10 @@ Exported FUNCTIONS
 * The device ID can be useful if several devices share an I2C address.
 * It can be used to control a "switch" on the I2C bus to the correct device.
 */
-	DRXStatus_t DRXBSP_I2C_WriteRead(pI2CDeviceAddr_t wDevAddr,
+	DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
 					 u16_t wCount,
 					 pu8_t wData,
-					 pI2CDeviceAddr_t rDevAddr,
+					 struct i2c_device_addr *rDevAddr,
 					 u16_t rCount, pu8_t rData);
 
 /**
diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
index 6a92a684c22e..1491358eba25 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_tuner.h
@@ -138,10 +138,10 @@ TYPEDEFS
 						     lockStat);
 
 	typedef DRXStatus_t(*TUNERi2cWriteReadFunc_t) (pTUNERInstance_t tuner,
-						       pI2CDeviceAddr_t
+						       struct i2c_device_addr *
 						       wDevAddr, u16_t wCount,
 						       pu8_t wData,
-						       pI2CDeviceAddr_t
+						       struct i2c_device_addr *
 						       rDevAddr, u16_t rCount,
 						       pu8_t rData);
 
@@ -157,7 +157,7 @@ TYPEDEFS
 
 	typedef struct TUNERInstance_s {
 
-		I2CDeviceAddr_t myI2CDevAddr;
+		struct i2c_device_addr myI2CDevAddr;
 		pTUNERCommonAttr_t myCommonAttr;
 		void *myExtAttr;
 		pTUNERFunc_t myFunct;
@@ -193,10 +193,10 @@ Exported FUNCTIONS
 					    pTUNERLockStatus_t lockStat);
 
 	DRXStatus_t DRXBSP_TUNER_DefaultI2CWriteRead(pTUNERInstance_t tuner,
-						     pI2CDeviceAddr_t wDevAddr,
+						     struct i2c_device_addr *wDevAddr,
 						     u16_t wCount,
 						     pu8_t wData,
-						     pI2CDeviceAddr_t rDevAddr,
+						     struct i2c_device_addr *rDevAddr,
 						     u16_t rCount, pu8_t rData);
 
 /*------------------------------------------------------------------------------
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 95ffc9832274..1ccb9921e9fa 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -327,7 +327,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 {
 	struct drx39xxj_state *state = NULL;
 
-	I2CDeviceAddr_t *demodAddr = NULL;
+	struct i2c_device_addr *demodAddr = NULL;
 	DRXCommonAttr_t *demodCommAttr = NULL;
 	DRXJData_t *demodExtAttr = NULL;
 	DRXDemodInstance_t *demod = NULL;
@@ -344,7 +344,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	if (demod == NULL)
 		goto error;
 
-	demodAddr = kmalloc(sizeof(I2CDeviceAddr_t), GFP_KERNEL);
+	demodAddr = kmalloc(sizeof(struct i2c_device_addr), GFP_KERNEL);
 	if (demodAddr == NULL)
 		goto error;
 
@@ -364,7 +364,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	demod->myI2CDevAddr = demodAddr;
 	memcpy(demod->myI2CDevAddr, &DRXJDefaultAddr_g,
-	       sizeof(I2CDeviceAddr_t));
+	       sizeof(struct i2c_device_addr));
 	demod->myI2CDevAddr->userData = state;
 	demod->myCommonAttr = demodCommAttr;
 	memcpy(demod->myCommonAttr, &DRXJDefaultCommAttr_g,
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
index 37967b2379b0..73fa63afc5f6 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
@@ -60,10 +60,10 @@ void *DRXBSP_HST_Memcpy(void *to, void *from, u32_t n)
 	return (memcpy(to, from, (size_t) n));
 }
 
-DRXStatus_t DRXBSP_I2C_WriteRead(pI2CDeviceAddr_t wDevAddr,
+DRXStatus_t DRXBSP_I2C_WriteRead(struct i2c_device_addr *wDevAddr,
 				 u16_t wCount,
 				 pu8_t wData,
-				 pI2CDeviceAddr_t rDevAddr,
+				 struct i2c_device_addr *rDevAddr,
 				 u16_t rCount, pu8_t rData)
 {
 	struct drx39xxj_state *state;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
index a4d3ed39fe58..472581e1c5dc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_dap_fasi.c
@@ -55,61 +55,61 @@
 /*============================================================================*/
 
 /* Function prototypes */
-static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register/memory   */
 					  u16_t datasize,	/* size of data                 */
 					  pu8_t data,	/* data to send                 */
 					  DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadBlock(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register/memory   */
 					 u16_t datasize,	/* size of data                 */
 					 pu8_t data,	/* data to send                 */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_WriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 u8_t data,	/* data to write                */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					DRXaddr_t addr,	/* address of register          */
 					pu8_t data,	/* buffer to receive data       */
 					DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t waddr,	/* address of register          */
 						   DRXaddr_t raddr,	/* address to read back from    */
 						   u8_t datain,	/* data to send                 */
 						   pu8_t dataout);	/* data to receive back         */
 
-static DRXStatus_t DRXDAP_FASI_WriteReg16(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register          */
 					  u16_t data,	/* data to write                */
 					  DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadReg16(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 pu16_t data,	/* buffer to receive data       */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
 						    u16_t datain,	/* data to send                 */
 						    pu16_t dataout);	/* data to receive back         */
 
-static DRXStatus_t DRXDAP_FASI_WriteReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					  DRXaddr_t addr,	/* address of register          */
 					  u32_t data,	/* data to write                */
 					  DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 pu32_t data,	/* buffer to receive data       */
 					 DRXflags_t flags);	/* special device flags         */
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
 						    u32_t datain,	/* data to send                 */
@@ -149,7 +149,7 @@ DRXAccessFunc_t drxDapFASIFunct_g = {
 
 /* Functions not supported by protocol*/
 
-static DRXStatus_t DRXDAP_FASI_WriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_WriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					 DRXaddr_t addr,	/* address of register          */
 					 u8_t data,	/* data to write                */
 					 DRXflags_t flags)
@@ -157,7 +157,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg8(pI2CDeviceAddr_t devAddr,	/* address of
 	return DRX_STS_ERROR;
 }
 
-static DRXStatus_t DRXDAP_FASI_ReadReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 					DRXaddr_t addr,	/* address of register          */
 					pu8_t data,	/* buffer to receive data       */
 					DRXflags_t flags)
@@ -165,7 +165,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg8(pI2CDeviceAddr_t devAddr,	/* address of
 	return DRX_STS_ERROR;
 }
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t waddr,	/* address of register          */
 						   DRXaddr_t raddr,	/* address to read back from    */
 						   u8_t datain,	/* data to send                 */
@@ -174,7 +174,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,	/*
 	return DRX_STS_ERROR;
 }
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						    DRXaddr_t waddr,	/* address of register          */
 						    DRXaddr_t raddr,	/* address to read back from    */
 						    u32_t datain,	/* data to send                 */
@@ -188,7 +188,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,	/*
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_ReadBlock (
-*      pI2CDeviceAddr_t devAddr,      -- address of I2C device
+*      struct i2c_device_addr *devAddr,      -- address of I2C device
 *      DRXaddr_t        addr,         -- address of chip register/memory
 *      u16_t            datasize,     -- number of bytes to read
 *      pu8_t            data,         -- data to receive
@@ -210,7 +210,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,	/*
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadBlock(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_ReadBlock(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 u16_t datasize,
 					 pu8_t data, DRXflags_t flags)
@@ -303,7 +303,7 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(pI2CDeviceAddr_t devAddr,
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16 (
-*      pI2CDeviceAddr_t devAddr,   -- address of I2C device
+*      struct i2c_device_addr *devAddr,   -- address of I2C device
 *      DRXaddr_t        waddr,     -- address of chip register/memory
 *      DRXaddr_t        raddr,     -- chip address to read back from
 *      u16_t            wdata,     -- data to send
@@ -325,7 +325,7 @@ static DRXStatus_t DRXDAP_FASI_ReadBlock(pI2CDeviceAddr_t devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						    DRXaddr_t waddr,
 						    DRXaddr_t raddr,
 						    u16_t wdata, pu16_t rdata)
@@ -349,7 +349,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_ReadReg16 (
-*     pI2CDeviceAddr_t devAddr, -- address of I2C device
+*     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     pu16_t           data,    -- data to receive
 *     DRXflags_t       flags)   -- special device flags
@@ -364,7 +364,7 @@ static DRXStatus_t DRXDAP_FASI_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_ReadReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 pu16_t data, DRXflags_t flags)
 {
@@ -382,7 +382,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg16(pI2CDeviceAddr_t devAddr,
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_ReadReg32 (
-*     pI2CDeviceAddr_t devAddr, -- address of I2C device
+*     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     pu32_t           data,    -- data to receive
 *     DRXflags_t       flags)   -- special device flags
@@ -397,7 +397,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg16(pI2CDeviceAddr_t devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_ReadReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_ReadReg32(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 pu32_t data, DRXflags_t flags)
 {
@@ -417,7 +417,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg32(pI2CDeviceAddr_t devAddr,
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_WriteBlock (
-*      pI2CDeviceAddr_t devAddr,    -- address of I2C device
+*      struct i2c_device_addr *devAddr,    -- address of I2C device
 *      DRXaddr_t        addr,       -- address of chip register/memory
 *      u16_t            datasize,   -- number of bytes to read
 *      pu8_t            data,       -- data to receive
@@ -436,7 +436,7 @@ static DRXStatus_t DRXDAP_FASI_ReadReg32(pI2CDeviceAddr_t devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_WriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16_t datasize,
 					  pu8_t data, DRXflags_t flags)
@@ -526,7 +526,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,
 			st = DRXBSP_I2C_WriteRead(devAddr,
 						  (u16_t) (bufx),
 						  buf,
-						  (pI2CDeviceAddr_t) (NULL),
+						  (struct i2c_device_addr *) (NULL),
 						  0, (pu8_t) (NULL));
 
 			if ((st != DRX_STS_OK) && (firstErr == DRX_STS_OK)) {
@@ -543,7 +543,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,
 		st = DRXBSP_I2C_WriteRead(devAddr,
 					  (u16_t) (bufx + todo),
 					  buf,
-					  (pI2CDeviceAddr_t) (NULL),
+					  (struct i2c_device_addr *) (NULL),
 					  0, (pu8_t) (NULL));
 
 		if ((st != DRX_STS_OK) && (firstErr == DRX_STS_OK)) {
@@ -561,7 +561,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_WriteReg16 (
-*     pI2CDeviceAddr_t devAddr, -- address of I2C device
+*     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     u16_t            data,    -- data to send
 *     DRXflags_t       flags)   -- special device flags
@@ -575,7 +575,7 @@ static DRXStatus_t DRXDAP_FASI_WriteBlock(pI2CDeviceAddr_t devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_WriteReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_WriteReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16_t data, DRXflags_t flags)
 {
@@ -590,7 +590,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg16(pI2CDeviceAddr_t devAddr,
 /******************************
 *
 * DRXStatus_t DRXDAP_FASI_WriteReg32 (
-*     pI2CDeviceAddr_t devAddr, -- address of I2C device
+*     struct i2c_device_addr *devAddr, -- address of I2C device
 *     DRXaddr_t        addr,    -- address of chip register/memory
 *     u32_t            data,    -- data to send
 *     DRXflags_t       flags)   -- special device flags
@@ -604,7 +604,7 @@ static DRXStatus_t DRXDAP_FASI_WriteReg16(pI2CDeviceAddr_t devAddr,
 *
 ******************************/
 
-static DRXStatus_t DRXDAP_FASI_WriteReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXDAP_FASI_WriteReg32(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u32_t data, DRXflags_t flags)
 {
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
index 2d2711032292..3a782d6f0bb5 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.c
@@ -991,7 +991,7 @@ CtrlUCode(pDRXDemodInstance_t demod,
 	u16_t mcNrOfBlks = 0;
 	u16_t mcMagicWord = 0;
 	pu8_t mcData = (pu8_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 
 	devAddr = demod->myI2CDevAddr;
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 712ffd5a2fbb..c88c064c3ab8 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -1329,11 +1329,11 @@ STRUCTS
 */
 	typedef struct {
 		u16_t portNr;	/**< I2C port number               */
-		pI2CDeviceAddr_t wDevAddr;
+		struct i2c_device_addr *wDevAddr;
 				/**< Write device address          */
 		u16_t wCount;	/**< Size of write data in bytes   */
 		pu8_t wData;	/**< Pointer to write data         */
-		pI2CDeviceAddr_t rDevAddr;
+		struct i2c_device_addr *rDevAddr;
 				/**< Read device address           */
 		u16_t rCount;	/**< Size of data to read in bytes */
 		pu8_t rData;	/**< Pointer to read buffer        */
@@ -1726,71 +1726,71 @@ STRUCTS
 	typedef u32_t DRXflags_t, *pDRXflags_t;
 
 /* Write block of data to device */
-	typedef DRXStatus_t(*DRXWriteBlockFunc_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXWriteBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
 						   u16_t datasize,	/* size of data in bytes        */
 						   pu8_t data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read block of data from device */
-	typedef DRXStatus_t(*DRXReadBlockFunc_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXReadBlockFunc_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  u16_t datasize,	/* size of data in bytes        */
 						  pu8_t data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Write 8-bits value to device */
-	typedef DRXStatus_t(*DRXWriteReg8Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  u8_t data,	/* data to send                 */
 						  DRXflags_t flags);
 
 /* Read 8-bits value to device */
-	typedef DRXStatus_t(*DRXReadReg8Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXReadReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						 DRXaddr_t addr,	/* address of register/memory   */
 						 pu8_t data,	/* receive buffer               */
 						 DRXflags_t flags);
 
 /* Read modify write 8-bits value to device */
-	typedef DRXStatus_t(*DRXReadModifyWriteReg8Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device       */
+	typedef DRXStatus_t(*DRXReadModifyWriteReg8Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							    DRXaddr_t waddr,	/* write address of register   */
 							    DRXaddr_t raddr,	/* read  address of register   */
 							    u8_t wdata,	/* data to write               */
 							    pu8_t rdata);	/* data to read                */
 
 /* Write 16-bits value to device */
-	typedef DRXStatus_t(*DRXWriteReg16Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
 						   u16_t data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read 16-bits value to device */
-	typedef DRXStatus_t(*DRXReadReg16Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXReadReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  pu16_t data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Read modify write 16-bits value to device */
-	typedef DRXStatus_t(*DRXReadModifyWriteReg16Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device       */
+	typedef DRXStatus_t(*DRXReadModifyWriteReg16Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							     DRXaddr_t waddr,	/* write address of register   */
 							     DRXaddr_t raddr,	/* read  address of register   */
 							     u16_t wdata,	/* data to write               */
 							     pu16_t rdata);	/* data to read                */
 
 /* Write 32-bits value to device */
-	typedef DRXStatus_t(*DRXWriteReg32Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						   DRXaddr_t addr,	/* address of register/memory   */
 						   u32_t data,	/* data to send                 */
 						   DRXflags_t flags);
 
 /* Read 32-bits value to device */
-	typedef DRXStatus_t(*DRXReadReg32Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device        */
+	typedef DRXStatus_t(*DRXReadReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device        */
 						  DRXaddr_t addr,	/* address of register/memory   */
 						  pu32_t data,	/* receive buffer               */
 						  DRXflags_t flags);
 
 /* Read modify write 32-bits value to device */
-	typedef DRXStatus_t(*DRXReadModifyWriteReg32Func_t) (pI2CDeviceAddr_t devAddr,	/* address of I2C device       */
+	typedef DRXStatus_t(*DRXReadModifyWriteReg32Func_t) (struct i2c_device_addr *devAddr,	/* address of I2C device       */
 							     DRXaddr_t waddr,	/* write address of register   */
 							     DRXaddr_t raddr,	/* read  address of register   */
 							     u32_t wdata,	/* data to write               */
@@ -1948,7 +1948,7 @@ STRUCTS
 				    /**< data access protocol functions       */
 		pTUNERInstance_t myTuner;
 				    /**< tuner instance,if NULL then baseband */
-		pI2CDeviceAddr_t myI2CDevAddr;
+		struct i2c_device_addr *myI2CDevAddr;
 				    /**< i2c address and device identifier    */
 		pDRXCommonAttr_t myCommonAttr;
 				    /**< common DRX attributes                */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index ddfde425e049..84f4e1823925 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -598,52 +598,52 @@ GLOBAL VARIABLES
  * DRXJ DAP structures
  */
 
-static DRXStatus_t DRXJ_DAP_ReadBlock(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u16_t datasize,
 				      pu8_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 						DRXaddr_t waddr,
 						DRXaddr_t raddr,
 						u8_t wdata, pu8_t rdata);
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u16_t wdata, pu16_t rdata);
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u32_t wdata, pu32_t rdata);
 
-static DRXStatus_t DRXJ_DAP_ReadReg8(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
 				     pu8_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_ReadReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      pu16_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_ReadReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      pu32_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteBlock(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16_t datasize,
 				       pu8_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteReg8(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u8_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16_t data, DRXflags_t flags);
 
-static DRXStatus_t DRXJ_DAP_WriteReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u32_t data, DRXflags_t flags);
 
@@ -940,7 +940,7 @@ DRXJData_t DRXJData_g = {
 * \var DRXJDefaultAddr_g
 * \brief Default I2C address and device identifier.
 */
-I2CDeviceAddr_t DRXJDefaultAddr_g = {
+struct i2c_device_addr DRXJDefaultAddr_g = {
 	DRXJ_DEF_I2C_ADDR,	/* i2c address */
 	DRXJ_DEF_DEMOD_DEV_ID	/* device id */
 };
@@ -1146,7 +1146,7 @@ FUNCTIONS
 ----------------------------------------------------------------------------*/
 /* Some prototypes */
 static DRXStatus_t
-HICommand(const pI2CDeviceAddr_t devAddr,
+HICommand(const struct i2c_device_addr *devAddr,
 	  const pDRXJHiCmd_t cmd, pu16_t result);
 
 static DRXStatus_t
@@ -1712,7 +1712,7 @@ Bool_t IsHandledByAudTrIf(DRXaddr_t addr)
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadBlock(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadBlock(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u16_t datasize,
 				      pu8_t data, DRXflags_t flags)
@@ -1723,7 +1723,7 @@ static DRXStatus_t DRXJ_DAP_ReadBlock(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(struct i2c_device_addr *devAddr,
 						DRXaddr_t waddr,
 						DRXaddr_t raddr,
 						u8_t wdata, pu8_t rdata)
@@ -1756,7 +1756,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg8(pI2CDeviceAddr_t devAddr,
 /* TODO correct define should be #if ( DRXDAPFASI_SHORT_ADDR_ALLOWED==1 )
    See comments DRXJ_DAP_ReadModifyWriteReg16 */
 #if ( DRXDAPFASI_LONG_ADDR_ALLOWED == 0 )
-static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(struct i2c_device_addr *devAddr,
 					      DRXaddr_t waddr,
 					      DRXaddr_t raddr,
 					      u16_t wdata, pu16_t rdata)
@@ -1795,7 +1795,7 @@ static DRXStatus_t DRXJ_DAP_RMWriteReg16Short(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u16_t wdata, pu16_t rdata)
@@ -1814,7 +1814,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg16(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(struct i2c_device_addr *devAddr,
 						 DRXaddr_t waddr,
 						 DRXaddr_t raddr,
 						 u32_t wdata, pu32_t rdata)
@@ -1826,7 +1826,7 @@ static DRXStatus_t DRXJ_DAP_ReadModifyWriteReg32(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadReg8(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadReg8(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
 				     pu8_t data, DRXflags_t flags)
 {
@@ -1848,7 +1848,7 @@ static DRXStatus_t DRXJ_DAP_ReadReg8(pI2CDeviceAddr_t devAddr,
 * 16 bits register read access via audio token ring interface.
 *
 */
-static DRXStatus_t DRXJ_DAP_ReadAudReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadAudReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr, pu16_t data)
 {
 	u32_t startTimer = 0;
@@ -1928,7 +1928,7 @@ static DRXStatus_t DRXJ_DAP_ReadAudReg16(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadReg16(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      pu16_t data, DRXflags_t flags)
 {
@@ -1951,7 +1951,7 @@ static DRXStatus_t DRXJ_DAP_ReadReg16(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_ReadReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_ReadReg32(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      pu32_t data, DRXflags_t flags)
 {
@@ -1960,7 +1960,7 @@ static DRXStatus_t DRXJ_DAP_ReadReg32(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteBlock(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteBlock(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16_t datasize,
 				       pu8_t data, DRXflags_t flags)
@@ -1971,7 +1971,7 @@ static DRXStatus_t DRXJ_DAP_WriteBlock(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteReg8(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteReg8(struct i2c_device_addr *devAddr,
 				      DRXaddr_t addr,
 				      u8_t data, DRXflags_t flags)
 {
@@ -1993,7 +1993,7 @@ static DRXStatus_t DRXJ_DAP_WriteReg8(pI2CDeviceAddr_t devAddr,
 * 16 bits register write access via audio token ring interface.
 *
 */
-static DRXStatus_t DRXJ_DAP_WriteAudReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteAudReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr, u16_t data)
 {
 	DRXStatus_t stat = DRX_STS_ERROR;
@@ -2040,7 +2040,7 @@ static DRXStatus_t DRXJ_DAP_WriteAudReg16(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteReg16(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteReg16(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u16_t data, DRXflags_t flags)
 {
@@ -2063,7 +2063,7 @@ static DRXStatus_t DRXJ_DAP_WriteReg16(pI2CDeviceAddr_t devAddr,
 
 /*============================================================================*/
 
-static DRXStatus_t DRXJ_DAP_WriteReg32(pI2CDeviceAddr_t devAddr,
+static DRXStatus_t DRXJ_DAP_WriteReg32(struct i2c_device_addr *devAddr,
 				       DRXaddr_t addr,
 				       u32_t data, DRXflags_t flags)
 {
@@ -2094,7 +2094,7 @@ static DRXStatus_t DRXJ_DAP_WriteReg32(pI2CDeviceAddr_t devAddr,
 *
 */
 static
-DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(pI2CDeviceAddr_t devAddr,
+DRXStatus_t DRXJ_DAP_AtomicReadWriteBlock(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16_t datasize,
 					  pu8_t data, Bool_t readFlag)
@@ -2168,7 +2168,7 @@ rw_error:
 * \brief Atomic read of 32 bits words
 */
 static
-DRXStatus_t DRXJ_DAP_AtomicReadReg32(pI2CDeviceAddr_t devAddr,
+DRXStatus_t DRXJ_DAP_AtomicReadReg32(struct i2c_device_addr *devAddr,
 				     DRXaddr_t addr,
 				     pu32_t data, DRXflags_t flags)
 {
@@ -2258,7 +2258,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-HICommand(const pI2CDeviceAddr_t devAddr, const pDRXJHiCmd_t cmd, pu16_t result)
+HICommand(const struct i2c_device_addr *devAddr, const pDRXJHiCmd_t cmd, pu16_t result)
 {
 	u16_t waitCmd = 0;
 	u16_t nrRetries = 0;
@@ -2338,7 +2338,7 @@ static DRXStatus_t InitHI(const pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
@@ -2415,7 +2415,7 @@ static DRXStatus_t GetDeviceCapabilities(pDRXDemodInstance_t demod)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	u16_t sioPdrOhwCfg = 0;
 	u32_t sioTopJtagidLo = 0;
 	u16_t bid = 0;
@@ -2588,10 +2588,10 @@ rw_error:
 
 static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	u8_t data = 0;
 	u16_t retryCount = 0;
-	I2CDeviceAddr_t wakeUpAddr;
+	struct i2c_device_addr wakeUpAddr;
 
 	devAddr = demod->myI2CDevAddr;
 	wakeUpAddr.i2cAddr = DRXJ_WAKE_UP_KEY;
@@ -2603,12 +2603,12 @@ static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
 	do {
 		data = 0;
 		DRXBSP_I2C_WriteRead(&wakeUpAddr, 1, &data,
-				     (pI2CDeviceAddr_t) (NULL), 0,
+				     (struct i2c_device_addr *) (NULL), 0,
 				     (pu8_t) (NULL));
 		DRXBSP_HST_Sleep(10);
 		retryCount++;
 	} while ((DRXBSP_I2C_WriteRead
-		  ((pI2CDeviceAddr_t) (NULL), 0, (pu8_t) (NULL), devAddr, 1,
+		  ((struct i2c_device_addr *) (NULL), 0, (pu8_t) (NULL), devAddr, 1,
 		   &data)
 		  != DRX_STS_OK) && (retryCount < DRXJ_MAX_RETRIES_POWERUP));
 
@@ -2638,7 +2638,7 @@ static DRXStatus_t PowerUpDevice(pDRXDemodInstance_t demod)
 static DRXStatus_t
 CtrlSetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	u16_t fecOcRegMode = 0;
@@ -3040,7 +3040,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetCfgMPEGOutput(pDRXDemodInstance_t demod, pDRXCfgMPEGOutput_t cfgData)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	u32_t rateReg = 0;
@@ -3098,7 +3098,7 @@ rw_error:
 static DRXStatus_t SetMPEGTEIHandling(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	u16_t fecOcDprMode = 0;
 	u16_t fecOcSncMode = 0;
 	u16_t fecOcEmsMode = 0;
@@ -3146,7 +3146,7 @@ rw_error:
 static DRXStatus_t BitReverseMPEGOutput(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	u16_t fecOcIprMode = 0;
 
 	devAddr = demod->myI2CDevAddr;
@@ -3182,7 +3182,7 @@ rw_error:
 static DRXStatus_t SetMPEGOutputClockRate(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -3210,7 +3210,7 @@ rw_error:
 static DRXStatus_t SetMPEGStartWidth(pDRXDemodInstance_t demod)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	u16_t fecOcCommMb = 0;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) NULL;
 
@@ -3862,7 +3862,7 @@ static DRXStatus_t SmartAntInit(pDRXDemodInstance_t demod)
 {
 	u16_t data = 0;
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXUIOCfg_t UIOCfg = { DRX_UIO1, DRX_UIO_MODE_FIRMWARE_SMA };
 
 	devAddr = demod->myI2CDevAddr;
@@ -3905,7 +3905,7 @@ static DRXStatus_t
 CtrlSetCfgSmartAnt(pDRXDemodInstance_t demod, pDRXJCfgSmartAnt_t smartAnt)
 {
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	u16_t data = 0;
 	u32_t startTime = 0;
 	static Bool_t bitInverted = FALSE;
@@ -3989,7 +3989,7 @@ rw_error:
 	return (DRX_STS_ERROR);
 }
 
-static DRXStatus_t SCUCommand(pI2CDeviceAddr_t devAddr, pDRXJSCUCmd_t cmd)
+static DRXStatus_t SCUCommand(struct i2c_device_addr *devAddr, pDRXJSCUCmd_t cmd)
 {
 	u16_t curCmd = 0;
 	u32_t startTime = 0;
@@ -4095,7 +4095,7 @@ rw_error:
 */
 #define ADDR_AT_SCU_SPACE(x) ((x - 0x82E000) * 2)
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(pI2CDeviceAddr_t devAddr, DRXaddr_t addr, u16_t datasize,	/* max 30 bytes because the limit of SCU parameter */
+DRXStatus_t DRXJ_DAP_SCU_AtomicReadWriteBlock(struct i2c_device_addr *devAddr, DRXaddr_t addr, u16_t datasize,	/* max 30 bytes because the limit of SCU parameter */
 					      pu8_t data, Bool_t readFlag)
 {
 	DRXJSCUCmd_t scuCmd;
@@ -4156,7 +4156,7 @@ rw_error:
 * \brief Atomic read of 16 bits words
 */
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(pI2CDeviceAddr_t devAddr,
+DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(struct i2c_device_addr *devAddr,
 					 DRXaddr_t addr,
 					 pu16_t data, DRXflags_t flags)
 {
@@ -4183,7 +4183,7 @@ DRXStatus_t DRXJ_DAP_SCU_AtomicReadReg16(pI2CDeviceAddr_t devAddr,
 * \brief Atomic read of 16 bits words
 */
 static
-DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16(pI2CDeviceAddr_t devAddr,
+DRXStatus_t DRXJ_DAP_SCU_AtomicWriteReg16(struct i2c_device_addr *devAddr,
 					  DRXaddr_t addr,
 					  u16_t data, DRXflags_t flags)
 {
@@ -4206,10 +4206,10 @@ CtrlI2CWriteRead(pDRXDemodInstance_t demod, pDRXI2CData_t i2cData)
 
 DRXStatus_t
 TunerI2CWriteRead(pTUNERInstance_t tuner,
-		  pI2CDeviceAddr_t wDevAddr,
+		  struct i2c_device_addr *wDevAddr,
 		  u16_t wCount,
 		  pu8_t wData,
-		  pI2CDeviceAddr_t rDevAddr, u16_t rCount, pu8_t rData)
+		  struct i2c_device_addr *rDevAddr, u16_t rCount, pu8_t rData)
 {
 	pDRXDemodInstance_t demod;
 	DRXI2CData_t i2cData =
@@ -4233,7 +4233,7 @@ TunerI2CWriteRead(pTUNERInstance_t tuner,
 static DRXStatus_t ADCSyncMeasurement(pDRXDemodInstance_t demod, pu16_t count)
 {
 	u16_t data = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 
@@ -4278,7 +4278,7 @@ rw_error:
 static DRXStatus_t ADCSynchronization(pDRXDemodInstance_t demod)
 {
 	u16_t count = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 
@@ -4315,7 +4315,7 @@ rw_error:
 static DRXStatus_t IQMSetAf(pDRXDemodInstance_t demod, Bool_t active)
 {
 	u16_t data = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -4359,7 +4359,7 @@ static DRXStatus_t
 CtrlSetCfgPdrSafeMode(pDRXDemodInstance_t demod, pBool_t enable)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) NULL;
 
 	if (enable == NULL) {
@@ -4551,7 +4551,7 @@ static DRXStatus_t CtrlValidateUCode(pDRXDemodInstance_t demod)
 */
 static DRXStatus_t InitAGC(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXJCfgAgc_t pAgcRfSettings = NULL;
@@ -4760,7 +4760,7 @@ static DRXStatus_t
 SetFrequency(pDRXDemodInstance_t demod,
 	     pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
 	DRXFrequency_t samplingFrequency = 0;
 	DRXFrequency_t frequencyShift = 0;
@@ -4874,7 +4874,7 @@ static DRXStatus_t GetSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
 	u16_t rfAgcMax = 0;
 	u16_t rfAgcMin = 0;
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	devAddr = demod->myI2CDevAddr;
@@ -4930,7 +4930,7 @@ static DRXStatus_t GetAccPktErr(pDRXDemodInstance_t demod, pu16_t packetErr)
 	static u16_t lastPktErr = 0;
 	u16_t data = 0;
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 	devAddr = demod->myI2CDevAddr;
@@ -4993,7 +4993,7 @@ static DRXStatus_t GetSTRFreqOffset(pDRXDemodInstance_t demod, s32_t * STRFreq)
 	u32_t symbolNomFrequencyRatio = 0;
 
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -5036,7 +5036,7 @@ static DRXStatus_t GetCTLFreqOffset(pDRXDemodInstance_t demod, s32_t * CTLFreq)
 	u32_t data64Lo = 0;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -5084,7 +5084,7 @@ rw_error:
 static DRXStatus_t
 SetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, Bool_t atomic)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXJCfgAgc_t pAgcSettings = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
@@ -5262,7 +5262,7 @@ rw_error:
 static DRXStatus_t
 GetAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 
@@ -5323,7 +5323,7 @@ rw_error:
 static DRXStatus_t
 SetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings, Bool_t atomic)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXJCfgAgc_t pAgcSettings = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
@@ -5514,7 +5514,7 @@ rw_error:
 static DRXStatus_t
 GetAgcIf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 
@@ -5576,7 +5576,7 @@ rw_error:
 static DRXStatus_t SetIqmAf(pDRXDemodInstance_t demod, Bool_t active)
 {
 	u16_t data = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 
@@ -5623,7 +5623,7 @@ rw_error:
 */
 static DRXStatus_t PowerDownVSB(pDRXDemodInstance_t demod, Bool_t primary)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command     */ 0,
 		/* parameterLen */ 0,
 		/* resultLen    */ 0,
@@ -5678,7 +5678,7 @@ rw_error:
 */
 static DRXStatus_t SetVSBLeakNGain(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	const u8_t vsb_ffe_leak_gain_ram0[] = {
 		DRXJ_16TO8(0x8),	/* FFETRAINLKRATIO1  */
@@ -5888,7 +5888,7 @@ rw_error:
 */
 static DRXStatus_t SetVSB(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	u16_t cmdResult = 0;
 	u16_t cmdParam = 0;
 	pDRXCommonAttr_t commonAttr = NULL;
@@ -6101,11 +6101,11 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBPostRSPckErr(pI2CDeviceAddr_t  devAddr, pu16_t PckErrs)
+* \fn static short GetVSBPostRSPckErr(struct i2c_device_addr * devAddr, pu16_t PckErrs)
 * \brief Get the values of packet error in 8VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBPostRSPckErr(pI2CDeviceAddr_t devAddr, pu16_t pckErrs)
+static DRXStatus_t GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, pu16_t pckErrs)
 {
 	u16_t data = 0;
 	u16_t period = 0;
@@ -6132,11 +6132,11 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBBer(pI2CDeviceAddr_t  devAddr, pu32_t ber)
+* \fn static short GetVSBBer(struct i2c_device_addr * devAddr, pu32_t ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBpostViterbiBer(pI2CDeviceAddr_t devAddr, pu32_t ber)
+static DRXStatus_t GetVSBpostViterbiBer(struct i2c_device_addr *devAddr, pu32_t ber)
 {
 	u16_t data = 0;
 	u16_t period = 0;
@@ -6170,11 +6170,11 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBpreViterbiBer(pI2CDeviceAddr_t  devAddr, pu32_t ber)
+* \fn static short GetVSBpreViterbiBer(struct i2c_device_addr * devAddr, pu32_t ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBpreViterbiBer(pI2CDeviceAddr_t devAddr, pu32_t ber)
+static DRXStatus_t GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, pu32_t ber)
 {
 	u16_t data = 0;
 
@@ -6189,11 +6189,11 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBSymbErr(pI2CDeviceAddr_t  devAddr, pu32_t ber)
+* \fn static short GetVSBSymbErr(struct i2c_device_addr * devAddr, pu32_t ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
-static DRXStatus_t GetVSBSymbErr(pI2CDeviceAddr_t devAddr, pu32_t ser)
+static DRXStatus_t GetVSBSymbErr(struct i2c_device_addr *devAddr, pu32_t ser)
 {
 	u16_t data = 0;
 	u16_t period = 0;
@@ -6219,11 +6219,11 @@ rw_error:
 }
 
 /**
-* \fn static DRXStatus_t GetVSBMER(pI2CDeviceAddr_t  devAddr, pu16_t mer)
+* \fn static DRXStatus_t GetVSBMER(struct i2c_device_addr * devAddr, pu16_t mer)
 * \brief Get the values of MER
 * \return Error code
 */
-static DRXStatus_t GetVSBMER(pI2CDeviceAddr_t devAddr, pu16_t mer)
+static DRXStatus_t GetVSBMER(struct i2c_device_addr *devAddr, pu16_t mer)
 {
 	u16_t dataHi = 0;
 
@@ -6248,7 +6248,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetVSBConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 				       /**< device address                    */
 	u16_t vsbTopCommMb = 0;	       /**< VSB SL MB configuration           */
 	u16_t vsbTopCommMbInit = 0;    /**< VSB SL MB intial configuration    */
@@ -6319,7 +6319,7 @@ static DRXStatus_t PowerDownQAM(pDRXDemodInstance_t demod, Bool_t primary)
 		/* *result      */ NULL
 	};
 	u16_t cmdResult = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXCfgMPEGOutput_t cfgMPEGOutput;
 
@@ -6384,7 +6384,7 @@ static DRXStatus_t
 SetQAMMeasurement(pDRXDemodInstance_t demod,
 		  DRXConstellation_t constellation, u32_t symbolRate)
 {
-	pI2CDeviceAddr_t devAddr = NULL;	/* device address for I2C writes */
+	struct i2c_device_addr *devAddr = NULL;	/* device address for I2C writes */
 	pDRXJData_t extAttr = NULL;	/* Global data container for DRXJ specif data */
 	u32_t fecBitsDesired = 0;	/* BER accounting period */
 	u16_t fecRsPlen = 0;	/* defines RS BER measurement period */
@@ -6545,7 +6545,7 @@ rw_error:
 */
 static DRXStatus_t SetQAM16(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = demod->myI2CDevAddr;
+	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8_t qamDqQualFun[] = {
 		DRXJ_16TO8(2),	/* fun0  */
 		DRXJ_16TO8(2),	/* fun1  */
@@ -6625,7 +6625,7 @@ rw_error:
 */
 static DRXStatus_t SetQAM32(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = demod->myI2CDevAddr;
+	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8_t qamDqQualFun[] = {
 		DRXJ_16TO8(3),	/* fun0  */
 		DRXJ_16TO8(3),	/* fun1  */
@@ -6705,7 +6705,7 @@ rw_error:
 */
 static DRXStatus_t SetQAM64(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = demod->myI2CDevAddr;
+	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8_t qamDqQualFun[] = {	/* this is hw reset value. no necessary to re-write */
 		DRXJ_16TO8(4),	/* fun0  */
 		DRXJ_16TO8(4),	/* fun1  */
@@ -6785,7 +6785,7 @@ rw_error:
 */
 static DRXStatus_t SetQAM128(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = demod->myI2CDevAddr;
+	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8_t qamDqQualFun[] = {
 		DRXJ_16TO8(6),	/* fun0  */
 		DRXJ_16TO8(6),	/* fun1  */
@@ -6865,7 +6865,7 @@ rw_error:
 */
 static DRXStatus_t SetQAM256(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = demod->myI2CDevAddr;
+	struct i2c_device_addr *devAddr = demod->myI2CDevAddr;
 	const u8_t qamDqQualFun[] = {
 		DRXJ_16TO8(8),	/* fun0  */
 		DRXJ_16TO8(8),	/* fun1  */
@@ -6951,7 +6951,7 @@ static DRXStatus_t
 SetQAM(pDRXDemodInstance_t demod,
        pDRXChannel_t channel, DRXFrequency_t tunerFreqOffset, u32_t op)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
 	u16_t cmdResult = 0;
@@ -7422,7 +7422,7 @@ static DRXStatus_t qamFlipSpec(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	u16_t fsmState = 0;
 	int i = 0;
 	int ofsofs = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -7834,7 +7834,7 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn static short GetQAMRSErrCount(pI2CDeviceAddr_t  devAddr)
+* \fn static short GetQAMRSErrCount(struct i2c_device_addr * devAddr)
 * \brief Get RS error count in QAM mode (used for post RS BER calculation)
 * \return Error code
 *
@@ -7842,7 +7842,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-GetQAMRSErrCount(pI2CDeviceAddr_t devAddr, pDRXJRSErrors_t RSErrors)
+GetQAMRSErrCount(struct i2c_device_addr *devAddr, pDRXJRSErrors_t RSErrors)
 {
 	u16_t nrBitErrors = 0,
 	    nrSymbolErrors = 0,
@@ -7898,7 +7898,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetQAMSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXConstellation_t constellation = DRX_CONSTELLATION_UNKNOWN;
 	DRXJRSErrors_t measuredRSErrors = { 0, 0, 0, 0, 0 };
@@ -8088,7 +8088,7 @@ CtrlGetQAMConstel(pDRXDemodInstance_t demod, pDRXComplex_t complexNr)
 	u16_t im = 0;	      /**< constellation Im part                */
 	u16_t re = 0;	      /**< constellation Re part                */
 	u32_t data = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 				     /**< device address */
 
 	/* read device info */
@@ -8270,7 +8270,7 @@ static DRXStatus_t AtvEquCoefIndex(DRXStandard_t standard, int *index)
 static DRXStatus_t
 AtvUpdateConfig(pDRXDemodInstance_t demod, Bool_t forceUpdate)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -8641,7 +8641,7 @@ static DRXStatus_t
 CtrlGetCfgAtvAgcStatus(pDRXDemodInstance_t demod,
 		       pDRXJCfgAtvAgcStatus_t agcStatus)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	u16_t data = 0;
 	u32_t tmp = 0;
@@ -8744,7 +8744,7 @@ rw_error:
 */
 static DRXStatus_t PowerUpATV(pDRXDemodInstance_t demod, DRXStandard_t standard)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -8782,7 +8782,7 @@ rw_error:
 static DRXStatus_t
 PowerDownATV(pDRXDemodInstance_t demod, DRXStandard_t standard, Bool_t primary)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
 		/* resultLen    */ 0,
@@ -9100,7 +9100,7 @@ trouble ?
 		DRXJ_16TO8(70)	/* im27 */
 	};
 
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
 		/* resultLen    */ 0,
@@ -9468,7 +9468,7 @@ SetATVChannel(pDRXDemodInstance_t demod,
 	};
 	u16_t cmdResult = 0;
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -9527,7 +9527,7 @@ GetATVChannel(pDRXDemodInstance_t demod,
 	      pDRXChannel_t channel, DRXStandard_t standard)
 {
 	DRXFrequency_t offset = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -9612,7 +9612,7 @@ rw_error:
 static DRXStatus_t
 GetAtvSigStrength(pDRXDemodInstance_t demod, pu16_t sigStrength)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	/* All weights must add up to 100 (%)
@@ -9721,7 +9721,7 @@ rw_error:
 static DRXStatus_t
 AtvSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	u16_t qualityIndicator = 0;
 
 	devAddr = demod->myI2CDevAddr;
@@ -9780,7 +9780,7 @@ rw_error:
 static DRXStatus_t PowerUpAud(pDRXDemodInstance_t demod, Bool_t setStandard)
 {
 	DRXAudStandard_t audStandard = DRX_AUD_STANDARD_AUTO;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 
@@ -9808,10 +9808,10 @@ rw_error:
 */
 static DRXStatus_t PowerDownAud(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	WR16(devAddr, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
@@ -9833,7 +9833,7 @@ rw_error:
 */
 static DRXStatus_t AUDGetModus(pDRXDemodInstance_t demod, pu16_t modus)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t rModus = 0;
@@ -9844,7 +9844,7 @@ static DRXStatus_t AUDGetModus(pDRXDemodInstance_t demod, pu16_t modus)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -9879,7 +9879,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 {
-	pI2CDeviceAddr_t addr = NULL;
+	struct i2c_device_addr *addr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t rRDSArrayCntInit = 0;
@@ -9887,7 +9887,7 @@ AUDCtrlGetCfgRDS(pDRXDemodInstance_t demod, pDRXCfgAudRDS_t status)
 	u16_t rRDSData = 0;
 	u16_t RDSDataCnt = 0;
 
-	addr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	addr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	if (status == NULL) {
@@ -9950,7 +9950,7 @@ static DRXStatus_t
 AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 {
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	u16_t rData = 0;
 
@@ -9958,7 +9958,7 @@ AUDCtrlGetCarrierDetectStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -10028,7 +10028,7 @@ static DRXStatus_t
 AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 {
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXCfgAudRDS_t rds = { FALSE, {0} };
 	u16_t rData = 0;
 
@@ -10036,7 +10036,7 @@ AUDCtrlGetStatus(pDRXDemodInstance_t demod, pDRXAudStatus_t status)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* carrier detection */
@@ -10068,7 +10068,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t rVolume = 0;
@@ -10080,7 +10080,7 @@ AUDCtrlGetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -10202,7 +10202,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t wVolume = 0;
@@ -10212,7 +10212,7 @@ AUDCtrlSetCfgVolume(pDRXDemodInstance_t demod, pDRXCfgAudVolume_t volume)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -10337,7 +10337,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t wI2SConfig = 0;
@@ -10347,7 +10347,7 @@ AUDCtrlGetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -10440,7 +10440,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t wI2SConfig = 0;
@@ -10453,7 +10453,7 @@ AUDCtrlSetCfgOutputI2S(pDRXDemodInstance_t demod, pDRXCfgI2SOutput_t output)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -10596,7 +10596,7 @@ static DRXStatus_t
 AUDCtrlGetCfgAutoSound(pDRXDemodInstance_t demod,
 		       pDRXCfgAudAutoSound_t autoSound)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t rModus = 0;
@@ -10653,7 +10653,7 @@ static DRXStatus_t
 AUDCtrSetlCfgAutoSound(pDRXDemodInstance_t demod,
 		       pDRXCfgAudAutoSound_t autoSound)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t rModus = 0;
@@ -10718,7 +10718,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t thresA2 = 0;
@@ -10762,7 +10762,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgASSThres(pDRXDemodInstance_t demod, pDRXCfgAudASSThres_t thres)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	if (thres == NULL) {
@@ -10801,7 +10801,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t wModus = 0;
@@ -10906,7 +10906,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgCarrier(pDRXDemodInstance_t demod, pDRXCfgAudCarriers_t carriers)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t wModus = 0;
@@ -11006,7 +11006,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t srcI2SMatr = 0;
@@ -11101,7 +11101,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgMixer(pDRXDemodInstance_t demod, pDRXCfgAudMixer_t mixer)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t srcI2SMatr = 0;
@@ -11209,7 +11209,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t wAudVidSync = 0;
@@ -11274,7 +11274,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgAVSync(pDRXDemodInstance_t demod, pDRXCfgAudAVSync_t avSync)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t wAudVidSync = 0;
@@ -11331,7 +11331,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t rModus = 0;
@@ -11372,7 +11372,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgDev(pDRXDemodInstance_t demod, pDRXCfgAudDeviation_t dev)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t wModus = 0;
@@ -11425,7 +11425,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t rMaxFMDeviation = 0;
@@ -11500,7 +11500,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetCfgPrescale(pDRXDemodInstance_t demod, pDRXCfgAudPrescale_t presc)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t wMaxFMDeviation = 0;
@@ -11582,7 +11582,7 @@ rw_error:
 */
 static DRXStatus_t AUDCtrlBeep(pDRXDemodInstance_t demod, pDRXAudBeep_t beep)
 {
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
 
 	u16_t theBeep = 0;
@@ -11641,7 +11641,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t currentStandard = DRX_STANDARD_UNKNOWN;
 
@@ -11657,7 +11657,7 @@ AUDCtrlSetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 		return DRX_STS_INVALID_ARG;
 	}
 
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
 
 	/* power up */
@@ -11819,7 +11819,7 @@ rw_error:
 static DRXStatus_t
 AUDCtrlGetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	u16_t rData = 0;
@@ -11829,7 +11829,7 @@ AUDCtrlGetStandard(pDRXDemodInstance_t demod, pDRXAudStandard_t standard)
 	}
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
-	devAddr = (pI2CDeviceAddr_t) demod->myI2CDevAddr;
+	devAddr = (struct i2c_device_addr *) demod->myI2CDevAddr;
 
 	/* power up */
 	if (extAttr->audData.audioIsActive == FALSE) {
@@ -11997,7 +11997,7 @@ rw_error:
 */
 static DRXStatus_t
 GetOOBLockStatus(pDRXDemodInstance_t demod,
-		 pI2CDeviceAddr_t devAddr, pDRXLockStatus_t oobLock)
+		 struct i2c_device_addr *devAddr, pDRXLockStatus_t oobLock)
 {
 	DRXJSCUCmd_t scuCmd;
 	u16_t cmdResult[2];
@@ -12051,7 +12051,7 @@ rw_error:
 *
 */
 static DRXStatus_t
-GetOOBSymbolRateOffset(pI2CDeviceAddr_t devAddr, ps32_t SymbolRateOffset)
+GetOOBSymbolRateOffset(struct i2c_device_addr *devAddr, ps32_t SymbolRateOffset)
 {
 /*  offset = -{(timingOffset/2^19)*(symbolRate/12,656250MHz)}*10^6 [ppm]  */
 /*  offset = -{(timingOffset/2^19)*(symbolRate/12656250)}*10^6 [ppm]  */
@@ -12146,7 +12146,7 @@ GetOOBFreqOffset(pDRXDemodInstance_t demod, pDRXFrequency_t freqOffset)
 	u32_t data64Lo = 0;
 	u32_t tempFreqOffset = 0;
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	/* check arguments */
 	if ((demod == NULL) || (freqOffset == NULL)) {
@@ -12238,7 +12238,7 @@ GetOOBFrequency(pDRXDemodInstance_t demod, pDRXFrequency_t frequency)
 	u16_t data = 0;
 	DRXFrequency_t freqOffset = 0;
 	DRXFrequency_t freq = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
 
@@ -12267,7 +12267,7 @@ rw_error:
 * Gets OOB MER. Table for MER is in Programming guide.
 *
 */
-static DRXStatus_t GetOOBMER(pI2CDeviceAddr_t devAddr, pu32_t mer)
+static DRXStatus_t GetOOBMER(struct i2c_device_addr *devAddr, pu32_t mer)
 {
 	u16_t data = 0;
 
@@ -12411,7 +12411,7 @@ rw_error:
 static DRXStatus_t SetOrxNsuAox(pDRXDemodInstance_t demod, Bool_t active)
 {
 	u16_t data = 0;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	extAttr = (pDRXJData_t) demod->myExtAttr;
@@ -12476,7 +12476,7 @@ static DRXStatus_t CtrlSetOOB(pDRXDemodInstance_t demod, pDRXOOB_t oobParam)
 #ifndef DRXJ_DIGITAL_ONLY
 	DRXOOBDownstreamStandard_t standard = DRX_OOB_MODE_A;
 	DRXFrequency_t freq = 0;	/* KHz */
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	u16_t i = 0;
 	Bool_t mirrorFreqSpectOOB = FALSE;
@@ -12750,7 +12750,7 @@ static DRXStatus_t
 CtrlGetOOB(pDRXDemodInstance_t demod, pDRXOOBStatus_t oobStatus)
 {
 #ifndef DRXJ_DIGITAL_ONLY
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	u16_t data = 0;
 
@@ -12793,7 +12793,7 @@ rw_error:
 static DRXStatus_t
 CtrlSetCfgOOBPreSAW(pDRXDemodInstance_t demod, pu16_t cfgData)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	if (cfgData == NULL) {
@@ -12843,7 +12843,7 @@ CtrlGetCfgOOBPreSAW(pDRXDemodInstance_t demod, pu16_t cfgData)
 static DRXStatus_t
 CtrlSetCfgOOBLoPower(pDRXDemodInstance_t demod, pDRXJCfgOobLoPower_t cfgData)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	if (cfgData == NULL) {
@@ -12913,7 +12913,7 @@ CtrlSetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 	DRXFrequency_t tunerFreqOffset = 0;
 	DRXFrequency_t intermediateFreq = 0;
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	TUNERMode_t tunerMode = 0;
 	pDRXCommonAttr_t commonAttr = NULL;
@@ -13289,7 +13289,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetChannel(pDRXDemodInstance_t demod, pDRXChannel_t channel)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
@@ -13540,7 +13540,7 @@ mer2indicator(u16_t mer, u16_t minMer, u16_t thresholdMer, u16_t maxMer)
 static DRXStatus_t
 CtrlSigQuality(pDRXDemodInstance_t demod, pDRXSigQuality_t sigQuality)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
@@ -13676,7 +13676,7 @@ CtrlLockStatus(pDRXDemodInstance_t demod, pDRXLockStatus_t lockStat)
 {
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
 	pDRXJData_t extAttr = NULL;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXJSCUCmd_t cmdSCU = { /* command      */ 0,
 		/* parameterLen */ 0,
 		/* resultLen    */ 0,
@@ -13947,7 +13947,7 @@ static DRXStatus_t
 CtrlGetCfgSymbolClockOffset(pDRXDemodInstance_t demod, ps32_t rateOffset)
 {
 	DRXStandard_t standard = DRX_STANDARD_UNKNOWN;
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	/* check arguments */
@@ -13998,7 +13998,7 @@ CtrlPowerMode(pDRXDemodInstance_t demod, pDRXPowerMode_t mode)
 {
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) NULL;
 	pDRXJData_t extAttr = (pDRXJData_t) NULL;
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) NULL;
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) NULL;
 	u16_t sioCcPwdMode = 0;
 
 	commonAttr = (pDRXCommonAttr_t) demod->myCommonAttr;
@@ -14125,7 +14125,7 @@ static DRXStatus_t
 CtrlVersion(pDRXDemodInstance_t demod, pDRXVersionList_t * versionList)
 {
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXCommonAttr_t commonAttr = (pDRXCommonAttr_t) (NULL);
 	u16_t ucodeMajorMinor = 0;	/* BCD Ma:Ma:Ma:Mi */
 	u16_t ucodePatch = 0;	/* BCD Pa:Pa:Pa:Pa */
@@ -14282,7 +14282,7 @@ static DRXStatus_t CtrlProbeDevice(pDRXDemodInstance_t demod)
 
 	if (commonAttr->isOpened == FALSE
 	    || commonAttr->currentPowerMode != DRX_POWER_UP) {
-		pI2CDeviceAddr_t devAddr = NULL;
+		struct i2c_device_addr *devAddr = NULL;
 		DRXPowerMode_t powerMode = DRX_POWER_UP;
 		u32_t jtag = 0;
 
@@ -14378,7 +14378,7 @@ CtrlUCodeUpload(pDRXDemodInstance_t demod,
 	u16_t mcNrOfBlks = 0;
 	u16_t mcMagicWord = 0;
 	pu8_t mcData = (pu8_t) (NULL);
-	pI2CDeviceAddr_t devAddr = (pI2CDeviceAddr_t) (NULL);
+	struct i2c_device_addr *devAddr = (struct i2c_device_addr *) (NULL);
 	pDRXJData_t extAttr = (pDRXJData_t) (NULL);
 
 	devAddr = demod->myI2CDevAddr;
@@ -14610,7 +14610,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetCfgOOBMisc(pDRXDemodInstance_t demod, pDRXJCfgOOBMisc_t misc)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	u16_t lock = 0U;
 	u16_t state = 0U;
 	u16_t data = 0U;
@@ -14662,7 +14662,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetCfgVSBMisc(pDRXDemodInstance_t demod, pDRXJCfgVSBMisc_t misc)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 
 	/* check arguments */
 	if (misc == NULL) {
@@ -14899,7 +14899,7 @@ CtrlGetCfgAgcRf(pDRXDemodInstance_t demod, pDRXJCfgAgc_t agcSettings)
 static DRXStatus_t
 CtrlGetCfgAgcInternal(pDRXDemodInstance_t demod, pu16_t agcInternal)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	DRXLockStatus_t lockStatus = DRX_NOT_LOCKED;
 	pDRXJData_t extAttr = NULL;
 	u16_t iqmCfScaleSh = 0;
@@ -14982,7 +14982,7 @@ rw_error:
 static DRXStatus_t
 CtrlSetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	devAddr = demod->myI2CDevAddr;
@@ -15051,7 +15051,7 @@ rw_error:
 static DRXStatus_t
 CtrlSetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	u8_t gain = 0;
 
@@ -15127,7 +15127,7 @@ rw_error:
 static DRXStatus_t
 CtrlGetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	/* check arguments */
@@ -15187,7 +15187,7 @@ CtrlGetCfgPreSaw(pDRXDemodInstance_t demod, pDRXJCfgPreSaw_t preSaw)
 static DRXStatus_t
 CtrlGetCfgAfeGain(pDRXDemodInstance_t demod, pDRXJCfgAfeGain_t afeGain)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 
 	/* check arguments */
@@ -15523,7 +15523,7 @@ rw_error:
 */
 DRXStatus_t DRXJ_Open(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
 	u32_t driverVersion = 0;
@@ -15740,7 +15740,7 @@ rw_error:
 */
 DRXStatus_t DRXJ_Close(pDRXDemodInstance_t demod)
 {
-	pI2CDeviceAddr_t devAddr = NULL;
+	struct i2c_device_addr *devAddr = NULL;
 	pDRXJData_t extAttr = NULL;
 	pDRXCommonAttr_t commonAttr = NULL;
 	DRXPowerMode_t powerMode = DRX_POWER_UP;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.h b/drivers/media/dvb-frontends/drx39xyj/drxj.h
index b9e51b44c221..dbd27da9de7f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -734,7 +734,7 @@ Exported GLOBAL VARIABLES
 	extern DRXAccessFunc_t drxDapDRXJFunct_g;
 	extern DRXDemodFunc_t DRXJFunctions_g;
 	extern DRXJData_t DRXJData_g;
-	extern I2CDeviceAddr_t DRXJDefaultAddr_g;
+	extern struct i2c_device_addr DRXJDefaultAddr_g;
 	extern DRXCommonAttr_t DRXJDefaultCommAttr_g;
 	extern DRXDemodInstance_t DRXJDefaultDemod_g;
 
-- 
1.8.5.3

