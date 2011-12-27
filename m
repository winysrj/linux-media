Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab1L0BJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:44 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19iKm017920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 55/91] [media] stv0299: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:43 -0200
Message-Id: <1324948159-23709-56-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-55-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
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

