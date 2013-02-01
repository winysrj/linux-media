Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:42037 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab3BAUVw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Feb 2013 15:21:52 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/4] tda8290: Allow custom std_map for tda18271
Date: Fri,  1 Feb 2013 21:21:25 +0100
Message-Id: <1359750087-1155-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359750087-1155-1-git-send-email-linux@rainbow-software.org>
References: <1359750087-1155-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow specifying a custom std_map for tda18271 by external configuration.
This is required by cards that require custom std_map for analog TV or radio,
like AverMedia A706.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/tuners/tda8290.c |    8 ++++++--
 drivers/media/tuners/tda8290.h |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index a2b7a9f..c1ade88 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -54,6 +54,7 @@ struct tda8290_priv {
 #define TDA18271 16
 
 	struct tda827x_config cfg;
+	struct tda18271_std_map *tda18271_std_map;
 };
 
 /*---------------------------------------------------------------------*/
@@ -635,6 +636,7 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 	if ((data == 0x83) || (data == 0x84)) {
 		priv->ver |= TDA18271;
 		tda829x_tda18271_config.config = priv->cfg.config;
+		tda829x_tda18271_config.std_map = priv->tda18271_std_map;
 		dvb_attach(tda18271_attach, fe, priv->tda827x_addr,
 			   priv->i2c_props.adap, &tda829x_tda18271_config);
 	} else {
@@ -746,8 +748,10 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 	priv->i2c_props.addr     = i2c_addr;
 	priv->i2c_props.adap     = i2c_adap;
 	priv->i2c_props.name     = "tda829x";
-	if (cfg)
-		priv->cfg.config         = cfg->lna_cfg;
+	if (cfg) {
+		priv->cfg.config = cfg->lna_cfg;
+		priv->tda18271_std_map = cfg->tda18271_std_map;
+	}
 
 	if (tda8290_probe(&priv->i2c_props) == 0) {
 		priv->ver = TDA8290;
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index 9959cc8..280b70d 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -19,6 +19,7 @@
 
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
+#include "tda18271.h"
 
 struct tda829x_config {
 	unsigned int lna_cfg;
@@ -27,6 +28,7 @@ struct tda829x_config {
 #define TDA829X_PROBE_TUNER 0
 #define TDA829X_DONT_PROBE  1
 	unsigned int no_i2c_gate:1;
+	struct tda18271_std_map *tda18271_std_map;
 };
 
 #if defined(CONFIG_MEDIA_TUNER_TDA8290) || (defined(CONFIG_MEDIA_TUNER_TDA8290_MODULE) && defined(MODULE))
-- 
Ondrej Zary

