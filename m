Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab2AEBBH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05117Zo029442
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/47] [media] mt2063: Remove unused data structures
Date: Wed,  4 Jan 2012 23:00:25 -0200
Message-Id: <1325725258-27934-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   97 +++++-----------------------------
 1 files changed, 14 insertions(+), 83 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index a1acfcc..30c72c0 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -16,53 +16,35 @@ module_param(verbose, int, 0644);
 #define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
 #define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
 
-/* FIXME: Those error codes need conversion*/
+/* FIXME: Those two error codes need conversion*/
 /*  Error:  Upconverter PLL is not locked  */
 #define MT2063_UPC_UNLOCK                   (0x80000002)
 /*  Error:  Downconverter PLL is not locked  */
 #define MT2063_DNC_UNLOCK                   (0x80000004)
+
 /*  Info: Unavoidable LO-related spur may be present in the output  */
-#define MT2063_SPUR_PRESENT_ERR                 (0x00800000)
+#define MT2063_SPUR_PRESENT_ERR             (0x00800000)
 
 /*  Info: Mask of bits used for # of LO-related spurs that were avoided during tuning  */
 #define MT2063_SPUR_CNT_MASK                (0x001f0000)
 #define MT2063_SPUR_SHIFT                   (16)
 
-
-/*  Info: Tuner input frequency is out of range */
-#define MT2063_FIN_RANGE                    (0x01000000)
-
-/*  Info: Tuner output frequency is out of range */
-#define MT2063_FOUT_RANGE                   (0x02000000)
-
 /*  Info: Upconverter frequency is out of range (may be reason for MT_UPC_UNLOCK) */
 #define MT2063_UPC_RANGE                    (0x04000000)
 
 /*  Info: Downconverter frequency is out of range (may be reason for MT_DPC_UNLOCK) */
 #define MT2063_DNC_RANGE                    (0x08000000)
 
-/*
- *  Data Types
- */
-
 #define MAX_UDATA         (4294967295)	/*  max value storable in u32   */
 
-/*
- * Define an MTxxxx_CNT macro for each type of tuner that will be built
- * into your application (e.g., MT2121, MT2060). MT_TUNER_CNT
- * must be set to the SUM of all of the MTxxxx_CNT macros.
- *
- * #define MT2050_CNT  (1)
- * #define MT2060_CNT  (1)
- * #define MT2111_CNT  (1)
- * #define MT2121_CNT  (3)
- */
-
-
 #define MT2063_TUNER_CNT               (1)	/*  total num of MicroTuner tuners  */
 #define MT2063_I2C (0xC0)
 
 /*
+ *  Data Types
+ */
+
+/*
  *  Constant defining the version of the following structure
  *  and therefore the API for this code.
  *
@@ -89,8 +71,6 @@ enum MT2063_DECT_Avoid_Type {
 
 #define MT2063_MAX_ZONES 48
 
-struct MT2063_ExclZone_t;
-
 struct MT2063_ExclZone_t {
 	u32 min_;
 	u32 max_;
@@ -130,57 +110,6 @@ struct MT2063_AvoidSpursData_t {
 };
 
 /*
- *  Values returned by the MT2063's on-chip temperature sensor
- *  to be read/written.
- */
-enum MT2063_Temperature {
-	MT2063_T_0C = 0,	/*  Temperature approx 0C           */
-	MT2063_T_10C,		/*  Temperature approx 10C          */
-	MT2063_T_20C,		/*  Temperature approx 20C          */
-	MT2063_T_30C,		/*  Temperature approx 30C          */
-	MT2063_T_40C,		/*  Temperature approx 40C          */
-	MT2063_T_50C,		/*  Temperature approx 50C          */
-	MT2063_T_60C,		/*  Temperature approx 60C          */
-	MT2063_T_70C,		/*  Temperature approx 70C          */
-	MT2063_T_80C,		/*  Temperature approx 80C          */
-	MT2063_T_90C,		/*  Temperature approx 90C          */
-	MT2063_T_100C,		/*  Temperature approx 100C         */
-	MT2063_T_110C,		/*  Temperature approx 110C         */
-	MT2063_T_120C,		/*  Temperature approx 120C         */
-	MT2063_T_130C,		/*  Temperature approx 130C         */
-	MT2063_T_140C,		/*  Temperature approx 140C         */
-	MT2063_T_150C,		/*  Temperature approx 150C         */
-};
-
-/*
- * Parameters for selecting GPIO bits
- */
-enum MT2063_GPIO_Attr {
-	MT2063_GPIO_IN,
-	MT2063_GPIO_DIR,
-	MT2063_GPIO_OUT,
-};
-
-enum MT2063_GPIO_ID {
-	MT2063_GPIO0,
-	MT2063_GPIO1,
-	MT2063_GPIO2,
-};
-
-/*
- *  Parameter for function MT2063_SetExtSRO that specifies the external
- *  SRO drive frequency.
- *
- *  MT2063_EXT_SRO_OFF is the power-up default value.
- */
-enum MT2063_Ext_SRO {
-	MT2063_EXT_SRO_OFF,	/*  External SRO drive off          */
-	MT2063_EXT_SRO_BY_4,	/*  External SRO drive divide by 4  */
-	MT2063_EXT_SRO_BY_2,	/*  External SRO drive divide by 2  */
-	MT2063_EXT_SRO_BY_1	/*  External SRO drive divide by 1  */
-};
-
-/*
  *  Parameter for function MT2063_SetPowerMask that specifies the power down
  *  of various sections of the MT2063.
  */
@@ -456,7 +385,6 @@ struct MT2063_Info_t {
 	u32 num_regs;
 	u8 reg[MT2063_REG_END_REGS];
 };
-typedef struct MT2063_Info_t *pMT2063_Info_t;
 
 enum MTTune_atv_standard {
 	MTTUNEA_UNKNOWN = 0,
@@ -498,7 +426,8 @@ static u32 MT2063_Close(struct MT2063_Info_t *pInfo);
 static u32 MT2063_GetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 * val);
 static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 * pValue);
 static u32 MT2063_SetReg(struct MT2063_Info_t *pInfo, u8 reg, u8 val);
-static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 nValue);
+static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param,
+			   enum MT2063_DNC_Output_Enable nValue);
 
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
@@ -2236,7 +2165,7 @@ static u32 MT2063_GetLocked(struct MT2063_Info_t *pInfo)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 * pValue)
+static u32 MT2063_GetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 *pValue)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u32 Div;
@@ -3221,7 +3150,9 @@ static u32 MT2063_ReInit(struct MT2063_Info_t *pInfo)
 **         06-24-2008    PINZ   Ver 1.18: Add Get/SetParam CTFILT_SW
 **
 ****************************************************************************/
-static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param, u32 nValue)
+static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo,
+		           enum MT2063_Param param,
+			   enum MT2063_DNC_Output_Enable nValue)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u8 val = 0;
@@ -3599,7 +3530,7 @@ static u32 MT2063_SetParam(struct MT2063_Info_t *pInfo, enum MT2063_Param param,
 
 	case MT2063_DNC_OUTPUT_ENABLE:
 		/* selects, which DNC output is used */
-		switch ((enum MT2063_DNC_Output_Enable)nValue) {
+		switch (nValue) {
 		case MT2063_DNC_NONE:
 			{
 				val = (pInfo->reg[MT2063_REG_DNC_GAIN] & 0xFC) | 0x03;	/* Set DNC1GC=3 */
-- 
1.7.7.5

