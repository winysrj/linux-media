Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933886AbbFJP1x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 11:27:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] ts2020: fix compilation on i386
Date: Wed, 10 Jun 2015 12:27:25 -0300
Message-Id: <1433950045-4807-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/built-in.o: In function `ts2020_read_signal_strength':
ts2020.c:(.text+0x298ff94): undefined reference to `__divdi3'
ts2020.c:(.text+0x298ffd4): undefined reference to `__divdi3'
ts2020.c:(.text+0x298fffd): undefined reference to `__divdi3'
Makefile:921: recipe for target 'vmlinux' failed

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/ts2020.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 946d8e9502fd..f61b143a0052 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -22,6 +22,7 @@
 #include "dvb_frontend.h"
 #include "ts2020.h"
 #include <linux/regmap.h>
+#include <linux/math64.h>
 
 #define TS2020_XTAL_FREQ   27000 /* in kHz */
 #define FREQ_OFFSET_LOW_SYM_RATE 3000
@@ -483,13 +484,13 @@ static int ts2020_read_signal_strength(struct dvb_frontend *fe,
 		strength = 0;
 	else if (gain < -65000)
 		/* 0% - 60%: weak signal */
-		strength = 0 + (85000 + gain) * 3 / 1000;
+		strength = 0 + div64_s64((85000 + gain) * 3, 1000);
 	else if (gain < -45000)
 		/* 60% - 90%: normal signal */
-		strength = 60 + (65000 + gain) * 3 / 2000;
+		strength = 60 + div64_s64((65000 + gain) * 3, 2000);
 	else
 		/* 90% - 99%: strong signal */
-		strength = 90 + (45000 + gain) / 5000;
+		strength = 90 + div64_s64((45000 + gain), 5000);
 
 	*_signal_strength = strength * 65535 / 100;
 	return 0;
-- 
2.4.2

