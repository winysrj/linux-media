Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1L0BJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:34 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19XnR015626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 14/91] [media] cx23123: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:02 -0200
Message-Id: <1324948159-23709-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-14-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/cx24123.c |   40 ++++++++++++++++----------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index 4dfe786..a8af0bd 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -526,9 +526,9 @@ static int cx24123_set_symbolrate(struct cx24123_state *state, u32 srate)
  * to be configured and the correct band selected.
  * Calculate those values.
  */
-static int cx24123_pll_calculate(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int cx24123_pll_calculate(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cx24123_state *state = fe->demodulator_priv;
 	u32 ndiv = 0, adiv = 0, vco_div = 0;
 	int i = 0;
@@ -548,8 +548,8 @@ static int cx24123_pll_calculate(struct dvb_frontend *fe,
 	 * FILTUNE programming bits */
 	for (i = 0; i < ARRAY_SIZE(cx24123_AGC_vals); i++) {
 		agcv = &cx24123_AGC_vals[i];
-		if ((agcv->symbolrate_low <= p->u.qpsk.symbol_rate) &&
-		    (agcv->symbolrate_high >= p->u.qpsk.symbol_rate)) {
+		if ((agcv->symbolrate_low <= p->symbol_rate) &&
+		    (agcv->symbolrate_high >= p->symbol_rate)) {
 			state->VCAarg = agcv->VCAprogdata;
 			state->VGAarg = agcv->VGAprogdata;
 			state->FILTune = agcv->FILTune;
@@ -658,15 +658,15 @@ static int cx24123_pll_writereg(struct dvb_frontend *fe, u32 data)
 	return 0;
 }
 
-static int cx24123_pll_tune(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int cx24123_pll_tune(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct cx24123_state *state = fe->demodulator_priv;
 	u8 val;
 
 	dprintk("frequency=%i\n", p->frequency);
 
-	if (cx24123_pll_calculate(fe, p) != 0) {
+	if (cx24123_pll_calculate(fe) != 0) {
 		err("%s: cx24123_pll_calcutate failed\n", __func__);
 		return -EINVAL;
 	}
@@ -924,10 +924,10 @@ static int cx24123_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
-static int cx24123_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int cx24123_set_frontend(struct dvb_frontend *fe)
 {
 	struct cx24123_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	dprintk("\n");
 
@@ -935,14 +935,14 @@ static int cx24123_set_frontend(struct dvb_frontend *fe,
 		state->config->set_ts_params(fe, 0);
 
 	state->currentfreq = p->frequency;
-	state->currentsymbolrate = p->u.qpsk.symbol_rate;
+	state->currentsymbolrate = p->symbol_rate;
 
 	cx24123_set_inversion(state, p->inversion);
-	cx24123_set_fec(state, p->u.qpsk.fec_inner);
-	cx24123_set_symbolrate(state, p->u.qpsk.symbol_rate);
+	cx24123_set_fec(state, p->fec_inner);
+	cx24123_set_symbolrate(state, p->symbol_rate);
 
 	if (!state->config->dont_use_pll)
-		cx24123_pll_tune(fe, p);
+		cx24123_pll_tune(fe);
 	else if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 	else
@@ -960,7 +960,7 @@ static int cx24123_set_frontend(struct dvb_frontend *fe,
 }
 
 static int cx24123_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+				struct dtv_frontend_properties *p)
 {
 	struct cx24123_state *state = fe->demodulator_priv;
 
@@ -970,12 +970,12 @@ static int cx24123_get_frontend(struct dvb_frontend *fe,
 		err("%s: Failed to get inversion status\n", __func__);
 		return -EREMOTEIO;
 	}
-	if (cx24123_get_fec(state, &p->u.qpsk.fec_inner) != 0) {
+	if (cx24123_get_fec(state, &p->fec_inner) != 0) {
 		err("%s: Failed to get fec status\n", __func__);
 		return -EREMOTEIO;
 	}
 	p->frequency = state->currentfreq;
-	p->u.qpsk.symbol_rate = state->currentsymbolrate;
+	p->symbol_rate = state->currentsymbolrate;
 
 	return 0;
 }
@@ -1014,7 +1014,7 @@ static int cx24123_tune(struct dvb_frontend *fe,
 	int retval = 0;
 
 	if (params != NULL)
-		retval = cx24123_set_frontend(fe, params);
+		retval = cx24123_set_frontend(fe);
 
 	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
 		cx24123_read_status(fe, status);
@@ -1125,7 +1125,7 @@ error:
 EXPORT_SYMBOL(cx24123_attach);
 
 static struct dvb_frontend_ops cx24123_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24123/CX24109",
 		.type = FE_QPSK,
@@ -1145,8 +1145,8 @@ static struct dvb_frontend_ops cx24123_ops = {
 	.release = cx24123_release,
 
 	.init = cx24123_initfe,
-	.set_frontend_legacy = cx24123_set_frontend,
-	.get_frontend_legacy = cx24123_get_frontend,
+	.set_frontend = cx24123_set_frontend,
+	.get_frontend = cx24123_get_frontend,
 	.read_status = cx24123_read_status,
 	.read_ber = cx24123_read_ber,
 	.read_signal_strength = cx24123_read_signal_strength,
-- 
1.7.8.352.g876a6

