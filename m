Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52921 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1EHXNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:21 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 7/8] DVB: dvb_frontend: add parameters_out
Date: Sun,  8 May 2011 23:03:40 +0000
Message-Id: <1304895821-21642-8-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

- Holds the parameters detected by the demod.
- Updated on every call to get_frontend, either through ioctl or when
  a frontend event occurs.
- Reset to input parameters after every call to set_frontend, tune or
  search/track.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index d4485c8..b41e5dc 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -106,6 +106,7 @@ struct dvb_frontend_private {
 	/* thread/frontend values */
 	struct dvb_device *dvbdev;
 	struct dvb_frontend_parameters parameters_in;
+	struct dvb_frontend_parameters parameters_out;
 	struct dvb_fe_events events;
 	struct semaphore sem;
 	struct list_head list_head;
@@ -160,12 +161,11 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	e = &events->events[events->eventw];
 
-	memcpy (&e->parameters, &fepriv->parameters_in,
-		sizeof (struct dvb_frontend_parameters));
-
 	if (status & FE_HAS_LOCK)
 		if (fe->ops.get_frontend)
-			fe->ops.get_frontend(fe, &e->parameters);
+			fe->ops.get_frontend(fe, &fepriv->parameters_out);
+
+	e->parameters = fepriv->parameters_out;
 
 	events->eventw = wp;
 
@@ -353,6 +353,7 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 		fepriv->parameters_in.inversion = fepriv->inversion;
 	if (fe->ops.set_frontend)
 		fe_set_err = fe->ops.set_frontend(fe, &fepriv->parameters_in);
+	fepriv->parameters_out = fepriv->parameters_in;
 	if (fe_set_err < 0) {
 		fepriv->state = FESTATE_ERROR;
 		return fe_set_err;
@@ -384,6 +385,7 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 			if (fe->ops.set_frontend)
 				retval = fe->ops.set_frontend(fe,
 							&fepriv->parameters_in);
+			fepriv->parameters_out = fepriv->parameters_in;
 			if (retval < 0)
 				fepriv->state = FESTATE_ERROR;
 			else
@@ -600,6 +602,8 @@ restart:
 
 				if (fe->ops.tune)
 					fe->ops.tune(fe, params, fepriv->tune_mode_flags, &fepriv->delay, &s);
+				if (params)
+					fepriv->parameters_out = *params;
 
 				if (s != fepriv->status && !(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT)) {
 					dprintk("%s: state changed, adding current state\n", __func__);
@@ -639,6 +643,7 @@ restart:
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
 				}
+				fepriv->parameters_out = fepriv->parameters_in;
 				fe->ops.read_status(fe, &s);
 				if (s != fepriv->status) {
 					dvb_frontend_add_event(fe, s); /* update event list */
@@ -1880,8 +1885,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 	case FE_GET_FRONTEND:
 		if (fe->ops.get_frontend) {
-			memcpy (parg, &fepriv->parameters_in, sizeof (struct dvb_frontend_parameters));
-			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
+			err = fe->ops.get_frontend(fe, &fepriv->parameters_out);
+			memcpy(parg, &fepriv->parameters_out, sizeof(struct dvb_frontend_parameters));
 		}
 		break;
 
-- 
1.7.2.5

