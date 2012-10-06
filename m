Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2JFOYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Oct 2012 10:24:32 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q96EOW3F012753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 6 Oct 2012 10:24:32 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] mt2063: properly handle return error codes
Date: Sat,  6 Oct 2012 11:24:27 -0300
Message-Id: <1349533467-12119-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a series of warnings when compiled with W=1:

drivers/media/tuners/mt2063.c: In function 'mt2063_setreg':
drivers/media/tuners/mt2063.c:290:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
...
drivers/media/tuners/mt2063.c:2013:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

drivers/media/tuners/mt2063.c:2271:14: warning: no previous prototype for 'tuner_MT2063_SoftwareShutdown' [-Wmissing-prototypes]
drivers/media/tuners/mt2063.c:2286:14: warning: no previous prototype for 'tuner_MT2063_ClearPowerMaskBits' [-Wmissing-prototypes]

Several of those warnings are real bugs: the error status code
used to be unsigned, but they're assigned to negative error
codes.

Fix it by using unsigned int.

While here, comment the two power management functions, while we
don't add a code there to properly handle tuner suspend/resume.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/tuners/mt2063.c | 36 ++++++++++++++++++------------------
 drivers/media/tuners/mt2063.h |  4 ----
 2 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 620c4fa..2e1a02e 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -245,7 +245,7 @@ struct mt2063_state {
 /*
  * mt2063_write - Write data into the I2C bus
  */
-static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
+static int mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 {
 	struct dvb_frontend *fe = state->frontend;
 	int ret;
@@ -277,9 +277,9 @@ static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
 /*
  * mt2063_write - Write register data into the I2C bus, caching the value
  */
-static u32 mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
+static int mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
 {
-	u32 status;
+	int status;
 
 	dprintk(2, "\n");
 
@@ -298,10 +298,10 @@ static u32 mt2063_setreg(struct mt2063_state *state, u8 reg, u8 val)
 /*
  * mt2063_read - Read data from the I2C bus
  */
-static u32 mt2063_read(struct mt2063_state *state,
+static int mt2063_read(struct mt2063_state *state,
 			   u8 subAddress, u8 *pData, u32 cnt)
 {
-	u32 status = 0;	/* Status to be returned        */
+	int status = 0;	/* Status to be returned        */
 	struct dvb_frontend *fe = state->frontend;
 	u32 i = 0;
 
@@ -816,7 +816,7 @@ static u32 IsSpurInBand(struct MT2063_AvoidSpursData_t *pAS_Info,
  */
 static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
 {
-	u32 status = 0;
+	int status = 0;
 	u32 fm, fp;		/*  restricted range on LO's        */
 	pAS_Info->bSpurAvoided = 0;
 	pAS_Info->nSpursFound = 0;
@@ -935,14 +935,14 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
  *
  * This function returns 0, if no lock, 1 if locked and a value < 1 if error
  */
-static unsigned int mt2063_lockStatus(struct mt2063_state *state)
+static int mt2063_lockStatus(struct mt2063_state *state)
 {
 	const u32 nMaxWait = 100;	/*  wait a maximum of 100 msec   */
 	const u32 nPollRate = 2;	/*  poll status bits every 2 ms */
 	const u32 nMaxLoops = nMaxWait / nPollRate;
 	const u8 LO1LK = 0x80;
 	u8 LO2LK = 0x08;
-	u32 status;
+	int status;
 	u32 nDelays = 0;
 
 	dprintk(2, "\n");
@@ -1069,7 +1069,7 @@ static u32 mt2063_get_dnc_output_enable(struct mt2063_state *state,
 static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 					enum MT2063_DNC_Output_Enable nValue)
 {
-	u32 status = 0;	/* Status to be returned        */
+	int status = 0;	/* Status to be returned        */
 	u8 val = 0;
 
 	dprintk(2, "\n");
@@ -1203,7 +1203,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 				  enum mt2063_delivery_sys Mode)
 {
-	u32 status = 0;	/* Status to be returned        */
+	int status = 0;	/* Status to be returned        */
 	u8 val;
 	u32 longval;
 
@@ -1345,7 +1345,7 @@ static u32 MT2063_SetReceiverMode(struct mt2063_state *state,
 static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
 				     enum MT2063_Mask_Bits Bits)
 {
-	u32 status = 0;
+	int status = 0;
 
 	dprintk(2, "\n");
 	Bits = (enum MT2063_Mask_Bits)(Bits & MT2063_ALL_SD);	/* Only valid bits for this tuner */
@@ -1374,7 +1374,7 @@ static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state,
  */
 static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown)
 {
-	u32 status;
+	int status;
 
 	dprintk(2, "\n");
 	if (Shutdown == 1)
@@ -1540,7 +1540,7 @@ static u32 FindClearTuneFilter(struct mt2063_state *state, u32 f_in)
 static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 {				/* RF input center frequency   */
 
-	u32 status = 0;
+	int status = 0;
 	u32 LO1;		/*  1st LO register value           */
 	u32 Num1;		/*  Numerator for LO1 reg. value    */
 	u32 f_IF1;		/*  1st IF requested                */
@@ -1803,7 +1803,7 @@ static const u8 MT2063B3_defaults[] = {
 
 static int mt2063_init(struct dvb_frontend *fe)
 {
-	u32 status;
+	int status;
 	struct mt2063_state *state = fe->tuner_priv;
 	u8 all_resets = 0xF0;	/* reset/load bits */
 	const u8 *def = NULL;
@@ -2264,11 +2264,12 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 }
 EXPORT_SYMBOL_GPL(mt2063_attach);
 
+#if 0
 /*
  * Ancillary routines visible outside mt2063
  * FIXME: Remove them in favor of using standard tuner callbacks
  */
-unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
+static int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 	int err = 0;
@@ -2281,9 +2282,8 @@ unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(tuner_MT2063_SoftwareShutdown);
 
-unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
+static int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 	int err = 0;
@@ -2296,7 +2296,7 @@ unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
+#endif
 
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("MT2063 Silicon tuner");
diff --git a/drivers/media/tuners/mt2063.h b/drivers/media/tuners/mt2063.h
index 3f5cfd9..ab24170 100644
--- a/drivers/media/tuners/mt2063.h
+++ b/drivers/media/tuners/mt2063.h
@@ -23,10 +23,6 @@ static inline struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	return NULL;
 }
 
-/* FIXME: Should use the standard DVB attachment interfaces */
-unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe);
-unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe);
-
 #endif /* CONFIG_DVB_MT2063 */
 
 #endif /* __MT2063_H__ */
-- 
1.7.11.4

