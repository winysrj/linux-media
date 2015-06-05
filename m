Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901AbbFEO2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Himangi Saraogi <himangi774@gmail.com>,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 08/11] [media] ir: Fix IR_MAX_DURATION enforcement
Date: Fri,  5 Jun 2015 11:27:41 -0300
Message-Id: <3de7135934d936e630a39a047bdf731a51713dd4.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't assume that IR_MAX_DURATION is a bitmask. It isn't.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c83292ad1b34..ec74244a3853 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -322,7 +322,7 @@ static u32 redrat3_us_to_len(u32 microsec)
 	u32 result;
 	u32 divisor;
 
-	microsec &= IR_MAX_DURATION;
+	microsec = (microsec > IR_MAX_DURATION) ? IR_MAX_DURATION : microsec;
 	divisor = (RR3_CLK_CONV_FACTOR / 1000);
 	result = (u32)(microsec * divisor) / 1000;
 
@@ -380,7 +380,8 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 		if (i == 0)
 			trailer = rawir.duration;
 		/* cap the value to IR_MAX_DURATION */
-		rawir.duration &= IR_MAX_DURATION;
+		rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
+				 IR_MAX_DURATION : rawir.duration;
 
 		dev_dbg(dev, "storing %s with duration %d (i: %d)\n",
 			rawir.pulse ? "pulse" : "space", rawir.duration, i);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index bf4a44272f0e..5a17cb88ff27 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -152,7 +152,8 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 				sz->signal_last.tv_usec);
 			rawir.duration -= sz->sum;
 			rawir.duration = US_TO_NS(rawir.duration);
-			rawir.duration &= IR_MAX_DURATION;
+			rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
+					 IR_MAX_DURATION : rawir.duration;
 		}
 		sz_push(sz, rawir);
 
@@ -165,7 +166,8 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 	rawir.duration += SZ_RESOLUTION / 2;
 	sz->sum += rawir.duration;
 	rawir.duration = US_TO_NS(rawir.duration);
-	rawir.duration &= IR_MAX_DURATION;
+	rawir.duration = (rawir.duration > IR_MAX_DURATION) ?
+			 IR_MAX_DURATION : rawir.duration;
 	sz_push(sz, rawir);
 }
 
-- 
2.4.2

