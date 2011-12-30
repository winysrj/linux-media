Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Rk9009113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 32/94] [media] lgs8gl5: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:29 -0200
Message-Id: <1325257711-12274-33-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/lgs8gl5.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb/frontends/lgs8gl5.c
index f4e82a6..0f4bc16 100644
--- a/drivers/media/dvb/frontends/lgs8gl5.c
+++ b/drivers/media/dvb/frontends/lgs8gl5.c
@@ -311,14 +311,14 @@ lgs8gl5_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 
 static int
-lgs8gl5_set_frontend(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *p)
+lgs8gl5_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct lgs8gl5_state *state = fe->demodulator_priv;
 
 	dprintk("%s\n", __func__);
 
-	if (p->u.ofdm.bandwidth != BANDWIDTH_8_MHZ)
+	if (p->bandwidth_hz != 8000000)
 		return -EINVAL;
 
 	if (fe->ops.tuner_ops.set_params) {
@@ -337,21 +337,20 @@ lgs8gl5_set_frontend(struct dvb_frontend *fe,
 
 static int
 lgs8gl5_get_frontend(struct dvb_frontend *fe,
-		struct dvb_frontend_parameters *p)
+		struct dtv_frontend_properties *p)
 {
 	struct lgs8gl5_state *state = fe->demodulator_priv;
 	u8 inv = lgs8gl5_read_reg(state, REG_INVERSION);
-	struct dvb_ofdm_parameters *o = &p->u.ofdm;
 
 	p->inversion = (inv & REG_INVERSION_ON) ? INVERSION_ON : INVERSION_OFF;
 
-	o->code_rate_HP = FEC_1_2;
-	o->code_rate_LP = FEC_7_8;
-	o->guard_interval = GUARD_INTERVAL_1_32;
-	o->transmission_mode = TRANSMISSION_MODE_2K;
-	o->constellation = QAM_64;
-	o->hierarchy_information = HIERARCHY_NONE;
-	o->bandwidth = BANDWIDTH_8_MHZ;
+	p->code_rate_HP = FEC_1_2;
+	p->code_rate_LP = FEC_7_8;
+	p->guard_interval = GUARD_INTERVAL_1_32;
+	p->transmission_mode = TRANSMISSION_MODE_2K;
+	p->modulation = QAM_64;
+	p->hierarchy = HIERARCHY_NONE;
+	p->bandwidth_hz = 8000000;
 
 	return 0;
 }
@@ -413,6 +412,7 @@ EXPORT_SYMBOL(lgs8gl5_attach);
 
 
 static struct dvb_frontend_ops lgs8gl5_ops = {
+	.delsys = { SYS_DMBTH },
 	.info = {
 		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
 		.type			= FE_OFDM,
@@ -434,8 +434,8 @@ static struct dvb_frontend_ops lgs8gl5_ops = {
 
 	.init = lgs8gl5_init,
 
-	.set_frontend_legacy = lgs8gl5_set_frontend,
-	.get_frontend_legacy = lgs8gl5_get_frontend,
+	.set_frontend = lgs8gl5_set_frontend,
+	.get_frontend = lgs8gl5_get_frontend,
 	.get_tune_settings = lgs8gl5_get_tune_settings,
 
 	.read_status = lgs8gl5_read_status,
-- 
1.7.8.352.g876a6

