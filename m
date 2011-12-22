Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab1LVLUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:24 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKONJ019845
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 08/28] [media] tda10021: Add support for DVB-C Annex C
Date: Thu, 22 Dec 2011 09:19:56 -0200
Message-Id: <1324552816-25704-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-8-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
 <1324552816-25704-8-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While tda10021 supports both DVB-C Annex A and C, it is currently
hard-coded to Annex A. Add support for Annex C and re-work the
code in order to report the delivery systems, thans to Andreas,
that passed us the register settings for the Roll-off factor.

Thanks-to: Andreas Oberriter <obi@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda10021.c |   49 +++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index cd9952e..2518c5a 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -231,6 +231,11 @@ struct qam_params {
 static int tda10021_set_parameters (struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys  = c->delivery_system;
+	unsigned qam = c->modulation;
+	bool is_annex_c;
+	u32 reg0x3d;
 	struct tda10021_state* state = fe->demodulator_priv;
 	static const struct qam_params qam_params[] = {
 		/* Modulation  Conf  AGCref  LTHR  MSETH  AREF */
@@ -241,7 +246,17 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 		[QAM_128]  = { 0x0c, 0x78,   0x36, 0x34,  0x7e },
 		[QAM_256]  = { 0x10, 0x5c,   0x26, 0x23,  0x6b },
 	};
-	int qam = p->u.qam.modulation;
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
 
 	/*
 	 * gcc optimizes the code bellow the same way as it would code:
@@ -262,7 +277,7 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
-	if (p->inversion != INVERSION_ON && p->inversion != INVERSION_OFF)
+	if (c->inversion != INVERSION_ON && c->inversion != INVERSION_OFF)
 		return -EINVAL;
 
 	//printk("tda10021: set frequency to %d qam=%d symrate=%d\n", p->frequency,qam,p->u.qam.symbol_rate);
@@ -272,14 +287,24 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	tda10021_set_symbolrate(state, p->u.qam.symbol_rate);
+	tda10021_set_symbolrate(state, c->symbol_rate);
 	_tda10021_writereg(state, 0x34, state->pwm);
 
 	_tda10021_writereg(state, 0x01, qam_params[qam].agcref);
 	_tda10021_writereg(state, 0x05, qam_params[qam].lthr);
 	_tda10021_writereg(state, 0x08, qam_params[qam].mseth);
 	_tda10021_writereg(state, 0x09, qam_params[qam].aref);
-	tda10021_setup_reg0(state, qam_params[qam].conf, p->inversion);
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
+	tda10021_setup_reg0(state, qam_params[qam].conf, c->inversion);
 
 	return 0;
 }
@@ -458,6 +483,21 @@ error:
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
@@ -486,6 +526,7 @@ static struct dvb_frontend_ops tda10021_ops = {
 
 	.set_frontend = tda10021_set_parameters,
 	.get_frontend = tda10021_get_frontend,
+	.get_property = tda10021_get_property,
 
 	.read_status = tda10021_read_status,
 	.read_ber = tda10021_read_ber,
-- 
1.7.8.352.g876a6

