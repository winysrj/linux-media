Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53564 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaKEMDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 07:03:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/5] [media] cx24110: Fix whitespaces at cx24110_set_fec()
Date: Wed,  5 Nov 2014 10:03:17 -0200
Message-Id: <5eb2829212890d2db9883562310b916cc86d72ac.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is hard to read what's there, because it doesn't follow the
CodingStyle.

Add missing whitespaces to split function arguments.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index e78e7893e8aa..4f5c992afe67 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -192,28 +192,29 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
 	if (fec > FEC_AUTO)
 		fec = FEC_AUTO;
 
-	if (fec==FEC_AUTO) { /* (re-)establish AutoAcq behaviour */
-		cx24110_writereg(state,0x37,cx24110_readreg(state,0x37)&0xdf);
+	if (fec == FEC_AUTO) { /* (re-)establish AutoAcq behaviour */
+		cx24110_writereg(state, 0x37, cx24110_readreg(state, 0x37) & 0xdf);
 		/* clear AcqVitDis bit */
-		cx24110_writereg(state,0x18,0xae);
+		cx24110_writereg(state, 0x18, 0xae);
 		/* allow all DVB standard code rates */
-		cx24110_writereg(state,0x05,(cx24110_readreg(state,0x05)&0xf0)|0x3);
+		cx24110_writereg(state, 0x05, (cx24110_readreg(state, 0x05) & 0xf0) | 0x3);
 		/* set nominal Viterbi rate 3/4 */
-		cx24110_writereg(state,0x22,(cx24110_readreg(state,0x22)&0xf0)|0x3);
+		cx24110_writereg(state, 0x22, (cx24110_readreg(state, 0x22) & 0xf0) | 0x3);
 		/* set current Viterbi rate 3/4 */
-		cx24110_writereg(state,0x1a,0x05); cx24110_writereg(state,0x1b,0x06);
+		cx24110_writereg(state, 0x1a, 0x05);
+		cx24110_writereg(state, 0x1b, 0x06);
 		/* set the puncture registers for code rate 3/4 */
 		return 0;
 	} else {
-		cx24110_writereg(state,0x37,cx24110_readreg(state,0x37)|0x20);
+		cx24110_writereg(state, 0x37, cx24110_readreg(state, 0x37) | 0x20);
 		/* set AcqVitDis bit */
-		if(rate[fec]>0) {
-			cx24110_writereg(state,0x05,(cx24110_readreg(state,0x05)&0xf0)|rate[fec]);
+		if (rate[fec] > 0) {
+			cx24110_writereg(state, 0x05, (cx24110_readreg(state, 0x05) & 0xf0) | rate[fec]);
 			/* set nominal Viterbi rate */
-			cx24110_writereg(state,0x22,(cx24110_readreg(state,0x22)&0xf0)|rate[fec]);
+			cx24110_writereg(state, 0x22, (cx24110_readreg(state, 0x22) & 0xf0) | rate[fec]);
 			/* set current Viterbi rate */
-			cx24110_writereg(state,0x1a,g1[fec]);
-			cx24110_writereg(state,0x1b,g2[fec]);
+			cx24110_writereg(state, 0x1a, g1[fec]);
+			cx24110_writereg(state, 0x1b, g2[fec]);
 			/* not sure if this is the right way: I always used AutoAcq mode */
 	   } else
 		   return -EOPNOTSUPP;
-- 
1.9.3

