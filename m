Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42168 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIXBk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 21:40:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] [media] tc90522: fix compilation on 32 bits
Date: Tue, 23 Sep 2014 22:40:02 -0300
Message-Id: <7503795adf7d327a41076e04a25c2cd47c99fac6.1411522795.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   drivers/built-in.o: In function `tc90522t_get_frontend':
>> tc90522.c:(.text+0x260b64c): undefined reference to `__divdi3'
>> tc90522.c:(.text+0x260b685): undefined reference to `__divdi3'
>> tc90522.c:(.text+0x260b6bb): undefined reference to `__divdi3'
>> tc90522.c:(.text+0x260b713): undefined reference to `__divdi3'
   drivers/built-in.o:tc90522.c:(.text+0x260bb64): more undefined references to `__divdi3' follow

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index cdd9808c322c..d9905fb52f84 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/math64.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
 #include "tc90522.h"
@@ -275,7 +276,7 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
 		/* cn = cnr << 3 */
 		p = int_sqrt(cndat << 16);
 		p4 = cndat * cndat;
-		cn = (-16346LL * p4 * p / 10) >> 35;
+		cn = div64_s64(-16346LL * p4 * p, 10) >> 35;
 		cn += (14341LL * p4) >> 21;
 		cn -= (50259LL * cndat * p) >> 23;
 		cn += (88977LL * cndat) >> 9;
@@ -434,13 +435,13 @@ static int tc90522t_get_frontend(struct dvb_frontend *fe)
 		p *= 10;
 
 		cn = 24772;
-		cn += ((43827LL * p) / 10) >> 24;
+		cn += div64_s64(43827LL * p, 10) >> 24;
 		tmp = p >> 8;
-		cn += ((3184LL * tmp * tmp) / 10) >> 32;
+		cn += div64_s64(3184LL * tmp * tmp, 10) >> 32;
 		tmp = p >> 13;
-		cn -= ((128LL * tmp * tmp * tmp) / 10) >> 33;
+		cn -= div64_s64(128LL * tmp * tmp * tmp, 10) >> 33;
 		tmp = p >> 18;
-		cn += ((192LL * tmp * tmp * tmp * tmp) / 1000) >> 24;
+		cn += div64_s64(192LL * tmp * tmp * tmp * tmp, 1000) >> 24;
 
 		stats->stat[0].svalue = cn >> 3;
 		stats->stat[0].scale = FE_SCALE_DECIBEL;
-- 
1.9.3

