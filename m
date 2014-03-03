Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaCCKHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:50 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 05/79] [media] drx-j: Fix CodingStyle
Date: Mon,  3 Mar 2014 07:05:59 -0300
Message-Id: <1393841233-24840-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

Make checkpatch.pl happy.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h  | 36 +++-------------
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c | 55 +++++++++++++------------
 2 files changed, 35 insertions(+), 56 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
index 982fc6b7eaa7..d71260240bda 100644
--- a/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
+++ b/drivers/media/dvb-frontends/drx39xyj/bsp_i2c.h
@@ -42,6 +42,8 @@
 *
 */
 
+#include <linux/kernel.h>
+
 #ifndef __BSPI2C_H__
 #define __BSPI2C_H__
 /*------------------------------------------------------------------------------
@@ -49,29 +51,9 @@ INCLUDES
 ------------------------------------------------------------------------------*/
 #include "bsp_types.h"
 
-#ifdef __cplusplus
-extern "C" {
-#endif
 /*------------------------------------------------------------------------------
 TYPEDEFS
 ------------------------------------------------------------------------------*/
-/**
-* \typedef I2Caddr_t
-* \brief I2C device address (7-bit or 10-bit)
-*/
-	typedef u16_t I2Caddr_t;
-
-/**
-* \typedef I2CdevId_t
-* \brief Device identifier.
-*
-* The device ID can be useful if several devices share an I2C address,
-* or if multiple I2C busses are used.
-* It can be used to control a "switch" selecting the correct device and/or
-* I2C bus.
-*
-*/
-	typedef u16_t I2CdevId_t;
 
 /**
 * \struct _I2CDeviceAddr_t
@@ -81,10 +63,10 @@ TYPEDEFS
 * The userData pointer can be used for application specific purposes.
 *
 */
-	struct _I2CDeviceAddr_t {
-		I2Caddr_t i2cAddr;
+	struct I2CDeviceAddr_t {
+		u16 i2cAddr;
 			      /**< The I2C address of the device. */
-		I2CdevId_t i2cDevId;
+		u16 i2cDevId;
 			      /**< The device identifier. */
 		void *userData;
 			      /**< User data pointer */
@@ -97,7 +79,7 @@ TYPEDEFS
 * This structure contains the I2C address and the device ID.
 *
 */
-	typedef struct _I2CDeviceAddr_t I2CDeviceAddr_t;
+	typedef struct I2CDeviceAddr_t I2CDeviceAddr_t;
 
 /**
 * \typedef pI2CDeviceAddr_t
@@ -205,10 +187,4 @@ Exported FUNCTIONS
 */
 	extern int DRX_I2C_Error_g;
 
-/*------------------------------------------------------------------------------
-THE END
-------------------------------------------------------------------------------*/
-#ifdef __cplusplus
-}
-#endif
 #endif				/* __BSPI2C_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 7f9cff1d8413..95ffc9832274 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -46,7 +46,7 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 
 	result = DRX_Ctrl(demod, DRX_CTRL_POWER_MODE, &powerMode);
 	if (result != DRX_STS_OK) {
-		printk("Power state change failed\n");
+		printk(KERN_ERR "Power state change failed\n");
 		return 0;
 	}
 
@@ -54,7 +54,7 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 	return 0;
 }
 
-static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t * status)
+static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
@@ -65,14 +65,14 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t * status)
 
 	result = DRX_Ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
 	if (result != DRX_STS_OK) {
-		printk("drx39xxj: could not get lock status!\n");
+		printk(KERN_ERR "drx39xxj: could not get lock status!\n");
 		*status = 0;
 	}
 
 	switch (lock_status) {
 	case DRX_NEVER_LOCK:
 		*status = 0;
-		printk("drx says NEVER_LOCK\n");
+		printk(KERN_ERR "drx says NEVER_LOCK\n");
 		break;
 	case DRX_NOT_LOCKED:
 		*status = 0;
@@ -95,13 +95,13 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t * status)
 		    | FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
 		break;
 	default:
-		printk("Lock state unknown %d\n", lock_status);
+		printk(KERN_ERR "Lock state unknown %d\n", lock_status);
 	}
 
 	return 0;
 }
 
-static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 * ber)
+static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
@@ -110,7 +110,7 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 * ber)
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
-		printk("drx39xxj: could not get ber!\n");
+		printk(KERN_ERR "drx39xxj: could not get ber!\n");
 		*ber = 0;
 		return 0;
 	}
@@ -120,7 +120,7 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 * ber)
 }
 
 static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
-					 u16 * strength)
+					 u16 *strength)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
@@ -129,7 +129,7 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
-		printk("drx39xxj: could not get signal strength!\n");
+		printk(KERN_ERR "drx39xxj: could not get signal strength!\n");
 		*strength = 0;
 		return 0;
 	}
@@ -139,7 +139,7 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 * snr)
+static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
@@ -148,7 +148,7 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 * snr)
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
-		printk("drx39xxj: could not read snr!\n");
+		printk(KERN_ERR "drx39xxj: could not read snr!\n");
 		*snr = 0;
 		return 0;
 	}
