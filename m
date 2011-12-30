Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab1L3PJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:30 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9USo009137
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 49/94] [media] s5h1420: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:46 -0200
Message-Id: <1325257711-12274-50-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/s5h1420.c |   54 ++++++++++++++++----------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 44ec27d..3bdfcbe 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -472,15 +472,15 @@ static void s5h1420_reset(struct s5h1420_state* state)
 }
 
 static void s5h1420_setsymbolrate(struct s5h1420_state* state,
-				  struct dvb_frontend_parameters *p)
+				  struct dtv_frontend_properties *p)
 {
 	u8 v;
 	u64 val;
 
 	dprintk("enter %s\n", __func__);
 
-	val = ((u64) p->u.qpsk.symbol_rate / 1000ULL) * (1ULL<<24);
-	if (p->u.qpsk.symbol_rate < 29000000)
+	val = ((u64) p->symbol_rate / 1000ULL) * (1ULL<<24);
+	if (p->symbol_rate < 29000000)
 		val *= 2;
 	do_div(val, (state->fclk / 1000));
 
@@ -543,7 +543,7 @@ static int s5h1420_getfreqoffset(struct s5h1420_state* state)
 }
 
 static void s5h1420_setfec_inversion(struct s5h1420_state* state,
-				     struct dvb_frontend_parameters *p)
+				     struct dtv_frontend_properties *p)
 {
 	u8 inversion = 0;
 	u8 vit08, vit09;
@@ -555,11 +555,11 @@ static void s5h1420_setfec_inversion(struct s5h1420_state* state,
 	else if (p->inversion == INVERSION_ON)
 		inversion = state->config->invert ? 0 : 0x08;
 
-	if ((p->u.qpsk.fec_inner == FEC_AUTO) || (p->inversion == INVERSION_AUTO)) {
+	if ((p->fec_inner == FEC_AUTO) || (p->inversion == INVERSION_AUTO)) {
 		vit08 = 0x3f;
 		vit09 = 0;
 	} else {
-		switch(p->u.qpsk.fec_inner) {
+		switch(p->fec_inner) {
 		case FEC_1_2:
 			vit08 = 0x01; vit09 = 0x10;
 			break;
@@ -628,9 +628,9 @@ static fe_spectral_inversion_t s5h1420_getinversion(struct s5h1420_state* state)
 	return INVERSION_OFF;
 }
 
-static int s5h1420_set_frontend(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *p)
+static int s5h1420_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s5h1420_state* state = fe->demodulator_priv;
 	int frequency_delta;
 	struct dvb_frontend_tune_settings fesettings;
@@ -639,14 +639,14 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	dprintk("enter %s\n", __func__);
 
 	/* check if we should do a fast-tune */
-	memcpy(&fesettings.parameters, p, sizeof(struct dvb_frontend_parameters));
+	memcpy(&fesettings.parameters, p, sizeof(struct dtv_frontend_properties));
 	s5h1420_get_tune_settings(fe, &fesettings);
 	frequency_delta = p->frequency - state->tunedfreq;
 	if ((frequency_delta > -fesettings.max_drift) &&
 			(frequency_delta < fesettings.max_drift) &&
 			(frequency_delta != 0) &&
-			(state->fec_inner == p->u.qpsk.fec_inner) &&
-			(state->symbol_rate == p->u.qpsk.symbol_rate)) {
+			(state->fec_inner == p->fec_inner) &&
+			(state->symbol_rate == p->symbol_rate)) {
 
 		if (fe->ops.tuner_ops.set_params) {
 			fe->ops.tuner_ops.set_params(fe);
@@ -669,13 +669,13 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	s5h1420_reset(state);
 
 	/* set s5h1420 fclk PLL according to desired symbol rate */
-	if (p->u.qpsk.symbol_rate > 33000000)
+	if (p->symbol_rate > 33000000)
 		state->fclk = 80000000;
-	else if (p->u.qpsk.symbol_rate > 28500000)
+	else if (p->symbol_rate > 28500000)
 		state->fclk = 59000000;
-	else if (p->u.qpsk.symbol_rate > 25000000)
+	else if (p->symbol_rate > 25000000)
 		state->fclk = 86000000;
-	else if (p->u.qpsk.symbol_rate > 1900000)
+	else if (p->symbol_rate > 1900000)
 		state->fclk = 88000000;
 	else
 		state->fclk = 44000000;
@@ -705,7 +705,7 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	s5h1420_writereg(state, DiS01, (state->fclk + (TONE_FREQ * 32) - 1) / (TONE_FREQ * 32));
 
 	/* TODO DC offset removal, config parameter ? */
-	if (p->u.qpsk.symbol_rate > 29000000)
+	if (p->symbol_rate > 29000000)
 		s5h1420_writereg(state, QPSK01, 0xae | 0x10);
 	else
 		s5h1420_writereg(state, QPSK01, 0xac | 0x10);
@@ -718,15 +718,15 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	s5h1420_writereg(state, Loop01, 0xF0);
 	s5h1420_writereg(state, Loop02, 0x2a); /* e7 for s5h1420 */
 	s5h1420_writereg(state, Loop03, 0x79); /* 78 for s5h1420 */
-	if (p->u.qpsk.symbol_rate > 20000000)
+	if (p->symbol_rate > 20000000)
 		s5h1420_writereg(state, Loop04, 0x79);
 	else
 		s5h1420_writereg(state, Loop04, 0x58);
 	s5h1420_writereg(state, Loop05, 0x6b);
 
-	if (p->u.qpsk.symbol_rate >= 8000000)
+	if (p->symbol_rate >= 8000000)
 		s5h1420_writereg(state, Post01, (0 << 6) | 0x10);
-	else if (p->u.qpsk.symbol_rate >= 4000000)
+	else if (p->symbol_rate >= 4000000)
 		s5h1420_writereg(state, Post01, (1 << 6) | 0x10);
 	else
 		s5h1420_writereg(state, Post01, (3 << 6) | 0x10);
@@ -757,8 +757,8 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 	/* start QPSK */
 	s5h1420_writereg(state, QPSK01, s5h1420_readreg(state, QPSK01) | 1);
 
-	state->fec_inner = p->u.qpsk.fec_inner;
-	state->symbol_rate = p->u.qpsk.symbol_rate;
+	state->fec_inner = p->fec_inner;
+	state->symbol_rate = p->symbol_rate;
 	state->postlocked = 0;
 	state->tunedfreq = p->frequency;
 
@@ -767,14 +767,14 @@ static int s5h1420_set_frontend(struct dvb_frontend* fe,
 }
 
 static int s5h1420_get_frontend(struct dvb_frontend* fe,
-				struct dvb_frontend_parameters *p)
+				struct dtv_frontend_properties *p)
 {
 	struct s5h1420_state* state = fe->demodulator_priv;
 
 	p->frequency = state->tunedfreq + s5h1420_getfreqoffset(state);
 	p->inversion = s5h1420_getinversion(state);
-	p->u.qpsk.symbol_rate = s5h1420_getsymbolrate(state);
-	p->u.qpsk.fec_inner = s5h1420_getfec(state);
+	p->symbol_rate = s5h1420_getsymbolrate(state);
+	p->fec_inner = s5h1420_getfec(state);
 
 	return 0;
 }
@@ -937,7 +937,7 @@ error:
 EXPORT_SYMBOL(s5h1420_attach);
 
 static struct dvb_frontend_ops s5h1420_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Samsung S5H1420/PnpNetwork PN1010 DVB-S",
 		.type     = FE_QPSK,
@@ -960,8 +960,8 @@ static struct dvb_frontend_ops s5h1420_ops = {
 	.sleep = s5h1420_sleep,
 	.i2c_gate_ctrl = s5h1420_i2c_gate_ctrl,
 
-	.set_frontend_legacy = s5h1420_set_frontend,
-	.get_frontend_legacy = s5h1420_get_frontend,
+	.set_frontend = s5h1420_set_frontend,
+	.get_frontend = s5h1420_get_frontend,
 	.get_tune_settings = s5h1420_get_tune_settings,
 
 	.read_status = s5h1420_read_status,
-- 
1.7.8.352.g876a6

