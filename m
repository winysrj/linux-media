Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBO22021855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 7/9] [media] dvb: get rid of fepriv->parameters_in
Date: Sun,  1 Jan 2012 18:11:16 -0200
Message-Id: <1325448678-13001-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This var were used during DVBv3 times, in order to keep a copy
of the parameters used by the events. This is not needed anymore,
as the parameters are now dynamically generated from the DVBv5
structure.

So, just get rid of it. That means that a DVBv5 pure call won't
use anymore any DVBv3 parameters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index ea3d0a3..678e329 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -108,7 +108,6 @@ struct dvb_frontend_private {
 
 	/* thread/frontend values */
 	struct dvb_device *dvbdev;
-	struct dvb_frontend_parameters parameters_in;
 	struct dvb_frontend_parameters parameters_out;
 	struct dvb_fe_events events;
 	struct semaphore sem;
@@ -696,7 +695,6 @@ restart:
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
-				fepriv->parameters_out = fepriv->parameters_in;
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
@@ -1561,8 +1559,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 {
 	int r = 0;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	dtv_property_dump(tvp);
 
 	/* Allow the frontend to validate incoming properties */
 	if (fe->ops.set_property) {
@@ -1587,9 +1583,6 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		c->state = tvp->cmd;
 		dprintk("%s() Finalised property cache\n", __func__);
 
-		/* Needed, due to status update */
-		dtv_property_legacy_params_sync(fe, &fepriv->parameters_in);
-
 		r = dtv_set_frontend(fe);
 		break;
 	case DTV_FREQUENCY:
@@ -1851,15 +1844,6 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		return -EINVAL;
 
 	/*
-	 * Initialize output parameters to match the values given by
-	 * the user. FE_SET_FRONTEND triggers an initial frontend event
-	 * with status = 0, which copies output parameters to userspace.
-	 *
-	 * This is still needed for DVBv5 calls, due to event state update.
-	 */
-	fepriv->parameters_out = fepriv->parameters_in;
-
-	/*
 	 * Be sure that the bandwidth will be filled for all
 	 * non-satellite systems, as tuners need to know what
 	 * low pass/Nyquist half filter should be applied, in
@@ -2173,15 +2157,11 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_SET_FRONTEND:
-		/* Synchronise DVBv5 parameters from DVBv3 */
-		memcpy (&fepriv->parameters_in, parg,
-			sizeof (struct dvb_frontend_parameters));
-
 		err = set_delivery_system(fe, SYS_UNDEFINED);
 		if (err)
 			break;
 
-		err = dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
+		err = dtv_property_cache_sync(fe, c, parg);
 		if (err)
 			break;
 		err = dtv_set_frontend(fe);
@@ -2191,10 +2171,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 
 	case FE_GET_FRONTEND:
-		err = dtv_get_frontend(fe, &fepriv->parameters_out);
-		if (err >= 0)
-			memcpy(parg, &fepriv->parameters_out,
-			       sizeof(struct dvb_frontend_parameters));
+		err = dtv_get_frontend(fe, parg);
 		break;
 
 	case FE_SET_FRONTEND_TUNE_MODE:
-- 
1.7.8.352.g876a6

