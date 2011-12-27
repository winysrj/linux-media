Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1L0BJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:46 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19kVu032689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 36/91] [media] vez1x93: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:24 -0200
Message-Id: <1324948159-23709-37-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-36-git-send-email-mchehab@redhat.com>
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

