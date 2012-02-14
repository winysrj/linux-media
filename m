Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28209 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab2BNVsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:23 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 02/22] mt2063: remove unused functions
Date: Tue, 14 Feb 2012 22:47:26 +0100
Message-Id: <1329256066-8844-2-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   34 ----------------------------
 drivers/media/common/tuners/mt2063.h |   40 +++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 47 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 872e9c0..9f3a546 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -2274,40 +2274,6 @@ error:
 }
 EXPORT_SYMBOL_GPL(mt2063_attach);
 
-/*
- * Ancillary routines visible outside mt2063
- * FIXME: Remove them in favor of using standard tuner callbacks
- */
-unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-	int err = 0;
-
-	dprintk(2, "\n");
-
-	err = MT2063_SoftwareShutdown(state, 1);
-	if (err < 0)
-		printk(KERN_ERR "%s: Couldn't shutdown\n", __func__);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(tuner_MT2063_SoftwareShutdown);
-
-unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-	int err = 0;
-
-	dprintk(2, "\n");
-
-	err = MT2063_ClearPowerMaskBits(state, MT2063_ALL_SD);
-	if (err < 0)
-		printk(KERN_ERR "%s: Invalid parameter\n", __func__);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(tuner_MT2063_ClearPowerMaskBits);
-
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_DESCRIPTION("MT2063 Silicon tuner");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index 62d0e8e..46d6d30 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -1,3 +1,25 @@
+/*
+ * Driver for microtune mt2063 tuner
+ *
+ * Copyright (c) 2012 Stefan Ringel <linuxtv@stefanringel.de>
+ * Copyright (c) 2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This driver came from a driver originally written by:
+ *              Henry Wang <Henry.wang@AzureWave.com>
+ * Made publicly available by Terratec, at:
+ *      http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
+ * The original driver's license is GPL, as declared with MODULE_LICENSE()
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
 #ifndef __MT2063_H__
 #define __MT2063_H__
 
@@ -10,27 +32,19 @@ struct mt2063_config {
 
 #if defined(CONFIG_MEDIA_TUNER_MT2063) || (defined(CONFIG_MEDIA_TUNER_MT2063_MODULE) && defined(MODULE))
 struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
-				   struct mt2063_config *config,
-				   struct i2c_adapter *i2c);
+				struct mt2063_config *config,
+				struct i2c_adapter *i2c);
 
 #else
 
 static inline struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
-				   struct mt2063_config *config,
-				   struct i2c_adapter *i2c)
+				struct mt2063_config *config,
+				struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: Driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 
-int mt2063_setTune(struct dvb_frontend *fe, u32 f_in,
-				   u32 bw_in,
-				   enum MTTune_atv_standard tv_type);
-
-/* FIXME: Should use the standard DVB attachment interfaces */
-unsigned int tuner_MT2063_SoftwareShutdown(struct dvb_frontend *fe);
-unsigned int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe);
-
-#endif /* CONFIG_DVB_MT2063 */
+#endif /* CONFIG_MEDIA_TUNER_MT2063 */
 
 #endif /* __MT2063_H__ */
-- 
1.7.7.6

