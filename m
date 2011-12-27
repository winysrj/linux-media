Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab1L0BJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:34 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19XTk032613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 09/91] [media] cx22702: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:07:57 -0200
Message-Id: <1324948159-23709-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-9-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/cx22702.c |   68 ++++++++++++++++----------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index a04cff8..225ce84 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -146,7 +146,7 @@ static int cx22702_set_inversion(struct cx22702_state *state, int inversion)
 
 /* Retrieve the demod settings */
 static int cx22702_get_tps(struct cx22702_state *state,
-	struct dvb_ofdm_parameters *p)
+			   struct dtv_frontend_properties *p)
 {
 	u8 val;
 
@@ -157,27 +157,27 @@ static int cx22702_get_tps(struct cx22702_state *state,
 	val = cx22702_readreg(state, 0x01);
 	switch ((val & 0x18) >> 3) {
 	case 0:
-		p->constellation = QPSK;
+		p->modulation = QPSK;
 		break;
 	case 1:
-		p->constellation = QAM_16;
+		p->modulation = QAM_16;
 		break;
 	case 2:
-		p->constellation = QAM_64;
+		p->modulation = QAM_64;
 		break;
 	}
 	switch (val & 0x07) {
 	case 0:
-		p->hierarchy_information = HIERARCHY_NONE;
+		p->hierarchy = HIERARCHY_NONE;
 		break;
 	case 1:
-		p->hierarchy_information = HIERARCHY_1;
+		p->hierarchy = HIERARCHY_1;
 		break;
 	case 2:
-		p->hierarchy_information = HIERARCHY_2;
+		p->hierarchy = HIERARCHY_2;
 		break;
 	case 3:
-		p->hierarchy_information = HIERARCHY_4;
+		p->hierarchy = HIERARCHY_4;
 		break;
 	}
 
@@ -260,9 +260,9 @@ static int cx22702_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 /* Talk to the demod, set the FEC, GUARD, QAM settings etc */
-static int cx22702_set_tps(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+static int cx22702_set_tps(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u8 val;
 	struct cx22702_state *state = fe->demodulator_priv;
 
@@ -277,14 +277,14 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 
 	/* set bandwidth */
 	val = cx22702_readreg(state, 0x0C) & 0xcf;
-	switch (p->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
+	switch (p->bandwidth_hz) {
+	case 6000000:
 		val |= 0x20;
 		break;
-	case BANDWIDTH_7_MHZ:
+	case 7000000:
 		val |= 0x10;
 		break;
-	case BANDWIDTH_8_MHZ:
+	case 8000000:
 		break;
 	default:
 		dprintk("%s: invalid bandwidth\n", __func__);
@@ -292,15 +292,15 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 	}
 	cx22702_writereg(state, 0x0C, val);
 
-	p->u.ofdm.code_rate_LP = FEC_AUTO; /* temp hack as manual not working */
+	p->code_rate_LP = FEC_AUTO; /* temp hack as manual not working */
 
 	/* use auto configuration? */
-	if ((p->u.ofdm.hierarchy_information == HIERARCHY_AUTO) ||
-	   (p->u.ofdm.constellation == QAM_AUTO) ||
-	   (p->u.ofdm.code_rate_HP == FEC_AUTO) ||
-	   (p->u.ofdm.code_rate_LP == FEC_AUTO) ||
-	   (p->u.ofdm.guard_interval == GUARD_INTERVAL_AUTO) ||
-	   (p->u.ofdm.transmission_mode == TRANSMISSION_MODE_AUTO)) {
+	if ((p->hierarchy == HIERARCHY_AUTO) ||
+	   (p->modulation == QAM_AUTO) ||
+	   (p->code_rate_HP == FEC_AUTO) ||
+	   (p->code_rate_LP == FEC_AUTO) ||
+	   (p->guard_interval == GUARD_INTERVAL_AUTO) ||
+	   (p->transmission_mode == TRANSMISSION_MODE_AUTO)) {
 
 		/* TPS Source - use hardware driven values */
 		cx22702_writereg(state, 0x06, 0x10);
@@ -316,7 +316,7 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 	}
 
 	/* manually programmed values */
-	switch (p->u.ofdm.constellation) {		/* mask 0x18 */
+	switch (p->modulation) {		/* mask 0x18 */
 	case QPSK:
 		val = 0x00;
 		break;
@@ -327,10 +327,10 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 		val = 0x10;
 		break;
 	default:
-		dprintk("%s: invalid constellation\n", __func__);
+		dprintk("%s: invalid modulation\n", __func__);
 		return -EINVAL;
 	}
-	switch (p->u.ofdm.hierarchy_information) {	/* mask 0x07 */
+	switch (p->hierarchy) {	/* mask 0x07 */
 	case HIERARCHY_NONE:
 		break;
 	case HIERARCHY_1:
@@ -348,7 +348,7 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 	}
 	cx22702_writereg(state, 0x06, val);
 
-	switch (p->u.ofdm.code_rate_HP) {		/* mask 0x38 */
+	switch (p->code_rate_HP) {		/* mask 0x38 */
 	case FEC_NONE:
 	case FEC_1_2:
 		val = 0x00;
@@ -369,7 +369,7 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 		dprintk("%s: invalid code_rate_HP\n", __func__);
 		return -EINVAL;
 	}
-	switch (p->u.ofdm.code_rate_LP) {		/* mask 0x07 */
+	switch (p->code_rate_LP) {		/* mask 0x07 */
 	case FEC_NONE:
 	case FEC_1_2:
 		break;
@@ -391,7 +391,7 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 	}
 	cx22702_writereg(state, 0x07, val);
 
-	switch (p->u.ofdm.guard_interval) {		/* mask 0x0c */
+	switch (p->guard_interval) {		/* mask 0x0c */
 	case GUARD_INTERVAL_1_32:
 		val = 0x00;
 		break;
@@ -408,7 +408,7 @@ static int cx22702_set_tps(struct dvb_frontend *fe,
 		dprintk("%s: invalid guard_interval\n", __func__);
 		return -EINVAL;
 	}
-	switch (p->u.ofdm.transmission_mode) {		/* mask 0x03 */
+	switch (p->transmission_mode) {		/* mask 0x03 */
 	case TRANSMISSION_MODE_2K:
 		break;
 	case TRANSMISSION_MODE_8K:
@@ -547,14 +547,14 @@ static int cx22702_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 }
 
 static int cx22702_get_frontend(struct dvb_frontend *fe,
-	struct dvb_frontend_parameters *p)
+				struct dtv_frontend_properties *c)
 {
 	struct cx22702_state *state = fe->demodulator_priv;
 
 	u8 reg0C = cx22702_readreg(state, 0x0C);
 
-	p->inversion = reg0C & 0x1 ? INVERSION_ON : INVERSION_OFF;
-	return cx22702_get_tps(state, &p->u.ofdm);
+	c->inversion = reg0C & 0x1 ? INVERSION_ON : INVERSION_OFF;
+	return cx22702_get_tps(state, c);
 }
 
 static int cx22702_get_tune_settings(struct dvb_frontend *fe,
@@ -603,7 +603,7 @@ error:
 EXPORT_SYMBOL(cx22702_attach);
 
 static const struct dvb_frontend_ops cx22702_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Conexant CX22702 DVB-T",
 		.type			= FE_OFDM,
@@ -622,8 +622,8 @@ static const struct dvb_frontend_ops cx22702_ops = {
 	.init = cx22702_init,
 	.i2c_gate_ctrl = cx22702_i2c_gate_ctrl,
 
-	.set_frontend_legacy = cx22702_set_tps,
-	.get_frontend_legacy = cx22702_get_frontend,
+	.set_frontend= cx22702_set_tps,
+	.get_frontend = cx22702_get_frontend,
 	.get_tune_settings = cx22702_get_tune_settings,
 
 	.read_status = cx22702_read_status,
-- 
1.7.8.352.g876a6

