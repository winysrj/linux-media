Return-path: <linux-media-owner@vger.kernel.org>
Received: from sypressi3.dnainternet.net ([83.102.40.158]:54592 "EHLO
        sypressi2.dnainternet.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752329AbdDHLOP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Apr 2017 07:14:15 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dvb-scan-tables: updated Digita frequencies for Finland
Date: Sat,  8 Apr 2017 14:08:00 +0300
Message-Id: <1491649680-13078-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In summer 2016 some DVB-T/DVB-T2 frequencies were changed by the broadcaster Digita. Here are some that have already changed.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 dvb-t/fi-Espoo              |  6 +++---
 dvb-t/fi-Fiskars            |  4 ++--
 dvb-t/fi-Kustavi_Viherlahti |  8 ++++----
 dvb-t/fi-Lahti              |  8 ++++----
 dvb-t/fi-Salo_Isokyla       |  6 +++---
 dvb-t/fi-Tampere            |  8 ++++----
 dvb-t/fi-Tampere_Pyynikki   |  6 +++---
 dvb-t/fi-Turku              | 12 ++++++------
 8 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/dvb-t/fi-Espoo b/dvb-t/fi-Espoo
index ceb906d..6fb0ff2 100644
--- a/dvb-t/fi-Espoo
+++ b/dvb-t/fi-Espoo
@@ -18,16 +18,16 @@
 
 [Espoo-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 730000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
 [Espoo-D]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 586000000
+	FREQUENCY = 650000000
 	BANDWIDTH_HZ = 8000000
 
 [Espoo-H]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 514000000
+	FREQUENCY = 618000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Fiskars b/dvb-t/fi-Fiskars
index 0f84bb7..2b6b791 100644
--- a/dvb-t/fi-Fiskars
+++ b/dvb-t/fi-Fiskars
@@ -8,7 +8,7 @@
 
 [Fiskars]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 658000000
+	FREQUENCY = 498000000
 	BANDWIDTH_HZ = 8000000
 
 [Fiskars]
@@ -18,6 +18,6 @@
 
 [Fiskars]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 770000000
+	FREQUENCY = 490000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Kustavi_Viherlahti b/dvb-t/fi-Kustavi_Viherlahti
index ecef74d..9840401 100644
--- a/dvb-t/fi-Kustavi_Viherlahti
+++ b/dvb-t/fi-Kustavi_Viherlahti
@@ -3,21 +3,21 @@
 
 [Kustavi_Viherlahti]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 714000000
+	FREQUENCY = 538000000
 	BANDWIDTH_HZ = 8000000
 
 [Kustavi_Viherlahti]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 738000000
+	FREQUENCY = 658000000
 	BANDWIDTH_HZ = 8000000
 
 [Kustavi_Viherlahti]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 762000000
+	FREQUENCY = 682000000
 	BANDWIDTH_HZ = 8000000
 
 [Kustavi_Viherlahti]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 786000000
+	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Lahti b/dvb-t/fi-Lahti
index f4c89b8..ea4163c 100644
--- a/dvb-t/fi-Lahti
+++ b/dvb-t/fi-Lahti
@@ -13,21 +13,21 @@
 
 [Lahti-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 762000000
+	FREQUENCY = 626000000
 	BANDWIDTH_HZ = 8000000
 
 [Lahti-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 714000000
+	FREQUENCY = 690000000
 	BANDWIDTH_HZ = 8000000
 
 [Lahti-D]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 626000000
+	FREQUENCY = 602000000
 	BANDWIDTH_HZ = 8000000
 
 [Lahti-H]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 690000000
+	FREQUENCY = 642000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Salo_Isokyla b/dvb-t/fi-Salo_Isokyla
index 42df3b4..0cf08b8 100644
--- a/dvb-t/fi-Salo_Isokyla
+++ b/dvb-t/fi-Salo_Isokyla
@@ -3,7 +3,7 @@
 
 [Salo_Isokyla]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 514000000
+	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
 [Salo_Isokyla]
@@ -13,11 +13,11 @@
 
 [Salo_Isokyla]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 682000000
+	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
 
 [Salo_Isokyla]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 570000000
+	FREQUENCY = 690000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Tampere b/dvb-t/fi-Tampere
index 27cf3a7..33d40c4 100644
--- a/dvb-t/fi-Tampere
+++ b/dvb-t/fi-Tampere
@@ -13,21 +13,21 @@
 
 [Tampere-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 770000000
+	FREQUENCY = 658000000
 	BANDWIDTH_HZ = 8000000
 
 [Tampere-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 778000000
+	FREQUENCY = 674000000
 	BANDWIDTH_HZ = 8000000
 
 [Tampere-D]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 642000000
+	FREQUENCY = 650000000
 	BANDWIDTH_HZ = 8000000
 
 [Tampere-H]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 674000000
+	FREQUENCY = 498000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Tampere_Pyynikki b/dvb-t/fi-Tampere_Pyynikki
index 03e8ecc..1da6662 100644
--- a/dvb-t/fi-Tampere_Pyynikki
+++ b/dvb-t/fi-Tampere_Pyynikki
@@ -8,7 +8,7 @@
 
 [Tampere_Pyynikki]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 658000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
 [Tampere_Pyynikki]
@@ -18,11 +18,11 @@
 
 [Tampere_Pyynikki]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 586000000
+	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
 [Tampere_Pyynikki]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 642000000
+	FREQUENCY = 562000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Turku b/dvb-t/fi-Turku
index e3907a6..dd29eb5 100644
--- a/dvb-t/fi-Turku
+++ b/dvb-t/fi-Turku
@@ -3,31 +3,31 @@
 
 [Turku-A]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 714000000
+	FREQUENCY = 538000000
 	BANDWIDTH_HZ = 8000000
 
 [Turku-B]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 738000000
+	FREQUENCY = 658000000
 	BANDWIDTH_HZ = 8000000
 
 [Turku-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 762000000
+	FREQUENCY = 682000000
 	BANDWIDTH_HZ = 8000000
 
 [Turku-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 786000000
+	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
 [Turku-D]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 538000000
+	FREQUENCY = 594000000
 	BANDWIDTH_HZ = 8000000
 
 [Turku-H]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 698000000
+	FREQUENCY = 570000000
 	BANDWIDTH_HZ = 8000000
 
-- 
2.7.4
