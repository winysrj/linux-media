Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab1L0BJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:50 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19oIt017958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:50 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 58/91] [media] tda10021: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:46 -0200
Message-Id: <1324948159-23709-59-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-58-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda10021.c |   37 ++++++++-----------------------
 1 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 3976d22..c8ab01b 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -228,8 +228,7 @@ struct qam_params {
 	u8 conf, agcref, lthr, mseth, aref;
 };
 
-static int tda10021_set_parameters (struct dvb_frontend *fe,
-			    struct dvb_frontend_parameters *p)
+static int tda10021_set_parameters (struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys  = c->delivery_system;
@@ -280,7 +279,7 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 	if (c->inversion != INVERSION_ON && c->inversion != INVERSION_OFF)
 		return -EINVAL;
 
-	//printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->u.qam.symbol_rate);
+	//printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->symbol_rate);
 
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
@@ -387,7 +386,7 @@ static int tda10021_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda10021_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int tda10021_get_frontend(struct dvb_frontend* fe, struct dtv_frontend_properties *p)
 {
 	struct tda10021_state* state = fe->demodulator_priv;
 	int sync;
@@ -400,17 +399,17 @@ static int tda10021_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 		printk(sync & 2 ? "DVB: TDA10021(%d): AFC (%d) %dHz\n" :
 				  "DVB: TDA10021(%d): [AFC (%d) %dHz]\n",
 			state->frontend.dvb->num, afc,
-		       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		       -((s32)p->symbol_rate * afc) >> 10);
 	}
 
 	p->inversion = ((state->reg0 & 0x20) == 0x20) ^ (state->config->invert != 0) ? INVERSION_ON : INVERSION_OFF;
-	p->u.qam.modulation = ((state->reg0 >> 2) & 7) + QAM_16;
+	p->modulation = ((state->reg0 >> 2) & 7) + QAM_16;
 
-	p->u.qam.fec_inner = FEC_NONE;
+	p->fec_inner = FEC_NONE;
 	p->frequency = ((p->frequency + 31250) / 62500) * 62500;
 
 	if (sync & 2)
-		p->frequency -= ((s32)p->u.qam.symbol_rate * afc) >> 10;
+		p->frequency -= ((s32)p->symbol_rate * afc) >> 10;
 
 	return 0;
 }
@@ -483,23 +482,8 @@ error:
 	return NULL;
 }
 
-static int tda10021_get_property(struct dvb_frontend *fe,
-				 struct dtv_property *p)
-{
-	switch (p->cmd) {
-	case DTV_ENUM_DELSYS:
-		p->u.buffer.data[0] = SYS_DVBC_ANNEX_A;
-		p->u.buffer.data[1] = SYS_DVBC_ANNEX_C;
-		p->u.buffer.len = 2;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 static struct dvb_frontend_ops tda10021_ops = {
-
+	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10021 DVB-C",
 		.type = FE_QAM,
@@ -524,9 +508,8 @@ static struct dvb_frontend_ops tda10021_ops = {
 	.sleep = tda10021_sleep,
 	.i2c_gate_ctrl = tda10021_i2c_gate_ctrl,
 
-	.set_frontend_legacy = tda10021_set_parameters,
-	.get_frontend_legacy = tda10021_get_frontend,
-	.get_property = tda10021_get_property,
+	.set_frontend = tda10021_set_parameters,
+	.get_frontend = tda10021_get_frontend,
 
 	.read_status = tda10021_read_status,
 	.read_ber = tda10021_read_ber,
-- 
1.7.8.352.g876a6

