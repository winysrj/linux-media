Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:59818 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaJSIZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Oct 2014 04:25:39 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so2455078lbv.21
        for <linux-media@vger.kernel.org>; Sun, 19 Oct 2014 01:25:37 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] dtv-scan-tables: add mux H to stations transmitting it in Finland
Date: Sun, 19 Oct 2014 11:25:27 +0300
Message-Id: <1413707128-19995-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new mux H is being broadcasted by Digita from 6 stations in Finland.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 dvb-t/fi-Espoo     | 15 ++++++++++-----
 dvb-t/fi-Jyvaskyla | 15 ++++++++++-----
 dvb-t/fi-Lahti     | 15 ++++++++++-----
 dvb-t/fi-Oulu      | 15 ++++++++++-----
 dvb-t/fi-Tampere   | 15 ++++++++++-----
 dvb-t/fi-Turku     | 15 ++++++++++-----
 6 files changed, 60 insertions(+), 30 deletions(-)

diff --git a/dvb-t/fi-Espoo b/dvb-t/fi-Espoo
index 03296ae..ceb906d 100644
--- a/dvb-t/fi-Espoo
+++ b/dvb-t/fi-Espoo
@@ -1,28 +1,33 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Espoo]
+[Espoo-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
 	BANDWIDTH_HZ = 8000000
 
-[Espoo]
+[Espoo-B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 658000000
 	BANDWIDTH_HZ = 8000000
 
-[Espoo]
+[Espoo-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
 	BANDWIDTH_HZ = 8000000
 
-[Espoo]
+[Espoo-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 730000000
 	BANDWIDTH_HZ = 8000000
 
-[Espoo]
+[Espoo-D]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 586000000
 	BANDWIDTH_HZ = 8000000
 
+[Espoo-H]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 514000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvb-t/fi-Jyvaskyla b/dvb-t/fi-Jyvaskyla
index 3e2c51f..02ced9e 100644
--- a/dvb-t/fi-Jyvaskyla
+++ b/dvb-t/fi-Jyvaskyla
@@ -1,28 +1,33 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Jyvaskyla]
+[Jyvaskyla-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 546000000
 	BANDWIDTH_HZ = 8000000
 
-[Jyvaskyla]
+[Jyvaskyla-B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 786000000
 	BANDWIDTH_HZ = 8000000
 
-[Jyvaskyla]
+[Jyvaskyla-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 746000000
 	BANDWIDTH_HZ = 8000000
 
-[Jyvaskyla]
+[Jyvaskyla-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
-[Jyvaskyla]
+[Jyvaskyla-D]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 506000000
 	BANDWIDTH_HZ = 8000000
 
+[Jyvaskyla-H]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 586000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvb-t/fi-Lahti b/dvb-t/fi-Lahti
index d4bf403..f4c89b8 100644
--- a/dvb-t/fi-Lahti
+++ b/dvb-t/fi-Lahti
@@ -1,28 +1,33 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Lahti]
+[Lahti-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 570000000
 	BANDWIDTH_HZ = 8000000
 
-[Lahti]
+[Lahti-B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
 	BANDWIDTH_HZ = 8000000
 
-[Lahti]
+[Lahti-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
 	BANDWIDTH_HZ = 8000000
 
-[Lahti]
+[Lahti-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
 	BANDWIDTH_HZ = 8000000
 
-[Lahti]
+[Lahti-D]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 626000000
 	BANDWIDTH_HZ = 8000000
 
+[Lahti-H]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 690000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvb-t/fi-Oulu b/dvb-t/fi-Oulu
index 6d10849..0e3906a 100644
--- a/dvb-t/fi-Oulu
+++ b/dvb-t/fi-Oulu
@@ -1,28 +1,33 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Oulu]
+[Oulu-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
-[Oulu]
+[Oulu-B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
 	BANDWIDTH_HZ = 8000000
 
-[Oulu]
+[Oulu-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
 	BANDWIDTH_HZ = 8000000
 
-[Oulu]
+[Oulu-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 602000000
 	BANDWIDTH_HZ = 8000000
 
-[Oulu]
+[Oulu-D]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 498000000
 	BANDWIDTH_HZ = 8000000
 
+[Oulu-H]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 570000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvb-t/fi-Tampere b/dvb-t/fi-Tampere
index 1440032..27cf3a7 100644
--- a/dvb-t/fi-Tampere
+++ b/dvb-t/fi-Tampere
@@ -1,28 +1,33 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Tampere]
+[Tampere-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 578000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere]
+[Tampere-B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere]
+[Tampere-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 770000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere]
+[Tampere-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 778000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere]
+[Tampere-D]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 642000000
 	BANDWIDTH_HZ = 8000000
 
+[Tampere-H]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 674000000
+	BANDWIDTH_HZ = 8000000
+
diff --git a/dvb-t/fi-Turku b/dvb-t/fi-Turku
index 281048d..e3907a6 100644
--- a/dvb-t/fi-Turku
+++ b/dvb-t/fi-Turku
@@ -1,28 +1,33 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Turku]
+[Turku-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 714000000
 	BANDWIDTH_HZ = 8000000
 
-[Turku]
+[Turku-B]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 738000000
 	BANDWIDTH_HZ = 8000000
 
-[Turku]
+[Turku-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 762000000
 	BANDWIDTH_HZ = 8000000
 
-[Turku]
+[Turku-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 786000000
 	BANDWIDTH_HZ = 8000000
 
-[Turku]
+[Turku-D]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 538000000
 	BANDWIDTH_HZ = 8000000
 
+[Turku-H]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 698000000
+	BANDWIDTH_HZ = 8000000
+
-- 
1.9.1

