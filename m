Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52924 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab1EHXNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:22 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 8/8] DVB: allow to read back of detected parameters through S2API
Date: Sun,  8 May 2011 23:03:41 +0000
Message-Id: <1304895821-21642-9-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index b41e5dc..a0f0458 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1023,10 +1023,9 @@ static int is_legacy_delivery_system(fe_delivery_system_t s)
  * it's being used for the legacy or new API, reducing code and complexity.
  */
 static void dtv_property_cache_sync(struct dvb_frontend *fe,
-				    struct dvb_frontend_parameters *p)
+				    struct dtv_frontend_properties *c,
+				    const struct dvb_frontend_parameters *p)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
 	c->frequency = p->frequency;
 	c->inversion = p->inversion;
 
@@ -1200,8 +1199,20 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct file *file)
 {
 	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dtv_frontend_properties cdetected;
 	int r;
 
+	/*
+	 * If the driver implements a get_frontend function, then convert
+	 * detected parameters to S2API properties.
+	 */
+	if (fe->ops.get_frontend) {
+		cdetected = *c;
+		dtv_property_cache_sync(fe, &cdetected, &fepriv->parameters_out);
+		c = &cdetected;
+	}
+
 	switch(tvp->cmd) {
 	case DTV_FREQUENCY:
 		tvp->u.data = c->frequency;
@@ -1812,7 +1823,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 			memcpy (&fepriv->parameters_in, parg,
 				sizeof (struct dvb_frontend_parameters));
-			dtv_property_cache_sync(fe, &fepriv->parameters_in);
+			dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
 		}
 
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
-- 
1.7.2.5

