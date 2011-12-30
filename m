Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9WqU009185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 84/94] [media] dvb: simplify get_tune_settings() struct
Date: Fri, 30 Dec 2011 13:08:21 -0200
Message-Id: <1325257711-12274-85-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, dvb_frontent_parameters were passed inside the
struct where get_tuner_settings should store their result.

This is not needed anymore, as all parameters needed are stored
already at the fe property cache. So, use it, where needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    3 ---
 drivers/media/dvb/dvb-core/dvb_frontend.h |    1 -
 drivers/media/dvb/frontends/s5h1420.c     |   16 ++++++++--------
 drivers/media/dvb/frontends/stv0299.c     |    9 +++++----
 drivers/media/dvb/frontends/tda10086.c    |   16 +++++++++-------
 5 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 5bb6c1d..bf733c4 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1977,13 +1977,10 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		fepriv->parameters_out = fepriv->parameters_in;
 
 		memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
-		memcpy(&fetunesettings.parameters, parg,
-		       sizeof (struct dvb_frontend_parameters));
 
 		/* force auto frequency inversion if requested */
 		if (dvb_force_auto_inversion) {
 			fepriv->parameters_in.inversion = INVERSION_AUTO;
-			fetunesettings.parameters.inversion = INVERSION_AUTO;
 		}
 		if (fe->ops.info.type == FE_OFDM) {
 			/* without hierarchical coding code_rate_LP is irrelevant,
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 23456b3..4b49bcd 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -52,7 +52,6 @@ struct dvb_frontend_tune_settings {
 	int min_delay_ms;
 	int step_size;
 	int max_drift;
-	struct dvb_frontend_parameters parameters;
 };
 
 struct dvb_frontend;
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 3bdfcbe..0726494 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -639,7 +639,6 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe)
 	dprintk("enter %s\n", __func__);
 
 	/* check if we should do a fast-tune */
-	memcpy(&fesettings.parameters, p, sizeof(struct dtv_frontend_properties));
 	s5h1420_get_tune_settings(fe, &fesettings);
 	frequency_delta = p->frequency - state->tunedfreq;
 	if ((frequency_delta > -fesettings.max_drift) &&
@@ -782,29 +781,30 @@ static int s5h1420_get_frontend(struct dvb_frontend* fe,
 static int s5h1420_get_tune_settings(struct dvb_frontend* fe,
 				     struct dvb_frontend_tune_settings* fesettings)
 {
-	if (fesettings->parameters.u.qpsk.symbol_rate > 20000000) {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	if (p->symbol_rate > 20000000) {
 		fesettings->min_delay_ms = 50;
 		fesettings->step_size = 2000;
 		fesettings->max_drift = 8000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 12000000) {
+	} else if (p->symbol_rate > 12000000) {
 		fesettings->min_delay_ms = 100;
 		fesettings->step_size = 1500;
 		fesettings->max_drift = 9000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 8000000) {
+	} else if (p->symbol_rate > 8000000) {
 		fesettings->min_delay_ms = 100;
 		fesettings->step_size = 1000;
 		fesettings->max_drift = 8000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 4000000) {
+	} else if (p->symbol_rate > 4000000) {
 		fesettings->min_delay_ms = 100;
 		fesettings->step_size = 500;
 		fesettings->max_drift = 7000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 2000000) {
+	} else if (p->symbol_rate > 2000000) {
 		fesettings->min_delay_ms = 200;
-		fesettings->step_size = (fesettings->parameters.u.qpsk.symbol_rate / 8000);
+		fesettings->step_size = (p->symbol_rate / 8000);
 		fesettings->max_drift = 14 * fesettings->step_size;
 	} else {
 		fesettings->min_delay_ms = 200;
-		fesettings->step_size = (fesettings->parameters.u.qpsk.symbol_rate / 8000);
+		fesettings->step_size = (p->symbol_rate / 8000);
 		fesettings->max_drift = 18 * fesettings->step_size;
 	}
 
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index abf4bff..ad6f3a6 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -647,14 +647,15 @@ static int stv0299_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 static int stv0299_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* fesettings)
 {
 	struct stv0299_state* state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	fesettings->min_delay_ms = state->config->min_delay_ms;
-	if (fesettings->parameters.u.qpsk.symbol_rate < 10000000) {
-		fesettings->step_size = fesettings->parameters.u.qpsk.symbol_rate / 32000;
+	if (p->symbol_rate < 10000000) {
+		fesettings->step_size = p->symbol_rate / 32000;
 		fesettings->max_drift = 5000;
 	} else {
-		fesettings->step_size = fesettings->parameters.u.qpsk.symbol_rate / 16000;
-		fesettings->max_drift = fesettings->parameters.u.qpsk.symbol_rate / 2000;
+		fesettings->step_size = p->symbol_rate / 16000;
+		fesettings->max_drift = p->symbol_rate / 2000;
 	}
 	return 0;
 }
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index 81fa57b..cfc6e0e 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -664,29 +664,31 @@ static int tda10086_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 
 static int tda10086_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings* fesettings)
 {
-	if (fesettings->parameters.u.qpsk.symbol_rate > 20000000) {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	if (p->symbol_rate > 20000000) {
 		fesettings->min_delay_ms = 50;
 		fesettings->step_size = 2000;
 		fesettings->max_drift = 8000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 12000000) {
+	} else if (p->symbol_rate > 12000000) {
 		fesettings->min_delay_ms = 100;
 		fesettings->step_size = 1500;
 		fesettings->max_drift = 9000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 8000000) {
+	} else if (p->symbol_rate > 8000000) {
 		fesettings->min_delay_ms = 100;
 		fesettings->step_size = 1000;
 		fesettings->max_drift = 8000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 4000000) {
+	} else if (p->symbol_rate > 4000000) {
 		fesettings->min_delay_ms = 100;
 		fesettings->step_size = 500;
 		fesettings->max_drift = 7000;
-	} else if (fesettings->parameters.u.qpsk.symbol_rate > 2000000) {
+	} else if (p->symbol_rate > 2000000) {
 		fesettings->min_delay_ms = 200;
-		fesettings->step_size = (fesettings->parameters.u.qpsk.symbol_rate / 8000);
+		fesettings->step_size = p->symbol_rate / 8000;
 		fesettings->max_drift = 14 * fesettings->step_size;
 	} else {
 		fesettings->min_delay_ms = 200;
-		fesettings->step_size = (fesettings->parameters.u.qpsk.symbol_rate / 8000);
+		fesettings->step_size =  p->symbol_rate / 8000;
 		fesettings->max_drift = 18 * fesettings->step_size;
 	}
 
-- 
1.7.8.352.g876a6

