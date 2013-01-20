Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:54831 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab3ATVXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 16:23:04 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/4] tda8290: Allow disabling I2C gate
Date: Sun, 20 Jan 2013 22:22:16 +0100
Message-Id: <1358716939-2133-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1358716939-2133-1-git-send-email-linux@rainbow-software.org>
References: <1358716939-2133-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow disabling I2C gate handling by external configuration.
This is required by cards that have all devices on a single I2C bus,
like AverMedia A706.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/tuners/tda8290.c |   13 +++++++++++--
 drivers/media/tuners/tda8290.h |    1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 8c48521..16dfbf2 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -54,6 +54,7 @@ struct tda8290_priv {
 #define TDA18271 16
 
 	struct tda827x_config cfg;
+	bool no_i2c_gate;
 };
 
 /*---------------------------------------------------------------------*/
@@ -66,6 +67,9 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
 	unsigned char disable[2] = { 0x21, 0x00 };
 	unsigned char *msg;
 
+	if (priv->no_i2c_gate)
+		return 0;
+
 	if (close) {
 		msg = enable;
 		tuner_i2c_xfer_send(&priv->i2c_props, msg, 2);
@@ -88,6 +92,9 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
 	unsigned char buf[3] = { 0x45, 0x01, 0x00 };
 	unsigned char *msg;
 
+	if (priv->no_i2c_gate)
+		return 0;
+
 	if (close) {
 		msg = enable;
 		tuner_i2c_xfer_send(&priv->i2c_props, msg, 2);
@@ -740,8 +747,10 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 	priv->i2c_props.addr     = i2c_addr;
 	priv->i2c_props.adap     = i2c_adap;
 	priv->i2c_props.name     = "tda829x";
-	if (cfg)
-		priv->cfg.config         = cfg->lna_cfg;
+	if (cfg) {
+		priv->cfg.config = cfg->lna_cfg;
+		priv->no_i2c_gate = cfg->no_i2c_gate;
+	}
 
 	if (tda8290_probe(&priv->i2c_props) == 0) {
 		priv->ver = TDA8290;
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index 7e288b2..9959cc8 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -26,6 +26,7 @@ struct tda829x_config {
 	unsigned int probe_tuner:1;
 #define TDA829X_PROBE_TUNER 0
 #define TDA829X_DONT_PROBE  1
+	unsigned int no_i2c_gate:1;
 };
 
 #if defined(CONFIG_MEDIA_TUNER_TDA8290) || (defined(CONFIG_MEDIA_TUNER_TDA8290_MODULE) && defined(MODULE))
-- 
Ondrej Zary

