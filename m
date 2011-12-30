Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9S0I009115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 33/94] [media] lgdt330x: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:30 -0200
Message-Id: <1325257711-12274-34-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/lgdt330x.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index 21bffc0..f117eeb 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -307,9 +307,9 @@ static int lgdt330x_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int lgdt330x_set_parameters(struct dvb_frontend* fe,
-				   struct dvb_frontend_parameters *param)
+static int lgdt330x_set_parameters(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	/*
 	 * Array of byte pairs <address, value>
 	 * to initialize 8VSB for lgdt3303 chip 50 MHz IF
@@ -345,8 +345,8 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 
 	int err;
 	/* Change only if we are actually changing the modulation */
-	if (state->current_modulation != param->u.vsb.modulation) {
-		switch(param->u.vsb.modulation) {
+	if (state->current_modulation != p->modulation) {
+		switch(p->modulation) {
 		case VSB_8:
 			dprintk("%s: VSB_8 MODE\n", __func__);
 
@@ -395,7 +395,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 			}
 			break;
 		default:
-			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __func__, param->u.vsb.modulation);
+			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __func__, p->modulation);
 			return -1;
 		}
 		/*
@@ -410,7 +410,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 				      sizeof(top_ctrl_cfg));
 		if (state->config->set_ts_params)
 			state->config->set_ts_params(fe, 0);
-		state->current_modulation = param->u.vsb.modulation;
+		state->current_modulation = p->modulation;
 	}
 
 	/* Tune to the specified frequency */
@@ -422,17 +422,17 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 	/* Keep track of the new frequency */
 	/* FIXME this is the wrong way to do this...           */
 	/* The tuner is shared with the video4linux analog API */
-	state->current_frequency = param->frequency;
+	state->current_frequency = p->frequency;
 
 	lgdt330x_SwReset(state);
 	return 0;
 }
 
-static int lgdt330x_get_frontend(struct dvb_frontend* fe,
-				 struct dvb_frontend_parameters* param)
+static int lgdt330x_get_frontend(struct dvb_frontend *fe,
+				 struct dtv_frontend_properties *p)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
-	param->frequency = state->current_frequency;
+	p->frequency = state->current_frequency;
 	return 0;
 }
 
@@ -762,6 +762,7 @@ error:
 }
 
 static struct dvb_frontend_ops lgdt3302_ops = {
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name= "LG Electronics LGDT3302 VSB/QAM Frontend",
 		.type = FE_ATSC,
@@ -773,8 +774,8 @@ static struct dvb_frontend_ops lgdt3302_ops = {
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.init                 = lgdt330x_init,
-	.set_frontend_legacy         = lgdt330x_set_parameters,
-	.get_frontend_legacy = lgdt330x_get_frontend,
+	.set_frontend         = lgdt330x_set_parameters,
+	.get_frontend         = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3302_read_status,
 	.read_ber             = lgdt330x_read_ber,
@@ -785,6 +786,7 @@ static struct dvb_frontend_ops lgdt3302_ops = {
 };
 
 static struct dvb_frontend_ops lgdt3303_ops = {
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name= "LG Electronics LGDT3303 VSB/QAM Frontend",
 		.type = FE_ATSC,
@@ -796,8 +798,8 @@ static struct dvb_frontend_ops lgdt3303_ops = {
 		.caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
 	},
 	.init                 = lgdt330x_init,
-	.set_frontend_legacy         = lgdt330x_set_parameters,
-	.get_frontend_legacy = lgdt330x_get_frontend,
+	.set_frontend         = lgdt330x_set_parameters,
+	.get_frontend         = lgdt330x_get_frontend,
 	.get_tune_settings    = lgdt330x_get_tune_settings,
 	.read_status          = lgdt3303_read_status,
 	.read_ber             = lgdt330x_read_ber,
-- 
1.7.8.352.g876a6

