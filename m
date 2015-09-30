Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.2b3w.ch ([92.42.186.250]:60110 "EHLO mx1.2b3w.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679AbbI3Sfp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2015 14:35:45 -0400
From: Beat Bolli <dev@drbeat.li>
To: linux-media@vger.kernel.org
Cc: Beat Bolli <dev@drbeat.li>
Subject: [PATCH] Add initial scan file ch-quickline-ewaarberg
Date: Wed, 30 Sep 2015 20:26:16 +0200
Message-Id: <1443637576-5925-1-git-send-email-dev@drbeat.li>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Beat Bolli <dev@drbeat.li>
---
 dvb-c/ch-quickline-ewaarberg | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 dvb-c/ch-quickline-ewaarberg

diff --git a/dvb-c/ch-quickline-ewaarberg b/dvb-c/ch-quickline-ewaarberg
new file mode 100644
index 0000000..c516821
--- /dev/null
+++ b/dvb-c/ch-quickline-ewaarberg
@@ -0,0 +1,8 @@
+# Initial scan config for Swiss DVB-C provider Quickline in Aarberg (EWA)
+[CHANNEL]
+	DELIVERY_SYSTEM = DVBC/ANNEX_A
+	FREQUENCY = 306000000
+	SYMBOL_RATE = 6900000
+	INNER_FEC = NONE
+	MODULATION = QAM/256
+	INVERSION = AUTO
-- 
2.5.0.492.g918e48c