@@ -157,7 +157,7 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 * snr)
 	return 0;
 }
 
-static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 * ucblocks)
+static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
@@ -166,7 +166,7 @@ static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 * ucblocks)
 
 	result = DRX_Ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != DRX_STS_OK) {
-		printk("drx39xxj: could not get uc blocks!\n");
+		printk(KERN_ERR "drx39xxj: could not get uc blocks!\n");
 		*ucblocks = 0;
 		return 0;
 	}
@@ -220,7 +220,8 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 		/* Set the standard (will be powered up if necessary */
 		result = DRX_Ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
 		if (result != DRX_STS_OK) {
-			printk("Failed to set standard! result=%02x\n", result);
+			printk(KERN_ERR "Failed to set standard! result=%02x\n",
+			       result);
 			return -EINVAL;
 		}
 		state->powered_up = 1;
@@ -236,22 +237,22 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	/* program channel */
 	result = DRX_Ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
 	if (result != DRX_STS_OK) {
-		printk("Failed to set channel!\n");
+		printk(KERN_ERR "Failed to set channel!\n");
 		return -EINVAL;
 	}
-	// Just for giggles, let's shut off the LNA again....
+	/* Just for giggles, let's shut off the LNA again.... */
 	uioData.uio = DRX_UIO1;
 	uioData.value = FALSE;
 	result = DRX_Ctrl(demod, DRX_CTRL_UIO_WRITE, &uioData);
 	if (result != DRX_STS_OK) {
-		printk("Failed to disable LNA!\n");
+		printk(KERN_ERR "Failed to disable LNA!\n");
 		return 0;
 	}
 #ifdef DJH_DEBUG
 	for (i = 0; i < 2000; i++) {
 		fe_status_t status;
 		drx39xxj_read_status(fe, &status);
-		printk("i=%d status=%d\n", i, status);
+		printk(KERN_DBG "i=%d status=%d\n", i, status);
 		msleep(100);
 		i += 100;
 	}
@@ -274,7 +275,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 	DRXStatus_t result;
 
 #ifdef DJH_DEBUG
-	printk("i2c gate call: enable=%d state=%d\n", enable,
+	printk(KERN_DBG "i2c gate call: enable=%d state=%d\n", enable,
 	       state->i2c_gate_open);
 #endif
 
@@ -290,7 +291,8 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	result = DRX_Ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
 	if (result != DRX_STS_OK) {
-		printk("drx39xxj: could not open i2c gate [%d]\n", result);
+		printk(KERN_ERR "drx39xxj: could not open i2c gate [%d]\n",
+		       result);
 		dump_stack();
 	} else {
 		state->i2c_gate_open = enable;
@@ -368,7 +370,9 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	memcpy(demod->myCommonAttr, &DRXJDefaultCommAttr_g,
 	       sizeof(DRXCommonAttr_t));
 	demod->myCommonAttr->microcode = DRXJ_MC_MAIN;
-	//      demod->myCommonAttr->verifyMicrocode = FALSE;
+#if 0
+	demod->myCommonAttr->verifyMicrocode = FALSE;
+#endif
 	demod->myCommonAttr->verifyMicrocode = TRUE;
 	demod->myCommonAttr->intermediateFreq = 5000;
 
@@ -381,7 +385,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	result = DRX_Open(demod);
 	if (result != DRX_STS_OK) {
-		printk("DRX open failed!  Aborting\n");
+		printk(KERN_ERR "DRX open failed!  Aborting\n");
 		kfree(state);
 		return NULL;
 	}
@@ -392,7 +396,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	/* Configure user-I/O #3: enable read/write */
 	result = DRX_Ctrl(demod, DRX_CTRL_UIO_CFG, &uioCfg);
 	if (result != DRX_STS_OK) {
-		printk("Failed to setup LNA GPIO!\n");
+		printk(KERN_ERR "Failed to setup LNA GPIO!\n");
 		return NULL;
 	}
 
@@ -400,7 +404,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	uioData.value = FALSE;
 	result = DRX_Ctrl(demod, DRX_CTRL_UIO_WRITE, &uioData);
 	if (result != DRX_STS_OK) {
-		printk("Failed to disable LNA!\n");
+		printk(KERN_ERR "Failed to disable LNA!\n");
 		return NULL;
 	}
 
@@ -418,6 +422,7 @@ error:
 		kfree(demod);
 	return NULL;
 }
+EXPORT_SYMBOL(drx39xxj_attach);
 
 static struct dvb_frontend_ops drx39xxj_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
@@ -444,5 +449,3 @@ static struct dvb_frontend_ops drx39xxj_ops = {
 MODULE_DESCRIPTION("Micronas DRX39xxj Frontend");
 MODULE_AUTHOR("Devin Heitmueller");
 MODULE_LICENSE("GPL");
-
-EXPORT_SYMBOL(drx39xxj_attach);
-- 
1.8.5.3

