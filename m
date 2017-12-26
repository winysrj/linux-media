Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:45059 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdLZOzE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 09:55:04 -0500
Received: by mail-lf0-f66.google.com with SMTP id f13so39799609lff.12
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 06:55:04 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] dtv-scan-tables: update all Finnish Digita DVB-T2 transponders
Date: Tue, 26 Dec 2017 16:49:57 +0200
Message-Id: <1514299797-16552-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update Finnish frequencies for Digita.

---
 dvb-t/fi-Anjalankoski_Ruotila | 18 +++++++++---------
 dvb-t/fi-Enontekio_Kuttanen   |  7 +------
 dvb-t/fi-Espoo                | 11 +++--------
 dvb-t/fi-Eurajoki             | 20 ++++++++++----------
 dvb-t/fi-Fiskars              | 11 +++--------
 dvb-t/fi-Hyvinkaa             | 13 ++++---------
 dvb-t/fi-Joutseno             | 18 +++++++++---------
 dvb-t/fi-Jyvaskyla            | 17 ++++++-----------
 dvb-t/fi-Karkkila             | 17 ++++++-----------
 dvb-t/fi-Kruunupyy            | 20 ++++++++++----------
 dvb-t/fi-Kuopio               | 18 +++++++++---------
 dvb-t/fi-Lahti                | 11 +++--------
 dvb-t/fi-Lapua                | 18 +++++++++---------
 dvb-t/fi-Lohja                | 14 +++++---------
 dvb-t/fi-Oulu                 | 13 ++++---------
 dvb-t/fi-Tammela              | 21 +++++++++++----------
 dvb-t/fi-Tampere              | 12 ++++--------
 dvb-t/fi-Tampere_Pyynikki     | 18 +++++++++---------
 dvb-t/fi-Turku                | 11 +++--------
 dvb-t/fi-Vantaa_Hakunila      |  7 +------
 20 files changed, 119 insertions(+), 176 deletions(-)

