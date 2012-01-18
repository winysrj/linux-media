Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab2ARRvb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 12:51:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0IHpUMJ011180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 18 Jan 2012 12:51:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] dvb_frontend: Require FE_HAS_PARAMETERS for get_frontend()
Date: Wed, 18 Jan 2012 15:51:25 -0200
Message-Id: <1326909085-14256-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1326909085-14256-1-git-send-email-mchehab@redhat.com>
References: <201201181450.14089.pboettcher@kernellabs.com>
 <1326909085-14256-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling get_frontend() before having either the frontend locked
or the network signaling carriers locked won't work. So, block
it at the DVB core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   50 ++++++++++++++--------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index fbbe545..a15c4ed 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -144,11 +144,6 @@ static void dvb_frontend_wakeup(struct dvb_frontend *fe);
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p_out);
 
-static bool has_get_frontend(struct dvb_frontend *fe)
-{
-	return fe->ops.get_frontend;
-}
-
 /*
  * Due to DVBv3 API calls, a delivery system should be mapped into one of
  * the 4 DVBv3 delivery systems (FE_QPSK, FE_QAM, FE_OFDM or FE_ATSC),
@@ -207,8 +202,12 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	dprintk ("%s\n", __func__);
 
-	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
-		dtv_get_frontend(fe, &fepriv->parameters_out);
+	/* FE_HAS_LOCK implies that the frontend has parameters */
+	if (status & FE_HAS_LOCK)
+		status |= FE_HAS_PARAMETERS;
+
+	fepriv->status = status;
+	dtv_get_frontend(fe, &fepriv->parameters_out);
 
 	mutex_lock(&events->mtx);
 
@@ -465,7 +464,6 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 			fe->ops.read_status(fe, &s);
 		if (s != fepriv->status) {
 			dvb_frontend_add_event(fe, s);
-			fepriv->status = s;
 		}
 	}
 
@@ -663,7 +661,6 @@ restart:
 				if (s != fepriv->status && !(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT)) {
 					dprintk("%s: state changed, adding current state\n", __func__);
 					dvb_frontend_add_event(fe, s);
-					fepriv->status = s;
 				}
 				break;
 			case DVBFE_ALGO_SW:
@@ -698,7 +695,6 @@ restart:
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
-					fepriv->status = s;
 					if (!(s & FE_HAS_LOCK)) {
 						fepriv->delay = HZ / 10;
 						fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
@@ -1213,18 +1209,26 @@ static int dtv_property_legacy_params_sync(struct dvb_frontend *fe,
 static int dtv_get_frontend(struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p_out)
 {
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int r;
 
-	if (fe->ops.get_frontend) {
-		r = fe->ops.get_frontend(fe);
-		if (unlikely(r < 0))
-			return r;
-		if (p_out)
-			dtv_property_legacy_params_sync(fe, p_out);
-		return 0;
+	/*
+	 * If the frontend is not locked, the transmission information
+	 * is not available. So, there's no sense on calling the frontend
+	 * to get anything, as all it has is what is already inside the
+	 * cache.
+	 */
+	if (fepriv->status & FE_HAS_PARAMETERS) {
+		if (fe->ops.get_frontend) {
+			r = fe->ops.get_frontend(fe);
+			if (unlikely(r < 0))
+				return r;
+		}
 	}
+	if (p_out)
+		dtv_property_legacy_params_sync(fe, p_out);
 
-	/* As everything is in cache, get_frontend fops are always supported */
+	/* As everything is in cache, get_frontend is always supported */
 	return 0;
 }
 
@@ -1725,7 +1729,6 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_frontend *fe = dvbdev->priv;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int err = 0;
 
@@ -1795,11 +1798,9 @@ static int dvb_frontend_ioctl_properties(struct file *file,
 		 * the data retrieved from get_frontend, if the frontend
 		 * is not idle. Otherwise, returns the cached content
 		 */
-		if (fepriv->state != FESTATE_IDLE) {
-			err = dtv_get_frontend(fe, NULL);
-			if (err < 0)
-				goto out;
-		}
+		err = dtv_get_frontend(fe, NULL);
+		if (err < 0)
+			goto out;
 		for (i = 0; i < tvps->num; i++) {
 			err = dtv_property_process_get(fe, c, tvp + i, file);
 			if (err < 0)
@@ -1922,7 +1923,6 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 	dvb_frontend_clear_events(fe);
 	dvb_frontend_add_event(fe, 0);
 	dvb_frontend_wakeup(fe);
-	fepriv->status = 0;
 
 	return 0;
 }
-- 
1.7.8

