Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9S10026552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 35/94] [media] lgs8gxx: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:32 -0200
Message-Id: <1325257711-12274-36-git-send-email-mchehab@redhat.com>
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

