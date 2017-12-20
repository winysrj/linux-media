Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58819 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754111AbdLTL1C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 06:27:02 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] Intelsat34-55.5W: update definitions from Vivo streaming
Date: Wed, 20 Dec 2017 09:26:52 -0200
Message-Id: <ef3c857a54279732639f0a71e6e64595e5ae3195.1513769154.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There were some frequency changes on this Satellite.
Update them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 dvb-s/Intelsat34-55.5W | 58 ++++++--------------------------------------------
 1 file changed, 7 insertions(+), 51 deletions(-)

diff --git a/dvb-s/Intelsat34-55.5W b/dvb-s/Intelsat34-55.5W
index 3b96fc894c99..28d57fbbf73e 100644
--- a/dvb-s/Intelsat34-55.5W
+++ b/dvb-s/Intelsat34-55.5W
@@ -2,28 +2,6 @@
 
 # TV channels
 
-[CHANNEL]
-	DELIVERY_SYSTEM = DVBS2
-	FREQUENCY = 11825000
-	POLARIZATION = HORIZONTAL
-	SYMBOL_RATE = 45000000
-	INNER_FEC = AUTO
-	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
-	STREAM_ID = 0
-	INVERSION = AUTO
-
-[CHANNEL]
-	DELIVERY_SYSTEM = DVBS2
-	FREQUENCY = 11825000
-	POLARIZATION = VERTICAL
-	SYMBOL_RATE = 45000000
-	INNER_FEC = AUTO
-	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
-	STREAM_ID = 0
-	INVERSION = AUTO
-
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBS2
 	FREQUENCY = 11890000
@@ -31,18 +9,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
-	STREAM_ID = 0
-	INVERSION = AUTO
-
-[CHANNEL]
-	DELIVERY_SYSTEM = DVBS2
-	FREQUENCY = 11905000
-	POLARIZATION = VERTICAL
-	SYMBOL_RATE = 45000000
-	INNER_FEC = AUTO
-	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
@@ -53,7 +20,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
@@ -64,7 +31,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
@@ -75,7 +42,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
@@ -86,7 +53,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
@@ -97,7 +64,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
@@ -108,18 +75,7 @@
 	SYMBOL_RATE = 30000000
 	INNER_FEC = AUTO
 	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
-	STREAM_ID = 0
-	INVERSION = AUTO
-
-[CHANNEL]
-	DELIVERY_SYSTEM = DVBS2
-	FREQUENCY = 12170000
-	POLARIZATION = HORIZONTAL
-	SYMBOL_RATE = 30000000
-	INNER_FEC = AUTO
-	ROLLOFF = AUTO
-	MODULATION = QAM/AUTO
+	MODULATION = PSK/8
 	STREAM_ID = 0
 	INVERSION = AUTO
 
-- 
2.14.3
