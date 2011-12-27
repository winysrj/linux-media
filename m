Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab1L0BJl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:41 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19eRo005497
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 56/91] [media] stv900: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:44 -0200
Message-Id: <1324948159-23709-57-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-56-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/stv0900_core.c |   35 +++------------------------
 1 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0900_core.c b/drivers/media/dvb/frontends/stv0900_core.c
index df46654..3f7e62f 100644
--- a/drivers/media/dvb/frontends/stv0900_core.c
+++ b/drivers/media/dvb/frontends/stv0900_core.c
@@ -973,31 +973,6 @@ static enum dvbfe_algo stv0900_frontend_algo(struct dvb_frontend *fe)
 	return DVBFE_ALGO_CUSTOM;
 }
 
-static int stb0900_set_property(struct dvb_frontend *fe,
-				struct dtv_property *tvp)
-{
-	dprintk("%s(..)\n", __func__);
-
-	return 0;
-}
-
-static int stb0900_get_property(struct dvb_frontend *fe,
-				struct dtv_property *tvp)
-{
-	dprintk("%s(..)\n", __func__);
-	switch (tvp->cmd) {
-	case DTV_ENUM_DELSYS:
-		tvp->u.buffer.data[0] = SYS_DSS;
-		tvp->u.buffer.data[1] = SYS_DVBS;
-		tvp->u.buffer.data[2] = SYS_DVBS2;
-		tvp->u.buffer.len = 3;
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
 void stv0900_start_search(struct stv0900_internal *intp,
 				enum fe_stv0900_demod_num demod)
 {
@@ -1876,7 +1851,7 @@ static int stv0900_sleep(struct dvb_frontend *fe)
 }
 
 static int stv0900_get_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *p)
+				struct dtv_frontend_properties *p)
 {
 	struct stv0900_state *state = fe->demodulator_priv;
 	struct stv0900_internal *intp = state->internal;
@@ -1884,12 +1859,12 @@ static int stv0900_get_frontend(struct dvb_frontend *fe,
 	struct stv0900_signal_info p_result = intp->result[demod];
 
 	p->frequency = p_result.locked ? p_result.frequency : 0;
-	p->u.qpsk.symbol_rate = p_result.locked ? p_result.symbol_rate : 0;
+	p->symbol_rate = p_result.locked ? p_result.symbol_rate : 0;
 	return 0;
 }
 
 static struct dvb_frontend_ops stv0900_ops = {
-
+	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
 	.info = {
 		.name			= "STV0900 frontend",
 		.type			= FE_QPSK,
@@ -1908,7 +1883,7 @@ static struct dvb_frontend_ops stv0900_ops = {
 	},
 	.release			= stv0900_release,
 	.init				= stv0900_init,
-	.get_frontend_legacy = stv0900_get_frontend,
+	.get_frontend                   = stv0900_get_frontend,
 	.sleep				= stv0900_sleep,
 	.get_frontend_algo		= stv0900_frontend_algo,
 	.i2c_gate_ctrl			= stv0900_i2c_gate_ctrl,
@@ -1916,8 +1891,6 @@ static struct dvb_frontend_ops stv0900_ops = {
 	.diseqc_send_burst		= stv0900_send_burst,
 	.diseqc_recv_slave_reply	= stv0900_recv_slave_reply,
 	.set_tone			= stv0900_set_tone,
-	.set_property			= stb0900_set_property,
-	.get_property			= stb0900_get_property,
 	.search				= stv0900_search,
 	.track				= stv0900_track,
 	.read_status			= stv0900_read_status,
-- 
1.7.8.352.g876a6

