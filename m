Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1L0BJh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:37 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19aHL015640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:36 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 35/91] [media] lgs8gxx: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:23 -0200
Message-Id: <1324948159-23709-36-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-35-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/lgs8gxx.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 05bfa05..da7d8f6 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -669,9 +669,9 @@ static int lgs8gxx_write(struct dvb_frontend *fe, const u8 buf[], int len)
 	return lgs8gxx_write_reg(priv, buf[0], buf[1]);
 }
 
-static int lgs8gxx_set_fe(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *fe_params)
+static int lgs8gxx_set_fe(struct dvb_frontend *fe)
 {
+
 	struct lgs8gxx_state *priv = fe->demodulator_priv;
 
 	dprintk("%s\n", __func__);
@@ -692,7 +692,7 @@ static int lgs8gxx_set_fe(struct dvb_frontend *fe,
 }
 
 static int lgs8gxx_get_fe(struct dvb_frontend *fe,
-			  struct dvb_frontend_parameters *fe_params)
+			  struct dtv_frontend_properties *fe_params)
 {
 	dprintk("%s\n", __func__);
 
@@ -701,21 +701,21 @@ static int lgs8gxx_get_fe(struct dvb_frontend *fe,
 	fe_params->inversion = INVERSION_OFF;
 
 	/* bandwidth */
-	fe_params->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+	fe_params->bandwidth_hz = 8000000;
 
-	fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
-	fe_params->u.ofdm.code_rate_LP = FEC_AUTO;
+	fe_params->code_rate_HP = FEC_AUTO;
+	fe_params->code_rate_LP = FEC_AUTO;
 
-	fe_params->u.ofdm.constellation = QAM_AUTO;
+	fe_params->modulation = QAM_AUTO;
 
 	/* transmission mode */
-	fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
+	fe_params->transmission_mode = TRANSMISSION_MODE_AUTO;
 
 	/* guard interval */
-	fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
+	fe_params->guard_interval = GUARD_INTERVAL_AUTO;
 
 	/* hierarchy */
-	fe_params->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+	fe_params->hierarchy = HIERARCHY_NONE;
 
 	return 0;
 }
@@ -994,6 +994,7 @@ static int lgs8gxx_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 static struct dvb_frontend_ops lgs8gxx_ops = {
+	.delsys = { SYS_DMBTH },
 	.info = {
 		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
 		.type = FE_OFDM,
@@ -1013,8 +1014,8 @@ static struct dvb_frontend_ops lgs8gxx_ops = {
 	.write = lgs8gxx_write,
 	.i2c_gate_ctrl = lgs8gxx_i2c_gate_ctrl,
 
-	.set_frontend_legacy = lgs8gxx_set_fe,
-	.get_frontend_legacy = lgs8gxx_get_fe,
+	.set_frontend = lgs8gxx_set_fe,
+	.get_frontend = lgs8gxx_get_fe,
 	.get_tune_settings = lgs8gxx_get_tune_settings,
 
 	.read_status = lgs8gxx_read_status,
-- 
1.7.8.352.g876a6

