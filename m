Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1L3PJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:30 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9UYw009135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 55/94] [media] stv0299: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:52 -0200
Message-Id: <1325257711-12274-56-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/stv0299.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 6aeabaf..abf4bff 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -559,8 +559,9 @@ static int stv0299_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int stv0299_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters * p)
+static int stv0299_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0299_state* state = fe->demodulator_priv;
 	int invval = 0;
 
@@ -583,19 +584,19 @@ static int stv0299_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	stv0299_set_FEC (state, p->u.qpsk.fec_inner);
-	stv0299_set_symbolrate (fe, p->u.qpsk.symbol_rate);
+	stv0299_set_FEC (state, p->fec_inner);
+	stv0299_set_symbolrate (fe, p->symbol_rate);
 	stv0299_writeregI(state, 0x22, 0x00);
 	stv0299_writeregI(state, 0x23, 0x00);
 
 	state->tuner_frequency = p->frequency;
-	state->fec_inner = p->u.qpsk.fec_inner;
-	state->symbol_rate = p->u.qpsk.symbol_rate;
+	state->fec_inner = p->fec_inner;
+	state->symbol_rate = p->symbol_rate;
 
 	return 0;
 }
 
-static int stv0299_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters * p)
+static int stv0299_get_frontend(struct dvb_frontend* fe, struct dtv_frontend_properties * p)
 {
 	struct stv0299_state* state = fe->demodulator_priv;
 	s32 derot_freq;
@@ -614,8 +615,8 @@ static int stv0299_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	if (state->config->invert) invval = (~invval) & 1;
 	p->inversion = invval ? INVERSION_ON : INVERSION_OFF;
 
-	p->u.qpsk.fec_inner = stv0299_get_fec (state);
-	p->u.qpsk.symbol_rate = stv0299_get_symbolrate (state);
+	p->fec_inner = stv0299_get_fec (state);
+	p->symbol_rate = stv0299_get_symbolrate (state);
 
 	return 0;
 }
@@ -705,7 +706,7 @@ error:
 }
 
 static struct dvb_frontend_ops stv0299_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0299 DVB-S",
 		.type			= FE_QPSK,
@@ -729,8 +730,8 @@ static struct dvb_frontend_ops stv0299_ops = {
 	.write = stv0299_write,
 	.i2c_gate_ctrl = stv0299_i2c_gate_ctrl,
 
-	.set_frontend_legacy = stv0299_set_frontend,
-	.get_frontend_legacy = stv0299_get_frontend,
+	.set_frontend = stv0299_set_frontend,
+	.get_frontend = stv0299_get_frontend,
 	.get_tune_settings = stv0299_get_tune_settings,
 
 	.read_status = stv0299_read_status,
-- 
1.7.8.352.g876a6

