Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:40867 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaJSI0A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Oct 2014 04:26:00 -0400
Received: by mail-la0-f49.google.com with SMTP id q1so2532354lam.36
        for <linux-media@vger.kernel.org>; Sun, 19 Oct 2014 01:25:58 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] dtv-scan-tables: fix the DNA muxes in Finland to DVB-T2
Date: Sun, 19 Oct 2014 11:25:28 +0300
Message-Id: <1413707128-19995-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1413707128-19995-1-git-send-email-olli.salonen@iki.fi>
References: <1413707128-19995-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All of the DNA muxes in Finland are DVB-T2, not DVB-T.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 dvb-t/fi-DNA-Espoo        | 6 +++---
 dvb-t/fi-DNA-Eurajoki     | 6 +++---
 dvb-t/fi-DNA-Hameenlinna  | 6 +++---
 dvb-t/fi-DNA-Hamina       | 6 +++---
 dvb-t/fi-DNA-Hausjarvi    | 6 +++---
 dvb-t/fi-DNA-Helsinki     | 6 +++---
 dvb-t/fi-DNA-Jokioinen    | 6 +++---
 dvb-t/fi-DNA-Jyvaskyla    | 6 +++---
 dvb-t/fi-DNA-Kaarina      | 6 +++---
 dvb-t/fi-DNA-Kajaani      | 6 +++---
 dvb-t/fi-DNA-Kangasala    | 6 +++---
 dvb-t/fi-DNA-Karkkila     | 6 +++---
 dvb-t/fi-DNA-Kiiminki     | 6 +++---
 dvb-t/fi-DNA-Kokkola      | 6 +++---
 dvb-t/fi-DNA-Kontiolahti  | 6 +++---
 dvb-t/fi-DNA-Kouvola      | 6 +++---
 dvb-t/fi-DNA-Kuopio       | 6 +++---
 dvb-t/fi-DNA-Lahti        | 6 +++---
 dvb-t/fi-DNA-Lappeenranta | 6 +++---
 dvb-t/fi-DNA-Lohja        | 6 +++---
 dvb-t/fi-DNA-Loviisa      | 6 +++---
 dvb-t/fi-DNA-Mikkeli      | 6 +++---
 dvb-t/fi-DNA-Nousiainen   | 6 +++---
 dvb-t/fi-DNA-Nurmijarvi   | 6 +++---
 dvb-t/fi-DNA-Porvoo       | 6 +++---
 dvb-t/fi-DNA-Salo         | 6 +++---
 dvb-t/fi-DNA-Savonlinna   | 6 +++---
 dvb-t/fi-DNA-Seinajoki    | 6 +++---
 dvb-t/fi-DNA-Tyrnava      | 6 +++---
 dvb-t/fi-DNA-Ulvila       | 6 +++---
 dvb-t/fi-DNA-Vaasa        | 6 +++---
 dvb-t/fi-DNA-Valkeakoski  | 6 +++---
 dvb-t/fi-DNA-Vesilahti    | 6 +++---
 dvb-t/fi-DNA-Ylivieska    | 6 +++---
 34 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/dvb-t/fi-DNA-Espoo b/dvb-t/fi-DNA-Espoo
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Espoo
+++ b/dvb-t/fi-DNA-Espoo
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Eurajoki b/dvb-t/fi-DNA-Eurajoki
index 8466fd3..31de935 100644
--- a/dvb-t/fi-DNA-Eurajoki
+++ b/dvb-t/fi-DNA-Eurajoki
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Hameenlinna b/dvb-t/fi-DNA-Hameenlinna
index 12f5846..92b4ecf 100644
--- a/dvb-t/fi-DNA-Hameenlinna
+++ b/dvb-t/fi-DNA-Hameenlinna
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Hamina b/dvb-t/fi-DNA-Hamina
index 1098df5..3525cb0 100644
--- a/dvb-t/fi-DNA-Hamina
+++ b/dvb-t/fi-DNA-Hamina
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Hausjarvi b/dvb-t/fi-DNA-Hausjarvi
index 12f5846..92b4ecf 100644
--- a/dvb-t/fi-DNA-Hausjarvi
+++ b/dvb-t/fi-DNA-Hausjarvi
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Helsinki b/dvb-t/fi-DNA-Helsinki
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Helsinki
+++ b/dvb-t/fi-DNA-Helsinki
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Jokioinen b/dvb-t/fi-DNA-Jokioinen
index 12f5846..92b4ecf 100644
--- a/dvb-t/fi-DNA-Jokioinen
+++ b/dvb-t/fi-DNA-Jokioinen
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Jyvaskyla b/dvb-t/fi-DNA-Jyvaskyla
index f390248..925c825 100644
--- a/dvb-t/fi-DNA-Jyvaskyla
+++ b/dvb-t/fi-DNA-Jyvaskyla
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kaarina b/dvb-t/fi-DNA-Kaarina
index 593b61c..85ca3bd 100644
--- a/dvb-t/fi-DNA-Kaarina
+++ b/dvb-t/fi-DNA-Kaarina
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kajaani b/dvb-t/fi-DNA-Kajaani
index 1098df5..3525cb0 100644
--- a/dvb-t/fi-DNA-Kajaani
+++ b/dvb-t/fi-DNA-Kajaani
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kangasala b/dvb-t/fi-DNA-Kangasala
index 99904cd..cb27de2 100644
--- a/dvb-t/fi-DNA-Kangasala
+++ b/dvb-t/fi-DNA-Kangasala
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Karkkila b/dvb-t/fi-DNA-Karkkila
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Karkkila
+++ b/dvb-t/fi-DNA-Karkkila
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kiiminki b/dvb-t/fi-DNA-Kiiminki
index f390248..925c825 100644
--- a/dvb-t/fi-DNA-Kiiminki
+++ b/dvb-t/fi-DNA-Kiiminki
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kokkola b/dvb-t/fi-DNA-Kokkola
index f390248..925c825 100644
--- a/dvb-t/fi-DNA-Kokkola
+++ b/dvb-t/fi-DNA-Kokkola
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kontiolahti b/dvb-t/fi-DNA-Kontiolahti
index 6f1beff..b7895d0 100644
--- a/dvb-t/fi-DNA-Kontiolahti
+++ b/dvb-t/fi-DNA-Kontiolahti
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kouvola b/dvb-t/fi-DNA-Kouvola
index 1098df5..3525cb0 100644
--- a/dvb-t/fi-DNA-Kouvola
+++ b/dvb-t/fi-DNA-Kouvola
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Kuopio b/dvb-t/fi-DNA-Kuopio
index f4f9b73..63be3ca 100644
--- a/dvb-t/fi-DNA-Kuopio
+++ b/dvb-t/fi-DNA-Kuopio
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Lahti b/dvb-t/fi-DNA-Lahti
index f839fc9..8147d50 100644
--- a/dvb-t/fi-DNA-Lahti
+++ b/dvb-t/fi-DNA-Lahti
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Lappeenranta b/dvb-t/fi-DNA-Lappeenranta
index 6f1beff..b7895d0 100644
--- a/dvb-t/fi-DNA-Lappeenranta
+++ b/dvb-t/fi-DNA-Lappeenranta
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Lohja b/dvb-t/fi-DNA-Lohja
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Lohja
+++ b/dvb-t/fi-DNA-Lohja
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Loviisa b/dvb-t/fi-DNA-Loviisa
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Loviisa
+++ b/dvb-t/fi-DNA-Loviisa
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Mikkeli b/dvb-t/fi-DNA-Mikkeli
index 6f1beff..b7895d0 100644
--- a/dvb-t/fi-DNA-Mikkeli
+++ b/dvb-t/fi-DNA-Mikkeli
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Nousiainen b/dvb-t/fi-DNA-Nousiainen
index 593b61c..85ca3bd 100644
--- a/dvb-t/fi-DNA-Nousiainen
+++ b/dvb-t/fi-DNA-Nousiainen
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Nurmijarvi b/dvb-t/fi-DNA-Nurmijarvi
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Nurmijarvi
+++ b/dvb-t/fi-DNA-Nurmijarvi
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Porvoo b/dvb-t/fi-DNA-Porvoo
index f29d2f5..7d74fc1 100644
--- a/dvb-t/fi-DNA-Porvoo
+++ b/dvb-t/fi-DNA-Porvoo
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Salo b/dvb-t/fi-DNA-Salo
index 593b61c..85ca3bd 100644
--- a/dvb-t/fi-DNA-Salo
+++ b/dvb-t/fi-DNA-Salo
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Savonlinna b/dvb-t/fi-DNA-Savonlinna
index d020070..7295413 100644
--- a/dvb-t/fi-DNA-Savonlinna
+++ b/dvb-t/fi-DNA-Savonlinna
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Seinajoki b/dvb-t/fi-DNA-Seinajoki
index b55a6aa..2f5d7e5 100644
--- a/dvb-t/fi-DNA-Seinajoki
+++ b/dvb-t/fi-DNA-Seinajoki
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Tyrnava b/dvb-t/fi-DNA-Tyrnava
index f390248..925c825 100644
--- a/dvb-t/fi-DNA-Tyrnava
+++ b/dvb-t/fi-DNA-Tyrnava
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Ulvila b/dvb-t/fi-DNA-Ulvila
index 8466fd3..31de935 100644
--- a/dvb-t/fi-DNA-Ulvila
+++ b/dvb-t/fi-DNA-Ulvila
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 184500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Vaasa b/dvb-t/fi-DNA-Vaasa
index b55a6aa..2f5d7e5 100644
--- a/dvb-t/fi-DNA-Vaasa
+++ b/dvb-t/fi-DNA-Vaasa
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 219500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Valkeakoski b/dvb-t/fi-DNA-Valkeakoski
index 99904cd..cb27de2 100644
--- a/dvb-t/fi-DNA-Valkeakoski
+++ b/dvb-t/fi-DNA-Valkeakoski
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Vesilahti b/dvb-t/fi-DNA-Vesilahti
index 99904cd..cb27de2 100644
--- a/dvb-t/fi-DNA-Vesilahti
+++ b/dvb-t/fi-DNA-Vesilahti
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 198500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 226500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 212500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
diff --git a/dvb-t/fi-DNA-Ylivieska b/dvb-t/fi-DNA-Ylivieska
index f839fc9..8147d50 100644
--- a/dvb-t/fi-DNA-Ylivieska
+++ b/dvb-t/fi-DNA-Ylivieska
@@ -1,7 +1,7 @@
 # 2014-03-08 Olli Salonen <olli.salonen@iki.fi>
 # generated from http://www.dna.fi/tuki-antenniverkon-nakyvyysalueet
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 191500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -13,7 +13,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 205500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
@@ -25,7 +25,7 @@
 	INVERSION = AUTO
 
 [CHANNEL]
-	DELIVERY_SYSTEM = DVBT
+	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 177500000
 	BANDWIDTH_HZ = 7000000
 	CODE_RATE_HP = AUTO
-- 
1.9.1

