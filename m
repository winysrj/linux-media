Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:55979 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab3ATVXJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 16:23:09 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/4] tda8290: Allow custom std_map for tda18271
Date: Sun, 20 Jan 2013 22:22:17 +0100
Message-Id: <1358716939-2133-3-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1358716939-2133-1-git-send-email-linux@rainbow-software.org>
References: <1358716939-2133-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow specifying a custom std_map for tda18271 by external configuration.
This is required by cards that require custom std_map for analog TV or radio,
like AverMedia A706.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/tuners/tda8290.c |    3 +++
 drivers/media/tuners/tda8290.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 16dfbf2..45fdb46 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -55,6 +55,7 @@ struct tda8290_priv {
 
 	struct tda827x_config cfg;
 	bool no_i2c_gate;
+	struct tda18271_std_map *tda18271_std_map;
 };
 
 /*---------------------------------------------------------------------*/
@@ -637,6 +638,7 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 	if ((data == 0x83) || (data == 0x84)) {
 		priv->ver |= TDA18271;
 		tda829x_tda18271_config.config = priv->cfg.config;
+		tda829x_tda18271_config.std_map = priv->tda18271_std_map;
 		dvb_attach(tda18271_attach, fe, priv->tda827x_addr,
 			   priv->i2c_props.adap, &tda829x_tda18271_config);
 	} else {
@@ -750,6 +752,7 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 	if (cfg) {
 		priv->cfg.config = cfg->lna_cfg;
 		priv->no_i2c_gate = cfg->no_i2c_gate;
+		priv->tda18271_std_map = cfg->tda18271_std_map;
 	}
 
 	if (tda8290_probe(&priv->i2c_props) == 0) {
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

