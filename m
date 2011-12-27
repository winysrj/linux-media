Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1L0BJl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:41 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19fla032659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:41 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 61/91] [media] tda10086: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:49 -0200
Message-Id: <1324948159-23709-62-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-61-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/tda10086.c |   46 ++++++++++++++++----------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index 8501100..81fa57b 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -267,7 +267,7 @@ static int tda10086_send_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t minic
 }
 
 static int tda10086_set_inversion(struct tda10086_state *state,
-				  struct dvb_frontend_parameters *fe_params)
+				  struct dtv_frontend_properties *fe_params)
 {
 	u8 invval = 0x80;
 
@@ -292,7 +292,7 @@ static int tda10086_set_inversion(struct tda10086_state *state,
 }
 
 static int tda10086_set_symbol_rate(struct tda10086_state *state,
-				    struct dvb_frontend_parameters *fe_params)
+				    struct dtv_frontend_properties *fe_params)
 {
 	u8 dfn = 0;
 	u8 afs = 0;
@@ -303,7 +303,7 @@ static int tda10086_set_symbol_rate(struct tda10086_state *state,
 	u32 tmp;
 	u32 bdr;
 	u32 bdri;
-	u32 symbol_rate = fe_params->u.qpsk.symbol_rate;
+	u32 symbol_rate = fe_params->symbol_rate;
 
 	dprintk ("%s %i\n", __func__, symbol_rate);
 
@@ -367,13 +367,13 @@ static int tda10086_set_symbol_rate(struct tda10086_state *state,
 }
 
 static int tda10086_set_fec(struct tda10086_state *state,
-			    struct dvb_frontend_parameters *fe_params)
+			    struct dtv_frontend_properties *fe_params)
 {
 	u8 fecval;
 
-	dprintk ("%s %i\n", __func__, fe_params->u.qpsk.fec_inner);
+	dprintk ("%s %i\n", __func__, fe_params->fec_inner);
 
-	switch(fe_params->u.qpsk.fec_inner) {
+	switch(fe_params->fec_inner) {
 	case FEC_1_2:
 		fecval = 0x00;
 		break;
@@ -409,9 +409,9 @@ static int tda10086_set_fec(struct tda10086_state *state,
 	return 0;
 }
 
-static int tda10086_set_frontend(struct dvb_frontend* fe,
-				 struct dvb_frontend_parameters *fe_params)
+static int tda10086_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fe_params = &fe->dtv_property_cache;
 	struct tda10086_state *state = fe->demodulator_priv;
 	int ret;
 	u32 freq = 0;
@@ -452,12 +452,12 @@ static int tda10086_set_frontend(struct dvb_frontend* fe,
 	tda10086_write_mask(state, 0x10, 0x40, 0x40);
 	tda10086_write_mask(state, 0x00, 0x01, 0x00);
 
-	state->symbol_rate = fe_params->u.qpsk.symbol_rate;
+	state->symbol_rate = fe_params->symbol_rate;
 	state->frequency = fe_params->frequency;
 	return 0;
 }
 
-static int tda10086_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *fe_params)
+static int tda10086_get_frontend(struct dvb_frontend* fe, struct dtv_frontend_properties *fe_params)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 val;
@@ -467,7 +467,7 @@ static int tda10086_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 	dprintk ("%s\n", __func__);
 
 	/* check for invalid symbol rate */
-	if (fe_params->u.qpsk.symbol_rate < 500000)
+	if (fe_params->symbol_rate < 500000)
 		return -EINVAL;
 
 	/* calculate the updated frequency (note: we convert from Hz->kHz) */
@@ -516,34 +516,34 @@ static int tda10086_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 		tmp |= 0xffffff00;
 	tmp = (tmp * 480 * (1<<1)) / 128;
 	tmp = ((state->symbol_rate/1000) * tmp) / (1000000/1000);
-	fe_params->u.qpsk.symbol_rate = state->symbol_rate + tmp;
+	fe_params->symbol_rate = state->symbol_rate + tmp;
 
 	/* the FEC */
 	val = (tda10086_read_byte(state, 0x0d) & 0x70) >> 4;
 	switch(val) {
 	case 0x00:
-		fe_params->u.qpsk.fec_inner = FEC_1_2;
+		fe_params->fec_inner = FEC_1_2;
 		break;
 	case 0x01:
-		fe_params->u.qpsk.fec_inner = FEC_2_3;
+		fe_params->fec_inner = FEC_2_3;
 		break;
 	case 0x02:
-		fe_params->u.qpsk.fec_inner = FEC_3_4;
+		fe_params->fec_inner = FEC_3_4;
 		break;
 	case 0x03:
-		fe_params->u.qpsk.fec_inner = FEC_4_5;
+		fe_params->fec_inner = FEC_4_5;
 		break;
 	case 0x04:
-		fe_params->u.qpsk.fec_inner = FEC_5_6;
+		fe_params->fec_inner = FEC_5_6;
 		break;
 	case 0x05:
-		fe_params->u.qpsk.fec_inner = FEC_6_7;
+		fe_params->fec_inner = FEC_6_7;
 		break;
 	case 0x06:
-		fe_params->u.qpsk.fec_inner = FEC_7_8;
+		fe_params->fec_inner = FEC_7_8;
 		break;
 	case 0x07:
-		fe_params->u.qpsk.fec_inner = FEC_8_9;
+		fe_params->fec_inner = FEC_8_9;
 		break;
 	}
 
@@ -701,7 +701,7 @@ static void tda10086_release(struct dvb_frontend* fe)
 }
 
 static struct dvb_frontend_ops tda10086_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name     = "Philips TDA10086 DVB-S",
 		.type     = FE_QPSK,
@@ -722,8 +722,8 @@ static struct dvb_frontend_ops tda10086_ops = {
 	.sleep = tda10086_sleep,
 	.i2c_gate_ctrl = tda10086_i2c_gate_ctrl,
 
-	.set_frontend_legacy = tda10086_set_frontend,
-	.get_frontend_legacy = tda10086_get_frontend,
+	.set_frontend = tda10086_set_frontend,
+	.get_frontend = tda10086_get_frontend,
 	.get_tune_settings = tda10086_get_tune_settings,
 
 	.read_status = tda10086_read_status,
-- 
1.7.8.352.g876a6

