Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1L3PJ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:28 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9SlU024189
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 40/94] [media] nxt6000: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:37 -0200
Message-Id: <1325257711-12274-41-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/nxt6000.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/frontends/nxt6000.c b/drivers/media/dvb/frontends/nxt6000.c
index a2419e8..389f490 100644
--- a/drivers/media/dvb/frontends/nxt6000.c
+++ b/drivers/media/dvb/frontends/nxt6000.c
@@ -81,22 +81,21 @@ static void nxt6000_reset(struct nxt6000_state* state)
 	nxt6000_writereg(state, OFDM_COR_CTL, val | COREACT);
 }
 
-static int nxt6000_set_bandwidth(struct nxt6000_state* state, fe_bandwidth_t bandwidth)
+static int nxt6000_set_bandwidth(struct nxt6000_state* state, u32 bandwidth)
 {
 	u16 nominal_rate;
 	int result;
 
 	switch (bandwidth) {
-
-	case BANDWIDTH_6_MHZ:
+	case 6000000:
 		nominal_rate = 0x55B7;
 		break;
 
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		nominal_rate = 0x6400;
 		break;
 
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		nominal_rate = 0x7249;
 		break;
 
@@ -457,8 +456,9 @@ static int nxt6000_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static int nxt6000_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *param)
+static int nxt6000_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct nxt6000_state* state = fe->demodulator_priv;
 	int result;
 
@@ -467,13 +467,13 @@ static int nxt6000_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	if ((result = nxt6000_set_bandwidth(state, param->u.ofdm.bandwidth)) < 0)
+	if ((result = nxt6000_set_bandwidth(state, p->bandwidth_hz)) < 0)
 		return result;
-	if ((result = nxt6000_set_guard_interval(state, param->u.ofdm.guard_interval)) < 0)
+	if ((result = nxt6000_set_guard_interval(state, p->guard_interval)) < 0)
 		return result;
-	if ((result = nxt6000_set_transmission_mode(state, param->u.ofdm.transmission_mode)) < 0)
+	if ((result = nxt6000_set_transmission_mode(state, p->transmission_mode)) < 0)
 		return result;
-	if ((result = nxt6000_set_inversion(state, param->inversion)) < 0)
+	if ((result = nxt6000_set_inversion(state, p->inversion)) < 0)
 		return result;
 
 	msleep(500);
@@ -566,7 +566,7 @@ error:
 }
 
 static struct dvb_frontend_ops nxt6000_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name = "NxtWave NXT6000 DVB-T",
 		.type = FE_OFDM,
@@ -592,7 +592,7 @@ static struct dvb_frontend_ops nxt6000_ops = {
 
 	.get_tune_settings = nxt6000_fe_get_tune_settings,
 
-	.set_frontend_legacy = nxt6000_set_frontend,
+	.set_frontend = nxt6000_set_frontend,
 
 	.read_status = nxt6000_read_status,
 	.read_ber = nxt6000_read_ber,
-- 
1.7.8.352.g876a6

