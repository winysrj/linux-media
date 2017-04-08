Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:57376 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdDHGLz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Apr 2017 02:11:55 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH 2/2] Update dvb-t/ua-Kyiv with new transponders and corrections
Date: Sat,  8 Apr 2017 09:04:16 +0300
Message-Id: <20170408060416.7327-2-oleg@kaa.org.ua>
In-Reply-To: <20170408060416.7327-1-oleg@kaa.org.ua>
References: <20170408060416.7327-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 dvb-t/ua-Kyiv | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/dvb-t/ua-Kyiv b/dvb-t/ua-Kyiv
index 2e45d59..52dd12b 100644
--- a/dvb-t/ua-Kyiv
+++ b/dvb-t/ua-Kyiv
@@ -1,25 +1,25 @@
 # Ukraine, Kyiv
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 526000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
-	CODE_RATE_HP = 3/5
+	CODE_RATE_HP = AUTO
 	CODE_RATE_LP = NONE
-	MODULATION = QAM/256
-	TRANSMISSION_MODE = 32K
-	GUARD_INTERVAL = 1/16
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 538000000
+	FREQUENCY = 538167000
 	BANDWIDTH_HZ = 8000000
-	CODE_RATE_HP = 3/5
+	CODE_RATE_HP = 2/3
 	CODE_RATE_LP = NONE
 	MODULATION = QAM/256
 	TRANSMISSION_MODE = 32K
-	GUARD_INTERVAL = 1/16
+	GUARD_INTERVAL = 1/128
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
@@ -27,23 +27,36 @@
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 554000000
 	BANDWIDTH_HZ = 8000000
-	CODE_RATE_HP = 3/5
+	CODE_RATE_HP = AUTO
 	CODE_RATE_LP = NONE
-	MODULATION = QAM/256
-	TRANSMISSION_MODE = 32K
-	GUARD_INTERVAL = 1/16
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
 [CHANNEL]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634167000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_LP = NONE
+	HIERARCHY = NONE
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 650167000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_LP = NONE
+	HIERARCHY = NONE
+
+[CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 698000000
 	BANDWIDTH_HZ = 8000000
-	CODE_RATE_HP = 3/5
+	CODE_RATE_HP = AUTO
 	CODE_RATE_LP = NONE
-	MODULATION = QAM/256
-	TRANSMISSION_MODE = 32K
-	GUARD_INTERVAL = 1/16
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
 	HIERARCHY = NONE
 	INVERSION = AUTO
-
-- 
2.10.2
