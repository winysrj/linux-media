Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1L0BJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:30 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19TVm005438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 10/91] [media] cx24110: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:07:58 -0200
Message-Id: <1324948159-23709-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-10-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/cx24110.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 278034d..6f85bb1 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -531,25 +531,26 @@ static int cx24110_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int cx24110_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int cx24110_set_frontend(struct dvb_frontend* fe)
 {
 	struct cx24110_state *state = fe->demodulator_priv;
-
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	cx24110_set_inversion (state, p->inversion);
-	cx24110_set_fec (state, p->u.qpsk.fec_inner);
-	cx24110_set_symbolrate (state, p->u.qpsk.symbol_rate);
+	cx24110_set_inversion(state, p->inversion);
+	cx24110_set_fec(state, p->fec_inner);
+	cx24110_set_symbolrate(state, p->symbol_rate);
 	cx24110_writereg(state,0x04,0x05); /* start acquisition */
 
 	return 0;
 }
 
-static int cx24110_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int cx24110_get_frontend(struct dvb_frontend* fe,
+				struct dtv_frontend_properties *p)
 {
 	struct cx24110_state *state = fe->demodulator_priv;
 	s32 afc; unsigned sclk;
@@ -571,7 +572,7 @@ static int cx24110_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	p->frequency += afc;
 	p->inversion = (cx24110_readreg (state, 0x22) & 0x10) ?
 				INVERSION_ON : INVERSION_OFF;
-	p->u.qpsk.fec_inner = cx24110_get_fec (state);
+	p->fec_inner = cx24110_get_fec (state);
 
 	return 0;
 }
@@ -623,7 +624,7 @@ error:
 }
 
 static struct dvb_frontend_ops cx24110_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Conexant CX24110 DVB-S",
 		.type = FE_QPSK,
@@ -643,8 +644,8 @@ static struct dvb_frontend_ops cx24110_ops = {
 
 	.init = cx24110_initfe,
 	.write = _cx24110_pll_write,
-	.set_frontend_legacy = cx24110_set_frontend,
-	.get_frontend_legacy = cx24110_get_frontend,
+	.set_frontend = cx24110_set_frontend,
+	.get_frontend = cx24110_get_frontend,
 	.read_status = cx24110_read_status,
 	.read_ber = cx24110_read_ber,
 	.read_signal_strength = cx24110_read_signal_strength,
-- 
1.7.8.352.g876a6

