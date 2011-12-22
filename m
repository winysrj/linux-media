Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNWA019821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 06/28] [media] tda10023: add support for DVB-C Annex C
Date: Thu, 22 Dec 2011 09:19:54 -0200
Message-Id: <1324552816-25704-7-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-6-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The difference between Annex A and C is the roll-off factor.
Properly implement it inside the driver, using the information
provided by Andreas.

Thanks-to: Andreas Oberriter <obi@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda10023.c |   46 +++++++++++++++++++++++++++----
 1 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index e6c321e..af7f1b8 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -305,6 +305,10 @@ struct qam_params {
 static int tda10023_set_parameters (struct dvb_frontend *fe,
 			    struct dvb_frontend_parameters *p)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 delsys  = c->delivery_system;
+	unsigned qam = c->modulation;
+	bool is_annex_c;
 	struct tda10023_state* state = fe->demodulator_priv;
 	static const struct qam_params qam_params[] = {
 		/* Modulation  QAM    LOCKTHR   MSETH   AREF AGCREFNYQ ERAGCNYQ_THD */
@@ -315,7 +319,17 @@ static int tda10023_set_parameters (struct dvb_frontend *fe,
 		[QAM_128] = { (3<<2),  0x36,    0x34,   0x7e,   0x78,   0x4c  },
 		[QAM_256] = { (4<<2),  0x26,    0x23,   0x6c,   0x5c,   0x3c  },
 	};
-	unsigned qam = p->u.qam.modulation;
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
@@ -341,23 +355,43 @@ static int tda10023_set_parameters (struct dvb_frontend *fe,
 		if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
-	tda10023_set_symbolrate (state, p->u.qam.symbol_rate);
+	tda10023_set_symbolrate(state, c->symbol_rate);
 	tda10023_writereg(state, 0x05, qam_params[qam].lockthr);
 	tda10023_writereg(state, 0x08, qam_params[qam].mseth);
 	tda10023_writereg(state, 0x09, qam_params[qam].aref);
 	tda10023_writereg(state, 0xb4, qam_params[qam].agcrefnyq);
 	tda10023_writereg(state, 0xb6, qam_params[qam].eragnyq_thd);
-
 #if 0
-	tda10023_writereg(state, 0x04, (p->inversion ? 0x12 : 0x32));
-	tda10023_writebit(state, 0x04, 0x60, (p->inversion ? 0 : 0x20));
+	tda10023_writereg(state, 0x04, (c->inversion ? 0x12 : 0x32));
+	tda10023_writebit(state, 0x04, 0x60, (c->inversion ? 0 : 0x20));
 #endif
 	tda10023_writebit(state, 0x04, 0x40, 0x40);
+
+	if (is_annex_c)
+		tda10023_writebit(state, 0x3d, 0xfc, 0x03);
+	else
+		tda10023_writebit(state, 0x3d, 0xfc, 0x02);
+
 	tda10023_setup_reg0(state, qam_params[qam].qam);
 
 	return 0;
 }
 
+static int tda10023_get_property(struct dvb_frontend *fe,
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
 static int tda10023_read_status(struct dvb_frontend* fe, fe_status_t* status)
 {
 	struct tda10023_state* state = fe->demodulator_priv;
@@ -577,7 +611,7 @@ static struct dvb_frontend_ops tda10023_ops = {
 
 	.set_frontend = tda10023_set_parameters,
 	.get_frontend = tda10023_get_frontend,
-
+	.get_property = tda10023_get_property,
 	.read_status = tda10023_read_status,
 	.read_ber = tda10023_read_ber,
 	.read_signal_strength = tda10023_read_signal_strength,
-- 
1.7.8.352.g876a6