diff --git a/dvb-t/fi-Anjalankoski_Ruotila b/dvb-t/fi-Anjalankoski_Ruotila
index 8ae1231..4d3ab83 100644
--- a/dvb-t/fi-Anjalankoski_Ruotila
+++ b/dvb-t/fi-Anjalankoski_Ruotila
@@ -1,27 +1,27 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Anjalankoski_Ruotila]
+[Anjalankoski-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
 	BANDWIDTH_HZ = 8000000
 
-[Anjalankoski_Ruotila]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 522000000
+[Anjalankoski-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 658000000
 	BANDWIDTH_HZ = 8000000
 
-[Anjalankoski_Ruotila]
+[Anjalankoski-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 730000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
-[Anjalankoski_Ruotila]
+[Anjalankoski-D]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 754000000
+	FREQUENCY = 618000000
 	BANDWIDTH_HZ = 8000000
 
-[Anjalankoski_Ruotila]
+[Anjalankoski-E]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
diff --git a/dvb-t/fi-Enontekio_Kuttanen b/dvb-t/fi-Enontekio_Kuttanen
index f9a6af8..a792d59 100644
--- a/dvb-t/fi-Enontekio_Kuttanen
+++ b/dvb-t/fi-Enontekio_Kuttanen
@@ -3,11 +3,6 @@
 
 [Enontekio_Kuttanen]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 730000000
-	BANDWIDTH_HZ = 8000000
-
-[Enontekio_Kuttanen]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 770000000
+	FREQUENCY = 522000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Espoo b/dvb-t/fi-Espoo
index 6fb0ff2..bc01a39 100644
--- a/dvb-t/fi-Espoo
+++ b/dvb-t/fi-Espoo
@@ -7,8 +7,8 @@
 	BANDWIDTH_HZ = 8000000
 
 [Espoo-B]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 658000000
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 650000000
 	BANDWIDTH_HZ = 8000000
 
 [Espoo-C]
@@ -21,12 +21,7 @@
 	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
-[Espoo-D]
-	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 650000000
-	BANDWIDTH_HZ = 8000000
-
-[Espoo-H]
+[Espoo-F]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 618000000
 	BANDWIDTH_HZ = 8000000
diff --git a/dvb-t/fi-Eurajoki b/dvb-t/fi-Eurajoki
index 1d090a5..2ccc418 100644
--- a/dvb-t/fi-Eurajoki
+++ b/dvb-t/fi-Eurajoki
@@ -1,28 +1,28 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Eurajoki]
+[Eurajoki-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
-[Eurajoki]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 666000000
+[Eurajoki-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 594000000
 	BANDWIDTH_HZ = 8000000
 
-[Eurajoki]
+[Eurajoki-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 722000000
+	FREQUENCY = 642000000
 	BANDWIDTH_HZ = 8000000
 
-[Eurajoki]
+[Eurajoki-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 746000000
+	FREQUENCY = 602000000
 	BANDWIDTH_HZ = 8000000
 
-[Eurajoki]
+[Eurajoki-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 594000000
+	FREQUENCY = 570000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Fiskars b/dvb-t/fi-Fiskars
index 2b6b791..5f8cacc 100644
--- a/dvb-t/fi-Fiskars
+++ b/dvb-t/fi-Fiskars
@@ -1,22 +1,17 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Fiskars]
+[Fiskars-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
 	BANDWIDTH_HZ = 8000000
 
-[Fiskars]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 498000000
-	BANDWIDTH_HZ = 8000000
-
-[Fiskars]
+[Fiskars-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
 	BANDWIDTH_HZ = 8000000
 
-[Fiskars]
+[Fiskars-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 490000000
 	BANDWIDTH_HZ = 8000000
diff --git a/dvb-t/fi-Hyvinkaa b/dvb-t/fi-Hyvinkaa
index e711b16..25b77d1 100644
--- a/dvb-t/fi-Hyvinkaa
+++ b/dvb-t/fi-Hyvinkaa
@@ -1,23 +1,18 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Hyvinkaa]
+[Hyvinkaa-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 538000000
 	BANDWIDTH_HZ = 8000000
 
-[Hyvinkaa]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 698000000
-	BANDWIDTH_HZ = 8000000
-
-[Hyvinkaa]
+[Hyvinkaa-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
 
-[Hyvinkaa]
+[Hyvinkaa-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 754000000
+	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Joutseno b/dvb-t/fi-Joutseno
index 80337fc..0bde1b7 100644
--- a/dvb-t/fi-Joutseno
+++ b/dvb-t/fi-Joutseno
@@ -1,28 +1,28 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Joutseno]
+[Joutseno-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
 	BANDWIDTH_HZ = 8000000
 
-[Joutseno]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 586000000
+[Joutseno-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 658000000
 	BANDWIDTH_HZ = 8000000
 
-[Joutseno]
+[Joutseno-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 762000000
+	FREQUENCY = 594000000
 	BANDWIDTH_HZ = 8000000
 
-[Joutseno]
+[Joutseno-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 562000000
 	BANDWIDTH_HZ = 8000000
 
-[Joutseno]
+[Joutseno-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 514000000
+	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Jyvaskyla b/dvb-t/fi-Jyvaskyla
index 02ced9e..287792e 100644
--- a/dvb-t/fi-Jyvaskyla
+++ b/dvb-t/fi-Jyvaskyla
@@ -7,27 +7,22 @@
 	BANDWIDTH_HZ = 8000000
 
 [Jyvaskyla-B]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 786000000
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 522000000
 	BANDWIDTH_HZ = 8000000
 
 [Jyvaskyla-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 746000000
+	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
 
 [Jyvaskyla-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 634000000
+	FREQUENCY = 482000000
 	BANDWIDTH_HZ = 8000000
 
-[Jyvaskyla-D]
+[Jyvaskyla-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 506000000
-	BANDWIDTH_HZ = 8000000
-
-[Jyvaskyla-H]
-	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 586000000
+	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Karkkila b/dvb-t/fi-Karkkila
index d598f47..7baeef4 100644
--- a/dvb-t/fi-Karkkila
+++ b/dvb-t/fi-Karkkila
@@ -1,23 +1,18 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Karkkila]
+[Karkkila-A]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 594000000
+	FREQUENCY = 666000000
 	BANDWIDTH_HZ = 8000000
 
-[Karkkila]
+[Karkkila-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 618000000
+	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
-[Karkkila]
+[Karkkila-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 762000000
-	BANDWIDTH_HZ = 8000000
-
-[Karkkila]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 698000000
+	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Kruunupyy b/dvb-t/fi-Kruunupyy
index 65d86c4..ef91e8d 100644
--- a/dvb-t/fi-Kruunupyy
+++ b/dvb-t/fi-Kruunupyy
@@ -1,28 +1,28 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Kruunupyy]
+[Kruunupyy-A]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 522000000
+	FREQUENCY = 546000000
 	BANDWIDTH_HZ = 8000000
 
-[Kruunupyy]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 482000000
+[Kruunupyy-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 626000000
 	BANDWIDTH_HZ = 8000000
 
-[Kruunupyy]
+[Kruunupyy-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
-[Kruunupyy]
+[Kruunupyy-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 658000000
+	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
 
-[Kruunupyy]
+[Kruunupyy-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 546000000
+	FREQUENCY = 506000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Kuopio b/dvb-t/fi-Kuopio
index eb39e5f..ae9d0f2 100644
--- a/dvb-t/fi-Kuopio
+++ b/dvb-t/fi-Kuopio
@@ -1,28 +1,28 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Kuopio]
+[Kuopio-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 498000000
 	BANDWIDTH_HZ = 8000000
 
-[Kuopio]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 594000000
+[Kuopio-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 562000000
 	BANDWIDTH_HZ = 8000000
 
-[Kuopio]
+[Kuopio-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 618000000
 	BANDWIDTH_HZ = 8000000
 
-[Kuopio]
+[Kuopio-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 722000000
+	FREQUENCY = 674000000
 	BANDWIDTH_HZ = 8000000
 
-[Kuopio]
+[Kuopio-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 674000000
+	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Lahti b/dvb-t/fi-Lahti
index ea4163c..19da8e7 100644
--- a/dvb-t/fi-Lahti
+++ b/dvb-t/fi-Lahti
@@ -7,8 +7,8 @@
 	BANDWIDTH_HZ = 8000000
 
 [Lahti-B]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 682000000
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 602000000
 	BANDWIDTH_HZ = 8000000
 
 [Lahti-C]
@@ -21,12 +21,7 @@
 	FREQUENCY = 690000000
 	BANDWIDTH_HZ = 8000000
 
-[Lahti-D]
-	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 602000000
-	BANDWIDTH_HZ = 8000000
-
-[Lahti-H]
+[Lahti-F]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 642000000
 	BANDWIDTH_HZ = 8000000
diff --git a/dvb-t/fi-Lapua b/dvb-t/fi-Lapua
index 9084440..cb982f1 100644
--- a/dvb-t/fi-Lapua
+++ b/dvb-t/fi-Lapua
@@ -1,28 +1,28 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Lapua]
+[Lapua-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
-[Lapua]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 602000000
+[Lapua-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 626000000
 	BANDWIDTH_HZ = 8000000
 
-[Lapua]
+[Lapua-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 746000000
+	FREQUENCY = 570000000
 	BANDWIDTH_HZ = 8000000
 
-[Lapua]
+[Lapua-E]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 690000000
 	BANDWIDTH_HZ = 8000000
 
-[Lapua]
+[Lapua-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 498000000
+	FREQUENCY = 506000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Lohja b/dvb-t/fi-Lohja
index d040f9b..7952ddf 100644
--- a/dvb-t/fi-Lohja
+++ b/dvb-t/fi-Lohja
@@ -1,23 +1,19 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Lohja]
+[Lohja-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 690000000
 	BANDWIDTH_HZ = 8000000
 
-[Lohja]
+[Lohja-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 746000000
+	FREQUENCY = 594000000
 	BANDWIDTH_HZ = 8000000
 
-[Lohja]
+[Lohja-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 754000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
-[Lohja]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 786000000
-	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Oulu b/dvb-t/fi-Oulu
index 0e3906a..0753c6c 100644
--- a/dvb-t/fi-Oulu
+++ b/dvb-t/fi-Oulu
@@ -7,13 +7,13 @@
 	BANDWIDTH_HZ = 8000000
 
 [Oulu-B]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 714000000
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 506000000
 	BANDWIDTH_HZ = 8000000
 
 [Oulu-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 738000000
+	FREQUENCY = 530000000
 	BANDWIDTH_HZ = 8000000
 
 [Oulu-E]
@@ -21,12 +21,7 @@
 	FREQUENCY = 602000000
 	BANDWIDTH_HZ = 8000000
 
-[Oulu-D]
-	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 498000000
-	BANDWIDTH_HZ = 8000000
-
-[Oulu-H]
+[Oulu-F]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 570000000
 	BANDWIDTH_HZ = 8000000
diff --git a/dvb-t/fi-Tammela b/dvb-t/fi-Tammela
index f537bef..8266610 100644
--- a/dvb-t/fi-Tammela
+++ b/dvb-t/fi-Tammela
@@ -1,28 +1,29 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Tammela]
+[Tammela-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 482000000
 	BANDWIDTH_HZ = 8000000
 
-[Tammela]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 522000000
+[Tammela-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 554000000
 	BANDWIDTH_HZ = 8000000
 
-[Tammela]
+[Tammela-C]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 706000000
+	FREQUENCY = 506000000
 	BANDWIDTH_HZ = 8000000
 
-[Tammela]
+[Tammela-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 650000000
+	FREQUENCY = 546000000
 	BANDWIDTH_HZ = 8000000
 
-[Tammela]
+[Tammela-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 546000000
+	FREQUENCY = 586000000
 	BANDWIDTH_HZ = 8000000
 
+
diff --git a/dvb-t/fi-Tampere b/dvb-t/fi-Tampere
index 33d40c4..35497e7 100644
--- a/dvb-t/fi-Tampere
+++ b/dvb-t/fi-Tampere
@@ -7,8 +7,8 @@
 	BANDWIDTH_HZ = 8000000
 
 [Tampere-B]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 490000000
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 650000000
 	BANDWIDTH_HZ = 8000000
 
 [Tampere-C]
@@ -21,13 +21,9 @@
 	FREQUENCY = 674000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere-D]
-	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 650000000
-	BANDWIDTH_HZ = 8000000
-
-[Tampere-H]
+[Tampere-F]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 498000000
 	BANDWIDTH_HZ = 8000000
 
+
diff --git a/dvb-t/fi-Tampere_Pyynikki b/dvb-t/fi-Tampere_Pyynikki
index 1da6662..ebd975f 100644
--- a/dvb-t/fi-Tampere_Pyynikki
+++ b/dvb-t/fi-Tampere_Pyynikki
@@ -1,28 +1,28 @@
 # 2014-04-18 Antti Palosaari <crope@iki.fi>
 # generated from http://www.digita.fi/kuluttajat/tv/nakyvyysalueet/kanavanumerot_ja_taajuudet
 
-[Tampere_Pyynikki]
+[Tampere_Pyynikki-A]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 626000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere_Pyynikki]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 514000000
+[Tampere_Pyynikki-B]
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 610000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere_Pyynikki]
+[Tampere_Pyynikki-C]
 	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 682000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere_Pyynikki]
+[Tampere_Pyynikki-E]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 610000000
+	FREQUENCY = 562000000
 	BANDWIDTH_HZ = 8000000
 
-[Tampere_Pyynikki]
+[Tampere_Pyynikki-F]
 	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 562000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
diff --git a/dvb-t/fi-Turku b/dvb-t/fi-Turku
index dd29eb5..413f6ca 100644
--- a/dvb-t/fi-Turku
+++ b/dvb-t/fi-Turku
@@ -7,8 +7,8 @@
 	BANDWIDTH_HZ = 8000000
 
 [Turku-B]
-	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 658000000
+	DELIVERY_SYSTEM = DVBT2
+	FREQUENCY = 594000000
 	BANDWIDTH_HZ = 8000000
 
 [Turku-C]
@@ -21,12 +21,7 @@
 	FREQUENCY = 634000000
 	BANDWIDTH_HZ = 8000000
 
-[Turku-D]
-	DELIVERY_SYSTEM = DVBT2
-	FREQUENCY = 594000000
-	BANDWIDTH_HZ = 8000000
-
-[Turku-H]
+[Turku-F]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 570000000
 	BANDWIDTH_HZ = 8000000
diff --git a/dvb-t/fi-Vantaa_Hakunila b/dvb-t/fi-Vantaa_Hakunila
index af493a1..4fceb86 100644
--- a/dvb-t/fi-Vantaa_Hakunila
+++ b/dvb-t/fi-Vantaa_Hakunila
@@ -8,16 +8,11 @@
 
 [Vantaa_Hakunila]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 658000000
-	BANDWIDTH_HZ = 8000000
-
-[Vantaa_Hakunila]
-	DELIVERY_SYSTEM = DVBT
 	FREQUENCY = 674000000
 	BANDWIDTH_HZ = 8000000
 
 [Vantaa_Hakunila]
 	DELIVERY_SYSTEM = DVBT
-	FREQUENCY = 730000000
+	FREQUENCY = 514000000
 	BANDWIDTH_HZ = 8000000
 
-- 
2.7.4
