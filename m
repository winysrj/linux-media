Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Wlv024227
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:32 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 86/94] [media] dvb: don't pass a DVBv3 parameter for search() fops
Date: Fri, 30 Dec 2011 13:08:23 -0200
Message-Id: <1325257711-12274-87-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like the other DVB algorithms, drivers should use the DVBv5
way to retrieve parameters: via the cache struct.

Actually, several drivers were partially using the DVBv3 struct
and partially using the DVBv5 way, with is confusing and may
lead into troubles.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c   |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h   |    2 +-
 drivers/media/dvb/frontends/cxd2820r_core.c |    3 +--
 drivers/media/dvb/frontends/mb86a16.c       |    6 +++---
 drivers/media/dvb/frontends/stb0899_drv.c   |    6 +++---
 drivers/media/dvb/frontends/stv0900_core.c  |    3 +--
 drivers/media/dvb/frontends/stv090x.c       |    8 ++++----
 7 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 8cdc666..18a7e23 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -628,7 +628,7 @@ restart:
 				 */
 				if (fepriv->algo_status & DVBFE_ALGO_SEARCH_AGAIN) {
 					if (fe->ops.search) {
-						fepriv->algo_status = fe->ops.search(fe, &fepriv->parameters_in);
+						fepriv->algo_status = fe->ops.search(fe);
 						/* We did do a search as was requested, the flags are
 						 * now unset as well and has the flags wrt to search.
 						 */
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index e10fe77..79f01ce 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -306,7 +306,7 @@ struct dvb_frontend_ops {
 	/* These callbacks are for devices that implement their own
 	 * tuning algorithms, rather than a simple swzigzag
 	 */
-	enum dvbfe_search (*search)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p);
+	enum dvbfe_search (*search)(struct dvb_frontend *fe);
 	int (*track)(struct dvb_frontend *fe, struct dvb_frontend_parameters *p);
 
 	struct dvb_tuner_ops tuner_ops;
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 5b2d840..96ceed7 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -653,8 +653,7 @@ static int cxd2820r_get_tune_settings(struct dvb_frontend *fe,
 	return ret;
 }
 
-static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 {
 	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
diff --git a/drivers/media/dvb/frontends/mb86a16.c b/drivers/media/dvb/frontends/mb86a16.c
index 292ba7b..45844f4 100644
--- a/drivers/media/dvb/frontends/mb86a16.c
+++ b/drivers/media/dvb/frontends/mb86a16.c
@@ -1621,13 +1621,13 @@ err:
 	return -EREMOTEIO;
 }
 
-static enum dvbfe_search mb86a16_search(struct dvb_frontend *fe,
-					struct dvb_frontend_parameters *p)
+static enum dvbfe_search mb86a16_search(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mb86a16_state *state = fe->demodulator_priv;
 
 	state->frequency = p->frequency / 1000;
-	state->srate = p->u.qpsk.symbol_rate / 1000;
+	state->srate = p->symbol_rate / 1000;
 
 	if (!mb86a16_set_fe(state)) {
 		dprintk(verbose, MB86A16_ERROR, 1, "Successfully acquired LOCK");
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index 0c47a99..93afc79 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1431,7 +1431,7 @@ static void stb0899_set_iterations(struct stb0899_state *state)
 	stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
 }
 
-static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static enum dvbfe_search stb0899_search(struct dvb_frontend *fe)
 {
 	struct stb0899_state *state = fe->demodulator_priv;
 	struct stb0899_params *i_params = &state->params;
@@ -1441,8 +1441,8 @@ static enum dvbfe_search stb0899_search(struct dvb_frontend *fe, struct dvb_fron
 
 	u32 SearchRange, gain;
 
-	i_params->freq	= p->frequency;
-	i_params->srate = p->u.qpsk.symbol_rate;
+	i_params->freq	= props->frequency;
+	i_params->srate = props->symbol_rate;
 	state->delsys = props->delivery_system;
 	dprintk(state->verbose, FE_DEBUG, 1, "delivery system=%d", state->delsys);
 
diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index 3f7e62f..83e9a81 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -1558,8 +1558,7 @@ static int stv0900_status(struct stv0900_internal *intp,
 	return locked;
 }
 
-static enum dvbfe_search stv0900_search(struct dvb_frontend *fe,
-					struct dvb_frontend_parameters *params)
+static enum dvbfe_search stv0900_search(struct dvb_frontend *fe)
 {
 	struct stv0900_state *state = fe->demodulator_priv;
 	struct stv0900_internal *intp = state->internal;
diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 574ef67..dd8ded5 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3427,17 +3427,17 @@ err:
 	return -1;
 }
 
-static enum dvbfe_search stv090x_search(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static enum dvbfe_search stv090x_search(struct dvb_frontend *fe)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *props = &fe->dtv_property_cache;
 
-	if (p->frequency == 0)
+	if (props->frequency == 0)
 		return DVBFE_ALGO_SEARCH_INVALID;
 
 	state->delsys = props->delivery_system;
-	state->frequency = p->frequency;
-	state->srate = p->u.qpsk.symbol_rate;
+	state->frequency = props->frequency;
+	state->srate = props->symbol_rate;
 	state->search_mode = STV090x_SEARCH_AUTO;
 	state->algo = STV090x_COLD_SEARCH;
 	state->fec = STV090x_PRERR;
-- 
1.7.8.352.g876a6

