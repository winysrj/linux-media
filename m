Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1LRAhL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:37:11 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0bBqm025414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:37:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 7/7] [media] tda10021: Add support for DVB-C Annex C
Date: Sat, 17 Dec 2011 22:37:01 -0200
Message-Id: <1324168621-21506-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324168621-21506-7-git-send-email-mchehab@redhat.com>
References: <1324168621-21506-1-git-send-email-mchehab@redhat.com>
 <1324168621-21506-2-git-send-email-mchehab@redhat.com>
 <1324168621-21506-3-git-send-email-mchehab@redhat.com>
 <1324168621-21506-4-git-send-email-mchehab@redhat.com>
 <1324168621-21506-5-git-send-email-mchehab@redhat.com>
 <1324168621-21506-6-git-send-email-mchehab@redhat.com>
 <1324168621-21506-7-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While tda10021 supports both DVB-C Annex A and C, it is currently
hard-coded to Annex A. Add support for Annex C and re-work the
code in order to report the delivery systems, thans to Andreas,
that passed us the register settings for the Roll-off factor.

While here, re-work the per-modulation register settings, in order
to avoid the magic test to check if the QAM type is supported.

Thanks-to: Andreas Oberriter <obi@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda10021.c |   83 +++++++++++++++++++++++--------
 1 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 6ca533e..3d4000d 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -227,26 +227,39 @@ static int tda10021_init (struct dvb_frontend *fe)
 static int tda10021_set_parameters (struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys  = c->delivery_system;
+	unsigned qam = c->modulation;
+	bool is_annex_c;
+	u32 reg0x3d;
 	struct tda10021_state* state = fe->demodulator_priv;
+	struct qam_params {
+		u8 conf, agcref, lthr, mseth, aref;
+	} qam_params[] = {
+		/* Modulation  Conf  AGCref  LTHR  MSETH  AREF */
+		[QPSK]	   = { 0x14, 0x78,   0x78, 0x8c,  0x96 },
+		[QAM_16]   = { 0x00, 0x8c,   0x87, 0xa2,  0x91 },
+		[QAM_32]   = { 0x04, 0x8c,   0x64, 0x74,  0x96 },
+		[QAM_64]   = { 0x08, 0x6a,   0x46, 0x43,  0x6a },
+		[QAM_128]  = { 0x0c, 0x78,   0x36, 0x34,  0x7e },
+		[QAM_256]  = { 0x10, 0x5c,   0x26, 0x23,  0x6b },
+	};
+
+	switch (delsys) {
+	case SYS_DVBC_ANNEX_A:
+		is_annex_c = false;
+		break;
+	case SYS_DVBC_ANNEX_C:
+		is_annex_c = true;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	//table for QAM4-QAM256 ready  QAM4  QAM16 QAM32 QAM64 QAM128 QAM256
-	//CONF
-	static const u8 reg0x00 [] = { 0x14, 0x00, 0x04, 0x08, 0x0c,  0x10 };
-	//AGCREF value
-	static const u8 reg0x01 [] = { 0x78, 0x8c, 0x8c, 0x6a, 0x78,  0x5c };
-	//LTHR value
-	static const u8 reg0x05 [] = { 0x78, 0x87, 0x64, 0x46, 0x36,  0x26 };
-	//MSETH
-	static const u8 reg0x08 [] = { 0x8c, 0xa2, 0x74, 0x43, 0x34,  0x23 };
-	//AREF
-	static const u8 reg0x09 [] = { 0x96, 0x91, 0x96, 0x6a, 0x7e,  0x6b };
-
-	int qam = p->u.qam.modulation;
-
-	if (qam < 0 || qam > 5)
+	if (qam >= ARRAY_SIZE(qam_params))
 		return -EINVAL;
 
-	if (p->inversion != INVERSION_ON && p->inversion != INVERSION_OFF)
+	if (c->inversion != INVERSION_ON && c->inversion != INVERSION_OFF)
 		return -EINVAL;
 
 	//printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->u.qam.symbol_rate);
@@ -256,15 +269,25 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	tda10021_set_symbolrate (state, p->u.qam.symbol_rate);
+	tda10021_set_symbolrate (state, c->symbol_rate);
 	_tda10021_writereg (state, 0x34, state->pwm);
 
-	_tda10021_writereg (state, 0x01, reg0x01[qam]);
-	_tda10021_writereg (state, 0x05, reg0x05[qam]);
-	_tda10021_writereg (state, 0x08, reg0x08[qam]);
-	_tda10021_writereg (state, 0x09, reg0x09[qam]);
+	_tda10021_writereg (state, 0x01, qam_params[qam].agcref);
+	_tda10021_writereg (state, 0x05, qam_params[qam].lthr);
+	_tda10021_writereg (state, 0x08, qam_params[qam].mseth);
+	_tda10021_writereg (state, 0x09, qam_params[qam].aref);
+	tda10021_setup_reg0 (state, qam_params[qam].conf, p->inversion);
+
+	/*
+	 * Bit 0 == 0 means roll-off = 0.15 (Annex A)
+	 *	 == 1 means roll-off = 0.13 (Annex C)
+	 */
+	reg0x3d = tda10021_readreg (state, 0x3d);
+	if (is_annex_c)
+		_tda10021_writereg (state, 0x3d, 0x01 | reg0x3d);
+	else
+		_tda10021_writereg (state, 0x3d, 0xfe & reg0x3d);
 
-	tda10021_setup_reg0 (state, reg0x00[qam], p->inversion);
 
 	return 0;
 }
@@ -443,6 +466,21 @@ error:
 	return NULL;
 }
 
+static int tda10021_get_property(struct dvb_frontend *fe,
+				 struct dtv_property *p)
+{
+	switch (p->cmd) {
+	case DTV_ENUM_DELSYS:
+		p->u.buffer.data[0] = SYS_DVBC_ANNEX_A;
+		p->u.buffer.data[1] = SYS_DVBC_ANNEX_C;
+		p->u.buffer.len = 2;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
 static struct dvb_frontend_ops tda10021_ops = {
 
 	.info = {
@@ -471,6 +509,7 @@ static struct dvb_frontend_ops tda10021_ops = {
 
 	.set_frontend = tda10021_set_parameters,
 	.get_frontend = tda10021_get_frontend,
+	.get_property = tda10021_get_property,
 
 	.read_status = tda10021_read_status,
 	.read_ber = tda10021_read_ber,
-- 
1.7.8

