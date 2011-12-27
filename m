Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab1L0BJf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:35 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19YZP017859
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 08/91] [media] cx22700: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:07:56 -0200
Message-Id: <1324948159-23709-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-8-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/cx22700.c |   52 +++++++++++++++++---------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index 7ac95de..3c571b9 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -121,7 +121,8 @@ static int cx22700_set_inversion (struct cx22700_state* state, int inversion)
 	}
 }
 
-static int cx22700_set_tps (struct cx22700_state *state, struct dvb_ofdm_parameters *p)
+static int cx22700_set_tps(struct cx22700_state *state,
+			   struct dtv_frontend_properties *p)
 {
 	static const u8 qam_tab [4] = { 0, 1, 0, 2 };
 	static const u8 fec_tab [6] = { 0, 1, 2, 0, 3, 4 };
@@ -146,25 +147,25 @@ static int cx22700_set_tps (struct cx22700_state *state, struct dvb_ofdm_paramet
 	    p->transmission_mode != TRANSMISSION_MODE_8K)
 		return -EINVAL;
 
-	if (p->constellation != QPSK &&
-	    p->constellation != QAM_16 &&
-	    p->constellation != QAM_64)
+	if (p->modulation != QPSK &&
+	    p->modulation != QAM_16 &&
+	    p->modulation != QAM_64)
 		return -EINVAL;
 
-	if (p->hierarchy_information < HIERARCHY_NONE ||
-	    p->hierarchy_information > HIERARCHY_4)
+	if (p->hierarchy < HIERARCHY_NONE ||
+	    p->hierarchy > HIERARCHY_4)
 		return -EINVAL;
 
-	if (p->bandwidth < BANDWIDTH_8_MHZ || p->bandwidth > BANDWIDTH_6_MHZ)
+	if (p->bandwidth_hz > 8000000 || p->bandwidth_hz < 6000000)
 		return -EINVAL;
 
-	if (p->bandwidth == BANDWIDTH_7_MHZ)
+	if (p->bandwidth_hz == 7000000)
 		cx22700_writereg (state, 0x09, cx22700_readreg (state, 0x09 | 0x10));
 	else
 		cx22700_writereg (state, 0x09, cx22700_readreg (state, 0x09 & ~0x10));
 
-	val = qam_tab[p->constellation - QPSK];
-	val |= p->hierarchy_information - HIERARCHY_NONE;
+	val = qam_tab[p->modulation - QPSK];
+	val |= p->hierarchy - HIERARCHY_NONE;
 
 	cx22700_writereg (state, 0x04, val);
 
@@ -184,7 +185,8 @@ static int cx22700_set_tps (struct cx22700_state *state, struct dvb_ofdm_paramet
 	return 0;
 }
 
-static int cx22700_get_tps (struct cx22700_state* state, struct dvb_ofdm_parameters *p)
+static int cx22700_get_tps(struct cx22700_state *state,
+			   struct dtv_frontend_properties *p)
 {
 	static const fe_modulation_t qam_tab [3] = { QPSK, QAM_16, QAM_64 };
 	static const fe_code_rate_t fec_tab [5] = { FEC_1_2, FEC_2_3, FEC_3_4,
@@ -199,14 +201,14 @@ static int cx22700_get_tps (struct cx22700_state* state, struct dvb_ofdm_paramet
 	val = cx22700_readreg (state, 0x01);
 
 	if ((val & 0x7) > 4)
-		p->hierarchy_information = HIERARCHY_AUTO;
+		p->hierarchy = HIERARCHY_AUTO;
 	else
-		p->hierarchy_information = HIERARCHY_NONE + (val & 0x7);
+		p->hierarchy = HIERARCHY_NONE + (val & 0x7);
 
 	if (((val >> 3) & 0x3) > 2)
-		p->constellation = QAM_AUTO;
+		p->modulation = QAM_AUTO;
 	else
-		p->constellation = qam_tab[(val >> 3) & 0x3];
+		p->modulation = qam_tab[(val >> 3) & 0x3];
 
 	val = cx22700_readreg (state, 0x02);
 
@@ -318,8 +320,9 @@ static int cx22700_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	return 0;
 }
 
-static int cx22700_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int cx22700_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx22700_state* state = fe->demodulator_priv;
 
 	cx22700_writereg (state, 0x00, 0x02); /* XXX CHECKME: soft reset*/
@@ -330,21 +333,22 @@ static int cx22700_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	cx22700_set_inversion (state, p->inversion);
-	cx22700_set_tps (state, &p->u.ofdm);
+	cx22700_set_inversion(state, c->inversion);
+	cx22700_set_tps(state, c);
 	cx22700_writereg (state, 0x37, 0x01);  /* PAL loop filter off */
 	cx22700_writereg (state, 0x00, 0x01);  /* restart acquire */
 
 	return 0;
 }
 
-static int cx22700_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int cx22700_get_frontend(struct dvb_frontend* fe,
+				struct dtv_frontend_properties *c)
 {
 	struct cx22700_state* state = fe->demodulator_priv;
 	u8 reg09 = cx22700_readreg (state, 0x09);
 
-	p->inversion = reg09 & 0x1 ? INVERSION_ON : INVERSION_OFF;
-	return cx22700_get_tps (state, &p->u.ofdm);
+	c->inversion = reg09 & 0x1 ? INVERSION_ON : INVERSION_OFF;
+	return cx22700_get_tps(state, c);
 }
 
 static int cx22700_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
@@ -401,7 +405,7 @@ error:
 }
 
 static struct dvb_frontend_ops cx22700_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22700 DVB-T",
 		.type			= FE_OFDM,
@@ -419,8 +423,8 @@ static struct dvb_frontend_ops cx22700_ops = {
 	.init = cx22700_init,
 	.i2c_gate_ctrl = cx22700_i2c_gate_ctrl,
 
-	.set_frontend_legacy = cx22700_set_frontend,
-	.get_frontend_legacy = cx22700_get_frontend,
+	.set_frontend = cx22700_set_frontend,
+	.get_frontend = cx22700_get_frontend,
 	.get_tune_settings = cx22700_get_tune_settings,
 
 	.read_status = cx22700_read_status,
-- 
1.7.8.352.g876a6

