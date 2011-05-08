Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52923 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1EHXNW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:22 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 4/8] DVB: dvb_frontend: rename parameters to parameters_in
Date: Sun,  8 May 2011 23:03:37 +0000
Message-Id: <1304895821-21642-5-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

- Preparation to distinguish input parameters from output parameters.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   60 ++++++++++++++--------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index bcb4186..aca8457 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -105,7 +105,7 @@ struct dvb_frontend_private {
 
 	/* thread/frontend values */
 	struct dvb_device *dvbdev;
-	struct dvb_frontend_parameters parameters;
+	struct dvb_frontend_parameters parameters_in;
 	struct dvb_fe_events events;
 	struct semaphore sem;
 	struct list_head list_head;
@@ -160,7 +160,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 
 	e = &events->events[events->eventw];
 
-	memcpy (&e->parameters, &fepriv->parameters,
+	memcpy (&e->parameters, &fepriv->parameters_in,
 		sizeof (struct dvb_frontend_parameters));
 
 	if (status & FE_HAS_LOCK)
@@ -277,12 +277,12 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 	int ready = 0;
 	int fe_set_err = 0;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int original_inversion = fepriv->parameters.inversion;
-	u32 original_frequency = fepriv->parameters.frequency;
+	int original_inversion = fepriv->parameters_in.inversion;
+	u32 original_frequency = fepriv->parameters_in.frequency;
 
 	/* are we using autoinversion? */
 	autoinversion = ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
-			 (fepriv->parameters.inversion == INVERSION_AUTO));
+			 (fepriv->parameters_in.inversion == INVERSION_AUTO));
 
 	/* setup parameters correctly */
 	while(!ready) {
@@ -348,18 +348,18 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
 
 	/* set the frontend itself */
-	fepriv->parameters.frequency += fepriv->lnb_drift;
+	fepriv->parameters_in.frequency += fepriv->lnb_drift;
 	if (autoinversion)
-		fepriv->parameters.inversion = fepriv->inversion;
+		fepriv->parameters_in.inversion = fepriv->inversion;
 	if (fe->ops.set_frontend)
-		fe_set_err = fe->ops.set_frontend(fe, &fepriv->parameters);
+		fe_set_err = fe->ops.set_frontend(fe, &fepriv->parameters_in);
 	if (fe_set_err < 0) {
 		fepriv->state = FESTATE_ERROR;
 		return fe_set_err;
 	}
 
-	fepriv->parameters.frequency = original_frequency;
-	fepriv->parameters.inversion = original_inversion;
+	fepriv->parameters_in.frequency = original_frequency;
+	fepriv->parameters_in.inversion = original_inversion;
 
 	fepriv->auto_sub_step++;
 	return 0;
@@ -383,7 +383,7 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 		if (fepriv->state & FESTATE_RETUNE) {
 			if (fe->ops.set_frontend)
 				retval = fe->ops.set_frontend(fe,
-							&fepriv->parameters);
+							&fepriv->parameters_in);
 			if (retval < 0)
 				fepriv->state = FESTATE_ERROR;
 			else
@@ -413,8 +413,8 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 
 		/* if we're tuned, then we have determined the correct inversion */
 		if ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
-		    (fepriv->parameters.inversion == INVERSION_AUTO)) {
-			fepriv->parameters.inversion = fepriv->inversion;
+		    (fepriv->parameters_in.inversion == INVERSION_AUTO)) {
+			fepriv->parameters_in.inversion = fepriv->inversion;
 		}
 		return;
 	}
@@ -594,7 +594,7 @@ restart:
 
 				if (fepriv->state & FESTATE_RETUNE) {
 					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
-					params = &fepriv->parameters;
+					params = &fepriv->parameters_in;
 					fepriv->state = FESTATE_TUNED;
 				}
 
