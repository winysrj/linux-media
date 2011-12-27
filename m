Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab1L0BJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19gZQ005509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 48/91] [media] mt312: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:36 -0200
Message-Id: <1324948159-23709-49-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-48-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/mt312.c |   36 +++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 8f5d2d2..3e4512a 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -531,9 +531,9 @@ static int mt312_read_ucblocks(struct dvb_frontend *fe, u32 *ubc)
 	return 0;
 }
 
-static int mt312_set_frontend(struct dvb_frontend *fe,
-			      struct dvb_frontend_parameters *p)
+static int mt312_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mt312_state *state = fe->demodulator_priv;
 	int ret;
 	u8 buf[5], config_val;
@@ -553,16 +553,16 @@ static int mt312_set_frontend(struct dvb_frontend *fe,
 	    || (p->inversion > INVERSION_ON))
 		return -EINVAL;
 
-	if ((p->u.qpsk.symbol_rate < fe->ops.info.symbol_rate_min)
-	    || (p->u.qpsk.symbol_rate > fe->ops.info.symbol_rate_max))
+	if ((p->symbol_rate < fe->ops.info.symbol_rate_min)
+	    || (p->symbol_rate > fe->ops.info.symbol_rate_max))
 		return -EINVAL;
 
-	if ((p->u.qpsk.fec_inner < FEC_NONE)
-	    || (p->u.qpsk.fec_inner > FEC_AUTO))
+	if ((p->fec_inner < FEC_NONE)
+	    || (p->fec_inner > FEC_AUTO))
 		return -EINVAL;
 
-	if ((p->u.qpsk.fec_inner == FEC_4_5)
-	    || (p->u.qpsk.fec_inner == FEC_8_9))
+	if ((p->fec_inner == FEC_4_5)
+	    || (p->fec_inner == FEC_8_9))
 		return -EINVAL;
 
 	switch (state->id) {
@@ -574,7 +574,7 @@ static int mt312_set_frontend(struct dvb_frontend *fe,
 		ret = mt312_readreg(state, CONFIG, &config_val);
 		if (ret < 0)
 			return ret;
-		if (p->u.qpsk.symbol_rate >= 30000000) {
+		if (p->symbol_rate >= 30000000) {
 			/* Note that 30MS/s should use 90MHz */
 			if (state->freq_mult == 6) {
 				/* We are running 60MHz */
@@ -609,19 +609,19 @@ static int mt312_set_frontend(struct dvb_frontend *fe,
 	}
 
 	/* sr = (u16)(sr * 256.0 / 1000000.0) */
-	sr = mt312_div(p->u.qpsk.symbol_rate * 4, 15625);
+	sr = mt312_div(p->symbol_rate * 4, 15625);
 
 	/* SYM_RATE */
 	buf[0] = (sr >> 8) & 0x3f;
 	buf[1] = (sr >> 0) & 0xff;
 
 	/* VIT_MODE */
-	buf[2] = inv_tab[p->inversion] | fec_tab[p->u.qpsk.fec_inner];
+	buf[2] = inv_tab[p->inversion] | fec_tab[p->fec_inner];
 
 	/* QPSK_CTRL */
 	buf[3] = 0x40;		/* swap I and Q before QPSK demodulation */
 
-	if (p->u.qpsk.symbol_rate < 10000000)
+	if (p->symbol_rate < 10000000)
 		buf[3] |= 0x04;	/* use afc mode */
 
 	/* GO */
@@ -637,7 +637,7 @@ static int mt312_set_frontend(struct dvb_frontend *fe,
 }
 
 static int mt312_get_frontend(struct dvb_frontend *fe,
-			      struct dvb_frontend_parameters *p)
+			      struct dtv_frontend_properties *p)
 {
 	struct mt312_state *state = fe->demodulator_priv;
 	int ret;
@@ -646,11 +646,11 @@ static int mt312_get_frontend(struct dvb_frontend *fe,
 	if (ret < 0)
 		return ret;
 
-	ret = mt312_get_symbol_rate(state, &p->u.qpsk.symbol_rate);
+	ret = mt312_get_symbol_rate(state, &p->symbol_rate);
 	if (ret < 0)
 		return ret;
 
-	ret = mt312_get_code_rate(state, &p->u.qpsk.fec_inner);
+	ret = mt312_get_code_rate(state, &p->fec_inner);
 	if (ret < 0)
 		return ret;
 
@@ -738,7 +738,7 @@ static void mt312_release(struct dvb_frontend *fe)
 
 #define MT312_SYS_CLK		90000000UL	/* 90 MHz */
 static struct dvb_frontend_ops mt312_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name = "Zarlink ???? DVB-S",
 		.type = FE_QPSK,
@@ -761,8 +761,8 @@ static struct dvb_frontend_ops mt312_ops = {
 	.sleep = mt312_sleep,
 	.i2c_gate_ctrl = mt312_i2c_gate_ctrl,
 
-	.set_frontend_legacy = mt312_set_frontend,
-	.get_frontend_legacy = mt312_get_frontend,
+	.set_frontend = mt312_set_frontend,
+	.get_frontend = mt312_get_frontend,
 	.get_tune_settings = mt312_get_tune_settings,
 
 	.read_status = mt312_read_status,
-- 
1.7.8.352.g876a6

