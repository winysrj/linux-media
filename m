Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Shm024174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 36/94] [media] vez1x93: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:33 -0200
Message-Id: <1325257711-12274-37-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/ves1x93.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index a95619e..15929c2 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -46,6 +46,7 @@ struct ves1x93_state {
 	u8 *init_1x93_wtab;
 	u8 tab_size;
 	u8 demod_type;
+	u32 frequency;
 };
 
 static int debug;
@@ -384,8 +385,9 @@ static int ves1x93_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int ves1x93_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int ves1x93_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1x93_state* state = fe->demodulator_priv;
 
 	if (fe->ops.tuner_ops.set_params) {
@@ -393,22 +395,24 @@ static int ves1x93_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 	ves1x93_set_inversion (state, p->inversion);
-	ves1x93_set_fec (state, p->u.qpsk.fec_inner);
-	ves1x93_set_symbolrate (state, p->u.qpsk.symbol_rate);
+	ves1x93_set_fec (state, p->fec_inner);
+	ves1x93_set_symbolrate (state, p->symbol_rate);
 	state->inversion = p->inversion;
+	state->frequency = p->frequency;
 
 	return 0;
 }
 
-static int ves1x93_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int ves1x93_get_frontend(struct dvb_frontend* fe,
+				struct dtv_frontend_properties *p)
 {
 	struct ves1x93_state* state = fe->demodulator_priv;
 	int afc;
 
 	afc = ((int)((char)(ves1x93_readreg (state, 0x0a) << 1)))/2;
-	afc = (afc * (int)(p->u.qpsk.symbol_rate/1000/8))/16;
+	afc = (afc * (int)(p->symbol_rate/1000/8))/16;
 
-	p->frequency -= afc;
+	p->frequency = state->frequency - afc;
 
 	/*
 	 * inversion indicator is only valid
@@ -417,7 +421,7 @@ static int ves1x93_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	if (state->inversion == INVERSION_AUTO)
 		p->inversion = (ves1x93_readreg (state, 0x0f) & 2) ?
 				INVERSION_OFF : INVERSION_ON;
-	p->u.qpsk.fec_inner = ves1x93_get_fec (state);
+	p->fec_inner = ves1x93_get_fec (state);
 	/*  XXX FIXME: timing offset !! */
 
 	return 0;
@@ -506,7 +510,7 @@ error:
 }
 
 static struct dvb_frontend_ops ves1x93_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "VLSI VES1x93 DVB-S",
 		.type			= FE_QPSK,
@@ -529,8 +533,8 @@ static struct dvb_frontend_ops ves1x93_ops = {
 	.sleep = ves1x93_sleep,
 	.i2c_gate_ctrl = ves1x93_i2c_gate_ctrl,
 
-	.set_frontend_legacy = ves1x93_set_frontend,
-	.get_frontend_legacy = ves1x93_get_frontend,
+	.set_frontend = ves1x93_set_frontend,
+	.get_frontend = ves1x93_get_frontend,
 
 	.read_status = ves1x93_read_status,
 	.read_ber = ves1x93_read_ber,
-- 
1.7.8.352.g876a6

