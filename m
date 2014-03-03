Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaCCKHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 12/79] [media] drx-j: fix whitespacing on pointer parmameters
Date: Mon,  3 Mar 2014 07:06:06 -0300
Message-Id: <1393841233-24840-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch generated with this script:

for i in drivers/media/dvb-frontends/drx39xyj/*.[ch]; do perl -ne 's,(enum|struct|void|int|u32|u64|u16|u8|s8|s16|s32|s64)\s+(\S+)\s+\*[ ]+,\1 \2 *,g; print $_' <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |  8 ++++----
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 16 ++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 1e906b8298fc..fddf491d4816 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -237,9 +237,9 @@ struct tuner_ops {
 
 struct tuner_instance {
 	struct i2c_device_addr myI2CDevAddr;
-	struct tuner_common * myCommonAttr;
+	struct tuner_common *myCommonAttr;
 	void *myExtAttr;
-	struct tuner_ops * myFunct;
+	struct tuner_ops *myFunct;
 };
 
 
@@ -257,7 +257,7 @@ int DRXBSP_TUNER_GetFrequency(struct tuner_instance *tuner,
 					s32 * IFfrequency);
 
 int DRXBSP_TUNER_LockStatus(struct tuner_instance *tuner,
-					enum tuner_lock_status * lockStat);
+					enum tuner_lock_status *lockStat);
 
 int DRXBSP_TUNER_DefaultI2CWriteRead(struct tuner_instance *tuner,
 						struct i2c_device_addr *wDevAddr,
@@ -1223,7 +1223,7 @@ STRUCTS
 	typedef struct {
 		u32 *symbolrate;	  /**<  list of symbolrates to scan   */
 		u16 symbolrateSize;	  /**<  size of symbolrate array      */
-		enum drx_modulation * constellation;
+		enum drx_modulation *constellation;
 					  /**<  list of constellations        */
 		u16 constellationSize;    /**<  size of constellation array */
 		u16 ifAgcThreshold;	  /**<  thresholf for IF-AGC based
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c8212069a540..c13622652bd6 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -6101,7 +6101,7 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBPostRSPckErr(struct i2c_device_addr * devAddr, u16 *PckErrs)
+* \fn static short GetVSBPostRSPckErr(struct i2c_device_addr *devAddr, u16 *PckErrs)
 * \brief Get the values of packet error in 8VSB mode
 * \return Error code
 */
@@ -6132,7 +6132,7 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBBer(struct i2c_device_addr * devAddr, u32 *ber)
+* \fn static short GetVSBBer(struct i2c_device_addr *devAddr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
@@ -6170,7 +6170,7 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBpreViterbiBer(struct i2c_device_addr * devAddr, u32 *ber)
+* \fn static short GetVSBpreViterbiBer(struct i2c_device_addr *devAddr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
@@ -6189,7 +6189,7 @@ rw_error:
 }
 
 /**
-* \fn static short GetVSBSymbErr(struct i2c_device_addr * devAddr, u32 *ber)
+* \fn static short GetVSBSymbErr(struct i2c_device_addr *devAddr, u32 *ber)
 * \brief Get the values of ber in VSB mode
 * \return Error code
 */
@@ -7834,7 +7834,7 @@ rw_error:
 /*============================================================================*/
 
 /**
-* \fn static short GetQAMRSErrCount(struct i2c_device_addr * devAddr)
+* \fn static short GetQAMRSErrCount(struct i2c_device_addr *devAddr)
 * \brief Get RS error count in QAM mode (used for post RS BER calculation)
 * \return Error code
 *
@@ -8841,7 +8841,7 @@ rw_error:
 #ifndef DRXJ_DIGITAL_ONLY
 #define SCU_RAM_ATV_ENABLE_IIR_WA__A 0x831F6D	/* TODO remove after done with reg import */
 static int
-SetATVStandard(pDRXDemodInstance_t demod, enum drx_standard * standard)
+SetATVStandard(pDRXDemodInstance_t demod, enum drx_standard *standard)
 {
 /* TODO: enable alternative for tap settings via external file
 
@@ -13817,7 +13817,7 @@ rw_error:
 *
 */
 static int
-CtrlSetStandard(pDRXDemodInstance_t demod, enum drx_standard * standard)
+CtrlSetStandard(pDRXDemodInstance_t demod, enum drx_standard *standard)
 {
 	pDRXJData_t extAttr = NULL;
 	enum drx_standard prevStandard;
@@ -13917,7 +13917,7 @@ rw_error:
 *
 */
 static int
-CtrlGetStandard(pDRXDemodInstance_t demod, enum drx_standard * standard)
+CtrlGetStandard(pDRXDemodInstance_t demod, enum drx_standard *standard)
 {
 	pDRXJData_t extAttr = NULL;
 	extAttr = (pDRXJData_t) demod->myExtAttr;
-- 
1.8.5.3

