Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1L0BJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:37 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19bh2032633
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 63/91] [media] or51132: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:51 -0200
Message-Id: <1324948159-23709-64-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-63-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/or51132.c |   34 ++++++++++++++++----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index e0c952c..2d9e81b 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -306,9 +306,9 @@ static int modulation_fw_class(fe_modulation_t modulation)
 	}
 }
 
-static int or51132_set_parameters(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *param)
+static int or51132_set_parameters(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int ret;
 	struct or51132_state* state = fe->demodulator_priv;
 	const struct firmware *fw;
@@ -317,8 +317,8 @@ static int or51132_set_parameters(struct dvb_frontend* fe,
 
 	/* Upload new firmware only if we need a different one */
 	if (modulation_fw_class(state->current_modulation) !=
-	    modulation_fw_class(param->u.vsb.modulation)) {
-		switch(modulation_fw_class(param->u.vsb.modulation)) {
+	    modulation_fw_class(p->modulation)) {
+		switch(modulation_fw_class(p->modulation)) {
 		case MOD_FWCLASS_VSB:
 			dprintk("set_parameters VSB MODE\n");
 			fwname = OR51132_VSB_FIRMWARE;
@@ -335,7 +335,7 @@ static int or51132_set_parameters(struct dvb_frontend* fe,
 			break;
 		default:
 			printk("or51132: Modulation type(%d) UNSUPPORTED\n",
-			       param->u.vsb.modulation);
+			       p->modulation);
 			return -1;
 		}
 		printk("or51132: Waiting for firmware upload(%s)...\n",
@@ -357,8 +357,8 @@ static int or51132_set_parameters(struct dvb_frontend* fe,
 		state->config->set_ts_params(fe, clock_mode);
 	}
 	/* Change only if we are actually changing the modulation */
-	if (state->current_modulation != param->u.vsb.modulation) {
-		state->current_modulation = param->u.vsb.modulation;
+	if (state->current_modulation != p->modulation) {
+		state->current_modulation = p->modulation;
 		or51132_setmode(fe);
 	}
 
@@ -371,12 +371,12 @@ static int or51132_set_parameters(struct dvb_frontend* fe,
 	or51132_setmode(fe);
 
 	/* Update current frequency */
-	state->current_frequency = param->frequency;
+	state->current_frequency = p->frequency;
 	return 0;
 }
 
 static int or51132_get_parameters(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *param)
+				  struct dtv_frontend_properties *p)
 {
 	struct or51132_state* state = fe->demodulator_priv;
 	int status;
@@ -389,9 +389,9 @@ start:
 		return -EREMOTEIO;
 	}
 	switch(status&0xff) {
-		case 0x06: param->u.vsb.modulation = VSB_8; break;
-		case 0x43: param->u.vsb.modulation = QAM_64; break;
-		case 0x45: param->u.vsb.modulation = QAM_256; break;
+		case 0x06: p->modulation = VSB_8; break;
+		case 0x43: p->modulation = QAM_64; break;
+		case 0x45: p->modulation = QAM_256; break;
 		default:
 			if (retry--) goto start;
 			printk(KERN_WARNING "or51132: unknown status 0x%02x\n",
@@ -400,10 +400,10 @@ start:
 	}
 
 	/* FIXME: Read frequency from frontend, take AFC into account */
-	param->frequency = state->current_frequency;
+	p->frequency = state->current_frequency;
 
 	/* FIXME: How to read inversion setting? Receiver 6 register? */
-	param->inversion = INVERSION_AUTO;
+	p->inversion = INVERSION_AUTO;
 
 	return 0;
 }
@@ -579,7 +579,7 @@ struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 }
 
 static struct dvb_frontend_ops or51132_ops = {
-
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Oren OR51132 VSB/QAM Frontend",
 		.type			= FE_ATSC,
@@ -597,8 +597,8 @@ static struct dvb_frontend_ops or51132_ops = {
 	.init = or51132_init,
 	.sleep = or51132_sleep,
 
-	.set_frontend_legacy = or51132_set_parameters,
-	.get_frontend_legacy = or51132_get_parameters,
+	.set_frontend = or51132_set_parameters,
+	.get_frontend = or51132_get_parameters,
 	.get_tune_settings = or51132_get_tune_settings,
 
 	.read_status = or51132_read_status,
-- 
1.7.8.352.g876a6

