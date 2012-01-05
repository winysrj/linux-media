Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289Ab2AEBBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:08 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05118wX029452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:08 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 26/47] [media] mt2063: Rework on the publicly-exported functions
Date: Wed,  4 Jan 2012 23:00:37 -0200
Message-Id: <1325725258-27934-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |   44 ++++++++++------------------------
 drivers/media/common/tuners/mt2063.h |    2 +-
 2 files changed, 14 insertions(+), 32 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 53e3960..0bf6292 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -320,53 +320,34 @@ static u32 MT2063_SoftwareShutdown(struct mt2063_state *state, u8 Shutdown);
 static u32 MT2063_ClearPowerMaskBits(struct mt2063_state *state, enum MT2063_Mask_Bits Bits);
 
 
-/*****************/
-/* From drivers/media/common/tuners/mt2063_cfg.h */
-
-
+/*
+ * Ancillary routines visible outside mt2063
+ */
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		err = MT2063_SoftwareShutdown(state, 1);
-		if (err < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
+	err = MT2063_SoftwareShutdown(state, 1);
+	if (err < 0)
+		printk(KERN_ERR "%s: Couldn't shutdown\n", __func__);
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(tuner_MT2063_SoftwareShutdown);
 
 unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
-	struct dvb_frontend_ops *frontend_ops = &fe->ops;
-	struct dvb_tuner_ops *tuner_ops = &frontend_ops->tuner_ops;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
-	if (tuner_ops->set_state) {
-		err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
-		if (err < 0) {
-			printk("%s: Invalid parameter\n", __func__);
-			return err;
-		}
-	}
+	err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
+	if (err < 0)
+		printk(KERN_ERR "%s: Invalid parameter\n", __func__);
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
 
 /*
  * mt2063_write - Write data into the I2C bus
@@ -1173,6 +1154,7 @@ unsigned int mt2063_lockStatus(struct mt2063_state *state)
 	 */
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mt2063_lockStatus);
 
 /****************************************************************************
 **
@@ -3333,8 +3315,8 @@ error:
 	kfree(state);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(mt2063_attach);
 
-EXPORT_SYMBOL(mt2063_attach);
 MODULE_PARM_DESC(verbose, "Set Verbosity level");
 
 MODULE_AUTHOR("Henry");
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index 27273bf..a95c11e 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -27,8 +27,8 @@ unsigned int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
 				   u32 bw_in,
 				   enum MTTune_atv_standard tv_type);
 
+/* FIXME: Should use the standard DVB attachment interfaces */
 unsigned int mt2063_lockStatus(struct dvb_frontend *fe);
-unsigned int tuner_MT2063_Open(struct dvb_frontend *fe);
 unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe);
 unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe);
 
-- 
1.7.7.5

