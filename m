Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05118In016646
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 21/47] [media] mt2063: Don't violate the DVB API
Date: Wed,  4 Jan 2012 23:00:32 -0200
Message-Id: <1325725258-27934-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   51 ++++++----------------------------
 1 files changed, 9 insertions(+), 42 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index c5e95dd..6c73bfd 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -10,10 +10,6 @@ module_param(verbose, int, 0644);
 
 /* Internal structures and types */
 
-/* FIXME: we probably don't need these new FE get/set property types for tuner */
-#define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
-#define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
-
 /* FIXME: Those two error codes need conversion*/
 /*  Error:  Upconverter PLL is not locked  */
 #define MT2063_UPC_UNLOCK                   (0x80000002)
@@ -411,6 +407,9 @@ static u32 MT2063_GetParam(struct mt2063_state *state, enum MT2063_Param param,
 static u32 MT2063_SetReg(struct mt2063_state *state, u8 reg, u8 val);
 static u32 MT2063_SetParam(struct mt2063_state *state, enum MT2063_Param param,
 			   enum MT2063_DNC_Output_Enable nValue);
+static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown);
+static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mask_Bits Bits);
+
 
 /*****************/
 /* From drivers/media/common/tuners/mt2063_cfg.h */
@@ -466,34 +465,12 @@ unsigned int mt2063_lockStatus(struct dvb_frontend *fe)
 	return err;
 }
 
-unsigned int tuner_MT2063_Open(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
-	int err = 0;
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_OPEN,
-					  &t_state)) < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
-
-	return err;
-}
 
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 {
+	struct mt2063_state *state = fe->tuner_priv;
 	struct dvb_frontend_ops *frontend_ops = &fe->ops;
 	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
 	int err = 0;
 
 	if (&fe->ops)
@@ -501,9 +478,8 @@ unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 	if (&frontend_ops->tuner_ops)
 		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_SOFTWARE_SHUTDOWN,
-					  &t_state)) < 0) {
+		err = MT2063_SoftwareShutdown(state, 1);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -514,9 +490,9 @@ unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 
 unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 {
+	struct mt2063_state *state = fe->tuner_priv;
 	struct dvb_frontend_ops *frontend_ops = &fe->ops;
 	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state t_state;
 	int err = 0;
 
 	if (&fe->ops)
@@ -524,9 +500,8 @@ unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 	if (&frontend_ops->tuner_ops)
 		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->set_state) {
-		if ((err =
-		     tuner_ops->set_state(fe, DVBFE_TUNER_CLEAR_POWER_MASKBITS,
-					  &t_state)) < 0) {
+		err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -3771,14 +3746,6 @@ static int mt2063_set_state(struct dvb_frontend *fe,
 	case DVBFE_TUNER_REFCLOCK:
 
 		break;
-	case DVBFE_TUNER_SOFTWARE_SHUTDOWN:
-		status = MT2063_SoftwareShutdown(state, 1);
-		break;
-	case DVBFE_TUNER_CLEAR_POWER_MASKBITS:
-		status =
-		    MT2063_ClearPowerMaskBits(state,
-					      MT2063_ALL_SD);
-		break;
 	default:
 		break;
 	}
-- 
1.7.7.5

