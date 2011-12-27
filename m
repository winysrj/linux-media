Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab1L0BJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19gcc032667
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 54/91] [media] stv0297: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:42 -0200
Message-Id: <1324948159-23709-55-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-54-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/stv0297.c |   35 +++++++++++++++++----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index 5d7c288..88e8e52 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -404,8 +404,9 @@ static int stv0297_read_ucblocks(struct dvb_frontend *fe, u32 * ucblocks)
 	return 0;
 }
 
-static int stv0297_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int stv0297_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stv0297_state *state = fe->demodulator_priv;
 	int u_threshold;
 	int initial_u;
@@ -417,7 +418,7 @@ static int stv0297_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 	unsigned long timeout;
 	fe_spectral_inversion_t inversion;
 
-	switch (p->u.qam.modulation) {
+	switch (p->modulation) {
 	case QAM_16:
 	case QAM_32:
 	case QAM_64:
@@ -519,16 +520,16 @@ static int stv0297_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 	stv0297_writereg_mask(state, 0x69, 0x0f, 0x00);
 
 	/* set parameters */
-	stv0297_set_qam(state, p->u.qam.modulation);
-	stv0297_set_symbolrate(state, p->u.qam.symbol_rate / 1000);
-	stv0297_set_sweeprate(state, sweeprate, p->u.qam.symbol_rate / 1000);
+	stv0297_set_qam(state, p->modulation);
+	stv0297_set_symbolrate(state, p->symbol_rate / 1000);
+	stv0297_set_sweeprate(state, sweeprate, p->symbol_rate / 1000);
 	stv0297_set_carrieroffset(state, carrieroffset);
 	stv0297_set_inversion(state, inversion);
 
 	/* kick off lock */
 	/* Disable corner detection for higher QAMs */
-	if (p->u.qam.modulation == QAM_128 ||
-		p->u.qam.modulation == QAM_256)
+	if (p->modulation == QAM_128 ||
+		p->modulation == QAM_256)
 		stv0297_writereg_mask(state, 0x88, 0x08, 0x00);
 	else
 		stv0297_writereg_mask(state, 0x88, 0x08, 0x08);
@@ -613,7 +614,7 @@ timeout:
 	return 0;
 }
 
-static int stv0297_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
+static int stv0297_get_frontend(struct dvb_frontend *fe, struct dtv_frontend_properties *p)
 {
 	struct stv0297_state *state = fe->demodulator_priv;
 	int reg_00, reg_83;
@@ -625,24 +626,24 @@ static int stv0297_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 	p->inversion = (reg_83 & 0x08) ? INVERSION_ON : INVERSION_OFF;
 	if (state->config->invert)
 		p->inversion = (p->inversion == INVERSION_ON) ? INVERSION_OFF : INVERSION_ON;
-	p->u.qam.symbol_rate = stv0297_get_symbolrate(state) * 1000;
-	p->u.qam.fec_inner = FEC_NONE;
+	p->symbol_rate = stv0297_get_symbolrate(state) * 1000;
+	p->fec_inner = FEC_NONE;
 
 	switch ((reg_00 >> 4) & 0x7) {
 	case 0:
-		p->u.qam.modulation = QAM_16;
+		p->modulation = QAM_16;
 		break;
 	case 1:
-		p->u.qam.modulation = QAM_32;
+		p->modulation = QAM_32;
 		break;
 	case 2:
-		p->u.qam.modulation = QAM_128;
+		p->modulation = QAM_128;
 		break;
 	case 3:
-		p->u.qam.modulation = QAM_256;
+		p->modulation = QAM_256;
 		break;
 	case 4:
-		p->u.qam.modulation = QAM_64;
+		p->modulation = QAM_64;
 		break;
 	}
 
@@ -706,8 +707,8 @@ static struct dvb_frontend_ops stv0297_ops = {
 	.sleep = stv0297_sleep,
 	.i2c_gate_ctrl = stv0297_i2c_gate_ctrl,
 
-	.set_frontend_legacy = stv0297_set_frontend,
-	.get_frontend_legacy = stv0297_get_frontend,
+	.set_frontend = stv0297_set_frontend,
+	.get_frontend = stv0297_get_frontend,
 
 	.read_status = stv0297_read_status,
 	.read_ber = stv0297_read_ber,
-- 
1.7.8.352.g876a6

