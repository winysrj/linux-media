Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab1L0BJd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:33 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19XIi032607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 40/91] [media] nxt6000: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:28 -0200
Message-Id: <1324948159-23709-41-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-40-git-send-email-mchehab@redhat.com>
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

