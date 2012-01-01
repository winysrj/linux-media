Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab2AAULY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:11:24 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q01KBN3t021907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 1 Jan 2012 15:11:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/9] [media] dvb: move dvb_set_frontend logic into a separate routine
Date: Sun,  1 Jan 2012 18:11:12 -0200
Message-Id: <1325448678-13001-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change is there in order to prepare the code to avoid calling
 dvb_frontend_ioctl_legacy() from FE_SET_PROPERTY.

A call to dvb_frontend_ioctl_legacy() would require to update the
DVBv3 cache without need, mangling calls for newer delivery system
without any reason.

No functional changes here.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |  182 +++++++++++++++--------------
 1 files changed, 93 insertions(+), 89 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 33ce309..eefcb7f 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1786,6 +1786,97 @@ out:
 	return err;
 }
 
+static int dtv_set_frontend(struct file *file, unsigned int cmd, void *parg)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct dvb_frontend *fe = dvbdev->priv;
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dvb_frontend_tune_settings fetunesettings;
+
+	if (c->state == DTV_TUNE) {
+		if (dvb_frontend_check_parameters(fe, &fepriv->parameters_in) < 0)
+			return -EINVAL;
+	} else {
+		if (dvb_frontend_check_parameters(fe, parg) < 0)
+			return -EINVAL;
+
+		memcpy (&fepriv->parameters_in, parg,
+			sizeof (struct dvb_frontend_parameters));
+		dtv_property_cache_init(fe, c);
+		dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
+	}
+
+	/*
+		* Initialize output parameters to match the values given by
+		* the user. FE_SET_FRONTEND triggers an initial frontend event
+		* with status = 0, which copies output parameters to userspace.
+		*/
+	fepriv->parameters_out = fepriv->parameters_in;
+
+	memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
+
+	/* force auto frequency inversion if requested */
+	if (dvb_force_auto_inversion) {
+		c->inversion = INVERSION_AUTO;
+	}
+	if (fe->ops.info.type == FE_OFDM) {
+		/* without hierarchical coding code_rate_LP is irrelevant,
+			* so we tolerate the otherwise invalid FEC_NONE setting */
+		if (c->hierarchy == HIERARCHY_NONE &&
+			c->code_rate_LP == FEC_NONE)
+			c->code_rate_LP = FEC_AUTO;
+	}
+
+	/* get frontend-specific tuning settings */
+	if (fe->ops.get_tune_settings && (fe->ops.get_tune_settings(fe, &fetunesettings) == 0)) {
+		fepriv->min_delay = (fetunesettings.min_delay_ms * HZ) / 1000;
+		fepriv->max_drift = fetunesettings.max_drift;
+		fepriv->step_size = fetunesettings.step_size;
+	} else {
+		/* default values */
+		switch(fe->ops.info.type) {
+		case FE_QPSK:
+			fepriv->min_delay = HZ/20;
+			fepriv->step_size = c->symbol_rate / 16000;
+			fepriv->max_drift = c->symbol_rate / 2000;
+			break;
+
+		case FE_QAM:
+			fepriv->min_delay = HZ/20;
+			fepriv->step_size = 0; /* no zigzag */
+			fepriv->max_drift = 0;
+			break;
+
+		case FE_OFDM:
+			fepriv->min_delay = HZ/20;
+			fepriv->step_size = fe->ops.info.frequency_stepsize * 2;
+			fepriv->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
+			break;
+		case FE_ATSC:
+			fepriv->min_delay = HZ/20;
+			fepriv->step_size = 0;
+			fepriv->max_drift = 0;
+			break;
+		}
+	}
+	if (dvb_override_tune_delay > 0)
+		fepriv->min_delay = (dvb_override_tune_delay * HZ) / 1000;
+
+	fepriv->state = FESTATE_RETUNE;
+
+	/* Request the search algorithm to search */
+	fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
+
+	dvb_frontend_clear_events(fe);
+	dvb_frontend_add_event(fe, 0);
+	dvb_frontend_wakeup(fe);
+	fepriv->status = 0;
+
+	return 0;
+}
+
+
 static int dvb_frontend_ioctl_legacy(struct file *file,
 			unsigned int cmd, void *parg)
 {
@@ -1969,96 +2060,9 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			err = fe->ops.enable_high_lnb_voltage(fe, (long) parg);
 		break;
 
-	case FE_SET_FRONTEND: {
-		struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-		struct dvb_frontend_tune_settings fetunesettings;
-
-		if (c->state == DTV_TUNE) {
-			if (dvb_frontend_check_parameters(fe, &fepriv->parameters_in) < 0) {
-				err = -EINVAL;
-				break;
-			}
-		} else {
-			if (dvb_frontend_check_parameters(fe, parg) < 0) {
-				err = -EINVAL;
-				break;
-			}
-
-			memcpy (&fepriv->parameters_in, parg,
-				sizeof (struct dvb_frontend_parameters));
-			dtv_property_cache_init(fe, c);
-			dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
-		}
-
-		/*
-		 * Initialize output parameters to match the values given by
-		 * the user. FE_SET_FRONTEND triggers an initial frontend event
-		 * with status = 0, which copies output parameters to userspace.
-		 */
-		fepriv->parameters_out = fepriv->parameters_in;
-
-		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
-
-		/* force auto frequency inversion if requested */
-		if (dvb_force_auto_inversion) {
-			c->inversion = INVERSION_AUTO;
-		}
-		if (fe->ops.info.type == FE_OFDM) {
-			/* without hierarchical coding code_rate_LP is irrelevant,
-			 * so we tolerate the otherwise invalid FEC_NONE setting */
-			if (c->hierarchy == HIERARCHY_NONE &&
-			    c->code_rate_LP == FEC_NONE)
-				c->code_rate_LP = FEC_AUTO;
-		}
-
-		/* get frontend-specific tuning settings */
-		if (fe->ops.get_tune_settings && (fe->ops.get_tune_settings(fe, &fetunesettings) == 0)) {
-			fepriv->min_delay = (fetunesettings.min_delay_ms * HZ) / 1000;
-			fepriv->max_drift = fetunesettings.max_drift;
-			fepriv->step_size = fetunesettings.step_size;
-		} else {
-			/* default values */
-			switch(fe->ops.info.type) {
-			case FE_QPSK:
-				fepriv->min_delay = HZ/20;
-				fepriv->step_size = c->symbol_rate / 16000;
-				fepriv->max_drift = c->symbol_rate / 2000;
-				break;
-
-			case FE_QAM:
-				fepriv->min_delay = HZ/20;
-				fepriv->step_size = 0; /* no zigzag */
-				fepriv->max_drift = 0;
-				break;
-
-			case FE_OFDM:
-				fepriv->min_delay = HZ/20;
-				fepriv->step_size = fe->ops.info.frequency_stepsize * 2;
-				fepriv->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
-				break;
-			case FE_ATSC:
-				fepriv->min_delay = HZ/20;
-				fepriv->step_size = 0;
-				fepriv->max_drift = 0;
-				break;
-			}
-		}
-		if (dvb_override_tune_delay > 0)
-			fepriv->min_delay = (dvb_override_tune_delay * HZ) / 1000;
-
-		fepriv->state = FESTATE_RETUNE;
-
-		/* Request the search algorithm to search */
-		fepriv->algo_status |= DVBFE_ALGO_SEARCH_AGAIN;
-
-		dvb_frontend_clear_events(fe);
-		dvb_frontend_add_event(fe, 0);
-		dvb_frontend_wakeup(fe);
-		fepriv->status = 0;
-		err = 0;
+	case FE_SET_FRONTEND:
+		err = dtv_set_frontend(file, cmd, parg);
 		break;
-	}
-
 	case FE_GET_EVENT:
 		err = dvb_frontend_get_event (fe, parg, file->f_flags);
 		break;
-- 
1.7.8.352.g876a6

