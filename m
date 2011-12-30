Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9ViU015926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 68/94] [media] vez1820: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:05 -0200
Message-Id: <1325257711-12274-69-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/ves1820.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 7961231..ef1b5fe 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -205,15 +205,16 @@ static int ves1820_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int ves1820_set_parameters(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int ves1820_set_parameters(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ves1820_state* state = fe->demodulator_priv;
 	static const u8 reg0x00[] = { 0x00, 0x04, 0x08, 0x0c, 0x10 };
 	static const u8 reg0x01[] = { 140, 140, 106, 100, 92 };
 	static const u8 reg0x05[] = { 135, 100, 70, 54, 38 };
 	static const u8 reg0x08[] = { 162, 116, 67, 52, 35 };
 	static const u8 reg0x09[] = { 145, 150, 106, 126, 107 };
-	int real_qam = p->u.qam.modulation - QAM_16;
+	int real_qam = p->modulation - QAM_16;
 
 	if (real_qam < 0 || real_qam > 4)
 		return -EINVAL;
@@ -223,7 +224,7 @@ static int ves1820_set_parameters(struct dvb_frontend* fe, struct dvb_frontend_p
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	ves1820_set_symbolrate(state, p->u.qam.symbol_rate);
+	ves1820_set_symbolrate(state, p->symbol_rate);
 	ves1820_writereg(state, 0x34, state->pwm);
 
 	ves1820_writereg(state, 0x01, reg0x01[real_qam]);
@@ -309,7 +310,7 @@ static int ves1820_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int ves1820_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int ves1820_get_frontend(struct dvb_frontend* fe, struct dtv_frontend_properties *p)
 {
 	struct ves1820_state* state = fe->demodulator_priv;
 	int sync;
@@ -320,7 +321,7 @@ static int ves1820_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	if (verbose) {
 		/* AFC only valid when carrier has been recovered */
 		printk(sync & 2 ? "ves1820: AFC (%d) %dHz\n" :
-			"ves1820: [AFC (%d) %dHz]\n", afc, -((s32) p->u.qam.symbol_rate * afc) >> 10);
+			"ves1820: [AFC (%d) %dHz]\n", afc, -((s32) p->symbol_rate * afc) >> 10);
 	}
 
 	if (!state->config->invert) {
@@ -329,13 +330,13 @@ static int ves1820_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 		p->inversion = (!(state->reg0 & 0x20)) ? INVERSION_ON : INVERSION_OFF;
 	}
 
-	p->u.qam.modulation = ((state->reg0 >> 2) & 7) + QAM_16;
+	p->modulation = ((state->reg0 >> 2) & 7) + QAM_16;
 
-	p->u.qam.fec_inner = FEC_NONE;
+	p->fec_inner = FEC_NONE;
 
 	p->frequency = ((p->frequency + 31250) / 62500) * 62500;
 	if (sync & 2)
-		p->frequency -= ((s32) p->u.qam.symbol_rate * afc) >> 10;
+		p->frequency -= ((s32) p->symbol_rate * afc) >> 10;
 
 	return 0;
 }
@@ -405,7 +406,7 @@ error:
 }
 
 static struct dvb_frontend_ops ves1820_ops = {
-
+	.delsys = { SYS_DVBC_ANNEX_A },
 	.info = {
 		.name = "VLSI VES1820 DVB-C",
 		.type = FE_QAM,
@@ -425,8 +426,8 @@ static struct dvb_frontend_ops ves1820_ops = {
 	.init = ves1820_init,
 	.sleep = ves1820_sleep,
 
-	.set_frontend_legacy = ves1820_set_parameters,
-	.get_frontend_legacy = ves1820_get_frontend,
+	.set_frontend = ves1820_set_parameters,
+	.get_frontend = ves1820_get_frontend,
 	.get_tune_settings = ves1820_get_tune_settings,
 
 	.read_status = ves1820_read_status,
-- 
1.7.8.352.g876a6

