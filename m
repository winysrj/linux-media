Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1L0BJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:34 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19XBE017845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 05/91] [media] atbm8830: convert set_fontend to new way and fix delivery system
Date: Mon, 26 Dec 2011 23:07:53 -0200
Message-Id: <1324948159-23709-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-5-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is one of the cases where the frontend changes is required:
while this device lies to applications that it is a DVB-T, it is,
in fact, a frontend for CTTB delivery system. So, the information
provided for a DVBv3 application should be different than the one
provided to a DVBv5 application.

So, fill delsys with the CTTB delivery system, and use the new
way. there aren't many changes here, as everything on this driver
is on auto mode, probably because of the lack of a proper API
for this delivery system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/atbm8830.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index c4e0909..c4edbbe 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -267,8 +267,7 @@ static void atbm8830_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static int atbm8830_set_fe(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *fe_params)
+static int atbm8830_set_fe(struct dvb_frontend *fe)
 {
 	struct atbm_state *priv = fe->demodulator_priv;
 	int i;
@@ -299,30 +298,30 @@ static int atbm8830_set_fe(struct dvb_frontend *fe,
 }
 
 static int atbm8830_get_fe(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *fe_params)
+			   struct dtv_frontend_properties *c)
 {
 	dprintk("%s\n", __func__);
 
 	/* TODO: get real readings from device */
 	/* inversion status */
-	fe_params->inversion = INVERSION_OFF;
+	c->inversion = INVERSION_OFF;
 
 	/* bandwidth */
-	fe_params->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+	c->bandwidth_hz = 8000000;
 
-	fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
-	fe_params->u.ofdm.code_rate_LP = FEC_AUTO;
+	c->code_rate_HP = FEC_AUTO;
+	c->code_rate_LP = FEC_AUTO;
 
-	fe_params->u.ofdm.constellation = QAM_AUTO;
+	c->modulation = QAM_AUTO;
 
 	/* transmission mode */
-	fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
+	c->transmission_mode = TRANSMISSION_MODE_AUTO;
 
 	/* guard interval */
-	fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
+	c->guard_interval = GUARD_INTERVAL_AUTO;
 
 	/* hierarchy */
-	fe_params->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+	c->hierarchy = HIERARCHY_NONE;
 
 	return 0;
 }
@@ -429,6 +428,7 @@ static int atbm8830_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 static struct dvb_frontend_ops atbm8830_ops = {
+	.delsys = { SYS_DMBTH },
 	.info = {
 		.name = "AltoBeam ATBM8830/8831 DMB-TH",
 		.type = FE_OFDM,
@@ -449,8 +449,8 @@ static struct dvb_frontend_ops atbm8830_ops = {
 	.write = NULL,
 	.i2c_gate_ctrl = atbm8830_i2c_gate_ctrl,
 
-	.set_frontend_legacy = atbm8830_set_fe,
-	.get_frontend_legacy = atbm8830_get_fe,
+	.set_frontend = atbm8830_set_fe,
+	.get_frontend = atbm8830_get_fe,
 	.get_tune_settings = atbm8830_get_tune_settings,
 
 	.read_status = atbm8830_read_status,
-- 
1.7.8.352.g876a6

