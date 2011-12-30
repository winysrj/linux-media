Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9U14024210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 59/94] [media] tda10023: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:56 -0200
Message-Id: <1325257711-12274-60-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda10023.c |   35 ++++++++-----------------------
 1 files changed, 9 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index de535a4..8f451dc 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -302,8 +302,7 @@ struct qam_params {
 	u8 qam, lockthr, mseth, aref, agcrefnyq, eragnyq_thd;
 };
 
-static int tda10023_set_parameters (struct dvb_frontend *fe,
-			    struct dvb_frontend_parameters *p)
+static int tda10023_set_parameters (struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u32 delsys  = c->delivery_system;
@@ -377,21 +376,6 @@ static int tda10023_set_parameters (struct dvb_frontend *fe,
 	return 0;
 }
 
-static int tda10023_get_property(struct dvb_frontend *fe,
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
 static int tda10023_read_status(struct dvb_frontend* fe, fe_status_t* status)
 {
 	struct tda10023_state* state = fe->demodulator_priv;
@@ -472,7 +456,7 @@ static int tda10023_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int tda10023_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int tda10023_get_frontend(struct dvb_frontend* fe, struct dtv_frontend_properties *p)
 {
 	struct tda10023_state* state = fe->demodulator_priv;
 	int sync,inv;
@@ -487,17 +471,17 @@ static int tda10023_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 		printk(sync & 2 ? "DVB: TDA10023(%d): AFC (%d) %dHz\n" :
 				  "DVB: TDA10023(%d): [AFC (%d) %dHz]\n",
 			state->frontend.dvb->num, afc,
-		       -((s32)p->u.qam.symbol_rate * afc) >> 10);
+		       -((s32)p->symbol_rate * afc) >> 10);
 	}
 
 	p->inversion = (inv&0x20?0:1);
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
@@ -588,7 +572,7 @@ error:
 }
 
 static struct dvb_frontend_ops tda10023_ops = {
-
+	.delsys = { SYS_DVBC_ANNEX_A, SYS_DVBC_ANNEX_C },
 	.info = {
 		.name = "Philips TDA10023 DVB-C",
 		.type = FE_QAM,
@@ -609,9 +593,8 @@ static struct dvb_frontend_ops tda10023_ops = {
 	.sleep = tda10023_sleep,
 	.i2c_gate_ctrl = tda10023_i2c_gate_ctrl,
 
-	.set_frontend_legacy = tda10023_set_parameters,
-	.get_frontend_legacy = tda10023_get_frontend,
-	.get_property = tda10023_get_property,
+	.set_frontend = tda10023_set_parameters,
+	.get_frontend = tda10023_get_frontend,
 	.read_status = tda10023_read_status,
 	.read_ber = tda10023_read_ber,
 	.read_signal_strength = tda10023_read_signal_strength,
-- 
1.7.8.352.g876a6

