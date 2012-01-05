Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab2AEBBL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:11 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511BQG016662
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 33/47] [media] mt2063: Rearrange the delivery system functions
Date: Wed,  4 Jan 2012 23:00:44 -0200
Message-Id: <1325725258-27934-34-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No functional changes on this patch. Better organize the delivery
system information and data types, putting everything together,
to improve readability.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |  143 ++++++++++++++++------------------
 1 files changed, 66 insertions(+), 77 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 181deac..5e9655a 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -130,19 +130,6 @@ enum MT2063_Mask_Bits {
 };
 
 /*
- *  Parameter for selecting tuner mode
- */
-enum MT2063_RCVR_MODES {
-	MT2063_CABLE_QAM = 0,	/* Digital cable              */
-	MT2063_CABLE_ANALOG,	/* Analog cable               */
-	MT2063_OFFAIR_COFDM,	/* Digital offair             */
-	MT2063_OFFAIR_COFDM_SAWLESS,	/* Digital offair without SAW */
-	MT2063_OFFAIR_ANALOG,	/* Analog offair              */
-	MT2063_OFFAIR_8VSB,	/* Analog offair              */
-	MT2063_NUM_RCVR_MODES
-};
-
-/*
  *  Possible values for MT2063_DNC_OUTPUT
  */
 enum MT2063_DNC_Output_Enable {
@@ -904,37 +891,6 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 #define MT2063_B2       (0x9D)
 #define MT2063_B3       (0x9E)
 
-/*
- *  Constants for setting receiver modes.
- *  (6 modes defined at this time, enumerated by MT2063_RCVR_MODES)
- *  (DNC1GC & DNC2GC are the values, which are used, when the specific
- *   DNC Output is selected, the other is always off)
- *
- *                enum MT2063_RCVR_MODES
- * -------------+----------------------------------------------
- * Mode 0 :     | MT2063_CABLE_QAM
- * Mode 1 :     | MT2063_CABLE_ANALOG
- * Mode 2 :     | MT2063_OFFAIR_COFDM
- * Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
- * Mode 4 :     | MT2063_OFFAIR_ANALOG
- * Mode 5 :     | MT2063_OFFAIR_8VSB
- * --------------+----------------------------------------------
- */
-static const u8 RFAGCEN[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 LNARIN[] = { 0, 0, 3, 3, 3, 3 };
-static const u8 FIFFQEN[] = { 1, 1, 1, 1, 1, 1 };
-static const u8 FIFFQ[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 DNC1GC[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 DNC2GC[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ACLNAMAX[] = { 31, 31, 31, 31, 31, 31 };
-static const u8 LNATGT[] = { 44, 43, 43, 43, 43, 43 };
-static const u8 RFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ACRFMAX[] = { 31, 31, 31, 31, 31, 31 };
-static const u8 PD1TGT[] = { 36, 36, 38, 38, 36, 38 };
-static const u8 FIFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
-static const u8 ACFIFMAX[] = { 29, 29, 29, 29, 29, 29 };
-static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
-
 /**
  * mt2063_lockStatus - Checks to see if LO1 and LO2 are locked
  *
@@ -977,6 +933,67 @@ static unsigned int mt2063_lockStatus(struct mt2063_state *state)
 }
 
 /*
+ *  Constants for setting receiver modes.
+ *  (6 modes defined at this time, enumerated by mt2063_delivery_sys)
+ *  (DNC1GC & DNC2GC are the values, which are used, when the specific
+ *   DNC Output is selected, the other is always off)
+ *
+ *                enum mt2063_delivery_sys
+ * -------------+----------------------------------------------
+ * Mode 0 :     | MT2063_CABLE_QAM
+ * Mode 1 :     | MT2063_CABLE_ANALOG
+ * Mode 2 :     | MT2063_OFFAIR_COFDM
+ * Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
+ * Mode 4 :     | MT2063_OFFAIR_ANALOG
+ * Mode 5 :     | MT2063_OFFAIR_8VSB
+ * --------------+----------------------------------------------
+ *
+ *                |<----------   Mode  -------------->|
+ *    Reg Field   |  0  |  1  |  2  |  3  |  4  |  5  |
+ *    ------------+-----+-----+-----+-----+-----+-----+
+ *    RFAGCen     | OFF | OFF | OFF | OFF | OFF | OFF
+ *    LNARin      |   0 |   0 |   3 |   3 |  3  |  3
+ *    FIFFQen     |   1 |   1 |   1 |   1 |  1  |  1
+ *    FIFFq       |   0 |   0 |   0 |   0 |  0  |  0
+ *    DNC1gc      |   0 |   0 |   0 |   0 |  0  |  0
+ *    DNC2gc      |   0 |   0 |   0 |   0 |  0  |  0
+ *    GCU Auto    |   1 |   1 |   1 |   1 |  1  |  1
+ *    LNA max Atn |  31 |  31 |  31 |  31 | 31  | 31
+ *    LNA Target  |  44 |  43 |  43 |  43 | 43  | 43
+ *    ign  RF Ovl |   0 |   0 |   0 |   0 |  0  |  0
+ *    RF  max Atn |  31 |  31 |  31 |  31 | 31  | 31
+ *    PD1 Target  |  36 |  36 |  38 |  38 | 36  | 38
+ *    ign FIF Ovl |   0 |   0 |   0 |   0 |  0  |  0
+ *    FIF max Atn |   5 |   5 |   5 |   5 |  5  |  5
+ *    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
+ */
+
+enum mt2063_delivery_sys {
+	MT2063_CABLE_QAM = 0,		/* Digital cable              */
+	MT2063_CABLE_ANALOG,		/* Analog cable               */
+	MT2063_OFFAIR_COFDM,		/* Digital offair             */
+	MT2063_OFFAIR_COFDM_SAWLESS,	/* Digital offair without SAW */
+	MT2063_OFFAIR_ANALOG,		/* Analog offair              */
+	MT2063_OFFAIR_8VSB,		/* Analog offair              */
+	MT2063_NUM_RCVR_MODES
+};
+
+static const u8 RFAGCEN[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 LNARIN[] = { 0, 0, 3, 3, 3, 3 };
+static const u8 FIFFQEN[] = { 1, 1, 1, 1, 1, 1 };
+static const u8 FIFFQ[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 DNC1GC[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 DNC2GC[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 ACLNAMAX[] = { 31, 31, 31, 31, 31, 31 };
+static const u8 LNATGT[] = { 44, 43, 43, 43, 43, 43 };
+static const u8 RFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 ACRFMAX[] = { 31, 31, 31, 31, 31, 31 };
+static const u8 PD1TGT[] = { 36, 36, 38, 38, 36, 38 };
+static const u8 FIFOVDIS[] = { 0, 0, 0, 0, 0, 0 };
+static const u8 ACFIFMAX[] = { 29, 29, 29, 29, 29, 29 };
+static const u8 PD2TGT[] = { 40, 33, 38, 42, 30, 38 };
+
+/*
  * mt2063_set_dnc_output_enable()
  */
 static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
@@ -1119,48 +1136,20 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 }
 
 /*
- * MT2063_SetReceiverMode() - Set the MT2063 receiver mode
-**
- *                 enum MT2063_RCVR_MODES
- * --------------+----------------------------------------------
- *  Mode 0 :     | MT2063_CABLE_QAM
- *  Mode 1 :     | MT2063_CABLE_ANALOG
- *  Mode 2 :     | MT2063_OFFAIR_COFDM
- *  Mode 3 :     | MT2063_OFFAIR_COFDM_SAWLESS
- *  Mode 4 :     | MT2063_OFFAIR_ANALOG
- *  Mode 5 :     | MT2063_OFFAIR_8VSB
- * --------------+----------------------------------------------
+ * MT2063_SetReceiverMode() - Set the MT2063 receiver mode, according with
+ * 			      the selected enum mt2063_delivery_sys type.
+ *
  *  (DNC1GC & DNC2GC are the values, which are used, when the specific
  *   DNC Output is selected, the other is always off)
  *
- *                |<----------   Mode  -------------->|
- *    Reg Field   |  0  |  1  |  2  |  3  |  4  |  5  |
- *    ------------+-----+-----+-----+-----+-----+-----+
- *    RFAGCen     | OFF | OFF | OFF | OFF | OFF | OFF
- *    LNARin      |   0 |   0 |   3 |   3 |  3  |  3
- *    FIFFQen     |   1 |   1 |   1 |   1 |  1  |  1
- *    FIFFq       |   0 |   0 |   0 |   0 |  0  |  0
- *    DNC1gc      |   0 |   0 |   0 |   0 |  0  |  0
- *    DNC2gc      |   0 |   0 |   0 |   0 |  0  |  0
- *    GCU Auto    |   1 |   1 |   1 |   1 |  1  |  1
- *    LNA max Atn |  31 |  31 |  31 |  31 | 31  | 31
- *    LNA Target  |  44 |  43 |  43 |  43 | 43  | 43
- *    ign  RF Ovl |   0 |   0 |   0 |   0 |  0  |  0
- *    RF  max Atn |  31 |  31 |  31 |  31 | 31  | 31
- *    PD1 Target  |  36 |  36 |  38 |  38 | 36  | 38
- *    ign FIF Ovl |   0 |   0 |   0 |   0 |  0  |  0
- *    FIF max Atn |   5 |   5 |   5 |   5 |  5  |  5
- *    PD2 Target  |  40 |  33 |  42 |  42 | 33  | 42
- *
- *
  * @state:	ptr to mt2063_state structure
- * @Mode:	desired reciever mode
+ * @Mode:	desired reciever delivery system
  *
  * Note: Register cache must be valid for it to work
  */
 
 static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
-				  enum MT2063_RCVR_MODES Mode)
+				  enum mt2063_delivery_sys Mode)
 {
 	u32 status = 0;	/* Status to be returned        */
 	u8 val;
-- 
1.7.7.5

