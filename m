Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9VTl024217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 66/94] [media] s55h1411: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:03 -0200
Message-Id: <1325257711-12274-67-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/s5h1411.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/s5h1411.c b/drivers/media/dvb/frontends/s5h1411.c
index cb221aa..08f568c 100644
--- a/drivers/media/dvb/frontends/s5h1411.c
+++ b/drivers/media/dvb/frontends/s5h1411.c
@@ -585,9 +585,9 @@ static int s5h1411_register_reset(struct dvb_frontend *fe)
 }
 
 /* Talk to the demod, set the FEC, GUARD, QAM settings etc */
-static int s5h1411_set_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int s5h1411_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct s5h1411_state *state = fe->demodulator_priv;
 
 	dprintk("%s(frequency=%d)\n", __func__, p->frequency);
@@ -596,7 +596,7 @@ static int s5h1411_set_frontend(struct dvb_frontend *fe,
 
 	state->current_frequency = p->frequency;
 
-	s5h1411_enable_modulation(fe, p->u.vsb.modulation);
+	s5h1411_enable_modulation(fe, p->modulation);
 
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
@@ -841,12 +841,12 @@ static int s5h1411_read_ber(struct dvb_frontend *fe, u32 *ber)
 }
 
 static int s5h1411_get_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *p)
+				struct dtv_frontend_properties *p)
 {
 	struct s5h1411_state *state = fe->demodulator_priv;
 
 	p->frequency = state->current_frequency;
-	p->u.vsb.modulation = state->current_modulation;
+	p->modulation = state->current_modulation;
 
 	return 0;
 }
@@ -915,7 +915,7 @@ error:
 EXPORT_SYMBOL(s5h1411_attach);
 
 static struct dvb_frontend_ops s5h1411_ops = {
-
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name			= "Samsung S5H1411 QAM/8VSB Frontend",
 		.type			= FE_ATSC,
@@ -928,8 +928,8 @@ static struct dvb_frontend_ops s5h1411_ops = {
 	.init                 = s5h1411_init,
 	.sleep                = s5h1411_sleep,
 	.i2c_gate_ctrl        = s5h1411_i2c_gate_ctrl,
-	.set_frontend_legacy         = s5h1411_set_frontend,
-	.get_frontend_legacy = s5h1411_get_frontend,
+	.set_frontend         = s5h1411_set_frontend,
+	.get_frontend         = s5h1411_get_frontend,
 	.get_tune_settings    = s5h1411_get_tune_settings,
 	.read_status          = s5h1411_read_status,
 	.read_ber             = s5h1411_read_ber,
-- 
1.7.8.352.g876a6

