Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNjA006756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 07/28] [media] tda10021: Don't use a magic numbers for QAM modulation
Date: Thu, 22 Dec 2011 09:19:55 -0200
Message-Id: <1324552816-25704-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-7-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the existing data struct to use the QAM modulation macros,
instead of assuming that they're numbered from 0 to 5.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda10021.c |   59 ++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 6ca533e..cd9952e 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -224,27 +224,43 @@ static int tda10021_init (struct dvb_frontend *fe)
 	return 0;
 }
 
+struct qam_params {
+	u8 conf, agcref, lthr, mseth, aref;
+};
+
 static int tda10021_set_parameters (struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p)
 {
 	struct tda10021_state* state = fe->demodulator_priv;
-
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
+	static const struct qam_params qam_params[] = {
+		/* Modulation  Conf  AGCref  LTHR  MSETH  AREF */
+		[QPSK]	   = { 0x14, 0x78,   0x78, 0x8c,  0x96 },
+		[QAM_16]   = { 0x00, 0x8c,   0x87, 0xa2,  0x91 },
+		[QAM_32]   = { 0x04, 0x8c,   0x64, 0x74,  0x96 },
+		[QAM_64]   = { 0x08, 0x6a,   0x46, 0x43,  0x6a },
+		[QAM_128]  = { 0x0c, 0x78,   0x36, 0x34,  0x7e },
+		[QAM_256]  = { 0x10, 0x5c,   0x26, 0x23,  0x6b },
+	};
 	int qam = p->u.qam.modulation;
 
-	if (qam < 0 || qam > 5)
+	/*
+	 * gcc optimizes the code bellow the same way as it would code:
+	 *           "if (qam > 5) return -EINVAL;"
+	 * Yet, the code is clearer, as it shows what QAM standards are
+	 * supported by the driver, and avoids the usage of magic numbers on
+	 * it.
+	 */
+	switch (qam) {
+	case QPSK:
+	case QAM_16:
+	case QAM_32:
+	case QAM_64:
+	case QAM_128:
+	case QAM_256:
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	if (p->inversion != INVERSION_ON && p->inversion != INVERSION_OFF)
 		return -EINVAL;
@@ -256,15 +272,14 @@ static int tda10021_set_parameters (struct dvb_frontend *fe,
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	tda10021_set_symbolrate (state, p->u.qam.symbol_rate);
-	_tda10021_writereg (state, 0x34, state->pwm);
-
-	_tda10021_writereg (state, 0x01, reg0x01[qam]);
-	_tda10021_writereg (state, 0x05, reg0x05[qam]);
-	_tda10021_writereg (state, 0x08, reg0x08[qam]);
-	_tda10021_writereg (state, 0x09, reg0x09[qam]);
+	tda10021_set_symbolrate(state, p->u.qam.symbol_rate);
+	_tda10021_writereg(state, 0x34, state->pwm);
 
-	tda10021_setup_reg0 (state, reg0x00[qam], p->inversion);
+	_tda10021_writereg(state, 0x01, qam_params[qam].agcref);
+	_tda10021_writereg(state, 0x05, qam_params[qam].lthr);
+	_tda10021_writereg(state, 0x08, qam_params[qam].mseth);
+	_tda10021_writereg(state, 0x09, qam_params[qam].aref);
+	tda10021_setup_reg0(state, qam_params[qam].conf, p->inversion);
 
 	return 0;
 }
-- 
1.7.8.352.g876a6

