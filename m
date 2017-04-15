Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:51192 "EHLO
        mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754729AbdDOSuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 14:50:54 -0400
Received: from mail-in-03-z2.arcor-online.net (mail-in-03-z2.arcor-online.net [151.189.8.15])
        by mx.arcor.de (Postfix) with ESMTP id 3w53Wd0pwdzGVks
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 20:50:53 +0200 (CEST)
Received: from mail-in-14.arcor-online.net (mail-in-14.arcor-online.net [151.189.21.54])
        by mail-in-03-z2.arcor-online.net (Postfix) with ESMTP id 1966B1F6ACB
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 20:50:53 +0200 (CEST)
Date: Sat, 15 Apr 2017 20:50:43 +0200
From: Reinhard Speyerer <rspmn@arcor.de>
To: linux-media@vger.kernel.org
Cc: rspmn@arcor.de
Subject: [PATCH] dtv-scan-tables: add new channels to dvb-t/de-Bayern
Message-ID: <20170415185042.GA1590@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several channels used at Bamberg and Hesselberg have been changed at the
start of 2017 to avoid potential interference with the new DVB-T2 service
started at the end of March. EinsPlus has been replaced with One in
October 2016.

Full details are available (in german) at http://dvb-t-bayern.de/ .

Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
diff --git a/dvb-t/de-Bayern b/dvb-t/de-Bayern
index 0d4182f..a71cbca 100644
--- a/dvb-t/de-Bayern
+++ b/dvb-t/de-Bayern
@@ -50,7 +50,7 @@
 	INVERSION = AUTO
 
                                             # CH28: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo
-[CH29: Das Erste, arte, Phoenix, EinsPlus]
+[CH29: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
 	BANDWIDTH_HZ = 8000000
@@ -62,7 +62,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[CH30: Das Erste, arte, Phoenix, EinsPlus]
+[CH30: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
 	BANDWIDTH_HZ = 8000000
@@ -74,6 +74,18 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
+[CH31: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 554000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = 2/3
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/16
+	TRANSMISSION_MODE = 8K
+	GUARD_INTERVAL = 1/4
+	HIERARCHY = NONE
+	INVERSION = AUTO
+
 [CH33: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
@@ -98,7 +110,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[CH36: Das Erste, arte, Phoenix, EinsPlus]
+[CH36: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 594000000
 	BANDWIDTH_HZ = 8000000
@@ -135,7 +147,19 @@
 	INVERSION = AUTO
 
                                             # CH40: Das Erste, arte, Phoenix, EinsPlus
-[CH42: Das Erste, arte, Phoenix, EinsPlus]
+[CH41: Das Erste, arte, Phoenix, One]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 634000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = 2/3
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/16
+	TRANSMISSION_MODE = 8K
+	GUARD_INTERVAL = 1/4
+	HIERARCHY = NONE
+	INVERSION = AUTO
+
+[CH42: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 642000000
 	BANDWIDTH_HZ = 8000000
@@ -160,7 +184,7 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
-[CH45: Das Erste, arte, Phoenix, EinsPlus]
+[CH45: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 666000000
 	BANDWIDTH_HZ = 8000000
@@ -198,7 +222,7 @@
 	INVERSION = AUTO
 
                                             # CH47: Das Erste, arte, Phoenix, EinsPlus
-[CH49: Das Erste, arte, Phoenix, EinsPlus]
+[CH49: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 698000000
 	BANDWIDTH_HZ = 8000000
@@ -223,7 +247,7 @@
 	INVERSION = AUTO
 
                                             # CH53: ZDF, 3sat, KiKa / ZDFneo, ZDFinfo
-[CH55: Das Erste, arte, Phoenix, EinsPlus]
+[CH55: Das Erste, arte, Phoenix, One]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
 	BANDWIDTH_HZ = 8000000
@@ -235,3 +259,15 @@
 	HIERARCHY = NONE
 	INVERSION = AUTO
 
+[CH58: Bayerisches Fernsehen, BR-alpha, MDR, hr]
+	DELIVERY_SYSTEM = DVBT
+	FREQUENCY = 770000000
+	BANDWIDTH_HZ = 8000000
+	CODE_RATE_HP = 2/3
+	CODE_RATE_LP = NONE
+	MODULATION = QAM/16
+	TRANSMISSION_MODE = 8K
+	GUARD_INTERVAL = 1/4
+	HIERARCHY = NONE
+	INVERSION = AUTO
+
