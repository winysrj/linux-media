Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9UHi009149
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 63/94] [media] or51132: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:00 -0200
Message-Id: <1325257711-12274-64-git-send-email-mchehab@redhat.com>
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

