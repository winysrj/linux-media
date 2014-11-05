Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53561 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKEMDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 07:03:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/5] [media] cx24110: Simplify error handling at cx24110_set_fec()
Date: Wed,  5 Nov 2014 10:03:19 -0200
Message-Id: <a23547374215422017239af32094e1aacc5d435e.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

move the return to happen before the logic. This way, we can
avoid one extra identation.

This also fixes an identation issue on this function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 5a31b3f59306..7b510f2ae20f 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -177,10 +177,8 @@ static int cx24110_set_inversion (struct cx24110_state* state, fe_spectral_inver
 	return 0;
 }
 
-static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
+static int cx24110_set_fec(struct cx24110_state* state, fe_code_rate_t fec)
 {
-/* fixme (low): error handling */
-
 	static const int rate[FEC_AUTO] = {-1,    1,    2,    3,    5,    7, -1};
 	static const int g1[FEC_AUTO]   = {-1, 0x01, 0x02, 0x05, 0x15, 0x45, -1};
 	static const int g2[FEC_AUTO]   = {-1, 0x01, 0x03, 0x06, 0x1a, 0x7a, -1};
@@ -208,16 +206,16 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
 	} else {
 		cx24110_writereg(state, 0x37, cx24110_readreg(state, 0x37) | 0x20);
 		/* set AcqVitDis bit */
-		if (rate[fec] > 0) {
-			cx24110_writereg(state, 0x05, (cx24110_readreg(state, 0x05) & 0xf0) | rate[fec]);
-			/* set nominal Viterbi rate */
-			cx24110_writereg(state, 0x22, (cx24110_readreg(state, 0x22) & 0xf0) | rate[fec]);
-			/* set current Viterbi rate */
-			cx24110_writereg(state, 0x1a, g1[fec]);
-			cx24110_writereg(state, 0x1b, g2[fec]);
-			/* not sure if this is the right way: I always used AutoAcq mode */
-	   } else
-		   return -EINVAL;
+		if (rate[fec] < 0)
+			return -EINVAL;
+
+		cx24110_writereg(state, 0x05, (cx24110_readreg(state, 0x05) & 0xf0) | rate[fec]);
+		/* set nominal Viterbi rate */
+		cx24110_writereg(state, 0x22, (cx24110_readreg(state, 0x22) & 0xf0) | rate[fec]);
+		/* set current Viterbi rate */
+		cx24110_writereg(state, 0x1a, g1[fec]);
+		cx24110_writereg(state, 0x1b, g2[fec]);
+		/* not sure if this is the right way: I always used AutoAcq mode */
 	}
 	return 0;
 }
-- 
1.9.3

