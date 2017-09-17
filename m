Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:58457 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751780AbdIQQtl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 12:49:41 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] scan-tables: add scan file for Shostka, Ukraine
Date: Sun, 17 Sep 2017 19:52:48 +0300
Message-Id: <20170917165248.14641-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 dvb-t/ua-Shostka | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 dvb-t/ua-Shostka

diff --git a/dvb-t/ua-Shostka b/dvb-t/ua-Shostka
new file mode 100644
index 0000000..696a428
--- /dev/null
+++ b/dvb-t/ua-Shostka
@@ -0,0 +1,55 @@
+# Ukraine, Shostka
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 706000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_LP = NONE
+	HIERARCHY = NONE
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 498000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = AUTO
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
+	HIERARCHY = NONE
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = AUTO
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
+	HIERARCHY = NONE
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 778000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = AUTO
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
+	HIERARCHY = NONE
+	INVERSION = AUTO
+
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 786000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = AUTO
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/AUTO
+	TRANSMISSION_MODE = AUTO
+	GUARD_INTERVAL = AUTO
+	HIERARCHY = NONE
+	INVERSION = AUTO
-- 
2.10.2
