Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbcBDP6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 10:58:47 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH 1/7] [media] dvb_frontend: add props argument to dtv_get_frontend()
Date: Thu,  4 Feb 2016 13:57:26 -0200
Message-Id: <2ea9a08d59b99fbb257bcd8c47e2cbc8be136f8c.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454600641.git.mchehab@osg.samsung.com>
References: <cover.1454600641.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of implicitly using the DTV cache properties at
dtv_get_frontend(), pass it as an additional argument.

This patch prepares to use a separate cache for G_PROPERTY,
in order to avoid it to mangle with the DVB thread
zigzag logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index b1255b7c0b0e..ca6d60f9d492 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -140,9 +140,12 @@ struct dvb_frontend_private {
 
 static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 static int dtv_get_frontend(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *c,
 			    struct dvb_frontend_parameters *p_out);
-static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
-					   struct dvb_frontend_parameters *p);
+static int
+dtv_property_legacy_params_sync(struct dvb_frontend *fe,
+				const struct dtv_frontend_properties *c,
+				struct dvb_frontend_parameters *p);
 
 static bool has_get_frontend(struct dvb_frontend *fe)
 {
@@ -202,6 +205,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe,
 				   enum fe_status status)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_fe_events *events = &fepriv->events;
 	struct dvb_frontend_event *e;
 	int wp;
@@ -209,7 +213,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe,
 	dev_dbg(fe->dvb->device, "%s:\n", __func__);
 
 	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
-		dtv_get_frontend(fe, &fepriv->parameters_out);
+		dtv_get_frontend(fe, c, &fepriv->parameters_out);
 
 	mutex_lock(&events->mtx);
 
@@ -687,6 +691,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 static int dvb_frontend_thread(void *data)
 {
 	struct dvb_frontend *fe = data;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	enum fe_status s;
 	enum dvbfe_algo algo;
@@ -807,7 +812,7 @@ restart:
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
-				dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
+				dtv_property_legacy_params_sync(fe, c, &fepriv->parameters_out);
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
@@ -1274,11 +1279,11 @@ static int dtv_property_cache_sync(struct dvb_frontend *fe,
 /* Ensure the cached values are set correctly in the frontend
  * legacy tuning structures, for the advanced tuning API.
  */
-static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
-					    struct dvb_frontend_parameters *p)
+static int
+dtv_property_legacy_params_sync(struct dvb_frontend *fe,
+				const struct dtv_frontend_properties *c,
+				struct dvb_frontend_parameters *p)
 {
-	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
 
@@ -1350,6 +1355,7 @@ static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
  * If p_out is not null, it will update the DVBv3 params pointed by it.
  */
 static int dtv_get_frontend(struct dvb_frontend *fe,
+			    struct dtv_frontend_properties *c,
 			    struct dvb_frontend_parameters *p_out)
 {
 	int r;
@@ -1359,7 +1365,7 @@ static int dtv_get_frontend(struct dvb_frontend *fe,
 		if (unlikely(r < 0))
 			return r;
 		if (p_out)
-			dtv_property_legacy_params_sync(fe, p_out);
+			dtv_property_legacy_params_sync(fe, c, p_out);
 		return 0;
 	}
 
@@ -2107,7 +2113,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 * is not idle. Otherwise, returns the cached content
 		 */
 		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, NULL);
+			err = dtv_get_frontend(fe, c, NULL);
 			if (err < 0)
 				goto out;
 		}
@@ -2147,7 +2153,7 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 	 * the user. FE_SET_FRONTEND triggers an initial frontend event
 	 * with status = 0, which copies output parameters to userspace.
 	 */
-	dtv_property_legacy_params_sync(fe, &fepriv->parameters_out);
+	dtv_property_legacy_params_sync(fe, c, &fepriv->parameters_out);
 
 	/*
 	 * Be sure that the bandwidth will be filled for all
@@ -2518,7 +2524,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_GET_FRONTEND:
-		err = dtv_get_frontend(fe, parg);
+		err = dtv_get_frontend(fe, c, parg);
 		break;
 
 	case FE_SET_FRONTEND_TUNE_MODE:
-- 
2.5.0


