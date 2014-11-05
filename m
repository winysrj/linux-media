Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaKEMDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 07:03:24 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/5] [media] cx23110: Fix return code for cx24110_set_fec()
Date: Wed,  5 Nov 2014 10:03:18 -0200
Message-Id: <6deaca2bc3224aa138c93447000677ba5731007e.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
In-Reply-To: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
References: <667c952e7191ffb0a2703c8e173b0d5f0231a764.1415188985.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a parameter is invalid, the right return code is
-EINVAL.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/cx24110.c b/drivers/media/dvb-frontends/cx24110.c
index 4f5c992afe67..5a31b3f59306 100644
--- a/drivers/media/dvb-frontends/cx24110.c
+++ b/drivers/media/dvb-frontends/cx24110.c
@@ -217,8 +217,7 @@ static int cx24110_set_fec (struct cx24110_state* state, fe_code_rate_t fec)
 			cx24110_writereg(state, 0x1b, g2[fec]);
 			/* not sure if this is the right way: I always used AutoAcq mode */
 	   } else
-		   return -EOPNOTSUPP;
-/* fixme (low): which is the correct return code? */
+		   return -EINVAL;
 	}
 	return 0;
 }
-- 
1.9.3

