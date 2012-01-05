Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab2AEBBG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q05116tC016352
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/47] [media] mt2063: Fix the driver to make it compile
Date: Wed,  4 Jan 2012 23:00:16 -0200
Message-Id: <1325725258-27934-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/mt2063.c |    1 -
 drivers/media/common/tuners/mt2063.h |   25 +++++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 1d36e51..cd3b206 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -4,7 +4,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 
-#include "drxk_type.h"
 #include "mt2063.h"
 
 /*  Version of this module                          */
diff --git a/drivers/media/common/tuners/mt2063.h b/drivers/media/common/tuners/mt2063.h
index 8fa4411..80af9af 100644
--- a/drivers/media/common/tuners/mt2063.h
+++ b/drivers/media/common/tuners/mt2063.h
@@ -1,9 +1,19 @@
 #ifndef __MT2063_H__
 #define __MT2063_H__
 
-#include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
+enum Bool_t {
+  FALSE = 0,
+  TRUE
+};
+
+typedef unsigned long  u32_t;
+
+#define DVBFE_TUNER_OPEN			99
+#define DVBFE_TUNER_SOFTWARE_SHUTDOWN		100
+#define DVBFE_TUNER_CLEAR_POWER_MASKBITS	101
+
 #define MT2063_ERROR (1 << 31)
 #define MT2063_USER_ERROR (1 << 30)
 
@@ -618,17 +628,16 @@ struct mt2063_state {
 	u32 reference;
 };
 
-#if defined(CONFIG_DVB_MT2063) || (defined(CONFIG_DVB_MT2063_MODULE) && defined(MODULE))
-
-extern struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
-					  struct mt2063_config *config,
-					  struct i2c_adapter *i2c);
+#if defined(CONFIG_MEDIA_TUNER_MT2063) || (defined(CONFIG_MEDIA_TUNER_MT2063_MODULE) && defined(MODULE))
+struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
+				   struct mt2063_config *config,
+				   struct i2c_adapter *i2c);
 
 #else
 
 static inline struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
-						 struct mt2063_config *config,
-						 struct i2c_adapter *i2c)
+				   struct mt2063_config *config,
+				   struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: Driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
1.7.7.5

