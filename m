Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53554 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaKEMDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 07:03:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/5] [media] cx24110: Fix a spatch warning
Date: Wed,  5 Nov 2014 10:03:16 -0200
Message-Id: <b8e64df00231a4c4d59b68d8eda9f8db1adc1ea4.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is actually a false positive:
	drivers/media/dvb-frontends/cx24110.c:210 cx24110_set_fec() error: buffer overflow 'rate' 7 <= 8

But fixing it is easy: just ensure that the table size will be
limited to FEC_AUTO.

While here, fix spacing on the affected lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 95b981cd7115..e78e7893e8aa 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -181,16 +181,16 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
 {
 /* fixme (low): error handling */
 
-	static const int rate[]={-1,1,2,3,5,7,-1};
-	static const int g1[]={-1,0x01,0x02,0x05,0x15,0x45,-1};
-	static const int g2[]={-1,0x01,0x03,0x06,0x1a,0x7a,-1};
+	static const int rate[FEC_AUTO] = {-1,    1,    2,    3,    5,    7, -1};
+	static const int g1[FEC_AUTO]   = {-1, 0x01, 0x02, 0x05, 0x15, 0x45, -1};
+	static const int g2[FEC_AUTO]   = {-1, 0x01, 0x03, 0x06, 0x1a, 0x7a, -1};
 
 	/* Well, the AutoAcq engine of the cx24106 and 24110 automatically
 	   searches all enabled viterbi rates, and can handle non-standard
 	   rates as well. */
 
-	if (fec>FEC_AUTO)
-		fec=FEC_AUTO;
+	if (fec > FEC_AUTO)
+		fec = FEC_AUTO;
 
 	if (fec==FEC_AUTO) { /* (re-)establish AutoAcq behaviour */
 		cx24110_writereg(state,0x37,cx24110_readreg(state,0x37)&0xdf);
-- 
1.9.3

