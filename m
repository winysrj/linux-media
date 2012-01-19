Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50849 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932543Ab2ASSqy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 13:46:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] cxd2820r: remove unused parameter from cxd2820r_attach
Date: Thu, 19 Jan 2012 20:46:43 +0200
Message-Id: <1326998803-14108-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix bug introduced by multi-frontend to single-frontend change.
This parameter is no longer used after multi-frontend to single-frontend change.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/anysee.c          |    3 +--
 drivers/media/dvb/frontends/cxd2820r.h      |    6 ++----
 drivers/media/dvb/frontends/cxd2820r_core.c |    3 +--
 drivers/media/video/em28xx/em28xx-dvb.c     |    3 +--
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index ecc3add..7b77c7b 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -887,8 +887,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 
 		/* attach demod */
 		adap->fe_adap[state->fe_id].fe = dvb_attach(cxd2820r_attach,
-				&anysee_cxd2820r_config, &adap->dev->i2c_adap,
-				NULL);
+				&anysee_cxd2820r_config, &adap->dev->i2c_adap);
 
 		state->has_ci = true;
 
diff --git a/drivers/media/dvb/frontends/cxd2820r.h b/drivers/media/dvb/frontends/cxd2820r.h
index cf0f546..5aa306e 100644
--- a/drivers/media/dvb/frontends/cxd2820r.h
+++ b/drivers/media/dvb/frontends/cxd2820r.h
@@ -77,14 +77,12 @@ struct cxd2820r_config {
 	(defined(CONFIG_DVB_CXD2820R_MODULE) && defined(MODULE))
 extern struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
-	struct i2c_adapter *i2c,
-	struct dvb_frontend *fe
+	struct i2c_adapter *i2c
 );
 #else
 static inline struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
-	struct i2c_adapter *i2c,
-	struct dvb_frontend *fe
+	struct i2c_adapter *i2c
 )
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 5fe591d..bdfa207 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -604,8 +604,7 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
 };
 
 struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
-				     struct i2c_adapter *i2c,
-				     struct dvb_frontend *fe)
+		struct i2c_adapter *i2c)
 {
 	struct cxd2820r_priv *priv = NULL;
 	int ret;
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 9449423..aabbf48 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -853,8 +853,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM28174_BOARD_PCTV_290E:
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 					&em28xx_cxd2820r_config,
-					&dev->i2c_adap,
-					NULL);
+					&dev->i2c_adap);
 		if (dvb->fe[0]) {
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach,
-- 
1.7.4.4