@@ -616,7 +616,7 @@ restart:
 				dprintk("%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n", __func__, fepriv->state);
 				if (fepriv->state & FESTATE_RETUNE) {
 					dprintk("%s: Retune requested, FESTAT_RETUNE\n", __func__);
-					params = &fepriv->parameters;
+					params = &fepriv->parameters_in;
 					fepriv->state = FESTATE_TUNED;
 				}
 				/* Case where we are going to search for a carrier
@@ -625,7 +625,7 @@ restart:
 				 */
 				if (fepriv->algo_status & DVBFE_ALGO_SEARCH_AGAIN) {
 					if (fe->ops.search) {
-						fepriv->algo_status = fe->ops.search(fe, &fepriv->parameters);
+						fepriv->algo_status = fe->ops.search(fe, &fepriv->parameters_in);
 						/* We did do a search as was requested, the flags are
 						 * now unset as well and has the flags wrt to search.
 						 */
@@ -636,7 +636,7 @@ restart:
 				/* Track the carrier if the search was successful */
 				if (fepriv->algo_status == DVBFE_ALGO_SEARCH_SUCCESS) {
 					if (fe->ops.track)
-						fe->ops.track(fe, &fepriv->parameters);
+						fe->ops.track(fe, &fepriv->parameters_in);
 				} else {
 					fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
 					fepriv->delay = HZ / 2;
@@ -1076,7 +1076,7 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 {
 	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_frontend_parameters *p = &fepriv->parameters;
+	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
 
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
@@ -1124,7 +1124,7 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 {
 	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	struct dvb_frontend_parameters *p = &fepriv->parameters;
+	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
 
 	p->frequency = c->frequency;
 	p->inversion = c->inversion;
@@ -1361,7 +1361,7 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 		dtv_property_cache_submit(fe);
 
 		r = dvb_frontend_ioctl_legacy(file, FE_SET_FRONTEND,
-			&fepriv->parameters);
+			&fepriv->parameters_in);
 		break;
 	case DTV_FREQUENCY:
 		fe->dtv_property_cache.frequency = tvp->u.data;
@@ -1792,7 +1792,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		struct dvb_frontend_tune_settings fetunesettings;
 
 		if(fe->dtv_property_cache.state == DTV_TUNE) {
-			if (dvb_frontend_check_parameters(fe, &fepriv->parameters) < 0) {
+			if (dvb_frontend_check_parameters(fe, &fepriv->parameters_in) < 0) {
 				err = -EINVAL;
 				break;
 			}
@@ -1802,9 +1802,9 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 				break;
 			}
 
-			memcpy (&fepriv->parameters, parg,
+			memcpy (&fepriv->parameters_in, parg,
 				sizeof (struct dvb_frontend_parameters));
-			dtv_property_cache_sync(fe, &fepriv->parameters);
+			dtv_property_cache_sync(fe, &fepriv->parameters_in);
 		}
 
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
@@ -1813,15 +1813,15 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 		/* force auto frequency inversion if requested */
 		if (dvb_force_auto_inversion) {
-			fepriv->parameters.inversion = INVERSION_AUTO;
+			fepriv->parameters_in.inversion = INVERSION_AUTO;
 			fetunesettings.parameters.inversion = INVERSION_AUTO;
 		}
 		if (fe->ops.info.type == FE_OFDM) {
 			/* without hierarchical coding code_rate_LP is irrelevant,
 			 * so we tolerate the otherwise invalid FEC_NONE setting */
-			if (fepriv->parameters.u.ofdm.hierarchy_information == HIERARCHY_NONE &&
-			    fepriv->parameters.u.ofdm.code_rate_LP == FEC_NONE)
-				fepriv->parameters.u.ofdm.code_rate_LP = FEC_AUTO;
+			if (fepriv->parameters_in.u.ofdm.hierarchy_information == HIERARCHY_NONE &&
+			    fepriv->parameters_in.u.ofdm.code_rate_LP == FEC_NONE)
+				fepriv->parameters_in.u.ofdm.code_rate_LP = FEC_AUTO;
 		}
 
 		/* get frontend-specific tuning settings */
@@ -1834,8 +1834,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			switch(fe->ops.info.type) {
 			case FE_QPSK:
 				fepriv->min_delay = HZ/20;
-				fepriv->step_size = fepriv->parameters.u.qpsk.symbol_rate / 16000;
-				fepriv->max_drift = fepriv->parameters.u.qpsk.symbol_rate / 2000;
+				fepriv->step_size = fepriv->parameters_in.u.qpsk.symbol_rate / 16000;
+				fepriv->max_drift = fepriv->parameters_in.u.qpsk.symbol_rate / 2000;
 				break;
 
 			case FE_QAM:
@@ -1877,7 +1877,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 	case FE_GET_FRONTEND:
 		if (fe->ops.get_frontend) {
-			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
+			memcpy (parg, &fepriv->parameters_in, sizeof (struct dvb_frontend_parameters));
 			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
 		}
 		break;
-- 
1.7.2.5

