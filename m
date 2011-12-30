Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vpc026604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 85/94] [media] dvb-core: Don't pass DVBv3 parameters on tune() fops
Date: Fri, 30 Dec 2011 13:08:22 -0200
Message-Id: <1325257711-12274-86-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As all parameters are passed via DVBv5 to the frontends, there's
no need to pass them again via fops. Also, most drivers weren't using
it anyway. So, instead, just pass a parameter to indicate if the
hardware algorithm wants the driver to re-tune or not.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dst.c             |   19 ++++++++++---------
 drivers/media/dvb/dvb-core/dvb_frontend.c |    9 +++------
 drivers/media/dvb/dvb-core/dvb_frontend.h |    2 +-
 drivers/media/dvb/frontends/cx24116.c     |    4 ++--
 drivers/media/dvb/frontends/cx24123.c     |    4 ++--
 drivers/media/dvb/frontends/ds3000.c      |    4 ++--
 drivers/media/dvb/frontends/mb86a20s.c    |    4 ++--
 drivers/media/dvb/frontends/s921.c        |    4 ++--
 drivers/media/dvb/pt1/va1j5jf8007s.c      |    4 ++--
 drivers/media/dvb/pt1/va1j5jf8007t.c      |    4 ++--
 10 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index 7d60893..80b1f2a 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1643,31 +1643,32 @@ static int dst_set_frontend(struct dvb_frontend *fe)
 }
 
 static int dst_tune_frontend(struct dvb_frontend* fe,
-			    struct dvb_frontend_parameters* p,
+			    bool re_tune,
 			    unsigned int mode_flags,
 			    unsigned int *delay,
 			    fe_status_t *status)
 {
 	struct dst_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
-	if (p != NULL) {
+	if (re_tune) {
 		dst_set_freq(state, p->frequency);
 		dprintk(verbose, DST_DEBUG, 1, "Set Frequency=[%d]", p->frequency);
 
 		if (state->dst_type == DST_TYPE_IS_SAT) {
 			if (state->type_flags & DST_TYPE_HAS_OBS_REGS)
 				dst_set_inversion(state, p->inversion);
-			dst_set_fec(state, p->u.qpsk.fec_inner);
-			dst_set_symbolrate(state, p->u.qpsk.symbol_rate);
+			dst_set_fec(state, p->fec_inner);
+			dst_set_symbolrate(state, p->symbol_rate);
 			dst_set_polarization(state);
-			dprintk(verbose, DST_DEBUG, 1, "Set Symbolrate=[%d]", p->u.qpsk.symbol_rate);
+			dprintk(verbose, DST_DEBUG, 1, "Set Symbolrate=[%d]", p->symbol_rate);
 
 		} else if (state->dst_type == DST_TYPE_IS_TERR)
-			dst_set_bandwidth(state, p->u.ofdm.bandwidth);
+			dst_set_bandwidth(state, p->bandwidth_hz);
 		else if (state->dst_type == DST_TYPE_IS_CABLE) {
-			dst_set_fec(state, p->u.qam.fec_inner);
-			dst_set_symbolrate(state, p->u.qam.symbol_rate);
-			dst_set_modulation(state, p->u.qam.modulation);
+			dst_set_fec(state, p->fec_inner);
+			dst_set_symbolrate(state, p->symbol_rate);
+			dst_set_modulation(state, p->modulation);
 		}
 		dst_write_tuna(fe);
 	}
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index bf733c4..8cdc666 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -547,7 +547,7 @@ static int dvb_frontend_thread(void *data)
 	fe_status_t s;
 	enum dvbfe_algo algo;
 
-	struct dvb_frontend_parameters *params;
+	bool re_tune = false;
 
 	dprintk("%s\n", __func__);
 
@@ -596,18 +596,15 @@ restart:
 			switch (algo) {
 			case DVBFE_ALGO_HW:
 				dprintk("%s: Frontend ALGO = DVBFE_ALGO_HW\n", __func__);
-				params = NULL; /* have we been asked to RETUNE ? */
 
 				if (fepriv->state & FESTATE_RETUNE) {
 					dprintk("%s: Retune requested, FESTATE_RETUNE\n", __func__);
-					params = &fepriv->parameters_in;
+					re_tune = true;
 					fepriv->state = FESTATE_TUNED;
 				}
 
 				if (fe->ops.tune)
-					fe->ops.tune(fe, params, fepriv->tune_mode_flags, &fepriv->delay, &s);
-				if (params)
-					fepriv->parameters_out = *params;
+					fe->ops.tune(fe, re_tune, fepriv->tune_mode_flags, &fepriv->delay, &s);
 
 				if (s != fepriv->status && !(fepriv->tune_mode_flags & FE_TUNE_MODE_ONESHOT)) {
 					dprintk("%s: state changed, adding current state\n", __func__);
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 4b49bcd..e10fe77 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -273,7 +273,7 @@ struct dvb_frontend_ops {
 
 	/* if this is set, it overrides the default swzigzag */
 	int (*tune)(struct dvb_frontend* fe,
-		    struct dvb_frontend_parameters* params,
+		    bool re_tune,
 		    unsigned int mode_flags,
 		    unsigned int *delay,
 		    fe_status_t *status);
diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index f24819a..e29de1c 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -1440,7 +1440,7 @@ tuned:  /* Set/Reset B/W */
 	return cx24116_cmd_execute(fe, &cmd);
 }
 
-static int cx24116_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters *params,
+static int cx24116_tune(struct dvb_frontend *fe, bool re_tune,
 	unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
 {
 	/*
@@ -1452,7 +1452,7 @@ static int cx24116_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters
 	 */
 
 	*delay = HZ / 5;
-	if (params) {
+	if (re_tune) {
 		int ret = cx24116_set_frontend(fe);
 		if (ret)
 			return ret;
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index a8af0bd..faafb1f 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -1006,14 +1006,14 @@ static int cx24123_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
 }
 
 static int cx24123_tune(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *params,
+			bool re_tune,
 			unsigned int mode_flags,
 			unsigned int *delay,
 			fe_status_t *status)
 {
 	int retval = 0;
 
-	if (params != NULL)
+	if (re_tune)
 		retval = cx24123_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index f8fa80a..c6a43c4 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -1205,12 +1205,12 @@ static int ds3000_set_frontend(struct dvb_frontend *fe)
 }
 
 static int ds3000_tune(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *p,
+			bool re_tune,
 			unsigned int mode_flags,
 			unsigned int *delay,
 			fe_status_t *status)
 {
-	if (p) {
+	if (re_tune) {
 		int ret = ds3000_set_frontend(fe);
 		if (ret)
 			return ret;
diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index a67d7ef..d71d6ee 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -540,7 +540,7 @@ static int mb86a20s_get_frontend(struct dvb_frontend *fe,
 }
 
 static int mb86a20s_tune(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *params,
+			bool re_tune,
 			unsigned int mode_flags,
 			unsigned int *delay,
 			fe_status_t *status)
@@ -549,7 +549,7 @@ static int mb86a20s_tune(struct dvb_frontend *fe,
 
 	dprintk("\n");
 
-	if (params != NULL)
+	if (re_tune)
 		rc = mb86a20s_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
diff --git a/drivers/media/dvb/frontends/s921.c b/drivers/media/dvb/frontends/s921.c
index 4c452f4..2e15f92 100644
--- a/drivers/media/dvb/frontends/s921.c
+++ b/drivers/media/dvb/frontends/s921.c
@@ -445,7 +445,7 @@ static int s921_get_frontend(struct dvb_frontend *fe,
 }
 
 static int s921_tune(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *params,
+			bool re_tune,
 			unsigned int mode_flags,
 			unsigned int *delay,
 			fe_status_t *status)
@@ -454,7 +454,7 @@ static int s921_tune(struct dvb_frontend *fe,
 
 	dprintk("\n");
 
-	if (params != NULL)
+	if (re_tune)
 		rc = s921_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
diff --git a/drivers/media/dvb/pt1/va1j5jf8007s.c b/drivers/media/dvb/pt1/va1j5jf8007s.c
index 451641c..78344e3 100644
--- a/drivers/media/dvb/pt1/va1j5jf8007s.c
+++ b/drivers/media/dvb/pt1/va1j5jf8007s.c
@@ -385,7 +385,7 @@ va1j5jf8007s_check_ts_id(struct va1j5jf8007s_state *state, int *lock)
 
 static int
 va1j5jf8007s_tune(struct dvb_frontend *fe,
-		  struct dvb_frontend_parameters *params,
+		  bool re_tune,
 		  unsigned int mode_flags,  unsigned int *delay,
 		  fe_status_t *status)
 {
@@ -395,7 +395,7 @@ va1j5jf8007s_tune(struct dvb_frontend *fe,
 
 	state = fe->demodulator_priv;
 
-	if (params != NULL)
+	if (re_tune)
 		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_1;
 
 	switch (state->tune_state) {
diff --git a/drivers/media/dvb/pt1/va1j5jf8007t.c b/drivers/media/dvb/pt1/va1j5jf8007t.c
index 0f085c3..c642820 100644
--- a/drivers/media/dvb/pt1/va1j5jf8007t.c
+++ b/drivers/media/dvb/pt1/va1j5jf8007t.c
@@ -264,7 +264,7 @@ static int va1j5jf8007t_check_modulation(struct va1j5jf8007t_state *state,
 
 static int
 va1j5jf8007t_tune(struct dvb_frontend *fe,
-		  struct dvb_frontend_parameters *params,
+		  bool re_tune,
 		  unsigned int mode_flags,  unsigned int *delay,
 		  fe_status_t *status)
 {
@@ -274,7 +274,7 @@ va1j5jf8007t_tune(struct dvb_frontend *fe,
 
 	state = fe->demodulator_priv;
 
-	if (params != NULL)
+	if (re_tune)
 		state->tune_state = VA1J5JF8007T_SET_FREQUENCY;
 
 	switch (state->tune_state) {
-- 
1.7.8.352.g876a6

