Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559Ab1L0BJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:38 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19b2H005475
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 06/91] [media] au8522_dig: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:07:54 -0200
Message-Id: <1324948159-23709-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-6-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/au8522_dig.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_dig.c b/drivers/media/dvb/frontends/au8522_dig.c
index 327d6fe..027d45d 100644
--- a/drivers/media/dvb/frontends/au8522_dig.c
+++ b/drivers/media/dvb/frontends/au8522_dig.c
@@ -576,19 +576,19 @@ static int au8522_enable_modulation(struct dvb_frontend *fe,
 }
 
 /* Talk to the demod, set the FEC, GUARD, QAM settings etc */
-static int au8522_set_frontend(struct dvb_frontend *fe,
-			       struct dvb_frontend_parameters *p)
+static int au8522_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct au8522_state *state = fe->demodulator_priv;
 	int ret = -EINVAL;
 
-	dprintk("%s(frequency=%d)\n", __func__, p->frequency);
+	dprintk("%s(frequency=%d)\n", __func__, c->frequency);
 
-	if ((state->current_frequency == p->frequency) &&
-	    (state->current_modulation == p->u.vsb.modulation))
+	if ((state->current_frequency == c->frequency) &&
+	    (state->current_modulation == c->modulation))
 		return 0;
 
-	au8522_enable_modulation(fe, p->u.vsb.modulation);
+	au8522_enable_modulation(fe, c->modulation);
 
 	/* Allow the demod to settle */
 	msleep(100);
@@ -604,7 +604,7 @@ static int au8522_set_frontend(struct dvb_frontend *fe,
 	if (ret < 0)
 		return ret;
 
-	state->current_frequency = p->frequency;
+	state->current_frequency = c->frequency;
 
 	return 0;
 }
@@ -912,12 +912,12 @@ static int au8522_read_ber(struct dvb_frontend *fe, u32 *ber)
 }
 
 static int au8522_get_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *p)
+			       struct dtv_frontend_properties *c)
 {
 	struct au8522_state *state = fe->demodulator_priv;
 
-	p->frequency = state->current_frequency;
-	p->u.vsb.modulation = state->current_modulation;
+	c->frequency = state->current_frequency;
+	c->modulation = state->current_modulation;
 
 	return 0;
 }
@@ -1010,7 +1010,7 @@ error:
 EXPORT_SYMBOL(au8522_attach);
 
 static struct dvb_frontend_ops au8522_ops = {
-
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Auvitek AU8522 QAM/8VSB Frontend",
 		.type			= FE_ATSC,
@@ -1023,8 +1023,8 @@ static struct dvb_frontend_ops au8522_ops = {
 	.init                 = au8522_init,
 	.sleep                = au8522_sleep,
 	.i2c_gate_ctrl        = au8522_i2c_gate_ctrl,
-	.set_frontend_legacy         = au8522_set_frontend,
-	.get_frontend_legacy = au8522_get_frontend,
+	.set_frontend         = au8522_set_frontend,
+	.get_frontend         = au8522_get_frontend,
 	.get_tune_settings    = au8522_get_tune_settings,
 	.read_status          = au8522_read_status,
 	.read_ber             = au8522_read_ber,
-- 
1.7.8.352.g876a6

