Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep13.mx.upcmail.net ([62.179.121.33]:36046 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaLRX4I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 18:56:08 -0500
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: oliver@schinagl.nl, linux-media@vger.kernel.org
Cc: Brian Burch <brian@pingtoo.com>,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH] dtv-scan-tables: update dvb-t/au-Brisbane
Date: Thu, 18 Dec 2014 23:37:56 +0000
Message-Id: <1418945876-8949-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Brian Burch <brian@pingtoo.com>

Update dvb-t/au-Brisbane as per Brian Burch's bug report on Ubuntu
Launchpad:
https://bugs.launchpad.net/ubuntu/+source/dtv-scan-tables/+bug/1393280

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 dvb-t/au-Brisbane | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/dvb-t/au-Brisbane b/dvb-t/au-Brisbane
index 68bc1ac..a23cb9c 100644
--- a/dvb-t/au-Brisbane
+++ b/dvb-t/au-Brisbane
@@ -54,7 +54,7 @@
 # SBS
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 585625000
+	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = 2/3
 	CODE_RATE_LP = NONE
@@ -67,7 +67,7 @@
 # 31 Digital
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 599500000
+	FREQUENCY = 529500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = 2/3
 	CODE_RATE_LP = NONE
-- 
2.1.3

