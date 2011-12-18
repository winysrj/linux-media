Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab1LRAV0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 19:21:26 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBI0LQw7025062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 17 Dec 2011 19:21:26 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 4/6] [media] tda10023: Don't use a magic numbers for QAM modulation
Date: Sat, 17 Dec 2011 22:21:11 -0200
Message-Id: <1324167673-20787-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324167673-20787-4-git-send-email-mchehab@redhat.com>
References: <1324167673-20787-1-git-send-email-mchehab@redhat.com>
 <1324167673-20787-2-git-send-email-mchehab@redhat.com>
 <1324167673-20787-3-git-send-email-mchehab@redhat.com>
 <1324167673-20787-4-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the existing data struct to use the QAM modulation macros,
instead of hardcoding it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda10023.c |   34 ++++++++++++++++---------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index a3c34ee..dccc74b 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -303,19 +303,21 @@ static int tda10023_set_parameters (struct dvb_frontend *fe,
 {
 	struct tda10023_state* state = fe->demodulator_priv;
 
-	static int qamvals[6][6] = {
-		//  QAM   LOCKTHR  MSETH   AREF AGCREFNYQ  ERAGCNYQ_THD
-		{ (5<<2),  0x78,    0x8c,   0x96,   0x78,   0x4c  },  // 4 QAM
-		{ (0<<2),  0x87,    0xa2,   0x91,   0x8c,   0x57  },  // 16 QAM
-		{ (1<<2),  0x64,    0x74,   0x96,   0x8c,   0x57  },  // 32 QAM
-		{ (2<<2),  0x46,    0x43,   0x6a,   0x6a,   0x44  },  // 64 QAM
-		{ (3<<2),  0x36,    0x34,   0x7e,   0x78,   0x4c  },  // 128 QAM
-		{ (4<<2),  0x26,    0x23,   0x6c,   0x5c,   0x3c  },  // 256 QAM
+	struct qam_params {
+		u8 qam, lockthr, mseth, aref, agcrefnyq, eragnyq_thd;
+	} static const qam_params[] = {
+		/* Modulation  QAM    LOCKTHR   MSETH   AREF AGCREFNYQ ERAGCNYQ_THD */
+		[QPSK]    = { (5<<2),  0x78,    0x8c,   0x96,   0x78,   0x4c  },
+		[QAM_16]  = { (0<<2),  0x87,    0xa2,   0x91,   0x8c,   0x57  },
+		[QAM_32]  = { (1<<2),  0x64,    0x74,   0x96,   0x8c,   0x57  },
+		[QAM_64]  = { (2<<2),  0x46,    0x43,   0x6a,   0x6a,   0x44  },
+		[QAM_128] = { (3<<2),  0x36,    0x34,   0x7e,   0x78,   0x4c  },
+		[QAM_256] = { (4<<2),  0x26,    0x23,   0x6c,   0x5c,   0x3c  },
 	};
 
-	int qam = p->u.qam.modulation;
+	unsigned qam = p->u.qam.modulation;
 
-	if (qam < 0 || qam > 5)
+	if (qam >= ARRAY_SIZE(qam_params))
 		return -EINVAL;
 
 	if (fe->ops.tuner_ops.set_params) {
@@ -324,16 +326,16 @@ static int tda10023_set_parameters (struct dvb_frontend *fe,
 	}
 
 	tda10023_set_symbolrate (state, p->u.qam.symbol_rate);
-	tda10023_writereg (state, 0x05, qamvals[qam][1]);
-	tda10023_writereg (state, 0x08, qamvals[qam][2]);
-	tda10023_writereg (state, 0x09, qamvals[qam][3]);
-	tda10023_writereg (state, 0xb4, qamvals[qam][4]);
-	tda10023_writereg (state, 0xb6, qamvals[qam][5]);
+	tda10023_writereg (state, 0x05, qam_params[qam].lockthr);
+	tda10023_writereg (state, 0x08, qam_params[qam].mseth);
+	tda10023_writereg (state, 0x09, qam_params[qam].aref);
+	tda10023_writereg (state, 0xb4, qam_params[qam].agcrefnyq);
+	tda10023_writereg (state, 0xb6, qam_params[qam].eragnyq_thd);
 
 //	tda10023_writereg (state, 0x04, (p->inversion?0x12:0x32));
 //	tda10023_writebit (state, 0x04, 0x60, (p->inversion?0:0x20));
 	tda10023_writebit (state, 0x04, 0x40, 0x40);
-	tda10023_setup_reg0 (state, qamvals[qam][0]);
+	tda10023_setup_reg0 (state, qam_params[qam].qam);
 
 	return 0;
 }
-- 
1.7.8

