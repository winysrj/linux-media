Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9WqG015944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 93/94] dvb_frontend: Fix inversion breakage due to DVBv5 conversion
Date: Fri, 30 Dec 2011 13:08:30 -0200
Message-Id: <1325257711-12274-94-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On several places inside dvb_frontend, only the DVBv3 parameters
were updated. Change it to be sure that, on all places, the DVBv5
parameters will be changed instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   38 ++++++++++++++++-------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 9dd30be..9d092a6 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -288,12 +288,13 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 	int ready = 0;
 	int fe_set_err = 0;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	int original_inversion = fepriv->parameters_in.inversion;
-	u32 original_frequency = fepriv->parameters_in.frequency;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
+	int original_inversion = c->inversion;
+	u32 original_frequency = c->frequency;
 
 	/* are we using autoinversion? */
 	autoinversion = ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
-			 (fepriv->parameters_in.inversion == INVERSION_AUTO));
+			 (c->inversion == INVERSION_AUTO));
 
 	/* setup parameters correctly */
 	while(!ready) {
@@ -359,19 +360,20 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
 
 	/* set the frontend itself */
-	fepriv->parameters_in.frequency += fepriv->lnb_drift;
+	c->frequency += fepriv->lnb_drift;
 	if (autoinversion)
-		fepriv->parameters_in.inversion = fepriv->inversion;
+		c->inversion = fepriv->inversion;
+	tmp = *c;
 	if (fe->ops.set_frontend)
 		fe_set_err = fe->ops.set_frontend(fe);
-	fepriv->parameters_out = fepriv->parameters_in;
+	*c = tmp;
 	if (fe_set_err < 0) {
 		fepriv->state = FESTATE_ERROR;
 		return fe_set_err;
 	}
 
-	fepriv->parameters_in.frequency = original_frequency;
-	fepriv->parameters_in.inversion = original_inversion;
+	c->frequency = original_frequency;
+	c->inversion = original_inversion;
 
 	fepriv->auto_sub_step++;
 	return 0;
@@ -382,6 +384,7 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 	fe_status_t s = 0;
 	int retval = 0;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache, tmp;
 
 	/* if we've got no parameters, just keep idling */
 	if (fepriv->state & FESTATE_IDLE) {
@@ -393,9 +396,10 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 	/* in SCAN mode, we just set the frontend when asked and leave it alone */
 	if (fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT) {
 		if (fepriv->state & FESTATE_RETUNE) {
+			tmp = *c;
 			if (fe->ops.set_frontend)
 				retval = fe->ops.set_frontend(fe);
-			fepriv->parameters_out = fepriv->parameters_in;
+			*c = tmp;
 			if (retval < 0)
 				fepriv->state = FESTATE_ERROR;
 			else
@@ -425,8 +429,8 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 
 		/* if we're tuned, then we have determined the correct inversion */
 		if ((!(fe->ops.info.caps & FE_CAN_INVERSION_AUTO)) &&
-		    (fepriv->parameters_in.inversion == INVERSION_AUTO)) {
-			fepriv->parameters_in.inversion = fepriv->inversion;
+		    (c->inversion == INVERSION_AUTO)) {
+			c->inversion = fepriv->inversion;
 		}
 		return;
 	}
@@ -1976,14 +1980,14 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 		/* force auto frequency inversion if requested */
 		if (dvb_force_auto_inversion) {
-			fepriv->parameters_in.inversion = INVERSION_AUTO;
+			c->inversion = INVERSION_AUTO;
 		}
 		if (fe->ops.info.type == FE_OFDM) {
 			/* without hierarchical coding code_rate_LP is irrelevant,
 			 * so we tolerate the otherwise invalid FEC_NONE setting */
-			if (fepriv->parameters_in.u.ofdm.hierarchy_information == HIERARCHY_NONE &&
-			    fepriv->parameters_in.u.ofdm.code_rate_LP == FEC_NONE)
-				fepriv->parameters_in.u.ofdm.code_rate_LP = FEC_AUTO;
+			if (c->hierarchy == HIERARCHY_NONE &&
+			    c->code_rate_LP == FEC_NONE)
+				c->code_rate_LP = FEC_AUTO;
 		}
 
 		/* get frontend-specific tuning settings */
@@ -1996,8 +2000,8 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			switch(fe->ops.info.type) {
 			case FE_QPSK:
 				fepriv->min_delay = HZ/20;
-				fepriv->step_size = fepriv->parameters_in.u.qpsk.symbol_rate / 16000;
-				fepriv->max_drift = fepriv->parameters_in.u.qpsk.symbol_rate / 2000;
+				fepriv->step_size = c->symbol_rate / 16000;
+				fepriv->max_drift = c->symbol_rate / 2000;
 				break;
 
 			case FE_QAM:
-- 
1.7.8.352.g876a6

